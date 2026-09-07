-- GAF N22 / N24 Nomad
--
-- Photo : GAF N22B Nomad.jpg
--   licence CC BY-SA 4.0 — Z3144228
--   https://commons.wikimedia.org/wiki/File%3AGAF_N22B_Nomad.jpg

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
    'GAF Nomad',
    'GAF Nomad',
    'GAF N22 / N24 Nomad',
    'GAF N22 / N24 Nomad',
    'Le seul avion de transport australien, et une réputation contestée',
    'Australia’s only transport aircraft, and a disputed reputation',
    '/assets/airplanes/gaf-nomad.jpg',
    E'## Genèse\nL''Australie a besoin d''un appareil capable de desservir l''*outback* et la Papouasie-Nouvelle-Guinée alors sous administration australienne : des pistes courtes, en terre, à des centaines de kilomètres de tout. Aucun avion étranger ne correspond exactement. Les **Government Aircraft Factories**, qui produisaient jusque-là le Jindivik et des Mirage sous licence, conçoivent le Nomad.\n\n## Conception\nAile haute à volets pleine envergure, empennage en T, deux petits turbopropulseurs **Allison 250** et un train fixe simplifié. L''appareil décolle en **deux cent quarante mètres** et se pose plus court encore. La formule est celle d''un utilitaire de brousse, dimensionné pour douze à seize passagers plutôt que pour du fret lourd.\n\n## Carrière opérationnelle\nCent soixante-douze exemplaires, douze pays — Australie, Indonésie, Papouasie, Philippines, Thaïlande. Sa carrière est ternie par une série d''accidents attribués à des **ruptures d''empennage** ; l''armée australienne le retire en 1995, et l''appareil fait l''objet d''une enquête parlementaire.\n\n## Place dans l''histoire\nCent soixante-douze exemplaires. Le Nomad reste **le seul avion de transport conçu et produit en Australie**, et le dernier appareil habité des Government Aircraft Factories, fermées en 1987. Le pays construit encore des drones et des composants, mais plus d''avions complets.',
    E'## Genesis\nAustralia needed an aircraft able to serve the outback and Papua New Guinea, then under Australian administration: short dirt strips hundreds of kilometres from anywhere. No foreign aircraft fitted exactly. The **Government Aircraft Factories**, until then building the Jindivik and Mirages under licence, designed the Nomad.\n\n## Design\nA high wing with full-span flaps, a T-tail, two small **Allison 250** turboprops and simplified fixed gear. The aircraft takes off in **two hundred and forty metres** and lands shorter still. The formula is that of a bush utility, sized for twelve to sixteen passengers rather than heavy freight.\n\n## Operational career\nOne hundred and seventy-two built, twelve countries — Australia, Indonesia, Papua, the Philippines, Thailand. Its career is clouded by a series of accidents attributed to **tailplane failures**; the Australian military withdrew it in 1995, and the aircraft became the subject of a parliamentary inquiry.\n\n## Place in history\nOne hundred and seventy-two built. The Nomad remains **the only transport aircraft designed and built in Australia**, and the last manned aircraft of the Government Aircraft Factories, closed in 1987. The country still builds drones and components, but no complete aircraft.',
    (SELECT id FROM countries WHERE code = 'AUS'),
    '1965-01-01',
    '1971-07-23',
    '1975-01-01',
    311.0,
    1352.0,
    (SELECT id FROM manufacturer WHERE code = 'GAF'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'GAF Nomad'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'GAF Nomad'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'GAF Nomad'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'GAF Nomad'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.56,
  wingspan          = 16.46,
  height            = 5.52,
  wing_area         = 30.1,
  empty_weight      = 2150,
  mtow              = 4264,
  service_ceiling   = 6400,
  climb_rate        = 6.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison 250-B17C',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1971,
  production_end    = 1985,
  units_built       = 172,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 12,
  variants          = E'- **N22** : version courte d''origine, douze passagers\n- **N24** : fuselage allongé de 1,14 m, seize passagers\n- **Searchmaster B / L** : versions de patrouille maritime à radar de nez\n- Décollage en **240 m** : conçu pour l''*outback* australien et la Papouasie\n- Retiré du service australien en **1995** après plusieurs accidents de rupture d''empennage',
  variants_en       = E'- **N22** : original short version, twelve passengers\n- **N24** : fuselage stretched by 1.14 m, sixteen passengers\n- **Searchmaster B / L** : maritime patrol versions with a nose radar\n- Take-off in **240 m**: designed for the Australian outback and Papua\n- Withdrawn from Australian service in **1995** after several tailplane failures',

  -- Strate 4 : qualitatif
  nickname          = 'Nomad',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/GAF_Nomad',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/GAF_Nomad',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Z3144228',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'GAF Nomad';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'GAF Nomad';
