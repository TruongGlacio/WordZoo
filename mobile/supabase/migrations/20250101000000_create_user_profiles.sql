-- User profiles table
create table public.user_profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  display_name text,
  preferred_language text default 'vi' not null,
  avatar_url text,
  is_guest boolean default false not null,
  device_id text,
  is_premium boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table public.user_profiles enable row level security;

-- Policies
create policy "Users can view own profile"
  on public.user_profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.user_profiles for update
  using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.user_profiles for insert
  with check (auth.uid() = id);

-- Allow guest access via device_id token (for anon users)
create policy "Guest can view own profile by device_id"
  on public.user_profiles for select
  using (device_id = current_setting('request.jwt.claims')::json->>'device_id');

create policy "Guest can insert own profile by device_id"
  on public.user_profiles for insert
  with check (device_id = current_setting('request.jwt.claims')::json->>'device_id');

-- Indexes
create index if not exists idx_user_profiles_device_id on public.user_profiles(device_id);
create index if not exists idx_user_profiles_email on public.user_profiles(email);

-- Trigger for updated_at
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql security definer;

create trigger set_updated_at
  before update on public.user_profiles
  for each row execute function public.handle_updated_at();
