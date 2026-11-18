-- Tupolev Tu-214R (projet 141)
--
-- Photo : Tupolev Tu-214R RA-64511 2012-12-17.jpg
--   licence CC BY 4.0 — Japan Ministry of Defense / JASDF
--   https://commons.wikimedia.org/wiki/File:Tupolev_Tu-214R_RA-64511_2012-12-17.jpg

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
    'Tupolev Tu-214R',
    'Tupolev Tu-214R',
    'Tupolev Tu-214R (projet 141)',
    'Tupolev Tu-214R (Project 141)',
    'Biréacteur de ligne russe devenu avion espion, essayé au-dessus de la mer du Japon puis déployé en Syrie',
    'Russian twinjet airliner turned spy plane, tested over the Sea of Japan and then deployed to Syria',
    '/assets/airplanes/tupolev-tu214r.jpg',
    E'## Genèse\nPendant des décennies, le renseignement électronique aéroporté russe repose sur l''**Il-20**, dérivé du quadrimoteur à hélices Il-18. Pour lui trouver un successeur, Moscou lance le **projet 141** sur la base du **Tu-214**, version alourdie du biréacteur de ligne **Tu-204** construite par l''usine de Kazan. Le choix n''a rien d''un hasard : doté de réservoirs supplémentaires et d''une structure renforcée, le Tu-214 est la plate-forme que le gouvernement russe a retenue pour toutes ses versions « missions spéciales ». Le Tu-214R vole depuis 2012.\n\n## Conception\nLa cellule reste celle d''un avion de ligne de 46 mètres : commandes de vol électriques, aile supercritique à winglets, deux réacteurs Aviadvigatel PS-90A de 158 kN. L''équipement, lui, est entièrement militaire. L''appareil emporte la charge de renseignement **MRC-411**, qui associe capteurs de renseignement électronique (ELINT), radar latéral à synthèse d''ouverture, interception des signaux (SIGINT) et capteurs électro-optiques multispectraux. Il doit ainsi rassembler dans un seul avion ce que le vieil Il-20 faisait avec des moyens d''une autre époque.\n\n## Carrière opérationnelle\nLes premiers vols d''essai se déroulent au-dessus de la mer du Japon, et le programme connaît des difficultés en janvier 2013. L''avion est montré au public au salon **MAKS** d''août 2013, présenté comme capable de surveiller les États-Unis dans le cadre du traité Ciel ouvert ; début 2015, deux exemplaires poursuivent leurs essais avec l''armée de l''air russe. En février 2016, un Tu-214R est déployé sur la base de **Lattaquié**, en Syrie. En juillet de la même année, deux vols le mènent le long des frontières lettone, estonienne et finlandaise, à quelques dizaines de kilomètres de la Finlande. Déclaré apte au combat après l''opération syrienne, il aurait été engagé contre l''Ukraine en 2022.\n\n## Place dans l''histoire\nLe Tu-214R marque le passage du renseignement aéroporté russe des turbopropulseurs des années 1960 à un biréacteur moderne, plus rapide et doté de capteurs regroupés. Construit à deux exemplaires seulement, il reste un outil rare, dont la mise au point a duré plusieurs années. Il témoigne aussi du rôle nouveau de la famille Tu-214 : à défaut de séduire les compagnies aériennes, le biréacteur de Kazan est devenu la cellule à tout faire des avions d''État et des avions spéciaux russes.',
    E'## Genesis\nFor decades, Russian airborne electronic intelligence relied on the **Il-20**, derived from the Il-18 four-engined turboprop. To find it a successor, Moscow launched **Project 141** on the basis of the **Tu-214**, a heavier version of the **Tu-204** twinjet airliner built by the Kazan factory. The choice was no accident: with extra fuel tanks and a strengthened structure, the Tu-214 is the platform the Russian government chose for all its special mission versions. The Tu-214R has been flying since 2012.\n\n## Design\nThe airframe remains that of a 46-metre airliner: fly-by-wire controls, a supercritical wing with winglets and two 158 kN Aviadvigatel PS-90A engines. The equipment, however, is entirely military. The aircraft carries the **MRC-411** intelligence payload, which combines electronic intelligence (ELINT) sensors, a side-looking synthetic aperture radar, signals intelligence (SIGINT) and multi-spectral electro-optical sensors. It was thus meant to bring together in one aircraft what the old Il-20 did with the means of another era.\n\n## Operational career\nThe first test flights took place over the Sea of Japan, and the programme ran into problems in January 2013. The aircraft made its public debut at the **MAKS** show in August 2013, presented as able to monitor the United States under the Treaty on Open Skies; in early 2015 two aircraft were still conducting test flights with the Russian Air Force. In February 2016 a Tu-214R was deployed to the base at **Latakia**, in Syria. In July that year two flights took it along the Latvian, Estonian and Finnish borders, a few dozen kilometres from Finland. Declared combat-ready after the Syrian operation, it was reportedly used against Ukraine in 2022.\n\n## Place in history\nThe Tu-214R marks the move of Russian airborne intelligence from the turboprops of the 1960s to a modern twinjet, faster and with its sensors grouped together. With only two built, it remains a rare asset whose development took several years. It also shows the new role of the Tu-214 family: having failed to win over the airlines, the Kazan twinjet has become the all-purpose airframe for Russia''s state and special mission aircraft.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '2012-01-01',
    NULL,
    900,
    4340,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-214R'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-214R'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-214R'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-214R'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-214R'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-214R'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.14,
  wingspan          = 41.8,
  height            = 13.9,
  wing_area         = 184.2,
  empty_weight      = NULL,
  mtow              = 110750,
  service_ceiling   = 12100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel PS-90A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 158.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Tu-214** : version alourdie du Tu-204 construite à Kazan, premier vol le 21 mars 1996, base de toutes les versions spéciales\n- **Tu-214R** : renseignement électronique et radar (projet 141), charge MRC-411, deux exemplaires\n- **Tu-214ON** : observation pour le traité Ciel ouvert, caméras et radar latéral, livré en 2013 et 2014\n- **Tu-214PU / Tu-214SUS** : poste de commandement et relais de communications de la présidence russe\n- **Tu-214LMK** : laboratoire volant des radars du Tu-160M2 et du futur PAK DA, en essais depuis décembre 2018',
  variants_en       = E'- **Tu-214**: heavier Tu-204 version built in Kazan, first flight on 21 March 1996, basis for all special versions\n- **Tu-214R**: electronic and radar intelligence (Project 141), MRC-411 payload, two aircraft\n- **Tu-214ON**: Treaty on Open Skies observation aircraft with cameras and side-looking radar, delivered in 2013 and 2014\n- **Tu-214PU / Tu-214SUS**: command post and communications relay aircraft for the Russian presidency\n- **Tu-214LMK**: flying laboratory for the radars of the Tu-160M2 and the future PAK DA, testing since December 2018',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-204',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-204',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Japan Ministry of Defense / JASDF',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Tupolev Tu-214R';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tupolev Tu-214R';
