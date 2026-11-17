-- General Dynamics–Grumman EF-111A Raven
--
-- Photo : Deny Flight EF-111.jpg
--   licence Public domain — Tana R. Hamilton
--   https://commons.wikimedia.org/wiki/File:Deny_Flight_EF-111.jpg

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
    'EF-111 Raven',
    'EF-111 Raven',
    'General Dynamics–Grumman EF-111A Raven',
    'General Dynamics–Grumman EF-111A Raven',
    'Un F-111 désarmé, bourré de brouilleurs, qui ouvrait la route des raids en profondeur',
    'An unarmed F-111 packed with jammers that cleared the way for deep strike raids',
    '/assets/airplanes/ef111-raven.jpg',
    E'## Genèse\nÀ la fin des années 1960, l''US Air Force veut remplacer ses vieux **EB-66** et **EB-57** de guerre électronique. Elle étudie l''**EA-6B Prowler** de la Navy, mais réclame un brouilleur supersonique capable de pénétrer avec les formations d''assaut. En 1972, elle choisit de transformer des **F-111A**, solution économique et politiquement commode. Grumman, maître d''œuvre désigné en décembre 1974, modifie deux prototypes ; le premier, surnommé alors « Electric Fox », vole le 10 mars 1977.\n\n## Conception\nLe cœur du Raven est le brouilleur **AN/ALQ-99E**, dérivé de celui du Prowler : son électronique occupe la soute à armement, ses émetteurs un radôme ventral en forme de canoë de 4,9 m, et ses récepteurs une nacelle au sommet de la dérive. L''ensemble pèse 2 700 kg et impose de revoir les circuits électriques et de refroidissement. Le poste est réorganisé : le pilote garde toutes les commandes, l''officier de guerre électronique ses consoles. L''avion n''emporte aucune arme et ne peut tirer de missile antiradar ; sa seule défense est sa vitesse, Mach 2,2 en altitude.\n\n## Carrière opérationnelle\nLe Raven débute au combat en avril 1986 lors du raid **El Dorado Canyon** contre la Libye : partis d''Upper Heyford, cinq appareils parcourent 5 600 km pour aveugler les défenses libyennes. Deux EF-111A brouillent les radars adverses au **Panama** en 1989. Pendant la **guerre du Golfe**, dix-huit appareils accompagnent les raids au plus profond de l''Irak ; le 17 janvier 1991, l''équipage **James Denton** et **Brent Brandon** pousse un **Mirage F1** irakien à s''écraser au sol, victoire officieuse mais seule victoire aérienne de la famille F-111. Depuis Aviano, il soutient ensuite l''opération Deliberate Force en **Bosnie**.\n\n## Place dans l''histoire\nSur quarante-deux appareils convertis pour 1,5 milliard de dollars, trois seulement sont perdus en quinze ans. Les derniers EF-111 se posent le 2 mai 1998 à Cannon, au Nouveau-Mexique : ce sont les ultimes F-111 de l''US Air Force, victimes des économies de l''après-**guerre froide**. Le Raven a démontré qu''un brouilleur pouvait suivre les chasseurs-bombardiers jusqu''au cœur du dispositif ennemi, sans aucune arme, avec la seule électronique pour bouclier.',
    E'## Genesis\nIn the late 1960s the US Air Force wanted to replace its ageing **EB-66** and **EB-57** electronic warfare aircraft. It studied the Navy''s **EA-6B Prowler**, but wanted a supersonic jammer able to penetrate alongside strike packages. In 1972 it chose to convert **F-111A** airframes, an economical and politically convenient solution. Grumman, named prime contractor in December 1974, modified two prototypes; the first, then nicknamed "Electric Fox", flew on 10 March 1977.\n\n## Design\nThe heart of the Raven is the **AN/ALQ-99E** jammer, developed from the Prowler''s: its electronics fill the weapons bay, its transmitters a 4.9 m ventral canoe radome, and its receivers a pod on top of the fin. The installation weighs 2,700 kg and required reworked electrical and cooling systems. The cockpit was rearranged: the pilot keeps all the flight controls, the electronic warfare officer his consoles. The aircraft carries no weapons and cannot fire anti-radiation missiles; its only defence is speed, Mach 2.2 at altitude.\n\n## Operational career\nThe Raven made its combat debut in April 1986 in the **El Dorado Canyon** raid on Libya: flying from Upper Heyford, five aircraft covered 5,600 km to blind the Libyan defences. Two EF-111As jammed enemy radars over **Panama** in 1989. During the **Gulf War**, eighteen aircraft escorted raids deep into Iraq; on 17 January 1991 the crew of **James Denton** and **Brent Brandon** drove an Iraqi **Mirage F1** into the ground, an unofficial kill but the only air-to-air victory of the F-111 family. Flying from Aviano, it then supported Operation Deliberate Force over **Bosnia**.\n\n## Place in history\nOf forty-two aircraft converted for $1.5 billion, only three were lost in fifteen years. The last EF-111s landed on 2 May 1998 at Cannon, New Mexico: they were the US Air Force''s final F-111s, victims of the post-**Cold War** cutbacks. The Raven showed that a jammer could follow fighter-bombers into the heart of enemy defences with no weapons at all, using electronics alone as its shield.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1972-01-01',
    '1977-03-10',
    '1983-01-01',
    2350,
    3220,
    (SELECT id FROM manufacturer WHERE code = 'GD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Guerre électronique'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM wars WHERE name = 'Invasion du Panama')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'EF-111 Raven'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.17,
  wingspan          = 19.2,
  height            = 6.1,
  wing_area         = 61.07,
  empty_weight      = 25072,
  mtow              = 40370,
  service_ceiling   = 13715,
  climb_rate        = 55.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney TF30-P-9',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 53.0,
  thrust_wet        = 87.2,

  -- Strate 3 : production & service
  production_start  = 1975,
  production_end    = 1985,
  units_built       = 42,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Prototypes** : deux F-111A modifiés par Grumman à partir de 1975, premier vol complet le 10 mars 1977\n- **EF-111A** : quarante-deux conversions de F-111A, livrées jusqu''en 1985\n- **TF30-P-9** : réacteurs du F-111D montés en 1986, 53 kN à sec et 87 kN avec postcombustion\n- **Avionics Modernization Program** (1987-1994) : centrale inertielle à gyrolaser, radar de suivi de terrain AN/APQ-146, écrans multifonctions',
  variants_en       = E'- **Prototypes**: two F-111As modified by Grumman from 1975, first fully equipped flight on 10 March 1977\n- **EF-111A**: forty-two F-111A conversions, delivered up to 1985\n- **TF30-P-9**: F-111D engines fitted in 1986, 53 kN dry and 87 kN with afterburner\n- **Avionics Modernization Program** (1987-1994): ring laser gyro inertial system, AN/APQ-146 terrain-following radar, multi-function displays',

  -- Strate 4 : qualitatif
  nickname          = 'Spark-Vark',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/General_Dynamics_EF-111A_Raven',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/General_Dynamics–Grumman_EF-111A_Raven',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tana R. Hamilton, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'EF-111 Raven';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'EF-111 Raven';
