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
    'IAI Lavi',
    'IAI Lavi',
    'IAI Lavi B-2 prototype (programme annulé 1987)',
    'IAI Lavi B-2 prototype (programme cancelled 1987)',
    'Chasseur multirôle avancé israélien de 4e génération, programme annulé en 1987',
    'Advanced Israeli 4th-generation multirole fighter, programme cancelled 1987',
    '/assets/airplanes/iai-lavi.jpg',
    'L''IAI Lavi ("Lion" en hébreu) était un programme israélien de chasseur multirôle monomoteur de 4e génération lancé en 1980, conçu comme successeur du Kfir et du F-4 Phantom. Canard delta, commande de vol électrique numérique, radar Elta EL/M-2035 et moteur PW1120 (dérivé F100) en faisaient un concurrent direct du F-16C de sa génération. Premier vol du prototype B-2 le 31 décembre 1986. Programme annulé le 30 août 1987 sous pression américaine (financement US de 1,3 milliard de dollars sur 5 ans contre abandon) : Washington craignait la concurrence export contre le F-16. L''héritage technologique du Lavi a profondément influencé le Chengdu J-10 chinois (partage technologique IAI-Chine dans les années 1990).',
    'The IAI Lavi ("Lion" in Hebrew) was an Israeli single-engine 4th-generation multirole fighter programme launched in 1980, designed as successor to the Kfir and F-4 Phantom. Canard delta, digital fly-by-wire flight control, Elta EL/M-2035 radar and PW1120 engine (F100 derivative) made it a direct competitor of the F-16C of its generation. First flight of the B-2 prototype on 31 December 1986. Programme cancelled on 30 August 1987 under American pressure (US funding of $1.3 billion over 5 years in exchange for cancellation): Washington feared export competition against the F-16. The Lavi''s technological legacy deeply influenced the Chinese Chengdu J-10 (IAI-China technology sharing in the 1990s).',
    (SELECT id FROM countries WHERE code = 'ISR'),
    '1980-02-01',
    '1986-12-31',
    NULL,
    1965.0,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Annulé',
    'Cancelled',
    7031.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM armement WHERE name = 'DEFA 553')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM armement WHERE name = 'Python 3')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM armement WHERE name = 'Mk 84'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM missions WHERE name = 'Interception'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.39, wingspan = 8.78, height = 4.78, wing_area = 33.00,
  empty_weight = 7031, mtow = 19277, service_ceiling = 15240, climb_rate = 254,
  combat_radius = 1850, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.5,
  engine_name = 'Pratt & Whitney PW1120 (dérivé F100)', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 59.2, thrust_wet = 91.2,
  production_start = 1986, production_end = 1987, units_built = 3,
  operators_count = 0,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/IAI_Lavi',
  wikipedia_en = 'https://en.wikipedia.org/wiki/IAI_Lavi'
WHERE name = 'IAI Lavi';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 20000000, unit_cost_year = 1987,
  manufacturer_page = 'https://www.iai.co.il/',
  variants    = E'- **Lavi B-1** : prototype aérodynamique (premier vol 31 décembre 1986)\n- **Lavi B-2** : prototype production (février 1987)\n- **Lavi TD** : démonstrateur technologique (jamais volé)\n- **Lavi B/C/D** : versions série planifiées, annulées 30 août 1987\n- Programme annulé après 2,1 milliards USD investis (deal avec Washington : 1,3 milliard USD contre abandon)',
  variants_en = E'- **Lavi B-1** : aerodynamic prototype (first flight 31 December 1986)\n- **Lavi B-2** : production prototype (February 1987)\n- **Lavi TD** : technology demonstrator (never flown)\n- **Lavi B/C/D** : planned production variants, cancelled 30 August 1987\n- Programme cancelled after USD 2.1 billion invested (deal with Washington: USD 1.3 billion against cancellation)'
WHERE name = 'IAI Lavi';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nProgramme lancé en **février 1980** pour doter Israël d''un chasseur multirôle de 4e génération 100 % indigène — successeur du Kfir et alternative nationale aux F-16 américains. Canard delta, commande de vol numérique quadruple redondance, radar Elta EL/M-2035 AESA (prototype), moteur Pratt & Whitney PW1120 (dérivé F100 adapté à la configuration Lavi). Premier vol du B-1 le **31 décembre 1986**, second prototype B-2 en février 1987.\n\n## Carrière opérationnelle\n**3 prototypes volés** uniquement. Aucun service opérationnel. Programme **annulé le 30 août 1987** par 12 voix contre 11 au Cabinet israélien sous pression américaine : Washington menaçait de réduire l''aide militaire à Israël (critique concurrence export du F-16). Deal final : USA paye **1,3 milliard USD sur 5 ans** en échange de l''annulation + 75 F-16C en livraison préférentielle.\n\n## Héritage\nBien que non-produit, le Lavi a profondément influencé la **filière aérospatiale israélienne et chinoise**. IAI a transféré les technologies Lavi (canard delta, commandes de vol numériques, avionique) à la Chine dans les années 1990 — le **Chengdu J-10** en est l''héritier direct reconnu. Les leçons du Lavi ont aussi influencé le programme F-35I Adir (suite EW israélienne autonome). Plus grande "victoire technologique" israélienne sans production.',
  description_en = E'## Genesis\nProgramme launched in **February 1980** to give Israel a 100 % indigenous 4th-generation multirole fighter — successor to the Kfir and national alternative to American F-16s. Canard delta, quadruplex digital flight controls, Elta EL/M-2035 AESA radar (prototype), Pratt & Whitney PW1120 engine (F100 derivative adapted to the Lavi configuration). First flight of the B-1 on **31 December 1986**, second prototype B-2 in February 1987.\n\n## Operational career\n**3 prototypes flown** only. No operational service. Programme **cancelled on 30 August 1987** by 12 votes to 11 in the Israeli Cabinet under US pressure: Washington threatened to cut military aid to Israel (criticism of F-16 export competition). Final deal: USA pays **USD 1.3 billion over 5 years** in exchange for cancellation + 75 F-16C in preferential delivery.\n\n## Legacy\nAlthough not produced, the Lavi deeply influenced both **Israeli and Chinese aerospace**. IAI transferred Lavi technologies (canard delta, digital flight controls, avionics) to China in the 1990s — the **Chengdu J-10** is recognised as its direct heir. Lavi lessons also influenced the F-35I Adir programme (autonomous Israeli EW suite). Israel''s greatest "technological victory" without production.'
WHERE name = 'IAI Lavi';
