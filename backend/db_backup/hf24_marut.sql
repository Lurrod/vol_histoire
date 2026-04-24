-- Insertion dans airplanes
INSERT INTO airplanes (
    name,
    name_en,
    complete_name,
    complete_name_en,
    little_description,
    little_description_en,
    image_url,
    description,
    description_en,
    country_id,
    date_concept,
    date_first_fly,
    date_operationel,
    max_speed,
    max_range,
    id_manufacturer,
    id_generation,
    type,
    status,
    status_en,
    weight
) VALUES (
    'HAL HF-24 Marut',
    'HAL HF-24 Marut',
    'HAL HF-24 Marut (Indian Air Force)',
    'HAL HF-24 Marut (Indian Air Force)',
    'Premier chasseur-bombardier supersonique de conception indienne',
    'First supersonic fighter-bomber of Indian design',
    '/assets/airplanes/hal-hf-24-marut.jpg',
    'Le HAL HF-24 Marut ("Esprit de la Tempête") est le premier avion de combat à réaction de conception indienne, développé par Hindustan Aeronautics Limited sous la direction de l''ingénieur allemand Kurt Tank (ex-Focke-Wulf). Mis en service en 1967 par l''Indian Air Force, il a été engagé lors de la guerre indo-pakistanaise de 1971 dans des missions d''appui au sol où il s''est distingué par sa robustesse. Ses performances supersoniques ont été limitées par l''absence d''un réacteur national à postcombustion digne de ses aptitudes aérodynamiques. Retiré en 1990.',
    'The HAL HF-24 Marut ("Spirit of the Storm") is the first jet combat aircraft of Indian design, developed by Hindustan Aeronautics Limited under the leadership of German engineer Kurt Tank (formerly of Focke-Wulf). Entered service in 1967 with the Indian Air Force, it was deployed during the 1971 Indo-Pakistani War in ground attack missions where it stood out for its ruggedness. Its supersonic performance was held back by the lack of a domestic afterburning engine worthy of its aerodynamic potential. Retired in 1990.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1956-01-01',
    '1961-06-17',
    '1967-04-01',
    1112.0,
    400.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired',
    6195.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.87, wingspan = 9.00, height = 3.60, wing_area = 28.00,
  empty_weight = 6195, mtow = 10908, service_ceiling = 13716, climb_rate = 23,
  combat_radius = 400, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'HAL (Bristol Siddeley) Orpheus Mk 703', engine_count = 2,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 21.6, thrust_wet = NULL,
  production_start = 1964, production_end = 1977, units_built = 147,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_HF-24_Marut',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_HF-24_Marut'
WHERE name = 'HAL HF-24 Marut';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 2200000, unit_cost_year = 1967,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **HF-24 Mk1** : production monoplace de série (1967)\n- **HF-24 Mk1T** : version biplace d''entraînement (1970)\n- **HF-24 Mk2** : projet avec postcombustion Orpheus BOr.12 — annulé faute de financement britannique',
  variants_en = E'- **HF-24 Mk1** : main production single-seat variant (1967)\n- **HF-24 Mk1T** : two-seat trainer version (1970)\n- **HF-24 Mk2** : proposed variant with afterburning Orpheus BOr.12 — cancelled due to lack of UK funding'
WHERE name = 'HAL HF-24 Marut';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme lancé en **1956** sous la direction de l''ingénieur allemand **Kurt Tank** (ex-Focke-Wulf, créateur du Fw 190), recruté par HAL pour doter l''Inde de son premier chasseur national. Premier vol du prototype le **17 juin 1961**, mise en service en **1967**.\n\n## Carrière opérationnelle\n**147 exemplaires produits** en 13 ans. Engagé lors de la **Guerre indo-pakistanaise de 1971**, où il a remarquablement performé en appui au sol grâce à sa robustesse et sa stabilité à basse altitude. Les pilotes le surnomment "the flying tank" en référence à sa capacité d''encaisser les tirs de DCA.\n\n## Héritage\nPremier avion de combat à réaction **entièrement conçu hors des États-Unis, d''Europe ou d''URSS**. Limité dans ses performances supersoniques par l''absence d''un Orpheus à postcombustion (projet Mk2 annulé). A posé les fondations techniques de HAL qui produit aujourd''hui le Tejas et le Su-30MKI. Retiré en **1990**.',
  description_en = E'## Genesis\nProgramme launched in **1956** under the direction of German engineer **Kurt Tank** (formerly of Focke-Wulf, creator of the Fw 190), recruited by HAL to give India its first domestic fighter. First prototype flight on **17 June 1961**, service entry in **1967**.\n\n## Operational career\n**147 examples built** over 13 years. Deployed during the **1971 Indo-Pakistani War**, where it performed remarkably well in ground support thanks to its ruggedness and low-altitude stability. Pilots nicknamed it "the flying tank" for its ability to absorb anti-aircraft fire.\n\n## Legacy\nFirst jet combat aircraft **entirely designed outside the United States, Europe or the USSR**. Limited in its supersonic performance by the absence of an afterburning Orpheus (Mk2 project cancelled). Laid the technical foundations of HAL which now produces the Tejas and Su-30MKI. Retired in **1990**.'
WHERE name = 'HAL HF-24 Marut';
