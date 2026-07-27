-- IAP products table
create table public.iap_products (
  id text primary key,
  platform text not null check (platform in ('ios', 'android')),
  type text not null check (type in ('subscription', 'non_consumable', 'consumable')),
  price text,
  title text,
  description text,
  is_active boolean default true not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- User IAP entitlements table
create table public.user_iap_entitlements (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users on delete cascade not null,
  product_id text references public.iap_products(id) not null,
  platform text not null,
  transaction_id text not null unique,
  receipt_data text,
  is_active boolean default true not null,
  expires_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  constraint unique_user_product unique (user_id, product_id)
);

-- Enable RLS
alter table public.iap_products enable row level security;
alter table public.user_iap_entitlements enable row level security;

-- Policies for iap_products
create policy "Anyone can view active IAP products"
  on public.iap_products for select
  using (is_active = true);

create policy "Service role can manage IAP products"
  on public.iap_products for all
  using (auth.role() = 'service_role');

-- Policies for user_iap_entitlements
create policy "Users can view own entitlements"
  on public.user_iap_entitlements for select
  using (auth.uid() = user_id);

create policy "Users can insert own entitlements"
  on public.user_iap_entitlements for insert
  with check (auth.uid() = user_id);

create policy "Users can update own entitlements"
  on public.user_iap_entitlements for update
  using (auth.uid() = user_id);

-- Indexes
create index if not exists idx_iap_products_platform on public.iap_products(platform);
create index if not exists idx_user_iap_entitlements_user_id on public.user_iap_entitlements(user_id);
create index if not exists idx_user_iap_entitlements_product_id on public.user_iap_entitlements(product_id);

-- Insert default IAP products
insert into public.iap_products (id, platform, type, title, description)
values 
  ('premium_monthly', 'android', 'subscription', 'Premium Monthly', 'Monthly subscription'),
  ('premium_yearly', 'ios', 'subscription', 'Premium Yearly', 'Yearly subscription');

-- Trigger for updated_at
create trigger set_updated_at
  before update on public.iap_products
  for each row execute function public.handle_updated_at();

create trigger set_updated_at
  before update on public.user_iap_entitlements
  for each row execute function public.handle_updated_at();
