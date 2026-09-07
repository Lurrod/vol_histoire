-- Boeing F-15EX Eagle II
--
-- Photo : F-15EX Eagle II.jpg
--   licence Public domain — Ethan Wagner
--   https://commons.wikimedia.org/wiki/File%3AF-15EX_Eagle_II.jpg

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
    'F-15EX Eagle II',
    'F-15EX Eagle II',
    'Boeing F-15EX Eagle II',
    'Boeing F-15EX Eagle II',
    'Dernière évolution du F-15, cinquante ans après le premier vol',
    'Latest evolution of the F-15, fifty years after its first flight',
    '/assets/airplanes/f15ex-eagle-2.jpg',
    E'## Genèse\nEn 2018, l''US Air Force fait un constat gênant : ses F-15C ont trente-cinq ans de moyenne d''âge et le F-35 ne peut pas tout remplacer. Plutôt qu''un nouveau programme, elle achète une cellule déjà développée et payée par d''autres — celle des **F-15QA** vendus au Qatar.\n\n## Conception\nStructure recalculée pour **20 000 heures de vol**, commandes de vol entièrement électriques, calculateur de mission ouvert (*Open Mission Systems*), suite de guerre électronique EPAWSS et onze points d''emport. L''appareil n''a aucune furtivité et n''en revendique aucune : sa raison d''être est d''emporter beaucoup, loin, et de tirer depuis l''arrière du dispositif ce que les avions furtifs désignent en avant.\n\n## Carrière opérationnelle\nLivré à partir de 2021, il n''a pas encore été engagé en opérations. L''US Air Force en prévoit une centaine, l''Indonésie et Israël ont signé pour des dérivés. Il sert d''abord dans les unités de la Garde nationale chargées de la défense du territoire.\n\n## Place dans l''histoire\nLe F-15EX matérialise la doctrine du **high-low mix** : un chasseur furtif coûteux et un porteur d''armes conventionnel, complémentaires plutôt que concurrents. C''est aussi la démonstration qu''une cellule de 1972 peut, refondue, rester pertinente jusqu''aux années 2050.',
    E'## Genesis\nIn 2018 the US Air Force faced an awkward fact: its F-15Cs averaged thirty-five years of age and the F-35 could not replace everything. Rather than launch a new programme, it bought an airframe already developed and paid for by others — that of the **F-15QA** sold to Qatar.\n\n## Design\nStructure recalculated for **20,000 flight hours**, fully fly-by-wire controls, an open mission computer (*Open Mission Systems*), the EPAWSS electronic warfare suite and eleven weapon stations. The aircraft has no stealth and claims none: its purpose is to carry a lot, far, and to shoot from behind the formation at what stealth aircraft designate ahead of it.\n\n## Operational career\nDelivered from 2021, it has not yet seen operations. The US Air Force plans about a hundred; Indonesia and Israel have signed for derivatives. It serves first with Air National Guard units tasked with homeland defence.\n\n## Place in history\nThe F-15EX embodies the **high-low mix** doctrine: an expensive stealth fighter and a conventional weapons truck, complementary rather than competing. It also proves that a 1972 airframe, rebuilt, can stay relevant into the 2050s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2018-01-01',
    '2021-02-02',
    '2021-03-11',
    2650.0,
    4400.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM armement WHERE name = 'AGM-158 JASSM')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.43,
  wingspan          = 13.05,
  height            = 5.63,
  wing_area         = 56.5,
  empty_weight      = 14300,
  mtow              = 36700,
  service_ceiling   = 18200,
  climb_rate        = 254,
  g_limit_pos       = 9.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F110-GE-129',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 76.3,
  thrust_wet        = 129.0,

  -- Strate 3 : production & service
  production_start  = 2020,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 87700000,
  unit_cost_year    = 2020,
  operators_count   = 1,
  variants          = E'- **F-15EX** : version US Air Force, dérivée des F-15QA qataris\n- **F-15QA / F-15SA / F-15SG** : versions export dont la cellule a servi de base\n- **F-15E Strike Eagle** : ancêtre direct, toujours en service en parallèle',
  variants_en       = E'- **F-15EX** : US Air Force version, derived from the Qatari F-15QA\n- **F-15QA / F-15SA / F-15SG** : export versions whose airframe served as the basis\n- **F-15E Strike Eagle** : direct ancestor, still serving alongside it',

  -- Strate 4 : qualitatif
  nickname          = 'Eagle II',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_F-15EX_Eagle_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_F-15EX_Eagle_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ethan Wagner',
  image_licence     = 'Public domain'
WHERE name = 'F-15EX Eagle II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-15EX Eagle II';
