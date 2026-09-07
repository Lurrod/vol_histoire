-- Lockheed C-5 Galaxy
--
-- Photo : C-5M Super Galaxy 140416-F-BO262-011.jpg
--   licence Public domain — Roland Balik
--   https://commons.wikimedia.org/wiki/File%3AC-5M_Super_Galaxy_140416-F-BO262-011.jpg

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
    'C-5 Galaxy',
    'C-5 Galaxy',
    'Lockheed C-5 Galaxy',
    'Lockheed C-5 Galaxy',
    'Le plus gros avion militaire occidental, ouvert aux deux extrémités',
    'The largest Western military aircraft, opening at both ends',
    '/assets/airplanes/c5-galaxy.jpg',
    E'## Genèse\nL''US Air Force veut, en 1961, pouvoir déposer une division blindée n''importe où sur la planète sans escale. Le programme **CX-HLS** demande un appareil deux fois plus gros que tout ce qui vole. Lockheed l''emporte devant Boeing, dont le projet perdant sera recyclé — sa disposition à pont supérieur et son moteur à fort taux de dilution donneront le **747**.\n\n## Conception\nDeux ponts : l''équipage et soixante-treize passagers en haut, la soute de trente-six mètres en bas. Comme sur l''An-124, l''appareil s''ouvre **aux deux extrémités** et le train s''agenouille. Ce train comporte vingt-huit roues sur cinq jambes, dont les quatre principales **pivotent** pour permettre au fuselage de rester aligné en approche par vent de travers. Les premiers Galaxy souffriront d''une aile sous-dimensionnée : il faudra la remplacer sur toute la flotte, opération sans précédent sur un avion de cette taille.\n\n## Carrière opérationnelle\nIl entre en service au Vietnam et évacue Saïgon en 1975 — l''un des vols, transportant des orphelins, s''écrase après une décompression, tuant cent cinquante-cinq personnes. Il achemine l''essentiel du matériel lourd vers le Golfe en 1991, puis vers l''Irak et l''Afghanistan. Il transporte des hélicoptères, des sous-marins de poche, des satellites, et le véhicule présidentiel partout où va le président.\n\n## Place dans l''histoire\nCent trente et un exemplaires, en service depuis 1969 et prévus jusqu''en 2040. Il reste le plus gros avion militaire occidental ; seul l''**An-124** soviétique, conçu quinze ans plus tard précisément pour le dépasser, le surclasse. Le **C-17**, plus petit, l''a complété sans jamais le remplacer : rien d''autre ne porte un char sur un océan.',
    E'## Genesis\nIn 1961 the US Air Force wanted to be able to put an armoured division anywhere on the planet without stopping. The **CX-HLS** programme called for an aircraft twice the size of anything flying. Lockheed beat Boeing, whose losing design would be recycled — its upper-deck layout and high-bypass engine produced the **747**.\n\n## Design\nTwo decks: crew and seventy-three passengers above, a thirty-six-metre hold below. As on the An-124, the aircraft opens **at both ends** and the gear kneels. That gear has twenty-eight wheels on five legs, the four main units **castering** so the fuselage can stay aligned in a crosswind approach. The first Galaxies suffered from an undersized wing: it had to be replaced across the whole fleet, an operation without precedent on an aircraft that size.\n\n## Operational career\nIt entered service over Vietnam and evacuated Saigon in 1975 — one flight, carrying orphans, crashed after a decompression, killing a hundred and fifty-five people. It carried the bulk of the heavy equipment to the Gulf in 1991, then to Iraq and Afghanistan. It carries helicopters, midget submarines, satellites, and the presidential vehicle wherever the president goes.\n\n## Place in history\nOne hundred and thirty-one built, in service since 1969 and planned to 2040. It remains the largest Western military aircraft; only the Soviet **An-124**, designed fifteen years later precisely to surpass it, is bigger. The smaller **C-17** complemented it without ever replacing it: nothing else carries a tank across an ocean.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1961-01-01',
    '1968-06-30',
    '1969-12-17',
    919.0,
    8890.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 75.31,
  wingspan          = 67.89,
  height            = 19.84,
  wing_area         = 576.0,
  empty_weight      = 172370,
  mtow              = 381000,
  service_ceiling   = 10600,
  climb_rate        = 8.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4440,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F138-GE-100',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 222.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1989,
  units_built       = 131,
  unit_cost_usd     = 100400000,
  unit_cost_year    = 1998,
  operators_count   = 1,
  variants          = E'- **C-5A** : version initiale, voilure remplacée en bloc dans les années 1980\n- **C-5B** : structure renforcée dès la construction, cinquante exemplaires\n- **C-5M Super Galaxy** : remotorisation et avionique neuve, flotte portée à 2040\n- **Ouverture nez et queue** : la visière avant se relève entièrement pour le chargement\n- Le train « s''agenouille » pour abaisser les deux planchers au niveau du sol',
  variants_en       = E'- **C-5A** : initial version, its wings replaced wholesale in the 1980s\n- **C-5B** : strengthened structure from build, fifty aircraft\n- **C-5M Super Galaxy** : re-engined with new avionics, the fleet extended to 2040\n- **Nose and tail loading** : the forward visor lifts clear entirely\n- The gear kneels to bring both floors down to ground level',

  -- Strate 4 : qualitatif
  nickname          = 'FRED',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_C-5_Galaxy',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_C-5_Galaxy',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Roland Balik',
  image_licence     = 'Public domain'
WHERE name = 'C-5 Galaxy';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-5 Galaxy';
