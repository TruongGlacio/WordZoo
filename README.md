# WordZoo

Flutter English learning app for children (ages 3-8).

## Tech Stack

- **Flutter** - Cross-platform mobile app
- **Supabase** - Backend (Auth, Storage, Database)
- **BLoC** - State management
- **Hive** - Local cache
- **Gap** - Spacing

## Project Structure

```
WordZoo/
├── wordzoo/                    # Local data folder (mirrors Supabase Storage)
│   ├── animals/
│   │   ├── LocalizedNames/
│   │   │   ├── name_vi/audio.wav
│   │   │   ├── name_en/audio.wav
│   │   │   └── name_zh/audio.wav
│   │   ├── icon.png
│   │   ├── background.png
│   │   └── sub_categorys/
│   │       ├── wild_animals/
│   │       │   ├── LocalizedNames/
│   │       │   ├── icon.png
│   │       │   ├── background.png
│   │       │   └── entitys/
│   │       │       ├── lion/
│   │       │       │   ├── icon.png
│   │       │       │   ├── LocalizedNames/
│   │       │       │   │   ├── name_vi/audio.wav
│   │       │       │   │   ├── name_en/audio.wav
│   │       │       │   │   └── name_zh/audio.wav
│   │       │       │   └── sound_effect.wav
│   │       │       └── elephant/
│   │       └── farm_animals/
│   ├── plants/
│   ├── vehicles/
│   └── human_relations/
├── mobile/
│   ├── lib/
│   │   ├── blocs/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── theme/
│   │   └── utils/
│   ├── scripts/
│   │   ├── sync_wordzoo.py    # Generate data.json + upload to Supabase
│   │   └── create_csv_templates.py
│   └── supabase/
│       ├── migrations/
│       └── config.toml
└── docs/
    ├── category_screen.md
    └── data_upload_guide.md
```

## Getting Started

### 1. Clone repository

```bash
git clone <repo-url>
cd WordZoo
```

### 2. Setup Flutter

```bash
cd mobile
flutter pub get
flutter gen-l10n
```

### 3. Setup Supabase

1. Create Supabase project
2. Run migrations in `mobile/supabase/migrations/`
3. Create storage buckets: `assets` (public) and `data` (private)
4. Create `data_versions` table

### 4. Add data

1. Create `wordzoo/` folder at project root
2. Add media files following the folder structure
3. Run sync script:
   ```bash
   python mobile/scripts/sync_wordzoo.py \
     --wordzoo-dir ./wordzoo \
     --version 1.0.0 \
     --upload \
     --supabase-url "https://your-project.supabase.co" \
     --supabase-key "your-service-role-key"
   ```

### 5. Run app

```bash
flutter run
```

## Documentation

- [Category Screen](docs/category_screen.md)
- [Data Upload Guide](docs/data_upload_guide.md)

## Scripts

| Script | Purpose |
|--------|---------|
| `sync_wordzoo.py` | Generate data.json and upload to Supabase |
| `create_csv_templates.py` | Create empty CSV templates for entities |

## License

© 2026 WordZoo. All rights reserved.
