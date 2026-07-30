# WordZoo Data Generator

Script này tự động generate `data.json` từ cấu trúc thư mục assets và file definitions.

## Cách dùng

### 1. Chuẩn bị thư mục assets

```
assets/
├── icons/
│   ├── animals.png
│   ├── plants.png
│   ├── vehicles.png
│   └── human_relations.png
├── backgrounds/
│   ├── animals.jpg
│   ├── plants.jpg
│   ├── vehicles.jpg
│   └── human_relations.jpg
├── images/
│   ├── lion.png
│   ├── elephant.png
│   └── ...
├── animations/
│   ├── lion.json
│   └── ...
├── audio/
│   ├── vi/
│   │   ├── lion.mp3
│   │   └── ...
│   ├── en/
│   │   ├── lion.mp3
│   │   └── ...
│   ├── zh/
│   │   ├── lion.mp3
│   │   └── ...
│   └── sfx/
│       ├── roar.mp3
│       └── ...
└── definitions/
    ├── animals_wild.csv
    ├── plants_flowers.csv
    └── ...
```

### 2. Tạo file definitions cho mỗi subcategory

Mỗi subcategory có 1 file CSV trong `assets/definitions/`:

**File:** `assets/definitions/animals_wild.csv`
```csv
id,vi,en,zh,is_premium,difficulty,tags
lion,Sư tử,Lion,狮子,false,1,wild,mammal,predator
elephant,Voọc elephant,Elephant,大象,false,1,wild,mammal,herbivore
tiger,Hổ,Tiger,老虎,false,1,wild,mammal,predator
giraffe,Hươu cao cổ,Giraffe,长颈鹿,false,1,wild,mammal,herbivore
```

**File:** `assets/definitions/animals_farm.csv`
```csv
id,vi,en,zh,is_premium,difficulty,tags
cow,Bò,Cow,牛,false,1,farm,mammal,herbivore
pig,Lợn,Pig,猪,false,1,farm,mammal,omnivore
sheep,Cừu,Sheep,羊,false,1,farm,mammal,herbivore
chicken,Gà,Chicken,鸡,false,1,farm,bird,omnivore
```

### 3. Chạy script

```bash
cd mobile/scripts
python generate_data.py \
  --assets-dir ../assets \
  --output ../data/data-v1.0.0.json \
  --version 1.0.0
```

### 4. Script sẽ:
- Quét toàn bộ files trong `assets/images/`, `assets/audio/`, etc.
- Đọc các file CSV definitions
- Match entity_id với filename
- Tạo `data.json` hoàn chỉnh với đầy đủ:
  - `names` (vi/en/zh) từ CSV
  - `real_image`: `assets/images/{id}.png`
  - `animation_image`: `assets/animations/{id}.json` (nếu có)
  - `audio_names`: `assets/audio/vi/{id}.mp3`, etc.
  - `sound_effect`: `assets/audio/sfx/{id}.mp3` (nếu có)
  - `type_tags`: từ CSV
  - `difficulty`: từ CSV

## CSV Format

Mỗi file CSV đại diện cho 1 subcategory:

```csv
id,vi,en,zh,is_premium,difficulty,tags
entity_id,Tên VI,Tên EN,Tên ZH,true/false,1-5,tag1,tag2,tag3
```

**Columns:**
- `id`: entity ID (không có extension, ví dụ: `lion`)
- `vi`: tên tiếng Việt
- `en`: tên tiếng Anh
- `zh`: tên tiếng Trung
- `is_premium`: `true` hoặc `false`
- `difficulty`: 1-5
- `tags`: các tags phân loại, phân cách bằng dấu phẩy

**Ví dụ:**
```csv
id,vi,en,zh,is_premium,difficulty,tags
lion,Sư tử,Lion,狮子,false,1,wild,mammal,predator
elephant,Voọc elephant,Elephant,大象,true,2,wild,mammal,herbivore
```

## Output

Script sẽ tạo file `data-v1.0.0.json` với cấu trúc:

```json
{
  "version": "1.0.0",
  "last_updated": "2025-01-01T00:00:00Z",
  "categories": [
    {
      "id": "animals",
      "type": "animals",
      "names": {"vi": "Động vật", "en": "Animals", "zh": "动物"},
      "icon": "assets/icons/animals.png",
      "background": "assets/backgrounds/animals.jpg",
      "signpost_style": "default",
      "subcategories": [
        {
          "id": "wild_animals",
          "names": {"vi": "Động vật hoang dã", "en": "Wild Animals", "zh": "野生动物"},
          "entities": [
            {
              "id": "lion",
              "isPremium": false,
              "names": {"vi": "Sư tử", "en": "Lion", "zh": "狮子"},
              "animation_image": "assets/animations/lion.json",
              "real_image": "assets/images/lion.png",
              "audio_names": {
                "vi": "assets/audio/vi/lion.mp3",
                "en": "assets/audio/en/lion.mp3",
                "zh": "assets/audio/zh/lion.mp3"
              },
              "sound_effect": "assets/audio/sfx/lion.mp3",
              "type_tags": ["wild", "mammal", "predator"],
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

1. **File names phải khớp với entity ID**:
   - Nếu CSV có `id=lion`
   - Thì phải có files: `lion.png`, `lion.json` (animation), `lion.mp3` (audio)

2. **Nếu thiếu file**, script sẽ để path rỗng:
   - Thiếu `lion.json` → `animation_image: ""`
   - Thiếu `lion.mp3` trong `audio/sfx/` → `sound_effect: null`

3. **Script không validate** file có tồn tại hay không, chỉ generate path dựa trên ID

4. **Để thêm entity mới**, chỉ cần:
   - Thêm row vào CSV tương ứng
   - Thêm files vào assets folder
   - Chạy lại script

## Upload lên Supabase

Sau khi generate xong:

```bash
# 1. Upload assets
cd assets
for file in $(find . -type f); do
  supabase storage upload assets "$file"
done

# 2. Upload data.json
supabase storage upload data data-v1.0.0.json

# 3. Update version
supabase db execute "INSERT INTO data_versions (version, is_active, created_at) VALUES ('1.0.0', true, NOW()) ON CONFLICT (version) DO UPDATE SET is_active = true;"
```

Hoặc dùng script Python/Node.js đã có trong `data_upload_guide.md`.
