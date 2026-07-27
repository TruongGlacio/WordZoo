-- Storage policies for Supabase Storage

-- Bucket: assets (public read)
create policy "Public read access for assets"
  on storage.objects for select
  using (bucket_id = 'assets');

create policy "Service role can upload assets"
  on storage.objects for insert
  with check (bucket_id = 'assets' and auth.role() = 'service_role');

create policy "Service role can update assets"
  on storage.objects for update
  using (bucket_id = 'assets' and auth.role() = 'service_role');

create policy "Service role can delete assets"
  on storage.objects for delete
  using (bucket_id = 'assets' and auth.role() = 'service_role');

-- Bucket: data (private, only service role)
create policy "Service role can manage data files"
  on storage.objects for all
  using (bucket_id = 'data' and auth.role() = 'service_role');
