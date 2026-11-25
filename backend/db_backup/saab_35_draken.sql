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
    'Saab 35 Draken',
    'Saab 35 Draken',
    'Saab 35 Draken (Flygvapnet)',
    'Saab 35 Draken (Swedish Air Force)',
    'Intercepteur supersonique suédois à configuration double delta',
    'Swedish supersonic interceptor with double-delta wing configuration',
    '/assets/airplanes/saab-35-draken.jpg',
    'Le Saab 35 Draken est un chasseur intercepteur monoplace conçu par Saab pour la Flygvapnet (force aérienne suédoise). Premier avion de combat occidental à franchir Mach 2 en production, il se distingue par sa configuration aérodynamique "double delta" unique qui combine performances supersoniques et capacité de décollage court depuis des routes civiles (doctrine Bas 90). Propulsé par un Rolls-Royce Avon construit sous licence par Volvo, il atteint 2125 km/h. Mis en service en 1960, retiré du service suédois en 1999 (jusqu''en 2005 en Autriche).',
    'The Saab 35 Draken is a single-seat interceptor designed by Saab for the Flygvapnet (Swedish Air Force). The first Western combat aircraft to exceed Mach 2 in production, it is distinguished by its unique "double-delta" aerodynamic configuration combining supersonic performance with short take-off capability from civilian roads (Bas 90 doctrine). Powered by a Rolls-Royce Avon built under licence by Volvo, it reaches 2125 km/h. Entered service in 1960, retired from Swedish service in 1999 (until 2005 in Austria).',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1949-01-01',
    '1955-10-25',
    '1960-03-08',
    2125.0,
    3250.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Configuration aérodynamique en double delta')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Radar R21G/M1')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'Bofors 135 mm')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — fiche technique étendue / motorisation / service
UPDATE airplanes SET
  length = 15.35, wingspan = 9.42, height = 3.89, wing_area = 49.20,
  empty_weight = 7425, mtow = 16000, service_ceiling = 20000, climb_rate = 175,
  combat_radius = 720, crew = 1, g_limit_pos = 9.0, g_limit_neg = -4.0,
  engine_name = 'Volvo Flygmotor RM6C (licence Rolls-Royce Avon 300)', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 56.9, thrust_wet = 78.4,
  production_start = 1955, production_end = 1974, units_built = 651,
  operators_count = 4,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Saab_35_Draken',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Saab_35_Draken'
WHERE name = 'Saab 35 Draken';

-- [auto:006] enrichment block — production, coût, variantes
UPDATE airplanes SET
  unit_cost_usd = 6000000, unit_cost_year = 1960,
  manufacturer_page = 'https://www.saab.com/',
  variants    = E'- **J 35A/B** : versions initiales (1960-1962), radar PS-02\n- **J 35D** : moteur RM6C plus puissant, radar PS-03 (1963)\n- **J 35F** : variante principale, missile Falcon Rb 27/28 (1965)\n- **J 35J** : modernisation de 54 J 35F (1987-1991)\n- **Saab 35XD/MK 50** : versions export Danemark, Finlande\n- **RF-35** : reconnaissance photographique\n- **SK 35C** : biplace d''entraînement',
  variants_en = E'- **J 35A/B** : initial variants (1960-1962), PS-02 radar\n- **J 35D** : more powerful RM6C engine, PS-03 radar (1963)\n- **J 35F** : main variant, Falcon Rb 27/28 missile (1965)\n- **J 35J** : upgrade of 54 J 35F aircraft (1987-1991)\n- **Saab 35XD/MK 50** : export versions Denmark, Finland\n- **RF-35** : photo reconnaissance\n- **SK 35C** : two-seat trainer'
WHERE name = 'Saab 35 Draken';

-- [auto:007] enrichment block — description narrative
UPDATE airplanes SET
  description = E'## Genèse\nEn septembre 1949, l''armée de l''air suédoise demande un intercepteur supersonique capable d''arrêter les bombardiers venus de l''Est. L''équipe de **Saab** que dirige l''ingénieur **Erik Bratt** imagine une formule inédite, le **double delta** : une aile très effilée près du fuselage, plus ouverte au-delà. Pour l''éprouver, un petit appareil à l''échelle réduite, le Saab 210 « Lilldraken », vole dès le 21 janvier 1952.\n\n## Conception\nLa forme réunit traînée faible à grande vitesse, volume pour le carburant et bonnes qualités à basse vitesse. Le réacteur est un **Rolls-Royce Avon** construit sous licence par Volvo. Surtout, le Draken est pensé pour la guerre suédoise : décoller de routes renforcées et être ravitaillé et réarmé en dix minutes au plus par des appelés, au sein du système de bases dispersées **Bas 60**.\n\n## Essais\nLe premier prototype vole le 25 octobre 1955 ; le second franchit le mur du son en montée dès son premier vol, sans le vouloir. Le 14 janvier 1960, le pilote Erik Dahlström atteint Mach 2 sur le prototype du J 35B. Les pilotes découvrent aussi un décrochage profond, dont la parade, la *kort parad*, deviendra une figure de combat.\n\n## Carrière opérationnelle\nLes livraisons commencent fin 1959 à l''escadre F 13 de Norrköping, et l''avion entre en ligne en mars 1960. Les versions s''enchaînent : 90 J 35A, 73 J 35B, 120 J 35D, 60 S 35E de reconnaissance et 230 J 35F armés de missiles Falcon. Pendant la **guerre froide**, quand les SR-71 américains commencent leurs vols de renseignement au-dessus de la Baltique, les J 35F tentent de les intercepter, sans en avoir les performances ; le Viggen prend le relais. Le Danemark, qui l''a préféré en 1968 au Mirage III et au F-5, en aligne 51 jusqu''en 1993, la Finlande l''exploite de 1972 à 2000 et l''Autriche reçoit à partir de 1987 vingt-quatre J 35D rénovés, retirés en 2005. En Suède, 67 J 35F modernisés en J 35J de 1987 à 1991 volent jusqu''en décembre 1999.\n\n## Place dans l''histoire\nAvec 651 exemplaires, le Draken installe la Suède parmi les rares pays capables de concevoir seuls un chasseur de Mach 2. Sa doctrine de dispersion se prolonge avec le Viggen et le Gripen.',
  description_en = E'## Genesis\nIn September 1949 the Swedish Air Force called for a supersonic interceptor able to stop bombers coming from the east. The **Saab** team led by engineer **Erik Bratt** devised an unprecedented layout, the **double delta**: a sharply swept inner wing close to the fuselage, with a less swept outer section. To test it, a small sub-scale aircraft, the Saab 210 "Lilldraken", flew as early as 21 January 1952.\n\n## Design\nThe shape combined low drag at high speed, room for fuel and good low-speed handling. The engine was a **Rolls-Royce Avon** built under licence by Volvo. Above all, the Draken was designed for Sweden''s kind of war: operating from reinforced roads and being refuelled and rearmed in ten minutes or less by conscripts, within the **Bas 60** dispersed basing system.\n\n## Testing\nThe first prototype flew on 25 October 1955; the second broke the sound barrier in a climb on its very first flight, unintentionally. On 14 January 1960 test pilot Erik Dahlström reached Mach 2 in the J 35B prototype. Pilots also discovered a deep stall, whose recovery, the *kort parad*, became a combat manoeuvre.\n\n## Operational career\nDeliveries began in late 1959 to the F 13 wing at Norrköping, and the aircraft entered frontline service in March 1960. Versions followed one another: 90 J 35As, 73 J 35Bs, 120 J 35Ds, 60 S 35E reconnaissance aircraft and 230 Falcon-armed J 35Fs. During the **Cold War**, when US SR-71s began their intelligence flights over the Baltic, J 35Fs tried to intercept them but lacked the performance, and the Viggen took over. Denmark, which preferred it to the Mirage III and F-5 in 1968, flew 51 until 1993; Finland operated it from 1972 to 2000; and Austria received twenty-four refurbished J 35Ds from 1987, retired in 2005. In Sweden, 67 J 35Fs upgraded to J 35J standard between 1987 and 1991 flew until December 1999.\n\n## Place in history\nWith 651 built, the Draken placed Sweden among the few countries able to design a Mach 2 fighter on their own. Its dispersal doctrine lived on with the Viggen and the Gripen.'
WHERE name = 'Saab 35 Draken';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 35 Draken';
