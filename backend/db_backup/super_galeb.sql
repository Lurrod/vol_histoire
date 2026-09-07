-- Soko G-4 Super Galeb
--
-- Photo : Super Galeb G-4 Serbia (20932748396).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File%3ASuper_Galeb_G-4_Serbia_%2820932748396%29.jpg

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
    'Soko G-4 Super Galeb',
    'Soko G-4 Super Galeb',
    'Soko G-4 Super Galeb',
    'Soko G-4 Super Galeb',
    'Entraîneur yougoslave, dernier avion conçu avant l’éclatement du pays',
    'Yugoslav trainer, the last aircraft designed before the country broke up',
    '/assets/airplanes/super-galeb.jpg',
    E'## Genèse\nLe G-2 Galeb, premier avion à réaction yougoslave, arrive en fin de vie dans les années 1970. Soko conçoit son successeur à Mostar : aile en flèche, réacteur Viper britannique sous licence, et une double vocation école et attaque légère, dans la logique de **défense territoriale** qui structure toute la doctrine yougoslave.\n\n## Conception\nAile à 22° de flèche, empennage entièrement mobile, sièges éjectables zéro-zéro. Le Super Galeb monte à Mach 0,81 et supporte 8 g, ce qui en fait un entraîneur avancé crédible ; ses quatre points d''emport et son canon ventral de 23 mm lui donnent une capacité d''attaque réelle contre des objectifs peu défendus.\n\n## Carrière opérationnelle\nCent trente-deux exemplaires, dont une trentaine vendus à la **Birmanie**. La production s''arrête net en 1991 avec la guerre : l''usine de Mostar est détruite. Les appareils restants sont engagés par plusieurs des belligérants issus de l''éclatement du pays, notamment au Kosovo en 1999.\n\n## Place dans l''histoire\nLe Super Galeb est le dernier avion entièrement conçu en Yougoslavie. Avec le **J-22 Orao**, il referme l''histoire d''une industrie aéronautique nationale qui, en trente ans, avait su concevoir, produire et exporter — et qui a disparu avec l''État qui la portait.',
    E'## Genesis\nThe G-2 Galeb, Yugoslavia’s first jet aircraft, was reaching the end of its life in the 1970s. Soko designed its successor at Mostar: a swept wing, a licence-built British Viper engine, and a dual school and light attack role, in keeping with the **territorial defence** doctrine that shaped all Yugoslav thinking.\n\n## Design\nA 22° swept wing, an all-moving tailplane, zero-zero ejection seats. The Super Galeb reaches Mach 0.81 and takes 8 g, which makes it a credible advanced trainer; its four hardpoints and ventral 23 mm gun give it real attack capability against lightly defended targets.\n\n## Operational career\nOne hundred and thirty-two built, some thirty of them sold to **Myanmar**. Production stopped dead in 1991 with the war: the Mostar factory was destroyed. The remaining aircraft were used by several of the belligerents that emerged from the country’s break-up, notably over Kosovo in 1999.\n\n## Place in history\nThe Super Galeb is the last aircraft designed entirely in Yugoslavia. With the **J-22 Orao** it closes the story of a national aviation industry that, in thirty years, had learned to design, build and export — and that disappeared along with the state that sustained it.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    '1973-01-01',
    '1978-07-17',
    '1984-01-01',
    910.0,
    1900.0,
    (SELECT id FROM manufacturer WHERE code = 'SOKO'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM armement WHERE name = 'S-5'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.86,
  wingspan          = 9.88,
  height            = 4.3,
  wing_area         = 19.5,
  empty_weight      = 3172,
  mtow              = 6330,
  service_ceiling   = 12850,
  climb_rate        = 30,
  g_limit_pos       = 8.0,
  g_limit_neg       = -4.0,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper Mk 632-46',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1983,
  production_end    = 1991,
  units_built       = 132,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **G-4** : version d''entraînement et d''attaque légère de série\n- **G-4M** : version modernisée d''après-guerre, avionique et armement occidentaux\n- **Soko G-2 Galeb** : prédécesseur à aile droite, premier avion à réaction yougoslave\n- Monture de la patrouille acrobatique **Leteće Zvezde** puis des **Flying Stars** serbes',
  variants_en       = E'- **G-4** : production training and light attack version\n- **G-4M** : post-war upgraded version with Western avionics and weapons\n- **Soko G-2 Galeb** : straight-wing predecessor, the first Yugoslav jet aircraft\n- Mount of the **Leteće Zvezde** display team and later the Serbian **Flying Stars**',

  -- Strate 4 : qualitatif
  nickname          = 'Super Galeb',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soko_G-4_Super_Galeb',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Soko_G-4_Super_Galeb',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert from Holland',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Soko G-4 Super Galeb';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Soko G-4 Super Galeb';
