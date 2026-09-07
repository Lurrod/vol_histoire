-- Iliouchine Il-114
--
-- Photo : Ilyushin Il-114 RA-91003 "RADAR" in flight at Army 2015 exhibition (1).jpg
--   licence CC BY-SA 2.0 — Artem Katranzhi
--   https://commons.wikimedia.org/wiki/File%3AIlyushin_Il-114_RA-91003_%22RADAR%22_in_flight_at_Army_2015_exhibition_%281%29.jpg

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
    'Iliouchine Il-114',
    'Ilyushin Il-114',
    'Iliouchine Il-114',
    'Ilyushin Il-114',
    'Conçu en 1990, relancé trois fois, toujours pas en service',
    'Designed in 1990, relaunched three times, still not in service',
    '/assets/airplanes/il114.jpg',
    E'## Genèse\nL''URSS lance en 1986 le remplacement de l''**Antonov An-24**, bimoteur régional des années 1960 produit à plus de mille exemplaires et omniprésent. Iliouchine dessine l''Il-114 et le fait voler en mars 1990. Dix-huit mois plus tard, l''Union soviétique n''existe plus.\n\n## Conception\nUn bimoteur classique de soixante-quatre places, aile basse, turbopropulseurs **TV7-117** russes. L''appareil est correct et sans surprise ; son problème n''est pas technique. L''usine d''assemblage se trouve à **Tachkent**, qui devient ouzbèke en 1991 : la Russie perd le contrôle de sa propre chaîne de production.\n\n## Carrière opérationnelle\nUne vingtaine d''exemplaires en trente-six ans. Quelques-uns volent en Ouzbékistan, un est transformé en **banc d''essai radar** volant pour les forces russes, et deux versions de patrouille maritime sont livrées. Le programme est relancé en 2014 puis en 2020 ; un prototype de la version -300 s''écrase en 2021, tuant son équipage.\n\n## Place dans l''histoire\nVingt exemplaires. L''Il-114 est le contre-exemple parfait du **L-410** tchèque, conçu à la même époque pour un rôle voisin : celui-ci s''est adapté à la chute du bloc en changeant de moteurs et de marché, celui-là attend depuis trente-cinq ans que son pays retrouve les moyens de le construire.',
    E'## Genesis\nIn 1986 the USSR launched the replacement of the **Antonov An-24**, a 1960s regional twin built in more than a thousand examples and everywhere. Ilyushin drew the Il-114 and flew it in March 1990. Eighteen months later the Soviet Union no longer existed.\n\n## Design\nA conventional sixty-four-seat twin, low wing, Russian **TV7-117** turboprops. The aircraft is sound and unsurprising; its problem is not technical. The assembly plant is at **Tashkent**, which became Uzbek in 1991: Russia lost control of its own production line.\n\n## Operational career\nSome twenty aircraft in thirty-six years. A few fly in Uzbekistan, one was converted into a flying **radar testbed** for the Russian forces, and two maritime patrol versions were delivered. The programme was relaunched in 2014 and again in 2020; a -300 prototype crashed in 2021, killing its crew.\n\n## Place in history\nTwenty built. The Il-114 is the perfect counter-example to the Czech **L-410**, designed at the same period for a neighbouring role: that one adapted to the bloc''s collapse by changing engines and markets, this one has waited thirty-five years for its country to find the means to build it.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1986-01-01',
    '1990-03-29',
    NULL,
    500.0,
    4800.0,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-114'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-114'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-114'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-114'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.88,
  wingspan          = 30.0,
  height            = 9.32,
  wing_area         = 81.9,
  empty_weight      = 15000,
  mtow              = 23500,
  service_ceiling   = 7600,
  climb_rate        = 8.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1800,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov TV7-117ST-01',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1992,
  production_end    = NULL,
  units_built       = 20,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Il-114** : version civile d''origine, produite à Tachkent en Ouzbékistan\n- **Il-114MP / Il-114LL** : versions de patrouille maritime et de banc d''essai radar\n- **Il-114-300** : relance russe de 2020, à moteurs et avionique neufs\n- Devait remplacer l''**An-24** : celui-ci vole encore, trente-six ans après\n- Programme interrompu par la chute de l''URSS, l''usine se retrouvant à l''étranger',
  variants_en       = E'- **Il-114** : original civil version, built at Tashkent in Uzbekistan\n- **Il-114MP / Il-114LL** : maritime patrol and radar testbed versions\n- **Il-114-300** : Russian relaunch of 2020, with new engines and avionics\n- Was to replace the **An-24**: that aircraft still flies, thirty-six years on\n- Programme broken by the fall of the USSR, the factory ending up abroad',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-114',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-114',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Artem Katranzhi',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Iliouchine Il-114';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-114';
