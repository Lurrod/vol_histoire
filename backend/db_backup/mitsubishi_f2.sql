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
    'Mitsubishi F-2',
    'Mitsubishi F-2',
    'Mitsubishi F-2A/B (Japan Air Self-Defense Force)',
    'Mitsubishi F-2A/B (Japan Air Self-Defense Force)',
    'Chasseur multirôle japonais dérivé du F-16, optimisé pour l''attaque antinavire',
    'Japanese multirole fighter derived from the F-16, optimised for anti-ship attack',
    '/assets/airplanes/mitsubishi-f2.jpg',
    'Le Mitsubishi F-2 est un chasseur multirôle de 4e génération développé conjointement par Mitsubishi et Lockheed Martin comme dérivé agrandi du F-16. Il adopte une aile composite élargie (25 %), un nez plus large pour le radar japonais J/APG-1 à antenne active (premier AESA aéroporté mondial en série), un train d''atterrissage renforcé et des structures composites co-cured (première application opérationnelle). Optimisé pour l''attaque antinavire avec jusqu''à 4 missiles ASM-2, il remplace le F-1. 94 appareils produits de 2000 à 2011. Modernisation progressive avec liaison de données tactique et intégration JDAM.',
    'The Mitsubishi F-2 is a 4th-generation multirole fighter jointly developed by Mitsubishi and Lockheed Martin as an enlarged derivative of the F-16. It features a larger composite wing (25 % bigger), a wider nose for the Japanese J/APG-1 active-array radar (world''s first operational airborne AESA), reinforced landing gear and co-cured composite structures (first operational application). Optimised for anti-ship attack with up to 4 ASM-2 missiles, it replaces the F-1. 94 aircraft produced from 2000 to 2011. Progressive upgrade with tactical data link and JDAM integration.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1987-01-01',
    '1995-10-07',
    '2000-09-25',
    2124.0,
    4000.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    9527.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM tech WHERE name = 'Radar J/APG-1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'AAM-3')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'AAM-4')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'ASM-1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'ASM-2')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'JDAM')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM armement WHERE name = 'ASM-3'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), (SELECT id FROM missions WHERE name = 'Interception'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.52, wingspan = 11.13, height = 4.96, wing_area = 34.84,
  empty_weight = 9527, mtow = 22100, service_ceiling = 18000, climb_rate = 229,
  combat_radius = 833, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'IHI F110-IHI-129 (licence General Electric F110)', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 75.6, thrust_wet = 131.6,
  production_start = 1995, production_end = 2011, units_built = 94,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mitsubishi_F-2',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_F-2'
WHERE name = 'Mitsubishi F-2';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 115000000, unit_cost_year = 1995,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **F-2A** : monoplace de production (62 appareils)\n- **F-2B** : biplace d''entraînement (32 appareils)\n- Cellule agrandie de 25 % par rapport au F-16 avec nez élargi pour radar J/APG-1 AESA (premier radar AESA aéroporté opérationnel mondial)\n- Modernisation 2014 : pods Link 16, JDAM, JASSM-ER, mise à niveau radar J/APG-2\n- Remplacement prévu par le F-X (GCAP) d''ici 2035',
  variants_en = E'- **F-2A** : production single-seat (62 aircraft)\n- **F-2B** : two-seat trainer (32 aircraft)\n- Airframe enlarged 25 % over the F-16 with widened nose for J/APG-1 AESA radar (world''s first operational airborne AESA radar)\n- 2014 upgrade: Link 16 pods, JDAM, JASSM-ER, J/APG-2 radar upgrade\n- Replacement planned by F-X (GCAP) by 2035'
WHERE name = 'Mitsubishi F-2';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme **FS-X** lancé en **1987** pour remplacer le Mitsubishi F-1. D''abord envisagé comme cellule nationale, le programme devient un développement conjoint **Mitsubishi + Lockheed Martin** en **1988** sous pression américaine (accord de partage de développement 60/40 japonais/américain). Dérivé du F-16 Agile Falcon avec une cellule élargie de 25 %, un nouveau nez, un radar AESA J/APG-1 indigène et une structure composite co-cured. Premier vol le **7 octobre 1995**, mise en service en **septembre 2000**.\n\n## Carrière opérationnelle\n**94 appareils produits** entre 2000 et 2011 (62 F-2A + 32 F-2B). **Premier chasseur de série avec radar AESA au monde**. Spécialisé dans l''attaque antinavire avec 4 missiles ASM-2 sur pylônes ventraux. Déployé à Misawa (3° Hikōtai), Tsuiki (6° Hikōtai) et Matsushima. 18 F-2 perdus lors du **tsunami de Tōhoku (11 mars 2011)**, 13 reconstruits par Mitsubishi.\n\n## Héritage\nVitrine technologique de l''industrie aéronautique japonaise — radar AESA, structure composite, système de tir antinavire tout-temps. Remplacement prévu dès **2035** par le **F-X (GCAP)**, programme trilatéral Japon + UK + Italie. Le F-2 restera en service jusqu''en 2040+.',
  description_en = E'## Genesis\n**FS-X** programme launched in **1987** to replace the Mitsubishi F-1. Initially considered a national airframe, the programme becomes a joint **Mitsubishi + Lockheed Martin** development in **1988** under US pressure (60/40 Japanese/American development share agreement). Derived from the F-16 Agile Falcon with a 25 % enlarged airframe, new nose, indigenous AESA J/APG-1 radar and co-cured composite structure. First flight on **7 October 1995**, service entry in **September 2000**.\n\n## Operational career\n**94 aircraft produced** between 2000 and 2011 (62 F-2A + 32 F-2B). **World''s first production fighter with AESA radar**. Specialised in anti-ship attack with 4 ASM-2 missiles on ventral pylons. Deployed at Misawa (3° Hikōtai), Tsuiki (6° Hikōtai) and Matsushima. 18 F-2 lost during the **Tōhoku tsunami (11 March 2011)**, 13 rebuilt by Mitsubishi.\n\n## Legacy\nTechnological showcase of the Japanese aerospace industry — AESA radar, composite structure, all-weather anti-ship fire-control system. Replacement planned from **2035** by the **F-X (GCAP)**, a trilateral Japan + UK + Italy programme. The F-2 will remain in service until 2040+.'
WHERE name = 'Mitsubishi F-2';
