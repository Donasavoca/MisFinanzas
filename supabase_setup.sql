-- ================================================================
-- MisFinanzas - Supabase Setup
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query
-- ================================================================

-- 1. Tabla principal: un registro por usuario con todos los datos
create table if not exists user_data (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- 2. Habilitar Row Level Security (cada usuario solo ve sus datos)
alter table user_data enable row level security;

-- 3. Policies
create policy "select_own" on user_data
  for select using (auth.uid() = user_id);

create policy "insert_own" on user_data
  for insert with check (auth.uid() = user_id);

create policy "update_own" on user_data
  for update using (auth.uid() = user_id);

create policy "delete_own" on user_data
  for delete using (auth.uid() = user_id);

-- 4. Habilitar Realtime para sincronización entre dispositivos
alter publication supabase_realtime add table user_data;

-- ================================================================
-- CONFIGURACIÓN EN EL DASHBOARD DE SUPABASE:
--
-- Authentication → Email:
--   - Enable email provider: ON
--   - Confirm email: OFF  (para que el magic link funcione sin confirmación)
--   - Enable magic links: ON
--
-- Authentication → URL Configuration:
--   - Site URL: https://TU_USUARIO.github.io/MisFinanzas
--   - Redirect URLs: https://TU_USUARIO.github.io/MisFinanzas
-- ================================================================
