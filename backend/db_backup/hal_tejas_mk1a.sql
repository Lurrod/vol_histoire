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
    'HAL Tejas Mk1A',
    'HAL Tejas Mk1A',
    'HAL Tejas Mk1A LCA (Indian Air Force)',
    'HAL Tejas Mk1A LCA (Indian Air Force)',
    'Version modernisée du Tejas Mk1 avec radar AESA et armement BVR',
    'Upgraded Tejas Mk1 variant with AESA radar and BVR weapons',
    '/assets/airplanes/hal-tejas-mk1a.jpg',
    'Le HAL Tejas Mk1A est la version améliorée du Tejas Mk1, introduisant un radar à antenne active (AESA) EL/M-2052 d''Elta, une suite de guerre électronique EW indigène Angad, une capacité BVR intégrée (Derby NG / Astra Mk1) et un maintenance friendly cockpit. 83 appareils commandés en 2021 pour 46 898 crore INR, premières livraisons attendues en 2024. Le Mk1A comble l''écart capacitaire en attendant la génération Mk2 (MWF).',
    'The HAL Tejas Mk1A is the upgraded variant of the Tejas Mk1, introducing an Elta EL/M-2052 AESA radar, an indigenous Angad EW suite, an integrated BVR capability (Derby NG / Astra Mk1) and a maintenance-friendly cockpit. 83 aircraft ordered in 2021 for INR 46,898 crore, first deliveries expected in 2024. The Mk1A fills the capability gap pending the Mk2 (MWF) generation.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2018-01-01',
    '2024-03-28',
    '2024-12-01',
    1975.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM armement WHERE name = 'Astra Mk1'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 13.20, wingspan = 8.20, height = 4.40, wing_area = 38.40,
  empty_weight = 6560, mtow = 13500, service_ceiling = 15240, climb_rate = 53,
  combat_radius = 500, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F404-GE-IN20', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 53.9, thrust_wet = 84.0,
  production_start = 2024, production_end = NULL, units_built = 0,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_Tejas',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_Tejas#Variants'
WHERE name = 'HAL Tejas Mk1A';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 42000000, unit_cost_year = 2021,
  manufacturer_page = 'https://hal-india.co.in/tejas',
  variants    = E'- **Mk1A** : upgrade Mk1 avec radar AESA Elta EL/M-2052, EW Angad, Derby NG/Astra Mk1 BVR, maintenance conviviale\n- 83 appareils commandés en 2021 (46 898 crore INR)\n- 97 appareils supplémentaires commandés en 2023 (67 000 crore INR)',
  variants_en = E'- **Mk1A** : Mk1 upgrade with Elta EL/M-2052 AESA radar, Angad EW, Derby NG/Astra Mk1 BVR, maintenance-friendly design\n- 83 aircraft ordered in 2021 (INR 46,898 crore)\n- 97 additional aircraft ordered in 2023 (INR 67,000 crore)'
WHERE name = 'HAL Tejas Mk1A';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nLe Tejas Mk1, premier chasseur moderne conçu en Inde, vole en janvier 2001 mais arrive tard en escadron et ne satisfait qu''à moitié l''Indian Air Force. En 2015, sous le ministre de la Défense **Manohar Parrikar**, naît l''idée d''une version intermédiaire, en attendant un Mk2 encore lointain. Le Conseil des acquisitions de défense approuve 73 Mk1A en août 2018 ; le 13 janvier 2021, le gouvernement valide 73 Mk1A et 10 biplaces, et le contrat est signé avec **HAL** le 3 février 2021, pour près de 48 000 crores de roupies.\n\n## Conception\nLe Mk1A garde la cellule delta et le réacteur **General Electric F404** du Mk1, mais en corrige les lacunes. Il reçoit un radar à antenne active, l''**EL/M-2052** israélien d''Elta sur une partie de la série et l''**Uttam** indien sur le reste, une suite de guerre électronique avec brouilleur en nacelle, le missile au-delà de la portée visuelle **Astra**, le missile de combat rapproché ASRAAM, le ravitaillement en vol et un générateur d''oxygène embarqué. Il doit aussi être plus simple à entretenir que son prédécesseur.\n\n## Essais\nLe prototype vole le 20 mai 2022, et le premier avion de série, **LA5033**, le 28 mars 2024. Les livraisons, attendues dès février 2024, glissent surtout faute de réacteurs : General Electric livre en retard les F404 commandés en 2021. Début 2026, HAL annonce la fin des essais d''armement, avec des tirs d''Astra et d''ASRAAM et des bombes guidées laser, et cinq avions prêts, tandis que d''autres attendent leur moteur. Fin 2026, aucun n''a encore été remis : selon ThePrint, le chef d''état-major de l''IAF annonce un premier escadron d''ici fin mars 2027. Ce sera le **No. 3 Squadron « Cobras »**, ancienne unité de MiG-21, à Nal, près de Bikaner.\n\n## Place dans l''histoire\nLe 25 septembre 2025, l''Inde commande 97 Mk1A supplémentaires, 68 monoplaces et 29 biplaces, pour 62 370 crores, ce qui porte le total à 180 avions. Pièce centrale du renouvellement de l''IAF, le Mk1A montre aussi, par ses retards, combien la dépendance à un réacteur étranger pèse encore sur l''aéronautique indienne.',
  description_en = E'## Genesis\nThe Tejas Mk1, India''s first modern home-grown fighter, flew in January 2001 but reached squadrons late and only half satisfied the Indian Air Force. In 2015, under Defence Minister **Manohar Parrikar**, an interim version was proposed to bridge the gap to a still-distant Mk2. The Defence Acquisition Council approved 73 Mk1As in August 2018; on 13 January 2021 the government cleared 73 Mk1As and 10 two-seaters, and the contract with **HAL** was signed on 3 February 2021 for nearly INR 48,000 crore.\n\n## Design\nThe Mk1A keeps the Mk1''s delta airframe and **General Electric F404** engine but fixes its shortcomings. It gains an active-array radar, Elta''s Israeli **EL/M-2052** on part of the batch and India''s own **Uttam** on the rest, an electronic warfare suite with a podded jammer, the **Astra** beyond-visual-range missile, the ASRAAM dogfight missile, air-to-air refuelling and an on-board oxygen generator. It is also meant to be easier to maintain than its predecessor.\n\n## Testing\nThe prototype flew on 20 May 2022 and the first production aircraft, **LA5033**, on 28 March 2024. Deliveries, expected from February 2024, slipped mainly for want of engines, as General Electric fell behind on the F404s ordered in 2021. In early 2026 HAL announced that weapons trials were complete, with Astra and ASRAAM firings and laser-guided bombs, and that five aircraft were ready while others awaited engines. By late 2026 none had yet been handed over: according to ThePrint, the IAF chief expects a first squadron by the end of March 2027. It will be **No. 3 Squadron "Cobras"**, a former MiG-21 unit, at Nal near Bikaner.\n\n## Place in history\nOn 25 September 2025 India ordered 97 more Mk1As, 68 single-seaters and 29 two-seaters, for INR 62,370 crore, bringing the total to 180 aircraft. Central to the IAF''s renewal, the Mk1A also shows through its delays how heavily dependence on a foreign engine still weighs on Indian aerospace.'
WHERE name = 'HAL Tejas Mk1A';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'HAL Tejas Mk1A';
