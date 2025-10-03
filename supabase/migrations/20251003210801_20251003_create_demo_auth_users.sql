/*
  # Create Demo Users in Supabase Auth

  1. Purpose
    - Create demo users that can authenticate through Supabase Auth
    - Enable login functionality
    
  2. Demo Users
    - admin@travel.com / admin123 (Admin role)
    - brand@travel.com / brand123 (Brand role, linked to The Travel Club)
    - operator@travel.com / operator123 (Operator role)

  3. Changes
    - Insert users into auth.users with encrypted passwords
    - Create auth.identities for email/password authentication
*/

-- Create extension if not exists
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Delete existing demo users
DELETE FROM auth.identities WHERE user_id IN (
  '550e8400-e29b-41d4-a716-446655440010',
  '550e8400-e29b-41d4-a716-446655440011',
  '550e8400-e29b-41d4-a716-446655440012'
);

DELETE FROM auth.users WHERE id IN (
  '550e8400-e29b-41d4-a716-446655440010',
  '550e8400-e29b-41d4-a716-446655440011',
  '550e8400-e29b-41d4-a716-446655440012'
);

-- Create Admin user
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  aud,
  role
) VALUES (
  '550e8400-e29b-41d4-a716-446655440010',
  '00000000-0000-0000-0000-000000000000',
  'admin@travel.com',
  crypt('admin123', gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"role":"admin"}',
  'authenticated',
  'authenticated'
);

-- Create Brand user
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  aud,
  role
) VALUES (
  '550e8400-e29b-41d4-a716-446655440011',
  '00000000-0000-0000-0000-000000000000',
  'brand@travel.com',
  crypt('brand123', gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"role":"brand"}',
  'authenticated',
  'authenticated'
);

-- Create Operator user
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  aud,
  role
) VALUES (
  '550e8400-e29b-41d4-a716-446655440012',
  '00000000-0000-0000-0000-000000000000',
  'operator@travel.com',
  crypt('operator123', gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"role":"operator"}',
  'authenticated',
  'authenticated'
);

-- Create identities for email/password auth
INSERT INTO auth.identities (
  provider_id,
  user_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
) VALUES
  (
    '550e8400-e29b-41d4-a716-446655440010',
    '550e8400-e29b-41d4-a716-446655440010',
    jsonb_build_object('sub', '550e8400-e29b-41d4-a716-446655440010', 'email', 'admin@travel.com'),
    'email',
    now(),
    now(),
    now()
  ),
  (
    '550e8400-e29b-41d4-a716-446655440011',
    '550e8400-e29b-41d4-a716-446655440011',
    jsonb_build_object('sub', '550e8400-e29b-41d4-a716-446655440011', 'email', 'brand@travel.com'),
    'email',
    now(),
    now(),
    now()
  ),
  (
    '550e8400-e29b-41d4-a716-446655440012',
    '550e8400-e29b-41d4-a716-446655440012',
    jsonb_build_object('sub', '550e8400-e29b-41d4-a716-446655440012', 'email', 'operator@travel.com'),
    'email',
    now(),
    now(),
    now()
  );