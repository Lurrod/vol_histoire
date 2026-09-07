-- Hawker Siddeley Nimrod MR2
--
-- Photo : XV233 Hawker Siddeley Nimrod MR2 RAF Fairford 20.7.91.jpg
--   licence CC BY-SA 4.0 — Colin Cooke Photo
--   https://commons.wikimedia.org/wiki/File%3AXV233_Hawker_Siddeley_Nimrod_MR2_RAF_Fairford_20.7.91.jpg

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
    status_en
) VALUES (
    'Hawker Siddeley Nimrod',
    'Hawker Siddeley Nimrod',
    'Hawker Siddeley Nimrod MR2',
    'Hawker Siddeley Nimrod MR2',
    'Le seul avion de patrouille maritime à réaction jamais produit en série',
    'The only jet-powered maritime patrol aircraft ever series-produced',
    '/assets/airplanes/nimrod.jpg',
    E'## Genèse\nLa Royal Air Force doit remplacer ses Shackleton à hélices, hérités du bombardier Lancaster. Tout le monde patrouille en turbopropulseur — c''est économique aux basses vitesses de recherche. Hawker Siddeley prend le contre-pied et propose de reprendre les cellules invendues du **de Havilland Comet**, le premier avion de ligne à réaction du monde, dont la production s''achève. Le choix est d''abord financier ; il produira le seul patrouilleur maritime à réaction de l''histoire.\n\n## Conception\nAu fuselage pressurisé du Comet est greffée une **soute non pressurisée** de plus de quinze mètres sous le plancher, capable d''emporter torpilles, bouées acoustiques et missiles. Un détecteur d''anomalies magnétiques allonge la queue. En patrouille, deux des quatre Spey sont coupés pour économiser le carburant ; en revanche, la vitesse de transit à réaction permet d''atteindre une zone de recherche bien plus vite qu''un turbopropulseur — l''argument décisif.\n\n## Carrière opérationnelle\nIl traque les sous-marins soviétiques dans l''Atlantique Nord pendant toute la guerre froide, vole les plus longues missions de la guerre des **Malouines** avec ravitaillement en vol improvisé, guide des secours en mer et sert au-dessus de l''Irak et de l''Afghanistan. Le crash du XV230 en Afghanistan en 2006, causé par une fuite de carburant pendant un ravitaillement, tue quatorze hommes et précipite la fin de la flotte.\n\n## Place dans l''histoire\nQuarante-neuf exemplaires, quarante-deux ans de service, et deux échecs industriels retentissants — l''AEW3 puis le MRA4, ce dernier annulé en 2010 alors que les appareils neufs étaient presque achevés, puis découpés. Le Royaume-Uni est resté neuf ans sans patrouille maritime, jusqu''à l''arrivée du P-8 américain. Son homologue soviétique était le **Tu-142**.',
    E'## Genesis\nThe Royal Air Force had to replace its propeller-driven Shackletons, inherited from the Lancaster bomber. Everyone patrolled with turboprops — economical at low search speeds. Hawker Siddeley went the other way and proposed reusing the unsold airframes of the **de Havilland Comet**, the world''s first jet airliner, then ending production. The choice was financial to begin with; it produced the only jet maritime patrol aircraft in history.\n\n## Design\nOnto the Comet''s pressurised fuselage was grafted an **unpressurised bay** more than fifteen metres long beneath the floor, able to carry torpedoes, sonobuoys and missiles. A magnetic anomaly detector extends the tail. On patrol two of the four Speys are shut down to save fuel; in exchange, jet transit speed reaches a search area far faster than a turboprop — the decisive argument.\n\n## Operational career\nIt hunted Soviet submarines in the North Atlantic throughout the Cold War, flew the longest missions of the **Falklands** war with improvised air-to-air refuelling, guided rescues at sea and served over Iraq and Afghanistan. The loss of XV230 over Afghanistan in 2006, caused by a fuel leak during refuelling, killed fourteen men and hastened the end of the fleet.\n\n## Place in history\nForty-nine built, forty-two years of service, and two resounding industrial failures — the AEW3 and then the MRA4, the latter cancelled in 2010 when the new aircraft were all but finished, and then cut up. The United Kingdom went nine years without maritime patrol, until the American P-8 arrived. Its Soviet counterpart was the **Tu-142**.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1964-01-01',
    '1967-05-23',
    '1969-10-02',
    926.0,
    9265.0,
    (SELECT id FROM manufacturer WHERE code = 'HS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM armement WHERE name = 'Sting Ray')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 38.63,
  wingspan          = 35.0,
  height            = 9.08,
  wing_area         = 197.0,
  empty_weight      = 39000,
  mtow              = 87090,
  service_ceiling   = 12800,
  climb_rate        = 12.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3800,
  crew              = 12,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Spey Mk 250',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 54.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1979,
  units_built       = 49,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Nimrod MR1 / MR2** : patrouille maritime et lutte anti-sous-marine\n- **Nimrod R1** : renseignement électronique, trois exemplaires très discrets\n- **Nimrod AEW3** : tentative de guet aérien, abandonnée en 1986 après un milliard de livres\n- **Nimrod MRA4** : refonte complète annulée en 2010, les cellules neuves détruites au bulldozer\n- Dérivé du **de Havilland Comet**, premier avion de ligne à réaction du monde',
  variants_en       = E'- **Nimrod MR1 / MR2** : maritime patrol and anti-submarine warfare\n- **Nimrod R1** : signals intelligence, three highly discreet aircraft\n- **Nimrod AEW3** : airborne early warning attempt, abandoned in 1986 after a billion pounds\n- **Nimrod MRA4** : complete rebuild cancelled in 2010, the new airframes bulldozed\n- Derived from the **de Havilland Comet**, the world''s first jet airliner',

  -- Strate 4 : qualitatif
  nickname          = 'The Mighty Hunter',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hawker_Siddeley_Nimrod',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hawker_Siddeley_Nimrod',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Colin Cooke Photo',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Hawker Siddeley Nimrod';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hawker Siddeley Nimrod';
