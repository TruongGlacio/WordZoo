# Sync to Supabase

Script này đọc thư mục `wordzoo/` local và:
1. Generate `data.json`
2. Upload toàn bộ media files + data.json lên Supabase Storage
3. Update `data_versions` table

## Cấu trúc thư mục local

Tạo thư mục `wordzoo/` với cấu trúc:

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
│       │       │   └── sound_effect.wav  (optional)
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

## Quy tắc đặt tên

### Category
- Folder name: `animals`, `plants`, `vehicles`, `human_relations`
- Files: `icon.png`, `background.png`
- Optional: `LocalizedNames/name_{vi|en|zh}/audio.wav` (audio đọc tên category)

### Subcategory
- Folder name: `wild_animals`, `farm_animals`, etc.
- Files: `icon.png`, `background.png`
- Optional: `LocalizedNames/name_{vi|en|zh}/audio.wav`

### Entity
- Folder name: `lion`, `elephant`, etc. (entity ID)
- Files:
  - `icon.png` - ảnh thực tế
  - `animation.json` (optional) - animation file
  - `sound_effect.wav` (optional) - hiệu ứng âm thanh
- Required: `LocalizedNames/name_{vi|en|zh}/audio.wav` - audio phát âm tên

## Cách dùng

### 1. Cấu trúc thư mục

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

### 2. Thêm dữ liệu

Thêm files vào đúng cấu trúc:
- Icons: `wordzoo/animals/icon.png`
- Backgrounds: `wordzoo/animals/background.png`
- Entity images: `wordzoo/animals/sub_categorys/wild_animals/entitys/lion/icon.png`
- Entity audio: `wordzoo/animals/sub_categorys/wild_animals/entitys/lion/LocalizedNames/name_vi/audio.wav`

### 3. Chạy script

```bash
# Generate data.json only
python mobile/scripts/sync_to_supabase.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --output ./mobile/data/data-v1.0.0.json

# Generate and upload to Supabase
python mobile/scripts/sync_to_supabase.py \
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

python mobile/scripts/sync_to_supabase.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --upload
```

## Mapping từ local sang Supabase Storage

| Local Path | Storage Path | Bucket |
|------------|--------------|--------|
| `wordzoo/{category}/icon.png` | `assets/icons/{category}.png` | assets |
| `wordzoo/{category}/background.png` | `assets/backgrounds/{category}.jpg` | assets |
| `wordzoo/{category}/sub_categorys/{sub}/icon.png` | `assets/sub_category_avata/{sub}.png` | assets |
| `wordzoo/{category}/sub_categorys/{sub}/entitys/{entity}/icon.png` | `assets/images/{entity}.png` | assets |
| `wordzoo/{category}/sub_categorys/{sub}/entitys/{entity}/animation.json` | `assets/animations/{entity}.json` | assets |
| `wordzoo/{category}/sub_categorys/{sub}/entitys/{entity}/sound_effect.wav` | `assets/audio/sfx/{entity}.mp3` | assets |
| `wordzoo/{category}/LocalizedNames/name_{lang}/audio.wav` | `assets/audio/{lang}/{category}.mp3` | assets |
| `wordzoo/{category}/sub_categorys/{sub}/LocalizedNames/name_{lang}/audio.wav` | `assets/audio/{lang}/{sub}.mp3` | assets |
| `wordzoo/{category}/sub_categorys/{sub}/entitys/{entity}/LocalizedNames/name_{lang}/audio.wav` | `assets/audio/{lang}/{entity}.mp3` | assets |

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
        "vi": "Động vật",
        "en": "Animals",
        "zh": "动物"
      },
      "icon": "assets/icons/animals.png",
      "background": "assets/backgrounds/animals.jpg",
      "signpost_style": "default",
      "subcategories": [
        {
          "id": "wild_animals",
          "names": {
            "vi": "Động vật hoang dã",
            "en": "Wild Animals",
            "zh": "野生动物"
          },
          "icon": "assets/sub_category_avata/wild_animals.png",
          "entities": [
            {
              "id": "lion",
              "isPremium": false,
              "names": {
                "vi": "Sư tử",
                "en": "Lion",
                "zh": "狮子"
              },
              "animation_image": "assets/animations/lion.json",
              "real_image": "assets/images/lion.png",
              "audio_names": {
                "vi": "assets/audio/vi/lion.mp3",
                "en": "assets/audio/en/lion.mp3",
                "zh": "assets/audio/zh/lion.mp3"
              },
              "sound_effect": "assets/audio/sfx/lion.mp3",
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

1. **Tên folder phải khớp với entity ID**:
   - Folder `lion` → entity ID = `lion`
   - File `audio.wav` bên trong `LocalizedNames/name_vi/` → audio cho language `vi`

2. **Audio files**:
   - Có thể dùng bất kỳ extension nào: `.wav`, `.mp3`, `.m4a`
   - Script sẽ tự động map sang `.mp3` trong JSON (để khớp với app)
   - Upload lên Supabase sẽ giữ nguyên extension gốc

3. **Category type mapping**:
   - Folder `animals` → `CategoryType.animals`
   - Folder `plants` → `CategoryType.plants`
   - Folder `vehicles` → `CategoryType.vehicles`
   - Folder `human_relations` → `CategoryType.humanRelations`
   - Nếu folder name không khớp, script sẽ dùng folder name làm type

4. **Script không validate**:
   - Không kiểm tra file có tồn tại không
   - Không kiểm tra audio có hợp lệ không
   - Chỉ generate path dựa trên cấu trúc folder

5. **Upload**:
   - Script sẽ upload toàn bộ files trong `wordzoo/` lên Supabase
   - Nếu file đã tồn tại, sẽ bị overwrite
   - Upload song song không, từng file tuần tự

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

### Files không upload đúng bucket
Kiểm tra:
1. Bucket `assets` và `data` đã tạo chưa
2. Service role key có quyền upload không
3. Storage policies đã set chưa

### data.json không đúng format
Kiểm tra:
1. File `data.json` đã generate đúng chưa (mở file xem)
2. Version có khớp với `data_versions` table không
3. JSON có valid không (dùng jsonlint.com)
