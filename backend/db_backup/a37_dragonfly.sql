-- Cessna A-37 Dragonfly
--
-- Photo : OA-37B-1 (centered).jpg
--   licence Public domain — TSGT KEN HAMMOND
--   https://commons.wikimedia.org/wiki/File%3AOA-37B-1_%28centered%29.jpg

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
    'A-37 Dragonfly',
    'A-37 Dragonfly',
    'Cessna A-37 Dragonfly',
    'Cessna A-37 Dragonfly',
    'Avion-école transformé en appareil d’attaque, le plus léger du Vietnam',
    'Trainer turned attack aircraft, the lightest of the Vietnam War',
    '/assets/airplanes/a37-dragonfly.jpg',
    E'## Genèse\nL''US Air Force cherche au Vietnam un appareil d''attaque **peu coûteux**, capable d''opérer depuis des terrains courts et d''être confié à l''aviation sud-vietnamienne. Plutôt que de concevoir, elle prend son entraîneur **T-37 Tweet**, en double la poussée et lui ajoute huit points d''emport.\n\n## Conception\nSièges côte à côte hérités de l''école, aile droite, deux petits J85. L''A-37B reçoit des réservoirs autoobturants, un blindage de cockpit et une perche de ravitaillement. Sa charge utile atteint **2 500 kg** — près de la moitié de sa masse à vide, un rapport que peu d''appareils atteignent.\n\n## Carrière opérationnelle\nLe Dragonfly effectue plus de **160 000 sorties** au Vietnam avec un taux de perte remarquablement bas, grâce à sa petite taille et à sa maniabilité à basse altitude. Après 1975, les appareils capturés servent dans l''armée de l''air vietnamienne. Une quinzaine de pays d''Amérique latine et d''Asie l''utilisent ensuite, certains jusque dans les années 2010.\n\n## Place dans l''histoire\nL''A-37 est la démonstration la plus économique de cette encyclopédie : **200 000 dollars** l''unité en 1970, contre plus de deux millions pour un F-105. Il a prouvé qu''un avion-école bien conçu pouvait devenir un appareil de combat crédible — leçon que reprendront le Hawk 200, le FA-50 et le M-346FA.',
    E'## Genesis\nIn Vietnam the US Air Force needed a **cheap** attack aircraft able to operate from short strips and be handed to the South Vietnamese air force. Rather than design one, it took its **T-37 Tweet** trainer, doubled its thrust and added eight hardpoints.\n\n## Design\nSide-by-side seats inherited from the school aircraft, a straight wing, two small J85s. The A-37B received self-sealing tanks, cockpit armour and a refuelling probe. Its payload reaches **2,500 kg** — nearly half its empty weight, a ratio few aircraft achieve.\n\n## Operational career\nThe Dragonfly flew more than **160,000 sorties** over Vietnam with a remarkably low loss rate, thanks to its small size and low-level agility. After 1975 captured aircraft served in the Vietnamese air force. Some fifteen Latin American and Asian countries flew it afterwards, several into the 2010s.\n\n## Place in history\nThe A-37 is the most economical demonstration in this encyclopedia: **$200,000** a unit in 1970, against more than two million for an F-105. It proved that a well-designed trainer could become a credible combat aircraft — a lesson taken up by the Hawk 200, the FA-50 and the M-346FA.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1962-01-01',
    '1963-10-22',
    '1967-08-01',
    816.0,
    1628.0,
    (SELECT id FROM manufacturer WHERE code = 'CES'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM armement WHERE name = 'Hydra 70')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.62,
  wingspan          = 10.93,
  height            = 2.7,
  wing_area         = 17.09,
  empty_weight      = 2817,
  mtow              = 6350,
  service_ceiling   = 12730,
  climb_rate        = 34,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 740,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-17A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 12.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1975,
  units_built       = 577,
  unit_cost_usd     = 200000,
  unit_cost_year    = 1970,
  operators_count   = 15,
  variants          = E'- **A-37A** : conversion directe du T-37 d''entraînement\n- **A-37B** : structure renforcée, réservoirs autoobturants, perche de ravitaillement\n- **OA-37B** : version de contrôle aérien avancé\n- Toujours en service en **Amérique du Sud** dans les années 2010',
  variants_en       = E'- **A-37A** : direct conversion of the T-37 trainer\n- **A-37B** : strengthened structure, self-sealing tanks, refuelling probe\n- **OA-37B** : forward air control version\n- Still in service in **South America** into the 2010s',

  -- Strate 4 : qualitatif
  nickname          = 'Super Tweet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Cessna_A-37_Dragonfly',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Cessna_A-37_Dragonfly',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'TSGT KEN HAMMOND',
  image_licence     = 'Public domain'
WHERE name = 'A-37 Dragonfly';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'A-37 Dragonfly';
