-- Israel Aerospace Industries Heron (Machatz-1)
--
-- Photo : IAI Heron( framed).jpg
--   licence Public domain — SSGT REYNALDO RAMON
--   https://commons.wikimedia.org/wiki/File%3AIAI_Heron%28_framed%29.jpg

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
    'IAI Heron',
    'IAI Heron',
    'Israel Aerospace Industries Heron (Machatz-1)',
    'Israel Aerospace Industries Heron (Machatz-1)',
    'Drone de surveillance de longue endurance, exporté sur quatre continents',
    'Long-endurance surveillance drone, exported across four continents',
    '/assets/airplanes/iai-heron.jpg',
    E'## Genèse\nIsraël est le pays qui a inventé l''emploi militaire moderne du drone : dès 1982, dans la **vallée de la Bekaa**, des engins sans pilote servent de leurres et de guetteurs pour détruire les batteries syriennes. Le Heron naît dix ans plus tard de la volonté de passer du drone tactique de quelques heures à un appareil capable de rester en l''air **deux jours entiers**, à moyenne altitude et longue endurance — la catégorie dite MALE.\n\n## Conception\nCellule légère à double poutre de queue et hélice propulsive placée à l''arrière, dégageant le nez pour les capteurs. Le moteur à pistons Rotax, dérivé de l''aviation légère, consomme peu — c''est le carburant, pas la structure, qui limite ces appareils. Le Heron vole de manière **entièrement automatique**, du décollage à l''atterrissage, et peut poursuivre sa mission programmée si la liaison satellite est perdue.\n\n## Carrière opérationnelle\nEmployé par Israël au **Liban** et à Gaza, il est surtout devenu un succès d''exportation majeur : une vingtaine de pays l''utilisent, dont l''Inde, la Turquie, l''Australie, le Canada, l''Allemagne, le Brésil et Singapour. La **France** en a acquis une version francisée, le Harfang, engagée en Afghanistan puis au Sahel avant l''arrivée du Reaper.\n\n## Place dans l''histoire\nLe Heron a fait de l''industrie israélienne le premier exportateur mondial de drones pendant deux décennies. Là où le **MQ-9 Reaper** américain a imposé le drone armé, le Heron a imposé le drone d''observation persistante — et beaucoup d''armées européennes ont découvert la surveillance de longue durée en le louant avant d''acheter le leur.',
    E'## Genesis\nIsrael is the country that invented the modern military use of drones: as early as 1982, in the **Bekaa Valley**, unmanned aircraft served as decoys and spotters to destroy Syrian missile batteries. The Heron was born ten years later of the wish to move from a tactical drone lasting a few hours to one able to stay aloft for **two whole days**, at medium altitude and long endurance — the category known as MALE.\n\n## Design\nA light twin-boom airframe with a pusher propeller at the rear, freeing the nose for sensors. The Rotax piston engine, derived from light aviation, uses little fuel — and it is fuel, not structure, that limits these aircraft. The Heron flies **fully automatically**, from take-off to landing, and can continue its programmed mission if the satellite link is lost.\n\n## Operational career\nUsed by Israel over **Lebanon** and Gaza, it above all became a major export success: some twenty countries operate it, among them India, Turkey, Australia, Canada, Germany, Brazil and Singapore. **France** acquired a localised version, the Harfang, committed in Afghanistan and then the Sahel before the Reaper arrived.\n\n## Place in history\nThe Heron made Israeli industry the world''s leading drone exporter for two decades. Where the American **MQ-9 Reaper** established the armed drone, the Heron established the persistent observation drone — and many European armies discovered long-endurance surveillance by leasing one before buying their own.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1993-01-01',
    '1994-10-18',
    '2005-01-01',
    207.0,
    3300.0,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'IAI Heron'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.5,
  wingspan          = 16.6,
  height            = 2.3,
  wing_area         = NULL,
  empty_weight      = 550,
  mtow              = 1250,
  service_ceiling   = 10000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 350,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2005,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **Heron 1** : version de base, endurance de cinquante-deux heures\n- **Heron TP (Eitan)** : version lourde à turbopropulseur, envergure de vingt-six mètres\n- **Harfang** : version française dérivée, employée en Afghanistan et au Sahel\n- **Heron MK II** : version modernisée à capteurs longue portée, livrée à l''**Inde**\n- Cellule à **double poutre de queue** et hélice propulsive, formule commune aux drones MALE',
  variants_en       = E'- **Heron 1** : baseline version, fifty-two hours endurance\n- **Heron TP (Eitan)** : heavy turboprop version with a twenty-six-metre span\n- **Harfang** : derived French version, used in Afghanistan and the Sahel\n- **Heron MK II** : upgraded version with long-range sensors, delivered to **India**\n- **Twin-boom** airframe with a pusher propeller, a layout common to MALE drones',

  -- Strate 4 : qualitatif
  nickname          = 'Machatz-1',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Heron',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Heron',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'SSGT REYNALDO RAMON',
  image_licence     = 'Public domain'
WHERE name = 'IAI Heron';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI Heron';
