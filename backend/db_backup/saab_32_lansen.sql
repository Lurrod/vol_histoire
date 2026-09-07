-- Saab 32 Lansen
--
-- Photo : Saab 32 Lansen SE-RME 5D4 8549 (52256858070).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford, United Kingdom
--   https://commons.wikimedia.org/wiki/File%3ASaab_32_Lansen_SE-RME_5D4_8549_%2852256858070%29.jpg

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
    'Saab 32 Lansen',
    'Saab 32 Lansen',
    'Saab 32 Lansen',
    'Saab 32 Lansen',
    'Premier avion de combat suédois à aile en flèche, polyvalent avant l’heure',
    'First Swedish swept-wing combat aircraft, multirole ahead of its time',
    '/assets/airplanes/saab-32-lansen.jpg',
    E'## Genèse\nLa Suède neutre ne peut compter que sur elle-même. En 1946, elle demande à Saab un appareil capable d''atteindre **n''importe quel point de ses côtes en une heure** depuis une base centrale, et de détruire un navire de débarquement. Le cahier des charges est signé avant que l''aile en flèche ne soit maîtrisée nulle part en Europe.\n\n## Conception\nSaab teste l''aile à 35° sur un Safir modifié avant de l''appliquer au Lansen. Un équipage de deux, un radar, une centrale de tir, et surtout le **Rb 04** : le premier missile antinavire à guidage radar actif au monde à entrer en service, conçu en Suède. La cellule accepte les pistes sommaires et les sections d''autoroute prévues pour la dispersion en temps de guerre.\n\n## Carrière opérationnelle\nJamais engagé en combat. Quatre cent cinquante exemplaires servent la Flygvapnet dans quatre rôles successifs — attaque, chasse de nuit, reconnaissance, guerre électronique — pendant **quarante et un ans**. Les derniers J 32E ne sont retirés qu''en 1997.\n\n## Place dans l''histoire\nLe Lansen fonde la méthode suédoise : une cellule, plusieurs métiers, une industrie nationale complète malgré la taille du pays. Le **Draken** puis le **Viggen** et le **Gripen** en descendent directement, chacun poussant plus loin la même idée.',
    E'## Genesis\nNeutral Sweden could rely only on itself. In 1946 it asked Saab for an aircraft able to reach **any point on its coastline within an hour** from a central base, and destroy a landing ship. The specification was signed before the swept wing was mastered anywhere in Europe.\n\n## Design\nSaab tested the 35° wing on a modified Safir before applying it to the Lansen. A crew of two, a radar, a fire control computer, and above all the **Rb 04**: the first active radar-guided anti-ship missile in the world to enter service, designed in Sweden. The airframe accepted rough strips and the motorway sections earmarked for wartime dispersal.\n\n## Operational career\nNever engaged in combat. Four hundred and fifty aircraft served the Flygvapnet in four successive roles — attack, night fighter, reconnaissance, electronic warfare — for **forty-one years**. The last J 32Es were only retired in 1997.\n\n## Place in history\nThe Lansen founded the Swedish method: one airframe, several trades, a complete national industry despite the country’s size. The **Draken**, then the **Viggen** and the **Gripen**, descend directly from it, each pushing the same idea further.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1946-01-01',
    '1952-11-03',
    '1956-12-01',
    1114.0,
    3220.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM armement WHERE name = 'Rb 04E')),
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.94,
  wingspan          = 13.0,
  height            = 4.65,
  wing_area         = 37.4,
  empty_weight      = 7440,
  mtow              = 13500,
  service_ceiling   = 15000,
  climb_rate        = 100,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1100,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Svenska Flygmotor RM5A2 (Rolls-Royce Avon)',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 34.3,
  thrust_wet        = 47.1,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1960,
  units_built       = 450,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **A 32A** : version d''attaque, porteuse du missile antinavire Rb 04\n- **J 32B** : chasseur de nuit tout-temps, moteur et radar plus puissants\n- **S 32C** : version de reconnaissance maritime\n- **J 32E** : guerre électronique et remorquage de cibles, en service jusqu''en 1997',
  variants_en       = E'- **A 32A** : attack version, carrier of the Rb 04 anti-ship missile\n- **J 32B** : all-weather night fighter with more powerful engine and radar\n- **S 32C** : maritime reconnaissance version\n- **J 32E** : electronic warfare and target towing, in service until 1997',

  -- Strate 4 : qualitatif
  nickname          = 'Lansen',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_32_Lansen',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_32_Lansen',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald from Chelmsford, United Kingdom',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Saab 32 Lansen';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 32 Lansen';
