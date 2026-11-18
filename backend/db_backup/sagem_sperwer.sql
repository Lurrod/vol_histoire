-- Sagem Sperwer (SDTI)
--
-- Photo : BRIGADEX 2014 Eurocorps Quartier Aubert de Vincelles Strasbourg 15 avril 2014-05.jpg
--   licence CC BY-SA 3.0 — Photo Claude TRUONG-NGOC
--   https://commons.wikimedia.org/wiki/File:BRIGADEX_2014_Eurocorps_Quartier_Aubert_de_Vincelles_Strasbourg_15_avril_2014-05.jpg

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
    'Sagem Sperwer',
    'Sagem Sperwer',
    'Sagem Sperwer (SDTI)',
    'Sagem Sperwer (SDTI)',
    'Drone tactique français à aile delta, engagé en Afghanistan par le Canada puis par la France',
    'French delta-winged tactical drone, flown in Afghanistan by Canada and then France',
    '/assets/airplanes/sagem-sperwer.jpg',
    E'## Genèse\nLe Sperwer est conçu et fabriqué par la société française **Sagem**, devenue Sagem Défense Sécurité en 2005 puis Safran Electronics & Defense en 2016, pour succéder à son drone **Crécerelle**, employé pendant les conflits de l''ex-Yougoslavie. Son développement commence au milieu des années 1990. Son nom est néerlandais : *sperwer* désigne l''épervier, en hommage à la vue perçante du rapace, car l''armée des Pays-Bas a été la première à le mettre en service.\n\n## Conception\nC''est un drone tactique à aile delta, propulsé par un moteur bicylindre à deux temps qui entraîne une hélice quadripale. Il décolle d''une catapulte pneumatique et se pose sous parachute, des coussins gonflables placés sous les ailes amortissant le contact avec le sol. Sa charge utile est un ensemble de caméras gyrostabilisées, dans le visible et l''infrarouge, qui suit et désigne des objectifs au profit des troupes au sol et règle les tirs d''artillerie. Piloté à distance, il croise à plus de 4 800 m pendant cinq heures et renvoie en temps réel les images d''objectifs situés jusqu''à 150 km de sa station sol, où un opérateur les analyse.\n\n## Carrière opérationnelle\nLe Sperwer est adopté par les Pays-Bas, la France, la Suède sous le nom d''**Ugglan**, la Grèce, le Danemark, la garde nationale aérienne américaine et le Canada sous la désignation **CU-161**. Les Forces canadiennes l''engagent en **Afghanistan** de 2003 jusqu''à sa dernière mission, le 18 avril 2009, avant de le remplacer par l''**IAI Heron**. Le Danemark, confronté à une série de problèmes, annule son programme et revend ses appareils au Canada. En France, le **61e régiment d''artillerie** le met en œuvre sous le nom de SDTI, système de drone tactique intérimaire, à partir de 2005 ; sept à huit appareils sont déployés en Afghanistan de novembre 2008 à juin 2012, et douze y sont perdus, le plus souvent par perte de contrôle.\n\n## Place dans l''histoire\nEnviron 130 Sperwer sont sortis de l''usine de Montluçon. Les Pays-Bas le retirent du front dès 2009 au profit de drones israéliens loués ; la France, qui l''a déployé au Kosovo puis en Afghanistan et l''a modernisé en Mk II, suspend sa flotte en juillet 2020, un arrêt de fait définitif, et lui donne pour successeur le **Safran Patroller**. Six exemplaires canadiens et deux néerlandais sont aujourd''hui conservés dans des musées.',
    E'## Genesis\nThe Sperwer was designed and built by the French company **Sagem**, which became Sagem Défense Sécurité in 2005 and Safran Electronics & Defense in 2016, to succeed its **Crécerelle** drone, used during the conflicts in the former Yugoslavia. Development began in the mid-1990s. Its name is Dutch: *sperwer* means sparrowhawk, a nod to the bird of prey''s keen sight, because the Netherlands army was the first to put it into service.\n\n## Design\nIt is a delta-winged tactical drone powered by a two-stroke twin-cylinder engine driving a four-bladed propeller. It is launched by a pneumatic catapult and lands under a parachute, with airbags under the wings cushioning the touchdown. Its payload is a set of gyro-stabilised cameras, working in the visible and infrared, that track and designate targets for ground troops and adjust artillery fire. Remotely piloted, it cruises above 4,800 m for five hours and sends back real-time images of targets up to 150 km from its ground station, where an operator analyses them.\n\n## Operational career\nThe Sperwer was adopted by the Netherlands, France, Sweden as the **Ugglan**, Greece, Denmark, the US Air National Guard and Canada as the **CU-161**. The Canadian Armed Forces flew it in **Afghanistan** from 2003 until its last mission on 18 April 2009, when the **IAI Heron** replaced it. Denmark, beset by a series of problems, cancelled its programme and sold its aircraft to Canada. In France the **61st Artillery Regiment** operated it from 2005 as the SDTI, the interim tactical drone system; seven or eight were deployed to Afghanistan from November 2008 to June 2012, and twelve were lost there, mostly through loss of control.\n\n## Place in history\nAbout 130 Sperwers left the Montluçon factory. The Netherlands withdrew it from front-line use in 2009 in favour of drones rented from Israel; France, which deployed it to Kosovo and then Afghanistan and upgraded it to Mk II standard, suspended its fleet in July 2020, in effect a final retirement, and gave it the **Safran Patroller** as its successor. Six Canadian and two Dutch examples are now preserved in museums.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SAF'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Sagem Sperwer'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Sagem Sperwer'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Sagem Sperwer'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Sagem Sperwer'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 4877,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Moteur bicylindre deux temps',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 130,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **Sperwer** : version initiale, mise en service d''abord par l''armée néerlandaise\n- **SDTI** : système de drone tactique intérimaire de l''armée de Terre française, en service de 2005 à 2020\n- **CU-161** : désignation canadienne, engagée en Afghanistan de 2003 à 2009\n- **UAV01 Ugglan** : désignation suédoise (« la chouette »)\n- **Sperwer Mk II** : version modernisée commandée par la France en juin 2012',
  variants_en       = E'- **Sperwer**: initial version, first put into service by the Netherlands army\n- **SDTI**: French Army interim tactical drone system, in service from 2005 to 2020\n- **CU-161**: Canadian designation, flown in Afghanistan from 2003 to 2009\n- **UAV01 Ugglan**: Swedish designation (''the owl'')\n- **Sperwer Mk II**: upgraded version ordered by France in June 2012',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Sagem_Sperwer',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/SAGEM_Sperwer',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Claude Truong-Ngoc',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Sagem Sperwer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Sagem Sperwer';
