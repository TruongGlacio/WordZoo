#!/usr/bin/env python3
"""
Sync data_version1_final.json and local wordzoo media to Supabase.

Changes:
- Zip each category folder.
- Upload only zip files to Storage/assets.
- Add zip_files and zip_files_version into data.json.
"""

import json
import os
import argparse
import mimetypes
import tempfile
import shutil
import zipfile

from pathlib import Path
from typing import Dict

###############################################################################
# Normalize Path
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
# Normalize Entity
###############################################################################

def normalize_entity(entity: Dict, wordzoo_dir: Path) -> Dict:
    normalized = dict(entity)

    if normalized.get("real_image"):
        normalized["real_image"] = normalize_path(
            normalized["real_image"],
            wordzoo_dir,
        )

    if isinstance(normalized.get("audio"), dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
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

def normalize_subcategory(sub: Dict, wordzoo_dir: Path) -> Dict:
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

    if isinstance(normalized.get("audio"), dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }

    if isinstance(normalized.get("entities"), list):
        normalized["entities"] = [
            normalize_entity(e, wordzoo_dir)
            for e in normalized["entities"]
        ]

    return normalized


###############################################################################
# Normalize Category
###############################################################################

def normalize_category(cat: Dict, wordzoo_dir: Path) -> Dict:
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

    if isinstance(normalized.get("audio"), dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }

    if isinstance(normalized.get("subcategories"), list):
        normalized["subcategories"] = [
            normalize_subcategory(s, wordzoo_dir)
            for s in normalized["subcategories"]
        ]

    return normalized


###############################################################################
# Normalize Whole JSON
###############################################################################

def normalize_data(data: Dict, wordzoo_dir: Path) -> Dict:
    normalized = dict(data)

    if isinstance(normalized.get("categories"), list):
        normalized["categories"] = [
            normalize_category(c, wordzoo_dir)
            for c in normalized["categories"]
        ]

    return normalized


###############################################################################
# ZIP Helpers
###############################################################################

def zip_category_folder(
        category_folder: Path,
        output_zip: Path,
):
    """
    Zip one category folder.

    Example

    animals/
        mammals/
        birds/
        LocalizedNames/

    -->

    animals.zip
    """

    with zipfile.ZipFile(
            output_zip,
            mode="w",
            compression=zipfile.ZIP_DEFLATED,
            compresslevel=9,
    ) as zipf:

        for file in category_folder.rglob("*"):

            if not file.is_file():
                continue

            arcname = file.relative_to(category_folder)

            zipf.write(file, arcname)


def upload_zip(
        supabase,
        bucket_name: str,
        zip_file: Path,
):
    """
    Upload one zip file to Supabase Storage.
    """

    with open(zip_file, "rb") as f:

        supabase.storage.from_(bucket_name).upload(
            zip_file.name,
            f,
            file_options={
                "content-type": "application/zip",
                "upsert": "true",
            },
        )

    print(f"[OK] Uploaded {zip_file.name}")
###############################################################################
# Delete all files in a bucket
###############################################################################

def clear_bucket(
        supabase,
        bucket_name: str,
):
    """
    Delete all files in a bucket (recursive).
    """

    print(f"\nCleaning bucket '{bucket_name}' ...")

    def _delete_folder(prefix: str = ""):

        files = supabase.storage.from_(bucket_name).list(
            path=prefix
        )

        file_paths = []

        for item in files:

            name = item["name"]

            if prefix:
                full_path = f"{prefix}/{name}"
            else:
                full_path = name

            # folder
            if item.get("id") is None:
                _delete_folder(full_path)
            else:
                file_paths.append(full_path)

        if file_paths:
            supabase.storage.from_(bucket_name).remove(file_paths)

            for path in file_paths:
                print(f"  [DELETE] {path}")

    _delete_folder()

    print(f"[OK] Bucket '{bucket_name}' cleaned.")
###############################################################################
# Upload Category ZIP Files
###############################################################################

def upload_all_category_zip(
        wordzoo_dir: Path,
        data: Dict,
        version: str,
        supabase,
):
    """
    Zip từng category rồi upload lên bucket assets.

    Sau khi upload thành công sẽ tự thêm:

    data["zip_files"]
    data["zip_files_version"]
    """

    temp_dir = Path(tempfile.mkdtemp())

    data["zip_files"] = {}
    data["zip_files_version"] = {}

    try:

        for category in data["categories"]:

            category_id = category["id"]

            category_folder = wordzoo_dir / category_id

            if not category_folder.exists():

                print(f"[WARNING] Category folder not found: {category_folder}")

                continue

            zip_name = f"{category_id}.zip"

            zip_path = temp_dir / zip_name

            print(f"\nCreating {zip_name} ...")

            zip_category_folder(
                category_folder,
                zip_path,
            )

            upload_zip(
                supabase=supabase,
                bucket_name="assets",
                zip_file=zip_path,
            )

            data["zip_files"][category_id] = zip_name

            data["zip_files_version"][category_id] = f"v{version}"

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

    supabase.storage.from_("data").upload(
        f"data-v{data['version']}.json",
        data_json.encode("utf-8"),
        file_options={
            "content-type": "application/json",
            "upsert": "true",
        },
    )

    print(f"[OK] Uploaded data-v{data['version']}.json")


###############################################################################
# Update data_versions table
###############################################################################

def update_data_version(
        supabase,
        version: str,
):

    supabase.table(
        "data_versions"
    ).upsert(
        {
            "version": version,
            "is_active": True,
        }
    ).execute()

    print(f"[OK] Updated version {version}")

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
        from supabase import create_client, Client

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
        print("\n===================================================")
        print("Cleaning Storage")
        print("===================================================")

        clear_bucket(
            supabase=supabase,
            bucket_name="assets",
        )

        clear_bucket(
            supabase=supabase,
            bucket_name="data",
        )
        print("\n===================================================")
        print("Upload Category ZIP")
        print("===================================================")

        upload_all_category_zip(
            wordzoo_dir=wordzoo_dir,
            data=data,
            version=data["version"],
            supabase=supabase,
        )

        print("\n===================================================")
        print("Upload data.json")
        print("===================================================")

        upload_data_json(
            supabase=supabase,
            data=data,
        )

        print("\n===================================================")
        print("Update data_versions")
        print("===================================================")

        update_data_version(
            supabase=supabase,
            version=data["version"],
        )

        print("\n===================================================")
        print("DONE")
        print("===================================================")

        return True

    except Exception as e:

        print(f"\n[FAIL] {e}")

        return False

###############################################################################
# Main
###############################################################################

def main():

    parser = argparse.ArgumentParser(
        description="Sync WordZoo data to Supabase"
    )

    parser.add_argument(
        "--wordzoo-dir",
        required=True,
        help="Path to wordzoo folder",
    )

    parser.add_argument(
        "--json-file",
        required=True,
        help="Path to data_version1_final.json",
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

    wordzoo_dir = Path(args.wordzoo_dir)
    json_file = Path(args.json_file)

    if not wordzoo_dir.exists():

        print(f"WordZoo folder not found:\n{wordzoo_dir}")

        return 1

    if not json_file.exists():

        print(f"Json file not found:\n{json_file}")

        return 1

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

            print("SUPABASE_URL missing")

            return 1

        if not supabase_key:

            print("SUPABASE_KEY missing")

            return 1

    print(f"\nLoading {json_file}")

    with open(
            json_file,
            "r",
            encoding="utf-8",
    ) as f:

        data = json.load(f)

    print("Normalizing paths...")

    data = normalize_data(
        data,
        wordzoo_dir,
    )

    data["version"] = args.version

    print(f"Version : {data['version']}")

    print("\n==============================")
    print("Summary")
    print("==============================")

    print(f"Version : {data['version']}")

    print(f"Categories : {len(data['categories'])}")

    total_entities = 0

    for category in data["categories"]:

        entity_count = sum(
            len(sub.get("entities", []))
            for sub in category["subcategories"]
        )

        total_entities += entity_count

        print(
            f"- {category['id']}"
            f" ({len(category['subcategories'])} subcategories,"
            f" {entity_count} entities)"
        )

    print(f"\nTotal entities : {total_entities}")

    if not args.upload:

        print("\nDry run finished.")

        return 0

    print("\nUploading...")

    success = upload_to_supabase(
        wordzoo_dir=wordzoo_dir,
        data=data,
        supabase_url=supabase_url,
        supabase_key=supabase_key,
    )

    if success:

        print("\n===================================")
        print("Upload completed successfully.")
        print("===================================")

        return 0

    print("\n===================================")
    print("Upload failed.")
    print("===================================")

    return 1


###############################################################################
# Entry
###############################################################################

if __name__ == "__main__":
    exit(main())