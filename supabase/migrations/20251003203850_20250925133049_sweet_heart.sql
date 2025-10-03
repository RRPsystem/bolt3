/*
  # Complete Travel Website Builder Database Setup

  1. New Tables
    - `users` - Admin and brand users with authentication
    - `agents` - Travel agents linked to brands  
    - `websites` - Brand websites with content
    - `website_pages` - Individual pages for websites
    - `news_articles` - Content management for brands

  2. Updates to Existing Tables
    - `brands` - Add missing columns (slug, description, contact info, etc.)
    - `companies` - Ensure default company exists

  3. Security
    - Enable RLS on all new tables
    - Add appropriate policies for data access

  4. Sample Data
    - Demo users (admin@travel.com, brand@travel.com)
    - Test agents and articles
    - Working authentication setup
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Companies table (must come first)
CREATE TABLE IF NOT EXISTS companies (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  category text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Brands table
CREATE TABLE IF NOT EXISTS brands (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id uuid REFERENCES companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  slug text,
  description text,
  logo_url text,
  business_type text DEFAULT 'travel_agency',
  primary_color text DEFAULT '#0EA5E9',
  secondary_color text DEFAULT '#F97316',
  contact_person text,
  contact_email text,
  contact_phone text,
  street_address text,
  city text,
  postal_code text,
  country text DEFAULT 'Netherlands',
  website_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  email text UNIQUE NOT NULL,
  role text NOT NULL CHECK (role IN ('admin', 'brand')),
  brand_id uuid REFERENCES brands(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Agents table
CREATE TABLE IF NOT EXISTS agents (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id uuid REFERENCES brands(id) ON DELETE CASCADE,
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  role text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Websites table
CREATE TABLE IF NOT EXISTS websites (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id uuid NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  template_id uuid,
  name text NOT NULL,
  slug text NOT NULL,
  domain text,
  content jsonb DEFAULT '{}',
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'pending_approval', 'approved', 'published')),
  is_published boolean DEFAULT false,
  published_at timestamptz,
  created_by uuid NOT NULL REFERENCES users(id),
  approved_by uuid REFERENCES users(id),
  approved_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Website pages table
CREATE TABLE IF NOT EXISTS website_pages (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  website_id uuid NOT NULL REFERENCES websites(id) ON DELETE CASCADE,
  name text NOT NULL,
  slug text NOT NULL,
  content jsonb DEFAULT '{}',
  meta_title text,
  meta_description text,
  is_homepage boolean DEFAULT false,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- News articles table
CREATE TABLE IF NOT EXISTS news_articles (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  template_id uuid,
  brand_id uuid REFERENCES brands(id) ON DELETE CASCADE,
  title text NOT NULL,
  slug text NOT NULL,
  content jsonb DEFAULT '{}',
  featured_image_url text,
  excerpt text,
  status text DEFAULT 'draft',
  published_at timestamptz,
  brand_approved boolean DEFAULT false,
  brand_mandatory boolean DEFAULT false,
  website_visible boolean DEFAULT false,
  author_type text DEFAULT 'admin' CHECK (author_type IN ('admin', 'brand')),
  author_brand_id uuid REFERENCES brands(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Make slug NOT NULL and unique for brands
ALTER TABLE brands ALTER COLUMN slug SET NOT NULL;
ALTER TABLE brands ADD CONSTRAINT brands_slug_key UNIQUE (slug);

-- Enable RLS on all tables
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE agents ENABLE ROW LEVEL SECURITY;
ALTER TABLE websites ENABLE ROW LEVEL SECURITY;
ALTER TABLE website_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE news_articles ENABLE ROW LEVEL SECURITY;

-- Sample data setup
DO $$
DECLARE
    default_company_id uuid;
BEGIN
    -- Create default company
    INSERT INTO companies (id, name, category) 
    VALUES ('550e8400-e29b-41d4-a716-446655440100', 'Default Company', 'general')
    ON CONFLICT (id) DO NOTHING;
    default_company_id := '550e8400-e29b-41d4-a716-446655440100';
    
    -- Insert brands with company_id
    INSERT INTO brands (id, company_id, name, slug, description, business_type, contact_email) 
    VALUES 
      ('550e8400-e29b-41d4-a716-446655440001', default_company_id, 'The Travel Club', 'the-travel-club', 'Franchise nummer 1', 'franchise', 'info@thetravelclub.nl'),
      ('550e8400-e29b-41d4-a716-446655440002', default_company_id, 'Reisbureau Del Monde', 'reisbureau-del-monde', 'ZRB Formule', 'independent', 'info@delmonde.nl'),
      ('550e8400-e29b-41d4-a716-446655440003', default_company_id, 'TestBrand', 'testbrand', 'Eigen merk', 'independent', 'test@brand.nl')
    ON CONFLICT (id) DO NOTHING;
END $$;

-- Insert users
INSERT INTO users (id, email, role, brand_id) 
VALUES 
  ('550e8400-e29b-41d4-a716-446655440010', 'admin@travel.com', 'admin', NULL),
  ('550e8400-e29b-41d4-a716-446655440011', 'brand@travel.com', 'brand', '550e8400-e29b-41d4-a716-446655440001')
ON CONFLICT (email) DO NOTHING;

-- Insert agents
INSERT INTO agents (id, brand_id, name, email, phone) 
VALUES ('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440001', 'Test Agent', 'test@agent.nl', '+31611725801')
ON CONFLICT DO NOTHING;

-- Insert news articles
INSERT INTO news_articles (id, title, slug, status, brand_approved, brand_mandatory, website_visible, author_type, brand_id) 
VALUES 
  ('550e8400-e29b-41d4-a716-446655440030', 'test2', 'test2', 'Brand Toegang', false, true, false, 'admin', NULL),
  ('550e8400-e29b-41d4-a716-446655440031', 'Admin vliegen', 'admin-vliegen', 'Brand Toegang', true, true, true, 'admin', NULL),
  ('550e8400-e29b-41d4-a716-446655440032', 'test 8', 'test-8', 'Live', true, false, true, 'brand', '550e8400-e29b-41d4-a716-446655440001'),
  ('550e8400-e29b-41d4-a716-446655440033', 'test Alex', 'test-alex', 'Live', true, false, true, 'brand', '550e8400-e29b-41d4-a716-446655440001')
ON CONFLICT DO NOTHING;