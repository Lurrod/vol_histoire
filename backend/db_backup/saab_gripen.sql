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
    'Saab JAS 39 Gripen',
    'Saab JAS 39 Gripen',
    'Saab JAS 39 Gripen C/D/E (Flygvapnet)',
    'Saab JAS 39 Gripen C/D/E (Swedish Air Force)',
    'Chasseur multirôle polyvalent suédois de 4e génération à aile canard-delta',
    'Swedish 4th-generation multirole fighter with canard-delta wing',
    '/assets/airplanes/saab-jas-39-gripen.jpg',
    'Le Saab JAS 39 Gripen ("Griffon") est un chasseur multirôle léger monomoteur conçu par Saab AB. Dénomination "JAS" pour Jakt (chasse), Attack et Spaning (reconnaissance) — le programme a été conçu dès le départ comme un véritable omnirôle. Sa configuration canard-delta, son fly-by-wire, son radar PS-05/A (Ericsson) et sa liaison de données tactique LINK 16 lui confèrent une excellente efficacité pour un coût d''exploitation parmi les plus bas au monde. Exploité par la Suède, l''Afrique du Sud, la République tchèque, la Hongrie, la Thaïlande et le Brésil (Gripen E/F). La version Gripen E (2019) introduit un radar AESA, une avionique tout nouveau et le missile Meteor.',
    'The Saab JAS 39 Gripen ("Griffon") is a single-engine lightweight multirole fighter designed by Saab AB. The "JAS" designation stands for Jakt (fighter), Attack and Spaning (reconnaissance) — the programme was designed from the outset as a genuine omnirole aircraft. Its canard-delta configuration, fly-by-wire, PS-05/A (Ericsson) radar and LINK 16 tactical data link deliver excellent effectiveness with one of the lowest operating costs in the world. Operated by Sweden, South Africa, the Czech Republic, Hungary, Thailand and Brazil (Gripen E/F). The Gripen E version (2019) introduces an AESA radar, all-new avionics and the Meteor missile.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1979-01-01',
    '1988-12-09',
    '1996-06-09',
    2460.0,
    3200.0,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Actif',
    'Active',
    6800.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM tech WHERE name = 'Aile canard delta')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM tech WHERE name = 'Réacteur Volvo RM12')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM tech WHERE name = 'Radar PS-05/A')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'Mauser BK-27')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'IRIS-T')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'M/71 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM armement WHERE name = 'Rb 15F'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 14.10, wingspan = 8.40, height = 4.50, wing_area = 25.54,
  empty_weight = 6800, mtow = 14000, service_ceiling = 15240, climb_rate = 254,
  combat_radius = 800, crew = 1, g_limit_pos = 9.0, g_limit_neg = -3.0,
  engine_name = 'Volvo Flygmotor RM12 (dérivé General Electric F404)', engine_count = 1,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 54.0, thrust_wet = 80.5,
  production_start = 1987, production_end = NULL, units_built = 271,
  operators_count = 6,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Saab_JAS_39_Gripen',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Saab_JAS_39_Gripen'
WHERE name = 'Saab JAS 39 Gripen';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 85000000, unit_cost_year = 2018,
  manufacturer_page = 'https://www.saab.com/products/gripen-fighter-system',
  variants    = E'- **JAS 39A/B** : versions initiales (1997), 30 appareils\n- **JAS 39C/D** : standard OTAN, perche de ravitaillement, liaison 16 (2003)\n- **JAS 39E/F Gripen E** : refonte complète, radar AESA, moteur F414, EW Arexis (2019)\n- **Gripen NG** : démonstrateur export pour Brésil/Colombie\n- Exploité par Suède, Afrique du Sud, République tchèque, Hongrie, Thaïlande, Brésil',
  variants_en = E'- **JAS 39A/B** : initial variants (1997), 30 aircraft\n- **JAS 39C/D** : NATO standard, refueling probe, Link 16 (2003)\n- **JAS 39E/F Gripen E** : full redesign, AESA radar, F414 engine, Arexis EW (2019)\n- **Gripen NG** : export demonstrator for Brazil/Colombia\n- Operated by Sweden, South Africa, Czech Republic, Hungary, Thailand, Brazil'
WHERE name = 'Saab JAS 39 Gripen';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nDémarré en **1979** par le groupe industriel JAS (Saab, Volvo, Ericsson, FFV), le Gripen vise à remplacer Draken et Viggen par une plateforme omnirôle light (le Jakt/Attack/Spaning — chasse/attaque/reconnaissance) à coût d''exploitation très bas. Premier vol le **9 décembre 1988**. Mise en service en **1997**.\n\n## Carrière opérationnelle\n**271 appareils** livrés ou en cours de livraison fin 2024 (A/B/C/D + E). Exporté à 5 nations (Afrique du Sud, République tchèque, Hongrie, Thaïlande, Brésil). Le Gripen est régulièrement cité pour son ratio efficacité/coût — coût à l''heure de vol 3 à 10× inférieur aux autres chasseurs occidentaux. Engagé en opérations OTAN (police du ciel Baltique, Libye 2011 — reconnaissance).\n\n## Héritage\nPremier chasseur occidental conçu dès l''origine avec une **architecture ouverte** et **mise à jour logicielle incrémentale** (cycles Edition 18/19/20/21). Modèle de développement repris par le Tempest GCAP et le KF-21 coréen. La variante Gripen E est le premier chasseur de production avec un ordinateur de mission séparé de la couche de vol (decoupled safety-critical software).',
  description_en = E'## Genesis\nStarted in **1979** by the JAS industrial group (Saab, Volvo, Ericsson, FFV), the Gripen aims to replace the Draken and Viggen with a light omnirole platform (Jakt/Attack/Spaning — fighter/attack/reconnaissance) with very low operating cost. First flight on **9 December 1988**. Service entry in **1997**.\n\n## Operational career\n**271 aircraft** delivered or being delivered by end-2024 (A/B/C/D + E). Exported to 5 nations (South Africa, Czech Republic, Hungary, Thailand, Brazil). The Gripen is regularly cited for its cost/effectiveness ratio — hourly flight cost 3 to 10× lower than other Western fighters. Deployed in NATO operations (Baltic air policing, Libya 2011 — reconnaissance).\n\n## Legacy\nFirst Western fighter designed from the ground up with an **open architecture** and **incremental software update** (Edition 18/19/20/21 cycles). Development model adopted by the Tempest GCAP and the Korean KF-21. The Gripen E variant is the first production fighter with a mission computer decoupled from the flight layer (decoupled safety-critical software).'
WHERE name = 'Saab JAS 39 Gripen';
