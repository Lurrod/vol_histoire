-- Gloster Meteor
--
-- Photo : Gloster Meteor (52577102516).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany, Germany
--   https://commons.wikimedia.org/wiki/File%3AGloster_Meteor_%2852577102516%29.jpg

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
    'Gloster Meteor',
    'Gloster Meteor',
    'Gloster Meteor',
    'Gloster Meteor',
    'Seul avion à réaction allié engagé pendant la Seconde Guerre mondiale',
    'The only Allied jet aircraft committed in the Second World War',
    '/assets/airplanes/gloster-meteor.jpg',
    E'## Genèse\nLe Meteor naît du réacteur de **Frank Whittle**, dont Gloster construit l''avion d''essai dès 1941. Contrairement au Messerschmitt Me 262, il conserve une aile droite : les Britanniques n''ont pas accès aux travaux allemands sur la flèche. C''est un choix conservateur qui lui coûtera sa carrière de chasseur de première ligne.\n\n## Conception\nDeux réacteurs en nacelles au milieu de l''aile, quatre canons de 20 mm dans le nez. La formule est sûre et facile à produire — près de **4 000 exemplaires** — mais l''aile droite plafonne la vitesse critique. Dès 1950, face aux MiG-15 à aile en flèche, l''écart est irrattrapable.\n\n## Carrière opérationnelle\nEngagé dès juillet 1944 contre les **bombes volantes V-1**, qu''il rattrape et fait basculer du bout de l''aile. En **Corée**, le 77e escadron australien subit de lourdes pertes face aux MiG-15 et bascule à l''attaque au sol. Israël, l''Égypte et la Syrie l''utilisent dans les années 1950 ; l''Argentine l''engage lors de la révolution de 1955.\n\n## Place dans l''histoire\nPremier avion à réaction opérationnel des Alliés, et le seul à avoir combattu pendant la Seconde Guerre mondiale. Le Meteor a servi quinze pays et volé jusque dans les années 1980 comme avion d''essai et remorqueur de cibles — une longévité qui doit tout à la robustesse et rien aux performances.',
    E'## Genesis\nThe Meteor grew out of **Frank Whittle**’s engine, for which Gloster built the test aircraft as early as 1941. Unlike the Messerschmitt Me 262 it kept a straight wing: the British had no access to German research on sweep. That conservative choice would cost it its front-line fighter career.\n\n## Design\nTwo engines in mid-wing nacelles, four 20 mm cannon in the nose. The formula was safe and easy to build — nearly **4,000 aircraft** — but the straight wing capped critical Mach. By 1950, against swept-wing MiG-15s, the gap was unbridgeable.\n\n## Operational career\nCommitted from July 1944 against **V-1 flying bombs**, which it caught and tipped over with its wingtip. Over **Korea** the Australian 77 Squadron suffered heavy losses to MiG-15s and switched to ground attack. Israel, Egypt and Syria flew it in the 1950s; Argentina used it during the 1955 revolution.\n\n## Place in history\nThe Allies’ first operational jet, and the only one to see combat in the Second World War. The Meteor served fifteen countries and flew into the 1980s as a test aircraft and target tug — a longevity that owes everything to ruggedness and nothing to performance.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1940-01-01',
    '1943-03-05',
    '1944-07-27',
    965.0,
    1610.0,
    (SELECT id FROM manufacturer WHERE code = 'GLO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.59,
  wingspan          = 11.33,
  height            = 3.96,
  wing_area         = 32.5,
  empty_weight      = 4846,
  mtow              = 7122,
  service_ceiling   = 13100,
  climb_rate        = 35,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 600,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Derwent 8',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 16.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1943,
  production_end    = 1955,
  units_built       = 3947,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **Meteor F.3 / F.4** : chasseurs de fin de guerre et d''après-guerre\n- **Meteor F.8** : version principale, engagée en Corée par l''Australie\n- **Meteor NF.11 à NF.14** : chasseurs de nuit biplaces à radar\n- **Meteor FR.9 / PR.10** : reconnaissance armée et photographique',
  variants_en       = E'- **Meteor F.3 / F.4** : late-war and post-war fighters\n- **Meteor F.8** : main version, flown in Korea by Australia\n- **Meteor NF.11 to NF.14** : two-seat radar night fighters\n- **Meteor FR.9 / PR.10** : armed and photographic reconnaissance',

  -- Strate 4 : qualitatif
  nickname          = 'Meatbox',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Gloster_Meteor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Gloster_Meteor',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters from Viersen, Germany, Germany',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Gloster Meteor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Gloster Meteor';
