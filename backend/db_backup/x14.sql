-- Bell X-14A
--
-- Photo : X-14B NASA-704- A Bell single-place, open cockpit, twin-engine, jet-lift VTOL aircraft over Highway 101 in approach to Moffett Field, California (ARC-1974-AC74-4562-15).jpg
--   licence Public domain — NASA Ames Research Center / Art Melliar
--   https://commons.wikimedia.org/wiki/File%3AX-14B_NASA-704-_A_Bell_single-place%2C_open_cockpit%2C_twin-engine%2C_jet-lift_VTOL_aircraft_over_Highway_101_in_approach_to_Moffett_Field%2C_California_%28ARC-1974-AC74-4562-15%29.jpg

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
    'Bell X-14',
    'Bell X-14',
    'Bell X-14A',
    'Bell X-14A',
    'Le laboratoire ouvert où Neil Armstrong a appris à poser un module lunaire',
    'The open-cockpit laboratory where Neil Armstrong learned to land on the Moon',
    '/assets/airplanes/x14.jpg',
    E'## Genèse\nPendant que l''Europe construit des prototypes à dix moteurs, l''US Air Force commande à Bell l''exact contraire : la machine la plus simple possible pour étudier le vol stationnaire. Budget réduit, délai court. Bell assemble donc un appareil à partir de pièces d''avions **civils de série** — l''aile et l''empennage d''un Beechcraft Bonanza, le fuselage avant d''un T-34.\n\n## Conception\nDeux petits réacteurs sont montés côte à côte dans le fuselage, à l''horizontale, et leurs gaz traversent des **cascades de déflecteurs** qui les renvoient vers le bas. Aucune tuyère mobile, aucun moteur de sustentation : rien que des volets d''aiguillage. Le cockpit est **ouvert**, sans verrière, ce qui donne au pilote une visibilité totale sur le sol — décisif pour un appareil qui doit se poser à la verticale.\n\n## Carrière opérationnelle\nAucune, au sens militaire. Mais l''appareil vole **vingt-quatre ans**, de 1957 à 1981 : le plus long service de tous les avions X. La NASA l''utilise à Ames pour étudier les lois de pilotage en stationnaire, puis comme **simulateur d''alunissage**. En 1964, un jeune pilote nommé **Neil Armstrong** y effectue plusieurs vols.\n\n## Place dans l''histoire\nUn seul exemplaire. Il n''a jamais visé le combat et n''a donc jamais échoué : c''est le seul programme ADAV de cette liste à avoir livré exactement ce qu''on lui demandait. Les données de pilotage qu''il a produites ont servi aussi bien au **Harrier** qu''au programme **Apollo**.',
    E'## Genesis\nWhile Europe was building ten-engined prototypes, the US Air Force ordered from Bell the exact opposite: the simplest possible machine for studying the hover. Small budget, short deadline. Bell therefore assembled an aircraft from **production civil** parts — the wing and tail of a Beechcraft Bonanza, the forward fuselage of a T-34.\n\n## Design\nTwo small engines are mounted side by side in the fuselage, horizontally, and their gas passes through **cascade vanes** that turn it downward. No moving nozzles, no lift engines: nothing but deflector vanes. The cockpit is **open**, with no canopy, giving the pilot complete visibility of the ground — decisive for an aircraft that must land vertically.\n\n## Operational career\nNone, in the military sense. But the aircraft flew for **twenty-four years**, from 1957 to 1981: the longest service of any X-plane. NASA used it at Ames to study hover handling laws, then as a **lunar landing simulator**. In 1964 a young pilot named **Neil Armstrong** made several flights in it.\n\n## Place in history\nA single aircraft. It never aimed at combat and so never failed: it is the only VTOL programme on this list to have delivered exactly what was asked of it. The handling data it produced served the **Harrier** as much as the **Apollo** programme.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1955-01-01',
    '1957-02-17',
    NULL,
    293.0,
    483.0,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-14'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Bell X-14'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-14'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.62,
  wingspan          = 10.36,
  height            = 2.39,
  wing_area         = 17.1,
  empty_weight      = 1500,
  mtow              = 1935,
  service_ceiling   = 6100,
  climb_rate        = 12.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-19',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à déflecteurs orientables',
  engine_type_en    = 'Turbojet with vectoring vanes',
  thrust_dry        = 13.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1957,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-14** puis **X-14A / X-14B** : un exemplaire unique, remotorisé deux fois\n- **Déflecteurs en cascade** dans les tuyères, qui dévient les gaz vers le bas\n- Le plus **long service** de tous les avions X : 1957 → 1981, vingt-quatre ans\n- Aile, empennage et cockpit repris de **Beechcraft Bonanza** et **T-34** de série\n- Sert de simulateur d''alunissage : **Neil Armstrong** y vole en 1964',
  variants_en       = E'- **X-14**, then **X-14A / X-14B** : a single aircraft, re-engined twice\n- **Cascade vanes** in the nozzles, deflecting the gas downward\n- The **longest service** of any X-plane: 1957 to 1981, twenty-four years\n- Wing, tail and cockpit taken from production **Beechcraft Bonanza** and **T-34**\n- Used as a lunar landing simulator: **Neil Armstrong** flew it in 1964',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bell_X-14',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell_X-14',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Ames Research Center / Art Melliar',
  image_licence     = 'Public domain'
WHERE name = 'Bell X-14';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell X-14';
