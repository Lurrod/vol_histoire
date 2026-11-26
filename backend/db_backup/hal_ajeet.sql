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
    'HAL Ajeet',
    'HAL Ajeet',
    'HAL Ajeet (Indian Air Force)',
    'HAL Ajeet (Indian Air Force)',
    'Chasseur léger indien dérivé amélioré du Folland Gnat',
    'Indian light fighter derived from an improved Folland Gnat',
    '/assets/airplanes/hal-ajeet.jpg',
    'Le HAL Ajeet ("Invincible") est une version indienne améliorée du Folland Gnat Mk.1, produite sous licence puis redéveloppée par HAL. Ses améliorations principales portent sur une avionique modernisée, des réservoirs de carburant additionnels dans les ailes et quatre points d''emport au lieu de deux. 79 exemplaires produits entre 1976 et 1982 pour l''Indian Air Force. Retiré en 1991. Le Folland Gnat/Ajeet s''est notamment illustré lors de la guerre indo-pakistanaise de 1971, où il s''est vu décerner le surnom de "Sabre Slayer" (tueur de F-86 Sabre).',
    'The HAL Ajeet ("Invincible") is an improved Indian version of the Folland Gnat Mk.1, produced under licence then redeveloped by HAL. Its main improvements concern modernised avionics, additional fuel tanks in the wings and four hardpoints instead of two. 79 airframes produced between 1976 and 1982 for the Indian Air Force. Retired in 1991. The Folland Gnat/Ajeet notably distinguished itself during the 1971 Indo-Pakistani War, where it earned the nickname "Sabre Slayer".',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1972-01-01',
    '1975-03-05',
    '1977-09-30',
    1150.0,
    800.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 9.07, wingspan = 6.75, height = 2.46, wing_area = 12.69,
  empty_weight = 2810, mtow = 4170, service_ceiling = 13720, climb_rate = 106,
  combat_radius = 370, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'HAL Orpheus 701-01 (licence Bristol Siddeley)', engine_count = 1,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 20.0, thrust_wet = NULL,
  production_start = 1975, production_end = 1982, units_built = 89,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Ajeet',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Ajeet'
WHERE name = 'HAL Ajeet';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 1500000, unit_cost_year = 1976,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **Ajeet Mk1** : monoplace d''interception et d''appui-feu\n- **Ajeet Trainer** : biplace d''entraînement (2 prototypes uniquement)',
  variants_en = E'- **Ajeet Mk1** : single-seat interceptor and ground attack\n- **Ajeet Trainer** : two-seat trainer (2 prototypes only)'
WHERE name = 'HAL Ajeet';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nL''Inde a fait du **Folland Gnat** britannique l''un de ses chasseurs : un contrat de septembre 1956 en autorise la production sous licence chez **HAL**, à Bangalore, et le premier exemplaire construit à partir de pièces indiennes vole en mai 1962. Surnommé « Sabre Slayer » pour ses victoires sur les F-86 pakistanais en 1965 et 1971, le Gnat a pourtant ses défauts : hydraulique capricieuse, canons Aden peu fiables, commandes de vol délicates. En 1972, l''armée de l''air indienne demande un Gnat amélioré : ce sera l''Ajeet, « l''Invincible » en sanskrit.\n\n## Conception\nHAL garde la silhouette du Gnat mais en reprend l''intérieur. L''aile devient réservoir intégral, ce qui libère les points d''emport sous voilure pour l''armement, et une paire de points supplémentaires porte leur nombre à quatre. L''avionique et l''hydraulique sont modernisées, l''empennage horizontal devient monobloc et le pilote reçoit un siège éjectable **Martin-Baker** GF4. Le réacteur reste l''Orpheus, construit sous licence par HAL.\n\n## Essais\nLes deux derniers Gnat de série servent de prototypes : le premier vole en mars 1975, le second le 5 novembre 1975. Le premier Ajeet de série prend l''air le 30 septembre 1976.\n\n## Carrière opérationnelle\nEntré en service en 1977, l''Ajeet est produit à 79 exemplaires neufs selon Bharat Rakshak ; d''autres sources en comptent 89 en ajoutant dix Gnat convertis. Intercepteur léger et avion d''appui, il n''a jamais combattu. Un biplace d''entraînement est approuvé en 1976, mais son premier prototype s''écrase le 30 décembre 1982 lors de son quatorzième vol, tuant le Squadron Leader D. K. Powar. Seuls deux biplaces sont livrés, fin 1987 ou début 1988, et servent dans deux escadrons. Monoplaces et biplaces quittent le service en mars 1991.\n\n## Place dans l''histoire\nDernier maillon de la lignée Gnat, l''Ajeet montre la capacité de HAL à transformer en profondeur un avion construit sous licence, plutôt qu''à le reproduire à l''identique. Sa carrière, courte et sans combat, ferme le chapitre du chasseur léger britannique dans l''aviation indienne.',
  description_en = E'## Genesis\nIndia made the British **Folland Gnat** one of its fighters: a September 1956 contract allowed licence production by **HAL** in Bangalore, and the first aircraft built from Indian-made parts flew in May 1962. Nicknamed the "Sabre Slayer" for its victories over Pakistani F-86s in 1965 and 1971, the Gnat nonetheless had its flaws: troublesome hydraulics, unreliable Aden cannon and tricky flight controls. In 1972 the Indian Air Force asked for an improved Gnat: the result was the Ajeet, "Invincible" in Sanskrit.\n\n## Design\nHAL kept the Gnat''s outline but reworked its interior. The wing became an integral fuel tank, freeing the underwing hardpoints for weapons, and an extra pair of hardpoints brought the total to four. Avionics and hydraulics were modernised, the tailplane became all-moving and the pilot got a **Martin-Baker** GF4 ejection seat. The engine remained the Orpheus, licence-built by HAL.\n\n## Testing\nThe last two production Gnats served as prototypes: the first flew in March 1975, the second on 5 November 1975. The first production Ajeet took to the air on 30 September 1976.\n\n## Operational career\nEntering service in 1977, the Ajeet was built new in 79 examples according to Bharat Rakshak; other sources count 89 by adding ten converted Gnats. A light interceptor and ground-attack aircraft, it never saw combat. A two-seat trainer was approved in 1976, but the first prototype crashed on 30 December 1982 on its fourteenth flight, killing Squadron Leader D. K. Powar. Only two trainers were delivered, in late 1987 or early 1988, and served with two squadrons. Single-seaters and trainers alike were retired in March 1991.\n\n## Place in history\nThe last link in the Gnat line, the Ajeet showed HAL''s ability to rework a licence-built aircraft in depth rather than simply copy it. Its short, combat-free career closed the chapter of the British light fighter in Indian service.'
WHERE name = 'HAL Ajeet';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HAL Ajeet';
