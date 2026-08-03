#!/usr/bin/env python3
"""
Sync data_version1_final.json and local wordzoo media to Supabase.

Usage:
    python sync_wordzoo.py --wordzoo-dir ./wordzoo --json-file ./data_version1_final.json --version 1.0.0 --upload
"""

import json
import os
import argparse
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional


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


def normalize_entity(entity: Dict, wordzoo_dir: Path) -> Dict:
    normalized = dict(entity)
    if "real_image" in normalized and normalized["real_image"]:
        normalized["real_image"] = normalize_path(normalized["real_image"], wordzoo_dir)
    if "audio" in normalized and isinstance(normalized["audio"], dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }
    if "animal_sound" in normalized and normalized["animal_sound"]:
        normalized["animal_sound"] = normalize_path(normalized["animal_sound"], wordzoo_dir)
    if "animation_image" in normalized and normalized["animation_image"]:
        normalized["animation_image"] = normalize_path(normalized["animation_image"], wordzoo_dir)
    return normalized


def normalize_subcategory(sub: Dict, wordzoo_dir: Path) -> Dict:
    normalized = dict(sub)
    if "real_image" in normalized and normalized["real_image"]:
        normalized["real_image"] = normalize_path(normalized["real_image"], wordzoo_dir)
    if "audio" in normalized and isinstance(normalized["audio"], dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }
    if "icon" in normalized and normalized["icon"]:
        normalized["icon"] = normalize_path(normalized["icon"], wordzoo_dir)
    if "background" in normalized and normalized["background"]:
        normalized["background"] = normalize_path(normalized["background"], wordzoo_dir)
    if "entities" in normalized and isinstance(normalized["entities"], list):
        normalized["entities"] = [normalize_entity(e, wordzoo_dir) for e in normalized["entities"]]
    return normalized


def normalize_category(cat: Dict, wordzoo_dir: Path) -> Dict:
    normalized = dict(cat)
    if "icon" in normalized and normalized["icon"]:
        normalized["icon"] = normalize_path(normalized["icon"], wordzoo_dir)
    if "background" in normalized and normalized["background"]:
        normalized["background"] = normalize_path(normalized["background"], wordzoo_dir)
    if "audio" in normalized and isinstance(normalized["audio"], dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }
    if "real_image" in normalized and normalized["real_image"]:
        normalized["real_image"] = normalize_path(normalized["real_image"], wordzoo_dir)
    if "subcategories" in normalized and isinstance(normalized["subcategories"], list):
        normalized["subcategories"] = [normalize_subcategory(s, wordzoo_dir) for s in normalized["subcategories"]]
    return normalized


def normalize_data(data: Dict, wordzoo_dir: Path) -> Dict:
    normalized = dict(data)
    if "categories" in normalized and isinstance(normalized["categories"], list):
        normalized["categories"] = [normalize_category(c, wordzoo_dir) for c in normalized["categories"]]
    return normalized


def upload_folder_to_supabase(local_dir: Path, bucket_name: str, supabase, base_path: str = ""):
    for item in sorted(local_dir.iterdir()):
        relative_path = item.relative_to(local_dir)
        storage_path = f"{base_path}/{relative_path}" if base_path else str(relative_path)
        if item.is_file():
            try:
                with open(item, "rb") as f:
                    supabase.storage.from_(bucket_name).upload(storage_path, f)
                print(f"  [OK] Uploaded {storage_path}")
            except Exception as e:
                print(f"  [FAIL] Failed to upload {storage_path}: {e}")
        elif item.is_dir():
            upload_folder_to_supabase(item, bucket_name, supabase, storage_path)


def upload_to_supabase(wordzoo_dir: Path, data: Dict, supabase_url: str, supabase_key: str):
    try:
        from supabase import create_client, Client
    except ImportError:
        print("Error: supabase-py not installed. Install with: pip install supabase")
        return False

    supabase: Client = create_client(supabase_url, supabase_key)

    print("\nUploading media files to 'assets' bucket...")
    upload_folder_to_supabase(wordzoo_dir, "assets")

    print("\nUploading data.json to 'data' bucket...")
    data_json = json.dumps(data, indent=2, ensure_ascii=False)
    try:
        supabase.storage.from_("data").upload(
            f"data-v{data['version']}.json",
            data_json.encode('utf-8')
        )
        print(f"  [OK] Uploaded data-v{data['version']}.json")
    except Exception as e:
        print(f"  [FAIL] Failed to upload data.json: {e}")
        return False

    print("\nUpdating data_versions table...")
    try:
        supabase.table("data_versions").upsert({
            "version": data["version"],
            "is_active": True
        }).execute()
        print(f"  [OK] Updated version to {data['version']}")
    except Exception as e:
        print(f"  [FAIL] Failed to update data_versions: {e}")
        return False

    return True


def main():
    parser = argparse.ArgumentParser(
        description="Sync data_version1_final.json and local wordzoo media to Supabase"
    )
    parser.add_argument("--wordzoo-dir", required=True, help="Path to wordzoo folder (e.g., ./wordzoo)")
    parser.add_argument("--json-file", required=True, help="Path to data_version1_final.json")
    parser.add_argument("--version", default="1.0.0", help="Data version (default: 1.0.0)")
    parser.add_argument("--supabase-url", default=None, help="Supabase URL (or set SUPABASE_URL env var)")
    parser.add_argument("--supabase-key", default=None, help="Supabase service role key (or set SUPABASE_KEY env var)")
    parser.add_argument("--upload", action="store_true", help="Upload to Supabase")

    args = parser.parse_args()

    wordzoo_dir = Path(args.wordzoo_dir)
    json_file = Path(args.json_file)

    if not wordzoo_dir.exists():
        print(f"Error: wordzoo directory {wordzoo_dir} does not exist")
        return 1

    if not json_file.exists():
        print(f"Error: json file {json_file} does not exist")
        return 1

    supabase_url = args.supabase_url or os.getenv("SUPABASE_URL")
    supabase_key = args.supabase_key or os.getenv("SUPABASE_KEY")

    if args.upload and (not supabase_url or not supabase_key):
        print("Error: --upload requires --supabase-url and --supabase-key or SUPABASE_URL/SUPABASE_KEY env vars")
        return 1

    print(f"Loading JSON: {json_file}")
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    print(f"Normalizing paths relative to: {wordzoo_dir}")
    data = normalize_data(data, wordzoo_dir)
    data["version"] = args.version

    print(f"\nSummary:")
    print(f"  Version: {data['version']}")
    print(f"  Categories: {len(data['categories'])}")
    for cat in data["categories"]:
        total_entities = sum(len(sub.get("entities", [])) for sub in cat["subcategories"])
        print(f"  - {cat['names'].get('vi', cat['id'])}: {len(cat['subcategories'])} subcategories, {total_entities} entities")

    if args.upload:
        print(f"\nUploading to Supabase...")
        success = upload_to_supabase(wordzoo_dir, data, supabase_url, supabase_key)
        if success:
            print("\n[OK] Upload completed successfully!")
        else:
            print("\n[FAIL] Upload failed")
            return 1

    return 0


if __name__ == "__main__":
    exit(main())
