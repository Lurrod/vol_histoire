-- Transall C-160
--
-- Photo : C-160 Transall Germany 50+95 Neubrandenburg 2013 (9965209624).jpg
--   licence CC BY-SA 2.0 — bomberpilot
--   https://commons.wikimedia.org/wiki/File%3AC-160_Transall_Germany_50%2B95_Neubrandenburg_2013_%289965209624%29.jpg

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
    'Transall C-160',
    'Transall C-160',
    'Transall C-160',
    'Transall C-160',
    'Transport franco-allemand, première coopération militaire des deux pays',
    'Franco-German transport, the two countries’ first military collaboration',
    '/assets/airplanes/transall-c160.jpg',
    E'## Genèse\nEn 1957, la France et l''Allemagne fédérale ont le même besoin — remplacer des Noratlas et des C-47 vieillissants — et une raison politique commune de le faire ensemble : douze ans après la guerre, un programme industriel partagé vaut déclaration. Le consortium **Transall**, contraction de *Transporter Allianz*, réunit Nord-Aviation, Weser et HFB. C''est la première coopération militaire franco-allemande, celle qui ouvrira la voie à l''Alpha Jet puis à Airbus.\n\n## Conception\nFormule classique — aile haute, rampe arrière, train dans des carénages — mais avec **deux turbopropulseurs seulement** là où le C-130 en a quatre. Les Tyne, construits sous licence, sont assez puissants pour compenser. L''appareil est plus court et plus léger que l''Hercules, mais sa soute est plus large, et il se pose sur huit cents mètres de terre battue. La version NG reçoit une perche de ravitaillement qui double son rayon d''action.\n\n## Carrière opérationnelle\nIl est l''outil de la projection française en Afrique pendant cinquante ans : Tchad, Kolwezi, Rwanda, Mali. Il évacue des ressortissants, largue des légionnaires, transporte des blessés. L''Allemagne l''engage en Somalie et en Afghanistan. La Turquie et l''Afrique du Sud l''exploitent aussi. Les deux **Gabriel** d''écoute électronique ont volé sur tous les théâtres français.\n\n## Place dans l''histoire\nDeux cent quatorze exemplaires et cinquante-cinq ans de service, jusqu''au retrait français de 2022. Son importance dépasse l''appareil : il a établi que la France et l''Allemagne pouvaient concevoir et produire ensemble un avion militaire complet. Son successeur, l''**A400M**, est né du même raisonnement, à l''échelle de sept pays.',
    E'## Genesis\nIn 1957 France and West Germany had the same need — replacing ageing Noratlas and C-47s — and a shared political reason for doing it together: twelve years after the war, a joint industrial programme amounted to a statement. The **Transall** consortium, a contraction of *Transporter Allianz*, brought together Nord-Aviation, Weser and HFB. It was the first Franco-German military collaboration, the one that opened the way to the Alpha Jet and then to Airbus.\n\n## Design\nA conventional layout — high wing, rear ramp, gear in fairings — but with **only two turboprops** where the C-130 has four. The licence-built Tynes are powerful enough to make up for it. The aircraft is shorter and lighter than the Hercules, but its hold is wider, and it lands in eight hundred metres of beaten earth. The NG version received a refuelling probe that doubles its radius.\n\n## Operational career\nIt was the instrument of French power projection in Africa for fifty years: Chad, Kolwezi, Rwanda, Mali. It evacuated nationals, dropped legionnaires, carried the wounded. Germany committed it in Somalia and Afghanistan. Turkey and South Africa flew it too. The two **Gabriel** listening aircraft flew in every French theatre.\n\n## Place in history\nTwo hundred and fourteen built and fifty-five years of service, until French withdrawal in 2022. Its importance goes beyond the aircraft: it established that France and Germany could design and build a complete military aircraft together. Its successor, the **A400M**, was born of the same reasoning, on the scale of seven countries.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1957-01-01',
    '1963-02-25',
    '1967-10-01',
    513.0,
    5000.0,
    (SELECT id FROM manufacturer WHERE code = 'TRA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Transall C-160'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.4,
  wingspan          = 40.0,
  height            = 11.65,
  wing_area         = 160.1,
  empty_weight      = 29000,
  mtow              = 51000,
  service_ceiling   = 8230,
  climb_rate        = 6.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1850,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Tyne RTy.20 Mk 22',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1985,
  units_built       = 214,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **C-160D** : version allemande, la plus nombreuse\n- **C-160F / NG** : versions françaises, la seconde à perche de ravitaillement\n- **C-160G Gabriel** : renseignement électronique, deux exemplaires\n- **C-160 Astarté** : relais de transmission vers les sous-marins nucléaires français\n- Retiré du service français en **2022**, après cinquante-cinq ans',
  variants_en       = E'- **C-160D** : German version, the most numerous\n- **C-160F / NG** : French versions, the latter with a refuelling probe\n- **C-160G Gabriel** : signals intelligence, two aircraft\n- **C-160 Astarté** : communications relay to French nuclear submarines\n- Withdrawn from French service in **2022**, after fifty-five years',

  -- Strate 4 : qualitatif
  nickname          = 'Transall',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Transall_C-160',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Transall_C-160',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'bomberpilot',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Transall C-160';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Transall C-160';
