-- VFW-Fokker VAK 191B
--
-- Photo : VFW VAK 191 V2 - B (D-9564) 1992-08-16 Andre Gerwing Collection ID 022591.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File%3AVFW_VAK_191_V2_-_B_%28D-9564%29_1992-08-16_Andre_Gerwing_Collection_ID_022591.jpg

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
    'VFW VAK 191B',
    'VFW VAK 191B',
    'VFW-Fokker VAK 191B',
    'VFW-Fokker VAK 191B',
    'Remplaçant vertical du Fiat G.91, arrivé dix ans trop tard',
    'Vertical replacement for the Fiat G.91, ten years too late',
    '/assets/airplanes/vak191b.jpg',
    E'## Genèse\nLe cahier des charges de l''OTAN de 1961 demande un successeur au **Fiat G.91** capable de décoller verticalement. L''Allemagne fédérale et l''Italie s''associent, la Grande-Bretagne propose de son côté le **P.1127**. Trois formules concurrentes, une seule mission. Le VAK 191B est le compromis allemand — et il mettra **dix ans** à voler.\n\n## Conception\nUn réacteur principal RB.193 à tuyères orientables, comme sur le Harrier, mais complété par deux petits réacteurs de sustentation verticaux placés devant et derrière le centre de gravité. C''est un demi-pas vers la formule du Pegasus : plus simple que le VJ 101, plus lourd et plus complexe que le P.1127. L''appareil inaugure en revanche un **système de commandes de vol numériques** en avance sur son époque.\n\n## Carrière opérationnelle\nAucune. L''Italie se retire en 1968, la Grande-Bretagne fait voler son Harrier en escadre dès 1969, et le premier VAK 191B ne décolle qu''en septembre 1971. Trois prototypes accumulent quatre-vingt-onze vols, dont une poignée de transitions complètes, puis le programme s''arrête en 1972.\n\n## Place dans l''histoire\nTrois exemplaires. Il n''a rien perdu sur le plan technique : il a perdu la course. Le seul héritage concret du programme est son calculateur de commandes de vol, repris et développé pour le **Panavia Tornado** — c''est-à-dire pour un avion qui décolle d''une piste.',
    E'## Genesis\nThe 1961 NATO requirement called for a successor to the **Fiat G.91** able to take off vertically. West Germany and Italy joined forces; Britain offered the **P.1127** instead. Three competing formulas, one mission. The VAK 191B was the German compromise — and it would take **ten years** to fly.\n\n## Design\nA main RB.193 engine with swivelling nozzles, as on the Harrier, but supplemented by two small vertical lift engines fore and aft of the centre of gravity. It is a half-step towards the Pegasus formula: simpler than the VJ 101, heavier and more complex than the P.1127. The aircraft did however introduce a **digital flight control system** ahead of its time.\n\n## Operational career\nNone. Italy withdrew in 1968, Britain had Harriers in squadron service by 1969, and the first VAK 191B did not lift off until September 1971. Three prototypes accumulated ninety-one flights, a handful of them full transitions, and the programme stopped in 1972.\n\n## Place in history\nThree built. It lost nothing technically: it lost the race. The programme''s one concrete legacy is its flight control computer, taken up and developed for the **Panavia Tornado** — that is, for an aircraft that takes off from a runway.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1961-01-01',
    '1971-09-10',
    NULL,
    1100.0,
    1100.0,
    (SELECT id FROM manufacturer WHERE code = 'VFW'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.72,
  wingspan          = 6.16,
  height            = 4.3,
  wing_area         = 12.5,
  empty_weight      = 5563,
  mtow              = 8500,
  service_ceiling   = 15000,
  climb_rate        = 80.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce/MTU RB.193 + 2 RB.162',
  engine_count      = 3,
  engine_type       = 'Turboréacteur à poussée vectorielle et réacteurs de sustentation',
  engine_type_en    = 'Vectored-thrust turbofan and lift jets',
  thrust_dry        = 45.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1971,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **VAK 191B V1 / V2 / V3** : trois prototypes, quatre-vingt-onze vols au total\n- Réacteur principal **RB.193** à tuyères orientables, plus deux RB.162 de sustentation\n- Programme lancé en coopération avec l''**Italie**, qui se retire en 1968\n- Ses **commandes de vol numériques** seront réutilisées sur le **Panavia Tornado**\n- Annulé en 1972 : le Harrier faisait déjà le travail, en service depuis trois ans',
  variants_en       = E'- **VAK 191B V1 / V2 / V3** : three prototypes, ninety-one flights in all\n- **RB.193** main engine with swivelling nozzles, plus two RB.162 lift jets\n- Programme launched jointly with **Italy**, which withdrew in 1968\n- Its **digital flight controls** were reused on the **Panavia Tornado**\n- Cancelled in 1972: the Harrier was already doing the job, in service for three years',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/VFW_VAK_191B',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/VFW_VAK_191',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'VFW VAK 191B';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'VFW VAK 191B';
