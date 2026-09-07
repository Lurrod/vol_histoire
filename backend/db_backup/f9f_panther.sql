-- Grumman F9F Panther
--
-- Photo : F9F-2 Panther at NACA Langley in 1958.jpeg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File%3AF9F-2_Panther_at_NACA_Langley_in_1958.jpeg

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
    'F9F Panther',
    'F9F Panther',
    'Grumman F9F Panther',
    'Grumman F9F Panther',
    'Premier chasseur à réaction de l’US Navy engagé au combat',
    'The US Navy’s first jet fighter committed to combat',
    '/assets/airplanes/f9f-panther.jpg',
    E'## Genèse\nGrumman se voit d''abord commander un chasseur de nuit à **quatre petits réacteurs**, formule qui ne tient pas la route : la consommation est ruineuse et la puissance insuffisante. L''apparition du Rolls-Royce Nene britannique, un seul réacteur plus puissant que les quatre réunis, sauve le programme. Le projet est repris de zéro en 1946 autour de ce moteur, construit sous licence par Pratt & Whitney.\n\n## Conception\nAile droite, fuselage court et trapu, tout conçu autour des contraintes du **pont d''envol** : voilure repliable, crosse d''appontage, train renforcé et surtout une vitesse d''approche basse, plus importante à bord qu''une vitesse de pointe élevée. Deux réservoirs de bout d''aile permanents donnent l''allonge. Quatre canons de 20 mm dans le nez, une charge sous voilure : c''est un chasseur simple, solide et prévisible, ce que réclame l''aéronavale.\n\n## Carrière opérationnelle\nLe **9 novembre 1950**, le lieutenant-commander William Amen abat un MiG-15 : première victoire aérienne de l''histoire de l''US Navy en avion à réaction. Le Panther sera surclassé en combat tournoyant par le MiG et deviendra l''avion d''attaque au sol de la marine en Corée, où il effectue soixante-dix-huit mille sorties. Deux de ses pilotes deviendront célèbres ailleurs : le joueur de baseball **Ted Williams** et l''astronaute **Neil Armstrong**.\n\n## Place dans l''histoire\nMille trois cent quatre-vingt-deux exemplaires, et la démonstration que l''aviation embarquée pouvait passer au réacteur sans renoncer à la sécurité du pont. Grumman prolongera la cellule avec le Cougar à aile en flèche puis le Tiger, ouvrant la lignée qui mènera au **F-14 Tomcat**.',
    E'## Genesis\nGrumman was first asked for a night fighter with **four small jet engines**, a formula that did not hold up: consumption was ruinous and thrust insufficient. The appearance of the British Rolls-Royce Nene, a single engine more powerful than all four together, saved the programme. The design was restarted from scratch in 1946 around that engine, built under licence by Pratt & Whitney.\n\n## Design\nA straight wing and a short, stocky fuselage, all shaped by the demands of the **flight deck**: folding wings, arrestor hook, reinforced landing gear and above all a low approach speed, which matters more aboard ship than a high top speed. Two permanent wingtip tanks give it reach. Four 20 mm cannon in the nose and a load under the wing: a simple, solid, predictable fighter, which is what naval aviation wanted.\n\n## Operational career\nOn **9 November 1950** Lieutenant Commander William Amen shot down a MiG-15: the first jet air victory in US Navy history. The Panther would be outclassed in turning combat by the MiG and became the Navy''s ground attack aircraft in Korea, where it flew seventy-eight thousand sorties. Two of its pilots became famous elsewhere: baseball player **Ted Williams** and astronaut **Neil Armstrong**.\n\n## Place in history\nOne thousand three hundred and eighty-two built, and proof that carrier aviation could move to jet power without giving up deck safety. Grumman extended the airframe with the swept-wing Cougar and then the Tiger, opening the line that would lead to the **F-14 Tomcat**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1946-04-22',
    '1947-11-21',
    '1949-05-08',
    925.0,
    2100.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F9F Panther'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.35,
  wingspan          = 11.58,
  height            = 3.45,
  wing_area         = 23.23,
  empty_weight      = 4220,
  mtow              = 9161,
  service_ceiling   = 13600,
  climb_rate        = 26.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 560,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J42-P-6',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1953,
  units_built       = 1382,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **F9F-2** : version initiale à réacteur Nene construit sous licence\n- **F9F-5** : fuselage allongé, version la plus produite\n- **F9F-5P** : reconnaissance photographique, sans armement\n- **F9F-6 Cougar** : évolution à aile en flèche, considérée comme un appareil distinct\n- L''**Argentine** l''a exploité de 1958 à 1969 depuis le porte-avions Independencia',
  variants_en       = E'- **F9F-2** : initial version with a licence-built Nene engine\n- **F9F-5** : lengthened fuselage, the most produced version\n- **F9F-5P** : photographic reconnaissance, unarmed\n- **F9F-6 Cougar** : swept-wing evolution, regarded as a distinct aircraft\n- **Argentina** flew it from 1958 to 1969 from the carrier Independencia',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_F9F_Panther',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_F9F_Panther',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'F9F Panther';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F9F Panther';
