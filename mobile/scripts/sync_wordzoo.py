#!/usr/bin/env python3

"""
Sync WordZoo data and media to Supabase.

ZIP strategy:

Category
    ├── subcategory A
    ├── subcategory B
    ├── subcategory C
    └── ...

=> animals_001.zip
=> animals_002.zip
=> animals_003.zip

Rules:
- Maximum ZIP size: 48 MB
- Keep whole subcategory together whenever possible.
- If one subcategory > 48 MB, split it by entity.
- Every generated ZIP is a valid independent ZIP.
- Update data["zip_files"] automatically.
"""

import argparse
import json
import os
import shutil
import tempfile
import zipfile

from pathlib import Path
from typing import Dict, List


###############################################################################
# CONFIG
###############################################################################

MAX_ZIP_SIZE = 48 * 1024 * 1024

ASSETS_BUCKET = "assets"
DATA_BUCKET = "data"


###############################################################################
# PATH
###############################################################################

def normalize_path(path: str, wordzoo_dir: Path) -> str:

    if not path:
        return path

    if path.startswith("wordzoo/") or path.startswith("wordzoo\\"):
        return path.replace("\\", "/")

    try:

        p = Path(path)

        if p.is_absolute():

            rel = p.relative_to(wordzoo_dir)

            return str(rel).replace("\\", "/")

    except Exception:
        pass

    return path.replace("\\", "/")


###############################################################################
# NORMALIZE ENTITY
###############################################################################

def normalize_entity(
        entity: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(entity)

    if normalized.get("real_image"):

        normalized["real_image"] = normalize_path(
            normalized["real_image"],
            wordzoo_dir
        )

    if isinstance(normalized.get("audio"), dict):

        normalized["audio"] = {

            lang: normalize_path(
                path,
                wordzoo_dir
            )

            for lang, path
            in normalized["audio"].items()

        }

    if normalized.get("animal_sound"):

        normalized["animal_sound"] = normalize_path(
            normalized["animal_sound"],
            wordzoo_dir
        )

    if normalized.get("animation_image"):

        normalized["animation_image"] = normalize_path(
            normalized["animation_image"],
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

    normalized = dict(sub)

    for field in [
        "real_image",
        "icon",
        "background"
    ]:

        if normalized.get(field):

            normalized[field] = normalize_path(
                normalized[field],
                wordzoo_dir
            )

    if isinstance(normalized.get("audio"), dict):

        normalized["audio"] = {

            lang: normalize_path(
                path,
                wordzoo_dir
            )

            for lang, path
            in normalized["audio"].items()

        }

    if isinstance(normalized.get("entities"), list):

        normalized["entities"] = [

            normalize_entity(
                entity,
                wordzoo_dir
            )

            for entity in normalized["entities"]

        ]

    return normalized


###############################################################################
# NORMALIZE CATEGORY
###############################################################################

def normalize_category(
        category: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(category)

    for field in [
        "icon",
        "background",
        "real_image"
    ]:

        if normalized.get(field):

            normalized[field] = normalize_path(
                normalized[field],
                wordzoo_dir
            )

    if isinstance(normalized.get("audio"), dict):

        normalized["audio"] = {

            lang: normalize_path(
                path,
                wordzoo_dir
            )

            for lang, path
            in normalized["audio"].items()

        }

    if isinstance(normalized.get("subcategories"), list):

        normalized["subcategories"] = [

            normalize_subcategory(
                sub,
                wordzoo_dir
            )

            for sub
            in normalized["subcategories"]

        ]

    return normalized


###############################################################################
# NORMALIZE DATA
###############################################################################

def normalize_data(
        data: Dict,
        wordzoo_dir: Path
) -> Dict:

    normalized = dict(data)

    if isinstance(
            normalized.get("categories"),
            list
    ):

        normalized["categories"] = [

            normalize_category(
                category,
                wordzoo_dir
            )

            for category
            in normalized["categories"]

        ]

    return normalized


###############################################################################
# FILE SIZE
###############################################################################

def get_folder_size(folder: Path) -> int:

    total = 0

    for file in folder.rglob("*"):

        if file.is_file():

            total += file.stat().st_size

    return total


###############################################################################
# FILE LIST
###############################################################################

def get_files(folder: Path) -> List[Path]:

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

            arcname = file.relative_to(root)

            zipf.write(
                file,
                arcname
            )


###############################################################################
# TEST ZIP SIZE
###############################################################################

def estimate_zip_size(
        files: List[Path],
        root: Path,
        temp_dir: Path,
        test_name: str
) -> int:

    test_zip = temp_dir / test_name

    zip_files(
        files,
        root,
        test_zip
    )

    size = test_zip.stat().st_size

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
        f"    Creating {output_zip.name} "
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
        f"    [OK] {output_zip.name} "
        f"{size_mb:.2f} MB"
    )


###############################################################################
# BUILD CATEGORY ZIP
###############################################################################

def build_category_zips(
        category_folder: Path,
        category_id: str,
        temp_dir: Path
) -> List[Path]:

    print()
    print("=" * 60)
    print(f"Scanning category: {category_id}")
    print("=" * 60)

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
        f"Subcategories found: {len(subfolders)}"
    )

    parts = []

    current_files = []
    current_root = category_folder

    part_index = 1

    def flush():

        nonlocal current_files
        nonlocal part_index

        if not current_files:
            return

        zip_name = (
            f"{category_id}_"
            f"{part_index:03d}.zip"
        )

        zip_path = temp_dir / zip_name

        create_zip_part(
            current_files,
            current_root,
            zip_path
        )

        parts.append(zip_path)

        current_files = []

        part_index += 1

    ###########################################################################
    # SUBCATEGORY
    ###########################################################################

    for subfolder in subfolders:

        print(
            f"\n  Subcategory: {subfolder.name}"
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
        # Test entire subcategory
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
        # Current ZIP has content -> flush
        #######################################################################

        if current_files:

            flush()

        #######################################################################
        # Try subcategory alone
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
        # Subcategory itself too large
        #######################################################################

        print(
            "    Subcategory > 48 MB"
        )

        print(
            "    Splitting by entity/files..."
        )

        entity_groups = []

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
                # Flush previous
                ################################################################

                if current_files:

                    flush()

                ################################################################
                # Single entity > limit
                ################################################################

                if entity_size > MAX_ZIP_SIZE:

                    print(
                        f"      WARNING: "
                        f"{entity_dir.name} "
                        f"itself exceeds 48 MB"
                    )

                    ################################################################
                    # Last resort: individual files
                    ################################################################

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

                            entity_current = candidate

                        else:

                            flush()

                            current_files = list(
                                entity_current
                            )

                            flush()

                            entity_current = [
                                file
                            ]

                    if entity_current:

                        current_files = entity_current

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
    # Final
    ###########################################################################

    flush()

    print()
    print(
        f"Category {category_id}: "
        f"{len(parts)} ZIP file(s)"
    )

    return parts


###############################################################################
# UPLOAD ZIP
###############################################################################

def upload_zip(
        supabase,
        zip_file: Path
):

    with open(
            zip_file,
            "rb"
    ) as f:

        supabase.storage \
            .from_(ASSETS_BUCKET) \
            .upload(
                zip_file.name,
                f,
                file_options={
                    "content-type": "application/zip",
                    "upsert": "true"
                }
            )

    size_mb = (
        zip_file.stat().st_size
        / 1024
        / 1024
    )

    print(
        f"[OK] Uploaded "
        f"{zip_file.name} "
        f"({size_mb:.2f} MB)"
    )


###############################################################################
# CLEAR BUCKET
###############################################################################

def clear_bucket(
        supabase,
        bucket_name: str
):

    print(
        f"\nCleaning bucket "
        f"'{bucket_name}'..."
    )

    def delete_folder(prefix=""):

        items = supabase.storage \
            .from_(bucket_name) \
            .list(
                path=prefix
            )

        files = []

        for item in items:

            name = item["name"]

            full_path = (
                f"{prefix}/{name}"
                if prefix
                else name
            )

            if item.get("id") is None:

                delete_folder(
                    full_path
                )

            else:

                files.append(
                    full_path
                )

        if files:

            supabase.storage \
                .from_(bucket_name) \
                .remove(files)

            for file in files:

                print(
                    f"  [DELETE] {file}"
                )

    delete_folder()

    print(
        f"[OK] Bucket '{bucket_name}' cleaned."
    )


###############################################################################
# UPLOAD ALL CATEGORY ZIPS
###############################################################################

def upload_all_category_zip(
        wordzoo_dir: Path,
        data: Dict,
        version: str,
        supabase
):

    temp_dir = Path(
        tempfile.mkdtemp(
            prefix="wordzoo_zip_"
        )
    )

    data["zip_files"] = {}
    data["zip_files_version"] = {}

    try:

        for category in data["categories"]:

            category_id = category["id"]

            category_folder = (
                wordzoo_dir
                / category_id
            )

            if not category_folder.exists():

                print(
                    f"[WARNING] "
                    f"Category folder not found: "
                    f"{category_folder}"
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

                upload_zip(
                    supabase,
                    zip_path
                )

                zip_names.append(
                    zip_path.name
                )

            data["zip_files"][
                category_id
            ] = zip_names

            data["zip_files_version"][
                category_id
            ] = f"v{version}"

    finally:

        shutil.rmtree(
            temp_dir,
            ignore_errors=True
        )


###############################################################################
# UPLOAD DATA JSON
###############################################################################

def upload_data_json(
        supabase,
        data: Dict
):

    data_json = json.dumps(
        data,
        indent=2,
        ensure_ascii=False
    )

    filename = (
        f"data-v"
        f"{data['version']}.json"
    )

    supabase.storage \
        .from_(DATA_BUCKET) \
        .upload(
            filename,
            data_json.encode("utf-8"),
            file_options={
                "content-type":
                    "application/json",
                "upsert": "true"
            }
        )

    print(
        f"[OK] Uploaded {filename}"
    )


###############################################################################
# UPDATE VERSION
###############################################################################

def update_data_version(
        supabase,
        version: str
):

    supabase.table(
        "data_versions"
    ).upsert(
        {
            "version": version,
            "is_active": True
        }
    ).execute()

    print(
        f"[OK] Updated version {version}"
    )


###############################################################################
# SUPABASE
###############################################################################

def upload_to_supabase(
        wordzoo_dir: Path,
        data: Dict,
        supabase_url: str,
        supabase_key: str
):

    try:

        from supabase import (
            create_client,
            Client
        )

    except ImportError:

        print(
            "supabase-py not installed.\n"
            "Run:\n"
            "pip install supabase"
        )

        return False

    supabase: Client = create_client(
        supabase_url,
        supabase_key
    )

    try:

        #######################################################################
        # CLEAN
        #######################################################################

        print()
        print("=" * 60)
        print("Cleaning Storage")
        print("=" * 60)

        clear_bucket(
            supabase,
            ASSETS_BUCKET
        )

        clear_bucket(
            supabase,
            DATA_BUCKET
        )

        #######################################################################
        # ZIP + UPLOAD
        #######################################################################

        print()
        print("=" * 60)
        print("Creating and Uploading ZIP")
        print("=" * 60)

        upload_all_category_zip(
            wordzoo_dir,
            data,
            data["version"],
            supabase
        )

        #######################################################################
        # DATA JSON
        #######################################################################

        print()
        print("=" * 60)
        print("Uploading data.json")
        print("=" * 60)

        upload_data_json(
            supabase,
            data
        )

        #######################################################################
        # VERSION
        #######################################################################

        print()
        print("=" * 60)
        print("Updating Version")
        print("=" * 60)

        update_data_version(
            supabase,
            data["version"]
        )

        #######################################################################
        # DONE
        #######################################################################

        print()
        print("=" * 60)
        print("DONE")
        print("=" * 60)

        return True

    except Exception as e:

        print()
        print(
            f"[FAIL] {e}"
        )

        return False


###############################################################################
# MAIN
###############################################################################

def main():

    parser = argparse.ArgumentParser(
        description="Sync WordZoo data to Supabase"
    )

    parser.add_argument(
        "--wordzoo-dir",
        required=True
    )

    parser.add_argument(
        "--json-file",
        required=True
    )

    parser.add_argument(
        "--version",
        required=True
    )

    parser.add_argument(
        "--supabase-url",
        default=None
    )

    parser.add_argument(
        "--supabase-key",
        default=None
    )

    parser.add_argument(
        "--upload",
        action="store_true"
    )

    args = parser.parse_args()

    wordzoo_dir = Path(
        args.wordzoo_dir
    )

    json_file = Path(
        args.json_file
    )

    ###########################################################################
    # CHECK
    ###########################################################################

    if not wordzoo_dir.exists():

        print(
            f"WordZoo folder not found:\n"
            f"{wordzoo_dir}"
        )

        return 1

    if not json_file.exists():

        print(
            f"JSON file not found:\n"
            f"{json_file}"
        )

        return 1

    ###########################################################################
    # SUPABASE CONFIG
    ###########################################################################

    supabase_url = (
        args.supabase_url
        or os.getenv("SUPABASE_URL")
    )

    supabase_key = (
        args.supabase_key
        or os.getenv("SUPABASE_KEY")
    )

    if args.upload:

        if not supabase_url:

            print(
                "SUPABASE_URL missing"
            )

            return 1

        if not supabase_key:

            print(
                "SUPABASE_KEY missing"
            )

            return 1

    ###########################################################################
    # LOAD JSON
    ###########################################################################

    print(
        f"\nLoading {json_file}"
    )

    try:

        with open(
                json_file,
                "r",
                encoding="utf-8"
        ) as f:

            data = json.load(f)

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
    # NORMALIZE
    ###########################################################################

    print(
        "Normalizing paths..."
    )

    data = normalize_data(
        data,
        wordzoo_dir
    )

    data["version"] = args.version

    ###########################################################################
    # SUMMARY
    ###########################################################################

    print()
    print("=" * 60)
    print("Summary")
    print("=" * 60)

    print(
        f"Version    : "
        f"{data['version']}"
    )

    print(
        f"Categories : "
        f"{len(data['categories'])}"
    )

    total_entities = 0

    for category in data["categories"]:

        entity_count = sum(

            len(
                sub.get(
                    "entities",
                    []
                )
            )

            for sub
            in category["subcategories"]

        )

        total_entities += entity_count

        print(
            f"- {category['id']} "
            f"("
            f"{len(category['subcategories'])} "
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
    # DRY RUN
    ###########################################################################

    if not args.upload:

        print()
        print(
            "Dry run finished."
        )

        return 0

    ###########################################################################
    # UPLOAD
    ###########################################################################

    print()
    print(
        "Uploading..."
    )

    success = upload_to_supabase(
        wordzoo_dir,
        data,
        supabase_url,
        supabase_key
    )

    if success:

        #######################################################################
        # IMPORTANT:
        # Save the generated JSON locally too.
        #######################################################################

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

        print()
        print(
            "=" * 60
        )

        print(
            "Local JSON updated."
        )

        print(
            "Upload completed successfully."
        )

        print(
            "=" * 60
        )

        return 0

    print()
    print(
        "=" * 60
    )

    print(
        "Upload failed."
    )

    print(
        "=" * 60
    )

    return 1


###############################################################################
# ENTRY
###############################################################################

if __name__ == "__main__":

    raise SystemExit(
        main()
    )