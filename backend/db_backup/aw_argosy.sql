-- Armstrong Whitworth AW.660 Argosy
--
-- Photo : Argosy C1 A&AEE (25636367733).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:Argosy_C1_A%26AEE_(25636367733).jpg

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
    'Armstrong Whitworth AW.660 Argosy',
    'Armstrong Whitworth AW.660 Argosy',
    'Armstrong Whitworth AW.660 Argosy',
    'Armstrong Whitworth AW.660 Argosy',
    'La « brouette sifflante » bipoutre, dernier avion d''Armstrong Whitworth et pont vers le Hercules',
    'The twin-boom "Whistling Wheelbarrow", Armstrong Whitworth''s last aircraft and the RAF''s bridge to the Hercules',
    '/assets/airplanes/aw-argosy.jpg',
    E'## Genèse\nEn 1955, le ministère britannique de l''Air publie, d''après l''Operational Requirement 323, une spécification de cargo moyen-courrier. Armstrong Whitworth étudie un bimoteur militaire, l''AW.66, puis y renonce faute de financement, mais poursuit à ses frais une version civile devenue quadrimoteur, l''**AW.650**. Le premier Argosy vole le 8 janvier 1959. La RAF, qui doit remplacer ses **Hastings** et ses Valetta à moteurs à pistons, demande alors une version militaire, l''**AW.660**, dont le premier exemplaire vole le 4 mars 1961.\n\n## Conception\nL''Argosy adopte la formule de la nacelle et des poutres : l''empennage, porté par deux poutres prolongeant les nacelles intérieures, dégage l''arrière du fuselage pour un chargement en ligne droite, à hauteur de plateau de camion. Quatre turbopropulseurs **Rolls-Royce Dart** entraînent des hélices quadripales Rotol, et l''aile dérive de celle de l''**Avro Shackleton** pour réduire les coûts. La version militaire condamne la porte avant au profit d''un radar météo, remplace les portes arrière par des coquilles avec rampe intégrée, renforce le plancher, ajoute deux portes latérales pour les parachutistes et double l''autonomie du modèle civil. Le sifflement des Dart et sa silhouette lui valent le surnom de « Whistling Wheelbarrow », la brouette sifflante.\n\n## Carrière opérationnelle\nLe premier Argosy C.1 entre en service en mars 1962. Il emporte 69 soldats, 48 civières ou 13 t de fret, dont des automitrailleuses Ferret ou un obusier de 105 mm. Six escadrons l''utilisent, trois au Royaume-Uni et un à Aden, à Chypre et en Extrême-Orient, notamment à Changi, à Singapour. À partir de décembre 1970, les **C-130 Hercules** le remplacent, et le No. 70 Squadron retire le dernier Argosy de transport en février 1975. Neuf appareils, convertis en Argosy E.1, étalonnent les aides à la navigation des bases britanniques jusqu''en 1978.\n\n## Place dans l''histoire\nDernier avion conçu et produit par Armstrong Whitworth, l''Argosy a été construit à 74 exemplaires, dont 56 pour la RAF. Sa carrière civile, chez Riddle Airlines, British European Airways ou SAFE Air, se heurte à la concurrence des avions de ligne à pistons convertis en cargos ; les derniers exemplaires soutiennent pourtant la lutte contre les incendies en Alaska jusqu''en 1991. Pour la RAF, il aura assuré la transition entre les transports à pistons de l''après-guerre et le Hercules.',
    E'## Genesis\nIn 1955 the British Air Ministry issued a specification for a medium-range freighter based on Operational Requirement 323. Armstrong Whitworth studied a twin-engined military design, the AW.66, then dropped it for lack of finance, but pressed on at its own expense with a civil version that became a four-engined aircraft, the **AW.650**. The first Argosy flew on 8 January 1959. The RAF, which had to replace its piston-engined **Hastings** and Valettas, then called for a military version, the **AW.660**, whose first example flew on 4 March 1961.\n\n## Design\nThe Argosy used a pod-and-boom layout: the tail, carried on two booms extending from the inner engine nacelles, left the rear of the fuselage clear for straight-in loading at the height of a flatbed truck. Four **Rolls-Royce Dart** turboprops drove four-bladed Rotol propellers, and the wing was derived from that of the **Avro Shackleton** to cut costs. The military version sealed the nose door to house a weather radar, replaced the rear doors with clamshells and an integral ramp, strengthened the floor, added two side doors for paratroopers and doubled the range of the civil model. The whistle of its Darts and its outline earned it the nickname "Whistling Wheelbarrow".\n\n## Operational career\nThe first Argosy C.1 entered service in March 1962. It carried 69 troops, 48 stretchers or 13 tonnes of freight, including Ferret armoured cars or a 105 mm howitzer. Six squadrons flew it, three in the United Kingdom and one each in Aden, Cyprus and the Far East, at Changi in Singapore. From December 1970 the **C-130 Hercules** progressively replaced it, and No. 70 Squadron retired the last transport Argosy in February 1975. Nine aircraft converted to Argosy E.1 standard calibrated navigation aids at British airfields until 1978.\n\n## Place in history\nThe last aircraft designed and built by Armstrong Whitworth, the Argosy was produced in 74 examples, 56 of them for the RAF. Its civil career, with Riddle Airlines, British European Airways or SAFE Air, ran up against piston airliners converted into cheap freighters; even so, the last examples supported firefighting in Alaska until 1991. For the RAF it bridged the gap between the piston transports of the post-war years and the Hercules.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1955-01-01',
    '1959-01-08',
    '1962-03-01',
    NULL,
    5550,
    (SELECT id FROM manufacturer WHERE code = 'AW'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Armstrong Whitworth AW.660 Argosy'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Armstrong Whitworth AW.660 Argosy'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Armstrong Whitworth AW.660 Argosy'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.44,
  wingspan          = 35.05,
  height            = 8.92,
  wing_area         = 135.5,
  empty_weight      = 25401,
  mtow              = 47627,
  service_ceiling   = 7000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Dart RDa.8 Mk 101 (2 470 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 74,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **AW.650 Series 100** : version civile initiale pour Riddle Airlines et BEA, dix exemplaires\n- **AW.650 Series 200 / 220** : aile plus légère à structure à sécurité intégrée, portes agrandies pour les palettes, sept exemplaires\n- **Argosy C.1 (AW.660)** : version militaire de la RAF, radar dans le nez, portes à coquille avec rampe, 56 exemplaires\n- **Argosy E.1** : neuf C.1 convertis en 1971 pour l''étalonnage des aides à la navigation\n- **Argosy T.2** : deux C.1 transformés en avions-écoles de navigation, programme abandonné',
  variants_en       = E'- **AW.650 Series 100**: initial civil version for Riddle Airlines and BEA, ten built\n- **AW.650 Series 200 / 220**: lighter fail-safe wing, enlarged doors for pallets, seven built\n- **Argosy C.1 (AW.660)**: RAF military version, nose radar, clamshell doors with ramp, 56 built\n- **Argosy E.1**: nine C.1s converted in 1971 for navigation-aid calibration\n- **Argosy T.2**: two C.1s converted as navigation trainers, programme abandoned',

  -- Strate 4 : qualitatif
  nickname          = 'Whistling Wheelbarrow',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Armstrong_Whitworth_A.W.660_Argosy',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Armstrong_Whitworth_AW.660_Argosy',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Armstrong Whitworth AW.660 Argosy';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Armstrong Whitworth AW.660 Argosy';
