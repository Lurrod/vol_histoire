-- Cessna AC-208 Combat Caravan
--
-- Photo : An AC-208 fires a Hellfire at practice target.jpg
--   licence Public domain — Sgt. Brandon Bolick
--   https://commons.wikimedia.org/wiki/File:An_AC-208_fires_a_Hellfire_at_practice_target.jpg

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
    'Cessna AC-208 Combat Caravan',
    'Cessna AC-208 Combat Caravan',
    'Cessna AC-208 Combat Caravan',
    'Cessna AC-208 Combat Caravan',
    'Un utilitaire civil à turbopropulseur armé de missiles Hellfire pour les aviations irakienne et libanaise',
    'A civil turboprop utility aircraft armed with Hellfire missiles for the Iraqi and Lebanese air forces',
    '/assets/airplanes/ac208-combat-caravan.jpg',
    E'## Genèse\nLe 20 novembre 1981, Cessna lance le projet d''un monomoteur à aile haute capable d''emporter une forte charge, imaginé par **John Berwick**, ingénieur en chef de son usine Pawnee. Le prototype du **Cessna 208 Caravan** vole le 9 décembre 1982 ; l''avion est certifié en octobre 1984 et livré à partir de 1985. FedEx en fait son appareil de fret régional, puis la version allongée **208B Grand Caravan** apparaît. Robuste, économique et capable d''opérer depuis des pistes courtes, le Caravan intéresse les armées : le département de la Défense américain le désigne **U-27A**, la force aérienne brésilienne **C-98**.\n\n## Conception\nLe Caravan est un monoplan à aile haute haubanée et train tricycle fixe, propulsé par un turbopropulseur **Pratt & Whitney Canada PT6A** de 675 ch dans sa version de base. Sa cabine non pressurisée reçoit neuf passagers, du fret ou des parachutistes, et un conteneur ventral peut s''y ajouter ; flotteurs et skis élargissent son domaine. L''**AC-208 Combat Caravan** ajoute des points d''emport sous les ailes : construit par **ATK** en version de renseignement, surveillance et reconnaissance, il est armé de missiles **AGM-114 Hellfire**. Le **MC-208 Guardian** doit réunir surveillance, appui aérien, évacuation sanitaire et frappe de précision dans une même mission, sans reconfiguration.\n\n## Carrière opérationnelle\nLa force aérienne irakienne met en œuvre des AC-208 armés de Hellfire. Le type connaît son baptême du feu en janvier 2014, lorsque l''Irak l''engage contre les insurgés de la province d''Anbar ; un appareil s''écrase en mars 2016. Entre 2009 et 2019, Northrop Grumman livre à la force aérienne libanaise deux AC-208B et un RC-208B de renseignement. D''autres AC-208 sont prévus pour des pays du Moyen-Orient et d''Afrique au titre des ventes militaires à l''étranger : le Mali, la Mauritanie, le Niger et le Burkina Faso figurent parmi les destinataires possibles. Dès les années 1980, l''US Army avait étudié une version C-16 pour le Salvador et le Nicaragua.\n\n## Place dans l''histoire\nPlus de 3 000 Caravan ont été livrés en 2022, et 123 servaient comme transports militaires en 2024. Le MC-208 Guardian a compté parmi les cinq finalistes du programme **Armed Overwatch** des forces spéciales américaines, remporté par l''**OA-1K Skyraider II**. Comme lui, l''AC-208 illustre l''emploi d''un avion utilitaire civil, bon marché et simple à entretenir, comme plate-forme de surveillance armée pour la contre-insurrection.',
    E'## Genesis\nOn 20 November 1981 Cessna launched a high-wing single-engined aircraft able to carry a large payload, conceived by **John Berwick**, chief engineer of its Pawnee plant. The prototype **Cessna 208 Caravan** flew on 9 December 1982; the aircraft was certified in October 1984 and delivered from 1985. FedEx made it its regional freighter, and the stretched **208B Grand Caravan** followed. Rugged, economical and able to use short strips, the Caravan attracted armed forces: the US Department of Defense designated it **U-27A**, the Brazilian Air Force **C-98**.\n\n## Design\nThe Caravan is a strut-braced high-wing monoplane with fixed tricycle landing gear, powered by a 675 hp **Pratt & Whitney Canada PT6A** turboprop in its basic version. Its unpressurised cabin takes nine passengers, cargo or parachutists, and an underslung cargo pod can be added; floats and skis widen its scope. The **AC-208 Combat Caravan** adds underwing hardpoints: built by **ATK** as an intelligence, surveillance and reconnaissance version, it is armed with **AGM-114 Hellfire** missiles. The **MC-208 Guardian** is meant to combine surveillance, air support, casualty evacuation and precision strike in a single mission, without reconfiguration.\n\n## Operational career\nThe Iraqi Air Force operates Hellfire-armed AC-208s. The type saw its combat debut in January 2014, when Iraq used it against insurgents in Anbar province; one aircraft crashed in March 2016. Between 2009 and 2019 Northrop Grumman delivered two AC-208Bs and one RC-208B intelligence aircraft to the Lebanese Air Force. Further AC-208s are planned for countries in the Middle East and Africa through Foreign Military Sales: Mali, Mauritania, Niger and Burkina Faso are among the possible recipients. As early as the 1980s the US Army had studied a C-16 version for El Salvador and Nicaragua.\n\n## Place in history\nMore than 3,000 Caravans had been delivered by 2022, and 123 were serving as military transports in 2024. The MC-208 Guardian was one of the five finalists of the US special forces'' **Armed Overwatch** programme, won by the **OA-1K Skyraider II**. Like that aircraft, the AC-208 shows a cheap, easily maintained civil utility type put to work as an armed surveillance platform for counter-insurgency.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1981-11-20',
    '1982-12-09',
    NULL,
    NULL,
    1980,
    (SELECT id FROM manufacturer WHERE code = 'CES'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna AC-208 Combat Caravan'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Cessna AC-208 Combat Caravan'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna AC-208 Combat Caravan'), (SELECT id FROM armement WHERE name = 'AGM-114 Hellfire'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna AC-208 Combat Caravan'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Cessna AC-208 Combat Caravan'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.46,
  wingspan          = 15.87,
  height            = 4.53,
  wing_area         = 25.96,
  empty_weight      = 2145,
  mtow              = 3629,
  service_ceiling   = 7600,
  climb_rate        = 6.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-114A (675 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **U-27A** : désignation du Cessna 208 au département de la Défense américain\n- **C-98** : désignation dans la force aérienne brésilienne\n- **AC-208 Combat Caravan** : version de surveillance armée à points d''emport sous voilure et missiles Hellfire, en service en Irak et au Liban\n- **RC-208B** : version de renseignement livrée au Liban\n- **MC-208 Guardian** : version multirôle, finaliste du programme Armed Overwatch',
  variants_en       = E'- **U-27A**: US Department of Defense designation of the Cessna 208\n- **C-98**: Brazilian Air Force designation\n- **AC-208 Combat Caravan**: armed surveillance version with underwing hardpoints and Hellfire missiles, in service in Iraq and Lebanon\n- **RC-208B**: intelligence version delivered to Lebanon\n- **MC-208 Guardian**: multi-role version, finalist of the Armed Overwatch programme',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Cessna_208_Caravan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Cessna_208_Caravan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sgt. Brandon Bolick, U.S. Army',
  image_licence     = 'Public domain'
WHERE name = 'Cessna AC-208 Combat Caravan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Cessna AC-208 Combat Caravan';
