-- Antonov An-12 (Cub)
--
-- Photo : Antonov An-12BK ‘RF-93950 - 14 red’ (37139713072).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3AAntonov_An-12BK_%E2%80%98RF-93950_-_14_red%E2%80%99_%2837139713072%29.jpg

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
    'Antonov An-12',
    'Antonov An-12',
    'Antonov An-12 (Cub)',
    'Antonov An-12 (Cub)',
    'Le C-130 soviétique, produit à plus de mille exemplaires',
    'The Soviet C-130, built in more than a thousand examples',
    '/assets/airplanes/an12.jpg',
    E'## Genèse\nLe bureau **Antonov**, installé à Kiev depuis 1952, se voit confier le transport militaire moyen que l''URSS n''a pas. Il part de l''An-10, un avion de ligne à quatre turbopropulseurs, et le transforme : fuselage relevé à l''arrière pour loger une rampe, plancher renforcé, structure adaptée aux terrains sommaires. Le calendrier est presque identique à celui du **C-130** américain, sans que l''un ait copié l''autre.\n\n## Conception\nAile haute, quatre AI-20, rampe arrière — la même grammaire que l''Hercules, à une différence près : le fuselage n''est **pressurisé qu''à l''avant**, la soute restant à la pression extérieure. C''est plus simple et plus léger, mais les parachutistes et le fret voyagent au froid. Autre singularité, héritée de la doctrine soviétique : une **tourelle de queue armée de deux canons de 23 mm**, servie par un homme, que l''on ne trouve sur aucun transport occidental.\n\n## Carrière opérationnelle\nIl équipe toute l''aviation de transport soviétique et celle de trente-huit pays. Il assure le pont aérien vers l''**Afghanistan** pendant dix ans, ravitaille l''Inde en 1971, l''Irak, l''Égypte, l''Angola. Sa seconde vie est civile et souvent trouble : des An-12 d''occasion transportent du fret sur tous les continents, parfois pour des opérations peu regardantes, et le type figure parmi les plus accidentés en service commercial.\n\n## Place dans l''histoire\nMille deux cent quarante-huit exemplaires, et une descendance chinoise — le **Shaanxi Y-8** — qui se construit encore aujourd''hui, soixante ans après. Son successeur soviétique direct est l''**Il-76** à réaction, mais l''An-12 lui a survécu dans nombre d''armées faute de moyens pour le remplacer.',
    E'## Genesis\nThe **Antonov** bureau, established in Kyiv since 1952, was given the medium military transport the USSR lacked. It started from the An-10, a four-turboprop airliner, and transformed it: an upswept rear fuselage to take a ramp, a strengthened floor, a structure suited to rough fields. The timetable is almost identical to that of the American **C-130**, without either having copied the other.\n\n## Design\nA high wing, four AI-20s, a rear ramp — the same grammar as the Hercules, with one difference: the fuselage is **pressurised only at the front**, the hold staying at outside pressure. That is simpler and lighter, but paratroops and freight travel cold. Another peculiarity, inherited from Soviet doctrine: a **tail turret with two 23 mm cannon**, manned, found on no Western transport.\n\n## Operational career\nIt equipped the whole of Soviet transport aviation and that of thirty-eight countries. It ran the air bridge to **Afghanistan** for ten years, resupplied India in 1971, Iraq, Egypt, Angola. Its second life is civil and often murky: second-hand An-12s carry freight on every continent, sometimes for undiscriminating operators, and the type is among the most accident-prone in commercial service.\n\n## Place in history\nOne thousand two hundred and forty-eight built, and a Chinese descendant — the **Shaanxi Y-8** — still being built today, sixty years on. Its direct Soviet successor is the jet **Il-76**, but the An-12 outlived it in many air forces for want of the means to replace it.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1955-01-01',
    '1957-12-16',
    '1959-01-01',
    660.0,
    5700.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM armement WHERE name = 'NR-23'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 33.1,
  wingspan          = 38.0,
  height            = 10.53,
  wing_area         = 121.7,
  empty_weight      = 28000,
  mtow              = 61000,
  service_ceiling   = 10200,
  climb_rate        = 10.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3600,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-20K',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1973,
  units_built       = 1248,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 38,
  variants          = E'- **An-12B / BK** : versions de transport tactique principales\n- **An-12PP** : guerre électronique, brouillage de zone\n- **An-12BSM** : version de largage de charges lourdes sur palettes\n- **Shaanxi Y-8** : copie chinoise, toujours produite et déclinée en guet aérien\n- **Tourelle de queue à deux canons de 23 mm** : rareté sur un avion de transport',
  variants_en       = E'- **An-12B / BK** : the main tactical transport versions\n- **An-12PP** : electronic warfare, area jamming\n- **An-12BSM** : heavy palletised load dropping version\n- **Shaanxi Y-8** : Chinese copy, still in production and developed into an AEW platform\n- **Tail turret with two 23 mm cannon** : a rarity on a transport aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Cub',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Antonov An-12';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-12';
