#!/usr/bin/env python3

"""
Sync WordZoo data and media to Supabase.

Features:
- Normalize paths in JSON.
- Zip each category.
- Maximum ZIP size: 49 MB.
- Automatically split large categories into multiple independent ZIP files.
- Upload ZIP files to Supabase Storage/assets.
- Update data["zip_files"] automatically.
- Update data["zip_files_version"].
- Upload updated data JSON.
"""

import json
import os
import argparse
import tempfile
import shutil
import zipfile

from pathlib import Path
from typing import Dict, List


###############################################################################
# CONFIG
###############################################################################

# Supabase hard limit is 50 MB.
# Keep a safety margin.
MAX_ZIP_SIZE = 49 * 1024 * 1024


###############################################################################
# Normalize Path
###############################################################################

def normalize_path(
        path: str,
        wordzoo_dir: Path,
) -> str:

    if not path:
        return path

    if (
        path.startswith("wordzoo/")
        or
        path.startswith("wordzoo\\")
    ):
        return path.replace("\\", "/")

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
# Normalize Entity
###############################################################################

def normalize_entity(
        entity: Dict,
        wordzoo_dir: Path,
) -> Dict:

    normalized = dict(entity)

    if normalized.get("real_image"):

        normalized["real_image"] = normalize_path(
            normalized["real_image"],
            wordzoo_dir,
        )

    if isinstance(
        normalized.get("audio"),
        dict,
    ):

        normalized["audio"] = {

            lang: normalize_path(
                path,
                wordzoo_dir,
            )

            for lang, path
            in normalized["audio"].items()

        }

    if normalized.get("animal_sound"):

        normalized["animal_sound"] = normalize_path(
            normalized["animal_sound"],
            wordzoo_dir,
        )

    if normalized.get("animation_image"):

        normalized["animation_image"] = normalize_path(
            normalized["animation_image"],
            wordzoo_dir,
        )

    return normalized


###############################################################################
# Normalize SubCategory
###############################################################################

def normalize_subcategory(
        sub: Dict,
        wordzoo_dir: Path,
) -> Dict:

    normalized = dict(sub)

    if normalized.get("real_image"):

        normalized["real_image"] = normalize_path(
            normalized["real_image"],
            wordzoo_dir,
        )

    if normalized.get("icon"):

        normalized["icon"] = normalize_path(
            normalized["icon"],
            wordzoo_dir,
        )

    if normalized.get("background"):

        normalized["background"] = normalize_path(
            normalized["background"],
            wordzoo_dir,
        )

    if isinstance(
        normalized.get("audio"),
        dict,
    ):

        normalized["audio"] = {

            lang: normalize_path(
                path,
                wordzoo_dir,
            )

            for lang, path
            in normalized["audio"].items()

        }

    if isinstance(
        normalized.get("entities"),
        list,
    ):

        normalized["entities"] = [

            normalize_entity(
                e,
                wordzoo_dir,
            )

            for e
            in normalized["entities"]

        ]

    return normalized


###############################################################################
# Normalize Category
###############################################################################

def normalize_category(
        cat: Dict,
        wordzoo_dir: Path,
) -> Dict:

    normalized = dict(cat)

    if normalized.get("icon"):

        normalized["icon"] = normalize_path(
            normalized["icon"],
            wordzoo_dir,
        )

    if normalized.get("background"):

        normalized["background"] = normalize_path(
            normalized["background"],
            wordzoo_dir,
        )

    if normalized.get("real_image"):

        normalized["real_image"] = normalize_path(
            normalized["real_image"],
            wordzoo_dir,
        )

    if isinstance(
        normalized.get("audio"),
        dict,
    ):

        normalized["audio"] = {

            lang: normalize_path(
                path,
                wordzoo_dir,
            )

            for lang, path
            in normalized["audio"].items()

        }

    if isinstance(
        normalized.get("subcategories"),
        list,
    ):

        normalized["subcategories"] = [

            normalize_subcategory(
                s,
                wordzoo_dir,
            )

            for s
            in normalized["subcategories"]

        ]

    return normalized


###############################################################################
# Normalize Whole JSON
###############################################################################

def normalize_data(
        data: Dict,
        wordzoo_dir: Path,
) -> Dict:

    normalized = dict(data)

    if isinstance(
        normalized.get("categories"),
        list,
    ):

        normalized["categories"] = [

            normalize_category(
                c,
                wordzoo_dir,
            )

            for c
            in normalized["categories"]

        ]

    return normalized


###############################################################################
# ZIP FILE LIST
###############################################################################

def get_category_files(
        category_folder: Path,
) -> List[Path]:

    files = []

    for file in category_folder.rglob("*"):

        if file.is_file():

            files.append(file)

    # Stable ordering
    files.sort(
        key=lambda p: str(p).lower()
    )

    return files


###############################################################################
# Create ZIP
###############################################################################

def create_zip(
        category_folder: Path,
        files: List[Path],
        output_zip: Path,
):
    """
    Create one independent ZIP containing selected files.
    """

    with zipfile.ZipFile(
        output_zip,
        mode="w",
        compression=zipfile.ZIP_DEFLATED,
        compresslevel=9,
    ) as zipf:

        for file in files:

            arcname = file.relative_to(
                category_folder
            )

            zipf.write(
                file,
                arcname,
            )


###############################################################################
# Find groups that fit under 49 MB
###############################################################################

def split_category_files(
        category_folder: Path,
) -> List[List[Path]]:

    files = get_category_files(
        category_folder
    )

    if not files:
        return []

    groups = []

    current_group = []

    temp_dir = Path(
        tempfile.mkdtemp(
            prefix="wordzoo_zip_test_"
        )
    )

    try:

        group_index = 1

        for file in files:

            # ---------------------------------------------------------------
            # Test adding this file to current group
            # ---------------------------------------------------------------

            test_files = current_group + [file]

            test_zip = (
                temp_dir
                /
                f"test_{group_index}.zip"
            )

            if test_zip.exists():

                test_zip.unlink()

            create_zip(
                category_folder,
                test_files,
                test_zip,
            )

            size = test_zip.stat().st_size

            # ---------------------------------------------------------------
            # File itself is too large
            # ---------------------------------------------------------------

            if not current_group:

                if size > MAX_ZIP_SIZE:

                    raise RuntimeError(
                        "\n"
                        f"File cannot fit into a ZIP <= 49 MB:\n"
                        f"{file}\n"
                        f"ZIP size: "
                        f"{size / 1024 / 1024:.2f} MB\n"
                        "\n"
                        "This individual file must be "
                        "compressed/resized separately."
                    )

                current_group = [
                    file
                ]

                continue

            # ---------------------------------------------------------------
            # Still fits
            # ---------------------------------------------------------------

            if size <= MAX_ZIP_SIZE:

                current_group.append(
                    file
                )

                continue

            # ---------------------------------------------------------------
            # Does not fit -> close current group
            # ---------------------------------------------------------------

            groups.append(
                current_group
            )

            group_index += 1

            current_group = [
                file
            ]

        # Last group
        if current_group:

            groups.append(
                current_group
            )

    finally:

        shutil.rmtree(
            temp_dir,
            ignore_errors=True,
        )

    return groups


###############################################################################
# Create Category ZIPs
###############################################################################

def create_category_zips(
        category_folder: Path,
        category_id: str,
        temp_dir: Path,
) -> List[Path]:

    print(
        f"\nScanning category: "
        f"{category_id}"
    )

    groups = split_category_files(
        category_folder
    )

    if not groups:

        print(
            f"[WARNING] "
            f"No files found in {category_id}"
        )

        return []

    zip_paths = []

    total_parts = len(
        groups
    )

    print(
        f"  Files: "
        f"{sum(len(g) for g in groups):,}"
    )

    print(
        f"  ZIP parts: "
        f"{total_parts}"
    )

    for index, files in enumerate(
        groups,
        start=1,
    ):

        # ---------------------------------------------------------------
        # Single ZIP -> preserve old name
        # ---------------------------------------------------------------

        if total_parts == 1:

            zip_name = (
                f"{category_id}.zip"
            )

        else:

            zip_name = (
                f"{category_id}_"
                f"{index:03d}.zip"
            )

        zip_path = (
            temp_dir
            /
            zip_name
        )

        print(
            f"\n  Creating "
            f"{zip_name} ..."
        )

        create_zip(
            category_folder,
            files,
            zip_path,
        )

        size = zip_path.stat().st_size

        print(
            f"    Files: "
            f"{len(files):,}"
        )

        print(
            f"    Size: "
            f"{size / 1024 / 1024:.2f} MB"
        )

        # ---------------------------------------------------------------
        # Safety check
        # ---------------------------------------------------------------

        if size > MAX_ZIP_SIZE:

            raise RuntimeError(
                f"\n"
                f"[FAIL] {zip_name} is "
                f"{size / 1024 / 1024:.2f} MB "
                f"> 49 MB"
            )

        zip_paths.append(
            zip_path
        )

    return zip_paths


###############################################################################
# Upload ZIP
###############################################################################

def upload_zip(
        supabase,
        bucket_name: str,
        zip_file: Path,
):
    """
    Upload one ZIP to Supabase.
    """

    size = zip_file.stat().st_size

    if size > MAX_ZIP_SIZE:

        raise RuntimeError(
            f"{zip_file.name} exceeds "
            f"49 MB"
        )

    print(
        f"  Uploading "
        f"{zip_file.name} "
        f"({size / 1024 / 1024:.2f} MB)..."
    )

    with open(
        zip_file,
        "rb",
    ) as f:

        supabase.storage.from_(
            bucket_name
        ).upload(

            zip_file.name,

            f,

            file_options={
                "content-type":
                    "application/zip",
                "upsert":
                    "true",
            },

        )

    print(
        f"  [OK] Uploaded "
        f"{zip_file.name}"
    )


###############################################################################
# Delete all files in bucket
###############################################################################

def clear_bucket(
        supabase,
        bucket_name: str,
):

    print(
        f"\nCleaning bucket "
        f"'{bucket_name}' ..."
    )

    def _delete_folder(
            prefix: str = ""
    ):

        files = (
            supabase
            .storage
            .from_(bucket_name)
            .list(
                path=prefix
            )
        )

        file_paths = []

        for item in files:

            name = item["name"]

            if prefix:

                full_path = (
                    f"{prefix}/{name}"
                )

            else:

                full_path = name

            # Folder
            if item.get("id") is None:

                _delete_folder(
                    full_path
                )

            else:

                file_paths.append(
                    full_path
                )

        if file_paths:

            (
                supabase
                .storage
                .from_(bucket_name)
                .remove(
                    file_paths
                )
            )

            for path in file_paths:

                print(
                    f"  [DELETE] "
                    f"{path}"
                )

    _delete_folder()

    print(
        f"[OK] Bucket "
        f"'{bucket_name}' cleaned."
    )


###############################################################################
# Upload Category ZIP Files
###############################################################################

def upload_all_category_zip(
        wordzoo_dir: Path,
        data: Dict,
        version: str,
        supabase,
):

    temp_dir = Path(
        tempfile.mkdtemp(
            prefix="wordzoo_upload_"
        )
    )

    data["zip_files"] = {}
    data["zip_files_version"] = {}

    try:

        for category in data["categories"]:

            category_id = category["id"]

            category_folder = (
                wordzoo_dir
                /
                category_id
            )

            if not category_folder.exists():

                print(
                    f"[WARNING] "
                    f"Category folder not found: "
                    f"{category_folder}"
                )

                continue

            print()
            print(
                "=" * 60
            )

            print(
                f"Category: "
                f"{category_id}"
            )

            print(
                "=" * 60
            )

            # -----------------------------------------------------------
            # Create ZIP parts
            # -----------------------------------------------------------

            zip_paths = create_category_zips(
                category_folder=category_folder,
                category_id=category_id,
                temp_dir=temp_dir,
            )

            if not zip_paths:

                continue

            # -----------------------------------------------------------
            # Upload every part
            # -----------------------------------------------------------

            uploaded_files = []

            for zip_path in zip_paths:

                upload_zip(
                    supabase=supabase,
                    bucket_name="assets",
                    zip_file=zip_path,
                )

                uploaded_files.append(
                    zip_path.name
                )

            # -----------------------------------------------------------
            # Update JSON
            # -----------------------------------------------------------

            if len(uploaded_files) == 1:

                # Preserve old JSON format
                data["zip_files"][
                    category_id
                ] = uploaded_files[0]

            else:

                # Multiple ZIP files
                data["zip_files"][
                    category_id
                ] = uploaded_files

                print(
                    f"\n  [INFO] "
                    f"{category_id} split into "
                    f"{len(uploaded_files)} ZIP files:"
                )

                for name in uploaded_files:

                    print(
                        f"    - {name}"
                    )

            data["zip_files_version"][
                category_id
            ] = f"v{version}"

    finally:

        shutil.rmtree(
            temp_dir,
            ignore_errors=True,
        )


###############################################################################
# Upload data.json
###############################################################################

def upload_data_json(
        supabase,
        data: Dict,
):

    data_json = json.dumps(
        data,
        indent=2,
        ensure_ascii=False,
    )

    data_bytes = data_json.encode(
        "utf-8"
    )

    print(
        f"Uploading "
        f"data-v{data['version']}.json ..."
    )

    (
        supabase
        .storage
        .from_("data")
        .upload(

            f"data-v{data['version']}.json",

            data_bytes,

            file_options={
                "content-type":
                    "application/json",
                "upsert":
                    "true",
            },

        )
    )

    print(
        f"[OK] Uploaded "
        f"data-v{data['version']}.json"
    )


###############################################################################
# Update data_versions
###############################################################################

def update_data_version(
        supabase,
        version: str,
):

    (
        supabase
        .table("data_versions")
        .upsert(
            {
                "version":
                    version,
                "is_active":
                    True,
            }
        )
        .execute()
    )

    print(
        f"[OK] Updated version "
        f"{version}"
    )


###############################################################################
# Upload To Supabase
###############################################################################

def upload_to_supabase(
        wordzoo_dir: Path,
        data: Dict,
        supabase_url: str,
        supabase_key: str,
):

    try:

        from supabase import (
            create_client,
            Client,
        )

    except ImportError:

        print(
            "Error: supabase-py not installed.\n"
            "Install:\n"
            "pip install supabase"
        )

        return False

    supabase: Client = create_client(
        supabase_url,
        supabase_key,
    )

    try:

        # ===============================================================
        # Cleaning
        # ===============================================================

        print()
        print(
            "==================================================="
        )

        print(
            "Cleaning Storage"
        )

        print(
            "==================================================="
        )

        clear_bucket(
            supabase=supabase,
            bucket_name="assets",
        )

        clear_bucket(
            supabase=supabase,
            bucket_name="data",
        )

        # ===============================================================
        # ZIP
        # ===============================================================

        print()
        print(
            "==================================================="
        )

        print(
            "Upload Category ZIP"
        )

        print(
            "==================================================="
        )

        upload_all_category_zip(
            wordzoo_dir=wordzoo_dir,
            data=data,
            version=data["version"],
            supabase=supabase,
        )

        # ===============================================================
        # Upload data JSON
        # ===============================================================

        print()
        print(
            "==================================================="
        )

        print(
            "Upload data.json"
        )

        print(
            "==================================================="
        )

        upload_data_json(
            supabase=supabase,
            data=data,
        )

        # ===============================================================
        # Update version
        # ===============================================================

        print()
        print(
            "==================================================="
        )

        print(
            "Update data_versions"
        )

        print(
            "==================================================="
        )

        update_data_version(
            supabase=supabase,
            version=data["version"],
        )

        print()
        print(
            "==================================================="
        )

        print(
            "DONE"
        )

        print(
            "==================================================="
        )

        return True

    except Exception as e:

        print()
        print(
            f"[FAIL] {e}"
        )

        return False


###############################################################################
# Main
###############################################################################

def main():

    parser = argparse.ArgumentParser(
        description=(
            "Sync WordZoo data to Supabase"
        )
    )

    parser.add_argument(
        "--wordzoo-dir",
        required=True,
        help="Path to wordzoo folder",
    )

    parser.add_argument(
        "--json-file",
        required=True,
        help="Path to data JSON",
    )

    parser.add_argument(
        "--version",
        required=True,
        help="Data version, example: 1.0.2",
    )

    parser.add_argument(
        "--supabase-url",
        default=None,
    )

    parser.add_argument(
        "--supabase-key",
        default=None,
    )

    parser.add_argument(
        "--upload",
        action="store_true",
    )

    args = parser.parse_args()

    wordzoo_dir = Path(
        args.wordzoo_dir
    )

    json_file = Path(
        args.json_file
    )

    # ===============================================================
    # Validate
    # ===============================================================

    if not wordzoo_dir.exists():

        print(
            f"WordZoo folder not found:\n"
            f"{wordzoo_dir}"
        )

        return 1

    if not json_file.exists():

        print(
            f"Json file not found:\n"
            f"{json_file}"
        )

        return 1

    supabase_url = (
        args.supabase_url
        or
        os.getenv("SUPABASE_URL")
    )

    supabase_key = (
        args.supabase_key
        or
        os.getenv("SUPABASE_KEY")
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

    # ===============================================================
    # Load JSON
    # ===============================================================

    print()
    print(
        f"Loading {json_file}"
    )

    with open(
        json_file,
        "r",
        encoding="utf-8",
    ) as f:

        data = json.load(f)

    # ===============================================================
    # Normalize
    # ===============================================================

    print(
        "Normalizing paths..."
    )

    data = normalize_data(
        data,
        wordzoo_dir,
    )

    data["version"] = args.version

    # ===============================================================
    # Summary
    # ===============================================================

    print()
    print(
        "=============================="
    )

    print(
        "Summary"
    )

    print(
        "=============================="
    )

    print(
        f"Version : "
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
            in category[
                "subcategories"
            ]

        )

        total_entities += (
            entity_count
        )

        print(
            f"- {category['id']}"
            f" ("
            f"{len(category['subcategories'])}"
            f" subcategories, "
            f"{entity_count}"
            f" entities)"
        )

    print(
        f"\nTotal entities : "
        f"{total_entities}"
    )

    print()
    print(
        f"Maximum ZIP size: "
        f"{MAX_ZIP_SIZE / 1024 / 1024:.0f} MB"
    )

    # ===============================================================
    # Dry run
    # ===============================================================

    if not args.upload:

        print(
            "\nDry run finished."
        )

        return 0

    # ===============================================================
    # Upload
    # ===============================================================

    print(
        "\nUploading..."
    )

    success = upload_to_supabase(
        wordzoo_dir=wordzoo_dir,
        data=data,
        supabase_url=supabase_url,
        supabase_key=supabase_key,
    )

    if success:

        print()
        print(
            "==================================="
        )

        print(
            "Upload completed successfully."
        )

        print(
            "==================================="
        )

        return 0

    print()
    print(
        "==================================="
    )

    print(
        "Upload failed."
    )

    print(
        "==================================="
    )

    return 1


###############################################################################
# Entry
###############################################################################

if __name__ == "__main__":

    exit(
        main()
    )