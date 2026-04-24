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
    'Mitsubishi X-2 Shinshin',
    'Mitsubishi X-2 Shinshin',
    'Mitsubishi X-2 Shinshin ATD-X (technology demonstrator)',
    'Mitsubishi X-2 Shinshin ATD-X (technology demonstrator)',
    'Démonstrateur technologique furtif japonais, base du futur F-X / Tempest GCAP',
    'Japanese stealth technology demonstrator, basis for the future F-X / Tempest GCAP',
    '/assets/airplanes/mitsubishi-x-2-shinshin.jpg',
    'Le Mitsubishi X-2 Shinshin (ATD-X — Advanced Technology Demonstrator-X) est un démonstrateur technologique japonais destiné à valider les concepts de furtivité, de moteurs à poussée vectorielle 3D et d''intégration avionique pour le futur chasseur F-X. Seul exemplaire construit, il a effectué son premier vol le 22 avril 2016 et a totalisé 34 vols avant retrait en 2018. Ses technologies alimentent désormais le programme trilatéral GCAP (Global Combat Air Programme) associant Japon, Royaume-Uni et Italie pour un chasseur de 6e génération attendu en 2035.',
    'The Mitsubishi X-2 Shinshin (ATD-X — Advanced Technology Demonstrator-X) is a Japanese technology demonstrator intended to validate stealth, 3D thrust-vectoring engines and avionics integration concepts for the future F-X fighter. The sole example built, it completed its first flight on 22 April 2016 and logged 34 flights before retirement in 2018. Its technologies now feed into the trilateral GCAP (Global Combat Air Programme) associating Japan, the United Kingdom and Italy for a 6th-generation fighter expected in 2035.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '2004-01-01',
    '2016-04-22',
    NULL,
    2459.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired',
    9700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi X-2 Shinshin'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.17, wingspan = 9.10, height = 4.51, wing_area = 34.84,
  empty_weight = 9700, mtow = 13000, service_ceiling = 15000, climb_rate = 303,
  combat_radius = NULL, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'IHI XF5-1 (démonstrateur)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 33.0, thrust_wet = 50.0,
  production_start = 2010, production_end = 2016, units_built = 1,
  operators_count = 0,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mitsubishi_X-2_Shinshin',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_X-2_Shinshin'
WHERE name = 'Mitsubishi X-2 Shinshin';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 400000000, unit_cost_year = 2016,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **ATD-X** : Advanced Technology Demonstrator-X, prototype unique\n- Budget programme : ~47 milliards JPY (400 M USD), 2004-2018\n- Validation : furtivité, poussée vectorielle 3D, avionique intégrée, Self-Repairing Flight Control System (SRFCS)\n- Pas de production, technologies transférées au programme F-X / GCAP Tempest',
  variants_en = E'- **ATD-X** : Advanced Technology Demonstrator-X, unique prototype\n- Programme budget: ~JPY 47 billion (USD 400M), 2004-2018\n- Validation: stealth, 3D thrust vectoring, integrated avionics, Self-Repairing Flight Control System (SRFCS)\n- No production, technologies transferred to F-X / GCAP Tempest programme'
WHERE name = 'Mitsubishi X-2 Shinshin';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nLancé par le **Technical Research and Development Institute (TRDI)** japonais en **2004** comme démonstrateur technologique pour préparer le programme F-3 de 5e génération. Nom officiel : **ATD-X** (Advanced Technology Demonstrator-X), baptisé Shinshin ("Esprit") lors de la présentation publique en janvier 2016. Premier vol le **22 avril 2016** à l''usine Mitsubishi de Komaki (pilote : Hideki Watanabe).\n\n## Carrière opérationnelle\n**34 vols d''essai** sur 3 ans. Aucun service opérationnel — c''est un démonstrateur uniquement. Retiré en **2018** après la fin de sa campagne d''essais. Validation réussie : signature radar réduite (forme facettes, matériaux absorbants), poussée vectorielle 3D par 3 ailerons mobiles indigènes, intégration avionique sur architecture nippone autonome.\n\n## Héritage\nBanque de données technologique pour le **programme F-X japonais** (successeur F-2), fusionné en **2022 dans le programme GCAP (Global Combat Air Programme)** associant le **Japon (Mitsubishi), le Royaume-Uni (BAE Systems) et l''Italie (Leonardo)** pour un chasseur de 6e génération attendu en **2035**. Le Shinshin a prouvé que le Japon pouvait concevoir un chasseur furtif sans transfert américain — levée majeure d''autonomie stratégique.',
  description_en = E'## Genesis\nLaunched by the Japanese **Technical Research and Development Institute (TRDI)** in **2004** as a technology demonstrator to prepare the 5th-generation F-3 programme. Official name: **ATD-X** (Advanced Technology Demonstrator-X), christened Shinshin ("Spirit") at the public presentation in January 2016. First flight on **22 April 2016** at the Mitsubishi Komaki factory (pilot: Hideki Watanabe).\n\n## Operational career\n**34 test flights** over 3 years. No operational service — it is solely a demonstrator. Retired in **2018** after completion of the test campaign. Successful validation: reduced radar signature (faceted shape, absorbing materials), 3D thrust vectoring by 3 indigenous movable paddles, avionics integration on an autonomous Japanese architecture.\n\n## Legacy\nTechnological database for the **Japanese F-X programme** (F-2 successor), merged in **2022 into the GCAP (Global Combat Air Programme)** associating **Japan (Mitsubishi), the United Kingdom (BAE Systems) and Italy (Leonardo)** for a 6th-generation fighter expected in **2035**. The Shinshin proved that Japan could design a stealth fighter without US transfer — a major strategic autonomy step.'
WHERE name = 'Mitsubishi X-2 Shinshin';
