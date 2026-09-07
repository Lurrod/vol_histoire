-- Westland Wyvern S.4
--
-- Photo : VR137 Westland Wyvern TF1.jpg
--   licence CC BY 2.0 — kitmasterbloke
--   https://commons.wikimedia.org/wiki/File%3AVR137_Westland_Wyvern_TF1.jpg

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
    'Westland Wyvern',
    'Westland Wyvern',
    'Westland Wyvern S.4',
    'Westland Wyvern S.4',
    'Seul avion de combat à turbopropulseur jamais engagé au feu',
    'The only turboprop combat aircraft ever committed to action',
    '/assets/airplanes/westland-wyvern.jpg',
    E'## Genèse\nEn 1944, le réacteur consomme trop pour un avion embarqué : sur un porte-avions, l''autonomie prime. Le turbopropulseur promet le meilleur des deux mondes — la puissance de la turbine, la sobriété de l''hélice. Westland conçoit le Wyvern autour de cette promesse. Il lui faudra **neuf ans** pour entrer en service, et treize pilotes y laisseront la vie.\n\n## Conception\nLe problème n''est pas la puissance mais le **temps de réponse**. Une turbine met plusieurs secondes à monter en régime, là où un moteur à pistons répond instantanément. Or l''appontage exige de corriger la puissance en permanence : le pilote commande, et l''avion obéit trois secondes plus tard, quand il est trop tard. Il faudra développer une commande de pas d''hélice couplée à la manette pour rendre l''appareil apponsable — et cela ne suffira jamais tout à fait.\n\n## Carrière opérationnelle\nSa seule guerre est **Suez**, en novembre 1956. Les Wyvern du *Eagle* et de l''*Albion* attaquent les aérodromes égyptiens et les batteries côtières à la roquette et à la bombe. Deux sont abattus par la DCA ; l''un des pilotes s''éjecte sous l''eau après un amerrissage et survit. L''appareil est retiré dix-huit mois plus tard.\n\n## Place dans l''histoire\nCent vingt-sept exemplaires pour quatre ans de service. Il reste **le seul avion de combat à turbopropulseur de l''histoire à avoir été engagé au feu** — une formule que tout le monde a essayée et que personne n''a retenue. Le réacteur avait, entre-temps, résolu son problème de consommation.',
    E'## Genesis\nIn 1944 the jet engine drank too much for a carrier aircraft: aboard ship, endurance comes first. The turboprop promised the best of both worlds — a turbine''s power with a propeller''s economy. Westland designed the Wyvern around that promise. It would take **nine years** to enter service, and thirteen pilots would die in the attempt.\n\n## Design\nThe problem is not power but **response time**. A turbine takes several seconds to spool up, where a piston engine answers instantly. Yet deck landing demands constant power correction: the pilot commands, and the aircraft obeys three seconds later, when it is too late. A propeller pitch control coupled to the throttle had to be developed to make the aircraft landable at all — and even that was never quite enough.\n\n## Operational career\nIts only war was **Suez**, in November 1956. Wyverns from *Eagle* and *Albion* attacked Egyptian airfields and coastal batteries with rockets and bombs. Two were shot down by anti-aircraft fire; one pilot ejected underwater after ditching and survived. The type was withdrawn eighteen months later.\n\n## Place in history\nOne hundred and twenty-seven built for four years of service. It remains **the only turboprop combat aircraft in history to have been committed to action** — a formula everyone tried and nobody kept. The jet engine had, in the meantime, solved its thirst.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-01-01',
    '1946-12-12',
    '1953-05-01',
    616.0,
    1450.0,
    (SELECT id FROM manufacturer WHERE code = 'WES'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Westland Wyvern'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.88,
  wingspan          = 13.42,
  height            = 4.8,
  wing_area         = 33.9,
  empty_weight      = 7080,
  mtow              = 11113,
  service_ceiling   = 8500,
  climb_rate        = 12.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Python 3',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1956,
  units_built       = 127,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Wyvern TF.1** : version initiale à moteur à pistons Rolls-Royce Eagle, 24 cylindres\n- **Wyvern TF.2** : passage au turbopropulseur, phase d''essais meurtrière\n- **Wyvern S.4** : seule version opérationnelle, engagée à Suez\n- **Hélices contrarotatives** de quatre mètres, indispensables pour absorber 4 000 ch\n- Treize pilotes tués pendant la mise au point, sur un programme de 127 appareils',
  variants_en       = E'- **Wyvern TF.1** : initial version with a 24-cylinder Rolls-Royce Eagle piston engine\n- **Wyvern TF.2** : switch to the turboprop, with a lethal testing phase\n- **Wyvern S.4** : the only operational version, committed at Suez\n- **Four-metre contra-rotating propellers**, essential to absorb 4,000 hp\n- Thirteen pilots killed during development, on a programme of 127 aircraft',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Westland_Wyvern',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Westland_Wyvern',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'kitmasterbloke',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Westland Wyvern';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Westland Wyvern';
