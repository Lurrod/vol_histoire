-- Tupolev Tu-143 Reys (VR-3)
--
-- Photo : Tupolev Tu-143 Reys ‘104217’ (37642263235).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ATupolev_Tu-143_Reys_%E2%80%98104217%E2%80%99_%2837642263235%29.jpg

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
    'Tu-143 Reys',
    'Tu-143 Reys',
    'Tupolev Tu-143 Reys (VR-3)',
    'Tupolev Tu-143 Reys (VR-3)',
    'Drone tactique soviétique produit à près de mille exemplaires',
    'Soviet tactical drone built in nearly a thousand examples',
    '/assets/airplanes/tu143-reys.jpg',
    E'## Genèse\nLa doctrine soviétique des années 1970 prévoit une offensive rapide en Europe centrale, ce qui suppose de savoir en permanence ce qui se trouve **à cinquante kilomètres devant** les colonnes blindées. Envoyer un avion de reconnaissance sous une défense antiaérienne dense coûte des pilotes. Tupolev propose un engin jetable.\n\n## Conception\nHuit mètres de long, une tonne, une aile delta minuscule et un petit turboréacteur. Le Tu-143 est lancé d''une **rampe montée sur camion** avec un propulseur-fusée d''appoint, vole une mission programmée d''avance de cent quatre-vingts kilomètres, puis revient et se pose **au parachute** sur un patin ventral. La pellicule est développée au sol dans l''heure.\n\n## Carrière opérationnelle\nNeuf cent cinquante exemplaires entre 1973 et 1989, six armées. Il est exporté vers l''Irak et la Syrie, qui l''emploient l''une contre l''Iran, l''autre au Liban. Son grand frère, le **Tu-141 Strizh**, plus lourd et plus lointain, remplit le même rôle à l''échelle de l''armée.\n\n## Place dans l''histoire\nNeuf cent cinquante exemplaires : le drone de reconnaissance le plus produit du bloc de l''Est. Sa logique — un engin bon marché, programmé, jetable — est exactement celle qui revient aujourd''hui avec les munitions rôdeuses, après quarante ans d''engouement pour le drone endurant et coûteux.',
    E'## Genesis\nSoviet doctrine in the 1970s planned a rapid offensive in central Europe, which meant knowing at all times what lay **fifty kilometres ahead** of the armoured columns. Sending a reconnaissance aircraft under dense air defences costs pilots. Tupolev offered a disposable machine.\n\n## Design\nEight metres long, a tonne, a tiny delta wing and a small turbojet. The Tu-143 is launched from a **truck-mounted rail** with a solid rocket booster, flies a pre-programmed hundred-and-eighty-kilometre mission, then returns and lands **by parachute** on a ventral skid. The film is developed on the ground within the hour.\n\n## Operational career\nNine hundred and fifty built between 1973 and 1989, six armies. It was exported to Iraq and Syria, which used it against Iran and in Lebanon respectively. Its bigger brother, the **Tu-141 Strizh**, heavier and longer-ranged, fills the same role at army level.\n\n## Place in history\nNine hundred and fifty built: the most-produced reconnaissance drone of the Eastern bloc. Its logic — a cheap, pre-programmed, expendable machine — is exactly the one returning today with loitering munitions, after forty years of enthusiasm for the expensive, long-endurance drone.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1968-01-01',
    '1970-12-01',
    '1976-01-01',
    950.0,
    180.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.06,
  wingspan          = 2.24,
  height            = 1.55,
  wing_area         = 2.9,
  empty_weight      = 1012,
  mtow              = 1230,
  service_ceiling   = 3000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 90,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'TR3-117',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 5.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1973,
  production_end    = 1989,
  units_built       = 950,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **Tu-143 (VR-3 Reys)** : version de reconnaissance photo et vidéo\n- **Tu-143 à charge chimique** : variante de détection de contamination radiologique\n- Lancé depuis une **rampe sur camion**, avec un propulseur-fusée d''appoint\n- Récupéré au **parachute**, l''appareil se posant sur un patin ventral\n- Exporté vers la **Tchécoslovaquie**, la **Roumanie**, l''**Irak** et la **Syrie**',
  variants_en       = E'- **Tu-143 (VR-3 Reys)** : photographic and video reconnaissance version\n- **Chemical-payload Tu-143** : variant for detecting radiological contamination\n- Launched from a **truck-mounted rail** with a solid rocket booster\n- Recovered by **parachute**, settling onto a ventral skid\n- Exported to **Czechoslovakia**, **Romania**, **Iraq** and **Syria**',

  -- Strate 4 : qualitatif
  nickname          = 'Reys',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-143',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-143',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Tu-143 Reys';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tu-143 Reys';
