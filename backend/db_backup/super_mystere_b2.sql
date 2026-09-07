-- Dassault Super Mystère B2
--
-- Photo : Dassault Super Mystere B2 pic1.JPG
--   licence CC0 — Alf van Beem
--   https://commons.wikimedia.org/wiki/File%3ADassault_Super_Mystere_B2_pic1.JPG

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
    'Super Mystère B2',
    'Super Mystère B2',
    'Dassault Super Mystère B2',
    'Dassault Super Mystère B2',
    'Premier avion de combat supersonique construit en Europe occidentale',
    'First supersonic combat aircraft built in Western Europe',
    '/assets/airplanes/super-mystere-b2.jpg',
    E'## Genèse\nLe Super Mystère est l''aboutissement de la lignée Ouragan – Mystère II – Mystère IV, par laquelle Dassault reconstruit une industrie aéronautique française partie de rien en 1945. Le 2 mars 1955, il franchit Mach 1 en palier : **aucun avion d''Europe occidentale ne l''avait fait**.\n\n## Conception\nAile à 45° de flèche, entrée d''air ovale, réacteur Atar national doté d''une postcombustion. Le saut technique est réel mais court : la vitesse maximale plafonne à Mach 1,1, et la génération suivante — delta, Mach 2 — est déjà sur les planches à dessin chez le même constructeur.\n\n## Carrière opérationnelle\nL''armée de l''air française l''engage en **Algérie**. Israël en reçoit 36 et les utilise en 1967 puis 1973, où ils tiennent le rôle ingrat de l''attaque au sol face aux défenses égyptiennes. Remotorisés **Sa''ar**, certains finiront leur carrière au Honduras dans les années 1990.\n\n## Place dans l''histoire\nProduit à seulement 180 exemplaires, il est vite éclipsé par le **Mirage III** qui lui succède directement. Son importance est industrielle plus qu''opérationnelle : il valide la formule Dassault — cellule simple, moteur national, export — qui portera le Mirage puis le Rafale.',
    E'## Genesis\nThe Super Mystère was the culmination of the Ouragan – Mystère II – Mystère IV line, through which Dassault rebuilt a French aviation industry that had started from nothing in 1945. On 2 March 1955 it passed Mach 1 in level flight: **no Western European aircraft had done so before**.\n\n## Design\nA 45° swept wing, an oval intake, and a national Atar engine fitted with an afterburner. The technical leap was real but brief: top speed plateaued at Mach 1.1, and the next generation — delta, Mach 2 — was already on the drawing boards at the same company.\n\n## Operational career\nThe French Air Force committed it in **Algeria**. Israel received 36 and used them in 1967 and then 1973, where they took the thankless ground-attack role against Egyptian defences. Re-engined as **Sa’ar**, some ended their careers in Honduras in the 1990s.\n\n## Place in history\nBuilt in only 180 examples, it was quickly eclipsed by the **Mirage III** that directly succeeded it. Its importance is industrial rather than operational: it validated the Dassault formula — simple airframe, national engine, export — that would carry the Mirage and then the Rafale.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1954-01-01',
    '1955-03-02',
    '1957-10-01',
    1195.0,
    1175.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM armement WHERE name = 'Matra R530')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.13,
  wingspan          = 10.51,
  height            = 4.55,
  wing_area         = 35.0,
  empty_weight      = 6932,
  mtow              = 10000,
  service_ceiling   = 17000,
  climb_rate        = 88,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 435,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 101G-2',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 34.3,
  thrust_wet        = 44.1,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1959,
  units_built       = 180,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Super Mystère B2** : unique version de série\n- **Sa''ar** : Super Mystère israéliens remotorisés au Pratt & Whitney J52 sans postcombustion\n- Une partie des Sa''ar israéliens sera revendue au **Honduras**, dernier utilisateur',
  variants_en       = E'- **Super Mystère B2** : the only production version\n- **Sa’ar** : Israeli Super Mystères re-engined with the non-afterburning Pratt & Whitney J52\n- Some Israeli Sa’ars were later sold to **Honduras**, the final operator',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Super_Myst%C3%A8re',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Super_Myst%C3%A8re',
  youtube_showcase  = NULL,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/passion/avions/',
  image_credit      = 'Alf van Beem',
  image_licence     = 'CC0'
WHERE name = 'Super Mystère B2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Super Mystère B2';
