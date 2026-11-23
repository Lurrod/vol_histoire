-- Max Holste MH.1521 Broussard
--
-- Photo : Max Holste MH.1521M Broussard ‘104 307-FG’ (F-GHFG) (49847505011).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Max_Holste_MH.1521M_Broussard_%E2%80%98104_307-FG%E2%80%99_(F-GHFG)_(49847505011).jpg

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
    'Max Holste Broussard',
    'Max Holste Broussard',
    'Max Holste MH.1521 Broussard',
    'Max Holste MH.1521 Broussard',
    'Le « Beaver français », avion de liaison et d''observation des armées françaises pendant la guerre d''Algérie',
    'The ''French Beaver'', liaison and spotter aircraft of the French forces throughout the Algerian War',
    '/assets/airplanes/mh1521-broussard.jpg',
    E'## Genèse\nAprès la guerre, **Max Holste** conçoit le biplace MH.52, puis répond à un besoin de l''armée de Terre française pour un avion léger d''observation et de réglage d''artillerie : le **MH.152**, à aile haute et moteur Salmson de 220 ch, vole le 12 juin 1951. Entre-temps, les besoins de l''armée ont changé : elle veut désormais un utilitaire robuste dans l''esprit du **DHC-2 Beaver** canadien. Max Holste agrandit son avion, lui donne un fuselage à flancs plats pour sept places et un moteur en étoile presque deux fois plus puissant : le **MH.1521** vole le 17 novembre 1952.\n\n## Conception\nLe Broussard — l''homme de la brousse, au sens des pilotes de brousse — est un monoplan entièrement métallique à aile haute haubanée, double dérive et train classique fixe. Son **Pratt & Whitney R-985 Wasp Junior** de 450 ch entraîne une hélice bipale à vitesse constante et le fait décoller en 200 m. Robuste et peu exigeant en entretien, il opère depuis des terrains non aménagés. Sa ressemblance avec le Beaver, en silhouette comme en performances, lui vaut le surnom de « Beaver français ». Son développement est soutenu au niveau politique par l''as **Pierre Clostermann**, ami de Max Holste.\n\n## Carrière opérationnelle\nLe premier appareil de série vole le 16 juin 1954. Pendant la **guerre d''Algérie**, plus de 150 Broussard sont engagés en coopération avec l''armée de Terre : réglage d''artillerie, ravitaillement par air, évacuation des blessés, missions où comptent leurs performances sur terrain court et leur résistance aux tirs du sol. Leur défaut tient au bruit : les combattants algériens entendent le moteur en étoile et la grande hélice bien avant les autres avions. Clostermann, qui les pilote à l''escadrille ELO 3/45, en tire un livre. Le Portugal les engage aussi en **Guinée portugaise** pendant sa guerre d''indépendance, pour l''observation, le réglage de tir et le ravitaillement.\n\n## Place dans l''histoire\nAprès l''indépendance algérienne, les Broussard rentrent en France pour la liaison, et beaucoup sont cédés aux jeunes États africains. L''armée de l''Air les retire en décembre 1987, l''armée de Terre en décembre 1993 et la Marine en 1996 ; une vingtaine volent encore en Afrique jusqu''en 1998. Construit à 396 exemplaires à Reims, il a été pendant près de quarante ans l''avion à tout faire de l''aviation légère militaire française.',
    E'## Genesis\nAfter the war **Max Holste** designed the two-seat MH.52, then answered a French Army requirement for a light observation and artillery-spotting aircraft: the **MH.152**, a high-wing design with a 220 hp Salmson engine, flew on 12 June 1951. In the meantime the Army''s needs had changed: it now wanted a rugged utility aircraft along the lines of Canada''s **DHC-2 Beaver**. Max Holste enlarged his design, gave it a slab-sided fuselage with room for seven and a radial engine of almost twice the power: the **MH.1521** flew on 17 November 1952.\n\n## Design\nThe Broussard — the ''bush man'', in the sense of a bush pilot — is an all-metal strut-braced high-wing monoplane with twin fins and fixed tailwheel landing gear. Its 450 hp **Pratt & Whitney R-985 Wasp Junior** drives a two-blade constant-speed propeller and gets it airborne in 200 m. Rugged and undemanding to maintain, it operates from unprepared strips. Its resemblance to the Beaver, in looks as in performance, earned it the nickname ''French Beaver''. Its development was backed at political level by the ace **Pierre Clostermann**, a friend of Max Holste.\n\n## Operational career\nThe first production aircraft flew on 16 June 1954. During the **Algerian War** more than 150 Broussards were deployed in Army cooperation: artillery spotting, air supply and casualty evacuation, roles where their short-field performance and resistance to ground fire counted. Their weakness was noise: Algerian fighters heard the radial engine and large propeller long before other aircraft. Clostermann, who flew them with Escadrille ELO 3/45, drew a book from it. Portugal also used them in **Portuguese Guinea** during its independence war, for observation, fire adjustment and supply.\n\n## Place in history\nAfter Algerian independence the Broussards returned to France for liaison, and many were handed to newly independent African states. The French Air Force retired them in December 1987, the Army in December 1993 and the Navy in 1996; some twenty still flew in Africa until 1998. Built to 396 examples at Reims, it was for almost forty years the maid-of-all-work of French military light aviation.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    NULL,
    '1952-11-17',
    '1954-01-01',
    259,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'MH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Max Holste Broussard'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Max Holste Broussard'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Max Holste Broussard'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Max Holste Broussard'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Max Holste Broussard'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.65,
  wingspan          = 13.75,
  height            = 3.67,
  wing_area         = 25.2,
  empty_weight      = 1650,
  mtow              = 2700,
  service_ceiling   = NULL,
  climb_rate        = 4.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-985-AN-1 Wasp Junior (451 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1961,
  units_built       = 396,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 19,
  variants          = E'- **MH.152** : prototype d''avion d''observation à moteur Salmson de 220 ch, premier vol le 12 juin 1951\n- **MH.1521** : prototypes et appareils de présérie, dont 19 militaires\n- **MH.1521M** : version de série des armées françaises, environ 320 exemplaires\n- **MH.1521C** : version civile et d''exportation\n- **MH.1522** : prototype à becs de bord d''attaque et volets à double fente, premier vol le 11 février 1958',
  variants_en       = E'- **MH.152**: observation prototype with a 220 hp Salmson engine, first flown on 12 June 1951\n- **MH.1521**: prototypes and pre-production aircraft, 19 of them military\n- **MH.1521M**: production version for the French armed forces, about 320 built\n- **MH.1521C**: civil and export version\n- **MH.1522**: prototype with leading-edge slats and double-slotted flaps, first flown on 11 February 1958',

  -- Strate 4 : qualitatif
  nickname          = 'Beaver français',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Max-Holste_MH-1521_Broussard',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Max_Holste_MH.1521_Broussard',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Max Holste Broussard';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Max Holste Broussard';
