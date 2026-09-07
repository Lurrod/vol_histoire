-- Dornier Do 28 D Skyservant
--
-- Photo : Dornier Do-28 Skyservant (50645648296).jpg
--   licence CC BY 2.0 — Thomas Vogt from Paderborn, Deutschland
--   https://commons.wikimedia.org/wiki/File%3ADornier_Do-28_Skyservant_%2850645648296%29.jpg

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
    'Dornier Do 28 Skyservant',
    'Dornier Do 28 Skyservant',
    'Dornier Do 28 D Skyservant',
    'Dornier Do 28 D Skyservant',
    'Laid, lent, increvable : le tracteur de la Bundeswehr',
    'Ugly, slow, indestructible: the Bundeswehr’s tractor',
    '/assets/airplanes/do28-skyservant.jpg',
    E'## Genèse\nDornier construit depuis les années 1950 des utilitaires de brousse — le Do 27 vole en Éthiopie, au Congo, en Nouvelle-Guinée. En 1965, la Bundeswehr veut un appareil de liaison capable de se poser sur un terrain de manœuvre, et Dornier propose une version bimoteur, entièrement redessinée malgré le nom qui suggère une simple évolution.\n\n## Conception\nL''appareil est laid, et volontairement : fuselage à section carrée, train fixe à jambes carénées, **moteurs sur pylônes** écartés du fuselage pour dégager la cabine. Tout est pensé pour l''entretien en plein air par des mécaniciens de campagne. Il décolle en deux cent cinquante mètres et se pose sur une prairie, ce que rien d''autre de cette taille ne fait alors.\n\n## Carrière opérationnelle\nDeux cent soixante-dix exemplaires, quinze pays. La **Luftwaffe** et la **Marineflieger** l''emploient trente ans pour la liaison, le transport léger, la photographie et — sur la version OU — la surveillance électronique de la mer Baltique. Israël, le Nigeria, la Turquie, le Kenya et la Thaïlande en achètent également.\n\n## Place dans l''histoire\nDeux cent soixante-dix exemplaires. Le Skyservant est l''antithèse du **Do 31** à décollage vertical que la même firme construisait au même moment : celui-ci a coûté une fortune et n''a rien donné, celui-là a coûté trois fois rien et a servi trente ans. Dornier a disparu en 1996, absorbé par Fairchild.',
    E'## Genesis\nDornier had been building bush utilities since the 1950s — the Do 27 flew in Ethiopia, the Congo, New Guinea. In 1965 the Bundeswehr wanted a liaison aircraft able to land on a training area, and Dornier offered a twin-engined version, entirely redrawn despite a name suggesting a simple evolution.\n\n## Design\nThe aircraft is ugly, deliberately so: a square-section fuselage, fixed gear on faired legs, **engines on pylons** held clear of the fuselage to free the cabin. Everything is designed for open-air maintenance by field mechanics. It takes off in two hundred and fifty metres and lands on a meadow, which nothing else of its size then did.\n\n## Operational career\nTwo hundred and seventy built, fifteen countries. The **Luftwaffe** and the **Marineflieger** used it for thirty years for liaison, light transport, photography and — in the OU version — electronic surveillance of the Baltic. Israel, Nigeria, Turkey, Kenya and Thailand also bought it.\n\n## Place in history\nTwo hundred and seventy built. The Skyservant is the antithesis of the vertical take-off **Do 31** the same firm was building at the same moment: that one cost a fortune and produced nothing, this one cost next to nothing and served thirty years. Dornier disappeared in 1996, absorbed by Fairchild.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1965-01-01',
    '1966-02-23',
    '1971-01-01',
    325.0,
    1150.0,
    (SELECT id FROM manufacturer WHERE code = 'DOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.41,
  wingspan          = 15.55,
  height            = 3.9,
  wing_area         = 29.0,
  empty_weight      = 2328,
  mtow              = 3842,
  service_ceiling   = 7680,
  climb_rate        = 6.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IGSO-540-A1E',
  engine_count      = 2,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = 1986,
  units_built       = 270,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **Do 28 D / D-2** : versions de série, la D-2 à envergure accrue\n- **Do 28 D-2 OU** : version de guerre électronique de la **Marineflieger**\n- **Do 128** : version remotorisée en turbopropulseurs, produite jusqu''en 1986\n- Moteurs montés sur **pylônes courts** sous l''aile, hors du fuselage\n- Décolle en **250 m** et se pose sur une prairie : conçu pour l''aide au développement',
  variants_en       = E'- **Do 28 D / D-2** : production versions, the D-2 with greater span\n- **Do 28 D-2 OU** : electronic warfare version of the **Marineflieger**\n- **Do 128** : turboprop conversion, built until 1986\n- Engines on **short pylons** under the wing, clear of the fuselage\n- Take-off in **250 m** and landing on a meadow: designed for development aid',

  -- Strate 4 : qualitatif
  nickname          = 'Skyservant',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dornier_Do_28',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dornier_Do_28',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Thomas Vogt from Paderborn, Deutschland',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Dornier Do 28 Skyservant';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dornier Do 28 Skyservant';
