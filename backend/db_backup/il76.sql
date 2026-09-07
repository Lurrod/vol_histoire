-- Iliouchine Il-76 (Candid)
--
-- Photo : Ilyushin Il-76MD ‘RF-76743’ (37126563151).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3AIlyushin_Il-76MD_%E2%80%98RF-76743%E2%80%99_%2837126563151%29.jpg

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
    'Iliouchine Il-76',
    'Ilyushin Il-76',
    'Iliouchine Il-76 (Candid)',
    'Ilyushin Il-76 (Candid)',
    'Porteur lourd conçu pour les pistes gelées de Sibérie',
    'Heavy airlifter designed for the frozen strips of Siberia',
    '/assets/airplanes/il76.jpg',
    E'## Genèse\nL''URSS a besoin d''un transporteur lourd à réaction, mais son problème n''est pas celui des Américains : il faut desservir la **Sibérie**, c''est-à-dire des pistes en terre gelée, en gravier ou en neige tassée, à des milliers de kilomètres de tout atelier. Le cahier des charges de 1967 exige quarante tonnes sur cinq mille kilomètres, et l''aptitude à se poser là où il n''y a rien.\n\n## Conception\nLa réponse tient dans le train d''atterrissage : **vingt roues** réparties sur cinq jambes, dont la pression peut être ajustée depuis le cockpit selon la nature du sol. L''aile haute en flèche porte quatre réacteurs en nacelles, très au-dessus des projections. La soute est entièrement pressurisée, contrairement à l''An-12, et un poste vitré de navigateur occupe le nez — la navigation astronomique restant prévue. Comme sur l''An-12, une tourelle de queue armée subsiste.\n\n## Carrière opérationnelle\nIl assure l''essentiel du pont aérien vers l''**Afghanistan** — quatorze mille sept cents vols — et sert dans trente-huit pays, dont l''Inde, la Chine, l''Algérie et l''Ukraine. En version civile il transporte des charges hors gabarit sur tous les continents, et en version bombardier d''eau il combat les grands incendies. Un Il-76 russe a été abattu au-dessus de Belgorod en janvier 2024.\n\n## Place dans l''histoire\nEnviron neuf cent soixante exemplaires, toujours produits en Russie sous une forme modernisée. Il a servi de base au **Beriev A-50**, au ravitailleur Il-78 et à une dizaine de dérivés spéciaux : peu de cellules militaires ont été déclinées aussi largement. Son équivalent occidental le plus proche est le **C-17**, de quinze ans son cadet.',
    E'## Genesis\nThe USSR needed a heavy jet airlifter, but its problem was not the Americans'': it had to serve **Siberia**, meaning strips of frozen earth, gravel or packed snow, thousands of kilometres from any workshop. The 1967 specification demanded forty tonnes over five thousand kilometres, and the ability to land where there is nothing.\n\n## Design\nThe answer lies in the undercarriage: **twenty wheels** on five legs, whose pressure can be adjusted from the cockpit according to the ground. The high swept wing carries four podded engines well clear of debris. The hold is fully pressurised, unlike the An-12''s, and a glazed navigator''s station occupies the nose — astronomical navigation still being provided for. As on the An-12, an armed tail turret remains.\n\n## Operational career\nIt ran the bulk of the air bridge to **Afghanistan** — fourteen thousand seven hundred flights — and serves in thirty-eight countries, including India, China, Algeria and Ukraine. In civil form it carries outsize loads on every continent, and as a water bomber it fights major fires. A Russian Il-76 was shot down over Belgorod in January 2024.\n\n## Place in history\nAbout nine hundred and sixty built, still produced in Russia in modernised form. It provided the basis for the **Beriev A-50**, the Il-78 tanker and a dozen special derivatives: few military airframes have been developed so widely. Its closest Western equivalent is the **C-17**, fifteen years its junior.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1967-01-01',
    '1971-03-25',
    '1974-06-01',
    900.0,
    4400.0,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.59,
  wingspan          = 50.5,
  height            = 14.76,
  wing_area         = 300.0,
  empty_weight      = 92000,
  mtow              = 210000,
  service_ceiling   = 13000,
  climb_rate        = 14.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4000,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel PS-90A-76',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 142.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1973,
  production_end    = NULL,
  units_built       = 960,
  unit_cost_usd     = 50000000,
  unit_cost_year    = 2015,
  operators_count   = 38,
  variants          = E'- **Il-76MD** : version militaire de base, tourelle de queue à deux canons de 23 mm\n- **Il-76MD-90A** : refonte à moteurs PS-90, aile nouvelle et avionique numérique\n- **Il-78 Midas** : version ravitailleuse, trois postes de transfert\n- **Beriev A-50** : plateforme de guet aérien, présente au catalogue comme appareil distinct\n- **Il-76TD « Waterbomber »** : lutte contre les feux, quarante-deux tonnes de largage',
  variants_en       = E'- **Il-76MD** : baseline military version, tail turret with two 23 mm cannon\n- **Il-76MD-90A** : rebuild with PS-90 engines, a new wing and digital avionics\n- **Il-78 Midas** : tanker version with three transfer stations\n- **Beriev A-50** : airborne early warning platform, in the catalogue as a distinct aircraft\n- **Il-76TD “Waterbomber”** : firefighting version dropping forty-two tonnes',

  -- Strate 4 : qualitatif
  nickname          = 'Candid',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-76',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-76',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Iliouchine Il-76';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-76';
