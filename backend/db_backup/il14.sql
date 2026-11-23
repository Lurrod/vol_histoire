-- Iliouchine Il-14 (Crate)
--
-- Photo : Ilyushin Il-14 (43105754104).jpg
--   licence CC BY 2.0 — Clemens Vasters
--   https://commons.wikimedia.org/wiki/File:Ilyushin_Il-14_(43105754104).jpg

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
    'Iliouchine Il-14',
    'Ilyushin Il-14',
    'Iliouchine Il-14 (Crate)',
    'Ilyushin Il-14 (Crate)',
    'Le bimoteur à tout faire du bloc soviétique, conçu pour succéder au DC-3 et au Li-2',
    'The Soviet bloc''s do-everything twin, designed to succeed the DC-3 and the Li-2',
    '/assets/airplanes/il14.jpg',
    E'## Genèse\nAu sortir de la guerre, l''URSS veut remplacer le **Douglas DC-3** et sa version soviétique, le **Lisounov Li-2**. Un premier candidat, l''**Il-12**, déçoit : il se comporte mal en cas de panne moteur et, prévu pour 32 passagers, n''en emporte que 18 en service, ce qui le rend peu rentable. Iliouchine en tire l''Il-14, destiné dès l''origine aux usages civils comme militaires. Le nouvel appareil vole le 1er octobre 1950 et entre en service en 1954.\n\n## Conception\nPar rapport à l''Il-12, l''Il-14 reçoit une aile nouvelle et une dérive élargie, qui améliorent nettement le vol sur un seul moteur. Deux moteurs en étoile **Shvetsov ASh-82T** de 1 900 ch entraînent des hélices quadripales. Robuste et fiable, il s''accommode des terrains médiocres des régions rurales. La famille se décline en une vingtaine de versions : Il-14P de ligne, Il-14M allongé, Il-14T de transport militaire, Il-14TD pour les parachutistes, remorqueur de planeurs, appareils de photographie aérienne, de reconnaissance des glaces, d''étalonnage des aides radio, et même un avion de guerre électronique que l''OTAN baptise Crate-C.\n\n## Carrière opérationnelle\nL''armée de l''air et l''aviation navale soviétiques l''utilisent à partir de 1954 ; 235 exemplaires y sont encore en service en 1979. Une trentaine de forces aériennes l''adoptent, de la RDA à Cuba et de l''Inde au Vietnam. L''Égypte en reçoit 70, dont plusieurs sont détruits lors des combats contre **Israël** ; le Vietnam en aligne 45, la Chine plus de 50. En 1956, **Nikita Khrouchtchev** offre un Il-14P au maréchal **Tito**. Les derniers exemplaires militaires quittent le service en Syrie et au Vietnam en 1998.\n\n## Place dans l''histoire\nConstruit à 1 348 exemplaires, dont 80 sous licence en RDA par VEB Flugzeugwerke Dresden et 203 en Tchécoslovaquie par Avia, l''Il-14 a tenu dans le monde soviétique la place du DC-3 qu''il devait remplacer : celle du bimoteur à tout faire, des lignes d''Aeroflot aux bases de l''Arctique. Il cède ensuite la place à l''An-24 et au Yak-40. Au milieu des années 2010, trois exemplaires restaurés par des passionnés volent encore en Russie.',
    E'## Genesis\nAfter the war the Soviet Union wanted to replace the **Douglas DC-3** and its Soviet-built version, the **Lisunov Li-2**. A first candidate, the **Il-12**, disappointed: it behaved poorly after an engine failure and, though meant to carry 32 passengers, carried only 18 in service, which made it uneconomical. Ilyushin developed it into the Il-14, intended from the start for both civil and military use. The new aircraft flew on 1 October 1950 and entered service in 1954.\n\n## Design\nCompared with the Il-12, the Il-14 had a new wing and a broader fin, which greatly improved single-engine handling. Two **Shvetsov ASh-82T** radial engines of 1,900 hp drove four-bladed propellers. Rugged and reliable, it coped well with the poor airfields of rural areas. The family ran to some twenty versions: the Il-14P airliner, the stretched Il-14M, the Il-14T military transport, the Il-14TD for paratroops, a glider tug, aerial photography, ice reconnaissance and radio-aid calibration aircraft, and even an electronic warfare version that NATO called Crate-C.\n\n## Operational career\nThe Soviet Air Force and Soviet Naval Aviation flew it from 1954; 235 were still in service in 1979. Some thirty air forces adopted it, from East Germany to Cuba and from India to Vietnam. Egypt received 70, several of which were destroyed in fighting with **Israel**; Vietnam fielded 45 and China more than 50. In 1956 **Nikita Khrushchev** presented an Il-14P to Marshal **Tito**. The last military examples left service in Syria and Vietnam in 1998.\n\n## Place in history\nBuilt in 1,348 examples, including 80 under licence in East Germany by VEB Flugzeugwerke Dresden and 203 in Czechoslovakia by Avia, the Il-14 filled in the Soviet world the role of the DC-3 it was meant to replace: the do-everything twin, from Aeroflot routes to Arctic bases. It was in turn succeeded by the An-24 and the Yak-40. In the mid-2010s, three examples restored by enthusiasts were still flying in Russia.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1950-10-01',
    '1954-01-01',
    417,
    1305,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-14'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-14'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-14'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-14'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.3,
  wingspan          = 31.7,
  height            = 7.9,
  wing_area         = 99.7,
  empty_weight      = 12600,
  mtow              = 18000,
  service_ceiling   = 7400,
  climb_rate        = 5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Shvetsov ASh-82T (1 900 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1960,
  units_built       = 1348,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 30,
  variants          = E'- **Il-14P** : version de ligne de 18 à 32 places\n- **Il-14M** : fuselage allongé, jusqu''à 36 places, base de la plupart des versions ultérieures\n- **Il-14T / Il-14TD** : transport militaire et version d''assaut pour parachutistes\n- **Crate-C** : version de guerre électronique, selon la désignation de l''OTAN\n- **Avia 14 et VEB 14P** : versions construites sous licence en Tchécoslovaquie et en RDA, dont l''Avia 14 Super pressurisé',
  variants_en       = E'- **Il-14P**: airliner version with 18 to 32 seats\n- **Il-14M**: stretched fuselage, up to 36 seats, basis for most later versions\n- **Il-14T / Il-14TD**: military transport and paratroop assault version\n- **Crate-C**: electronic warfare version, by its NATO designation\n- **Avia 14 and VEB 14P**: licence-built versions from Czechoslovakia and East Germany, including the pressurised Avia 14 Super',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-14',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-14',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Iliouchine Il-14';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-14';
