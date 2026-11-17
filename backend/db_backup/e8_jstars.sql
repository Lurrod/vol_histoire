-- Northrop Grumman E-8 Joint STARS
--
-- Photo : Air Refueling Mission 110517-F-RH591-068.jpg
--   licence Public domain — Master Sgt. William Greer
--   https://commons.wikimedia.org/wiki/File:Air_Refueling_Mission_110517-F-RH591-068.jpg

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
    'E-8 Joint STARS',
    'E-8 Joint STARS',
    'Northrop Grumman E-8 Joint STARS',
    'Northrop Grumman E-8 Joint STARS',
    'Un Boeing 707 qui voyait bouger les chars à 250 km derrière la ligne de front',
    'A Boeing 707 that could watch tanks moving 250 km behind the front line',
    '/assets/airplanes/e8-jstars.jpg',
    E'## Genèse\nL''US Army et l''US Air Force mènent chacune un programme pour repérer et frapper les blindés ennemis au-delà de la ligne de front. En 1982, les deux projets fusionnent et l''Air Force en prend la tête. Le concept et la technologie du capteur sont éprouvés sur l''appareil expérimental **Tacit Blue**, puis Grumman reçoit en septembre 1985 le contrat de deux **E-8A** de développement. Le premier vole le 1er avril 1988.\n\n## Conception\nL''E-8C est un **Boeing 707-300** d''occasion profondément modifié. Sous l''avant du fuselage, un radôme en forme de canoë de 12 m abrite l''antenne de 7,3 m du radar latéral **AN/APY-7**, une antenne active capable de couvrir près de 50 000 km² et de suivre 600 cibles à plus de 250 km. En indication de cibles mobiles, il distingue un char d''un camion ; en mode synthétique, il photographie les objets immobiles. Dix-huit opérateurs travaillent dans la cabine, et la situation est transmise presque en temps réel aux stations de l''Army par une liaison de données protégée contre le brouillage.\n\n## Carrière opérationnelle\nEncore en développement, les deux E-8A sont engagés dès 1991 dans **Tempête du désert** : 49 sorties de combat, plus de 500 heures, à suivre les colonnes irakiennes et les lanceurs de Scud. Ils surveillent ensuite l''application des accords de Dayton en **Bosnie**, avant que la flotte opérationnelle n''appuie l''opération **Allied Force** au **Kosovo** en 1999. Le dix-septième et dernier E-8C est livré le 23 mars 2005. Après les attentats de 2001, les Joint STARS restent dix-huit ans au-dessus de l''Irak et de l''Afghanistan, pour 10 938 sorties. Fin 2021, ils reprennent leur mission d''origine en surveillant les troupes russes massées aux portes de l''Ukraine.\n\n## Place dans l''histoire\nLe Joint STARS a fait pour le champ de bataille terrestre ce que l''AWACS avait fait pour le ciel : une vue d''ensemble des mouvements adverses, transmise à qui doit frapper. L''Air Force renonce en 2019 à lui donner un successeur, préférant un réseau de satellites et de capteurs. Les retraits commencent en février 2022, et le dernier vol a lieu le 15 novembre 2023, au terme de 14 000 sorties et 141 000 heures en 32 ans de service.',
    E'## Genesis\nThe US Army and US Air Force each ran a programme to detect and strike enemy armour beyond the front line. In 1982 the two projects merged, with the Air Force in the lead. The concept and sensor technology were proven on the **Tacit Blue** experimental aircraft, then Grumman received in September 1985 the contract for two **E-8A** development aircraft. The first flew on 1 April 1988.\n\n## Design\nThe E-8C is a heavily modified second-hand **Boeing 707-300**. Under the forward fuselage, a 12 m canoe-shaped radome houses the 7.3 m antenna of the **AN/APY-7** side-looking radar, an active array able to cover nearly 50,000 km² and track 600 targets beyond 250 km. In moving-target mode it can tell a tank from a truck; in synthetic aperture mode it images stationary objects. Eighteen operators work in the cabin, and the picture is relayed in near-real time to Army ground stations over a jam-resistant data link.\n\n## Operational career\nStill in development, the two E-8As were committed to **Desert Storm** in 1991: 49 combat sorties and over 500 hours tracking Iraqi columns and Scud launchers. They then monitored compliance with the Dayton accords in **Bosnia**, before the operational fleet supported **Allied Force** over **Kosovo** in 1999. The seventeenth and last E-8C was delivered on 23 March 2005. After the 2001 attacks, Joint STARS spent eighteen years over Iraq and Afghanistan, flying 10,938 sorties. In late 2021 they returned to their original mission, watching Russian troops massing on Ukraine''s borders.\n\n## Place in history\nJoint STARS did for the land battlefield what AWACS had done for the sky: an overall picture of enemy movements, passed to those who must strike. In 2019 the Air Force gave up on a successor, preferring a network of satellites and sensors. Retirements began in February 2022, and the last flight took place on 15 November 2023, after 14,000 sorties and 141,000 hours over 32 years of service.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1982-01-01',
    '1988-04-01',
    '1991-01-01',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'E-8 Joint STARS'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.61,
  wingspan          = 44.42,
  height            = 12.95,
  wing_area         = NULL,
  empty_weight      = 77564,
  mtow              = 152407,
  service_ceiling   = 12802,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 22,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney TF33-PW-102',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 85.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = 2005,
  units_built       = 17,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **E-8A** : deux appareils de développement engagés dès 1991 dans Tempête du désert\n- **TE-8A** : un E-8A débarrassé de son équipement de mission pour l''entraînement des équipages\n- **YE-8B** : cellule destinée à l''E-6 de la Navy, transférée à l''Air Force comme avion de développement\n- **E-8C** : version de série tirée de Boeing 707 d''occasion, dont un ancien CC-137 canadien ; dix-sept livrés jusqu''en 2005',
  variants_en       = E'- **E-8A**: two development aircraft committed to Desert Storm as early as 1991\n- **TE-8A**: one E-8A stripped of its mission equipment for crew training\n- **YE-8B**: airframe intended as a Navy E-6, transferred to the Air Force as a development aircraft\n- **E-8C**: production version converted from second-hand Boeing 707s, one of them a former Canadian CC-137; seventeen delivered up to 2005',

  -- Strate 4 : qualitatif
  nickname          = 'JSTARS',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Grumman_E-8_Joint_STARS',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_E-8_Joint_STARS',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Master Sgt. William Greer, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'E-8 Joint STARS';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'E-8 Joint STARS';
