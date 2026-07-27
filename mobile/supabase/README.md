# Supabase Local Setup

## Prerequisites
- Supabase CLI installed (`npm install -g supabase`)
- Supabase project created

## Setup Steps

### 1. Initialize Supabase Local
```bash
supabase init
supabase start
```

### 2. Link to Remote Project
```bash
supabase link --project-ref <your-project-id>
```

### 3. Apply Migrations
```bash
supabase db push
```

Or apply manually via Supabase Dashboard:
1. Go to SQL Editor
2. Paste content from each file in `migrations/` folder in order
3. Run each migration

### 4. Create Storage Buckets
Via Supabase Dashboard > Storage:
- Create bucket `assets` (public)
- Create bucket `data` (private)

### 5. Upload Sample Data
```bash
# Upload data.json to data bucket
curl -X POST \
  "https://<your-project>.supabase.co/storage/v1/object/data/data-v1.0.0.json" \
  -H "Authorization: Bearer <service-role-key>" \
  -H "Content-Type: application/json" \
  --data-binary @data.json
```

### 6. Set Environment Variables
```bash
# mobile/.env
SUPABASE_URL=https://<your-project>.supabase.co
SUPABASE_ANON_KEY=<your-anon-key>
```

## Tables Created
- `user_profiles` - User accounts and profiles
- `user_progress` - Learning progress and favorites
- `data_versions` - Data.json version tracking
- `iap_products` - IAP product definitions
- `user_iap_entitlements` - User purchase records

## Storage Buckets
- `assets` - Images and audio files (public read)
- `data` - data.json files (private, app downloads via authenticated request)
