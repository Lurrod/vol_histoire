-- Antonov An-32 (Cline)
--
-- Photo : Indian Air Force Antonov An-32.jpg
--   licence CC BY-SA 3.0 — Dmitry Karpezo
--   https://commons.wikimedia.org/wiki/File%3AIndian_Air_Force_Antonov_An-32.jpg

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
    'Antonov An-32',
    'Antonov An-32',
    'Antonov An-32 (Cline)',
    'Antonov An-32 (Cline)',
    'Un An-26 remotorisé pour l’Himalaya, à la demande de l’Inde',
    'An An-26 re-engined for the Himalaya, at India’s request',
    '/assets/airplanes/an32.jpg',
    E'## Genèse\nL''Inde exploite des **An-26** soviétiques et se heurte à un problème que Kiev n''avait pas prévu : aux altitudes himalayennes et par quarante degrés, l''appareil ne décolle plus à pleine charge. New Delhi demande une version plus puissante. Antonov répond en 1975 par une refonte de la motorisation.\n\n## Conception\nLes turbopropulseurs passent de deux mille huit cents à **cinq mille cent chevaux** — presque le double. Ces moteurs sont trop gros pour tenir sous l''aile : Antonov les monte **au-dessus**, sur des pylônes, silhouette immédiatement reconnaissable. Les hélices, dégagées du sol, peuvent grandir ; les hypersustentateurs sont revus. L''appareil décolle désormais de Leh, à trois mille cinq cents mètres.\n\n## Carrière opérationnelle\nTrois cent soixante et un exemplaires, vingt-cinq pays. L''**Inde** en est de loin le premier utilisateur avec plus de cent appareils, employés pour le ravitaillement des postes du Ladakh et du Siachen — le champ de bataille le plus élevé du monde. La version **Firekiller** combat les incendies en Ukraine, en Libye et au Portugal.\n\n## Place dans l''histoire\nTrois cent soixante et un exemplaires. L''An-32 est le cas rare d''un appareil soviétique **conçu à la demande d''un client étranger** et pour ses conditions, non pour celles de l''URSS. Il complète dans ce catalogue la lignée Antonov — An-2, An-12, An-72, An-124 — devenue ukrainienne en 1991.',
    E'## Genesis\nIndia operated Soviet **An-26s** and ran into a problem Kyiv had not foreseen: at Himalayan altitudes and forty degrees of heat, the aircraft would not take off at full load. New Delhi asked for a more powerful version. Antonov answered in 1975 with a complete change of powerplant.\n\n## Design\nThe turboprops go from two thousand eight hundred to **five thousand one hundred horsepower** — nearly double. These engines are too large to fit under the wing: Antonov mounts them **above** it, on pylons, an immediately recognisable silhouette. The propellers, cleared of the ground, can grow; the high-lift devices are revised. The aircraft now takes off from Leh, at thirty-five hundred metres.\n\n## Operational career\nThree hundred and sixty-one built, twenty-five countries. **India** is by far the largest user with more than a hundred aircraft, used to resupply the posts of Ladakh and Siachen — the highest battlefield in the world. The **Firekiller** version fights fires in Ukraine, Libya and Portugal.\n\n## Place in history\nThree hundred and sixty-one built. The An-32 is the rare case of a Soviet aircraft **designed at a foreign customer''s request** and for that customer''s conditions, not the USSR''s. In this catalogue it completes the Antonov line — An-2, An-12, An-72, An-124 — which became Ukrainian in 1991.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1975-01-01',
    '1976-07-09',
    '1984-01-01',
    530.0,
    2500.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-32'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-32'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-32'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-32'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.78,
  wingspan          = 29.2,
  height            = 8.75,
  wing_area         = 74.98,
  empty_weight      = 16800,
  mtow              = 27000,
  service_ceiling   = 9500,
  climb_rate        = 10.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-20DM',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1976,
  production_end    = 2012,
  units_built       = 361,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 25,
  variants          = E'- **An-32** : version de base, dérivée de l''**An-26** remotorisée\n- **An-32B-100** : version modernisée, charge portée à 7,5 tonnes\n- **An-32P Firekiller** : version de lutte contre l''incendie, huit tonnes d''eau\n- **An-32RE** : modernisation ukrainienne de la flotte **indienne**, cent quatre appareils\n- Moteurs **surélevés au-dessus de l''aile** : hélices dégagées, puissance doublée',
  variants_en       = E'- **An-32** : basic version, a re-engined derivative of the **An-26**\n- **An-32B-100** : upgraded version, payload raised to 7.5 tonnes\n- **An-32P Firekiller** : firefighting version, eight tonnes of water\n- **An-32RE** : Ukrainian upgrade of the **Indian** fleet, one hundred and four aircraft\n- Engines **raised above the wing**: propellers cleared, power doubled',

  -- Strate 4 : qualitatif
  nickname          = 'Cline',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-32',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-32',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dmitry Karpezo',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Antonov An-32';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-32';
