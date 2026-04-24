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
    status_en,
    weight
) VALUES (
    'Embraer EMB-312 Tucano',
    'Embraer EMB-312 Tucano',
    'Embraer EMB-312 Tucano (Força Aérea Brasileira — T-27)',
    'Embraer EMB-312 Tucano (Brazilian Air Force — T-27)',
    'Avion d''entraînement turbopropulseur brésilien, standard mondial de la formation militaire',
    'Brazilian turboprop trainer, a global standard of military flight training',
    '/assets/airplanes/emb-312-tucano.jpg',
    'L''EMB-312 Tucano est un avion d''entraînement monoturbine à hélice biplace tandem conçu par Embraer, premier véritable succès commercial international brésilien. Adopté par la Força Aérea Brasileira sous la désignation T-27, il a été exporté à 14 pays et produit à 664 exemplaires entre 1983 et 1996. Sa conception moderne (cockpit jet-like, siège éjectable, 45° visibilité pilote arrière) a redéfini le standard de l''entraînement militaire à hélice. Le Royaume-Uni et Égypte l''ont produit sous licence (Short Tucano T.Mk 1 pour la RAF). Base technique du Super Tucano.',
    'The EMB-312 Tucano is a single-turboprop tandem two-seat trainer designed by Embraer, Brazil''s first true international commercial success. Adopted by the Brazilian Air Force under the T-27 designation, it was exported to 14 countries and built in 664 examples between 1983 and 1996. Its modern design (jet-like cockpit, ejection seat, 45° rear pilot visibility) redefined the propeller military training standard. The United Kingdom and Egypt produced it under licence (Short Tucano T.Mk 1 for the RAF). Technical basis for the Super Tucano.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1978-01-01',
    '1980-08-16',
    '1983-09-29',
    458.0,
    1916.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Actif',
    'Active',
    1810.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 9.86, wingspan = 11.14, height = 3.40, wing_area = 19.40,
  empty_weight = 1810, mtow = 3175, service_ceiling = 9145, climb_rate = 11,
  combat_radius = 556, crew = 2, g_limit_pos = 6.0, g_limit_neg = -3.0,
  engine_name = 'Pratt & Whitney Canada PT6A-25C', engine_count = 1,
  engine_type = 'Turbopropulseur', engine_type_en = 'Turboprop',
  thrust_dry = NULL, thrust_wet = NULL,
  production_start = 1980, production_end = 1996, units_built = 664,
  operators_count = 14,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Embraer_EMB_312_Tucano',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Embraer_EMB_312_Tucano'
WHERE name = 'Embraer EMB-312 Tucano';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 3500000, unit_cost_year = 1990,
  manufacturer_page = 'https://www.embraer.com/',
  variants    = E'- **EMB-312 Tucano** : version initiale d''entraînement, désignation FAB **T-27**\n- **Shorts Tucano T.Mk 1** : version RAF produite sous licence à Belfast (130 appareils)\n- **EMB-312F** : version pour l''Armée de l''air française (50 appareils, 1993-2005)\n- Exporté à 14 pays : France, Royaume-Uni, Argentine, Égypte, Iran, Irak, Pérou, Colombie, Honduras, Mauritanie, Paraguay, Venezuela, Angola, Burkina Faso',
  variants_en = E'- **EMB-312 Tucano** : initial training variant, FAB **T-27** designation\n- **Shorts Tucano T.Mk 1** : RAF variant licence-built at Belfast (130 aircraft)\n- **EMB-312F** : French Air Force variant (50 aircraft, 1993-2005)\n- Exported to 14 countries: France, United Kingdom, Argentina, Egypt, Iran, Iraq, Peru, Colombia, Honduras, Mauritania, Paraguay, Venezuela, Angola, Burkina Faso'
WHERE name = 'Embraer EMB-312 Tucano';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme YT-25B lancé par la FAB en **1978** pour remplacer le Cessna T-37 et le North American T-6 Texan. Embraer innove en proposant un **monomoteur turbopropulseur tandem biplace** avec cockpit inspiré des jets — siège éjectable, verrière type jet, avionique moderne. Premier vol le **16 août 1980**, mise en service le **29 septembre 1983**.\n\n## Carrière opérationnelle\n**664 exemplaires produits** en 16 ans. Premier grand succès commercial international d''Embraer — exporté à 14 pays. Contrat historique avec le Royaume-Uni : **130 Shorts Tucano T.Mk 1** produits sous licence à Belfast pour la RAF entre 1987 et 1993. Utilisé par l''Armée de l''air française comme entraîneur primaire pendant 13 ans (1993-2005).\n\n## Héritage\nA redéfini le **standard mondial de l''entraînement militaire à hélice** — cockpit jet-like, HOTAS partiel, passage direct aux jets d''entraînement. Base technique du **Super Tucano** (2003) qui a repris sa cellule aile et ses commandes. Le Tucano reste produit et modernisé (upgrade RAF prolongation jusqu''en 2016).',
  description_en = E'## Genesis\nYT-25B programme launched by the FAB in **1978** to replace the Cessna T-37 and the North American T-6 Texan. Embraer innovates by proposing a **single-engine turboprop tandem two-seater** with a jet-inspired cockpit — ejection seat, jet-style canopy, modern avionics. First flight on **16 August 1980**, service entry on **29 September 1983**.\n\n## Operational career\n**664 examples built** over 16 years. Embraer''s first major international commercial success — exported to 14 countries. Historic contract with the United Kingdom: **130 Shorts Tucano T.Mk 1** licence-built at Belfast for the RAF between 1987 and 1993. Used by the French Air Force as a primary trainer for 13 years (1993-2005).\n\n## Legacy\nRedefined the **world standard for propeller military training** — jet-like cockpit, partial HOTAS, direct transition to training jets. Technical basis for the **Super Tucano** (2003) which reused its wing airframe and controls. The Tucano remains produced and upgraded (RAF upgrade extending service until 2016).'
WHERE name = 'Embraer EMB-312 Tucano';
