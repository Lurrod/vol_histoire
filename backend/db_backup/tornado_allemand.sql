-- Insertion dans airplanes
INSERT INTO airplanes (
    name, complete_name, little_description, image_url, description, 
    country_id, date_concept, date_first_fly, date_operationel, 
    max_speed, max_range, id_manufacturer, id_generation, type, status, weight
) VALUES (
    'Panavia Tornado Allemand', 'Panavia Tornado IDS/ECR (Luftwaffe)', 'Avion d''attaque et de suppression des défenses aériennes de 4e génération', 
    'https://i.postimg.cc/bvX7CTZK/tornado-allemand.png', 
    'Le Panavia Tornado allemand est la version exploitée par la Luftwaffe et la Marineflieger, déclinée en variantes IDS (Interdictor/Strike) et ECR (Electronic Combat/Reconnaissance). L''Allemagne de l''Ouest, partenaire fondateur du programme trinational avec le Royaume-Uni et l''Italie, reçut 357 appareils à partir de 1981, en grande partie assemblés par MBB (devenu DASA puis Airbus). La version IDS fut conçue pour la pénétration à très basse altitude et la frappe en profondeur derrière les lignes du Pacte de Varsovie, utilisant le radar de suivi de terrain et les ailes à géométrie variable pour voler au ras du sol à grande vitesse. La version ECR, développée spécifiquement pour la Luftwaffe, constitue une plateforme unique de suppression des défenses aériennes ennemies (SEAD), équipée du système de détection de menaces ELS et du missile anti-radar AGM-88 HARM. Déployé au Kosovo en 1999, en Afghanistan et en Syrie contre Daech, le Tornado allemand assura également la mission de partage nucléaire de l''OTAN avec des bombes B61. Il est progressivement retiré du service et remplacé par l''Eurofighter Typhoon et le F-35A Lightning II.', 
    (SELECT id FROM countries WHERE code = 'DEU'), '1968-07-01', '1974-08-14', '1981-06-01', 
    2337.0, 3890.0, (SELECT id FROM manufacturer WHERE code = 'ADS'), 
    (SELECT id FROM generation WHERE generation = 4), (SELECT id FROM type WHERE name = 'Multirôle'), 
    'Actif', 13890.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Aile à géométrie variable')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Radar de suivi de terrain')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'GBU-24 Paveway III')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'B61')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM armement WHERE name = 'IRIS-T'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Panavia Tornado Allemand'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));