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
    'Mirage 2000H Vajra',
    'Mirage 2000H Vajra',
    'Dassault Mirage 2000H/TH Vajra (Indian Air Force)',
    'Dassault Mirage 2000H/TH Vajra (Indian Air Force)',
    'Version indienne du Mirage 2000 pour l''Indian Air Force',
    'Indian variant of the Mirage 2000 for the Indian Air Force',
    '/assets/airplanes/mirage-2000h-vajra.jpg',
    'Le Mirage 2000H Vajra ("Foudre du ciel" en sanskrit) est la variante indienne du Mirage 2000 livrée entre 1985 et 1988 à l''Indian Air Force (59 appareils). Star de la campagne de Kargil en 1999 où il a frappé avec précision les positions pakistanaises retranchées dans l''Himalaya grâce aux bombes guidées laser Matra. Modernisé entre 2015 et 2021 au standard Mirage 2000I (MICA, Damocles, RDY-2), il constitue l''une des principales capacités de précision de l''IAF.',
    'The Mirage 2000H Vajra ("Thunderbolt of the sky" in Sanskrit) is the Indian variant of the Mirage 2000 delivered between 1985 and 1988 to the Indian Air Force (59 aircraft). Star of the 1999 Kargil campaign where it struck Pakistani positions entrenched in the Himalayas with precision using Matra laser-guided bombs. Upgraded between 2015 and 2021 to the Mirage 2000I standard (MICA, Damocles, RDY-2), it remains one of the IAF''s main precision-strike capabilities.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1982-01-01',
    '1984-10-25',
    '1985-06-29',
    2336.0,
    3335.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    7500.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM tech WHERE name = 'Radar RDM/RDI')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'DEFA 554')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'Matra Super 530D')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'MICA IR')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'MICA EM')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'AS-30L')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mirage 2000H Vajra'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.36, wingspan = 9.13, height = 5.20, wing_area = 41.00,
  empty_weight = 7500, mtow = 17000, service_ceiling = 17060, climb_rate = 285,
  combat_radius = 1550, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.6,
  engine_name = 'SNECMA M53-P2', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 64.33, thrust_wet = 95.12,
  production_start = 1985, production_end = 1988, units_built = 59,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_2000',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Dassault_Mirage_2000#Indian_variants'
WHERE name = 'Mirage 2000H Vajra';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 23000000, unit_cost_year = 1985,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/defense/mirage-2000/',
  variants    = E'- **Mirage 2000H** : monoplace livraison initiale (40 appareils, 1985-1988)\n- **Mirage 2000TH** : biplace d''entraînement (9 appareils)\n- **Mirage 2000I/TI** : modernisation 2015-2021 au standard -5 Mk2 (MICA IR/EM, Damocles, RDY-2, avionique HUD-NG)\n- Cellules 2 escadrons (No. 1 "Tigers" et No. 7 "Battleaxes") à Gwalior',
  variants_en = E'- **Mirage 2000H** : single-seat initial delivery (40 aircraft, 1985-1988)\n- **Mirage 2000TH** : two-seat trainer (9 aircraft)\n- **Mirage 2000I/TI** : 2015-2021 upgrade to -5 Mk2 standard (MICA IR/EM, Damocles, RDY-2, HUD-NG avionics)\n- 2 squadrons (No. 1 "Tigers" and No. 7 "Battleaxes") at Gwalior'
WHERE name = 'Mirage 2000H Vajra';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nContrat signé en **1982** après l''échec des négociations F-16 (Inde sanctionnée post-essais Pokhran-I 1974). 40 Mirage 2000H + 9 biplaces 2000TH livrés entre **juin 1985 et 1988**. Nom Vajra ("Foudre du ciel" en sanskrit) donné par la cérémonie d''adoption à Gwalior.\n\n## Carrière opérationnelle\n**Star de l''opération Safed Sagar** durant la **guerre de Kargil (mai-juillet 1999)** — frappes de précision à très haute altitude (>5 000 m) au-dessus de l''Himalaya contre les positions pakistanaises retranchées, grâce aux bombes guidées laser Matra BGL-1000 et au pod Atlis. Premier engagement opérationnel du Mirage 2000 en guerre. Engagé lors de l''**opération Bandar** (frappe de Balakot, 26 février 2019) contre un camp du Jaish-e-Mohammed. Upgrade Mirage 2000I/TI (2015-2021) prolonge la carrière jusqu''en 2040+.\n\n## Héritage\nPremier avion multirôle de 4e génération de l''IAF. Grande valeur symbolique — a démontré la validité de la chaîne franco-indienne avant Rafale (2020). Avec 59 appareils, Gwalior reste l''une des bases d''assaut nucléaires conventionnelles les plus redoutables d''Asie du Sud.',
  description_en = E'## Genesis\nContract signed in **1982** after the collapse of F-16 negotiations (India sanctioned after Pokhran-I 1974 tests). 40 Mirage 2000H + 9 two-seat 2000TH delivered between **June 1985 and 1988**. Vajra name ("Thunderbolt of the sky" in Sanskrit) given at the Gwalior adoption ceremony.\n\n## Operational career\n**Star of Operation Safed Sagar** during the **Kargil War (May-July 1999)** — precision strikes at very high altitude (>5,000 m) over the Himalayas against entrenched Pakistani positions, thanks to Matra BGL-1000 laser-guided bombs and the Atlis pod. First operational engagement of the Mirage 2000 in war. Deployed during **Operation Bandar** (Balakot strike, 26 February 2019) against a Jaish-e-Mohammed camp. Mirage 2000I/TI upgrade (2015-2021) extends career until 2040+.\n\n## Legacy\nFirst 4th-generation multirole aircraft of the IAF. Great symbolic value — demonstrated the validity of the Franco-Indian chain before Rafale (2020). With 59 aircraft, Gwalior remains one of the most formidable conventional/nuclear strike bases in South Asia.'
WHERE name = 'Mirage 2000H Vajra';
