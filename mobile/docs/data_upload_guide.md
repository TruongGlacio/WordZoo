# Data Upload Guide

## Mục đích
Hướng dẫn upload/update dữ liệu (ảnh, audio, text names, JSON) lên Supabase để app có thể đồng bộ về client.

## Prerequisites
- Đã có Supabase project
- Đã chạy migrations trong `supabase/migrations/`
- Đã tạo 2 storage buckets: `assets` (public) và `data` (private)
- Có quyền truy cập Supabase Dashboard hoặc CLI
- Python 3.8+ installed

---

## 1. Cấu trúc thư mục local

Tạo thư mục `wordzoo/` ở root project (cùng cấp với `mobile/`):

```
WordZoo/
├── wordzoo/
│   ├── animals/
│   │   ├── LocalizedNames/
│   │   │   ├── name_vi/
│   │   │   │   └── audio.wav
│   │   │   ├── name_en/
│   │   │   │   └── audio.wav
│   │   │   └── name_zh/
│   │   │       └── audio.wav
│   │   ├── icon.png
│   │   ├── background.png
│   │   └── sub_categorys/
│   │       ├── wild_animals/
│   │       │   ├── LocalizedNames/
│   │       │   │   ├── name_vi/
│   │       │   │   │   └── audio.wav
│   │       │   │   ├── name_en/
│   │       │   │   │   └── audio.wav
│   │       │   │   └── name_zh/
│   │       │   │       └── audio.wav
│   │       │   ├── icon.png
│   │       │   ├── background.png
│   │       │   └── entitys/
│   │       │       ├── lion/
│   │       │       │   ├── icon.png
│   │       │       │   ├── LocalizedNames/
│   │       │       │   │   ├── name_vi/
│   │       │       │   │   │   └── audio.wav
│   │       │       │   │   ├── name_en/
│   │       │       │   │   │   └── audio.wav
│   │       │       │   │   └── name_zh/
│   │       │       │   │       └── audio.wav
│   │       │       │   └── sound_effect.wav
│   │       │       └── elephant/
│   │       │           └── ...
│   │       └── farm_animals/
│   │           └── ...
│   ├── plants/
│   │   └── ...
│   ├── vehicles/
│   │   └── ...
│   └── human_relations/
│       └── ...
└── mobile/
    └── ...
```

## 2. Quy tắc đặt tên

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

## 3. Cách dùng script

### 3.1 Cài đặt Python dependencies

```bash
pip install supabase
```

### 3.2 Chạy script

```bash
# Generate data.json only (không upload)
python mobile/scripts/sync_wordzoo.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --output ./mobile/data/data-v1.0.0.json

# Generate và upload lên Supabase
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
# Windows
set SUPABASE_URL=https://your-project.supabase.co
set SUPABASE_KEY=your-service-role-key

# Mac/Linux
export SUPABASE_URL=https://your-project.supabase.co
export SUPABASE_KEY=your-service-role-key

# Chạy script
python mobile/scripts/sync_wordzoo.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --upload
```

## 4. Upload qua Supabase Dashboard (thủ công)

Nếu không muốn dùng script, bạn có thể upload thủ công:

### 4.1 Upload media files

1. Vào **Supabase Dashboard → Storage**
2. Chọn bucket **`assets`**
3. Tạo cấu trúc thư mục giống hệt local:
   ```
   assets/
   ├── animals/
   │   ├── LocalizedNames/
   │   │   ├── name_vi/
   │   │   ├── name_en/
   │   │   └── name_zh/
   │   ├── icon.png
   │   ├── background.png
   │   └── sub_categorys/
   │       ├── wild_animals/
   │       │   ├── LocalizedNames/
   │       │   │   ├── name_vi/
   │       │   │   ├── name_en/
   │       │   │   └── name_zh/
   │       │   ├── icon.png
   │       │   ├── background.png
   │       │   └── entitys/
   │       │       ├── lion/
   │       │       │   ├── icon.png
   │       │       │   ├── LocalizedNames/
   │       │       │   │   ├── name_vi/
   │       │       │   │   ├── name_en/
   │       │       │   │   └── name_zh/
   │       │       │   └── sound_effect.wav
   │       │       └── elephant/
   │       │           └── ...
   │       └── farm_animals/
   │           └── ...
   ├── plants/
   └── ...
   ```
4. Upload files vào đúng thư mục

### 4.2 Upload data.json

1. Vào **Supabase Dashboard → Storage**
2. Chọn bucket **`data`**
3. Upload file `data-v1.0.0.json`

### 4.3 Cập nhật version

1. Vào **Supabase Dashboard → Table Editor**
2. Chọn bảng **`data_versions`**
3. Insert hoặc update record:
   ```sql
   INSERT INTO data_versions (version, is_active, created_at)
   VALUES ('1.0.0', true, NOW())
   ON CONFLICT (version) DO UPDATE SET is_active = true;
   ```
4. Đảm bảo chỉ có 1 record có `is_active = true`

## 5. Output data.json

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

## 6. Verification

### 6.1 Kiểm tra Storage
- Vào **Supabase Dashboard → Storage**
- Kiểm tra đủ files trong đúng cấu trúc thư mục

### 6.2 Kiểm tra data.json
- Download file `data-v1.0.0.json` từ Storage
- Validate JSON format: https://jsonlint.com/

### 6.3 Kiểm tra database
```sql
-- Check data_versions
SELECT * FROM data_versions;

-- Should show:
-- version | is_active | created_at
-- 1.0.0   | true      | 2025-01-01 00:00:00
```

### 6.4 Test trên app
```dart
final dataSyncRepo = DataSyncRepositoryImpl.instance;

// Force sync
await dataSyncRepo.syncData();

// Check cached data
final cached = await dataSyncRepo.getCachedData();
print('Categories: ${cached?.categories.length}');
print('Version: ${cached?.version}');
```

## 7. Update dữ liệu (version mới)

Khi cần update dữ liệu:

1. Thêm/sửa/xóa files trong thư mục `wordzoo/`
2. Tăng version: `--version 1.0.1`
3. Chạy lại script:
   ```bash
   python mobile/scripts/sync_wordzoo.py \
     --wordzoo-dir ./wordzoo \
     --version 1.0.1 \
     --upload
   ```

App sẽ tự động:
- `needsUpdate()` phát hiện version mới
- `syncData()` download `data-v1.0.1.json` + media files
- `_cacheMediaFromJson()` cache tất cả media files

## 8. Common Pitfalls

1. **Cấu trúc thư mục sai**:
   - Phải đúng: `LocalizedNames/name_vi/audio.wav`
   - Không được: `localizednames/name_vi/audio.wav` (case-sensitive)

2. **Quên upload `data.json`**:
   - App cần `data.json` để biết cấu trúc dữ liệu
   - Phải upload lên bucket `data` sau mỗi lần thay đổi

3. **Quên update `data_versions`**:
   - App chỉ sync khi `remoteVersion != localVersion`
   - Nếu không update table, app sẽ không biết có data mới

4. **File names có ký tự đặc biệt**:
   - Tránh dùng spaces, accents, emoji trong file names
   - Ví dụ: `cây cọ.png` → `cay_co.png`

5. **Bucket permissions**:
   - `assets` phải public để app đọc trực tiếp (fallback)
   - `data` phải private, chỉ service_role được truy cập

## 9. Quick Reference

| Task | Command/URL |
|------|-------------|
| Generate data.json | `python mobile/scripts/sync_wordzoo.py --wordzoo-dir ./wordzoo --version 1.0.0 --output ./mobile/data/data.json` |
| Generate + Upload | `python mobile/scripts/sync_wordzoo.py --wordzoo-dir ./wordzoo --version 1.0.0 --upload` |
| Upload file qua Dashboard | Storage → bucket → Upload |
| Download file từ Storage | `supabase storage download <bucket> <remote_path>` |
| List files trong bucket | `supabase storage ls <bucket>` |
| Update version (SQL) | `INSERT INTO data_versions ...` |
| Check current version | `SELECT * FROM data_versions WHERE is_active = true;` |
| Force sync trong app | `await dataSyncRepo.syncData();` |
| Clear cache trong app | `await MediaCacheService.instance.clearCache();` |

## 10. Script Reference

### `sync_wordzoo.py`

Script chính để generate `data.json` và upload lên Supabase.

**Arguments:**
- `--wordzoo-dir`: Path to wordzoo folder (required)
- `--output`: Output JSON file path (optional)
- `--version`: Data version (default: 1.0.0)
- `--upload`: Upload to Supabase after generating
- `--supabase-url`: Supabase URL (or set `SUPABASE_URL` env var)
- `--supabase-key`: Supabase service role key (or set `SUPABASE_KEY` env var)

**Example:**
```bash
python mobile/scripts/sync_wordzoo.py \
  --wordzoo-dir ./wordzoo \
  --version 1.0.0 \
  --output ./mobile/data/data.json \
  --upload
```

### Output

Script sẽ:
1. Quét toàn bộ thư mục `wordzoo/`
2. Generate `data.json` với paths theo cấu trúc thư mục
3. Upload toàn bộ files lên bucket `assets` (giữ nguyên cấu trúc)
4. Upload `data.json` lên bucket `data`
5. Update `data_versions` table
