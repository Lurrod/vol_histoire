-- Cessna L-19 / O-1 Bird Dog
--
-- Photo : Cessna O-1E Bird Dog in flight over Vietnam, in 1967 (6344058).jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Cessna_O-1E_Bird_Dog_in_flight_over_Vietnam,_in_1967_(6344058).jpg

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
    'Cessna O-1 Bird Dog',
    'Cessna O-1 Bird Dog',
    'Cessna L-19 / O-1 Bird Dog',
    'Cessna L-19 / O-1 Bird Dog',
    'Le premier avion tout métal de l''US Army, chien d''arrêt de l''artillerie de la Corée au Vietnam',
    'The US Army''s first all-metal aircraft, pointing artillery and fighters at the enemy from Korea to Vietnam',
    '/assets/airplanes/o1-bird-dog.jpg',
    E'## Genèse\nAu sortir de la Seconde Guerre mondiale, l''**US Army** cherche un avion capable de survoler les positions ennemies pour régler les tirs d''artillerie et d''assurer la liaison, de préférence tout en métal : les Piper et Stinson entoilés de la guerre s''usaient trop vite. Cessna propose son **Model 305A**, dérivé du Cessna 170, et l''emporte en avril 1950 face à Piper, Taylorcraft et Temco. Le prototype a volé le 14 décembre 1949 ; un premier contrat porte sur 418 appareils baptisés **L-19A Bird Dog**. C''est le premier avion entièrement métallique commandé par l''Army depuis la séparation de l''aviation en 1947.\n\n## Conception\nLe L-19 est un monomoteur à aile haute haubanée et train classique, mais il ne garde du Cessna 170 que la formule : deux places en tandem, des vitres latérales inclinées pour observer le sol, un fuselage arrière redessiné qui ouvre la vue vers l''arrière et des panneaux transparents dans l''aile au-dessus du poste. Le **Continental O-470** de 213 ch lui fait franchir 15 m de hauteur après 170 m de course. Son nom, choisi par concours parmi les employés de Cessna, résume le métier : trouver l''ennemi et tourner au-dessus de lui jusqu''à ce que l''artillerie ou l''aviation le frappe, comme un chien d''arrêt.\n\n## Carrière opérationnelle\nLivré à partir de décembre 1950, le Bird Dog fait sa première guerre en **Corée**, où les Marines l''engagent aussi sous le nom d''OE-1. Rebaptisé **O-1** en 1962, il part au **Vietnam** avec l''Army, les Marines et l''aviation sud-vietnamienne, puis l''US Air Force en fait un avion de contrôle aérien avancé : il marque les cibles à la roquette fumigène pour les chasseurs-bombardiers et soutient le sauvetage des équipages abattus. Les « Ravens » le pilotent en secret au Laos et au Cambodge. La guerre en coûte 469 ; le capitaine **Hilliard Wilbanks** reçoit la Medal of Honor à titre posthume pour avoir défendu des Rangers sud-vietnamiens au fusil, depuis sa fenêtre. Le 29 avril 1975, le major **Bung-Ly** pose sur le porte-avions **Midway** un O-1 chargé de sa femme et de leurs cinq enfants.\n\n## Place dans l''histoire\nCessna en produit 3 431 entre 1950 et 1959, Fuji 60 autres sous licence, et plus de vingt-cinq pays l''ont utilisé. L''US Air Force le remplace par le **Cessna O-2 Skymaster** puis l''**OV-10 Bronco**, plus rapides et bimoteurs, mais l''Army le garde jusqu''au bout de la guerre pour son silence, sa lenteur, sa maniabilité et sa visibilité, et ne le retire qu''en 1974. Il incarne l''observateur aérien de l''après-guerre : un avion léger presque civil, sans blindage, dont l''arme principale était la radio.',
    E'## Genesis\nAfter the Second World War the **US Army** wanted an aircraft that could fly over enemy positions to adjust artillery fire and carry out liaison, preferably all-metal: the fabric-covered Piper and Stinson types of the war wore out too quickly. Cessna offered its **Model 305A**, derived from the Cessna 170, and won the April 1950 competition against Piper, Taylorcraft and Temco. The prototype had flown on 14 December 1949; a first contract covered 418 aircraft named **L-19A Bird Dog**. It was the first all-metal aircraft ordered by the Army since the air arm became independent in 1947.\n\n## Design\nThe L-19 is a strut-braced high-wing single with a tailwheel, but it keeps only the layout of the Cessna 170: two seats in tandem, angled side windows for watching the ground, a reshaped rear fuselage giving a view straight aft and transparent panels in the wing above the cockpit. A wider door allowed a stretcher to be loaded. The 213 hp **Continental O-470** cleared a 15 m obstacle after a 170 m run. Its name, picked in a contest among Cessna employees, sums up the job: find the enemy and circle overhead until artillery or aircraft strike it, like a gun dog.\n\n## Operational career\nDelivered from December 1950, the Bird Dog fought its first war in **Korea**, where the Marines also flew it as the OE-1. Redesignated **O-1** in 1962, it went to **Vietnam** with the Army, the Marines and the South Vietnamese air force, then the US Air Force made it a forward air control aircraft: it marked targets with smoke rockets for fighter-bombers and supported the rescue of downed crews. The ''Ravens'' flew it covertly over Laos and Cambodia. The war cost 469 of them; Captain **Hilliard Wilbanks** received a posthumous Medal of Honor for defending South Vietnamese Rangers with a rifle fired from his window. On 29 April 1975 Major **Bung-Ly** landed an O-1 carrying his wife and their five children on the carrier **Midway**.\n\n## Place in history\nCessna built 3,431 between 1950 and 1959, Fuji another 60 under licence, and more than twenty-five countries flew it. The US Air Force replaced it with the **Cessna O-2 Skymaster** and then the **OV-10 Bronco**, faster twin-engined types, but the Army kept it to the end of the war for its quietness, low speed, agility and visibility, retiring it only in 1974. It embodies the post-war air observer: a light, almost civilian aircraft, unarmoured, whose main weapon was its radio.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1949-12-14',
    '1950-12-01',
    185,
    850,
    (SELECT id FROM manufacturer WHERE code = 'CES'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna O-1 Bird Dog'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Cessna O-1 Bird Dog'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Cessna O-1 Bird Dog'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Cessna O-1 Bird Dog'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.87,
  wingspan          = 10.97,
  height            = 2.24,
  wing_area         = 16.2,
  empty_weight      = 732,
  mtow              = 1102,
  service_ceiling   = 5600,
  climb_rate        = 5.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Continental O-470-11 (213 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1959,
  units_built       = 3431,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 26,
  variants          = E'- **L-19A / O-1A** : version de série initiale pour l''US Army, 2 486 exemplaires\n- **TL-19D / TO-1D** : biplace d''entraînement au vol aux instruments à double commande, 310 exemplaires\n- **L-19E / O-1E** : cellule renforcée et masse au décollage accrue, 469 exemplaires\n- **OE-1 / OE-2** : versions des Marines, l''OE-2 recevant l''aile du Cessna 180 et un moteur de 260 ch\n- **O-1D, O-1F, O-1G** : conversions de l''US Air Force pour le contrôle aérien avancé',
  variants_en       = E'- **L-19A / O-1A**: initial production version for the US Army, 2,486 built\n- **TL-19D / TO-1D**: dual-control instrument trainer, 310 built\n- **L-19E / O-1E**: strengthened airframe and higher take-off weight, 469 built\n- **OE-1 / OE-2**: Marine Corps versions, the OE-2 with the Cessna 180 wing and a 260 hp engine\n- **O-1D, O-1F, O-1G**: US Air Force conversions for forward air control',

  -- Strate 4 : qualitatif
  nickname          = 'Bird Dog',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Cessna_L-19',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Cessna_O-1_Bird_Dog',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Cessna O-1 Bird Dog';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Cessna O-1 Bird Dog';
