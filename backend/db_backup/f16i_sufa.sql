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
    'F-16I Sufa',
    'F-16I Sufa',
    'Lockheed Martin F-16I Sufa / Block 52+ (Israeli Air Force)',
    'Lockheed Martin F-16I Sufa / Block 52+ (Israeli Air Force)',
    'Version israélienne du F-16D Block 52+, optimisée pour la frappe longue portée',
    'Israeli version of the F-16D Block 52+, optimised for long-range strike',
    '/assets/airplanes/f16i-sufa.jpg',
    'Le F-16I Sufa ("Tempête" en hébreu) est la variante israélienne du F-16D Block 52+ livrée à partir de 2004 (101 appareils). Biplace dotée d''une suite avionique intégralement israélienne — ordinateur de mission Elbit, suite EW Elisra SPS-3000, liaison de données Elbit, HUD et casque DASH — ainsi que de réservoirs dorsaux Conformal Fuel Tanks augmentant l''autonomie à plus de 3700 km. Moteur Pratt & Whitney F100-PW-229 de 129 kN. Largement engagée contre les dépôts du Hezbollah et les convois iraniens en Syrie depuis 2013. Escadrons 201 ("The One"), 107 ("Knights of the Orange Tail") et 119 ("Bat").',
    'The F-16I Sufa ("Storm" in Hebrew) is the Israeli variant of the F-16D Block 52+ delivered from 2004 (101 aircraft). Two-seater with an entirely Israeli avionics suite — Elbit mission computer, Elisra SPS-3000 EW suite, Elbit data link, HUD and DASH helmet — plus Conformal Fuel Tanks boosting range beyond 3,700 km. Pratt & Whitney F100-PW-229 engine of 129 kN. Widely engaged against Hezbollah depots and Iranian convoys in Syria since 2013. 201st ("The One"), 107th ("Knights of the Orange Tail") and 119th ("Bat") squadrons.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1999-01-01',
    '2003-12-23',
    '2004-02-19',
    2120.0,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    9207.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-68')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'Derby')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'Popeye')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'Spice')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'Rampage')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM armement WHERE name = 'Delilah'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.04, wingspan = 9.96, height = 5.10, wing_area = 27.87,
  empty_weight = 9207, mtow = 21772, service_ceiling = 15240, climb_rate = 254,
  combat_radius = 1740, crew = 2, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Pratt & Whitney F100-PW-229', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 79.1, thrust_wet = 129.4,
  production_start = 2004, production_end = 2009, units_built = 101,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/General_Dynamics_F-16_Fighting_Falcon',
  wikipedia_en = 'https://en.wikipedia.org/wiki/General_Dynamics_F-16_Fighting_Falcon#F-16I'
WHERE name = 'F-16I Sufa';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 70000000, unit_cost_year = 2004,
  manufacturer_page = 'https://www.lockheedmartin.com/en-us/products/f-16.html',
  variants    = E'- **F-16I Sufa** : biplace F-16D Block 52+ avec réservoirs dorsaux CFT (Conformal Fuel Tanks) — 101 appareils\n- Différences ISE : ordinateur de mission Elbit, suite EW Elisra SPS-3000, liaison de données Elbit, HUD et casque DASH-IV, radar AN/APG-68(V)9, compatibilité missiles Rafael (Python 5, Derby, Spice)\n- Escadrons : 201 "The One" (Ramon), 107 "Knights of the Orange Tail" (Hatzerim), 119 "Bat" (Ramon), 253 "Negev" (Ramon), 105 "Scorpion" (Hatzerim)',
  variants_en = E'- **F-16I Sufa** : two-seat F-16D Block 52+ with dorsal CFT (Conformal Fuel Tanks) — 101 aircraft\n- ISE differences: Elbit mission computer, Elisra SPS-3000 EW suite, Elbit data link, HUD and DASH-IV helmet, AN/APG-68(V)9 radar, Rafael missile compatibility (Python 5, Derby, Spice)\n- Squadrons: 201 "The One" (Ramon), 107 "Knights of the Orange Tail" (Hatzerim), 119 "Bat" (Ramon), 253 "Negev" (Ramon), 105 "Scorpion" (Hatzerim)'
WHERE name = 'F-16I Sufa';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat **Peace Marble V** signé le **14 juillet 1999** : 102 F-16D Block 52+ commandés par Israël (4,5 milliards USD) en remplacement des F-4E Kurnass et complément des F-15I. Configuration uniquement biplace pour offrir une capacité air-sol profonde avec NFO (Naval Flight Officer). Livraison de février **2004** à décembre 2009. 1 appareil perdu en formation, **101 en service**.\n\n## Carrière opérationnelle\nColonne vertébrale de la frappe conventionnelle israélienne. Engagé lors de la **2e guerre du Liban (2006)** contre le Hezbollah (plus de 10 000 sorties en 34 jours). **Campagne Syrie** depuis 2013 — opération **Between the Wars** — avec des frappes quasi-hebdomadaires contre les dépôts Hezbollah, les convois iraniens et les sites de production de missiles de précision. Participation à l''**opération Orchard (2007)** contre le réacteur d''Al-Kibar avec les F-15I.\n\n## Héritage\nPlus grande flotte F-16 au monde après les USA, la Turquie et l''Égypte. Le Sufa reste en service jusqu''en **2035+**, après retrait progressif des F-16C/D Barak (Block 40/30), remplacé progressivement par le **F-35I Adir**.',
  description_en = E'## Genesis\n**Peace Marble V** contract signed on **14 July 1999**: 102 F-16D Block 52+ ordered by Israel (USD 4.5 billion) to replace the F-4E Kurnass and complement the F-15I. Exclusively two-seat configuration to offer deep air-to-ground capability with NFO (Naval Flight Officer). Delivery from February **2004** to December 2009. 1 aircraft lost in training, **101 in service**.\n\n## Operational career\nBackbone of Israeli conventional strike. Deployed during the **Second Lebanon War (2006)** against Hezbollah (over 10,000 sorties in 34 days). **Syria campaign** since 2013 — Operation **Between the Wars** — with near-weekly strikes against Hezbollah depots, Iranian convoys and precision-missile production sites. Participation in **Operation Orchard (2007)** against the Al-Kibar reactor with F-15I.\n\n## Legacy\nLargest F-16 fleet in the world after the USA, Turkey and Egypt. The Sufa remains in service until **2035+**, after gradual retirement of F-16C/D Barak (Block 40/30), progressively replaced by the **F-35I Adir**.'
WHERE name = 'F-16I Sufa';
