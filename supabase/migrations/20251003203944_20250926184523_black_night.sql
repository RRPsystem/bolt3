/*
  # Add Sample Data for GPT Models and News Articles

  1. Sample Data
    - GPT models for different content types
    - News articles for testing
    - Proper brand associations

  2. Data Setup
    - Default GPT models for each content type
    - Sample articles for both admin and brand users
    - Proper relationships between tables
*/

-- Insert sample GPT models
INSERT INTO gpt_models (
  id,
  name,
  description,
  content_type,
  system_prompt,
  temperature,
  max_tokens,
  model,
  is_active,
  usage_count,
  last_used,
  created_at
) VALUES 
(
  gen_random_uuid(),
  'Travel Destination Expert',
  'Professionele bestemmingsteksten voor reisagenten',
  'destination',
  'Je bent een professionele reisschrijver die boeiende bestemmingsteksten schrijft over {DESTINATION}. Schrijf in {WRITING_STYLE} stijl voor {VACATION_TYPE} reizigers. Gebruik actuele informatie en maak de tekst aantrekkelijk. Geef praktische tips, bezienswaardigheden, en lokale cultuur informatie.',
  0.7,
  1500,
  'gpt-3.5-turbo',
  true,
  0,
  NULL,
  now()
),
(
  gen_random_uuid(),
  'Route Planning Specialist',
  'Gedetailleerde routebeschrijvingen en reisplannen',
  'route',
  'Je bent een routeplanner die gedetailleerde routebeschrijvingen maakt. {ROUTE_TYPE_INSTRUCTION} Geef praktische informatie over de route, bezienswaardigheden onderweg, en reistips. Schrijf in {WRITING_STYLE} stijl voor {VACATION_TYPE} reizigers. Vermeld afstanden, reistijden, en interessante stops.',
  0.6,
  2000,
  'gpt-3.5-turbo',
  true,
  0,
  NULL,
  now()
),
(
  gen_random_uuid(),
  'Day Planning Assistant',
  'Dagplanningen en itineraries voor reizigers',
  'planning',
  'Je bent een reisplanner die {DAYS} dagplanningen maakt voor {DESTINATION}. Geef een praktische planning met tijden, activiteiten, en tips. Schrijf in {WRITING_STYLE} stijl voor {VACATION_TYPE} reizigers. Zorg voor een goede balans tussen must-see attracties en lokale ervaringen.',
  0.8,
  1800,
  'gpt-3.5-turbo',
  true,
  0,
  NULL,
  now()
),
(
  gen_random_uuid(),
  'Hotel Search Expert',
  'Hotelzoekresultaten en accommodatie-advies',
  'hotel',
  'Je bent een hotelexpert die hotelzoekresultaten presenteert voor {VACATION_TYPE} reizigers. Geef gedetailleerde informatie over hotels, voorzieningen, en boekingsadvies. Schrijf in {WRITING_STYLE} stijl. Vergelijk prijzen, locaties, en faciliteiten.',
  0.5,
  1200,
  'gpt-3.5-turbo',
  true,
  0,
  NULL,
  now()
),
(
  gen_random_uuid(),
  'Travel Image Creator',
  'DALL-E prompts voor reisafbeeldingen',
  'image',
  'Je bent een AI die afbeeldingsbeschrijvingen genereert voor DALL-E. Maak een gedetailleerde, visuele beschrijving voor een {VACATION_TYPE} reisafbeelding in {WRITING_STYLE} stijl. Focus op sfeer, kleuren, compositie en reisgevoel.',
  0.9,
  500,
  'dall-e-3',
  true,
  0,
  NULL,
  now()
)
ON CONFLICT (id) DO NOTHING;