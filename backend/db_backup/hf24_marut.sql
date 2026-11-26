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
    status_en
) VALUES (
    'HAL HF-24 Marut',
    'HAL HF-24 Marut',
    'HAL HF-24 Marut (Indian Air Force)',
    'HAL HF-24 Marut (Indian Air Force)',
    'Premier chasseur-bombardier supersonique de conception indienne',
    'First supersonic fighter-bomber of Indian design',
    '/assets/airplanes/hal-hf-24-marut.jpg',
    'Le HAL HF-24 Marut ("Esprit de la Tempête") est le premier avion de combat à réaction de conception indienne, développé par Hindustan Aeronautics Limited sous la direction de l''ingénieur allemand Kurt Tank (ex-Focke-Wulf). Mis en service en 1967 par l''Indian Air Force, il a été engagé lors de la guerre indo-pakistanaise de 1971 dans des missions d''appui au sol où il s''est distingué par sa robustesse. Ses performances supersoniques ont été limitées par l''absence d''un réacteur national à postcombustion digne de ses aptitudes aérodynamiques. Retiré en 1990.',
    'The HAL HF-24 Marut ("Spirit of the Storm") is the first jet combat aircraft of Indian design, developed by Hindustan Aeronautics Limited under the leadership of German engineer Kurt Tank (formerly of Focke-Wulf). Entered service in 1967 with the Indian Air Force, it was deployed during the 1971 Indo-Pakistani War in ground attack missions where it stood out for its ruggedness. Its supersonic performance was held back by the lack of a domestic afterburning engine worthy of its aerodynamic potential. Retired in 1990.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '1956-01-01',
    '1961-06-17',
    '1967-04-01',
    1112.0,
    400.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 15.87, wingspan = 9.00, height = 3.60, wing_area = 28.00,
  empty_weight = 6195, mtow = 10908, service_ceiling = 13716, climb_rate = 23,
  combat_radius = 400, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'HAL (Bristol Siddeley) Orpheus Mk 703', engine_count = 2,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 21.6, thrust_wet = NULL,
  production_start = 1964, production_end = 1977, units_built = 147,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_HF-24_Marut',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_HF-24_Marut'
WHERE name = 'HAL HF-24 Marut';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 2200000, unit_cost_year = 1967,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **HF-24 Mk1** : production monoplace de série (1967)\n- **HF-24 Mk1T** : version biplace d''entraînement (1970)\n- **HF-24 Mk2** : projet avec postcombustion Orpheus BOr.12 — annulé faute de financement britannique',
  variants_en = E'- **HF-24 Mk1** : main production single-seat variant (1967)\n- **HF-24 Mk1T** : two-seat trainer version (1970)\n- **HF-24 Mk2** : proposed variant with afterburning Orpheus BOr.12 — cancelled due to lack of UK funding'
WHERE name = 'HAL HF-24 Marut';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nAu milieu des années 1950, l''Indian Air Force demande un avion polyvalent capable de Mach 2, aussi à l''aise en interception qu''en attaque à basse altitude. **Hindustan Aircraft** n''a ni l''expérience ni l''équipe : son bureau d''études compte 54 personnes. Le gouvernement fait appel à **Kurt Tank**, père du Focke-Wulf Fw 190, qui sort d''Argentine où il a dessiné le chasseur Pulqui II. Il arrive à Bangalore en août 1956.\n\n## Conception\nTank dessine un biréacteur à aile en flèche, prévu pour deux **Orpheus** BOr.12 à postcombustion. Mais le Royaume-Uni cesse de financer ce moteur et l''Inde refuse de payer la suite : le Marut vole avec des Orpheus 703 sans postcombustion, bien moins puissants que prévu, qui le limitent tout juste à Mach 1. Il porte quatre canons **ADEN** de 30 mm, un panier escamotable de roquettes Matra et des bombes.\n\n## Essais\nAprès un planeur en bois à l''échelle 1, le prototype vole le 17 juin 1961 aux mains du wing commander Suranjan Das. La remotorisation reste l''obsession du programme : le banc d''essai à réacteur Brandner E-300, mené avec l''Égypte, est abandonné en 1969. L''IAF reçoit son premier Marut de série le 1er avril 1967.\n\n## Carrière opérationnelle\nTrois escadrons, les 10, 31 et 220, volent sur Marut. Pendant la **guerre indo-pakistanaise de 1971**, ceux des 10e et 220e escadrons effectuent plus de 300 sorties en deux semaines, surtout en attaque à basse altitude, dont l''appui des défenseurs de **Longewala** le 5 décembre. Trois sont abattus par la DCA et un autre est détruit au sol à Uttarlai par un F-104 ; trois pilotes reçoivent la Vir Chakra. Une victoire sur un F-86 le 7 décembre, revendiquée par l''Inde, est attribuée par le Pakistan à une panne moteur.\n\n## Place dans l''histoire\nProduit à 147 exemplaires dont 18 biplaces (145 selon d''autres sources), le Marut est remplacé par le MiG-23 et quitte le service en 1990 selon la plupart des sources. Premier chasseur à réaction de conception indienne, il a prouvé que l''Inde savait dessiner un avion de combat, et rappelé qu''il lui fallait d''abord un moteur.',
  description_en = E'## Genesis\nIn the mid-1950s the Indian Air Force asked for a multirole aircraft capable of Mach 2, equally at home intercepting at altitude and attacking at low level. **Hindustan Aircraft** had neither the experience nor the team: its design office numbered 54 people. The government turned to **Kurt Tank**, father of the Focke-Wulf Fw 190, fresh from Argentina where he had designed the Pulqui II fighter. He arrived in Bangalore in August 1956.\n\n## Design\nTank drew a twin-engined swept-wing aircraft, meant for two afterburning **Orpheus** BOr.12s. But Britain stopped funding that engine and India declined to pay for the rest: the Marut flew on non-afterburning Orpheus 703s, far less powerful than planned, which held it to barely Mach 1. It carried four 30 mm **ADEN** cannon, a retractable Matra rocket pack and bombs.\n\n## Testing\nAfter a full-scale wooden glider, the prototype flew on 17 June 1961 with Wing Commander Suranjan Das at the controls. Re-engining became the programme''s obsession: a test bed for the Brandner E-300 engine, developed with Egypt, was abandoned in 1969. The IAF received its first production Marut on 1 April 1967.\n\n## Operational career\nThree squadrons, Nos. 10, 31 and 220, flew the Marut. In the **1971 Indo-Pakistani War**, the Maruts of Nos. 10 and 220 Squadrons flew more than 300 sorties in two weeks, mostly low-level attack, including support for the defenders of **Longewala** on 5 December. Three were shot down by ground fire and another was destroyed on the ground at Uttarlai by an F-104; three pilots received the Vir Chakra. India claims an F-86 shot down on 7 December; Pakistan attributes the loss to an engine flameout.\n\n## Place in history\nBuilt to 147 examples including 18 two-seaters (145 according to other sources), the Marut was replaced by the MiG-23 and left service in 1990 according to most sources. The first Indian-designed jet fighter, it proved that India could design a combat aircraft, and showed that it first needed an engine.'
WHERE name = 'HAL HF-24 Marut';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HAL HF-24 Marut';
