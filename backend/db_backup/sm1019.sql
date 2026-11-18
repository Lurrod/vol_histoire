-- SIAI-Marchetti SM.1019A
--
-- Photo : Siai-marchetti SM 1019 (N394RV).jpg
--   licence CC BY 2.0 — Armchair Aviator's
--   https://commons.wikimedia.org/wiki/File:Siai-marchetti_SM_1019_(N394RV).jpg

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
    'SIAI-Marchetti SM.1019',
    'SIAI-Marchetti SM.1019',
    'SIAI-Marchetti SM.1019A',
    'SIAI-Marchetti SM.1019A',
    'Un Bird Dog à turbine : l''avion de liaison à décollage court de l''armée de Terre italienne',
    'A turbine-powered Bird Dog: the Italian Army''s short take-off liaison aircraft',
    '/assets/airplanes/siai-marchetti-sm1019.jpg',
    E'## Genèse\nÀ la fin des années 1960, l''armée de Terre italienne cherche un avion de liaison à décollage court. Plutôt que de partir d''une feuille blanche, **SIAI-Marchetti** reprend la cellule du **Cessna 305A**, l''avion d''observation que l''armée américaine connaît sous le nom d''**O-1 Bird Dog**. Il lui donne un turbopropulseur et un empennage redessiné. Le prototype vole le 24 mai 1969, propulsé par une turbine **Allison 250-B15C** de 317 ch.\n\n## Conception\nLe SM.1019 garde l''architecture du Bird Dog : monoplan à aile haute contreventée, train classique fixe, pilote et observateur assis en tandem. La turbine Allison entraîne une hélice tripale **Hartzell** métallique à vitesse constante et à pas réversible. Le résultat est un avion de 690 kg à vide qui décolle en 112 m, se pose en 91,5 m grâce à l''inversion de pas, et décroche à 70 km/h volets sortis. Quatre réservoirs d''aile, soit 320 l de carburant, lui donnent plus de cinq heures d''endurance, et il monte à plus de 9 m/s jusqu''à un plafond de 7 600 m.\n\n## Carrière opérationnelle\nPour le marché de l''armée italienne, le SM.1019 est opposé à l''**Aermacchi AM.3**, conçu pour le même besoin : remplacer les Cessna L-19. Il l''emporte et décroche une commande de 80 appareils. La version de série **SM.1019A** conserve une turbine Allison 250-B15G, d''une puissance nominale de 400 ch mais limitée à 317 ch ; 81 exemplaires en sont construits. Quatre **SM.1019B**, équipés d''une Allison 250-B17B de 400 ch, suivent sous la désignation militaire SM.1019E.I. L''appareil entre en service en 1976. Seul autre client militaire, l''armée de l''air somalienne en aligne six en 1981, aujourd''hui tous retirés.\n\n## Place dans l''histoire\nAvec 86 exemplaires au total, le SM.1019 illustre une voie économique : moderniser une cellule éprouvée plutôt que d''en concevoir une nouvelle. Doter le Bird Dog d''une turbine et d''une hélice réversible suffit à en faire un appareil de liaison des années 1970, capable de se poser en moins de 100 m. Passés dans le civil, des exemplaires volent encore aux États-Unis : c''est sur un SM.1019B que l''ancien pilote de F-14 **Dale Snodgrass** se tue le 24 juillet 2021 à Lewiston, dans l''Idaho, faute d''avoir retiré le blocage des commandes.',
    E'## Genesis\nIn the late 1960s the Italian Army was looking for a short take-off liaison aircraft. Rather than start from a blank sheet, **SIAI-Marchetti** took the airframe of the **Cessna 305A**, the observation aircraft the US Army knew as the **O-1 Bird Dog**. It gave it a turboprop and a redesigned tail. The prototype flew on 24 May 1969, powered by a 317 hp **Allison 250-B15C** turbine.\n\n## Design\nThe SM.1019 keeps the Bird Dog''s layout: a strut-braced high-wing monoplane with fixed tailwheel landing gear and pilot and observer seated in tandem. The Allison turbine drives a three-blade **Hartzell** metal constant-speed propeller with reversible pitch. The result is an aircraft weighing 690 kg empty that takes off in 112 m, lands in 91.5 m thanks to reverse pitch, and stalls at 70 km/h with flaps down. Four wing tanks holding 320 l of fuel give it more than five hours'' endurance, and it climbs at more than 9 m/s to a ceiling of 7,600 m.\n\n## Operational career\nFor the Italian Army contract, the SM.1019 was pitted against the **Aermacchi AM.3**, designed for the same need: replacing the Cessna L-19. It won and secured an order for 80 aircraft. The production **SM.1019A** kept an Allison 250-B15G, rated at 400 hp but derated to 317 hp; 81 were built. Four **SM.1019B**s with a 400 hp Allison 250-B17B followed under the military designation SM.1019E.I. The aircraft entered service in 1976. The only other military customer, the Somali Air Force, had six in 1981, all since retired.\n\n## Place in history\nWith 86 built in all, the SM.1019 illustrates an economical path: updating a proven airframe instead of designing a new one. Giving the Bird Dog a turbine and a reversible propeller was enough to make it a 1970s liaison aircraft able to land in under 100 m. Examples passed into civil hands still fly in the United States: former F-14 pilot **Dale Snodgrass** was killed in an SM.1019B at Lewiston, Idaho, on 24 July 2021, after failing to remove the flight control lock.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    NULL,
    '1969-05-24',
    '1976-01-01',
    300,
    1090,
    (SELECT id FROM manufacturer WHERE code = 'SIAI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti SM.1019'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti SM.1019'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'SIAI-Marchetti SM.1019'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.52,
  wingspan          = 10.97,
  height            = 2.86,
  wing_area         = 16.16,
  empty_weight      = 690,
  mtow              = 1450,
  service_ceiling   = 7620,
  climb_rate        = 9.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison 250-B15G (317 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 86,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **SM.1019** : prototype à turbine Allison 250-B15C de 317 ch, premier vol le 24 mai 1969\n- **SM.1019A** : version de série, Allison 250-B15G limitée à 317 ch, 81 exemplaires\n- **SM.1019B (SM.1019E.I)** : turbine Allison 250-B17B de 400 ch, quatre exemplaires pour l''armée italienne',
  variants_en       = E'- **SM.1019**: prototype with a 317 hp Allison 250-B15C, first flight on 24 May 1969\n- **SM.1019A**: production version, Allison 250-B15G derated to 317 hp, 81 built\n- **SM.1019B (SM.1019E.I)**: 400 hp Allison 250-B17B, four built for the Italian Army',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/SIAI-Marchetti_SM.1019',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Armchair Aviator''s',
  image_licence     = 'CC BY 2.0'
WHERE name = 'SIAI-Marchetti SM.1019';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'SIAI-Marchetti SM.1019';
