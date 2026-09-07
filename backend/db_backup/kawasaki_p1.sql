-- Kawasaki P-1
--
-- Photo : JMSDF P-1 (9).jpg
--   licence CC BY 4.0 — 海上自衛隊
--   https://commons.wikimedia.org/wiki/File%3AJMSDF_P-1_%289%29.jpg

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
    'Kawasaki P-1',
    'Kawasaki P-1',
    'Kawasaki P-1',
    'Kawasaki P-1',
    'Seul patrouilleur maritime moderne conçu de zéro plutôt que dérivé d’un avion de ligne',
    'The only modern maritime patroller designed from scratch rather than from an airliner',
    '/assets/airplanes/kawasaki-p1.jpg',
    E'## Genèse\nLe Japon exploite cent dix **P-3 Orion** construits sous licence, la deuxième flotte du monde après les États-Unis : sa géographie insulaire et le voisinage de trois marines majeures en font une nécessité. Quand vient le remplacement, Tokyo écarte la solution américaine et décide de concevoir son propre appareil — décision coûteuse, justifiée par la volonté de maintenir une industrie aéronautique nationale.\n\n## Conception\nContrairement au **P-8**, dérivé d''un 737, le P-1 est dessiné pour sa mission seule. D''où quatre réacteurs plutôt que deux : la redondance rassure au-dessus de l''océan, et la panne d''un moteur n''interrompt pas la patrouille. Surtout, il est le premier avion de série au monde à commandes de vol **par fibre optique**, insensibles aux perturbations électromagnétiques — précisément celles que génèrent ses propres capteurs de détection sous-marine. Le radar à antenne active balaie sur quatre faces.\n\n## Carrière opérationnelle\nIl surveille la mer du Japon, la mer de Chine orientale et le détroit de Tsushima, où l''activité sous-marine chinoise et russe s''est intensifiée. Un incident diplomatique l''a opposé à la Corée du Sud en 2018, Séoul accusant un P-1 de survol menaçant, Tokyo accusant un destroyer coréen d''illumination radar. L''appareil a été présenté à l''exportation sans succès.\n\n## Place dans l''histoire\nTrente-cinq exemplaires. Il est le **seul patrouilleur maritime moderne** qui ne soit pas un avion de ligne converti, à contre-courant d''une économie qui pousse partout ailleurs à l''inverse. Ce choix lui donne des qualités réelles et un coût par appareil supérieur au **P-8**, ce qui explique ses échecs à l''exportation.',
    E'## Genesis\nJapan operates a hundred and ten licence-built **P-3 Orions**, the world''s second-largest fleet after the United States: its island geography and the proximity of three major navies make it a necessity. When replacement came, Tokyo rejected the American solution and decided to design its own aircraft — an expensive decision, justified by the wish to sustain a national aircraft industry.\n\n## Design\nUnlike the **P-8**, derived from a 737, the P-1 is drawn for its mission alone. Hence four engines rather than two: redundancy reassures over the ocean, and one engine failing does not end the patrol. Above all it is the world''s first production aircraft with **fly-by-light** controls, immune to electromagnetic interference — precisely what its own submarine detection sensors generate. The active array radar scans on four faces.\n\n## Operational career\nIt watches the Sea of Japan, the East China Sea and the Tsushima Strait, where Chinese and Russian submarine activity has intensified. A diplomatic incident set it against South Korea in 2018, Seoul accusing a P-1 of a threatening overflight, Tokyo accusing a Korean destroyer of radar illumination. The aircraft has been offered for export without success.\n\n## Place in history\nThirty-five built. It is the **only modern maritime patroller** that is not a converted airliner, against the grain of an economics that pushes everywhere else the other way. That choice gives it real qualities and a unit cost above the **P-8**''s, which explains its export failures.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '2001-01-01',
    '2007-09-28',
    '2013-03-26',
    996.0,
    8000.0,
    (SELECT id FROM manufacturer WHERE code = 'KHI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM armement WHERE name = 'Mk 46')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM armement WHERE name = 'ASM-1'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 38.0,
  wingspan          = 35.4,
  height            = 12.1,
  wing_area         = 170.0,
  empty_weight      = 45400,
  mtow              = 79700,
  service_ceiling   = 13520,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2500,
  crew              = 11,

  -- Strate 2 : motorisation
  engine_name       = 'IHI Corporation F7-10',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 60.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2007,
  production_end    = NULL,
  units_built       = 35,
  unit_cost_usd     = 180000000,
  unit_cost_year    = 2020,
  operators_count   = 1,
  variants          = E'- **P-1** : version de patrouille maritime standard de la marine japonaise\n- **RC-1** : projet de version de renseignement électronique, abandonné\n- **Commandes de vol optiques** : premier avion de série à piloter par **fibre optique**\n- Développé **conjointement avec le C-2**, dont il partage des éléments de cellule\n- Proposé sans succès au Royaume-Uni et à la Nouvelle-Zélande face au P-8',
  variants_en       = E'- **P-1** : the standard maritime patrol version of the Japanese navy\n- **RC-1** : proposed signals intelligence version, abandoned\n- **Fly-by-light controls** : the first production aircraft flown by **optical fibre**\n- Developed **alongside the C-2**, with which it shares airframe elements\n- Offered unsuccessfully to the United Kingdom and New Zealand against the P-8',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Kawasaki_P-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kawasaki_P-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '海上自衛隊',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Kawasaki P-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kawasaki P-1';
