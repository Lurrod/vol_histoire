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
    'HAL AMCA',
    'HAL AMCA',
    'HAL AMCA Advanced Medium Combat Aircraft (Indian Air Force)',
    'HAL AMCA Advanced Medium Combat Aircraft (Indian Air Force)',
    'Chasseur furtif bimoteur indien de 5e génération en développement',
    'Indian twin-engine 5th-generation stealth fighter in development',
    '/assets/airplanes/hal-amca.jpg',
    'L''AMCA (Advanced Medium Combat Aircraft) est le programme de chasseur furtif de 5e génération de l''Inde, conduit par l''Aeronautical Development Agency (ADA) et HAL. Bimoteur (GE F414 Mk1, puis moteur indigène de 110 kN Mk2), soute interne à armement, radar AESA Uttam, supercruise et fusion de capteurs sont au programme. Premier prototype attendu en 2026, premier vol en 2028, service opérationnel vers 2035. 125 appareils prévus pour l''Indian Air Force.',
    'The AMCA (Advanced Medium Combat Aircraft) is India''s 5th-generation stealth fighter programme, conducted by the Aeronautical Development Agency (ADA) and HAL. Twin-engine (GE F414 Mk1, then a 110 kN indigenous engine for Mk2), internal weapons bay, Uttam AESA radar, supercruise and sensor fusion are on the agenda. First prototype expected in 2026, first flight in 2028, operational service around 2035. 125 aircraft planned for the Indian Air Force.',
    (SELECT id FROM countries WHERE code = 'IND'),
    '2010-01-01',
    NULL,
    NULL,
    2100.0,
    2800.0,
    (SELECT id FROM manufacturer WHERE code = 'HAL'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'Python 5')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'GBU-39 SDB')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'SCALP EG')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM armement WHERE name = 'Astra Mk1'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies')),
((SELECT id FROM airplanes WHERE name = 'HAL AMCA'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 17.60, wingspan = 11.08, height = 4.80, wing_area = 55.00,
  empty_weight = 12000, mtow = 25000, service_ceiling = 17500, climb_rate = 350,
  combat_radius = 1620, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.5,
  engine_name = 'General Electric F414-INS6 (Mk1) / Moteur indigène 110 kN (Mk2)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 58.0, thrust_wet = 98.0,
  production_start = NULL, production_end = NULL, units_built = 0,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/HAL_AMCA',
  wikipedia_en = 'https://en.wikipedia.org/wiki/HAL_AMCA'
WHERE name = 'HAL AMCA';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 180000000, unit_cost_year = 2030,
  manufacturer_page = 'https://hal-india.co.in/',
  variants    = E'- **AMCA Mk1** : version initiale, moteurs F414-INS6 (2× 98 kN)\n- **AMCA Mk2** : moteurs indigènes de 110 kN, super-croisière, EOTS indigène\n- Soute interne : 1500 kg (4 BVR + 2 PGM)\n- Pylônes externes : 4500 kg en mode non-furtif\n- 125 appareils prévus sur 7 escadrons',
  variants_en = E'- **AMCA Mk1** : initial variant, F414-INS6 engines (2× 98 kN)\n- **AMCA Mk2** : indigenous 110 kN engines, supercruise, indigenous EOTS\n- Internal bay : 1500 kg (4 BVR + 2 PGM)\n- External pylons : 4500 kg in non-stealth mode\n- 125 aircraft planned across 7 squadrons'
WHERE name = 'HAL AMCA';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nAu tournant des années 2010, l''Inde veut un chasseur furtif conçu chez elle, plus lourd que le **Tejas**. En avril 2010, l''Indian Air Force publie ses exigences et, en octobre, le ministère de la Défense finance une étude de faisabilité. L''**Aeronautical Development Agency** (ADA), bureau de conception rattaché à la DRDO, étudie neuf configurations entre 2013 et 2014 ; l''aviation accepte le dessin en 2016. Le retrait indien du chasseur FGFA mené avec la Russie laisse ensuite l''AMCA seul en lice. Le 7 mars 2024, le Comité du Cabinet pour la sécurité approuve le développement des prototypes, pour environ 15 000 crores de roupies (15 803 selon d''autres sources).\n\n## Conception\nMonoplace bimoteur d''environ 25 tonnes, l''AMCA associe des formes étudiées pour réduire la signature radar — entrées d''air sans séparateur à conduits en S, double dérive — et une soute interne d''environ 1 500 kg ; des points d''emport externes servent quand la discrétion passe au second plan. La version **Mk1** recevra deux **General Electric F414** produits en Inde par **HAL**. La **Mk2** attend un moteur de 120 kN que la DRDO doit développer avec **Safran** : le ministre Rajnath Singh a confirmé ce partenariat le 22 août 2025, pour un cycle d''une dizaine d''années.\n\n## Essais\nL''AMCA n''a pas encore volé. Le 27 mai 2025, le ministère adopte un nouveau modèle d''exécution : un partenaire industriel, public ou privé, construira les cinq prototypes sous l''autorité de conception de l''ADA. Trois consortiums restent en lice en 2026, menés par **Tata Advanced Systems**, **Larsen & Toubro** et **Bharat Forge** ; HAL, longtemps présentée comme maître d''œuvre, aurait été écartée selon la presse, ce qu''elle conteste. Les offres ont été ouvertes au début de novembre 2026. Le contrat imposera un premier vol dans les 30 mois suivant sa signature, et le secrétaire à la Défense vise septembre 2028. Un centre d''intégration et d''essais en vol est en construction près de Puttaparthi, dans l''Andhra Pradesh. L''Indian Air Force prévoit sept escadrons, soit environ 125 appareils, avec une mise en service espérée vers 2034-2035.\n\n## Place dans l''histoire\nSi le calendrier tient, l''Inde rejoindra le cercle restreint des pays qui ont conçu leur propre chasseur furtif. Le programme est aussi un pari industriel : il rompt avec l''habitude de confier les avions de combat indiens à HAL.',
  description_en = E'## Genesis\nAround 2010 India set out to design its own stealth fighter, heavier than the **Tejas**. In April 2010 the Indian Air Force issued its requirements, and in October the Defence Ministry funded a feasibility study. The **Aeronautical Development Agency** (ADA), the DRDO design bureau, studied nine configurations in 2013-2014; the air force accepted the design in 2016. India''s withdrawal from the FGFA fighter project with Russia later left the AMCA as the only option. On 7 March 2024 the Cabinet Committee on Security approved prototype development, at a cost of around 15,000 crore rupees (15,803 crore according to other sources).\n\n## Design\nA single-seat, twin-engined fighter of about 25 tonnes, the AMCA combines shapes meant to reduce radar signature (diverterless intakes with S-shaped ducts, twin tails) with an internal bay of about 1,500 kg; external hardpoints are for missions where stealth matters less. The **Mk1** will use two **General Electric F414** engines built in India by **HAL**. The **Mk2** awaits a 120 kN engine to be developed by DRDO with **Safran**: Defence Minister Rajnath Singh confirmed the partnership on 22 August 2025, for a development cycle of about ten years.\n\n## Testing\nThe AMCA has not flown yet. On 27 May 2025 the ministry adopted a new execution model: an industrial partner, public or private, will build the five prototypes under ADA''s design authority. Three consortia remained in contention in 2026, led by **Tata Advanced Systems**, **Larsen & Toubro** and **Bharat Forge**; HAL, long presented as prime contractor, was reportedly eliminated, which it disputes. Bids were opened in early November 2026. The contract will require a first flight within 30 months of signature, and the Defence Secretary is aiming for September 2028. An integration and flight test centre is being built near Puttaparthi, in Andhra Pradesh. The Indian Air Force plans seven squadrons, about 125 aircraft, with service entry hoped for around 2034-2035.\n\n## Place in history\nIf the schedule holds, India will join the small club of countries that have designed their own stealth fighter. The programme is also an industrial gamble, breaking with the habit of entrusting Indian combat aircraft to HAL.'
WHERE name = 'HAL AMCA';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'HAL AMCA';
