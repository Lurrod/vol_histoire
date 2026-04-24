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
    'Embraer EMB-326 Xavante',
    'Embraer EMB-326 Xavante',
    'Embraer EMB-326GB Xavante (Força Aérea Brasileira)',
    'Embraer EMB-326GB Xavante (Brazilian Air Force)',
    'Version brésilienne sous licence de l''Aermacchi MB-326 italien',
    'Licence-built Brazilian version of the Italian Aermacchi MB-326',
    '/assets/airplanes/emb-326-xavante.jpg',
    'L''EMB-326 Xavante est la version brésilienne de l''Aermacchi MB-326 construite sous licence par Embraer entre 1971 et 1982 (182 appareils livrés à la Força Aérea Brasileira, Togo et Paraguay). Ce biplace d''entraînement et d''attaque légère a constitué le pilier de la formation de chasse brésilienne pendant plus de 30 ans, avant sa retraite en 2010. Il a permis à Embraer de maîtriser la production industrielle d''avions militaires jet, ouvrant la voie aux programmes AMX, Tucano et ultérieurs. Le nom Xavante fait référence à une tribu amérindienne du Mato Grosso.',
    'The EMB-326 Xavante is the Brazilian version of the Aermacchi MB-326 built under licence by Embraer between 1971 and 1982 (182 aircraft delivered to the Brazilian Air Force, Togo and Paraguay). This two-seat trainer and light attack aircraft was the pillar of Brazilian fighter training for over 30 years, before its retirement in 2010. It enabled Embraer to master the industrial production of military jet aircraft, paving the way for the AMX, Tucano and later programmes. The Xavante name refers to an Amerindian tribe from Mato Grosso.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1969-01-01',
    '1971-08-01',
    '1971-09-01',
    867.0,
    1850.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired',
    2685.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 10.63, wingspan = 10.85, height = 3.72, wing_area = 19.35,
  empty_weight = 2685, mtow = 5897, service_ceiling = 14325, climb_rate = 30,
  combat_radius = 370, crew = 2, g_limit_pos = 8.0, g_limit_neg = -4.0,
  engine_name = 'Rolls-Royce Viper Mk 20 Mk2 (licence Alfa Romeo/Piaggio)', engine_count = 1,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 11.1, thrust_wet = NULL,
  production_start = 1971, production_end = 1982, units_built = 182,
  operators_count = 3,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Aermacchi_MB-326',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Embraer_EMB-326_Xavante'
WHERE name = 'Embraer EMB-326 Xavante';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 1800000, unit_cost_year = 1975,
  manufacturer_page = 'https://www.embraer.com/',
  variants    = E'- **EMB-326GB Xavante** : version brésilienne sous licence Aermacchi MB-326GB (182 appareils)\n- Force Aérienne Brésilienne (FAB) : désignation **AT-26**, ~166 appareils livrés\n- Export : 9 Togo + 8 Paraguay\n- Servi de modèle industriel à Embraer pour les programmes Tucano et AMX',
  variants_en = E'- **EMB-326GB Xavante** : Brazilian Aermacchi MB-326GB licence version (182 aircraft)\n- Brazilian Air Force (FAB): **AT-26** designation, ~166 aircraft delivered\n- Export: 9 Togo + 8 Paraguay\n- Served as Embraer''s industrial model for the Tucano and AMX programmes'
WHERE name = 'Embraer EMB-326 Xavante';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat de licence signé en **1970** entre Aermacchi (Italie) et Embraer (Brésil naissant, fondé en 1969) pour produire le MB-326GB. Premier EMB-326 assemblé à São José dos Campos le **3 août 1971**. Contrat stratégique pour l''industrie aéronautique brésilienne débutante — Embraer ne construisait jusque-là que des appareils civils légers.\n\n## Carrière opérationnelle\n**182 exemplaires produits** à São José dos Campos sur 11 ans. Entraînement avancé et appui-feu léger pour la FAB pendant plus de 30 ans. Déployé dans la défense de la frontière amazonienne contre les incursions de narcotrafiquants et de contrebandiers. Retrait final en **2010**, remplacé par le Super Tucano.\n\n## Héritage\nProgramme charnière qui a transformé Embraer en constructeur militaire. A posé les fondations industrielles du succès du **Tucano (1983)**, du **Super Tucano (2003)** et du **KC-390 (2019)**. Sans le Xavante, pas d''industrie aéronautique brésilienne moderne.',
  description_en = E'## Genesis\nLicence contract signed in **1970** between Aermacchi (Italy) and Embraer (nascent Brazil, founded 1969) to produce the MB-326GB. First EMB-326 assembled at São José dos Campos on **3 August 1971**. Strategic contract for the emerging Brazilian aerospace industry — Embraer had previously only built light civilian aircraft.\n\n## Operational career\n**182 examples built** at São José dos Campos over 11 years. Advanced training and light attack for the FAB for over 30 years. Deployed in defence of the Amazon border against drug traffickers and smugglers. Final retirement in **2010**, replaced by the Super Tucano.\n\n## Legacy\nPivotal programme that transformed Embraer into a military manufacturer. Laid the industrial foundations for the success of the **Tucano (1983)**, **Super Tucano (2003)** and **KC-390 (2019)**. Without the Xavante, no modern Brazilian aerospace industry.'
WHERE name = 'Embraer EMB-326 Xavante';
