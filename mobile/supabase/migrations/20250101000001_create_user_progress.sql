-- User progress table
create table public.user_progress (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users on delete cascade not null,
  entity_id text not null,
  category_type text not null,
  subcategory_id text not null,
  is_learned boolean default false not null,
  is_favorite boolean default false not null,
  last_practiced_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  constraint unique_user_entity unique (user_id, entity_id)
);

-- Enable RLS
alter table public.user_progress enable row level security;

-- Policies
create policy "Users can view own progress"
  on public.user_progress for select
  using (auth.uid() = user_id);

create policy "Users can insert own progress"
  on public.user_progress for insert
  with check (auth.uid() = user_id);

create policy "Users can update own progress"
  on public.user_progress for update
  using (auth.uid() = user_id);

create policy "Users can delete own progress"
  on public.user_progress for delete
  using (auth.uid() = user_id);

-- Indexes
create index if not exists idx_user_progress_user_id on public.user_progress(user_id);
create index if not exists idx_user_progress_entity_id on public.user_progress(entity_id);
create index if not exists idx_user_progress_category on public.user_progress(category_type);

-- Trigger for updated_at
create trigger set_updated_at
  before update on public.user_progress
  for each row execute function public.handle_updated_at();
