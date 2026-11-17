-- IAI RQ-5 Hunter
--
-- Photo : B-Hunter Landing.jpg
--   licence CC BY-SA 4.0 — Seb5340
--   https://commons.wikimedia.org/wiki/File:B-Hunter_Landing.jpg

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
    'RQ-5 Hunter',
    'RQ-5 Hunter',
    'IAI RQ-5 Hunter',
    'IAI RQ-5 Hunter',
    'Le drone israélien à deux moteurs que l''US Army a failli abandonner, puis gardé vingt ans du Kosovo à l''Irak',
    'The twin-engined Israeli drone the US Army nearly dropped, then kept for twenty years from Kosovo to Iraq',
    '/assets/airplanes/rq5-hunter.jpg',
    E'## Genèse\nLe **Hunter** est un drone conçu par **Israel Aerospace Industries**, que l''**US Army** choisit comme système à courte portée au service des commandants de division et de corps d''armée. Produit en association avec l''américain **TRW**, plus tard absorbé par **Northrop Grumman**, il prend la désignation RQ-5. L''achat et la formation commencent en 1994, mais le programme tourne mal : en 1996, la production est arrêtée pour mauvaise gestion, après seulement sept systèmes de présérie de huit appareils chacun.\n\n## Conception\nLe Hunter se reconnaît à sa double motorisation en tandem, une hélice tractive à l''avant et une hélice propulsive à l''arrière : deux moteurs Moto Guzzi sur le RQ-5A, deux diesels sur le **MQ-5B** des années 2000. Il décolle et se pose sur piste, freiné à l''atterrissage par un brin d''arrêt. Sa tourelle optique et infrarouge transmet la vidéo en temps réel par liaison en bande C, et un second Hunter peut servir de relais pour en guider un premier au-delà de l''horizon ou derrière un relief, une capacité propre au type. La version MQ-5B tient jusqu''à 21 heures en l''air.\n\n## Carrière opérationnelle\nLe sauvetage vient du **Kosovo**. En mars 1999, une compagnie équipée de Hunter s''installe en Macédoine pour la campagne de l''OTAN ; un appareil est abattu à la mitrailleuse depuis un hélicoptère Mi-8 yougoslave, et au moins sept sont perdus en 78 jours, mais la flotte vole plus de 4 000 heures en sept mois. Le succès relance la production. En 2003, le Hunter est le premier drone de l''US Army à entrer en **Irak** ; il sert aussi en **Afghanistan** et, dans sa version MQ-5B, emporte la munition guidée **Viper Strike**. Il effectue son dernier vol dans l''Army le 16 décembre 2015 à Fort Hood.\n\n## Place dans l''histoire\nPromis à la disparition dès 1996, puis censé céder sa place au plus petit RQ-7 Shadow, le Hunter est resté parce que sa charge utile, son rayon d''action et son endurance n''avaient pas d''équivalent dans l''Army. Il a dépassé les 110 000 heures de vol, avant de céder la place au **MQ-1C Gray Eagle**. La Belgique, qui avait acheté en 1998 trois systèmes B-Hunter, a retiré son dernier exemplaire le 28 août 2020, remplacé par le MQ-9B SkyGuardian.',
    E'## Genesis\nThe **Hunter** is a drone designed by **Israel Aerospace Industries**, chosen by the **US Army** as a short-range system serving division and corps commanders. Built in partnership with the American firm **TRW**, later absorbed by **Northrop Grumman**, it received the designation RQ-5. Acquisition and training began in 1994, but the programme went badly: in 1996 production was halted over mismanagement, after only seven low-rate initial production systems of eight aircraft each.\n\n## Design\nThe Hunter is recognisable by its tandem twin-engine layout, a tractor propeller at the front and a pusher at the rear: two Moto Guzzi engines on the RQ-5A, two diesels on the **MQ-5B** of the 2000s. It takes off and lands on a runway, stopped on landing by an arresting wire. Its electro-optical and infrared turret relays video in real time over a C-band link, and a second Hunter can act as a relay to guide the first beyond the horizon or behind high ground, a capability unique to the type. The MQ-5B version can stay aloft for up to 21 hours.\n\n## Operational career\nRescue came from **Kosovo**. In March 1999 a Hunter company deployed to Macedonia for the NATO campaign; one aircraft was shot down by a machine gun fired from a Yugoslav Mi-8 helicopter, and at least seven were lost in 78 days, but the fleet flew more than 4,000 hours in seven months. That success restarted production. In 2003 the Hunter was the first US Army drone to enter **Iraq**; it also served in **Afghanistan** and, in its MQ-5B version, carried the **Viper Strike** guided munition. It made its last Army flight on 16 December 2015 at Fort Hood.\n\n## Place in history\nMarked for extinction in 1996, then meant to give way to the smaller RQ-7 Shadow, the Hunter stayed on because its payload, range and endurance had no equivalent in the Army. It passed 110,000 flight hours before giving way to the **MQ-1C Gray Eagle**. Belgium, which had bought three B-Hunter systems in 1998, retired its last aircraft on 28 August 2020, replaced by the MQ-9B SkyGuardian.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    NULL,
    '1995-01-01',
    170,
    125,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM armement WHERE name = 'GBU-44/B Viper Strike'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'RQ-5 Hunter'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.01,
  wingspan          = 10.57,
  height            = 1.9,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 885,
  service_ceiling   = 5500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Mercedes HFE diesel (56 ch)',
  engine_count      = 2,
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
  operators_count   = 3,
  variants          = E'- **RQ-5A** : version initiale de l''US Army, deux moteurs Moto Guzzi de 60 ch en tandem\n- **MQ-5A/B** : versions armées de la munition guidée GBU-44/B Viper Strike ; le MQ-5B, développé à partir de 2005, vole plus haut et plus longtemps grâce à deux diesels\n- **B-Hunter** : version de la composante air belge, trois systèmes de six appareils achetés en 1998',
  variants_en       = E'- **RQ-5A**: initial US Army version, two 60 hp Moto Guzzi engines in tandem\n- **MQ-5A/B**: versions armed with the GBU-44/B Viper Strike guided munition; the MQ-5B, developed from 2005, flies higher and longer on two diesels\n- **B-Hunter**: Belgian Air Component version, three systems of six aircraft bought in 1998',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_RQ-5_Hunter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_RQ-5_Hunter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Seb5340',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'RQ-5 Hunter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'RQ-5 Hunter';
