#!/usr/bin/env python3
"""
Generate data.json and upload to Supabase from local wordzoo folder.

Local folder structure:
    wordzoo/
    ├── category1/
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
    │       ├── sub_category1/
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
    │       │       ├── entity1/
    │       │       │   ├── icon.png
    │       │       │   ├── LocalizedNames/
    │       │       │   │   ├── name_vi/
    │       │       │   │   │   └── audio.wav
    │       │       │   │   ├── name_en/
    │       │       │   │   │   └── audio.wav
    │       │       │   │   └── name_zh/
    │       │       │   │       └── audio.wav
    │       │       │   └── sound_effect.wav  (optional)
    │       │       └── entity2/
    │       │           └── ...
    │       └── sub_category2/
    │           └── ...
    └── category2/
        └── ...

Supabase Storage structure:
    assets/
    ├── icons/
    │   ├── category1.png
    │   ├── category2.png
    │   └── ...
    ├── backgrounds/
    │   ├── category1.jpg
    │   ├── category2.jpg
    │   └── ...
    ├── sub_category_avata/
    │   ├── sub_category1.png
    │   ├── sub_category2.png
    │   └── ...
    ├── images/
    │   ├── entity1.png
    │   ├── entity2.png
    │   └── ...
    ├── animations/
    │   ├── entity1.json
    │   └── ...
    ├── audio/
    │   ├── vi/
    │   │   ├── category1.mp3
    │   │   ├── sub_category1.mp3
    │   │   ├── entity1.mp3
    │   │   └── ...
    │   ├── en/
    │   │   └── ...
    │   ├── zh/
    │   │   └── ...
    │   └── sfx/
    │       ├── entity1.mp3
    │       └── ...
    └── ...
    data/
    └── data-v1.0.0.json

Usage:
    python sync_to_supabase.py --wordzoo-dir ./wordzoo --version 1.0.0
"""

import json
import os
import argparse
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional


# Category ID mapping (folder name -> category type)
# You can customize this based on your category names
CATEGORY_TYPE_MAPPING = {
    "animals": "animals",
    "plants": "plants",
    "vehicles": "vehicles",
    "human_relations": "human_relations",
    # Add more if needed
}


def scan_localized_names(localized_dir: Path) -> Dict[str, str]:
    """
    Scan LocalizedNames folder and return mapping of lang -> audio path.
    
    Structure:
        LocalizedNames/
        ├── name_vi/
        │   └── audio.wav
        ├── name_en/
        │   └── audio.wav
        └── name_zh/
            └── audio.wav
    
    Returns:
        {"vi": "path/to/audio.wav", "en": "path/to/audio.wav", "zh": "path/to/audio.wav"}
    """
    result = {}
    if not localized_dir.exists() or not localized_dir.is_dir():
        return result
    
    for lang_dir in localized_dir.iterdir():
        if lang_dir.is_dir():
            lang = lang_dir.name.replace("name_", "")
            audio_files = list(lang_dir.glob("audio.*"))
            if audio_files:
                result[lang] = str(audio_files[0])
    
    return result


def scan_category(category_dir: Path) -> Dict:
    """Scan a category folder and return category data."""
    category_id = category_dir.name
    category_type = CATEGORY_TYPE_MAPPING.get(category_id, category_id)
    
    # Scan category-level localized names
    localized_names_dir = category_dir / "LocalizedNames"
    category_names = scan_localized_names(localized_names_dir)
    
    # Extract names from folder structure
    names = {
        "vi": category_names.get("vi", "").replace("_", " ").title() if category_names.get("vi") else category_id.replace("_", " ").title(),
        "en": category_names.get("en", "").replace("_", " ").title() if category_names.get("en") else category_id.replace("_", " ").title(),
        "zh": category_names.get("zh", "").replace("_", " ").title() if category_names.get("zh") else category_id.replace("_", " ").title(),
    }
    
    # Category icon and background
    icon_path = category_dir / "icon.png"
    background_path = category_dir / "background.png"
    
    category = {
        "id": category_id,
        "type": category_type,
        "names": names,
        "icon": f"assets/icons/{category_id}.png" if icon_path.exists() else "",
        "background": f"assets/backgrounds/{category_id}.jpg" if background_path.exists() else "",
        "signpost_style": "default",
        "subcategories": []
    }
    
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
    subcategory_names = scan_localized_names(localized_names_dir)
    
    names = {
        "vi": subcategory_names.get("vi", "").replace("_", " ").title() if subcategory_names.get("vi") else subcategory_id.replace("_", " ").title(),
        "en": subcategory_names.get("en", "").replace("_", " ").title() if subcategory_names.get("en") else subcategory_id.replace("_", " ").title(),
        "zh": subcategory_names.get("zh", "").replace("_", " ").title() if subcategory_names.get("zh") else subcategory_id.replace("_", " ").title(),
    }
    
    # Subcategory icon and background
    icon_path = sub_dir / "icon.png"
    background_path = sub_dir / "background.png"
    
    subcategory = {
        "id": subcategory_id,
        "names": names,
        "icon": f"assets/sub_category_avata/{subcategory_id}.png" if icon_path.exists() else "",
        "background": f"assets/backgrounds/subcategory/{category_id}_{subcategory_id}.jpg" if background_path.exists() else "",
        "entities": []
    }
    
    # Scan entities
    entities_dir = sub_dir / "entitys"
    if entities_dir.exists():
        for entity_dir in sorted(entities_dir.iterdir()):
            if entity_dir.is_dir():
                entity = scan_entity(entity_dir)
                subcategory["entities"].append(entity)
    
    return subcategory


def scan_entity(entity_dir: Path) -> Dict:
    """Scan an entity folder and return entity data."""
    entity_id = entity_dir.name
    
    # Scan entity-level localized names
    localized_names_dir = entity_dir / "LocalizedNames"
    entity_names = scan_localized_names(localized_names_dir)
    
    names = {
        "vi": entity_names.get("vi", "").replace("_", " ").title() if entity_names.get("vi") else entity_id.replace("_", " ").title(),
        "en": entity_names.get("en", "").replace("_", " ").title() if entity_names.get("en") else entity_id.replace("_", " ").title(),
        "zh": entity_names.get("zh", "").replace("_", " ").title() if entity_names.get("zh") else entity_id.replace("_", " ").title(),
    }
    
    # Entity files
    icon_path = entity_dir / "icon.png"
    animation_path = entity_dir / "animation.json"
    sound_effect_path = entity_dir / "sound_effect.wav"
    
    entity = {
        "id": entity_id,
        "isPremium": False,
        "names": names,
        "animation_image": f"assets/animations/{entity_id}.json" if animation_path.exists() else "",
        "real_image": f"assets/images/{entity_id}.png" if icon_path.exists() else "",
        "audio_names": {
            "vi": f"assets/audio/vi/{entity_id}.mp3" if entity_names.get("vi") else "",
            "en": f"assets/audio/en/{entity_id}.mp3" if entity_names.get("en") else "",
            "zh": f"assets/audio/zh/{entity_id}.mp3" if entity_names.get("zh") else "",
        },
        "sound_effect": f"assets/audio/sfx/{entity_id}.mp3" if sound_effect_path.exists() else None,
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


def upload_to_supabase(data: Dict, wordzoo_dir: Path, supabase_url: str, supabase_key: str):
    """Upload data.json and media files to Supabase Storage."""
    try:
        from supabase import create_client, Client
    except ImportError:
        print("Error: supabase-py not installed. Install with: pip install supabase")
        return False
    
    supabase: Client = create_client(supabase_url, supabase_key)
    
    # Upload media files
    print("\nUploading media files...")
    for root, dirs, files in os.walk(wordzoo_dir):
        for file in files:
            file_path = Path(root) / file
            relative_path = file_path.relative_to(wordzoo_dir)
            
            # Determine storage path based on file type and location
            parts = relative_path.parts
            
            # Category files
            if len(parts) == 2:
                category_id = parts[0]
                filename = parts[1]
                if filename == "icon.png":
                    storage_path = f"icons/{category_id}.png"
                    bucket = "assets"
                elif filename == "background.png":
                    storage_path = f"backgrounds/{category_id}.jpg"
                    bucket = "assets"
                else:
                    continue
            
            # Subcategory files
            elif len(parts) == 3 and parts[1] == "sub_categorys":
                subcategory_id = parts[2]
                # This is the subcategory folder, need to look inside
                continue
            
            # Entity files
            elif len(parts) >= 4 and parts[1] == "sub_categorys":
                category_id = parts[0]
                subcategory_id = parts[2]
                entity_id = parts[4] if len(parts) >= 5 else None
                
                if entity_id:
                    filename = parts[-1]
                    
                    # Entity icon
                    if filename == "icon.png":
                        storage_path = f"images/{entity_id}.png"
                        bucket = "assets"
                    # Entity animation
                    elif filename == "animation.json":
                        storage_path = f"animations/{entity_id}.json"
                        bucket = "assets"
                    # Entity sound effect
                    elif filename == "sound_effect.wav":
                        storage_path = f"audio/sfx/{entity_id}.mp3"
                        bucket = "assets"
                    # Entity audio names
                    elif "LocalizedNames" in parts:
                        lang = parts[-2]  # name_vi, name_en, name_zh
                        lang_code = lang.replace("name_", "")
                        storage_path = f"audio/{lang_code}/{entity_id}.mp3"
                        bucket = "assets"
                    else:
                        continue
                else:
                    continue
            
            # Category/Subcategory audio names
            elif "LocalizedNames" in parts:
                # Category name audio
                if len(parts) == 3:
                    lang = parts[1]  # name_vi, name_en, name_zh
                    lang_code = lang.replace("name_", "")
                    entity_id = parts[0]
                    storage_path = f"audio/{lang_code}/{entity_id}.mp3"
                    bucket = "assets"
                else:
                    continue
            else:
                continue
            
            # Upload file
            try:
                with open(file_path, "rb") as f:
                    supabase.storage.from(bucket).upload(storage_path, f)
                print(f"  ✓ Uploaded {storage_path}")
            except Exception as e:
                print(f"  ✗ Failed to upload {storage_path}: {e}")
    
    # Upload data.json
    print("\nUploading data.json...")
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
        description="Generate data.json and upload to Supabase from local wordzoo folder"
    )
    parser.add_argument(
        "--wordzoo-dir",
        required=True,
        help="Path to wordzoo folder (e.g., ./wordzoo)"
    )
    parser.add_argument(
        "--output",
        default=None,
        help="Output JSON file path (e.g., ./data/data.json). If not provided, only upload without saving."
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
        success = upload_to_supabase(data, wordzoo_dir, supabase_url, supabase_key)
        if success:
            print("\n✓ Upload completed successfully!")
        else:
            print("\n✗ Upload failed")
            return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
