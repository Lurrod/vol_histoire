-- Raytheon Sentinel R1 (ASTOR)
--
-- Photo : Bombardier Sentinel R1 5D4 1145 (41982150810).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford and Largs, United Kingdom
--   https://commons.wikimedia.org/wiki/File:Bombardier_Sentinel_R1_5D4_1145_(41982150810).jpg

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
    'Raytheon Sentinel R1',
    'Raytheon Sentinel R1',
    'Raytheon Sentinel R1 (ASTOR)',
    'Raytheon Sentinel R1 (ASTOR)',
    'Global Express à radar ventral en canoë, qui a surveillé le sol de l''Afghanistan à la Libye pour la RAF',
    'Global Express with a canoe-shaped belly radar that watched the ground from Afghanistan to Libya for the RAF',
    '/assets/airplanes/raytheon-sentinel-r1.jpg',
    E'## Genèse\nLe Sentinel naît d''un programme de la guerre froide, le **CASTOR** de l''armée britannique, qui veut surveiller depuis le ciel les forces du pacte de Varsovie stationnées en Allemagne de l''Est ; un Britten-Norman Islander à gros radôme de nez teste l''idée dès 1984. La guerre du Golfe de 1991 confirme le besoin, mais la fin de la guerre froide et les coupes budgétaires freinent le projet. En décembre 1999, le Royaume-Uni signe enfin avec l''américain **Raytheon** le programme **ASTOR** (Airborne Stand-Off Radar) : cinq avions, huit stations au sol mobiles et un centre d''instruction à Waddington, pour 850 millions de livres.\n\n## Conception\nLe Sentinel R1 est un **Bombardier Global Express** dont quatre exemplaires sur cinq sont transformés par Raytheon à Broughton, dans le Flintshire. Sous le fuselage, un long carénage en canoë abrite le radar **DMRS**, à antenne active, qui combine imagerie à synthèse d''ouverture et détection des cibles mobiles ; il est apparenté à l''ASARS-2 de l''U-2. Volant au-dessus de 12 000 m pour voir loin, l''avion emporte un pilote, un copilote, un chef de mission et deux analystes d''images, pour environ neuf heures. L''autoprotection réunit un leurre radar remorqué, un détecteur d''approche de missiles et des lance-paillettes et leurres. L''essentiel de la gestion de bataille se fait au sol, contrairement au JSTARS américain.\n\n## Carrière opérationnelle\nLe premier Sentinel de série vole le 26 mai 2004. Sa première mission opérationnelle, au-dessus de l''Afghanistan au profit de l''armée britannique, a lieu le 15 novembre 2008, et le 5 Squadron le met en service régulier à Waddington début 2009. Le chef de la RAF qualifie son rôle de « déterminant » au-dessus de la Libye en 2011 ; le 30 mars, il y vole 12 h 30, son record. Il appuie ensuite les forces françaises au Mali en 2013, cartographie des inondations en Angleterre, cherche au Ghana les lycéennes enlevées par Boko Haram et surveille l''Irak et la Syrie contre l''État islamique à partir de 2015. Au-dessus de la Baltique, il guette les forces russes de Kaliningrad, souvent intercepté par des Su-27.\n\n## Place dans l''histoire\nRetrait annoncé en 2010, ajourné en 2014, puis repoussé en 2015 : ces hésitations privent le Sentinel de toute modernisation. Réduite à quatre avions en 2017, la flotte effectue sa dernière mission le 25 février 2021, près de Kaliningrad, après quelque 32 300 heures de vol en 4 870 sorties. Le Poseidon MRA1 et le futur drone Protector reprennent ses tâches, et les cellules sont revendues à un consortium américain en vue d''un usage par l''US Army.',
    E'## Genesis\nThe Sentinel grew out of a Cold War programme, the British Army''s **CASTOR**, which sought to watch from the air the Warsaw Pact forces stationed in East Germany; a Britten-Norman Islander with a large nose radome tested the idea from 1984. The 1991 Gulf War confirmed the need, but the end of the Cold War and defence cuts held the project back. In December 1999 the United Kingdom finally signed the **ASTOR** (Airborne Stand-Off Radar) programme with the American firm **Raytheon**: five aircraft, eight mobile ground stations and a training facility at Waddington, for £850 million.\n\n## Design\nThe Sentinel R1 is a **Bombardier Global Express**, four of the five being converted by Raytheon at Broughton, Flintshire. Beneath the fuselage a long canoe fairing houses the **DMRS** radar, an active electronically scanned array combining synthetic aperture imaging with moving target indication; it is related to the U-2''s ASARS-2. Flying above 12,000 m to see far, the aircraft carries a pilot, a co-pilot, a mission commander and two image analysts, for about nine hours. Self-protection comprises a towed radar decoy, a missile approach warning system and chaff and flare dispensers. Most battle management takes place on the ground, unlike the American JSTARS.\n\n## Operational career\nThe first production Sentinel flew on 26 May 2004. Its first operational sortie, over Afghanistan in support of the British Army, came on 15 November 2008, and No. 5 Squadron brought it into regular service at Waddington in early 2009. The head of the RAF called its role over Libya in 2011 "pivotal"; on 30 March it flew 12 hours 30 minutes there, its longest sortie. It went on to support French forces in Mali in 2013, mapped flooding in England, searched from Ghana for the schoolgirls abducted by Boko Haram and watched over Iraq and Syria against Islamic State from 2015. Over the Baltic it monitored Russian forces in Kaliningrad, often intercepted by Su-27s.\n\n## Place in history\nRetirement announced in 2010, reversed in 2014, then postponed in 2015: this indecision deprived the Sentinel of any upgrade. Cut to four aircraft in 2017, the fleet flew its last mission on 25 February 2021, near Kaliningrad, after some 32,300 flying hours in 4,870 sorties. The Poseidon MRA1 and the forthcoming Protector drone took over its tasks, and the airframes were sold to an American consortium with a view to use by the US Army.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1999-12-01',
    '2004-05-26',
    '2008-11-15',
    945,
    9249,
    (SELECT id FROM manufacturer WHERE code = 'RAY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM wars WHERE name = 'Intervention en Libye')),
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM wars WHERE name = 'Guerre du Sahel')),
((SELECT id FROM airplanes WHERE name = 'Raytheon Sentinel R1'), (SELECT id FROM wars WHERE name = 'Guerre contre l''État islamique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.3,
  wingspan          = 28.5,
  height            = 8.23,
  wing_area         = 94.9,
  empty_weight      = 24494,
  mtow              = 42411,
  service_ceiling   = 14935,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce BR710',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 65.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Islander CASTOR** : Britten-Norman Islander à grand radôme de nez, banc d''essai du concept de surveillance du champ de bataille en 1984\n- **Prototype aérodynamique** : Global Express modifié, premier vol le 3 août 2001 pour valider les formes du système ASTOR\n- **Sentinel R1** : cinq avions de série du 5 Squadron, radar DMRS et autoprotection DASS, retirés en mars 2021\n- **Overseer** : modernisation des systèmes de mission financée par Raytheon pendant plus de cinq ans, jamais appliquée',
  variants_en       = E'- **CASTOR Islander**: Britten-Norman Islander with a large nose radome, testbed for the battlefield surveillance concept in 1984\n- **Aerodynamic prototype**: modified Global Express, first flight on 3 August 2001 to validate the ASTOR system''s shapes\n- **Sentinel R1**: five production aircraft of No. 5 Squadron, DMRS radar and DASS self-protection, retired in March 2021\n- **Overseer**: mission system upgrade self-funded by Raytheon for over five years, never applied',

  -- Strate 4 : qualitatif
  nickname          = 'ASTOR',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Raytheon_Sentinel',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Raytheon_Sentinel',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Raytheon Sentinel R1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Raytheon Sentinel R1';
