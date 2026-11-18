-- Boeing YAL-1A Airborne Laser
--
-- Photo : YAL-1A Airborne Laser unstowed.jpg
--   licence Public domain — US Missile Defense Agency
--   https://commons.wikimedia.org/wiki/File:YAL-1A_Airborne_Laser_unstowed.jpg

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
    'Boeing YAL-1',
    'Boeing YAL-1',
    'Boeing YAL-1A Airborne Laser',
    'Boeing YAL-1A Airborne Laser',
    'Un Boeing 747 armé d''un laser d''un mégawatt pour détruire les missiles balistiques dès leur décollage',
    'A Boeing 747 armed with a megawatt laser to destroy ballistic missiles as they climb away from the launch pad',
    '/assets/airplanes/yal1.jpg',
    E'## Genèse\nDans les années 1980, un laser moins puissant installé à bord d''un **NKC-135A**, l''**Airborne Laser Laboratory**, abat déjà plusieurs missiles lors d''essais. L''US Air Force lance en 1996 le programme **Airborne Laser** (ABL) en confiant à **Boeing** un premier contrat : il s''agit de détruire les missiles balistiques tactiques pendant leur phase de propulsion, quand ils sont encore lents, brûlants et au-dessus du territoire ennemi. En 2001, le programme passe à la **Missile Defense Agency**. Boeing fournit l''avion et l''intégration, **Northrop Grumman** le laser, **Lockheed Martin** la tourelle de nez et la conduite de tir.\n\n## Conception\nL''avion est un **Boeing 747-400F** cargo, sorti d''usine à Everett et premier vol le 6 janvier 2000, transformé à Wichita ; il revole sous sa nouvelle forme le 18 juillet 2002. Son cœur est un laser chimique oxygène-iode, le **COIL**, de la classe du mégawatt : six modules grands chacun comme un SUV, d''environ 3 000 kg pièce. Des capteurs infrarouges détectent le missile, trois lasers de faible puissance mesurent sa course et la turbulence de l''air, qu''une optique adaptative compense, puis le laser principal tire trois à cinq secondes depuis la tourelle du nez. Il ne perce pas sa cible : il chauffe l''enveloppe, qui cède sous les efforts du vol.\n\n## Essais\nLe 15 mars 2007, l''avion atteint en vol avec son laser de poursuite une cible peinte sur un **NC-135E Big Crow**. Le 18 août 2009, le laser de haute énergie tire pour la première fois en vol, dans un calorimètre embarqué. Le 11 février 2010, au large de la Californie, il détruit un missile balistique à carburant liquide en phase de propulsion ; moins d''une heure plus tard, un second missile, à poudre, est engagé sans être détruit, mais un missile identique l''avait été huit jours plus tôt. Pour la Missile Defense Agency, c''est la première fois qu''une arme à énergie dirigée abat un missile balistique. Mais **Robert Gates** juge le concept irréaliste : il faudrait un laser vingt à trente fois plus puissant, ou que l''avion tourne au-dessus de l''Iran.\n\n## Place dans l''histoire\nPrivé de crédits en 2010, le programme est arrêté en décembre 2011 après seize ans de développement et plus de cinq milliards de dollars. Le YAL-1 rejoint en février 2012 le cimetière de Davis-Monthan, où il est ferraillé en septembre 2014. Il a pourtant prouvé qu''une arme laser aéroportée pouvait abattre un missile balistique. La Missile Defense Agency étudie ensuite un laser électrique sur drone de haute altitude, avant d''y renoncer faute de puissance suffisante.',
    E'## Genesis\nIn the 1980s a less powerful laser fitted in an **NKC-135A**, the **Airborne Laser Laboratory**, had already shot down several missiles in tests. In 1996 the US Air Force launched the **Airborne Laser** (ABL) programme, awarding **Boeing** a first contract: the aim was to destroy tactical ballistic missiles during their boost phase, while still slow, hot and over enemy territory. In 2001 the programme passed to the **Missile Defense Agency**. Boeing provided the aircraft and integration, **Northrop Grumman** the laser and **Lockheed Martin** the nose turret and fire control system.\n\n## Design\nThe aircraft was a **Boeing 747-400F** freighter, built at Everett and first flown on 6 January 2000, converted at Wichita; it flew again in its new form on 18 July 2002. Its heart was a megawatt-class chemical oxygen iodine laser, the **COIL**: six modules each as large as an SUV, weighing about 3,000 kg apiece. Infrared sensors detected the missile, three low-power lasers measured its course and the air turbulence, which adaptive optics compensated for, then the main laser fired for three to five seconds from the nose turret. It did not burn through its target: it heated the skin, which failed under the stresses of flight.\n\n## Testing\nOn 15 March 2007 the aircraft hit, in flight, a target painted on an **NC-135E Big Crow** with its tracking laser. On 18 August 2009 the high-energy laser fired in flight for the first time, into an onboard calorimeter. On 11 February 2010, off California, it destroyed a liquid-fuelled ballistic missile in its boost phase; less than an hour later a second, solid-fuelled missile was engaged but not destroyed, although an identical one had been destroyed eight days earlier. For the Missile Defense Agency, it was the first time a directed-energy weapon had brought down a ballistic missile. But **Robert Gates** judged the concept unworkable: it would need a laser twenty to thirty times more powerful, or the aircraft would have to orbit over Iran.\n\n## Place in history\nDenied funding in 2010, the programme was ended in December 2011 after sixteen years of development and more than five billion dollars. The YAL-1 flew to the Davis-Monthan boneyard in February 2012 and was scrapped there in September 2014. Yet it had proved that an airborne laser weapon could shoot down a ballistic missile. The Missile Defense Agency then studied an electric laser on a high-altitude drone, before giving up for lack of sufficient power.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1996-01-01',
    '2002-07-18',
    NULL,
    1014,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YAL-1'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YAL-1'), (SELECT id FROM armement WHERE name = 'Laser chimique oxygène-iode (COIL)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YAL-1'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Boeing YAL-1'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 70.6,
  wingspan          = 64.4,
  height            = 19.4,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 396893,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-80C2B5F',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 276,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Airborne Laser Laboratory** : précurseur des années 1980, laser moins puissant monté sur un NKC-135A\n- **Banc d''intégration (SIL)** : fuselage d''un 747-200 d''Air India installé à Edwards pour essayer le laser au sol, plus de 50 tirs\n- **YAL-1A** : le 747-400F transformé, seul exemplaire construit, désigné ainsi en 2004\n- **Second ABL** : deuxième avion prévu, annulé sur recommandation de Robert Gates le 6 avril 2009',
  variants_en       = E'- **Airborne Laser Laboratory**: 1980s forerunner, a less powerful laser fitted in an NKC-135A\n- **System Integration Laboratory (SIL)**: an Air India 747-200 fuselage installed at Edwards to test the laser on the ground, fired more than 50 times\n- **YAL-1A**: the converted 747-400F, the only one built, so designated in 2004\n- **Second ABL**: a second aircraft that was planned, cancelled on Robert Gates''s recommendation on 6 April 2009',

  -- Strate 4 : qualitatif
  nickname          = 'Airborne Laser',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_YAL-1_Airborne_Laser',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_YAL-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'US Missile Defense Agency',
  image_licence     = 'Public domain'
WHERE name = 'Boeing YAL-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing YAL-1';
