-- Antonov An-124 Ruslan (Condor)
--
-- Photo : UR-82007 Antonov An-124-100M Ruslan (VGHS).jpg
--   licence CC BY-SA 4.0 — Md Shaifuzzaman Ayon
--   https://commons.wikimedia.org/wiki/File%3AUR-82007_Antonov_An-124-100M_Ruslan_%28VGHS%29.jpg

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
    'Antonov An-124 Ruslan',
    'Antonov An-124 Ruslan',
    'Antonov An-124 Ruslan (Condor)',
    'Antonov An-124 Ruslan (Condor)',
    'Le plus gros avion de série jamais construit',
    'The largest series-built aircraft ever made',
    '/assets/airplanes/an124-ruslan.jpg',
    E'## Genèse\nL''URSS veut déplacer ce qu''aucun avion ne peut porter : des lanceurs balistiques complets, des engins de chantier, des sections d''usine vers la Sibérie. Le bureau **Antonov**, à Kiev, reçoit en 1971 la commande d''un appareil qui dépasserait de moitié le **C-5 Galaxy** américain, alors le plus gros du monde. Il faudra onze ans pour le faire voler.\n\n## Conception\nTout est démesuré : soixante-treize mètres d''envergure, quatre réacteurs D-18T de vingt-trois tonnes de poussée chacun, **vingt-quatre roues**. La cellule emploie massivement les composites et le soudage du titane. La soute s''ouvre **aux deux extrémités** — visière de nez relevable et rampe arrière — ce qui autorise un chargement de part en part sans manœuvre. Le train avant « s''agenouille » pour poser le seuil de la soute au niveau du sol, un véhicule pouvant y entrer sans grue.\n\n## Carrière opérationnelle\nMilitaire à l''origine, il devient après 1991 l''outil du transport hors gabarit mondial : générateurs, turbines, satellites, locomotives, et les convois humanitaires de l''ONU. L''OTAN loue régulièrement des An-124 ukrainiens et russes pour ses propres déploiements — situation singulière d''une alliance dépendant, pour son transport lourd, d''appareils conçus par son adversaire historique. Plusieurs exemplaires ont été détruits ou immobilisés depuis 2022.\n\n## Place dans l''histoire\nCinquante-cinq exemplaires : c''est le plus gros avion **de série** jamais construit, record qu''il détient toujours. Son dérivé unique, l''**An-225 Mriya**, plus grand encore, a été détruit au sol à Hostomel en février 2022 dans les premiers jours de l''invasion russe. La reprise de la production de l''An-124 est évoquée depuis vingt ans sans avoir jamais eu lieu.',
    E'## Genesis\nThe USSR wanted to move what no aircraft could carry: complete ballistic launchers, construction plant, factory sections bound for Siberia. In 1971 the **Antonov** bureau in Kyiv was ordered to build an aircraft half again as large as the American **C-5 Galaxy**, then the biggest in the world. It would take eleven years to fly it.\n\n## Design\nEverything is outsized: seventy-three metres of span, four D-18T engines of twenty-three tonnes thrust each, **twenty-four wheels**. The airframe makes heavy use of composites and titanium welding. The hold opens **at both ends** — a lifting nose visor and a rear ramp — allowing straight-through loading with no manoeuvring. The nose gear kneels to bring the hold sill down to ground level, so a vehicle can drive in without a crane.\n\n## Operational career\nMilitary at the outset, after 1991 it became the world''s instrument for outsize freight: generators, turbines, satellites, locomotives, and UN humanitarian convoys. NATO regularly chartered Ukrainian and Russian An-124s for its own deployments — the singular position of an alliance depending, for its heavy lift, on aircraft designed by its historic adversary. Several aircraft have been destroyed or grounded since 2022.\n\n## Place in history\nFifty-five built: it is the largest **series-produced** aircraft ever made, a record it still holds. Its unique derivative, the **An-225 Mriya**, larger still, was destroyed on the ground at Hostomel in February 2022 in the first days of the Russian invasion. Restarting An-124 production has been discussed for twenty years without ever happening.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1971-01-01',
    '1982-12-24',
    '1987-01-01',
    865.0,
    5400.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 68.96,
  wingspan          = 73.3,
  height            = 20.78,
  wing_area         = 628.0,
  empty_weight      = 181000,
  mtow              = 405000,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4800,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Progress D-18T',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 229.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1982,
  production_end    = 2004,
  units_built       = 55,
  unit_cost_usd     = 70000000,
  unit_cost_year    = 2000,
  operators_count   = 4,
  variants          = E'- **An-124-100** : version civile certifiée, la plus répandue\n- **An-124-100M-150** : capacité portée à 150 tonnes, équipage réduit\n- **An-225 Mriya** : dérivé unique à six réacteurs, **détruit à Hostomel en février 2022**\n- Ouverture **par le nez et par la queue**, permettant le chargement de part en part\n- Le train « s''agenouille » à l''avant pour abaisser le plancher au niveau du sol',
  variants_en       = E'- **An-124-100** : certified civil version, the most widespread\n- **An-124-100M-150** : capacity raised to 150 tonnes, reduced crew\n- **An-225 Mriya** : unique six-engined derivative, **destroyed at Hostomel in February 2022**\n- Opens **at both nose and tail**, allowing straight-through loading\n- The nose gear kneels to bring the floor down to ground level',

  -- Strate 4 : qualitatif
  nickname          = 'Condor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-124',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-124',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Md Shaifuzzaman Ayon',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Antonov An-124 Ruslan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-124 Ruslan';
