-- EADS Harfang (SIDM)
--
-- Photo : Harfang-090711-F-4859J-003.jpg
--   licence Public domain — U.S. Air Force photo/Senior Airman Felicia Juenke
--   https://commons.wikimedia.org/wiki/File:Harfang-090711-F-4859J-003.jpg

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
    'EADS Harfang',
    'EADS Harfang',
    'EADS Harfang (SIDM)',
    'EADS Harfang (SIDM)',
    'Version française du Heron israélien, premier drone MALE de l''armée de l''air, de Bagram au Mali',
    'French version of the Israeli Heron, the French Air Force''s first MALE drone, from Bagram to Mali',
    '/assets/airplanes/eads-harfang.jpg',
    E'## Genèse\nL''armée de l''air française acquiert ses premiers drones en 1995 : des **RQ-5 Hunter**. Présenté au salon du Bourget en 1999, l''**IAI Heron** israélien suscite son intérêt, et un projet d''en dériver une version française est lancé deux ans plus tard : le **Système intérimaire de drone MALE** (SIDM, pour moyenne altitude longue endurance), mené par **EADS** avec **Israel Aerospace Industries**. Attendu à l''été 2003 pour remplacer les Hunter, retirés en septembre 2004, il prend un retard considérable : sa liaison satellite ne répond pas aux exigences de l''armée de l''air, et le produit « sur étagère » devient un appareil fait sur mesure. Le prototype est lancé pour ses essais depuis la base d''Istres le 9 septembre 2006.\n\n## Conception\nLa cellule et l''ordinateur de bord sont construits par **Malat**, une division d''IAI, sur la base du Heron. Le Harfang est un monoplan à aile haute munie de volets et d''un système de dégivrage, à empennage bipoutre, mû par un moteur **Rotax** turbocompressé de 115 ch entraînant une hélice propulsive. Pour 1 200 kg au décollage, il emporte 250 kg de charge à 7 500 m pendant 24 heures : une boule gyrostabilisée à trois capteurs — optronique, infrarouge, désignateur laser — et un **radar à synthèse d''ouverture** qui suit les véhicules au sol par tous les temps. Il décolle et atterrit seul ; sa station sol le commande en vue directe jusqu''à 200 km, au-delà par satellite. Il lui manque des capteurs électromagnétiques, il manœuvre peu et redoute le givre.\n\n## Carrière opérationnelle\nCommandé à trois exemplaires avec deux stations sol, le SIDM entre en service en juin 2008 à l''escadron d''expérimentation drones 1/330 « Adour ». Il surveille la visite du pape **Benoît XVI** à Lourdes, puis part en février 2009 pour **Bagram**, en **Afghanistan**, où l''un des trois appareils est accidenté, probablement à cause du givre. En août 2011, des Harfang opèrent au-dessus de la **Libye**. En 2013, ils soutiennent l''**opération Serval au Mali**, où ils réalisent leur centième sortie dans la nuit du 5 au 6 juin, après 1 600 heures de vol sur ce théâtre.\n\n## Place dans l''histoire\nLe Harfang a payé cher son statut de solution intérimaire : le ministère de la Défense y a consacré 440 millions d''euros contre cent prévus, et la version **Eagle 2** à turbopropulseur a été abandonnée. Il a néanmoins assuré à l''armée de l''air la surveillance continue de trois théâtres d''opérations, avant de céder la place aux **MQ-9 Reaper** commandés en 2013. Retirés début 2018, ses trois appareils sont livrés en 2020 au Maroc, qui les avait achetés en 2014.',
    E'## Genesis\nThe French Air Force bought its first drones in 1995: **RQ-5 Hunters**. Shown at the Paris Air Show in 1999, the Israeli **IAI Heron** caught its interest, and a project to field a French derivative was launched two years later: the **Système intérimaire de drone MALE** (SIDM, the interim medium-altitude, long-endurance drone system), led by **EADS** with **Israel Aerospace Industries**. Due in the summer of 2003 to replace the Hunters, which were phased out in September 2004, it fell badly behind schedule: its satellite link did not meet Air Force requirements, and the ''off-the-shelf'' product became a custom-built aircraft. The prototype was launched for trials from Istres on 9 September 2006.\n\n## Design\nThe airframe and onboard computer are built by **Malat**, a division of IAI, on the basis of the Heron. The Harfang is a high-wing monoplane with flaps and an anti-icing system and a twin-boom tail, powered by a 115 hp turbocharged **Rotax** engine driving a pusher propeller. At 1,200 kg take-off weight it carries a 250 kg payload to 7,500 m for 24 hours: a gyro-stabilised three-sensor ball — optronic, infrared and laser designator — and a **synthetic aperture radar** that tracks vehicles on the ground in any weather. It takes off and lands automatically; its ground station controls it by line of sight out to 150 to 200 km, and beyond that by satellite. It lacks electromagnetic sensors, has little manoeuvrability and is vulnerable to icing.\n\n## Operational career\nOrdered as three aircraft and two ground stations, the SIDM entered service in June 2008 with Drone Experimentation Squadron 1/330 ''Adour''. It watched over Pope **Benedict XVI**''s visit to Lourdes, then deployed in February 2009 to **Bagram**, in **Afghanistan**, where one of the three aircraft crashed, probably because of icing. In August 2011 Harfangs flew over **Libya**. In 2013 they supported **Operation Serval in Mali**, where they flew their hundredth sortie on the night of 5-6 June, after 1,600 flight hours in that theatre.\n\n## Place in history\nThe Harfang paid dearly for being an interim solution: the French Ministry of Defence spent 440 million euros on it against a hundred million planned, and the turboprop **Eagle 2** version was abandoned. It nevertheless gave the Air Force continuous surveillance over three theatres of operations before giving way to the **MQ-9 Reapers** ordered in 2013. Retired in early 2018, its three aircraft were delivered in 2020 to Morocco, which had bought them in 2014 for $48 million.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '2001-01-01',
    '2006-09-09',
    '2008-06-01',
    148,
    1000,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EADS Harfang'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'EADS Harfang'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EADS Harfang'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'EADS Harfang'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'EADS Harfang'), (SELECT id FROM wars WHERE name = 'Intervention en Libye')),
((SELECT id FROM airplanes WHERE name = 'EADS Harfang'), (SELECT id FROM wars WHERE name = 'Guerre du Sahel'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.3,
  wingspan          = 16.6,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 657,
  mtow              = 1250,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914F (115 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Eagle 0** : prototype, premier vol en 1998\n- **Eagle 1** : première version de production, premier vol le 2 juin 2003 en Israël\n- **SIDM / Harfang** : version de l''armée de l''air française, liaison satellite spécifique, en service de 2008 à 2018\n- **Eagle MPR** : version navale de l''Eagle 1\n- **Eagle 2** : version agrandie à turbopropulseur Pratt & Whitney PT6, abandonnée',
  variants_en       = E'- **Eagle 0**: prototype, first flight in 1998\n- **Eagle 1**: first production version, first flight on 2 June 2003 in Israel\n- **SIDM / Harfang**: French Air Force version with a dedicated satellite link, in service from 2008 to 2018\n- **Eagle MPR**: naval version of the Eagle 1\n- **Eagle 2**: larger version with a Pratt & Whitney PT6 turboprop, abandoned',

  -- Strate 4 : qualitatif
  nickname          = 'Harfang',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/EADS_Harfang',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/EADS_Harfang',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Airman Felicia Juenke, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'EADS Harfang';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EADS Harfang';
