-- Ling-Temco-Vought XC-142A
--
-- Photo : Ling-Temco-Vought XC-142A.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File%3ALing-Temco-Vought_XC-142A.jpg

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
    'LTV XC-142',
    'LTV XC-142',
    'Ling-Temco-Vought XC-142A',
    'Ling-Temco-Vought XC-142A',
    'Transport à voilure basculante, sabordé par sa transmission',
    'Tilt-wing transport, undone by its transmission',
    '/assets/airplanes/xc142.jpg',
    E'## Genèse\nEn 1961, les quatre armées américaines cherchent la même chose : un transport tactique qui se pose sans piste, plus rapide et plus endurant qu''un hélicoptère. Le programme est confié à un consortium mené par **Ling-Temco-Vought**, avec Hiller et Ryan — les deux firmes qui venaient d''échouer sur leurs propres appareils à décollage vertical.\n\n## Conception\nLa formule choisie n''est ni la poussée orientée ni le tail-sitter, mais la **voilure basculante** : l''aile entière pivote de cent degrés, emmenant avec elle les quatre turbopropulseurs. À la verticale, les hélices soulèvent l''appareil ; à l''horizontale, elles le tractent. Un **arbre de liaison** relie les quatre moteurs entre eux, si bien qu''une panne unique ne déséquilibre pas la machine — c''est la pièce la plus astucieuse et la plus fragile de l''ensemble.\n\n## Carrière opérationnelle\nAucune. Cinq exemplaires accomplissent quatre cent quatre-vingt-huit vols entre 1964 et 1970, dont des appontages sur le porte-avions **USS Bennington**. L''appareil emporte trente-deux soldats à près de sept cents kilomètres-heure, très au-delà de ce que fait un hélicoptère de l''époque. Trois cellules sont perdues en essais, l''une avec son équipage.\n\n## Place dans l''histoire\nCinq exemplaires. La transmission croisée, sa force théorique, se révèle son point faible : vibrations, usure, entretien constant. Les armées renoncent en 1970 — mais l''idée survit. Vingt ans plus tard, le **V-22 Osprey** reprend le même arbre de liaison en ne faisant basculer que les nacelles, et non l''aile entière.',
    E'## Genesis\nIn 1961 all four American services were after the same thing: a tactical transport that lands without a runway, faster and longer-legged than a helicopter. The programme went to a consortium led by **Ling-Temco-Vought**, with Hiller and Ryan — the two firms that had just failed with their own vertical take-off aircraft.\n\n## Design\nThe chosen formula is neither vectored thrust nor the tail-sitter, but the **tilt-wing**: the entire wing pivots through a hundred degrees, carrying all four turboprops with it. Vertical, the propellers lift the aircraft; horizontal, they pull it. A **cross-shaft** links the four engines, so a single failure does not unbalance the machine — the cleverest and most fragile part of the whole design.\n\n## Operational career\nNone. Five aircraft flew four hundred and eighty-eight sorties between 1964 and 1970, including landings aboard the carrier **USS Bennington**. It carried thirty-two soldiers at nearly seven hundred kilometres an hour, far beyond any helicopter of the day. Three airframes were lost in testing, one with its crew.\n\n## Place in history\nFive built. The cross-shaft, its theoretical strength, proved its weak point: vibration, wear, constant maintenance. The services gave up in 1970 — but the idea survived. Twenty years later the **V-22 Osprey** took up the same cross-shaft, tilting only the nacelles rather than the whole wing.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1961-01-01',
    '1964-09-29',
    NULL,
    694.0,
    3900.0,
    (SELECT id FROM manufacturer WHERE code = 'LTV'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'LTV XC-142'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'LTV XC-142'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'LTV XC-142'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'LTV XC-142'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'LTV XC-142'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.7,
  wingspan          = 20.6,
  height            = 7.9,
  wing_area         = 48.77,
  empty_weight      = 10270,
  mtow              = 20230,
  service_ceiling   = 7600,
  climb_rate        = 20.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 760,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric T64-GE-1',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur à voilure basculante',
  engine_type_en    = 'Tilt-wing turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1965,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XC-142A** : cinq exemplaires, quatre cent quatre-vingt-huit vols au total\n- **Voilure entière basculante** à 100°, emportant les quatre turbopropulseurs\n- Arbre de liaison reliant les quatre hélices : une panne moteur ne fait pas basculer\n- Apponte sur l''**USS Bennington** en 1966, décollant et se posant à la verticale\n- Un exemplaire survit et repose au **National Museum of the USAF**',
  variants_en       = E'- **XC-142A** : five aircraft, four hundred and eighty-eight flights in all\n- **The entire wing tilts** through 100°, carrying all four turboprops\n- A cross-shaft links the four propellers: an engine failure does not roll the aircraft\n- Landed aboard **USS Bennington** in 1966, taking off and landing vertically\n- One survivor rests at the **National Museum of the USAF**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Ling-Temco-Vought_XC-142',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ling-Temco-Vought_XC-142',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'LTV XC-142';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'LTV XC-142';
