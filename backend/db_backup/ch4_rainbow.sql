-- CASC CH-4 Rainbow (Caihong-4)
--
-- Photo : CH-4 at Airshow China Zhuhai 2022.jpg
--   licence CC BY-SA 4.0 — Infinty 0
--   https://commons.wikimedia.org/wiki/File:CH-4_at_Airshow_China_Zhuhai_2022.jpg

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
    'CASC CH-4 Rainbow',
    'CASC CH-4 Rainbow',
    'CASC CH-4 Rainbow (Caihong-4)',
    'CASC CH-4 Rainbow (Caihong-4)',
    'Le sosie chinois du MQ-9 Reaper, drone armé exporté de l''Irak à l''Indonésie',
    'China''s MQ-9 Reaper look-alike, an armed drone exported from Iraq to Indonesia',
    '/assets/airplanes/ch4-rainbow.jpg',
    E'## Genèse\nLe CH-4 appartient à la famille **Rainbow**, ou Caihong (« arc-en-ciel »), de drones commercialisés par la **China Aerospace Science and Technology Corporation** (CASC) et produits par son Académie chinoise d''aérodynamique aérospatiale. Il succède aux petits CH-1 et CH-2 de reconnaissance et au **CH-3**, premier drone de combat de la série, qui a volé en 2007 et emporte 70 kg de charge. Le CH-4 vise un cran au-dessus : celui des drones de moyenne altitude et longue endurance, capables de surveiller puis de frapper.\n\n## Conception\nVu de l''extérieur, le CH-4 est presque identique au **MQ-9 Reaper** américain ; seule l''absence de dérive ventrale sous l''empennage en V les distingue. Long de 8,5 m pour 18 m d''envergure, il pèse 1 300 kg au décollage et peut tenir l''air 40 heures grâce à un moteur à pistons de 100 ch. Il existe en deux versions : le **CH-4A** de reconnaissance, d''une autonomie de 30 à 40 heures et d''un rayon d''action de 3 500 à 5 000 km, et le **CH-4B**, mixte attaque-reconnaissance, avec six emplacements d''armes et jusqu''à 345 kg de charge. Il tire ses missiles air-sol **AR-1** et AR-2, ou des bombes guidées FT, depuis 5 000 m, hors de portée de la plupart des canons antiaériens.\n\n## Carrière opérationnelle\nL''Irak reçoit ses premiers CH-4 vers 2015 et les engage contre l''**État islamique** ; mais en 2019, un seul de ses appareils reste pleinement opérationnel, les autres étant cloués au sol par des problèmes de maintenance. Dans la guerre civile du **Yémen**, la coalition menée par l''Arabie saoudite lance des CH-4 saoudiens et émiratis contre les Houthis : plus d''une douzaine d''appareils saoudiens sont perdus avant juillet 2022. L''Algérie, l''Éthiopie, l''Indonésie, le Pakistan, le Soudan, la Zambie, la République démocratique du Congo et l''Arménie l''ont aussi adopté.\n\n## Place dans l''histoire\nLe CH-4 a fait de la série Rainbow un succès d''exportation : une usine de CASC le produit en Birmanie, l''armée de terre chinoise en a tiré le **KVD002** de reconnaissance et de frappe de précision, et le drone **Saqr-1** passe pour s''en être largement inspiré. Son successeur, le **CH-5**, plus grand, partage avec lui une liaison de données qui permet aux deux appareils d''opérer ensemble.',
    E'## Genesis\nThe CH-4 belongs to the **Rainbow**, or Caihong, family of drones marketed by the **China Aerospace Science and Technology Corporation** (CASC) and built by its China Academy of Aerospace Aerodynamics. It followed the small CH-1 and CH-2 reconnaissance drones and the **CH-3**, the first combat drone in the series, which flew in 2007 and carries a 70 kg payload. The CH-4 aimed one step higher: the class of medium-altitude, long-endurance drones able to watch and then strike.\n\n## Design\nFrom the outside the CH-4 looks almost identical to the American **MQ-9 Reaper**; the only visible difference is the lack of a ventral fin below the V-tail. It is 8.5 m long with an 18 m span, weighs 1,300 kg at take-off and can stay aloft for 40 hours on a 100 hp piston engine. There are two versions: the **CH-4A** for reconnaissance, with 30 to 40 hours'' endurance and a range of 3,500 to 5,000 km, and the **CH-4B**, a mixed attack and reconnaissance model with six weapon stations and up to 345 kg of payload. It can fire its **AR-1** and AR-2 air-to-surface missiles, or FT guided bombs, from 5,000 m, beyond the reach of most anti-aircraft guns.\n\n## Operational career\nIraq received its first CH-4s around 2015 and used them against the **Islamic State**; but by 2019 only one was fully mission capable, the rest being grounded by maintenance problems. In the **Yemeni** civil war, the Saudi-led coalition used Saudi and Emirati CH-4s against the Houthi movement: more than twelve Saudi aircraft had been lost by July 2022. Algeria, Ethiopia, Indonesia, Pakistan, Sudan, Zambia, the Democratic Republic of the Congo and Armenia have also adopted it.\n\n## Place in history\nThe CH-4 turned the Rainbow series into an export success: a CASC factory builds it in Myanmar, the Chinese Army derived the **KVD002** reconnaissance and precision strike drone from it, and the **Saqr-1** is thought to be largely based on it. Its larger successor, the **CH-5**, shares a data link with it that lets the two aircraft operate together.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    NULL,
    NULL,
    NULL,
    435,
    3500,
    (SELECT id FROM manufacturer WHERE code = 'CASC'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-4 Rainbow'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-4 Rainbow'), (SELECT id FROM armement WHERE name = 'AR-1'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-4 Rainbow'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'CASC CH-4 Rainbow'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'CASC CH-4 Rainbow'), (SELECT id FROM wars WHERE name = 'Guerre contre l''État islamique')),
((SELECT id FROM airplanes WHERE name = 'CASC CH-4 Rainbow'), (SELECT id FROM wars WHERE name = 'Guerre civile yéménite'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.5,
  wingspan          = 18,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1300,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Moteur à pistons (100 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 14,
  variants          = E'- **CH-4A** : version de reconnaissance, 30 à 40 heures d''autonomie\n- **CH-4B** : version mixte attaque-reconnaissance, six emplacements d''armes et jusqu''à 345 kg de charge\n- **KVD002** : drone de reconnaissance et de frappe de précision de l''armée de terre chinoise, dérivé du CH-4\n- **Production birmane** : CH-4B assemblés sous licence dans une usine de CASC en Birmanie',
  variants_en       = E'- **CH-4A**: reconnaissance version, 30 to 40 hours'' endurance\n- **CH-4B**: mixed attack and reconnaissance version, six weapon stations and up to 345 kg of payload\n- **KVD002**: Chinese Army reconnaissance and precision strike drone derived from the CH-4\n- **Myanmar production**: CH-4Bs built under licence at a CASC factory in Myanmar',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASC_Rainbow',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Infinty 0',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'CASC CH-4 Rainbow';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASC CH-4 Rainbow';
