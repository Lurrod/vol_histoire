-- Dassault Mystère IV
--
-- Photo : Dassault Mystère IV.jpg
--   licence CC BY-SA 3.0 — Jean-Christophe BENOIST
--   https://commons.wikimedia.org/wiki/File%3ADassault_Myst%C3%A8re_IV.jpg

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
    'Mystère IV',
    'Mystère IV',
    'Dassault Mystère IV',
    'Dassault Mystère IV',
    'Premier avion français à franchir Mach 1, en piqué, en 1954',
    'First French aircraft to pass Mach 1, in a dive, in 1954',
    '/assets/airplanes/mystere-4.jpg',
    E'## Genèse\nTroisième étage de la reconstruction de Dassault après l''Ouragan et le Mystère II, le Mystère IV n''est pas une évolution mais une cellule neuve : aile plus fine à 38° de flèche, fuselage affiné, commandes irréversibles. Le 28 février 1954, il franchit Mach 1 en piqué — une première française.\n\n## Conception\nEntrée d''air frontale ovale, deux canons DEFA de 30 mm dans le nez, réacteur britannique Tay construit sous licence puis remplacé par le Verdon national. L''appareil est financé pour moitié par l''**aide américaine** au titre de l''OTAN : 225 des 421 exemplaires sont payés par Washington, qui voit dans le Mystère un moyen de réarmer l''Europe sans y consacrer ses propres chaînes.\n\n## Carrière opérationnelle\nEngagé par la France en **Algérie** et lors de l''expédition de Suez en 1956. **Israël** l''utilise intensivement en 1956 et 1967, où ses Mystère IV détruisent au sol une part importante de l''aviation égyptienne. L''**Inde** l''engage contre le Pakistan en 1965 et 1971 dans l''appui au sol.\n\n## Place dans l''histoire\nLe Mystère IV est le premier avion de combat français exporté en série depuis 1939. Il ouvre la séquence commerciale que poursuivront le **Super Mystère B2** puis le **Mirage III** — et fixe la relation durable entre Dassault et l''armée de l''air israélienne.',
    E'## Genesis\nThe third stage of Dassault’s post-war reconstruction after the Ouragan and Mystère II, the Mystère IV was not an evolution but a new airframe: a thinner wing swept 38°, a slimmer fuselage, irreversible controls. On 28 February 1954 it passed Mach 1 in a dive — a French first.\n\n## Design\nAn oval nose intake, two 30 mm DEFA cannon in the nose, a British Tay engine built under licence and later replaced by the national Verdon. The aircraft was half financed by **American aid** under NATO: 225 of the 421 built were paid for by Washington, which saw in the Mystère a way to rearm Europe without committing its own production lines.\n\n## Operational career\nCommitted by France in **Algeria** and during the 1956 Suez expedition. **Israel** used it heavily in 1956 and 1967, where its Mystère IVs destroyed a substantial part of the Egyptian air force on the ground. **India** flew it against Pakistan in 1965 and 1971 in the ground attack role.\n\n## Place in history\nThe Mystère IV was the first French combat aircraft exported in series since 1939. It opened the commercial sequence continued by the **Super Mystère B2** and then the **Mirage III** — and established the lasting relationship between Dassault and the Israeli Air Force.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1951-01-01',
    '1952-09-28',
    '1955-05-01',
    1120.0,
    1320.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Mystère IV'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.85,
  wingspan          = 11.12,
  height            = 4.6,
  wing_area         = 32.0,
  empty_weight      = 5875,
  mtow              = 9500,
  service_ceiling   = 15000,
  climb_rate        = 45,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 570,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Hispano-Suiza Verdon 350',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 34.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1958,
  units_built       = 421,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Mystère IVA** : version de série, moteur Tay puis Verdon\n- **Mystère IVN** : chasseur de nuit biplace, resté prototype\n- Financé en grande partie par l''**aide militaire américaine** dans le cadre de l''OTAN\n- Exporté vers **Israël** et l''**Inde**, tous deux utilisateurs au combat',
  variants_en       = E'- **Mystère IVA** : production version, Tay then Verdon engine\n- **Mystère IVN** : two-seat night fighter, remained a prototype\n- Largely financed by **American military aid** under NATO\n- Exported to **Israel** and **India**, both of which used it in combat',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Myst%C3%A8re_IV',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Myst%C3%A8re_IV',
  youtube_showcase  = NULL,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/passion/avions/',
  image_credit      = 'Jean-Christophe BENOIST',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Mystère IV';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mystère IV';
