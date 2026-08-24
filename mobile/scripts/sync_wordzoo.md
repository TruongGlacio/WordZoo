# Sync WordZoo to Supabase

Script này đọc thư mục `wordzoo/` local, generate `data.json`, và upload lên Supabase **giữ nguyên cấu trúc thư mục**.

## Cấu trúc thư mục local

```
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
├── plants/
│   └── ...
├── vehicles/
│   └── ...
└── human_relations/
    └── ...
```

## Cấu trúc trên Supabase Storage

```
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
├── plants/
│   └── ...
└── vehicles/
    └── ...
data/
└── data-v1.0.0.json
```

## Cách dùng

### 1. Cài đặt dependencies

```bash
pip install supabase
```

### 2. Chuẩn bị thư mục wordzoo

Tạo thư mục `wordzoo/` ở root project (cùng cấp với `mobile/`):

```
WordZoo/
├── wordzoo/
│   ├── animals/
│   ├── plants/
│   ├── vehicles/
│   └── human_relations/
├── mobile/
│   └── ...
└── ...
```

### 3. Thêm dữ liệu

Thêm files vào đúng cấu trúc:
- Category icon: `wordzoo/animals/icon.png`
- Category background: `wordzoo/animals/background.png`
- Category name audio: `wordzoo/animals/LocalizedNames/name_vi/audio.wav`
- Subcategory icon: `wordzoo/animals/sub_categorys/wild_animals/icon.png`
- Entity icon: `wordzoo/animals/sub_categorys/wild_animals/entitys/lion/icon.png`
- Entity audio: `wordzoo/animals/sub_categorys/wild_animals/entitys/lion/LocalizedNames/name_vi/audio.wav`

### 4. Chạy script

```bash
# Generate data.json only
python mobile/scripts/sync_wordzoo.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --output ./mobile/data/data-v1.0.0.json

# Generate and upload to Supabase
python mobile/scripts/sync_wordzoo.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --output ./mobile/data/data-v1.0.0.json \
  --upload \
  --supabase-url "https://your-project.supabase.co" \
  --supabase-key "your-service-role-key"
```

Hoặc dùng environment variables:
```bash
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_KEY="your-service-role-key"

python mobile/scripts/sync_wordzoo.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --upload
```

## Output data.json

Script sẽ generate `data.json` với cấu trúc:

```json
{
  "version": "1.0.0",
  "last_updated": "2025-01-01T00:00:00Z",
  "categories": [
    {
      "id": "animals",
      "type": "animals",
      "names": {
        "vi": "Animals",
        "en": "Animals",
        "zh": "Animals"
      },
      "icon": "animals/icon.png",
      "background": "animals/background.png",
      "signpost_style": "default",
      "subcategories": [
        {
          "id": "wild_animals",
          "names": {
            "vi": "Wild Animals",
            "en": "Wild Animals",
            "zh": "Wild Animals"
          },
          "icon": "animals/sub_categorys/wild_animals/icon.png",
          "entities": [
            {
              "id": "lion",
              "isPremium": false,
              "names": {
                "vi": "Lion",
                "en": "Lion",
                "zh": "Lion"
              },
              "animation_image": "animals/sub_categorys/wild_animals/entitys/lion/animation.json",
              "real_image": "animals/sub_categorys/wild_animals/entitys/lion/icon.png",
              "audio_names": {
                "vi": "animals/sub_categorys/wild_animals/entitys/lion/LocalizedNames/name_vi/audio.wav",
                "en": "animals/sub_categorys/wild_animals/entitys/lion/LocalizedNames/name_en/audio.wav",
                "zh": "animals/sub_categorys/wild_animals/entitys/lion/LocalizedNames/name_zh/audio.wav"
              },
              "sound_effect": "animals/sub_categorys/wild_animals/entitys/lion/sound_effect.wav",
              "type_tags": [],
              "difficulty": 1
            }
          ]
        }
      ]
    }
  ]
}
```

## Lưu ý

1. **Cấu trúc thư mục phải đúng**:
   - `LocalizedNames/name_vi/audio.wav`
   - `LocalizedNames/name_en/audio.wav`
   - `LocalizedNames/name_zh/audio.wav`
   - `entitys/` (not `entities/`)
   - `sub_categorys/` (not `subcategories/`)

2. **Audio files**:
   - Có thể dùng bất kỳ extension nào: `.wav`, `.mp3`, `.m4a`
   - Script sẽ giữ nguyên extension trong path

3. **Category type mapping**:
   - Folder `animals` → `CategoryType.animals`
   - Folder `plants` → `CategoryType.plants`
   - Folder `vehicles` → `CategoryType.vehicles`
   - Folder `human_relations` → `CategoryType.humanRelations`

4. **Upload**:
   - Script upload toàn bộ files trong `wordzoo/` lên bucket `assets`
   - Cấu trúc thư mục được giữ nguyên
   - Nếu file đã tồn tại, sẽ bị overwrite

## Troubleshooting

### Lỗi: "supabase-py not installed"
```bash
pip install supabase
```

### Lỗi: "SUPABASE_URL not set"
```bash
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_KEY="your-service-role-key"
```

### Files không upload đúng cấu trúc
Kiểm tra:
1. Bucket `assets` và `data` đã tạo chưa
2. Service role key có quyền upload không
3. Storage policies đã set chưa

SUPABASE_URL=https://csvlyadhslkpanqfocre.supabase.co
SUPABASE_ANON_KEY=sb_publishable_aweNe_u7DiW_5B-HYdnc8w_jT3wvegP


python sync_wordzoo.py --wordzoo-dir "./wordzoo" --json-file "./data_version1_final.json" --version 1.0.0 --upload --supabase-url https://csvlyadhslkpanqfocre.supabase.co --supabase-key eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNzdmx5YWRoc2xrcGFucWZvY3JlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NTA4ODI1NiwiZXhwIjoyMTAwNjY0MjU2fQ.zKKxspsquEamJIT-IOb_oV8SIaB-JSpqIKzhiCHuc4o


python ..\..\sync_wordzoo.py --wordzoo-dir "./wordzoo" --json-file "./data_version1_final.json" --version 1.0.12 --upload --supabase-url https://csvlyadhslkpanqfocre.supabase.co --supabase-key eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNzdmx5YWRoc2xrcGFucWZvY3JlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NTA4ODI1NiwiZXhwIjoyMTAwNjY0MjU2fQ.zKKxspsquEamJIT-IOb_oV8SIaB-JSpqIKzhiCHuc4o
