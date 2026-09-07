-- Tupolev Tu-141 Strizh (VR-2)
--
-- Photo : Tu-141 Strizh Kiyv 2019 01.jpg
--   licence CC BY-SA 4.0 — VargaA
--   https://commons.wikimedia.org/wiki/File%3ATu-141_Strizh_Kiyv_2019_01.jpg

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
    'Tu-141 Strizh',
    'Tu-141 Strizh',
    'Tupolev Tu-141 Strizh (VR-2)',
    'Tupolev Tu-141 Strizh (VR-2)',
    'Drone de 1979 réarmé par l’Ukraine quarante ans plus tard',
    'A 1979 drone rearmed by Ukraine forty years later',
    '/assets/airplanes/tu141-strizh.jpg',
    E'## Genèse\nLe **Tu-143** couvre les cent quatre-vingts premiers kilomètres devant les divisions. Il en faut un autre pour ce qui se trouve plus loin — les aérodromes de l''OTAN, les dépôts, les réserves. Le Tu-141 est ce second échelon : cinq fois plus lourd, cinq fois plus loin, et confié aux unités de reconnaissance des districts militaires occidentaux.\n\n## Conception\nQuatorze mètres, six tonnes, une aile delta et un réacteur KR-17 de deux tonnes de poussée. Comme son cadet, il est lancé d''une rampe sur camion et récupéré au parachute, mais il vole **mille kilomètres** et emporte caméras, capteurs infrarouges et matériel de renseignement électronique. Son rayon d''action en fait, dès l''origine, autre chose qu''un simple observateur.\n\n## Carrière opérationnelle\nCent cinquante-deux exemplaires produits entre 1979 et 1989 — et **tous** livrés à des unités stationnées en République socialiste soviétique d''Ukraine, dont ils sont restés après 1991. En **2022**, l''Ukraine réactive ce qui lui reste et les convertit en engins d''attaque à longue portée : plusieurs bases aériennes russes sont touchées à mille kilomètres du front.\n\n## Place dans l''histoire\nCent cinquante-deux exemplaires. Le Tu-141 est le seul appareil du catalogue à avoir changé de camp, de rôle et de siècle : conçu à Moscou pour observer l''OTAN, il frappe aujourd''hui la Russie depuis l''Ukraine, quarante-trois ans après son entrée en service.',
    E'## Genesis\nThe **Tu-143** covers the first hundred and eighty kilometres ahead of the divisions. Something else was needed for what lies further — NATO airfields, depots, reserves. The Tu-141 is that second echelon: five times heavier, five times further, and entrusted to the reconnaissance units of the western military districts.\n\n## Design\nFourteen metres, six tonnes, a delta wing and a KR-17 engine of two tonnes thrust. Like its junior it is rail-launched from a truck and recovered by parachute, but it flies **a thousand kilometres** and carries cameras, infrared sensors and electronic intelligence equipment. Its range made it, from the start, something more than an observer.\n\n## Operational career\nOne hundred and fifty-two built between 1979 and 1989 — and **all** delivered to units stationed in the Ukrainian Soviet Socialist Republic, where they remained after 1991. In **2022** Ukraine reactivated what was left and converted them into long-range strike weapons: several Russian air bases were hit a thousand kilometres behind the front.\n\n## Place in history\nOne hundred and fifty-two built. The Tu-141 is the only aircraft in this catalogue to have changed side, role and century: designed in Moscow to watch NATO, it now strikes Russia from Ukraine, forty-three years after entering service.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1974-01-01',
    '1974-12-01',
    '1979-01-01',
    1100.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.33,
  wingspan          = 3.88,
  height            = 2.44,
  wing_area         = 10.0,
  empty_weight      = 5370,
  mtow              = 6215,
  service_ceiling   = 6000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Toumanski KR-17A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 19.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1979,
  production_end    = 1989,
  units_built       = 152,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Tu-141 (VR-2 Strizh)** : version unique, reconnaissance à l''échelle de l''armée\n- *Strizh* signifie « **martinet** » en russe\n- Cinq fois plus lourd que le **Tu-143**, pour un rayon d''action cinq fois supérieur\n- Toute la production a été livrée à des unités basées en **Ukraine**\n- Réactivé et **converti en engin d''attaque** par l''Ukraine à partir de 2022',
  variants_en       = E'- **Tu-141 (VR-2 Strizh)** : the only version, army-level reconnaissance\n- *Strizh* means ''**swift**'' in Russian\n- Five times heavier than the **Tu-143**, for five times the range\n- The entire production run went to units based in **Ukraine**\n- Reactivated and **converted into a strike weapon** by Ukraine from 2022',

  -- Strate 4 : qualitatif
  nickname          = 'Strizh',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-141',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-141',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'VargaA',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Tu-141 Strizh';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tu-141 Strizh';
