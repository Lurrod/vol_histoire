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
    'Mitsubishi F-1',
    'Mitsubishi F-1',
    'Mitsubishi F-1 (Japan Air Self-Defense Force)',
    'Mitsubishi F-1 (Japan Air Self-Defense Force)',
    'Premier avion de combat de conception japonaise depuis 1945, dérivé du T-2',
    'First Japanese-designed combat aircraft since 1945, derived from the T-2',
    '/assets/airplanes/mitsubishi-f1.jpg',
    'Le Mitsubishi F-1 est le premier chasseur-bombardier à réaction de conception japonaise depuis la Seconde Guerre mondiale, dérivé monoplace du T-2 avec le poste arrière converti en baie avionique et un système de navigation/attaque intégré Fujitsu. Spécialisé dans la frappe antinavire avec le missile ASM-1, il assurait la défense du littoral japonais contre une éventuelle flotte soviétique. 77 exemplaires produits entre 1977 et 1987. Retiré en 2006, remplacé par le F-2.',
    'The Mitsubishi F-1 is Japan''s first domestically designed jet fighter-bomber since World War II, a single-seat derivative of the T-2 with the rear seat converted into an avionics bay and a Fujitsu integrated navigation/attack system. Specialised in anti-ship strike with the ASM-1 missile, it provided coastal defence for Japan against a potential Soviet fleet. 77 examples built between 1977 and 1987. Retired in 2006, replaced by the F-2.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1972-01-01',
    '1975-06-03',
    '1977-09-16',
    1700.0,
    2870.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired',
    6358.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'ASM-1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 17.86, wingspan = 7.88, height = 4.39, wing_area = 21.17,
  empty_weight = 6358, mtow = 13700, service_ceiling = 15240, climb_rate = 178,
  combat_radius = 556, crew = 1, g_limit_pos = 7.33, g_limit_neg = -3.0,
  engine_name = 'Ishikawajima-Harima TF40-IHI-801A (licence Adour)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 22.8, thrust_wet = 32.5,
  production_start = 1977, production_end = 1987, units_built = 77,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mitsubishi_F-1',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_F-1'
WHERE name = 'Mitsubishi F-1';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 12000000, unit_cost_year = 1980,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **F-1** : version unique monoplace d''attaque antinavire\n- **F-1 Kai** : modernisation avionique années 1990\n- Évolution du T-2 biplace avec poste arrière transformé en baie avionique Fujitsu\n- 77 appareils produits pour 3 escadrons (3 Hikōtai à Tsuiki, 6 Hikōtai à Tsuiki, 8 Hikōtai à Misawa)',
  variants_en = E'- **F-1** : unique single-seat anti-ship attack version\n- **F-1 Kai** : 1990s avionics upgrade\n- Evolution of the two-seat T-2 with rear seat transformed into a Fujitsu avionics bay\n- 77 aircraft produced for 3 squadrons (3 Hikōtai at Tsuiki, 6 Hikōtai at Tsuiki, 8 Hikōtai at Misawa)'
WHERE name = 'Mitsubishi F-1';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme FS-T2-Kai lancé en **1972** pour doter la JASDF d''un chasseur-bombardier **de conception entièrement japonaise** remplaçant les F-86F Sabre. Le F-1 est la première cellule de combat conçue au Japon depuis la capitulation de 1945. Premier vol le **3 juin 1975**, mise en service le **16 septembre 1977**.\n\n## Carrière opérationnelle\n**77 exemplaires produits** sur 10 ans. Spécialisé dans la **défense antinavire** avec le missile national **ASM-1** (Mitsubishi, 50 km portée) puis **ASM-2** (100 km, IR guidance). Mission principale : interdire à une flotte soviétique d''approcher les côtes japonaises depuis Misawa (Pacifique Nord) et Tsuiki (mer du Japon).\n\n## Héritage\nValidation de la chaîne industrielle militaire japonaise d''après-guerre. A ouvert la voie au **F-2** (1995) qui en partage la philosophie antinavire. Retiré en **2006** après 29 ans de service, remplacé par le Mitsubishi F-2.',
  description_en = E'## Genesis\nFS-T2-Kai programme launched in **1972** to give the JASDF a **fully Japanese-designed** fighter-bomber replacing F-86F Sabres. The F-1 is the first combat airframe designed in Japan since the 1945 surrender. First flight on **3 June 1975**, service entry on **16 September 1977**.\n\n## Operational career\n**77 airframes built** over 10 years. Specialised in **anti-ship defence** with the domestic **ASM-1** missile (Mitsubishi, 50 km range) then **ASM-2** (100 km, IR guidance). Main mission: deny a Soviet fleet approach to the Japanese coast from Misawa (North Pacific) and Tsuiki (Sea of Japan).\n\n## Legacy\nValidation of the post-war Japanese military industrial chain. Paved the way for the **F-2** (1995) which shares its anti-ship philosophy. Retired in **2006** after 29 years of service, replaced by the Mitsubishi F-2.'
WHERE name = 'Mitsubishi F-1';
