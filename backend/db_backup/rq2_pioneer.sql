-- AAI/IAI RQ-2 Pioneer
--
-- Photo : DN-ST-87-03310 (17056761199).jpg
--   licence Public domain — Chief Photographer's Mate Jeff Hilton
--   https://commons.wikimedia.org/wiki/File:DN-ST-87-03310_(17056761199).jpg

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
    'RQ-2 Pioneer',
    'RQ-2 Pioneer',
    'AAI/IAI RQ-2 Pioneer',
    'AAI/IAI RQ-2 Pioneer',
    'Le petit drone israélien lancé à la fusée depuis un cuirassé, auquel des soldats irakiens se sont rendus en 1991',
    'The small Israeli drone rocket-launched from a battleship, to which Iraqi soldiers surrendered in 1991',
    '/assets/airplanes/rq2-pioneer.jpg',
    E'## Genèse\nAu début des années 1980, l''armée israélienne obtient des résultats remarqués avec ses petits drones d''observation, le **Tadiran Mastiff** puis l''**IAI Scout**. Impressionnée, l''**US Navy** décide en 1985 d''acquérir un système comparable, d''abord pour régler le tir des canons des cuirassés de la classe **Iowa**, ensuite pour les besoins tactiques des Marines. Après des essais comparatifs, elle retient un appareil qu''**Israel Aircraft Industries** a tiré du Scout en 1984. IAI fonde avec l''américain **AAI Corporation** une coentreprise installée à Hunt Valley, dans le Maryland, et neuf systèmes de huit drones sont achetés début 1986 pour environ 87,7 millions de dollars.\n\n## Conception\nLe Pioneer est au fond un Scout remotorisé pour emporter davantage : le bicylindre deux temps Limbach cède la place à un Fichtel & Sachs plus puissant, qui entraîne une hélice propulsive. C''est un petit monoplan à aile haute, à double poutre et double dérive, posé sur un train tricycle fixe, qui tient environ cinq heures en l''air. En mer, il décolle à l''aide de fusées d''appoint et revient se jeter dans un filet tendu à la poupe du navire ; à terre, il part d''une catapulte ou d''une piste et se pose avec un brin d''arrêt. Sa tourelle optique et infrarouge transmet une vidéo analogique en temps réel.\n\n## Carrière opérationnelle\nLes débuts sont pénibles : interférences avec l''électronique des navires, récupérations ratées, accidents en série. La **guerre du Golfe** change tout. En 1991, les Pioneer volent 545 sorties ; l''un d''eux, lancé par le cuirassé **USS Wisconsin**, filme la reddition de soldats irakiens sur l''île de Failaka, juste après le bombardement de leurs tranchées par l''**USS Missouri**. Le drone sert ensuite en Somalie, en Bosnie, au Kosovo et en Irak, avant d''être retiré par l''US Navy et les Marines en 2007, remplacé par le **RQ-7 Shadow**.\n\n## Place dans l''histoire\nAcheté comme un matériel d''attente, hors des procédures habituelles, le Pioneer est devenu le premier drone tactique en service dans les forces américaines et a tenu plus de vingt ans. Il a montré au Pentagone ce qu''apportait un œil sans pilote au-dessus du champ de bataille, et sa lignée se prolonge dans le Shadow, son descendant direct chez AAI. Le Smithsonian a demandé, pour ses collections, l''exemplaire précis auquel les Irakiens s''étaient rendus.',
    E'## Genesis\nIn the early 1980s the Israeli army achieved striking results with its small observation drones, the **Tadiran Mastiff** and then the **IAI Scout**. Impressed, the **US Navy** decided in 1985 to acquire a comparable system, first to spot the fall of shot for the guns of the **Iowa**-class battleships, then for the tactical needs of the Marines. After comparative trials it chose an aircraft that **Israel Aircraft Industries** had derived from the Scout in 1984. IAI set up a joint venture with the American **AAI Corporation** at Hunt Valley, Maryland, and nine systems of eight drones each were bought in early 1986 for about 87.7 million dollars.\n\n## Design\nThe Pioneer is essentially a Scout re-engined to carry more: the Limbach two-stroke twin gave way to a more powerful Fichtel & Sachs driving a pusher propeller. It is a small high-wing monoplane with twin booms and twin fins on a fixed tricycle undercarriage, able to stay aloft for about five hours. At sea it took off with rocket boosters and came back into a net rigged at the ship''s stern; ashore it left from a catapult or a runway and landed with an arresting wire. Its electro-optical and infrared turret relayed analogue video in real time.\n\n## Operational career\nThe early years were difficult: interference from shipboard electronics, botched recoveries and a string of accidents. The **Gulf War** changed everything. In 1991 the Pioneers flew 545 sorties; one of them, launched by the battleship **USS Wisconsin**, watched Iraqi soldiers on Failaka Island surrender, just after **USS Missouri** had shelled their trenches. The drone then served in Somalia, Bosnia, Kosovo and Iraq, before being retired by the US Navy and the Marines in 2007 and replaced by the **RQ-7 Shadow**.\n\n## Place in history\nBought as a stopgap, outside the usual procurement rules, the Pioneer became the first tactical drone in American service and lasted more than twenty years. It showed the Pentagon what an unmanned eye over the battlefield could bring, and its line continues in the Shadow, its direct descendant at AAI. The Smithsonian asked, for its collections, for the very aircraft to which the Iraqis had surrendered.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1984-01-01',
    NULL,
    '1986-12-01',
    NULL,
    185,
    (SELECT id FROM manufacturer WHERE code = 'AAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM wars WHERE name = 'Intervention en Somalie')),
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'RQ-2 Pioneer'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 4.3,
  wingspan          = 5.15,
  height            = 1.0,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 205,
  service_ceiling   = 4600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Fichtel & Sachs SF2-350 (26 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1986,
  production_end    = NULL,
  units_built       = 175,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **RQ-2A** : version initiale livrée à partir de juillet 1986, avionique analogique\n- **RQ-2B** : réservoirs agrandis (« Configuration 2+ »), trente exemplaires neufs livrés en 1995-1996, puis avionique numérique, GPS et récupération automatique\n- **RQ-2C** : modernisation des RQ-2B de l''US Navy avec le moteur rotatif UEL AR-741 du Shadow',
  variants_en       = E'- **RQ-2A**: initial version delivered from July 1986, analogue avionics\n- **RQ-2B**: enlarged tanks ("Configuration 2+"), thirty new aircraft delivered in 1995-1996, later digital avionics, GPS and automatic recovery\n- **RQ-2C**: upgrade of US Navy RQ-2Bs with the Shadow''s UEL AR-741 rotary engine',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/RQ-2_Pioneer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AAI_RQ-2_Pioneer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'PHC Jeff Hilton, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'RQ-2 Pioneer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'RQ-2 Pioneer';
