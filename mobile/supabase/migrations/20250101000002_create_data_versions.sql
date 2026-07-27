-- Data versions table
create table public.data_versions (
  id bigint generated always as identity primary key,
  version text not null unique,
  file_url text not null,
  is_active boolean default true not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table public.data_versions enable row level security;

-- Policies (public read, admin write)
create policy "Anyone can view active data versions"
  on public.data_versions for select
  using (true);

create policy "Service role can manage data versions"
  on public.data_versions for all
  using (auth.role() = 'service_role');

-- Insert default version
insert into public.data_versions (version, file_url, is_active)
values ('1.0.0', 'https://example.com/data-v1.0.0.json', true);

-- Trigger for updated_at
create trigger set_updated_at
  before update on public.data_versions
  for each row execute function public.handle_updated_at();
