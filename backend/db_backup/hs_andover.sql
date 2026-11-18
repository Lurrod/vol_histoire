-- Hawker Siddeley HS 780 Andover
--
-- Photo : XS646 Andover RAE Greenham Common 27-06-81 (29800438640).jpg
--   licence CC BY-SA 2.0 — Rob Hodgkins
--   https://commons.wikimedia.org/wiki/File:XS646_Andover_RAE_Greenham_Common_27-06-81_(29800438640).jpg

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
    'Hawker Siddeley Andover',
    'Hawker Siddeley Andover',
    'Hawker Siddeley HS 780 Andover',
    'Hawker Siddeley HS 780 Andover',
    'L''avion de ligne HS 748 doté d''une rampe arrière et d''un train qui s''agenouille pour charger',
    'The HS 748 airliner given a rear ramp and a kneeling undercarriage for loading',
    '/assets/airplanes/hs-andover.jpg',
    E'## Genèse\nAu début des années 1960, la Royal Air Force cherche un cargo tactique moyen. **Avro** propose une version militaire de son avion de ligne biturbopropulseur **748**, et Handley Page une variante de son Herald ; les deux sont évalués à Martlesham Heath en février 1962. La RAF choisit l''Avro, désigné 780, et commande en avril 1963 trente et un **Andover C.1**. Le nom reprend celui d''un biplan d''évacuation sanitaire de l''entre-deux-guerres, et celui de la base d''Andover, où une partie des essais a lieu. Le prototype converti, le 748MF, vole à Woodford le 21 décembre 1963.\n\n## Conception\nPour en faire un cargo, Hawker Siddeley relève fortement l''arrière du fuselage et y installe une rampe de chargement. Trouvaille principale : un **train à genouillage**, qui abaisse l''avion pour faciliter le chargement par la rampe. Les moteurs **Rolls-Royce Dart**, plus puissants, entraînent des hélices quadripales plus grandes, ce qui impose d''éloigner les moteurs du fuselage ; les saumons d''aile sont raccourcis pour garder l''envergure du 748, et le plan horizontal reçoit un dièdre qui l''écarte du souffle des hélices. L''Andover emporte 52 soldats, 40 parachutistes, 24 civières ou 6,5 tonnes de fret.\n\n## Carrière opérationnelle\nLe premier C.1 de série vole le 9 juillet 1965 et la No. 46 Squadron reçoit le sien en juin 1966 à Abingdon. L''Andover sert aussi en Extrême-Orient à Seletar, et au Moyen-Orient à Sharjah, où la No. 84 Squadron l''emploie surtout au sauvetage dans le Golfe à la place du **Blackburn Beverley**. Sept C.1 deviennent des E.3 et E.3A de calibration des aides radio, un autre un avion photographique des vols d''observation du **traité Ciel ouvert**. La Nouvelle-Zélande en achète dix en 1976 ; ils servent aux missions de l''ONU en **Somalie** et à la frontière irano-irakienne, et aux secours dans le Pacifique, malgré une autonomie trop courte.\n\n## Place dans l''histoire\nLes Andover néo-zélandais sont retirés en 1998 ; trois appareils de la RAF volent encore à Boscombe Down au-delà de 2010. Revendus surtout en Afrique, d''autres finissent dans des compagnies civiles, et l''un sert en 1996-1997 les mercenaires de la Légion blanche pendant la première guerre du Congo. Le dernier en service commercial est irrémédiablement endommagé en 2015 au Soudan du Sud. Trente-sept appareils portent le nom d''Andover, dont six CC.2 qui ne sont que des HS 748 de transport VIP.',
    E'## Genesis\nIn the early 1960s the Royal Air Force was looking for a medium tactical freighter. **Avro** offered a military version of its **748** twin-turboprop airliner, and Handley Page a variant of its Herald; both were evaluated at Martlesham Heath in February 1962. The RAF chose the Avro, designated 780, and in April 1963 ordered thirty-one **Andover C.1s**. The name revived that of an inter-war medical evacuation biplane, and that of RAF Andover, where some of the trials took place. The converted prototype, the 748MF, flew at Woodford on 21 December 1963.\n\n## Design\nTo turn it into a freighter, Hawker Siddeley sharply upswept the rear fuselage and fitted a loading ramp. The key feature was a **kneeling undercarriage**, which lowered the aircraft to make ramp loading easier. The more powerful **Rolls-Royce Dart** engines drove larger four-bladed propellers, which meant moving the engines further from the fuselage; the wingtips were shortened to keep the 748''s span, and the tailplane was given dihedral to keep it clear of the slipstream. The Andover carried 52 troops, 40 paratroops, 24 stretchers or 6.5 tonnes of freight.\n\n## Operational career\nThe first production C.1 flew on 9 July 1965 and No. 46 Squadron received its first in June 1966 at Abingdon. The Andover also served in the Far East at Seletar and in the Middle East at Sharjah, where No. 84 Squadron used it mainly for search and rescue in the Gulf in place of the **Blackburn Beverley**. Seven C.1s became E.3 and E.3A radio-aid calibration aircraft, and another a photographic aircraft for **Open Skies Treaty** observation flights. New Zealand bought ten in 1976; they served on UN missions to **Somalia** and the Iran-Iraq border and in Pacific disaster relief, despite too short a range.\n\n## Place in history\nThe New Zealand Andovers were retired in 1998; three RAF aircraft were still flying at Boscombe Down beyond 2010. Sold on mainly in Africa, others ended up with civil operators, and one served the mercenaries of the White Legion in 1996-1997 during the First Congo War. The last in commercial service was wrecked in 2015 in South Sudan. Thirty-seven aircraft bore the Andover name, including six CC.2s that were simply HS 748 VIP transports.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1962-04-01',
    '1963-12-21',
    '1966-06-01',
    515,
    2295,
    (SELECT id FROM manufacturer WHERE code = 'HS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Andover'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Andover'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Andover'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Andover'), (SELECT id FROM wars WHERE name = 'Intervention en Somalie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.77,
  wingspan          = 29.95,
  height            = 9.17,
  wing_area         = 77.24,
  empty_weight      = 13301,
  mtow              = 23133,
  service_ceiling   = 7300,
  climb_rate        = 6.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Dart RDa.12 (3 245 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 37,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Avro 748MF** : prototype converti, à fuselage arrière relevé, rampe et train à genouillage, premier vol le 21 décembre 1963\n- **Andover C.1** : version de transport de série pour la RAF, 31 exemplaires\n- **Andover C.1(PR)** : deux C.1 convertis en avions de reconnaissance photographique\n- **Andover CC.2** : six HS 748 de transport VIP, sans rampe ni train à genouillage\n- **Andover E.3 / E.3A** : sept C.1 convertis pour la calibration des aides radio et à la navigation',
  variants_en       = E'- **Avro 748MF**: converted prototype with upswept rear fuselage, ramp and kneeling gear, first flight on 21 December 1963\n- **Andover C.1**: RAF production transport, 31 built\n- **Andover C.1(PR)**: two C.1s converted for photographic reconnaissance\n- **Andover CC.2**: six HS 748 VIP transports, without ramp or kneeling gear\n- **Andover E.3 / E.3A**: seven C.1s converted for radio and navigation aid calibration',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hawker_Siddeley_Andover',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hawker_Siddeley_Andover',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Hodgkins',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Hawker Siddeley Andover';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hawker Siddeley Andover';
