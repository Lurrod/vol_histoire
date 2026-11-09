-- de Havilland Canada DHC-2 Beaver
--
-- Photo : DHC 2 Beaver at Abingdon - Flickr - Dave S..jpg
--   licence CC BY 4.0 — Dave_S.
--   https://commons.wikimedia.org/wiki/File:DHC_2_Beaver_at_Abingdon_-_Flickr_-_Dave_S..jpg

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
    'DHC-2 Beaver',
    'DHC-2 Beaver',
    'de Havilland Canada DHC-2 Beaver',
    'de Havilland Canada DHC-2 Beaver',
    'L’avion de brousse canadien que l’US Army a acheté à près d’un millier d’exemplaires',
    'The Canadian bush plane the US Army bought in nearly a thousand examples',
    '/assets/airplanes/dhc2-beaver.jpg',
    E'## Genèse\nAu lendemain de la guerre, **de Havilland Canada** interroge les pilotes de brousse canadiens sur l''avion dont ils ont besoin : un appareil robuste, capable d''emporter une vraie charge sur roues, skis ou flotteurs, et de décoller court depuis un lac ou une clairière. Le travail commence le 17 septembre 1946 ; le prototype, piloté par l''ancien as **Russell Bannock**, vole le 16 août 1947. Le premier exemplaire de série est livré en avril 1948 à un client civil, le ministère des Terres et Forêts de l''Ontario.\n\n## Conception\nAile haute, volets généreux, structure entièrement métallique, moteur en étoile **Pratt & Whitney R-985 Wasp Junior** de 450 ch : le Beaver emporte six passagers ou près d''une tonne de charge utile et se contente de terrains très courts. Il passe des roues aux flotteurs ou aux skis selon la saison, et supporte les atterrissages sur les surfaces les plus sommaires. Rien de sophistiqué, tout est pensé pour être réparé loin de tout atelier.\n\n## Carrière opérationnelle\nL''**US Army** est le client décisif : elle commande 970 exemplaires sous la désignation L-20, devenue U-6A en 1962, soit plus de la moitié de la production. Le Beaver sert d''avion de liaison, d''évacuation sanitaire et d''observation en **Corée**, puis au **Vietnam**, où il relie des postes que seuls les hélicoptères peuvent atteindre autrement. L''Army Air Corps britannique et de nombreuses autres armées l''adoptent ; au total, 1 657 exemplaires sont construits de 1947 à 1967.\n\n## Place dans l''histoire\nEn 1987, le Beaver est désigné comme l''une des dix plus grandes réalisations du génie canadien du XXe siècle. Il fonde la réputation de de Havilland Canada pour les avions à décollage court, qui conduit à l''Otter, au **DHC-4 Caribou** et au **DHC-5 Buffalo**. Près de quatre-vingts ans après son premier vol, des centaines d''exemplaires volent encore, surtout dans l''aviation civile de brousse.',
    E'## Genesis\nIn the aftermath of the war, **de Havilland Canada** asked Canadian bush pilots what aircraft they needed: a rugged machine able to carry a real load on wheels, skis or floats, and to take off short from a lake or a clearing. Work began on 17 September 1946; the prototype, flown by former ace **Russell Bannock**, flew on 16 August 1947. The first production aircraft was delivered in April 1948 to a civil customer, the Ontario Department of Lands and Forests.\n\n## Design\nHigh wing, generous flaps, all-metal structure and a 450 hp **Pratt & Whitney R-985 Wasp Junior** radial engine: the Beaver carries six passengers or nearly a tonne of payload and makes do with very short strips. It switches from wheels to floats or skis with the seasons and tolerates landings on the roughest surfaces. Nothing is sophisticated; everything is designed to be repaired far from any workshop.\n\n## Operational career\nThe **US Army** was the decisive customer, ordering 970 aircraft as the L-20, redesignated U-6A in 1962 — more than half of all production. The Beaver served for liaison, medical evacuation and observation in **Korea**, then in **Vietnam**, linking outposts that otherwise only helicopters could reach. The British Army Air Corps and many other armed forces adopted it; in all, 1,657 were built between 1947 and 1967.\n\n## Place in history\nIn 1987 the Beaver was named one of the ten greatest Canadian engineering achievements of the twentieth century. It founded de Havilland Canada''s reputation for short take-off aircraft, leading to the Otter, the **DHC-4 Caribou** and the **DHC-5 Buffalo**. Nearly eighty years after its first flight, hundreds still fly, mostly in civil bush aviation.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1946-09-17',
    '1947-08-16',
    '1948-04-01',
    254.0,
    732.0,
    (SELECT id FROM manufacturer WHERE code = 'DHC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.22,
  wingspan          = 14.63,
  height            = 2.74,
  wing_area         = 23.2,
  empty_weight      = 1361,
  mtow              = 2313,
  service_ceiling   = 5486,
  climb_rate        = 5.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-985 Wasp Junior',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1967,
  units_built       = 1657,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **DHC-2 Mk I** : version d''origine à moteur en étoile Wasp Junior de 450 ch\n- **L-20A / U-6A** : version de l''US Army, 970 exemplaires\n- **Beaver AL.1** : version de l''Army Air Corps britannique\n- **DHC-2 Mk III Turbo-Beaver** : turbopropulseur Pratt & Whitney Canada PT6A de 680 ch\n- Ouvre la lignée STOL de de Havilland Canada : Otter, **DHC-4 Caribou**, **DHC-5 Buffalo**',
  variants_en       = E'- **DHC-2 Mk I** : original version with the 450 hp Wasp Junior radial\n- **L-20A / U-6A** : US Army version, 970 built\n- **Beaver AL.1** : British Army Air Corps version\n- **DHC-2 Mk III Turbo-Beaver** : 680 shp Pratt & Whitney Canada PT6A turboprop\n- Opens de Havilland Canada''s STOL line: Otter, **DHC-4 Caribou**, **DHC-5 Buffalo**',

  -- Strate 4 : qualitatif
  nickname          = 'Beaver',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Canada_DHC-2_Beaver',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Canada_DHC-2_Beaver',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dave_S.',
  image_licence     = 'CC BY 4.0'
WHERE name = 'DHC-2 Beaver';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DHC-2 Beaver';
