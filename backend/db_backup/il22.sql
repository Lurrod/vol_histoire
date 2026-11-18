-- Iliouchine Il-22 (Coot-B)
--
-- Photo : Ilyushin IL-22M-11 ‘75926’ (36809720134).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Ilyushin_IL-22M-11_%E2%80%9875926%E2%80%99_(36809720134).jpg

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
    'Iliouchine Il-22',
    'Ilyushin Il-22',
    'Iliouchine Il-22 (Coot-B)',
    'Ilyushin Il-22 (Coot-B)',
    'Avion de ligne Il-18 devenu poste de commandement volant, toujours en ligne soixante ans plus tard',
    'Il-18 airliner turned flying command post, still in service sixty years on',
    '/assets/airplanes/ilyushin-il22.jpg',
    E'## Genèse\nL''**Il-18** naît d''une directive du Conseil des ministres du 30 décembre 1955, qui demande à Iliouchine et à Antonov un avion de ligne à turbopropulseurs ; les études ont commencé dès 1954. Le prototype vole le 4 juillet 1957 et le quadrimoteur devient pour des décennies l''un des principaux avions de ligne soviétiques. Sa robustesse en fait aussi une base militaire de choix : il donne l''avion de renseignement **Il-20**, le patrouilleur anti-sous-marin **Il-38** et, pour le commandement, l''**Il-22**, que l''OTAN baptise « Coot-B ».\n\n## Conception\nL''Il-22 est un **poste de commandement aéroporté** : la cabine pressurisée de l''avion de ligne, à fuselage circulaire, accueille les moyens de transmission qui permettent de diriger des forces depuis le ciel. La cellule garde ses quatre turbopropulseurs Ivtchenko AI-20M de 4 250 ch, ses hélices quadripales et le radar météo logé dans le nez, une nouveauté à la naissance de l''Il-18. L''**Il-22M** reprend le même principe avec un nouvel équipement de mission. Plus récent, l''**Il-22PP**, étudié à partir de l''automne 2009, est un avion de guerre électronique et de reconnaissance.\n\n## Carrière opérationnelle\nLes Il-18, Il-20 et Il-22 servent toujours dans l''armée de l''air russe comme avions de reconnaissance et postes de commandement. L''unique Il-22PP entre en service en octobre 2016 au sein du détachement de guerre électronique du 117e régiment d''aviation de transport militaire. Le 24 juin 2023, pendant la rébellion du groupe **Wagner**, un Il-22 de commandement est abattu : ses dix membres d''équipage sont tués. Le 14 janvier 2024, des médias ukrainiens affirment qu''un autre Il-22 a été touché au-dessus de la **mer d''Azov** ; l''appareil parvient à se poser en catastrophe à Anapa, mais serait irréparable.\n\n## Place dans l''histoire\nL''Il-22 illustre la longévité de la famille Il-18 : plus de soixante ans après le premier vol du prototype, la cellule d''un avion de ligne de la fin des années 1950 porte encore les transmissions du commandement russe. Ses pertes récentes rappellent aussi la vulnérabilité de ces grands quadrimoteurs, ni rapides ni discrets. Avec l''Il-20 et l''Il-38, il forme la branche militaire d''un appareil conçu à l''origine pour transporter des passagers d''Aeroflot.',
    E'## Genesis\nThe **Il-18** was born of a Council of Ministers directive of 30 December 1955 asking Ilyushin and Antonov for a turboprop airliner; design work had begun as early as 1954. The prototype flew on 4 July 1957 and the four-engined aircraft became, for decades, one of the Soviet Union''s principal airliners. Its durability also made it a prime military platform: it produced the **Il-20** intelligence aircraft, the **Il-38** anti-submarine patrol aircraft and, for command duties, the **Il-22**, which NATO named "Coot-B".\n\n## Design\nThe Il-22 is an **airborne command post**: the airliner''s pressurised, circular-section cabin houses the communications equipment needed to direct forces from the air. The airframe keeps its four 4,250 hp Ivchenko AI-20M turboprops, its four-bladed propellers and the weather radar in the nose, a novelty when the Il-18 appeared. The **Il-22M** follows the same principle with new mission equipment. More recent, the **Il-22PP**, developed from autumn 2009, is an electronic warfare and reconnaissance aircraft.\n\n## Operational career\nThe Il-18, Il-20 and Il-22 still serve with the Russian Air Force as reconnaissance and command post aircraft. The single Il-22PP entered service in October 2016 with the electronic warfare detachment of the 117th Military Transport Aviation Regiment. On 24 June 2023, during the **Wagner Group** rebellion, a command post Il-22 was shot down and all ten crew members were killed. On 14 January 2024, Ukrainian media claimed that another Il-22 had been hit over the **Sea of Azov**; the aircraft managed a crash landing at Anapa but was said to be beyond repair.\n\n## Place in history\nThe Il-22 shows the longevity of the Il-18 family: more than sixty years after the prototype''s first flight, the airframe of a late-1950s airliner still carries the communications of Russian command. Its recent losses are also a reminder of how vulnerable these large four-engined aircraft are, being neither fast nor stealthy. With the Il-20 and the Il-38, it forms the military branch of an aircraft originally designed to carry Aeroflot passengers.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    NULL,
    NULL,
    675,
    6500,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-22'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-22'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-22'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-22'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-22'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-22'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.9,
  wingspan          = 37.4,
  height            = 10.17,
  wing_area         = NULL,
  empty_weight      = 35000,
  mtow              = 64000,
  service_ceiling   = 11800,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 10,

  -- Strate 2 : motorisation
  engine_name       = 'Ivtchenko AI-20M (4 250 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Il-22 (Coot-B)** : poste de commandement aéroporté dérivé de l''avion de ligne Il-18\n- **Il-22M** : même rôle, avec un nouvel équipement de mission\n- **Il-22PP** : guerre électronique et reconnaissance, étudié à partir de 2009, un seul exemplaire en service depuis octobre 2016\n- **Il-20M (Coot-A)** : cousin de renseignement électronique et de reconnaissance radar\n- **Il-38** : cousin de patrouille maritime et de lutte anti-sous-marine',
  variants_en       = E'- **Il-22 (Coot-B)**: airborne command post derived from the Il-18 airliner\n- **Il-22M**: same role, with new mission equipment\n- **Il-22PP**: electronic warfare and reconnaissance, developed from 2009, a single aircraft in service since October 2016\n- **Il-20M (Coot-A)**: electronic intelligence and radar reconnaissance cousin\n- **Il-38**: maritime patrol and anti-submarine warfare cousin',

  -- Strate 4 : qualitatif
  nickname          = 'Coot-B',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-18',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-18',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Iliouchine Il-22';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-22';
