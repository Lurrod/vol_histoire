-- Myasishchev M-4 Bison
--
-- Photo : Myasischev 3MD VVS museum.jpg
--   licence CC BY-SA 3.0 — Mike1979 Russia
--   https://commons.wikimedia.org/wiki/File%3AMyasischev_3MD_VVS_museum.jpg

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
    'Myasishchev M-4',
    'Myasishchev M-4',
    'Myasishchev M-4 Bison',
    'Myasishchev M-4 Bison',
    'Bombardier stratégique soviétique à l’origine du « bomber gap »',
    'Soviet strategic bomber behind the “bomber gap” scare',
    '/assets/airplanes/m4-bison.jpg',
    E'## Genèse\nEn 1951, Staline exige un bombardier à réaction capable d''atteindre les États-Unis et d''en revenir. Le bureau **Myasishchev**, rouvert pour l''occasion, livre un prototype en moins de deux ans — un délai qui restera inégalé pour un appareil de cette taille.\n\n## Conception\nCinquante mètres d''envergure, quatre réacteurs enterrés à l''emplanture, train en tandem avec balancines. Le défaut est fondamental : les turboréacteurs de l''époque consomment trop pour un vol transocéanique. Le M-4 n''atteint pas les États-Unis sans ravitaillement, ce que le commandement soviétique sait dès sa mise en service.\n\n## Carrière opérationnelle\nSa contribution la plus durable est involontaire. Au défilé aérien de **Toushino en 1955**, une poignée d''appareils repasse plusieurs fois devant les observateurs occidentaux, qui en concluent à une production massive. Le **bomber gap** ainsi inventé justifiera aux États-Unis un effort budgétaire considérable — sur la foi d''une flotte qui n''existait pas.\n\n## Place dans l''histoire\nQuatre-vingt-treize exemplaires seulement. Supplanté par le **Tu-95**, à hélices mais bien plus endurant, il finira ravitailleur puis transporteur d''éléments de la navette **Bourane**. Le M-4 est le rappel qu''une perception erronée peut peser plus lourd, stratégiquement, que la réalité matérielle.',
    E'## Genesis\nIn 1951 Stalin demanded a jet bomber able to reach the United States and return. The **Myasishchev** bureau, reopened for the purpose, delivered a prototype in under two years — a timescale never matched for an aircraft of that size.\n\n## Design\nFifty metres of span, four engines buried at the wing roots, tandem gear with outriggers. The flaw was fundamental: the turbojets of the day burned too much fuel for a transoceanic flight. The M-4 could not reach the United States without refuelling, something the Soviet command knew from the day it entered service.\n\n## Operational career\nIts most lasting contribution was unintended. At the **Tushino air parade in 1955** a handful of aircraft flew past Western observers several times, who concluded that mass production was under way. The **bomber gap** thus invented justified considerable American spending — on the strength of a fleet that did not exist.\n\n## Place in history\nOnly ninety-three built. Superseded by the propeller-driven but far longer-legged **Tu-95**, it ended its days as a tanker and then as a carrier of **Buran** shuttle components. The M-4 is a reminder that a mistaken perception can weigh more, strategically, than material reality.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1951-01-01',
    '1953-01-20',
    '1955-02-01',
    947.0,
    8100.0,
    (SELECT id FROM manufacturer WHERE code = 'MYA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM armement WHERE name = 'FAB-1500')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM armement WHERE name = 'FAB-3000')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM armement WHERE name = 'FAB-5000'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 47.2,
  wingspan          = 50.53,
  height            = 14.1,
  wing_area         = 309.0,
  empty_weight      = 79700,
  mtow              = 181500,
  service_ceiling   = 12150,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3600,
  crew              = 8,

  -- Strate 2 : motorisation
  engine_name       = 'Dobrynin VD-7B',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 93.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1963,
  units_built       = 93,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **M-4** : version initiale, rayon d''action insuffisant pour atteindre les États-Unis\n- **3M / M-6** : voilure et moteurs revus, ravitaillement en vol\n- **3MS-2 / 3MN-2** : convertis en ravitailleurs, rôle principal en fin de carrière\n- **VM-T Atlant** : version de transport de charges hors gabarit pour le programme Bourane',
  variants_en       = E'- **M-4** : initial version, with insufficient range to reach the United States\n- **3M / M-6** : revised wing and engines, air-to-air refuelling\n- **3MS-2 / 3MN-2** : converted to tankers, their main late-career role\n- **VM-T Atlant** : outsize cargo version for the Buran space programme',

  -- Strate 4 : qualitatif
  nickname          = 'Bison',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Miassichtchev_M-4',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Myasishchev_M-4',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mike1979 Russia',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Myasishchev M-4';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Myasishchev M-4';
