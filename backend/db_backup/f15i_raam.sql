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
    'F-15I Ra''am',
    'F-15I Ra''am',
    'Boeing F-15I Ra''am (Israeli Air Force)',
    'Boeing F-15I Ra''am (Israeli Air Force)',
    'Version israélienne de frappe stratégique longue portée du F-15E Strike Eagle',
    'Israeli long-range strategic strike version of the F-15E Strike Eagle',
    '/assets/airplanes/f15i-raam.jpg',
    'Le F-15I Ra''am ("Tonnerre" en hébreu) est la version israélienne du F-15E Strike Eagle livrée entre 1998 et 1999 (25 appareils). Commandé après la Guerre du Golfe et les tirs Scud irakiens de 1991, le Ra''am est conçu pour la frappe stratégique à très longue portée (Iran) avec une suite avionique israélienne spécifique (radar AN/APG-70I amélioré par Elta, suite EW autonome, liaisons israéliennes, compatibilité missiles Popeye et Rampage). Escadron 69 ("Hammers") à la base de Hatzerim. Rôle clé dans l''opération Orchard (bombardement du réacteur syrien d''Al-Kibar en 2007) et contre les dépôts iraniens en Syrie.',
    'The F-15I Ra''am ("Thunder" in Hebrew) is the Israeli version of the F-15E Strike Eagle delivered between 1998 and 1999 (25 aircraft). Ordered after the Gulf War and the 1991 Iraqi Scud strikes, the Ra''am is designed for very long-range strategic strike (Iran) with an Israeli-specific avionics suite (AN/APG-70I radar upgraded by Elta, autonomous EW suite, Israeli data links, Popeye and Rampage missile compatibility). 69th Squadron ("Hammers") at Hatzerim. Key role in Operation Orchard (bombing of the Syrian Al-Kibar reactor in 2007) and against Iranian depots in Syria.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1993-01-01',
    '1997-09-12',
    '1998-01-19',
    2655.0,
    4445.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    14300.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM tech WHERE name = 'Radar AN/APG-63')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'Popeye')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'Spice')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'Mk 84')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'Rampage')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM armement WHERE name = 'Popeye Turbo'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 19.43, wingspan = 13.05, height = 5.63, wing_area = 56.50,
  empty_weight = 14300, mtow = 36741, service_ceiling = 18288, climb_rate = 255,
  combat_radius = 1967, crew = 2, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Pratt & Whitney F100-PW-229', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 79.6, thrust_wet = 129.4,
  production_start = 1998, production_end = 1999, units_built = 25,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Boeing_F-15E_Strike_Eagle',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Boeing_F-15E_Strike_Eagle#F-15I_Ra''am'
WHERE name = 'F-15I Ra''am';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 94000000, unit_cost_year = 1998,
  manufacturer_page = 'https://www.boeing.com/defense/f-15/',
  variants    = E'- **F-15I Ra''am** : version israélienne du F-15E Strike Eagle (25 appareils)\n- Différences ISE (Israel-Specific Enhancement) : suite EW israélienne autonome (Elisra SPS-2110), radar AN/APG-70I upgradé par Elta, IRST Tamam, liaisons Mike 4, cryptographie indépendante\n- Compatibilité unique : missiles Popeye AGM-142 Have Nap, Popeye Turbo (portée 1500 km), Rampage, Rocks\n- Escadron 69 "Hammers" à la base de Hatzerim (unique escadron Ra''am)',
  variants_en = E'- **F-15I Ra''am** : Israeli version of the F-15E Strike Eagle (25 aircraft)\n- ISE (Israel-Specific Enhancement) differences: autonomous Israeli EW suite (Elisra SPS-2110), AN/APG-70I radar upgraded by Elta, Tamam IRST, Mike 4 data links, independent cryptography\n- Unique compatibility: Popeye AGM-142 Have Nap missiles, Popeye Turbo (1,500 km range), Rampage, Rocks\n- 69th "Hammers" squadron at Hatzerim base (unique Ra''am squadron)'
WHERE name = 'F-15I Ra''am';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat signé le **27 janvier 1994** : 25 F-15I Ra''am ("Tonnerre") commandés par Israël après les tirs **Scud irakiens** de 1991 sur Tel-Aviv, démontrant le besoin d''une capacité de frappe stratégique longue portée (1967 km combat radius + ravitaillement en vol). Livraison de janvier **1998** à juillet 1999. Coût unitaire : **94 millions USD**.\n\n## Carrière opérationnelle\n**Star de l''opération Orchard (6 septembre 2007)** — bombardement du réacteur nucléaire syrien d''**Al-Kibar** dans le désert de Deir ez-Zor par 4 F-15I et 4 F-16I (frappe totalement furtive, suite EW Elta ayant désactivé les radars S-300 syriens). Engagé régulièrement contre les dépôts iraniens en Syrie depuis 2013 (**Opération Between the Wars**). Frappes profondes hypothétiques contre les installations nucléaires iraniennes (Natanz, Fordow) — cœur de la dissuasion stratégique israélienne.\n\n## Héritage\nPremier F-15 avec suite EW **non-américaine** autorisée par Washington. Modèle pour les F-15EX, F-15SA (Arabie saoudite), F-15QA (Qatar), F-15SG (Singapour). Service prévu jusqu''en **2045+** avec modernisations successives.',
  description_en = E'## Genesis\nContract signed on **27 January 1994**: 25 F-15I Ra''am ("Thunder") ordered by Israel after the Iraqi **Scud strikes** of 1991 on Tel Aviv, demonstrating the need for long-range strategic strike capability (1,967 km combat radius + in-flight refuelling). Delivery from January **1998** to July 1999. Unit cost: **USD 94 million**.\n\n## Operational career\n**Star of Operation Orchard (6 September 2007)** — bombing of the Syrian nuclear reactor at **Al-Kibar** in the Deir ez-Zor desert by 4 F-15I and 4 F-16I (fully stealthy strike, Elta EW suite having deactivated Syrian S-300 radars). Regularly engaged against Iranian depots in Syria since 2013 (**Operation Between the Wars**). Hypothetical deep strikes against Iranian nuclear facilities (Natanz, Fordow) — core of Israeli strategic deterrence.\n\n## Legacy\nFirst F-15 with **non-American** EW suite authorised by Washington. Model for the F-15EX, F-15SA (Saudi Arabia), F-15QA (Qatar), F-15SG (Singapore). Service planned until **2045+** with successive upgrades.'
WHERE name = 'F-15I Ra''am';
