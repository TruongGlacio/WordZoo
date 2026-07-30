#!/usr/bin/env python3
"""
Generate data.json for WordZoo app from assets folder.

This script:
1. Scans assets folder for images, audio, animations
2. Reads entity definitions from CSV files
3. Generates complete data.json with all paths

Usage:
    python generate_data.py --assets-dir ./assets --definitions-dir ./assets/definitions --output ./data/data.json --version 1.0.0
"""

import json
import csv
import os
import argparse
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional


class LocalizedNames:
    def __init__(self, vi: str = "", en: str = "", zh: str = ""):
        self.vi = vi
        self.en = en
        self.zh = zh

    def to_dict(self):
        return {"vi": self.vi, "en": self.en, "zh": self.zh}


class AudioPaths:
    def __init__(self, vi: str = "", en: str = "", zh: str = ""):
        self.vi = vi
        self.en = en
        self.zh = zh

    def to_dict(self):
        return {"vi": self.vi, "en": self.en, "zh": self.zh}


class Entity:
    def __init__(self, entity_id: str, vi: str, en: str, zh: str,
                 is_premium: bool = False, difficulty: int = 1, tags: List[str] = None):
        self.id = entity_id
        self.isPremium = is_premium
        self.names = LocalizedNames(vi, en, zh)
        self.animation_image = f"assets/animations/{entity_id}.json"
        self.real_image = f"assets/images/{entity_id}.png"
        self.audio_names = AudioPaths(
            vi=f"assets/audio/vi/{entity_id}.mp3",
            en=f"assets/audio/en/{entity_id}.mp3",
            zh=f"assets/audio/zh/{entity_id}.mp3"
        )
        self.sound_effect = f"assets/audio/sfx/{entity_id}.mp3"
        self.type_tags = tags or []
        self.difficulty = difficulty

    def to_dict(self):
        result = {
            "id": self.id,
            "isPremium": self.isPremium,
            "names": self.names.to_dict(),
            "animation_image": self.animation_image,
            "real_image": self.real_image,
            "audio_names": self.audio_names.to_dict(),
            "type_tags": self.type_tags,
            "difficulty": self.difficulty
        }
        if self.sound_effect:
            result["sound_effect"] = self.sound_effect
        return result


class Subcategory:
    def __init__(self, subcategory_id: str, order: int, vi: str, en: str, zh: str, entities: List[Entity] = None):
        self.id = subcategory_id
        self.order = order
        self.icon = f"assets/sub_category_avata/{subcategory_id}.png"
        self.names = LocalizedNames(vi, en, zh)
        self.entities = entities or []

    def to_dict(self):
        return {
            "id": self.id,
            "names": self.names.to_dict(),
            "entities": [e.to_dict() for e in self.entities]
        }


class Category:
    def __init__(self, category_id: str, category_type: str, vi: str, en: str, zh: str,
                 subcategories: List[Subcategory] = None):
        self.id = category_id
        self.type = category_type
        self.names = LocalizedNames(vi, en, zh)
        self.icon = f"assets/icons/{category_id}.png"
        self.background = f"assets/backgrounds/{category_id}.jpg"
        self.signpost_style = "default"
        self.subcategories = subcategories or []

    def to_dict(self):
        return {
            "id": self.id,
            "type": self.type,
            "names": self.names.to_dict(),
            "icon": self.icon,
            "background": self.background,
            "signpost_style": self.signpost_style,
            "subcategories": [s.to_dict() for s in self.subcategories]
        }


class WordZooData:
    def __init__(self, version: str, categories: List[Category]):
        self.version = version
        self.last_updated = datetime.utcnow().isoformat() + "Z"
        self.categories = categories

    def to_dict(self):
        return {
            "version": self.version,
            "last_updated": self.last_updated,
            "categories": [c.to_dict() for c in self.categories]
        }


# Category configuration
CATEGORY_CONFIG = {
    "animals": {
        "type": "animals",
        "names": {"vi": "Động vật", "en": "Animals", "zh": "动物"},
        "subcategories": [
            {"id": "wild_animals", "names": {"vi": "Động vật hoang dã", "en": "Wild Animals", "zh": "野生动物"}},
            {"id": "farm_animals", "names": {"vi": "Động vật trang trại", "en": "Farm Animals", "zh": "农场动物"}},
            {"id": "birds", "names": {"vi": "Chim", "en": "Birds", "zh": "鸟类"}},
            {"id": "sea_animals", "names": {"vi": "Động vật biển", "en": "Sea Animals", "zh": "海洋动物"}},
            {"id": "insects", "names": {"vi": "Côn trùng", "en": "Insects", "zh": "昆虫"}},
            {"id": "reptiles", "names": {"vi": "Bò sát", "en": "Reptiles", "zh": "爬行动物"}},
            {"id": "amphibians", "names": {"vi": "Lưỡng cư", "en": "Amphibians", "zh": "两栖动物"}},
            {"id": "mammals", "names": {"vi": "Động vật có vú", "en": "Mammals", "zh": "哺乳动物"}},
            {"id": "fish", "names": {"vi": "Cá", "en": "Fish", "zh": "鱼类"}},
            {"id": "dinosaurs", "names": {"vi": "Khủng long", "en": "Dinosaurs", "zh": "恐龙"}},
            {"id": "arachnids", "names": {"vi": "Nhện/bọ cạp", "en": "Arachnids", "zh": "蛛形纲"}},
            {"id": "rodents", "names": {"vi": "Gặm nhấm", "en": "Rodents", "zh": "啮齿动物"}},
            {"id": "nocturnal_animals", "names": {"vi": "Động vật ban đêm", "en": "Nocturnal Animals", "zh": "夜行动物"}},
            {"id": "baby_animals", "names": {"vi": "Động vật con", "en": "Baby Animals", "zh": "幼崽"}},
            {"id": "animal_homes", "names": {"vi": "Nhà của động vật", "en": "Animal Homes", "zh": "动物之家"}},
        ]
    },
    "plants": {
        "type": "plants",
        "names": {"vi": "Thực vật", "en": "Plants", "zh": "植物"},
        "subcategories": [
            {"id": "flowers", "names": {"vi": "Hoa", "en": "Flowers", "zh": "花卉"}},
            {"id": "trees", "names": {"vi": "Cây", "en": "Trees", "zh": "树木"}},
            {"id": "fruits", "names": {"vi": "Trái cây", "en": "Fruits", "zh": "水果"}},
            {"id": "vegetables", "names": {"vi": "Rau củ", "en": "Vegetables", "zh": "蔬菜"}},
            {"id": "herbs", "names": {"vi": "Thảo mộc", "en": "Herbs", "zh": "草药"}},
            {"id": "mushrooms", "names": {"vi": "Nấm", "en": "Mushrooms", "zh": "蘑菇"}},
            {"id": "cacti", "names": {"vi": "Xương rồng", "en": "Cacti", "zh": "仙人掌"}},
            {"id": "vines", "names": {"vi": "Dây leo", "en": "Vines", "zh": "藤蔓"}},
            {"id": "ferns", "names": {"vi": "Dương xỉ", "en": "Ferns", "zh": "蕨类"}},
            {"id": "palms", "names": {"vi": "Cây cọ", "en": "Palms", "zh": "棕榈"}},
            {"id": "grasses", "names": {"vi": "Cỏ", "en": "Grasses", "zh": "草"}},
            {"id": "weeds", "names": {"vi": "Cỏ dại", "en": "Weeds", "zh": "杂草"}},
            {"id": "seeds", "names": {"vi": "Hạt giống", "en": "Seeds", "zh": "种子"}},
            {"id": "leaves", "names": {"vi": "Lá", "en": "Leaves", "zh": "叶子"}},
            {"id": "roots", "names": {"vi": "Rễ", "en": "Roots", "zh": "根"}},
        ]
    },
    "vehicles": {
        "type": "vehicles",
        "names": {"vi": "Phương tiện", "en": "Vehicles", "zh": "交通工具"},
        "subcategories": [
            {"id": "land_vehicles", "names": {"vi": "Phương tiện trên đất", "en": "Land Vehicles", "zh": "陆地交通工具"}},
            {"id": "water_vehicles", "names": {"vi": "Phương tiện trên nước", "en": "Water Vehicles", "zh": "水上交通工具"}},
            {"id": "air_vehicles", "names": {"vi": "Phương tiện trên không", "en": "Air Vehicles", "zh": "空中交通工具"}},
            {"id": "construction_vehicles", "names": {"vi": "Xe công trình", "en": "Construction Vehicles", "zh": "工程车辆"}},
            {"id": "emergency_vehicles", "names": {"vi": "Xe khẩn cấp", "en": "Emergency Vehicles", "zh": "紧急车辆"}},
            {"id": "bicycles", "names": {"vi": "Xe đạp", "en": "Bicycles", "zh": "自行车"}},
            {"id": "motorcycles", "names": {"vi": "Xe máy", "en": "Motorcycles", "zh": "摩托车"}},
            {"id": "trains", "names": {"vi": "Tàu hỏa", "en": "Trains", "zh": "火车"}},
            {"id": "rockets", "names": {"vi": "Tên lửa", "en": "Rockets", "zh": "火箭"}},
            {"id": "spaceships", "names": {"vi": "Tàu vũ trụ", "en": "Spaceships", "zh": "宇宙飞船"}},
            {"id": "scooters", "names": {"vi": "Xe tay ga", "en": "Scooters", "zh": "踏板车"}},
            {"id": "trucks", "names": {"vi": "Xe tải", "en": "Trucks", "zh": "卡车"}},
            {"id": "boats", "names": {"vi": "Thuyền nhỏ", "en": "Boats", "zh": "小船"}},
            {"id": "ferries", "names": {"vi": "Phà", "en": "Ferries", "zh": "渡轮"}},
            {"id": "hoverboards", "names": {"vi": "Ván bay", "en": "Hoverboards", "zh": "悬浮滑板"}},
        ]
    },
    "human_relations": {
        "type": "human_relations",
        "names": {"vi": "Quan hệ con người", "en": "Human Relations", "zh": "人际关系"},
        "subcategories": [
            {"id": "family", "names": {"vi": "Gia đình", "en": "Family", "zh": "家庭"}},
            {"id": "friends", "names": {"vi": "Bạn bè", "en": "Friends", "zh": "朋友"}},
            {"id": "community", "names": {"vi": "Cộng đồng", "en": "Community", "zh": "社区"}},
            {"id": "emotions", "names": {"vi": "Cảm xúc", "en": "Emotions", "zh": "情绪"}},
            {"id": "actions", "names": {"vi": "Hành động", "en": "Actions", "zh": "动作"}},
            {"id": "body_parts", "names": {"vi": "Bộ phận cơ thể", "en": "Body Parts", "zh": "身体部位"}},
            {"id": "senses", "names": {"vi": "Giác quan", "en": "Senses", "zh": "感官"}},
            {"id": "daily_activities", "names": {"vi": "Hoạt động hàng ngày", "en": "Daily Activities", "zh": "日常活动"}},
            {"id": "school", "names": {"vi": "Trường học", "en": "School", "zh": "学校"}},
            {"id": "health", "names": {"vi": "Sức khỏe", "en": "Health", "zh": "健康"}},
            {"id": "clothes", "names": {"vi": "Quần áo", "en": "Clothes", "zh": "衣服"}},
            {"id": "food", "names": {"vi": "Đồ ăn", "en": "Food", "zh": "食物"}},
            {"id": "drinks", "names": {"vi": "Đồ uống", "en": "Drinks", "zh": "饮料"}},
            {"id": "toys", "names": {"vi": "Đồ chơi", "en": "Toys", "zh": "玩具"}},
            {"id": "tools", "names": {"vi": "Công cụ", "en": "Tools", "zh": "工具"}},
        ]
    }
}


def read_csv_entities(csv_path: Path) -> List[Entity]:
    """Read entity definitions from a CSV file."""
    entities = []
    if not csv_path.exists():
        print(f"  Warning: {csv_path} not found, skipping")
        return entities

    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                entity = Entity(
                    entity_id=row['id'].strip(),
                    vi=row['vi'].strip(),
                    en=row['en'].strip(),
                    zh=row['zh'].strip(),
                    is_premium=row.get('is_premium', 'false').lower() == 'true',
                    difficulty=int(row.get('difficulty', 1)),
                    tags=[t.strip() for t in row.get('tags', '').split(',') if t.strip()]
                )
                entities.append(entity)
            except Exception as e:
                print(f"  Error parsing row {row}: {e}")

    return entities


def generate_data_json(assets_dir: Path, definitions_dir: Path, version: str) -> WordZooData:
    """Generate complete WordZooData from assets and definitions."""
    categories = []

    for category_id, config in CATEGORY_CONFIG.items():
        subcategories = []

        for idx, sub_config in enumerate(config["subcategories"]):
            subcategory_id = sub_config["id"]

            # Try to read CSV definitions
            csv_path = definitions_dir / f"{subcategory_id}.csv"
            entities = read_csv_entities(csv_path)

            subcategories.append(Subcategory(
                id=subcategory_id,
                order=idx + 1,
                vi=sub_config["names"]["vi"],
                en=sub_config["names"]["en"],
                zh=sub_config["names"]["zh"],
                entities=entities
            ))

        categories.append(Category(
            category_id=category_id,
            category_type=config["type"],
            vi=config["names"]["vi"],
            en=config["names"]["en"],
            zh=config["names"]["zh"],
            subcategories=subcategories
        ))

    return WordZooData(version=version, categories=categories)


def main():
    parser = argparse.ArgumentParser(
        description="Generate data.json for WordZoo app from assets folder"
    )
    parser.add_argument(
        "--assets-dir",
        required=True,
        help="Path to assets folder (e.g., ./assets)"
    )
    parser.add_argument(
        "--definitions-dir",
        required=True,
        help="Path to definitions folder (e.g., ./assets/definitions)"
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Output JSON file path (e.g., ./data/data.json)"
    )
    parser.add_argument(
        "--version",
        default="1.0.0",
        help="Data version (default: 1.0.0)"
    )
    parser.add_argument(
        "--date",
        default=None,
        help="Last updated date (ISO format, default: current UTC time)"
    )

    args = parser.parse_args()

    assets_dir = Path(args.assets_dir)
    definitions_dir = Path(args.definitions_dir)

    if not assets_dir.exists():
        print(f"Error: Assets directory {assets_dir} does not exist")
        return 1

    if not definitions_dir.exists():
        print(f"Error: Definitions directory {definitions_dir} does not exist")
        return 1

    print(f"Scanning assets in {assets_dir}...")
    print(f"Reading definitions from {definitions_dir}...")

    data = generate_data_json(assets_dir, definitions_dir, args.version)

    if args.date:
        data.last_updated = args.date

    # Convert to dict and save
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data.to_dict(), f, indent=2, ensure_ascii=False)

    print(f"\n✓ Generated {output_path}")
    print(f"  Version: {data.version}")
    print(f"  Last updated: {data.last_updated}")
    print(f"  Categories: {len(data.categories)}")

    for cat in data.categories:
        total_entities = sum(len(sub.entities) for sub in cat.subcategories)
        print(f"  - {cat.names.vi}: {len(cat.subcategories)} subcategories, {total_entities} entities")

    print("\nNext steps:")
    print(f"1. Review {output_path}")
    print(f"2. Upload assets to Supabase Storage")
    print(f"3. Upload {output_path} to Supabase Storage bucket 'data'")
    print(f"4. Update data_versions table with version '{data.version}'")

    return 0


if __name__ == "__main__":
    exit(main())
