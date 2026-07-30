#!/usr/bin/env python3
"""
Create empty CSV templates for all subcategories.

Usage:
    python create_csv_templates.py --output-dir ./assets/definitions
"""

import csv
import argparse
from pathlib import Path


CATEGORY_SUBCATEGORIES = {
    "animals": [
        "wild_animals", "farm_animals", "birds", "sea_animals", "insects",
        "reptiles", "amphibians", "mammals", "fish", "dinosaurs",
        "arachnids", "rodents", "nocturnal_animals", "baby_animals", "animal_homes"
    ],
    "plants": [
        "flowers", "trees", "fruits", "vegetables", "herbs",
        "mushrooms", "cacti", "vines", "ferns", "palms",
        "grasses", "weeds", "seeds", "leaves", "roots"
    ],
    "vehicles": [
        "land_vehicles", "water_vehicles", "air_vehicles", "construction_vehicles", "emergency_vehicles",
        "bicycles", "motorcycles", "trains", "rockets", "spaceships",
        "scooters", "trucks", "boats", "ferries", "hoverboards"
    ],
    "human_relations": [
        "family", "friends", "community", "emotions", "actions",
        "body_parts", "senses", "daily_activities", "school", "health",
        "clothes", "food", "drinks", "toys", "tools"
    ]
}


def main():
    parser = argparse.ArgumentParser(
        description="Create empty CSV templates for all subcategories"
    )
    parser.add_argument(
        "--output-dir",
        required=True,
        help="Output directory for CSV files (e.g., ./assets/definitions)"
    )

    args = parser.parse_args()
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    created_files = []

    for category_id, subcategories in CATEGORY_SUBCATEGORIES.items():
        for subcategory_id in subcategories:
            csv_path = output_dir / f"{subcategory_id}.csv"

            # Skip if already exists
            if csv_path.exists():
                print(f"  Skipping {csv_path} (already exists)")
                continue

            # Create CSV with header
            with open(csv_path, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow([
                    'id', 'vi', 'en', 'zh', 'is_premium', 'difficulty', 'tags'
                ])
                # Add example row
                writer.writerow([
                    'example_id',
                    'Tên tiếng Việt',
                    'English Name',
                    '中文名称',
                    'false',
                    '1',
                    'tag1,tag2,tag3'
                ])

            created_files.append(csv_path)
            print(f"  Created {csv_path}")

    print(f"\n✓ Created {len(created_files)} CSV templates")
    print(f"\nNext steps:")
    print(f"1. Edit each CSV file in {output_dir}")
    print(f"2. Add your entity data (id, names, tags, etc.)")
    print(f"3. Run generate_data.py to create data.json")


if __name__ == "__main__":
    main()
