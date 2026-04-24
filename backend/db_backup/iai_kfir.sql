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
    'IAI Kfir',
    'IAI Kfir',
    'IAI Kfir C2/C7/CE (Israeli Air Force)',
    'IAI Kfir C2/C7/CE (Israeli Air Force)',
    'Chasseur multirôle israélien dérivé du Mirage 5 avec réacteur J79',
    'Israeli multirole fighter derived from the Mirage 5 with J79 engine',
    '/assets/airplanes/iai-kfir.jpg',
    'L''IAI Kfir ("Lionceau" en hébreu) est un chasseur multirôle israélien dérivé en profondeur du Nesher/Mirage 5 par remplacement du réacteur SNECMA Atar par un General Electric J79 (construit sous licence, 35 % plus puissant) et par adjonction de petits canards fixes. Premier avion de combat supersonique entièrement développé et produit en Israël (212 exemplaires). Engagé au Liban (1982) où il a remporté plusieurs victoires contre des MiG syriens. Versions C2 (1974), C7 (1983, avionique améliorée) et CE (retrofit encore utilisé par le Sri Lanka et la Colombie). Loué aux États-Unis comme agresseur (F-21 Lion) à l''US Navy et Marines dans les années 1980.',
    'The IAI Kfir ("Lion Cub" in Hebrew) is an Israeli multirole fighter deeply derived from the Nesher/Mirage 5 by replacing the SNECMA Atar engine with a General Electric J79 (built under licence, 35 % more powerful) and adding small fixed canards. First supersonic combat aircraft entirely developed and produced in Israel (212 examples). Deployed in Lebanon (1982) where it scored several victories against Syrian MiGs. C2 (1974), C7 (1983, upgraded avionics) and CE (retrofit still used by Sri Lanka and Colombia) variants. Leased to the United States as an aggressor (F-21 Lion) by the US Navy and Marines in the 1980s.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1969-01-01',
    '1973-10-01',
    '1975-04-01',
    2440.0,
    2400.0,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired',
    7285.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM tech WHERE name = 'Radar EL/M-2032')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'Python 3')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'Mk 83')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'Shafrir 2')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM armement WHERE name = 'Delilah'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM wars WHERE name = 'Guerre du Liban')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.65, wingspan = 8.22, height = 4.55, wing_area = 34.80,
  empty_weight = 7285, mtow = 16500, service_ceiling = 17680, climb_rate = 230,
  combat_radius = 882, crew = 1, g_limit_pos = 7.5, g_limit_neg = -3.5,
  engine_name = 'IAI Bedek J79-JIE (licence General Electric J79)', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 52.9, thrust_wet = 79.4,
  production_start = 1975, production_end = 1989, units_built = 212,
  operators_count = 5,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/IAI_Kfir',
  wikipedia_en = 'https://en.wikipedia.org/wiki/IAI_Kfir'
WHERE name = 'IAI Kfir';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 4500000, unit_cost_year = 1975,
  manufacturer_page = 'https://www.iai.co.il/p/kfir',
  variants    = E'- **Kfir C1** : version initiale sans canards (27 appareils, 1975)\n- **Kfir C2** : canards fixes, grande performance manœuvre (185 appareils, 1976)\n- **Kfir C7** : avionique HOTAS, radar EL/M-2021, HUD Elbit, Python 3 (212 cellules converties, 1983)\n- **Kfir CE/COA** : upgrade export Colombie (2008), Equateur, Sri Lanka\n- **F-21 Lion** : 25 Kfir C1 loués à l''US Navy/Marines comme agresseurs (1985-1989)\n- Pays opérateurs : Israël, Colombie, Équateur, Sri Lanka, USA (prêt)',
  variants_en = E'- **Kfir C1** : initial variant without canards (27 aircraft, 1975)\n- **Kfir C2** : fixed canards, high manoeuvre performance (185 aircraft, 1976)\n- **Kfir C7** : HOTAS avionics, EL/M-2021 radar, Elbit HUD, Python 3 (212 converted airframes, 1983)\n- **Kfir CE/COA** : export upgrade Colombia (2008), Ecuador, Sri Lanka\n- **F-21 Lion** : 25 Kfir C1 leased to US Navy/Marines as aggressors (1985-1989)\n- Operator countries: Israel, Colombia, Ecuador, Sri Lanka, USA (loan)'
WHERE name = 'IAI Kfir';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme **Black Curtain** lancé en **1969** par IAI pour remotoriser le Nesher/Mirage 5 avec un **General Electric J79** (35 % plus puissant que l''Atar 9C) fourni légalement par les USA dans le cadre du deal Kennedy-Eshkol. Contournement de l''embargo français par la souveraineté américaine. Premier vol du Kfir C1 en **octobre 1973** en pleine guerre du Kippour.\n\n## Carrière opérationnelle\n**212 exemplaires produits** en 14 ans. Engagé lors de l''**opération Paix en Galilée (1982, guerre du Liban)** où il a remporté plusieurs victoires contre MiG-21 et MiG-23 syriens — sans perte en combat aérien. Retrait IAF en **1996**. **F-21 Lion** loué à l''US Navy/Marines de 1985 à 1989 comme avion agresseur, formant les pilotes américains aux tactiques soviétiques.\n\n## Héritage\nAncêtre direct du **IAI Lavi** (1986) puis du **Chengdu J-10** chinois (transfert technologique IAI-Chine 1990-1998 — le J-10 hérite de l''aérodynamique canard-delta israélienne). Encore en service en 2024 en Colombie (20 appareils), Sri Lanka (5) et Équateur (12) — plus de 50 ans de carrière opérationnelle.',
  description_en = E'## Genesis\n**Black Curtain** programme launched in **1969** by IAI to re-engine the Nesher/Mirage 5 with a **General Electric J79** (35 % more powerful than the Atar 9C) legally supplied by the USA under the Kennedy-Eshkol deal. Circumvention of the French embargo via US sovereignty. First flight of the Kfir C1 in **October 1973** in the midst of the Yom Kippur War.\n\n## Operational career\n**212 examples built** over 14 years. Deployed during **Operation Peace for Galilee (1982, Lebanon War)** where it scored several victories against Syrian MiG-21s and MiG-23s — without loss in air combat. IAF retirement in **1996**. **F-21 Lion** leased to the US Navy/Marines from 1985 to 1989 as an aggressor aircraft, training US pilots in Soviet tactics.\n\n## Legacy\nDirect ancestor of the **IAI Lavi** (1986) then the Chinese **Chengdu J-10** (IAI-China technology transfer 1990-1998 — the J-10 inherits Israeli canard-delta aerodynamics). Still in service in 2024 in Colombia (20 aircraft), Sri Lanka (5) and Ecuador (12) — over 50 years of operational career.'
WHERE name = 'IAI Kfir';
