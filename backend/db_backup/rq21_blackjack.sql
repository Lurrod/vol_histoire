-- Boeing Insitu RQ-21A Blackjack
--
-- Photo : Marine Corps RQ-21 flies for first time in Australia (6300728).jpg
--   licence Public domain — Cpl. Harrison Rakhshani, U.S. Marine Corps
--   https://commons.wikimedia.org/wiki/File:Marine_Corps_RQ-21_flies_for_first_time_in_Australia_(6300728).jpg

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
    'Boeing Insitu RQ-21 Blackjack',
    'Boeing Insitu RQ-21 Blackjack',
    'Boeing Insitu RQ-21A Blackjack',
    'Boeing Insitu RQ-21A Blackjack',
    'Le grand frère bipoutre du ScanEagle : seize heures de veille, sans piste, pour les Marines et la Navy',
    'The ScanEagle''s twin-boom big brother: sixteen hours on watch, with no runway, for the Marines and the Navy',
    '/assets/airplanes/rq21-blackjack.jpg',
    E'## Genèse\nLe succès du **ScanEagle** a montré l''intérêt d''un drone qui se passe de piste, mais aussi ses limites : trop petit pour emporter plusieurs capteurs à la fois. L''US Navy et le Corps des Marines lancent donc un programme de petit système de drone tactique, le **STUAS**. En juin 2010, l''**Integrator** de **Boeing Insitu** l''emporte sur le **Killer Bee** de Raytheon, l''**Aerosonde** d''AAI et le **Storm** de General Dynamics et Elbit. Il vole pour la première fois le 28 juillet 2012, effectue son premier vol en mer depuis le transport de chalands de débarquement **USS Mesa Verde** le 10 février 2013, puis reçoit en septembre 2013 le nom de **RQ-21A Blackjack**.\n\n## Conception\nLe Blackjack est un monoplan bipoutre à moteur unique de 4,9 m d''envergure et 61 kg au décollage, qui reprend la catapulte et le système de récupération par crochet du ScanEagle : il se lance d''un rail et se récupère en accrochant un câble vertical, à terre comme sur un navire, le matériel se remorquant derrière un véhicule. Un système comprend cinq drones et deux stations de contrôle. Sa charge utile de 18 kg réunit caméras vidéo de jour et de nuit, marqueur infrarouge, télémètre laser, relais de communications et récepteurs AIS d''identification des navires ; sa caméra atteint le niveau 7 de l''échelle d''interprétation NIIRS à 2 400 m. Il tient l''air seize heures.\n\n## Carrière opérationnelle\nLes Marines déploient un premier système en **Afghanistan** fin avril 2014, avec des appareils de capacité initiale, sans logiciel embarqué : il rentre le 10 septembre après près de 1 000 heures de vol en 119 jours. Les forces spéciales des Marines l''engagent en Irak à l''été 2016. En juillet 2018, le Corps des Marines retire le **RQ-7 Shadow** au profit du Blackjack, qui atteint sa pleine capacité opérationnelle en 2019. Sur la base de Patuxent River, l''équipe du programme est distinguée en 2020 pour le meilleur taux de disponibilité, puis atteint en 2021 un taux de 100 %.\n\n## Place dans l''histoire\nLe Blackjack a prolongé la recette du ScanEagle vers une classe supérieure, en gardant ce qui faisait sa force : aucune piste, un lanceur et une perche. Les Marines étudient un fuselage agrandi porté à 66 kg pour 24 heures d''endurance, et de nouveaux capteurs, radar à synthèse d''ouverture ou désignateur laser. Le Canada, l''Australie, qui le construit sous le nom d''**A61 Integrator**, les Pays-Bas, la Pologne, la Belgique, le Bangladesh et Brunei l''ont adopté.',
    E'## Genesis\nThe success of the **ScanEagle** showed the value of a drone that needs no runway, but also its limits: too small to carry several sensors at once. The US Navy and the Marine Corps therefore launched a small tactical unmanned air system programme, **STUAS**. In June 2010 **Boeing Insitu**''s **Integrator** won it over Raytheon''s **Killer Bee**, AAI''s **Aerosonde** and the General Dynamics and Elbit **Storm**. It first flew on 28 July 2012, made its first flight at sea from the amphibious transport dock **USS Mesa Verde** on 10 February 2013, and in September 2013 was named **RQ-21A Blackjack**.\n\n## Design\nThe Blackjack is a twin-boom, single-engine monoplane with a 4.9 m span and a take-off weight of 61 kg, which reuses the ScanEagle''s catapult and hook recovery system: it is launched from a rail and recovered by catching a vertical wire, on land or aboard ship, the equipment being towable behind a vehicle. A system comprises five air vehicles and two control stations. Its 18 kg payload combines day and night video cameras, an infrared marker, a laser rangefinder, a communications relay and AIS ship identification receivers; its camera reaches level 7 on the NIIRS interpretability scale at 2,400 m. It stays aloft for sixteen hours.\n\n## Operational career\nThe Marines deployed a first system to **Afghanistan** in late April 2014, with early capability aircraft lacking shipboard software: it returned on 10 September after nearly 1,000 flight hours in 119 days. Marine special forces took it to Iraq in the summer of 2016. In July 2018 the Marine Corps phased out the **RQ-7 Shadow** in favour of the Blackjack, which reached full operational capability in 2019. At Patuxent River the programme team was recognised in 2020 for the highest readiness, then reached a 100% mission capable rate in 2021.\n\n## Place in history\nThe Blackjack extended the ScanEagle recipe into a larger class while keeping what made it strong: no runway, just a launcher and a pole. The Marines have studied an enlarged fuselage taking it to 66 kg for 24 hours of endurance, and new sensors such as a synthetic aperture radar or a laser designator. Canada, Australia, which builds it as the **A61 Integrator**, the Netherlands, Poland, Belgium, Bangladesh and Brunei have adopted it.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2010-06-01',
    '2012-07-28',
    '2014-04-01',
    170,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'INS'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu RQ-21 Blackjack'), (SELECT id FROM tech WHERE name = 'Lancement par catapulte et récupération par crochet')),
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu RQ-21 Blackjack'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu RQ-21 Blackjack'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Insitu RQ-21 Blackjack'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 2.5,
  wingspan          = 4.9,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 37,
  mtow              = 61,
  service_ceiling   = 5944,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 93,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Moteur à injection électronique EFI (8 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2013,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **Integrator** : nom d''origine du prototype, premier vol le 28 juillet 2012\n- **RQ-21A Block II** : version de 55 kg dotée du capteur du NightEagle, premier vol le 19 février 2013\n- **RQ-21A Blackjack** : version de série de l''US Navy et des Marines, parfois désignée **MQ-21**\n- **CU-172 Blackjack** : version des Forces armées canadiennes\n- **A61 Integrator** : version de l''armée australienne, construite en Australie avec la tourelle CM234 Spitfire',
  variants_en       = E'- **Integrator**: original name of the prototype, first flight on 28 July 2012\n- **RQ-21A Block II**: 55 kg version with the NightEagle sensor, first flight on 19 February 2013\n- **RQ-21A Blackjack**: production version for the US Navy and the Marines, sometimes designated **MQ-21**\n- **CU-172 Blackjack**: version for the Canadian Armed Forces\n- **A61 Integrator**: Australian Army version, built in Australia with the CM234 Spitfire gimbal',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_Insitu_RQ-21_Blackjack',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cpl. Harrison Rakhshani, U.S. Marine Corps',
  image_licence     = 'Public domain'
WHERE name = 'Boeing Insitu RQ-21 Blackjack';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing Insitu RQ-21 Blackjack';
