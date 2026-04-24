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
    'Su-30MKI',
    'Su-30MKI',
    'Sukhoi Su-30MKI Flanker-H (Indian Air Force)',
    'Sukhoi Su-30MKI Flanker-H (Indian Air Force)',
    'Chasseur multirôle biplace super-maniable russo-indien à poussée vectorielle',
    'Indo-Russian super-maneuverable two-seat multirole fighter with thrust vectoring',
    '/assets/airplanes/su-30-mki.jpg',
    'Le Su-30MKI ("Modernizirovanniy Kommercheskiy Indiski") est une version profondément modernisée du Sukhoi Su-30 conçue spécifiquement pour l''Indian Air Force avec des apports français (avionique Thales), israéliens (EW Elta, radar LITENING), russes (AL-31FP à poussée vectorielle 2D, N011M Bars) et indiens (intégration HAL). Produit sous licence par HAL à Nashik. Colonne vertébrale de l''IAF avec plus de 270 appareils en service depuis 2002, capable d''emporter le missile supersonique BrahMos-A.',
    'The Su-30MKI ("Modernizirovanniy Kommercheskiy Indiski") is a deeply modernised version of the Sukhoi Su-30 designed specifically for the Indian Air Force with contributions from France (Thales avionics), Israel (Elta EW, LITENING radar), Russia (AL-31FP with 2D thrust vectoring, N011M Bars) and India (HAL integration). Produced under licence by HAL at Nashik. Backbone of the IAF with over 270 aircraft in service since 2002, capable of carrying the supersonic BrahMos-A missile.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1996-01-01',
    '2000-11-01',
    '2002-09-27',
    2120.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    18400.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Moteurs à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Réacteur AL-31F')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Radar N011M Bars')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'Kh-29L')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'Kh-31A')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'KAB-500L')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'KAB-1500L')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'FAB-500')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'Astra Mk1')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM armement WHERE name = 'BrahMos-A'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Su-30MKI'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 21.94, wingspan = 14.70, height = 6.35, wing_area = 62.00,
  empty_weight = 18400, mtow = 38800, service_ceiling = 17300, climb_rate = 305,
  combat_radius = 1500, crew = 2, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'AL-31FP à poussée vectorielle', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 75.0, thrust_wet = 122.58,
  production_start = 1997, production_end = 2020, units_built = 272,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Sukhoi_Su-30MKI',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Sukhoi_Su-30MKI'
WHERE name = 'Su-30MKI';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 63000000, unit_cost_year = 2010,
  manufacturer_page = 'https://www.sukhoi.org/',
  variants    = E'- **Su-30MKI** : version initiale, livrée par Sukhoi (18 appareils)\n- **Su-30MKI produit par HAL** : 254 appareils construits sous licence à Nashik\n- **Super Sukhoi** : upgrade en cours avec radar Virupaksha AESA, BrahMos-NG, Meteor, GaN\n- Avionique Thales (HUD), EW Elta (EL/L-8222), MFD israéliens',
  variants_en = E'- **Su-30MKI** : initial variant, delivered by Sukhoi (18 aircraft)\n- **Su-30MKI built by HAL** : 254 aircraft built under licence at Nashik\n- **Super Sukhoi** : ongoing upgrade with Virupaksha AESA radar, BrahMos-NG, Meteor, GaN\n- Thales avionics (HUD), Elta EW (EL/L-8222), Israeli MFDs'
WHERE name = 'Su-30MKI';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat signé le **30 novembre 1996** entre l''Inde et la Russie pour 50 appareils (8 milliards USD incluant transfert de technologie et production locale). Développé spécifiquement pour l''IAF avec contributions tri-nationales : **russe** (cellule, moteurs AL-31FP à poussée vectorielle, radar N011M Bars PESA), **française** (avionique Thales, HUD, MFD Sextant), **israélienne** (suite EW Elta, LITENING pod) et **indienne** (intégration HAL, cryptographie). Premier vol du MKI le **1 novembre 2000**, livraison premier escadron en **2002**.\n\n## Carrière opérationnelle\n**272 appareils** en service fin 2024, colonne vertébrale de l''IAF (15 escadrons). Premier vol opérationnel du missile supersonique BrahMos-A en **2019** (intégration air-sol unique au monde). Engagé en exercices OTAN (Cope India, Red Flag) où le MKI a démontré sa supériorité contre F-15, F-16 et Eurofighter.\n\n## Héritage\nPlateforme multirôle la plus polyvalente au monde — super-maniabilité (Cobra Pugachev, Kulbit) + BVR + frappe stratégique + antinavire. Mise à niveau **Super Sukhoi** en cours (2024-2030) pour prolonger la carrière jusqu''en 2050 avec radar AESA Virupaksha indigène.',
  description_en = E'## Genesis\nContract signed on **30 November 1996** between India and Russia for 50 aircraft (USD 8 billion including technology transfer and local production). Specifically developed for the IAF with tri-national contributions: **Russian** (airframe, AL-31FP thrust-vectoring engines, N011M Bars PESA radar), **French** (Thales avionics, HUD, Sextant MFD), **Israeli** (Elta EW suite, LITENING pod) and **Indian** (HAL integration, cryptography). First flight of MKI on **1 November 2000**, first squadron delivery in **2002**.\n\n## Operational career\n**272 aircraft** in service end-2024, backbone of the IAF (15 squadrons). First operational flight of the BrahMos-A supersonic missile in **2019** (unique air-to-surface integration worldwide). Deployed in NATO exercises (Cope India, Red Flag) where the MKI demonstrated superiority against F-15, F-16 and Eurofighter.\n\n## Legacy\nMost versatile multirole platform in the world — supermaneuverability (Pugachev Cobra, Kulbit) + BVR + strategic strike + anti-ship. **Super Sukhoi** upgrade in progress (2024-2030) to extend career until 2050 with indigenous Virupaksha AESA radar.'
WHERE name = 'Su-30MKI';
