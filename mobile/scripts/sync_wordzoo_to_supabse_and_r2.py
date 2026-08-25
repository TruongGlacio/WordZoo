#!/usr/bin/env python3

"""
WordZoo Sync Tool
=================

Architecture
------------

Cloudflare R2
    ├── ZIP media files
    └── data-vX.json

Supabase PostgreSQL
    └── data_versions

Supabase Storage is NOT used.

Before every upload:
    1. Clear all old files from R2
    2. Create category ZIP files
    3. Upload ZIP files to R2
    4. Upload data-vX.json to R2
    5. Update Supabase data_versions

Configuration
-------------

All configuration is stored in .env.

No command-line arguments are required.

Run:

    python sync_wordzoo.py

Dependencies:

    pip install supabase boto3 python-dotenv
"""

import json
import os
import shutil
import tempfile
import zipfile

from pathlib import Path
from typing import Dict, List

import boto3

from botocore.config import Config
from dotenv import load_dotenv


###############################################################################
# LOAD ENV
###############################################################################

load_dotenv()


###############################################################################
# CONFIG
###############################################################################

# ---------------------------------------------------------------------------
# Local project
# ---------------------------------------------------------------------------

WORDZOO_DIR = Path(
    os.getenv(
        "WORDZOO_DIR",
        r"D:\projects\Projects\flutter\ai_generater\WordZoo\mobile\scripts\wordzoo_generator\scripts\wordzoo"
    )
)

JSON_FILE = Path(
    os.getenv(
        "JSON_FILE",
        r"D:\projects\Projects\flutter\ai_generater\WordZoo\mobile\scripts\wordzoo_generator\scripts\data_version1_final.json"
    )
)

VERSION = os.getenv(
    "VERSION",
    "1.0.15"
)


# ---------------------------------------------------------------------------
# ZIP
# ---------------------------------------------------------------------------

MAX_ZIP_SIZE = 48 * 1024 * 1024


# ---------------------------------------------------------------------------
# Supabase
# ---------------------------------------------------------------------------

SUPABASE_URL = os.getenv(
    "SUPABASE_URL"
)

SUPABASE_KEY = os.getenv(
    "SUPABASE_KEY"
)


# ---------------------------------------------------------------------------
# Cloudflare R2
# ---------------------------------------------------------------------------

R2_ACCOUNT_ID = os.getenv(
    "R2_ACCOUNT_ID"
)

R2_ACCESS_KEY_ID = os.getenv(
    "R2_ACCESS_KEY_ID"
)

R2_SECRET_ACCESS_KEY = os.getenv(
    "R2_SECRET_ACCESS_KEY"
)

R2_BUCKET = os.getenv(
    "R2_BUCKET",
    "wordzoo"
)

R2_ENDPOINT = os.getenv(
    "R2_ENDPOINT"
)


###############################################################################
# VALIDATE CONFIG
###############################################################################

def validate_config():

    errors = []

    if not SUPABASE_URL:
        errors.append(
            "SUPABASE_URL is missing"
        )

    if not SUPABASE_KEY:
        errors.append(
            "SUPABASE_KEY is missing"
        )

    if not R2_ACCOUNT_ID:
        errors.append(
            "R2_ACCOUNT_ID is missing"
        )

    if not R2_ACCESS_KEY_ID:
        errors.append(
            "R2_ACCESS_KEY_ID is missing"
        )

    if not R2_SECRET_ACCESS_KEY:
        errors.append(
            "R2_SECRET_ACCESS_KEY is missing"
        )

    if not R2_ENDPOINT:
        errors.append(
            "R2_ENDPOINT is missing"
        )

    if errors:

        print()
        print("=" * 70)
        print("CONFIGURATION ERROR")
        print("=" * 70)

        for error in errors:
            print(
                f"[ERROR] {error}"
            )

        print()
        print(
            "Please check your .env file."
        )

        raise RuntimeError(
            "Invalid configuration"
        )


###############################################################################
# NORMALIZE PATH
###############################################################################

def normalize_path(
        path: str,
        wordzoo_dir: Path
) -> str:

    if not path:
        return path

    if (
        path.startswith("wordzoo/")
        or
        path.startswith("wordzoo\\")
    ):

        return path.replace(
            "\\",
            "/"
        )

    try:

        p = Path(path)

        if p.is_absolute():

            rel = p.relative_to(
                wordzoo_dir
            )

            return str(
                rel
            ).replace(
                "\\",
                "/"
            )

    except Exception:
        pass

    return path.replace(
        "\\",
        "/"
    )


###############################################################################
# NORMALIZE ENTITY
###############################################################################

def normalize_entity(
        entity: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(
        entity
    )

    if normalized.get(
        "real_image"
    ):

        normalized[
            "real_image"
        ] = normalize_path(
            normalized[
                "real_image"
            ],
            wordzoo_dir
        )

    if isinstance(
        normalized.get("audio"),
        dict
    ):

        normalized[
            "audio"
        ] = {

            lang: normalize_path(
                path,
                wordzoo_dir
            )

            for lang, path
            in normalized[
                "audio"
            ].items()

        }

    if normalized.get(
        "animal_sound"
    ):

        normalized[
            "animal_sound"
        ] = normalize_path(
            normalized[
                "animal_sound"
            ],
            wordzoo_dir
        )

    if normalized.get(
        "animation_image"
    ):

        normalized[
            "animation_image"
        ] = normalize_path(
            normalized[
                "animation_image"
            ],
            wordzoo_dir
        )

    return normalized


###############################################################################
# NORMALIZE SUBCATEGORY
###############################################################################

def normalize_subcategory(
        sub: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(
        sub
    )

    for field in [
        "real_image",
        "icon",
        "background"
    ]:

        if normalized.get(
            field
        ):

            normalized[
                field
            ] = normalize_path(
                normalized[
                    field
                ],
                wordzoo_dir
            )

    if isinstance(
        normalized.get("audio"),
        dict
    ):

        normalized[
            "audio"
        ] = {

            lang: normalize_path(
                path,
                wordzoo_dir
            )

            for lang, path
            in normalized[
                "audio"
            ].items()

        }

    if isinstance(
        normalized.get("entities"),
        list
    ):

        normalized[
            "entities"
        ] = [

            normalize_entity(
                entity,
                wordzoo_dir
            )

            for entity
            in normalized[
                "entities"
            ]

        ]

    return normalized


###############################################################################
# NORMALIZE CATEGORY
###############################################################################

def normalize_category(
        category: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(
        category
    )

    for field in [
        "icon",
        "background",
        "real_image"
    ]:

        if normalized.get(
            field
        ):

            normalized[
                field
            ] = normalize_path(
                normalized[
                    field
                ],
                wordzoo_dir
            )

    if isinstance(
        normalized.get("audio"),
        dict
    ):

        normalized[
            "audio"
        ] = {

            lang: normalize_path(
                path,
                wordzoo_dir
            )

            for lang, path
            in normalized[
                "audio"
            ].items()

        }

    if isinstance(
        normalized.get("subcategories"),
        list
    ):

        normalized[
            "subcategories"
        ] = [

            normalize_subcategory(
                sub,
                wordzoo_dir
            )

            for sub
            in normalized[
                "subcategories"
            ]

        ]

    return normalized


###############################################################################
# NORMALIZE DATA
###############################################################################

def normalize_data(
        data: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(
        data
    )

    if isinstance(
        normalized.get("categories"),
        list
    ):

        normalized[
            "categories"
        ] = [

            normalize_category(
                category,
                wordzoo_dir
            )

            for category
            in normalized[
                "categories"
            ]

        ]

    return normalized


###############################################################################
# FILE LIST
###############################################################################

def get_files(
        folder: Path
) -> List[Path]:

    return [

        file

        for file
        in folder.rglob("*")

        if file.is_file()

    ]


###############################################################################
# ZIP FILES
###############################################################################

def zip_files(
        files: List[Path],
        root: Path,
        output_zip: Path
):

    with zipfile.ZipFile(
        output_zip,
        "w",
        compression=zipfile.ZIP_DEFLATED,
        compresslevel=6
    ) as zipf:

        for file in files:

            arcname = file.relative_to(
                root
            )

            zipf.write(
                file,
                arcname
            )


###############################################################################
# ESTIMATE ZIP SIZE
###############################################################################

def estimate_zip_size(
        files: List[Path],
        root: Path,
        temp_dir: Path,
        test_name: str
) -> int:

    test_zip = (
        temp_dir
        / test_name
    )

    zip_files(
        files,
        root,
        test_zip
    )

    size = (
        test_zip.stat().st_size
    )

    test_zip.unlink(
        missing_ok=True
    )

    return size


###############################################################################
# CREATE ZIP PART
###############################################################################

def create_zip_part(
        files: List[Path],
        root: Path,
        output_zip: Path
):

    print(
        f"    Creating "
        f"{output_zip.name} "
        f"({len(files)} files)..."
    )

    zip_files(
        files,
        root,
        output_zip
    )

    size_mb = (
        output_zip.stat().st_size
        / 1024
        / 1024
    )

    print(
        f"    [OK] "
        f"{output_zip.name} "
        f"{size_mb:.2f} MB"
    )


###############################################################################
# BUILD CATEGORY ZIPS
###############################################################################

def build_category_zips(
        category_folder: Path,
        category_id: str,
        temp_dir: Path
) -> List[Path]:

    print()
    print("=" * 70)
    print(
        f"Scanning category: "
        f"{category_id}"
    )
    print("=" * 70)

    subfolders = [

        folder

        for folder
        in category_folder.iterdir()

        if folder.is_dir()

    ]

    subfolders.sort(
        key=lambda p: p.name.lower()
    )

    print(
        f"Subcategories found: "
        f"{len(subfolders)}"
    )

    parts = []

    current_files = []

    current_root = (
        category_folder
    )

    part_index = 1

    ###########################################################################
    # FLUSH
    ###########################################################################

    def flush():

        nonlocal current_files
        nonlocal part_index

        if not current_files:
            return

        zip_name = (
            f"{category_id}_"
            f"{part_index:03d}.zip"
        )

        zip_path = (
            temp_dir
            / zip_name
        )

        create_zip_part(
            current_files,
            current_root,
            zip_path
        )

        parts.append(
            zip_path
        )

        current_files = []

        part_index += 1

    ###########################################################################
    # SUBCATEGORIES
    ###########################################################################

    for subfolder in subfolders:

        print()
        print(
            f"  Subcategory: "
            f"{subfolder.name}"
        )

        sub_files = get_files(
            subfolder
        )

        if not sub_files:

            print(
                "    Empty - skip"
            )

            continue

        #######################################################################
        # Test with current ZIP
        #######################################################################

        candidate = (
            current_files
            + sub_files
        )

        candidate_size = estimate_zip_size(
            candidate,
            current_root,
            temp_dir,
            "__test.zip"
        )

        candidate_mb = (
            candidate_size
            / 1024
            / 1024
        )

        print(
            f"    Size with current ZIP: "
            f"{candidate_mb:.2f} MB"
        )

        #######################################################################
        # Fits
        #######################################################################

        if candidate_size <= MAX_ZIP_SIZE:

            current_files = candidate

            continue

        #######################################################################
        # Current ZIP contains files
        #######################################################################

        if current_files:

            flush()

        #######################################################################
        # Test subcategory alone
        #######################################################################

        sub_size = estimate_zip_size(
            sub_files,
            current_root,
            temp_dir,
            "__test_sub.zip"
        )

        sub_mb = (
            sub_size
            / 1024
            / 1024
        )

        print(
            f"    Subcategory size: "
            f"{sub_mb:.2f} MB"
        )

        #######################################################################
        # Entire subcategory fits
        #######################################################################

        if sub_size <= MAX_ZIP_SIZE:

            current_files = list(
                sub_files
            )

            continue

        #######################################################################
        # Subcategory > 48 MB
        #######################################################################

        print(
            "    Subcategory > 48 MB"
        )

        print(
            "    Splitting by entity..."
        )

        entity_dirs = [

            folder

            for folder
            in subfolder.iterdir()

            if folder.is_dir()

        ]

        entity_dirs.sort(
            key=lambda p: p.name.lower()
        )

        #######################################################################
        # Entity directories
        #######################################################################

        if entity_dirs:

            for entity_dir in entity_dirs:

                entity_files = get_files(
                    entity_dir
                )

                if not entity_files:
                    continue

                entity_size = estimate_zip_size(
                    entity_files,
                    current_root,
                    temp_dir,
                    "__test_entity.zip"
                )

                entity_mb = (
                    entity_size
                    / 1024
                    / 1024
                )

                print(
                    f"      Entity "
                    f"{entity_dir.name}: "
                    f"{entity_mb:.2f} MB"
                )

                candidate = (
                    current_files
                    + entity_files
                )

                candidate_size = estimate_zip_size(
                    candidate,
                    current_root,
                    temp_dir,
                    "__test_entity_group.zip"
                )

                ################################################################
                # Fits
                ################################################################

                if candidate_size <= MAX_ZIP_SIZE:

                    current_files = candidate

                    continue

                ################################################################
                # Flush
                ################################################################

                if current_files:

                    flush()

                ################################################################
                # Entity > limit
                ################################################################

                if entity_size > MAX_ZIP_SIZE:

                    print(
                        f"      WARNING: "
                        f"{entity_dir.name} "
                        f"itself exceeds "
                        f"48 MB"
                    )

                    print(
                        "      Splitting "
                        "entity by files..."
                    )

                    entity_current = []

                    for file in entity_files:

                        candidate = (
                            entity_current
                            + [file]
                        )

                        size = estimate_zip_size(
                            candidate,
                            current_root,
                            temp_dir,
                            "__test_file.zip"
                        )

                        if (
                            size <= MAX_ZIP_SIZE
                            or not entity_current
                        ):

                            entity_current = (
                                candidate
                            )

                        else:

                            current_files = (
                                entity_current
                            )

                            flush()

                            entity_current = [
                                file
                            ]

                    if entity_current:

                        current_files = (
                            entity_current
                        )

                else:

                    current_files = list(
                        entity_files
                    )

        #######################################################################
        # No entity directories
        #######################################################################

        else:

            print(
                "    No entity folders. "
                "Splitting files..."
            )

            for file in sub_files:

                candidate = (
                    current_files
                    + [file]
                )

                size = estimate_zip_size(
                    candidate,
                    current_root,
                    temp_dir,
                    "__test_file.zip"
                )

                if (
                    size <= MAX_ZIP_SIZE
                    or not current_files
                ):

                    current_files = candidate

                else:

                    flush()

                    current_files = [
                        file
                    ]

    ###########################################################################
    # FINAL FLUSH
    ###########################################################################

    flush()

    print()
    print(
        f"Category "
        f"{category_id}: "
        f"{len(parts)} ZIP file(s)"
    )

    return parts


###############################################################################
# CREATE R2 CLIENT
###############################################################################

def create_r2_client():

    print()
    print(
        "Initializing Cloudflare R2..."
    )

    client = boto3.client(
        "s3",

        endpoint_url=R2_ENDPOINT,

        aws_access_key_id=(
            R2_ACCESS_KEY_ID
        ),

        aws_secret_access_key=(
            R2_SECRET_ACCESS_KEY
        ),

        region_name="auto",

        config=Config(
            signature_version="s3v4"
        )
    )

    print(
        "[OK] R2 client initialized"
    )

    return client


###############################################################################
# LIST ALL R2 OBJECTS
###############################################################################

def list_r2_objects(
        r2_client
) -> List[str]:

    objects = []

    continuation_token = None

    while True:

        kwargs = {
            "Bucket": R2_BUCKET
        }

        if continuation_token:

            kwargs[
                "ContinuationToken"
            ] = continuation_token

        response = r2_client.list_objects_v2(
            **kwargs
        )

        for item in response.get(
            "Contents",
            []
        ):

            objects.append(
                item["Key"]
            )

        if not response.get(
            "IsTruncated",
            False
        ):

            break

        continuation_token = (
            response.get(
                "NextContinuationToken"
            )
        )

    return objects


###############################################################################
# CLEAR R2
###############################################################################

def clear_r2(
        r2_client
):

    print()
    print("=" * 70)
    print("Cleaning Cloudflare R2")
    print("=" * 70)

    objects = list_r2_objects(
        r2_client
    )

    if not objects:

        print(
            "[OK] R2 bucket is already empty."
        )

        return

    print(
        f"Found "
        f"{len(objects)} "
        f"object(s)."
    )

    ###########################################################################
    # Delete in batches of 1000
    ###########################################################################

    for start in range(
        0,
        len(objects),
        1000
    ):

        batch = objects[
            start:start + 1000
        ]

        r2_client.delete_objects(

            Bucket=R2_BUCKET,

            Delete={
                "Objects": [
                    {
                        "Key": key
                    }

                    for key in batch
                ]
            }
        )

        for key in batch:

            print(
                f"  [DELETE] {key}"
            )

    print()
    print(
        "[OK] R2 bucket cleaned."
    )


###############################################################################
# UPLOAD FILE TO R2
###############################################################################

def upload_file_to_r2(
        r2_client,
        file_path: Path,
        object_key: str,
        content_type: str
):

    file_size = (
        file_path.stat().st_size
    )

    size_mb = (
        file_size
        / 1024
        / 1024
    )

    print()
    print(
        f"Uploading "
        f"{file_path.name}"
    )

    print(
        f"  Size: "
        f"{size_mb:.2f} MB"
    )

    print(
        f"  R2 key: "
        f"{object_key}"
    )

    r2_client.upload_file(

        str(file_path),

        R2_BUCKET,

        object_key,

        ExtraArgs={
            "ContentType": content_type
        }
    )

    print(
        f"  [OK] "
        f"{object_key}"
    )


###############################################################################
# UPLOAD ZIP
###############################################################################

def upload_zip_to_r2(
        r2_client,
        zip_file: Path
):

    upload_file_to_r2(
        r2_client,
        zip_file,
        zip_file.name,
        "application/zip"
    )


###############################################################################
# UPLOAD DATA JSON
###############################################################################

def upload_data_json_to_r2(
        r2_client,
        data: Dict
):

    filename = (
        f"data-v"
        f"{data['version']}.json"
    )

    temp_file = (
        Path(
            tempfile.gettempdir()
        )
        / filename
    )

    data_json = json.dumps(
        data,
        indent=2,
        ensure_ascii=False
    )

    with open(
        temp_file,
        "w",
        encoding="utf-8"
    ) as f:

        f.write(
            data_json
        )

    try:

        upload_file_to_r2(
            r2_client,
            temp_file,
            filename,
            "application/json"
        )

    finally:

        temp_file.unlink(
            missing_ok=True
        )


###############################################################################
# UPLOAD ALL CATEGORY ZIPS
###############################################################################

def upload_all_category_zip(
        wordzoo_dir: Path,
        data: Dict,
        version: str,
        r2_client
):

    temp_dir = Path(
        tempfile.mkdtemp(
            prefix="wordzoo_zip_"
        )
    )

    data[
        "zip_files"
    ] = {}

    data[
        "zip_files_version"
    ] = {}

    try:

        for category in data[
            "categories"
        ]:

            category_id = (
                category["id"]
            )

            category_folder = (
                wordzoo_dir
                / category_id
            )

            if not category_folder.exists():

                print()
                print(
                    f"[WARNING] "
                    f"Category folder "
                    f"not found:"
                )

                print(
                    f"  {category_folder}"
                )

                continue

            parts = build_category_zips(

                category_folder,

                category_id,

                temp_dir
            )

            if not parts:

                continue

            zip_names = []

            for zip_path in parts:

                upload_zip_to_r2(
                    r2_client,
                    zip_path
                )

                zip_names.append(
                    zip_path.name
                )

            data[
                "zip_files"
            ][
                category_id
            ] = zip_names

            data[
                "zip_files_version"
            ][
                category_id
            ] = f"v{version}"

    finally:

        shutil.rmtree(
            temp_dir,
            ignore_errors=True
        )


###############################################################################
# UPDATE SUPABASE VERSION
###############################################################################

def update_data_version(
        supabase,
        version: str
):

    print()
    print(
        "Updating Supabase "
        "data_versions..."
    )

    supabase.table(
        "data_versions"
    ).upsert(
        {
            "version": version,
            "is_active": True
        }
    ).execute()

    print(
        f"[OK] Supabase version "
        f"updated to {version}"
    )


###############################################################################
# SUPABASE
###############################################################################

def create_supabase_client():

    try:

        from supabase import (
            create_client,
            Client
        )

    except ImportError:

        print()
        print(
            "[ERROR] supabase-py "
            "is not installed."
        )

        print()
        print(
            "Run:"
        )

        print(
            "pip install supabase"
        )

        raise

    client: Client = create_client(
        SUPABASE_URL,
        SUPABASE_KEY
    )

    print(
        "[OK] Supabase client initialized"
    )

    return client


###############################################################################
# UPLOAD EVERYTHING
###############################################################################

def upload_all(
        wordzoo_dir: Path,
        json_file: Path,
        data: Dict
):

    ###########################################################################
    # CLIENTS
    ###########################################################################

    supabase = (
        create_supabase_client()
    )

    r2_client = (
        create_r2_client()
    )

    ###########################################################################
    # CLEAR R2
    ###########################################################################

    clear_r2(
        r2_client
    )

    ###########################################################################
    # CREATE + UPLOAD ZIP
    ###########################################################################

    print()
    print("=" * 70)
    print(
        "Creating and Uploading "
        "Category ZIPs to R2"
    )
    print("=" * 70)

    upload_all_category_zip(
        wordzoo_dir,
        data,
        data["version"],
        r2_client
    )

    ###########################################################################
    # SAVE UPDATED JSON LOCALLY
    ###########################################################################

    print()
    print(
        "Updating local data.json..."
    )

    with open(
        json_file,
        "w",
        encoding="utf-8"
    ) as f:

        json.dump(
            data,
            f,
            ensure_ascii=False,
            indent=2
        )

    print(
        "[OK] Local data.json updated."
    )

    ###########################################################################
    # UPLOAD DATA JSON TO R2
    ###########################################################################

    print()
    print("=" * 70)
    print(
        "Uploading data.json to R2"
    )
    print("=" * 70)

    upload_data_json_to_r2(
        r2_client,
        data
    )

    ###########################################################################
    # UPDATE SUPABASE
    ###########################################################################

    print()
    print("=" * 70)
    print(
        "Updating Supabase DB"
    )
    print("=" * 70)

    update_data_version(
        supabase,
        data["version"]
    )

    ###########################################################################
    # DONE
    ###########################################################################

    print()
    print("=" * 70)
    print("SYNC COMPLETED SUCCESSFULLY")
    print("=" * 70)

    print()
    print(
        f"Version: {data['version']}"
    )

    print(
        f"R2 bucket: {R2_BUCKET}"
    )

    print()
    print(
        "R2 contains:"
    )

    print(
        "  - Category ZIP files"
    )

    print(
        f"  - data-v{data['version']}.json"
    )

    print()
    print(
        "Supabase contains:"
    )

    print(
        "  - data_versions"
    )

    print()


###############################################################################
# MAIN
###############################################################################

def main():

    print()
    print("=" * 70)
    print("WORDZOO SYNC")
    print("=" * 70)

    ###########################################################################
    # CONFIG
    ###########################################################################

    print()
    print(
        f"WordZoo directory : "
        f"{WORDZOO_DIR}"
    )

    print(
        f"JSON file         : "
        f"{JSON_FILE}"
    )

    print(
        f"Version           : "
        f"{VERSION}"
    )

    print(
        f"R2 bucket         : "
        f"{R2_BUCKET}"
    )

    ###########################################################################
    # VALIDATE
    ###########################################################################

    validate_config()

    if not WORDZOO_DIR.exists():

        print()
        print(
            f"[ERROR] "
            f"WordZoo folder not found:"
        )

        print(
            f"  {WORDZOO_DIR}"
        )

        return 1

    if not JSON_FILE.exists():

        print()
        print(
            f"[ERROR] "
            f"JSON file not found:"
        )

        print(
            f"  {JSON_FILE}"
        )

        return 1

    ###########################################################################
    # LOAD JSON
    ###########################################################################

    print()
    print(
        f"Loading "
        f"{JSON_FILE}"
    )

    try:

        with open(
            JSON_FILE,
            "r",
            encoding="utf-8"
        ) as f:

            data = json.load(
                f
            )

    except json.JSONDecodeError as e:

        print()
        print(
            "[ERROR] Invalid JSON"
        )

        print(
            f"Line: {e.lineno}"
        )

        print(
            f"Column: {e.colno}"
        )

        print(
            f"Message: {e.msg}"
        )

        return 1

    ###########################################################################
    # VALIDATE DATA
    ###########################################################################

    if not isinstance(
        data,
        dict
    ):

        print(
            "[ERROR] "
            "data.json root must be an object."
        )

        return 1

    if not isinstance(
        data.get("categories"),
        list
    ):

        print(
            "[ERROR] "
            "data.json does not contain "
            "categories."
        )

        return 1

    ###########################################################################
    # NORMALIZE
    ###########################################################################

    print()
    print(
        "Normalizing paths..."
    )

    data = normalize_data(
        data,
        WORDZOO_DIR
    )

    data[
        "version"
    ] = VERSION

    ###########################################################################
    # SUMMARY
    ###########################################################################

    print()
    print("=" * 70)
    print("Summary")
    print("=" * 70)

    print(
        f"Version    : "
        f"{data['version']}"
    )

    print(
        f"Categories : "
        f"{len(data['categories'])}"
    )

    total_entities = 0

    for category in data[
        "categories"
    ]:

        subcategories = (
            category.get(
                "subcategories",
                []
            )
        )

        entity_count = sum(

            len(
                sub.get(
                    "entities",
                    []
                )
            )

            for sub
            in subcategories

        )

        total_entities += (
            entity_count
        )

        print(
            f"- {category['id']} "
            f"("
            f"{len(subcategories)} "
            f"subcategories, "
            f"{entity_count} entities"
            f")"
        )

    print()
    print(
        f"Total entities: "
        f"{total_entities}"
    )

    ###########################################################################
    # UPLOAD
    ###########################################################################

    print()
    print("=" * 70)
    print("Starting upload...")
    print("=" * 70)

    try:

        upload_all(
            WORDZOO_DIR,
            JSON_FILE,
            data
        )

    except Exception as e:

        print()
        print("=" * 70)
        print("UPLOAD FAILED")
        print("=" * 70)

        print()
        print(
            f"[FAIL] {e}"
        )

        return 1

    return 0


###############################################################################
# ENTRY
###############################################################################

if __name__ == "__main__":

    raise SystemExit(
        main()
    )