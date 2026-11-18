-- Teledyne Ryan Model 154 / AQM-91A Firefly
--
-- Photo : Teledyne Ryan AQM-91A Compass Arrow USAF.jpg
--   licence Public domain — USAF Museum
--   https://commons.wikimedia.org/wiki/File:Teledyne_Ryan_AQM-91A_Compass_Arrow_USAF.jpg

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
    'Ryan AQM-91 Firefly',
    'Ryan AQM-91 Firefly',
    'Teledyne Ryan Model 154 / AQM-91A Firefly',
    'Teledyne Ryan Model 154 / AQM-91A Firefly',
    'Drone espion furtif conçu pour survoler Lop Nor, mis sous cocon quand Nixon tendit la main à Pékin',
    'Stealthy spy drone designed to overfly Lop Nor, mothballed when Nixon reached out to Beijing',
    '/assets/airplanes/aqm91-firefly.jpg',
    E'## Genèse\nPendant la guerre du Vietnam, le drone de reconnaissance **Ryan Model 147 Lightning Bug** rend de grands services, mais il n''a pas l''allonge nécessaire pour pénétrer loin en Chine et en revenir. Le centre d''essais nucléaires chinois de **Lop Nor** est hors de sa portée et à peine à celle de l''avion espion **U-2**, l''un comme l''autre devenus trop vulnérables aux missiles sol-air. Ryan démarche l''US Air Force au début de 1966 ; après une compétition contre North American Aviation, l''Air Force commande en juin 1966 cent **Model 154**, ou AQM-91A Firefly, dit aussi **Compass Arrow**.\n\n## Conception\nCe n''est pas un drone-cible modifié mais un appareil entièrement nouveau, pensé pour survivre. Le réacteur General Electric YJ97, placé sur le dos, est caché aux radars et aux capteurs infrarouges situés en dessous ; deux dérives inclinées vers l''intérieur masquent le jet, dont les gaz sont mélangés à de l''air froid. Le dessous du fuselage est plat, ses flancs inclinés renvoient les ondes radar, la structure fait une large place aux composites plastiques et les bords d''aile portent des inserts triangulaires en matériau absorbant. Largué par un DC-130 Hercules et récupéré en vol par hélicoptère, le Firefly monte jusqu''à 24 000 m avec une caméra Itek KA-80A et un dispositif d''autodestruction.\n\n## Essais\nLe système de guidage se révèle délicat et le premier vol propulsé n''a lieu qu''en septembre 1968 ; entre-temps, le **National Reconnaissance Office** a réduit la commande de série de 100 à 20 appareils. Le 4 août 1969, un prototype en panne descend sous parachute au milieu du centre de recherche nucléaire de Los Alamos, hors de toute zone interdite : la presse locale le photographie et l''Air Force le présente comme une « cible de haute altitude ». Les essais culminent fin 1971 par des évaluations à longue distance : le Model 154 dépasse ses objectifs d''altitude et se montre presque invisible au radar.\n\n## Place dans l''histoire\nLe besoin a pourtant disparu. En juillet 1971, **Richard Nixon** engage le rapprochement avec la Chine et les survols de reconnaissance sont annulés ; le satellite **KH-9 Hexagon**, lancé pour la première fois le 15 juin 1971, fournit le renseignement stratégique sans conséquence diplomatique. Les 28 Firefly construits, dont 20 de série qui ont coûté 250 millions de dollars, sont mis sous cocon en 1973 puis ferraillés. Selon des membres du programme, Israël a voulu les acquérir avant la guerre du Kippour, et Nixon aurait ordonné leur destruction pour l''en empêcher. Ryan en tire encore le **YQM-98** du programme Compass Cope.',
    E'## Genesis\nDuring the Vietnam War the **Ryan Model 147 Lightning Bug** reconnaissance drone served well over South-East Asia, but it lacked the range to fly deep into China and back. China''s **Lop Nor** nuclear test site was out of its reach and barely within that of the **U-2** spy plane, both of which had become far too vulnerable to surface-to-air missiles. Ryan pitched its advanced drone concepts to the US Air Force in early 1966; after a competition against North American Aviation, the Air Force ordered 100 **Model 154**s in June 1966, designated AQM-91A Firefly and also known as **Compass Arrow** after the programme name.\n\n## Design\nIt was not a modified target drone but an entirely new design built to survive. The General Electric YJ97 engine sat on top, hidden from radars and infrared sensors below; twin inward-canted fins concealed the exhaust, which was mixed with cool air. The fuselage had a flat bottom and sloping flat sides to deflect radar waves, the structure made wide use of plastic composites, and the wing edges carried triangular inserts of radar-absorbent material. Launched from a DC-130 Hercules and recovered in mid-air by helicopter, the Firefly climbed to 24,000 m with an Itek KA-80A camera and a self-destruct system.\n\n## Testing\nThe guidance system proved tricky and the first powered flight only took place in September 1968; meanwhile the **National Reconnaissance Office** had cut the production order from 100 to 20. On 4 August 1969 a failed prototype parachuted down inside the Los Alamos nuclear research complex, outside any restricted area: local newspeople photographed it and the Air Force described it as a high altitude target. Testing resumed and culminated in late 1971 with long-range evaluations: the Model 154 exceeded its altitude requirements and proved almost invisible to radar.\n\n## Place in history\nBy then the need had vanished. In July 1971 **Richard Nixon** began building ties with China and reconnaissance overflights were cancelled; the **KH-9 Hexagon** satellite, first launched on 15 June 1971, provided strategic intelligence without diplomatic consequences. The 28 Fireflies built, including 20 production models that cost $250 million, were mothballed in 1973 and later scrapped. According to programme members, Israel sought them before the Yom Kippur War, and Nixon is said to have personally ordered their destruction to prevent it. Ryan still drew from it the **YQM-98** for the Compass Cope programme.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1966-06-01',
    '1968-09-01',
    NULL,
    815,
    3220,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan AQM-91 Firefly'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Ryan AQM-91 Firefly'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan AQM-91 Firefly'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.4,
  wingspan          = 14.5,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 1725,
  mtow              = 2450,
  service_ceiling   = 24000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric YJ97-GE-3',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 28,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 154** : désignation Ryan, proche dans son principe du Model 136 Red Wagon, refusé au début des années 1960\n- **AQM-91A Firefly** : désignation militaire, aussi appelée **Compass Arrow** d''après le programme\n- **Prototypes et série** : 28 exemplaires, dont 20 de série après la réduction de commande de 100 à 20\n- **Mise en œuvre** : largage depuis un DC-130 Hercules, récupération en vol par hélicoptère',
  variants_en       = E'- **Model 154**: Ryan designation, similar in concept to the Model 136 Red Wagon turned down earlier in the 1960s\n- **AQM-91A Firefly**: military designation, also called **Compass Arrow** after the programme\n- **Prototypes and production**: 28 built, 20 of them production models after the order was cut from 100 to 20\n- **Operation**: launched from a DC-130 Hercules, recovered in mid-air by helicopter',

  -- Strate 4 : qualitatif
  nickname          = 'Compass Arrow',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_AQM-91_Firefly',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Ryan AQM-91 Firefly';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'Ryan AQM-91 Firefly';
