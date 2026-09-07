-- Hispano Aviación HA-200 Saeta
--
-- Photo : A.10B-70 HA-200 Saeta Ejército del Aire LEN 01.jpg
--   licence CC BY-SA 4.0 — Bene Riobó
--   https://commons.wikimedia.org/wiki/File%3AA.10B-70_HA-200_Saeta_Ej%C3%A9rcito_del_Aire_LEN_01.jpg

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
    'Hispano HA-200 Saeta',
    'Hispano HA-200 Saeta',
    'Hispano Aviación HA-200 Saeta',
    'Hispano Aviación HA-200 Saeta',
    'Premier avion à réaction espagnol, dessiné par l’ingénieur du Messerschmitt 262',
    'Spain’s first jet aircraft, drawn by the engineer of the Messerschmitt 262',
    '/assets/airplanes/ha200-saeta.jpg',
    E'## Genèse\nL''Espagne franquiste des années 1950 est isolée, pauvre en devises, et dépourvue d''industrie aéronautique moderne. Elle dispose en revanche d''un atout singulier : **Willy Messerschmitt**, interdit d''exercer en Allemagne après 1945, travaille alors à Séville pour Hispano Aviación. C''est lui qui dessine le premier avion à réaction espagnol.\n\n## Conception\nDeux petits réacteurs **Marboré** français, les mêmes que sur le Fouga Magister, encastrés dans les emplantures d''aile. Deux places en tandem sous une longue verrière, aile droite à réservoirs de bout d''aile, empennage en T. L''appareil est léger — moins de deux tonnes à vide — simple, et conçu pour être construit avec les moyens dont dispose l''Espagne, ce qui compte autant que ses performances.\n\n## Carrière opérationnelle\nIl forme les pilotes espagnols pendant trente ans et sert de monture à la patrouille acrobatique nationale. Sa version d''attaque monoplace, le **HA-220 Super Saeta**, est engagée au Sahara occidental en 1975 contre le Front Polisario — seul emploi au feu du type. L''Égypte en construit soixante-trois sous licence à Helwan, où Messerschmitt travaillait aussi sur le **HA-300**.\n\n## Place dans l''histoire\nDeux cent dix exemplaires. Il fonde l''industrie aéronautique espagnole moderne : Hispano Aviación fusionnera avec CASA, qui produira le **C-101 Aviojet**, puis deviendra l''un des piliers d''Airbus. Messerschmitt, lui, aura dessiné trois avions à réaction pour trois pays — l''Allemagne, l''Espagne et l''Égypte.',
    E'## Genesis\nFranco''s Spain in the 1950s was isolated, short of foreign currency and without a modern aircraft industry. It had, however, one singular asset: **Willy Messerschmitt**, barred from working in Germany after 1945, was then in Seville working for Hispano Aviación. It was he who drew Spain''s first jet aircraft.\n\n## Design\nTwo small French **Marboré** engines, the same as the Fouga Magister''s, buried in the wing roots. Two seats in tandem under a long canopy, a straight wing with tip tanks, a T-tail. The aircraft is light — under two tonnes empty — simple, and designed to be built with the means Spain actually had, which mattered as much as its performance.\n\n## Operational career\nIt trained Spanish pilots for thirty years and equipped the national display team. Its single-seat attack version, the **HA-220 Super Saeta**, was committed in the Western Sahara in 1975 against the Polisario Front — the type''s only combat use. Egypt built sixty-three under licence at Helwan, where Messerschmitt was also working on the **HA-300**.\n\n## Place in history\nTwo hundred and ten built. It founded the modern Spanish aircraft industry: Hispano Aviación would merge into CASA, which produced the **C-101 Aviojet** and then became one of the pillars of Airbus. Messerschmitt himself would have designed three jet aircraft for three countries — Germany, Spain and Egypt.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '1951-01-01',
    '1955-08-12',
    '1962-01-01',
    700.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'HSP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.97,
  wingspan          = 10.42,
  height            = 2.9,
  wing_area         = 17.4,
  empty_weight      = 1830,
  mtow              = 3350,
  service_ceiling   = 13000,
  climb_rate        = 17.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Marboré VI',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 4.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1980,
  units_built       = 210,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **HA-200A / D / E** : versions d''entraînement successives\n- **HA-220 Super Saeta** : version d''attaque monoplace, engagée au **Sahara occidental**\n- **Al-Kahira** : version construite sous licence en **Égypte** par Helwan, 63 exemplaires\n- Conçu par **Willy Messerschmitt**, également auteur du Me 262 et du Helwan HA-300\n- Premier avion à réaction conçu et produit en Espagne',
  variants_en       = E'- **HA-200A / D / E** : successive training versions\n- **HA-220 Super Saeta** : single-seat attack version, committed in the **Western Sahara**\n- **Al-Kahira** : version licence-built in **Egypt** by Helwan, 63 aircraft\n- Designed by **Willy Messerschmitt**, also author of the Me 262 and the Helwan HA-300\n- The first jet aircraft designed and built in Spain',

  -- Strate 4 : qualitatif
  nickname          = 'Saeta',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hispano_HA-200',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hispano_Aviación_HA-200',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bene Riobó',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Hispano HA-200 Saeta';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hispano HA-200 Saeta';
