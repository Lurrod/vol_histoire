-- GAF Jindivik
--
-- Photo : Jindivik at Woomera.jpg
--   licence CC BY 3.0 — Jonathan Rabbitt
--   https://commons.wikimedia.org/wiki/File%3AJindivik_at_Woomera.jpg

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
    'GAF Jindivik',
    'GAF Jindivik',
    'GAF Jindivik',
    'GAF Jindivik',
    'Cible volante australienne produite pendant quarante ans',
    'Australian target drone built for forty years',
    '/assets/airplanes/jindivik.jpg',
    E'## Genèse\nL''Australie de l''après-guerre accueille à **Woomera**, en plein désert de l''Australie-Méridionale, le plus grand champ de tir du monde occidental — quatre cent mille kilomètres carrés sans personne. Les missiles britanniques y sont essayés, et pour les essayer il faut quelque chose sur quoi tirer. Le Jindivik est né de ce besoin.\n\n## Conception\nHuit mètres de long, une tonne et demie, un réacteur **Viper** britannique. Pas de train d''atterrissage : l''engin décolle d''un **chariot** qu''il abandonne au décollage et se pose sur un patin ventral. Il est piloté depuis le sol par radio, monte à dix-sept mille mètres et vole à neuf cents kilomètres-heure — assez pour représenter un bombardier ou un chasseur.\n\n## Carrière opérationnelle\nCinq cent deux exemplaires produits de 1952 à 1986, **trente-quatre ans** de production continue. Il sert de cible aux missiles britanniques, australiens, suédois et américains, et de plastron aux essais de systèmes d''armes. Beaucoup, par définition, ont été détruits — c''était leur fonction ; les autres volaient plusieurs dizaines de fois.\n\n## Place dans l''histoire\nCinq cent deux exemplaires. Le Jindivik est **le plus produit et le plus durable des appareils conçus en Australie**, et l''un des rares programmes australiens à avoir été exporté vers le Royaume-Uni plutôt que l''inverse. Il appartient à la même famille d''engins que le **Firebee** américain, avec lequel il a coexisté quarante ans.',
    E'## Genesis\nPost-war Australia hosted at **Woomera**, deep in the South Australian desert, the largest firing range in the Western world — four hundred thousand square kilometres with nobody in them. British missiles were tested there, and to test them something was needed to shoot at. The Jindivik was born of that need.\n\n## Design\nEight metres long, a tonne and a half, a British **Viper** engine. No undercarriage: the machine takes off from a **trolley** it abandons on lift-off and lands on a ventral skid. It is flown from the ground by radio, climbs to seventeen thousand metres and flies at nine hundred kilometres an hour — enough to represent a bomber or a fighter.\n\n## Operational career\nFive hundred and two built between 1952 and 1986, **thirty-four years** of continuous production. It served as a target for British, Australian, Swedish and American missiles, and as a testbed for weapons systems. Many, by definition, were destroyed — that was the job; the rest flew dozens of times.\n\n## Place in history\nFive hundred and two built. The Jindivik is **the most produced and longest-lived aircraft designed in Australia**, and one of the few Australian programmes exported to Britain rather than the reverse. It belongs to the same family as the American **Firebee**, with which it coexisted for forty years.',
    (SELECT id FROM countries WHERE code = 'AUS'),
    '1948-01-01',
    '1952-08-28',
    '1953-01-01',
    900.0,
    1600.0,
    (SELECT id FROM manufacturer WHERE code = 'GAF'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'GAF Jindivik'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'GAF Jindivik'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'GAF Jindivik'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.1,
  wingspan          = 6.3,
  height            = 2.1,
  wing_area         = 8.0,
  empty_weight      = 1350,
  mtow              = 1655,
  service_ceiling   = 17000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 700,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Viper 201',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 11.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = 1986,
  units_built       = 502,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Jindivik Mk 1 à Mk 4** : quatre générations successives sur trente-quatre ans\n- **Pika** : version pilotée d''essai, construite pour valider la cellule\n- Décolle d''un **chariot largable**, se pose sur un patin ventral\n- *Jindivik* signifie « **celui qui est traqué** » en langue aborigène\n- Exploité en Australie, au **Royaume-Uni**, en **Suède** et aux **États-Unis**',
  variants_en       = E'- **Jindivik Mk 1 to Mk 4** : four successive generations over thirty-four years\n- **Pika** : piloted test version, built to validate the airframe\n- Takes off from a **jettisonable trolley**, lands on a ventral skid\n- *Jindivik* means ''**the hunted one**'' in an Aboriginal language\n- Operated by Australia, **Britain**, **Sweden** and the **United States**',

  -- Strate 4 : qualitatif
  nickname          = 'Jindivik',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/GAF_Jindivik',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/GAF_Jindivik',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jonathan Rabbitt',
  image_licence     = 'CC BY 3.0'
WHERE name = 'GAF Jindivik';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'GAF Jindivik';
