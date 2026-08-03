#!/usr/bin/env python3
"""
Sync data_version1_final.json and local wordzoo media to Supabase.

Usage:
    python sync_wordzoo.py --wordzoo-dir ./wordzoo --json-file ./data_version1_final.json --version 1.0.0 --upload
"""

import json
import os
import argparse
import mimetypes
import re
import unicodedata
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


def _to_ascii_fallback(text: str) -> str:
    # 1) Replace common Vietnamese and similar Latin chars with ASCII base
    result = "".join(_LATIN_ASCII_MAP.get(ch, ch) for ch in text)
    # 2) Decompose remaining accents
    result = unicodedata.normalize("NFKD", result)
    # 3) Keep only ASCII
    result = result.encode("ascii", "ignore").decode("ascii")
    return result


def sanitize_filename(name: str) -> str:
    """
    Convert a filename to an ASCII-safe string that Supabase Storage accepts.
    - Prefer unidecode when available.
    - Otherwise use a Vietnamese-aware fallback + NFKD decomposition.
    """
    if not name:
        return name
    try:
        from unidecode import unidecode
        name = unidecode(name)
    except Exception:
        name = _to_ascii_fallback(name)
    name = name.encode("ascii", "ignore").decode("ascii")
    name = re.sub(r"[^A-Za-z0-9._-]+", "_", name)
    name = re.sub(r"_+", "_", name).strip("_")
    return name


def warn_if_non_ascii_remaining(data: Dict) -> None:
    """Scan JSON media paths and warn if any remain non-ASCII after sanitization."""
    problems: List[str] = []

    def check(path: Optional[str]) -> None:
        if not path:
            return
        try:
            path.encode("ascii")
        except Exception:
            problems.append(path)

    for cat in data.get("categories", []):
        check(cat.get("icon"))
        check(cat.get("background"))
        check(cat.get("real_image"))
        for lang, p in (cat.get("audio") or {}).items():
            check(p)
        for sub in cat.get("subcategories", []):
            check(sub.get("icon"))
            check(sub.get("background"))
            check(sub.get("real_image"))
            for lang, p in (sub.get("audio") or {}).items():
                check(p)
            for entity in sub.get("entities", []):
                check(entity.get("real_image"))
                check(entity.get("animal_sound"))
                check(entity.get("animation_image"))
                for lang, p in (entity.get("audio") or {}).items():
                    check(p)

    if problems:
        print(f"\nWARNING: {len(problems)} paths remain non-ASCII after sanitization.")
        print("Supabase Storage may reject these uploads.")
        for p in problems[:10]:
            print(f"  {p}")
        if len(problems) > 10:
            print(f"  ... and {len(problems) - 10} more")


def build_sanitized_mapping(wordzoo_dir: Path) -> Dict[str, str]:
    """
    Walk wordzoo_dir and return a mapping from original relative path
    to sanitized relative path for Supabase upload.
    """
    mapping: Dict[str, str] = {}
    for item in sorted(wordzoo_dir.rglob("*")):
        if item.is_file():
            try:
                rel = item.relative_to(wordzoo_dir)
                original = str(rel).replace("\\", "/")
                sanitized_parts = [sanitize_filename(part) for part in rel.parts]
                sanitized = "/".join(sanitized_parts)
                if original != sanitized:
                    mapping[original] = sanitized
            except Exception:
                pass
    return mapping


def normalize_entity(entity: Dict, wordzoo_dir: Path, sanitize: bool = True) -> Dict:
    normalized = dict(entity)
    if "real_image" in normalized and normalized["real_image"]:
        normalized["real_image"] = normalize_path(normalized["real_image"], wordzoo_dir)
        if sanitize:
            normalized["real_image"] = sanitize_storage_path(normalized["real_image"])
    if "audio" in normalized and isinstance(normalized["audio"], dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }
        if sanitize:
            normalized["audio"] = {
                lang: sanitize_storage_path(path)
                for lang, path in normalized["audio"].items()
            }
    if "animal_sound" in normalized and normalized["animal_sound"]:
        normalized["animal_sound"] = normalize_path(normalized["animal_sound"], wordzoo_dir)
        if sanitize:
            normalized["animal_sound"] = sanitize_storage_path(normalized["animal_sound"])
    if "animation_image" in normalized and normalized["animation_image"]:
        normalized["animation_image"] = normalize_path(normalized["animation_image"], wordzoo_dir)
        if sanitize:
            normalized["animation_image"] = sanitize_storage_path(normalized["animation_image"])
    return normalized


def normalize_subcategory(sub: Dict, wordzoo_dir: Path, sanitize: bool = True) -> Dict:
    normalized = dict(sub)
    if "real_image" in normalized and normalized["real_image"]:
        normalized["real_image"] = normalize_path(normalized["real_image"], wordzoo_dir)
        if sanitize:
            normalized["real_image"] = sanitize_storage_path(normalized["real_image"])
    if "audio" in normalized and isinstance(normalized["audio"], dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }
        if sanitize:
            normalized["audio"] = {
                lang: sanitize_storage_path(path)
                for lang, path in normalized["audio"].items()
            }
    if "icon" in normalized and normalized["icon"]:
        normalized["icon"] = normalize_path(normalized["icon"], wordzoo_dir)
        if sanitize:
            normalized["icon"] = sanitize_storage_path(normalized["icon"])
    if "background" in normalized and normalized["background"]:
        normalized["background"] = normalize_path(normalized["background"], wordzoo_dir)
        if sanitize:
            normalized["background"] = sanitize_storage_path(normalized["background"])
    if "entities" in normalized and isinstance(normalized["entities"], list):
        normalized["entities"] = [normalize_entity(e, wordzoo_dir, sanitize=sanitize) for e in normalized["entities"]]
    return normalized


def normalize_category(cat: Dict, wordzoo_dir: Path, sanitize: bool = True) -> Dict:
    normalized = dict(cat)
    if "icon" in normalized and normalized["icon"]:
        normalized["icon"] = normalize_path(normalized["icon"], wordzoo_dir)
        if sanitize:
            normalized["icon"] = sanitize_storage_path(normalized["icon"])
    if "background" in normalized and normalized["background"]:
        normalized["background"] = normalize_path(normalized["background"], wordzoo_dir)
        if sanitize:
            normalized["background"] = sanitize_storage_path(normalized["background"])
    if "audio" in normalized and isinstance(normalized["audio"], dict):
        normalized["audio"] = {
            lang: normalize_path(path, wordzoo_dir)
            for lang, path in normalized["audio"].items()
        }
        if sanitize:
            normalized["audio"] = {
                lang: sanitize_storage_path(path)
                for lang, path in normalized["audio"].items()
            }
    if "real_image" in normalized and normalized["real_image"]:
        normalized["real_image"] = normalize_path(normalized["real_image"], wordzoo_dir)
        if sanitize:
            normalized["real_image"] = sanitize_storage_path(normalized["real_image"])
    if "subcategories" in normalized and isinstance(normalized["subcategories"], list):
        normalized["subcategories"] = [normalize_subcategory(s, wordzoo_dir, sanitize=sanitize) for s in normalized["subcategories"]]
    return normalized


def normalize_data(data: Dict, wordzoo_dir: Path, sanitize: bool = True) -> Dict:
    normalized = dict(data)
    if "categories" in normalized and isinstance(normalized["categories"], list):
        normalized["categories"] = [normalize_category(c, wordzoo_dir, sanitize=sanitize) for c in normalized["categories"]]
    return normalized


def sanitize_storage_path(path: str) -> str:
    """Sanitize each path component for Supabase Storage compatibility."""
    if not path:
        return path
    parts = path.split("/")
    return "/".join(sanitize_filename(part) for part in parts)


def upload_folder_to_supabase(local_dir: Path, bucket_name: str, supabase, base_path: str = "", skip_existing: bool = False):
    for item in sorted(local_dir.iterdir()):
        relative_path = item.relative_to(local_dir)
        local_storage_path = f"{base_path}/{relative_path}" if base_path else str(relative_path)
        storage_path = sanitize_storage_path(local_storage_path)

        if item.is_file():
            try:
                if skip_existing:
                    try:
                        folder_path = storage_path.rsplit("/", 1)[0]
                        file_name = storage_path.split("/")[-1]
                        file_info = supabase.storage.from_(bucket_name).list(folder_path)
                        if any(f["name"] == file_name for f in file_info):
                            print(f"  [SKIP] Already exists {storage_path}")
                            continue
                    except Exception:
                        pass

                mime_type, _ = mimetypes.guess_type(str(item))
                if mime_type is None:
                    mime_type = "application/octet-stream"
                file_options = {"content-type": mime_type, "upsert": "true"}
                with open(item, "rb") as f:
                    supabase.storage.from_(bucket_name).upload(storage_path, f, file_options=file_options)
                print(f"  [OK] Uploaded {storage_path}")
            except Exception as e:
                print(f"  [FAIL] Failed to upload {storage_path}: {e}")
        elif item.is_dir():
            upload_folder_to_supabase(item, bucket_name, supabase, storage_path, skip_existing=skip_existing)


def upload_to_supabase(wordzoo_dir: Path, data: Dict, supabase_url: str, supabase_key: str, skip_existing: bool = False):
    try:
        from supabase import create_client, Client
    except ImportError:
        print("Error: supabase-py not installed. Install with: pip install supabase")
        return False

    supabase: Client = create_client(supabase_url, supabase_key)

    print("\nUploading media files to 'assets' bucket...")
    upload_folder_to_supabase(wordzoo_dir, "assets", supabase, skip_existing=skip_existing)

    print("\nUploading data.json to 'data' bucket...")
    data_json = json.dumps(data, indent=2, ensure_ascii=False)
    try:
        supabase.storage.from_("data").upload(
            f"data-v{data['version']}.json",
            data_json.encode('utf-8'),
            file_options={"content-type": "application/json", "upsert": "true"}
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
    parser.add_argument("--skip-existing", action="store_true", help="Skip files that already exist in storage")
    parser.add_argument("--output-normalized", default=None, help="Save normalized JSON to this path")

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

    print("=" * 60)
    print("WordZoo -> Supabase Sync")
    print("=" * 60)
    print(f"WordZoo dir : {wordzoo_dir}")
    print(f"JSON file   : {json_file}")
    print(f"Version     : {args.version}")
    print(f"Supabase URL: {supabase_url}")
    print(f"Key prefix  : {supabase_key[:8]}..." if supabase_key else "Key: None")
    print("=" * 60)

    print(f"\nLoading JSON: {json_file}")
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Build sanitized mapping BEFORE normalization so we can show warnings
    sanitized_mapping = build_sanitized_mapping(wordzoo_dir)
    if sanitized_mapping:
        print(f"\nWARNING: {len(sanitized_mapping)} paths contain Unicode/non-ASCII characters.")
        print("These will be sanitized for Supabase Storage compatibility.")
        for original, sanitized in list(sanitized_mapping.items())[:5]:
            print(f"  {original} -> {sanitized}")
        if len(sanitized_mapping) > 5:
            print(f"  ... and {len(sanitized_mapping) - 5} more")

    print(f"\nNormalizing paths relative to: {wordzoo_dir}")
    data = normalize_data(data, wordzoo_dir, sanitize=True)
    data["version"] = args.version

    warn_if_non_ascii_remaining(data)

    print(f"\nSummary:")
    print(f"  Version: {data['version']}")
    print(f"  Categories: {len(data['categories'])}")
    for cat in data["categories"]:
        total_entities = sum(len(sub.get("entities", [])) for sub in cat["subcategories"])
        print(f"  - {cat['names'].get('vi', cat['id'])}: {len(cat['subcategories'])} subcategories, {total_entities} entities")

    if args.output_normalized:
        output_path = Path(args.output_normalized)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"\n[INFO] Normalized JSON saved to: {output_path}")

    if args.upload:
        print(f"\nUploading to Supabase...")
        success = upload_to_supabase(wordzoo_dir, data, supabase_url, supabase_key, skip_existing=args.skip_existing)
        if success:
            print("\n[OK] Upload completed successfully!")
        else:
            print("\n[FAIL] Upload failed")
            return 1

    return 0


if __name__ == "__main__":
    exit(main())
