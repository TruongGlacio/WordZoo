#!/usr/bin/env python3
"""
Generate data.json and sync to Supabase from local wordzoo folder.

Local structure:
    wordzoo/
    ├── animals/
    │   ├── LocalizedNames/
    │   │   ├── name_vi/
    │   │   │   └── audio.wav
    │   │   ├── name_en/
    │   │   │   └── audio.wav
    │   │   └── name_zh/
    │   │       └── audio.wav
    │   ├── icon.png
    │   ├── background.png
    │   └── sub_categorys/
    │       ├── wild_animals/
    │       │   ├── LocalizedNames/
    │       │   │   ├── name_vi/
    │       │   │   │   └── audio.wav
    │       │   │   ├── name_en/
    │       │   │   │   └── audio.wav
    │       │   │   └── name_zh/
    │       │   │       └── audio.wav
    │       │   ├── icon.png
    │       │   ├── background.png
    │       │   └── entitys/
    │       │       ├── lion/
    │       │       │   ├── icon.png
    │       │       │   ├── LocalizedNames/
    │       │       │   │   ├── name_vi/
    │       │       │   │   │   └── audio.wav
    │       │       │   │   ├── name_en/
    │       │       │   │   │   └── audio.wav
    │       │       │   │   └── name_zh/
    │       │       │   │       └── audio.wav
    │       │       │   └── sound_effect.wav
    │       │       └── elephant/
    │       │           └── ...
    │       └── farm_animals/
    │           └── ...
    └── plants/
        └── ...

Supabase Storage structure (MIRROR local):
    assets/
    ├── animals/
    │   ├── LocalizedNames/
    │   │   ├── name_vi/
    │   │   │   └── audio.wav
    │   │   ├── name_en/
    │   │   │   └── audio.wav
    │   │   └── name_zh/
    │   │       └── audio.wav
    │   ├── icon.png
    │   ├── background.png
    │   └── sub_categorys/
    │       ├── wild_animals/
    │       │   ├── LocalizedNames/
    │       │   │   ├── name_vi/
    │       │   │   │   └── audio.wav
    │       │   │   ├── name_en/
    │       │   │   │   └── audio.wav
    │       │   │   └── name_zh/
    │       │   │       └── audio.wav
    │       │   ├── icon.png
    │       │   ├── background.png
    │       │   └── entitys/
    │       │       ├── lion/
    │       │       │   ├── icon.png
    │       │       │   ├── LocalizedNames/
    │       │       │   │   ├── name_vi/
    │       │       │   │   │   └── audio.wav
    │       │       │   │   ├── name_en/
    │       │       │   │   │   └── audio.wav
    │       │       │   │   └── name_zh/
    │       │       │   │       └── audio.wav
    │       │       │   └── sound_effect.wav
    │       │       └── elephant/
    │       │           └── ...
    │       └── farm_animals/
    │           └── ...
    └── plants/
        └── ...
    data/
    └── data-v1.0.0.json

Usage:
    python sync_wordzoo.py --wordzoo-dir ./wordzoo --version 1.0.0 --upload
"""

import json
import os
import argparse
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional


# Category ID mapping (folder name -> category type)
CATEGORY_TYPE_MAPPING = {
    "animals": "animals",
    "plants": "plants",
    "vehicles": "vehicles",
    "human_relations": "human_relations",
}


def scan_localized_names(localized_dir: Path) -> Dict[str, str]:
    """
    Scan LocalizedNames folder and return mapping of lang -> relative path.
    
    Structure:
        LocalizedNames/
        ├── name_vi/
        │   └── audio.wav
        ├── name_en/
        │   └── audio.wav
        └── name_zh/
            └── audio.wav
    
    Returns:
        {"vi": "LocalizedNames/name_vi/audio.wav", ...}
    """
    result = {}
    if not localized_dir.exists() or not localized_dir.is_dir():
        return result
    
    for lang_dir in localized_dir.iterdir():
        if lang_dir.is_dir():
            lang = lang_dir.name.replace("name_", "")
            audio_files = list(lang_dir.glob("audio.*"))
            if audio_files:
                # Return relative path from the parent of LocalizedNames
                result[lang] = str(audio_files[0].relative_to(localized_dir.parent))
    
    return result


def scan_category(category_dir: Path) -> Dict:
    """Scan a category folder and return category data."""
    category_id = category_dir.name
    category_type = CATEGORY_TYPE_MAPPING.get(category_id, category_id)
    
    # Scan category-level localized names
    localized_names_dir = category_dir / "LocalizedNames"
    localized_audios = scan_localized_names(localized_names_dir)
    
    # Extract names from folder structure or use default
    names = {
        "vi": category_id.replace("_", " ").title(),
        "en": category_id.replace("_", " ").title(),
        "zh": category_id.replace("_", " ").title(),
    }
    
    # Try to read names from audio filenames if available
    # For now, use folder name as default
    
    category = {
        "id": category_id,
        "type": category_type,
        "names": names,
        "icon": f"{category_id}/icon.png" if (category_dir / "icon.png").exists() else "",
        "background": f"{category_id}/background.png" if (category_dir / "background.png").exists() else "",
        "signpost_style": "default",
        "subcategories": []
    }
    
    # Add localized name audio paths
    if localized_audios:
        category["localized_names_audio"] = localized_audios
    
    # Scan subcategories
    subcategories_dir = category_dir / "sub_categorys"
    if subcategories_dir.exists():
        for sub_dir in sorted(subcategories_dir.iterdir()):
            if sub_dir.is_dir():
                subcategory = scan_subcategory(sub_dir, category_id)
                category["subcategories"].append(subcategory)
    
    return category


def scan_subcategory(sub_dir: Path, category_id: str) -> Dict:
    """Scan a subcategory folder and return subcategory data."""
    subcategory_id = sub_dir.name
    
    # Scan subcategory-level localized names
    localized_names_dir = sub_dir / "LocalizedNames"
    localized_audios = scan_localized_names(localized_names_dir)
    
    names = {
        "vi": subcategory_id.replace("_", " ").title(),
        "en": subcategory_id.replace("_", " ").title(),
        "zh": subcategory_id.replace("_", " ").title(),
    }
    
    subcategory = {
        "id": subcategory_id,
        "names": names,
        "icon": f"{category_id}/sub_categorys/{subcategory_id}/icon.png" if (sub_dir / "icon.png").exists() else "",
        "background": f"{category_id}/sub_categorys/{subcategory_id}/background.png" if (sub_dir / "background.png").exists() else "",
        "entities": []
    }
    
    # Add localized name audio paths
    if localized_audios:
        subcategory["localized_names_audio"] = localized_audios
    
    # Scan entities
    entities_dir = sub_dir / "entitys"
    if entities_dir.exists():
        for entity_dir in sorted(entities_dir.iterdir()):
            if entity_dir.is_dir():
                entity = scan_entity(entity_dir, category_id, subcategory_id)
                subcategory["entities"].append(entity)
    
    return subcategory


def scan_entity(entity_dir: Path, category_id: str, subcategory_id: str) -> Dict:
    """Scan an entity folder and return entity data."""
    entity_id = entity_dir.name
    
    # Scan entity-level localized names
    localized_names_dir = entity_dir / "LocalizedNames"
    localized_audios = scan_localized_names(localized_names_dir)
    
    names = {
        "vi": entity_id.replace("_", " ").title(),
        "en": entity_id.replace("_", " ").title(),
        "zh": entity_id.replace("_", " ").title(),
    }
    
    # Entity files
    icon_path = entity_dir / "icon.png"
    animation_path = entity_dir / "animation.json"
    sound_effect_path = entity_dir / "sound_effect.wav"
    
    entity = {
        "id": entity_id,
        "isPremium": False,
        "names": names,
        "animation_image": f"{category_id}/sub_categorys/{subcategory_id}/entitys/{entity_id}/animation.json" if animation_path.exists() else "",
        "real_image": f"{category_id}/sub_categorys/{subcategory_id}/entitys/{entity_id}/icon.png" if icon_path.exists() else "",
        "audio_names": {
            "vi": localized_audios.get("vi", ""),
            "en": localized_audios.get("en", ""),
            "zh": localized_audios.get("zh", ""),
        },
        "sound_effect": f"{category_id}/sub_categorys/{subcategory_id}/entitys/{entity_id}/sound_effect.wav" if sound_effect_path.exists() else None,
        "type_tags": [],
        "difficulty": 1
    }
    
    return entity


def scan_wordzoo_folder(wordzoo_dir: Path) -> Dict:
    """Scan the entire wordzoo folder and generate data.json structure."""
    categories = []
    
    for category_dir in sorted(wordzoo_dir.iterdir()):
        if category_dir.is_dir():
            category = scan_category(category_dir)
            categories.append(category)
    
    return {
        "version": "1.0.0",
        "last_updated": datetime.utcnow().isoformat() + "Z",
        "categories": categories
    }


def upload_folder_to_supabase(local_dir: Path, bucket_name: str, supabase, base_path: str = ""):
    """Upload a folder to Supabase Storage preserving structure."""
    for item in sorted(local_dir.iterdir()):
        relative_path = item.relative_to(local_dir)
        storage_path = f"{base_path}/{relative_path}" if base_path else str(relative_path)
        
        if item.is_file():
            try:
                with open(item, "rb") as f:
                    supabase.storage.from(bucket_name).upload(storage_path, f)
                print(f"  ✓ Uploaded {storage_path}")
            except Exception as e:
                print(f"  ✗ Failed to upload {storage_path}: {e}")
        elif item.is_dir():
            upload_folder_to_supabase(item, bucket_name, storage_path)


def upload_to_supabase(wordzoo_dir: Path, data: Dict, supabase_url: str, supabase_key: str):
    """Upload data.json and media files to Supabase Storage."""
    try:
        from supabase import create_client, Client
    except ImportError:
        print("Error: supabase-py not installed. Install with: pip install supabase")
        return False
    
    supabase: Client = create_client(supabase_url, supabase_key)
    
    # Upload media files preserving folder structure
    print("\nUploading media files to 'assets' bucket...")
    upload_folder_to_supabase(wordzoo_dir, "assets")
    
    # Upload data.json
    print("\nUploading data.json to 'data' bucket...")
    data_json = json.dumps(data, indent=2, ensure_ascii=False)
    try:
        supabase.storage.from("data").upload(
            f"data-v{data['version']}.json",
            data_json.encode('utf-8')
        )
        print(f"  ✓ Uploaded data-v{data['version']}.json")
    except Exception as e:
        print(f"  ✗ Failed to upload data.json: {e}")
        return False
    
    # Update data_versions table
    print("\nUpdating data_versions table...")
    try:
        supabase.table("data_versions").upsert({
            "version": data["version"],
            "is_active": True
        }).execute()
        print(f"  ✓ Updated version to {data['version']}")
    except Exception as e:
        print(f"  ✗ Failed to update data_versions: {e}")
        return False
    
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Generate data.json and sync to Supabase from local wordzoo folder"
    )
    parser.add_argument(
        "--wordzoo-dir",
        required=True,
        help="Path to wordzoo folder (e.g., ./wordzoo)"
    )
    parser.add_argument(
        "--output",
        default=None,
        help="Output JSON file path (e.g., ./data/data.json)"
    )
    parser.add_argument(
        "--version",
        default="1.0.0",
        help="Data version (default: 1.0.0)"
    )
    parser.add_argument(
        "--supabase-url",
        default=None,
        help="Supabase URL (or set SUPABASE_URL env var)"
    )
    parser.add_argument(
        "--supabase-key",
        default=None,
        help="Supabase service role key (or set SUPABASE_KEY env var)"
    )
    parser.add_argument(
        "--upload",
        action="store_true",
        help="Upload to Supabase after generating"
    )
    
    args = parser.parse_args()
    
    wordzoo_dir = Path(args.wordzoo_dir)
    if not wordzoo_dir.exists():
        print(f"Error: wordzoo directory {wordzoo_dir} does not exist")
        return 1
    
    # Get Supabase credentials
    supabase_url = args.supabase_url or os.getenv("SUPABASE_URL")
    supabase_key = args.supabase_key or os.getenv("SUPABASE_KEY")
    
    if args.upload and (not supabase_url or not supabase_key):
        print("Error: --upload requires --supabase-url and --supabase-key or SUPABASE_URL/SUPABASE_KEY env vars")
        return 1
    
    # Generate data
    print(f"Scanning wordzoo folder: {wordzoo_dir}")
    data = scan_wordzoo_folder(wordzoo_dir)
    data["version"] = args.version
    
    # Save to file if output specified
    if args.output:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"\n✓ Generated {output_path}")
    
    # Print summary
    print(f"\nSummary:")
    print(f"  Version: {data['version']}")
    print(f"  Categories: {len(data['categories'])}")
    for cat in data["categories"]:
        total_entities = sum(len(sub.get("entities", [])) for sub in cat["subcategories"])
        print(f"  - {cat['names']['vi']}: {len(cat['subcategories'])} subcategories, {total_entities} entities")
    
    # Upload to Supabase
    if args.upload:
        print(f"\nUploading to Supabase...")
        success = upload_to_supabase(wordzoo_dir, data, supabase_url, supabase_key)
        if success:
            print("\n✓ Upload completed successfully!")
        else:
            print("\n✗ Upload failed")
            return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
