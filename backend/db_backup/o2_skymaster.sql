-- Cessna O-2 Skymaster
--
-- Photo : An air-to-air left side view of an O-2A aircraft flying over the Empire Range near Howard Air Force Base, Panama DF-ST-85-09231.jpg
--   licence Public domain — Staff Sgt. David Cornwell
--   https://commons.wikimedia.org/wiki/File:An_air-to-air_left_side_view_of_an_O-2A_aircraft_flying_over_the_Empire_Range_near_Howard_Air_Force_Base,_Panama_DF-ST-85-09231.jpg

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
    'Cessna O-2 Skymaster',
    'Cessna O-2 Skymaster',
    'Cessna O-2 Skymaster',
    'Cessna O-2 Skymaster',
    'Un bimoteur civil à hélices en tandem devenu l''œil des chasseurs-bombardiers au Vietnam',
    'A push-pull civil twin turned into the eye of the fighter-bombers over Vietnam',
    '/assets/airplanes/o2-skymaster.jpg',
    E'## Genèse\nEn 1966, l''**US Air Force** doit épauler le **Cessna O-1 Bird Dog** dans le contrôle aérien avancé au Vietnam. Plutôt que de lancer un avion nouveau, elle commande à Cessna une version militaire du **Model 337 Super Skymaster**, un bimoteur civil bon marché déjà en production. Le premier O-2 vole en janvier 1967, la fabrication démarre aussitôt et les livraisons commencent dès mars. L''Army en reçoit aussi la même année, prélevés sur les stocks de l''Air Force.\n\n## Conception\nLe Skymaster a une formule rare : un moteur à l''avant qui tire, un second à l''arrière du fuselage qui pousse, et une queue bipoutre. La poussée reste dans l''axe, ce qui simplifie le pilotage par rapport à un bimoteur classique, et l''aile haute dégage la vue vers le bas et l''arrière. La version militaire remplace les six sièges par un pilote et un observateur, perce des hublots dans les portes, remplit les réservoirs d''aile de mousse ignifuge, adopte radios et antennes militaires et voit sa masse maximale passer de 1 996 à 2 449 kg. Ses performances en croisière en pâtissent, mais restent suffisantes pour voler bas. Quatre points d''emport reçoivent roquettes, nacelles de minigun ou fusées éclairantes.\n\n## Carrière opérationnelle\nAu **Vietnam**, l''O-2A succède progressivement à l''O-1 dans le contrôle aérien avancé, notamment au 20th Tactical Air Support Squadron. L''**O-2B**, désarmé, emporte haut-parleurs et distributeur de tracts pour la guerre psychologique. Même après l''arrivée de l''**OV-10 Bronco**, il garde les missions de nuit : le poste du Bronco, trop éclairé, gêne l''observation nocturne. La guerre coûte 178 O-2 à l''US Air Force, et 35 sont cédés à l''aviation sud-vietnamienne. Au **Salvador**, à partir de 1981, une vingtaine d''O-2 surveillent les colonnes du FMLN et dirigent les frappes, contribuant à faire renoncer la guérilla aux grandes opérations ; ses missiles SA-7 en abattent deux en 1990.\n\n## Place dans l''histoire\nProduit à 532 exemplaires jusqu''en juin 1970, l''O-2 sert l''US Air Force et la Garde nationale jusqu''à la fin des années 1980 ; les deux derniers de l''Army, employés aux essais de Yuma, partent au musée en octobre 2010. Vingt anciens appareils du Vietnam deviennent à partir de 1976 les avions de coordination de CAL FIRE, la lutte contre les incendies de Californie, pendant plus de vingt ans. Avion d''affaires presque inchangé, il est le maillon intermédiaire du contrôle aérien avancé américain, entre le Bird Dog et le Bronco.',
    E'## Genesis\nIn 1966 the **US Air Force** needed to back up the **Cessna O-1 Bird Dog** in forward air control over Vietnam. Rather than launch a new aircraft, it asked Cessna for a military version of the **Model 337 Super Skymaster**, a cheap civil twin already in production. The first O-2 flew in January 1967, production started at once and deliveries began in March. The Army also received some that year, drawn from Air Force stocks.\n\n## Design\nThe Skymaster has an unusual layout: one engine in the nose pulling, a second at the rear of the fuselage pushing, and twin tail booms. Thrust stays on the centreline, which makes it simpler to fly than a conventional twin, and the high wing leaves a clear view below and behind. The military version replaced the six seats with a pilot and an observer, added view panels in the doors, filled the wing tanks with fire-retardant foam, took military radios and antennas and saw its maximum weight rise from 1,996 to 2,449 kg. Cruise performance suffered, but remained adequate for low flying. Four hardpoints carried rockets, minigun pods or flares.\n\n## Operational career\nOver **Vietnam** the O-2A progressively took over forward air control from the O-1, notably with the 20th Tactical Air Support Squadron. The unarmed **O-2B** carried loudspeakers and a leaflet dispenser for psychological warfare. Even after the **OV-10 Bronco** arrived it kept the night missions, as the Bronco''s brightly lit cockpit hampered night observation. The war cost the US Air Force 178 O-2s, and 35 were handed to the South Vietnamese air force. In **El Salvador**, from 1981, some twenty O-2s tracked FMLN columns and directed air strikes, helping to force the guerrillas to give up large-scale operations; their SA-7 missiles shot down two in 1990.\n\n## Place in history\nBuilt to 532 examples until June 1970, the O-2 served the US Air Force and Air National Guard until the late 1980s; the Army''s last two, used for trials at Yuma, went to a museum in October 2010. From 1976 twenty former Vietnam aircraft became the air attack platforms of CAL FIRE, California''s firefighting service, for more than twenty years. An almost unchanged business aircraft, it is the middle link of American forward air control, between the Bird Dog and the Bronco.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1966-01-01',
    '1967-01-01',
    '1967-03-01',
    320,
    1710,
    (SELECT id FROM manufacturer WHERE code = 'CES'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna O-2 Skymaster'), (SELECT id FROM armement WHERE name = 'M134 Minigun'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna O-2 Skymaster'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Cessna O-2 Skymaster'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna O-2 Skymaster'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Cessna O-2 Skymaster'), (SELECT id FROM wars WHERE name = 'Guerre civile salvadorienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.07,
  wingspan          = 11.58,
  height            = 2.84,
  wing_area         = 18.81,
  empty_weight      = 1292,
  mtow              = 2449,
  service_ceiling   = 6000,
  climb_rate        = 6.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Continental IO-360C/D (210 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1970,
  units_built       = 532,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 16,
  variants          = E'- **Model 337 Super Skymaster** : bimoteur civil à six places dont l''O-2 est la version militaire\n- **O-2A** : version de contrôle aérien avancé à points d''emport sous voilure, 513 livrés\n- **O-2B** : version de guerre psychologique désarmée, à haut-parleurs et distributeur de tracts, 31 Model 337 civils convertis\n- **O2-337 Sentry** : appareils de la marine royale thaïlandaise, 11 exemplaires',
  variants_en       = E'- **Model 337 Super Skymaster**: six-seat civil twin of which the O-2 is the military version\n- **O-2A**: forward air control version with underwing hardpoints, 513 delivered\n- **O-2B**: unarmed psychological warfare version with loudspeakers and leaflet dispenser, 31 civil Model 337s converted\n- **O2-337 Sentry**: Royal Thai Navy aircraft, 11 in service',

  -- Strate 4 : qualitatif
  nickname          = 'Oscar Deuce',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Cessna_O-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Cessna_O-2_Skymaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. David Cornwell, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Cessna O-2 Skymaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Cessna O-2 Skymaster';
