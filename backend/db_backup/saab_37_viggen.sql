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
    'Saab 37 Viggen',
    'Saab 37 Viggen',
    'Saab 37 Viggen (Flygvapnet)',
    'Saab 37 Viggen (Swedish Air Force)',
    'Avion multirôle suédois à aile canard-delta et réacteur à inverseur de poussée',
    'Swedish multirole canard-delta aircraft with thrust reverser',
    '/assets/airplanes/saab-37-viggen.jpg',
    'Le Saab 37 Viggen ("Foudre") est un avion de combat multirôle suédois conçu pour remplacer les Saab 32 Lansen et Saab 35 Draken. Sa configuration canard-delta couplée à un réacteur Volvo RM8 doté d''un inverseur de poussée lui permet des décollages et atterrissages très courts sur routes civiles (doctrine Bas 90). Décliné en versions AJ (attaque), JA (chasse), SF/SH (reconnaissance) et SK (entraînement). Retiré du service en 2005, remplacé par le JAS 39 Gripen.',
    'The Saab 37 Viggen ("Thunderbolt") is a Swedish multirole combat aircraft designed to replace the Saab 32 Lansen and Saab 35 Draken. Its canard-delta configuration paired with a Volvo RM8 engine with thrust reverser allows very short take-offs and landings from civilian roads (Bas 90 doctrine). Delivered in AJ (attack), JA (fighter), SF/SH (reconnaissance) and SK (trainer) variants. Retired from service in 2005, replaced by the JAS 39 Gripen.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1961-01-01',
    '1967-02-08',
    '1971-06-21',
    2231.0,
    2000.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired',
    9500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM tech WHERE name = 'Réacteur Volvo RM8')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM tech WHERE name = 'Radar PS-37/A')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'Skyflash')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'M/71 120 kg')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'M/71 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'Bofors 135 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'Rb 04E')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'Rb 05A')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM armement WHERE name = 'Rb 15F'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 16.40, wingspan = 10.60, height = 5.90, wing_area = 46.00,
  empty_weight = 9500, mtow = 20000, service_ceiling = 18000, climb_rate = 203,
  combat_radius = 1000, crew = 1, g_limit_pos = 7.0, g_limit_neg = -3.0,
  engine_name = 'Volvo Flygmotor RM8B (dérivé P&W JT8D)', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 72.1, thrust_wet = 125.0,
  production_start = 1970, production_end = 1990, units_built = 329,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Saab_37_Viggen',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Saab_37_Viggen'
WHERE name = 'Saab 37 Viggen';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 15000000, unit_cost_year = 1980,
  manufacturer_page = 'https://www.saab.com/',
  variants    = E'- **AJ 37** : attaque (1971), version initiale, radar PS-37/A\n- **SF 37** : reconnaissance photographique (1977)\n- **SH 37** : reconnaissance maritime (1975)\n- **SK 37** : biplace d''entraînement (1972)\n- **JA 37** : chasse, radar PS-46/A, canon Oerlikon KCA 30 mm (1979)\n- **AJS 37** : modernisation attaque/reco (1993-1997)',
  variants_en = E'- **AJ 37** : attack (1971), initial variant, PS-37/A radar\n- **SF 37** : photo reconnaissance (1977)\n- **SH 37** : maritime reconnaissance (1975)\n- **SK 37** : two-seat trainer (1972)\n- **JA 37** : fighter, PS-46/A radar, Oerlikon KCA 30 mm gun (1979)\n- **AJS 37** : attack/reco upgrade (1993-1997)'
WHERE name = 'Saab 37 Viggen';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nLancé en **1961** comme système d''arme national intégré (Système 37), le Viggen ("Foudre") est conçu pour opérer depuis des tronçons d''autoroute dans le cadre de la doctrine **Bas 90** de dispersion anti-nucléaire. Sa configuration **canard-delta** est une première mondiale sur un avion de série, et son inverseur de poussée réduit la distance d''atterrissage à moins de 500 m. Premier vol le **8 février 1967**, mise en service AJ 37 en **juin 1971**.\n\n## Carrière opérationnelle\n**329 exemplaires produits** en 4 sous-types (AJ/SF/SH/SK/JA). Aucune exportation — l''Autriche, le Danemark, l''Inde et la Finlande avaient été prospectés mais les restrictions américaines sur le moteur RM8 (dérivé JT8D) ont bloqué les contrats. Jamais engagé en combat. Retiré en **2005**, remplacé par le Gripen.\n\n## Héritage\nPremier avion suédois à embarquer un **ordinateur numérique de bord** (CK37, conçu par Saab et Singer-Kearfott). Premier lien de données tactique opérationnel au monde (1972). Référence technique pour le Gripen.',
  description_en = E'## Genesis\nLaunched in **1961** as an integrated national weapon system (System 37), the Viggen ("Thunderbolt") is designed to operate from motorway stretches under the **Bas 90** anti-nuclear dispersal doctrine. Its **canard-delta** configuration is a world first on a production aircraft, and its thrust reverser cuts landing distance below 500 m. First flight on **8 February 1967**, AJ 37 service entry in **June 1971**.\n\n## Operational career\n**329 airframes built** in 4 sub-types (AJ/SF/SH/SK/JA). No exports — Austria, Denmark, India and Finland were approached but US restrictions on the RM8 engine (JT8D-derivative) blocked the contracts. Never engaged in combat. Retired in **2005**, replaced by the Gripen.\n\n## Legacy\nFirst Swedish aircraft to carry a **digital on-board computer** (CK37, designed by Saab and Singer-Kearfott). World''s first operational tactical data link (1972). Technical reference for the Gripen.'
WHERE name = 'Saab 37 Viggen';
