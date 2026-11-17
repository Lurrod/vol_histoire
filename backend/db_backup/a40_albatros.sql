-- Beriev A-40 Albatros (Be-42, Mermaid)
--
-- Photo : Soviet A-40 Albatross.JPEG
--   licence Public domain — Unknown author (U.S. Department of Defense, VIRIN DN-SC-92-01051)
--   https://commons.wikimedia.org/wiki/File:Soviet_A-40_Albatross.JPEG

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
    'Beriev A-40 Albatros',
    'Beriev A-40 Albatros',
    'Beriev A-40 Albatros (Be-42, Mermaid)',
    'Beriev A-40 Albatros (Be-42, Mermaid)',
    'Le géant des hydravions à réaction soviétiques, chasseur de sous-marins resté à l''état de prototype',
    'The giant of Soviet jet flying boats, a submarine hunter that never left the prototype stage',
    '/assets/airplanes/beriev-a40.jpg',
    E'## Genèse\nDans les années 1980, le bureau d''études **Beriev**, dirigé par **A. K. Konstantinov**, étudie un grand hydravion à réaction destiné à la lutte anti-sous-marine. Il doit remplacer à la fois l''amphibie à turbopropulseurs **Be-12** et le patrouilleur terrestre **Il-38**. Son premier vol, le 8 décembre 1986, n''a rien de prévu : lors d''un essai de roulage à grande vitesse, l''avion quitte le sol et arrive en bout de piste, si bien que l''équipage doit poursuivre le décollage. Le vol s''achève sans incident, mais les pilotes sont écartés de leurs fonctions, alors même qu''ils ont sauvé l''appareil.\n\n## Conception\nL''A-40 est un hydravion à coque entièrement métallique, à aile haute en flèche au dièdre négatif marqué, avec des flotteurs d''équilibre fixés sous les saumons. Ses deux réacteurs double flux **Soloviev D-30KPV** de 117,7 kN sont placés au-dessus des emplantures, sur les nacelles du train principal. Deux turboréacteurs d''appoint **RD-36-35** de 23 kN l''aident à décoller, en 1 000 m sur piste et 2 000 m sur l''eau. Avec 86 tonnes au décollage et 41,6 m d''envergure, il atteint 800 km/h et franchit 4 100 km.\n\n## Essais\nÀ l''été 1988, la presse occidentale le surnomme « Tag-D », avant que l''OTAN ne le baptise **Mermaid**. Le secret n''est levé que le 20 août 1989, au meeting de Touchino, et l''avion est présenté au Bourget en 1991 sous le nom de Be-42. Entre 1989 et 1998, il établit 140 records du monde. Mais l''effondrement de l''URSS arrête tout : en 1993, la version de sauvetage **A-42** reste inachevée. Remis en état de vol en 2002 à la demande de la marine russe, le prototype est rejoint par l''A-42 achevé en 2006, avant que le ministère de la Défense n''abandonne le programme en 2011.\n\n## Place dans l''histoire\nL''A-40 est resté un appareil unique, mais il a prouvé qu''un hydravion à réaction de cette taille pouvait décoller de l''eau et battre des records. Ses déclinaisons civiles, étudiées dès 1994, ont mené au **Beriev Be-200**, plus petit, qui a trouvé des clients en Russie et à l''étranger, là où son aîné n''en a jamais eu. La marine russe a bien annoncé en 2019 une commande de trois A-42 à hélices rapides **Progress D-27**, mais ces moteurs venaient d''Ukraine, et l''usine Motor Sich de Zaporijia a été détruite en mai 2022.',
    E'## Genesis\nIn the 1980s the **Beriev** design bureau, led by **A. K. Konstantinov**, worked on a large jet flying boat for anti-submarine warfare. It was to replace both the **Be-12** turboprop amphibian and the land-based **Il-38** patrol aircraft. Its first flight, on 8 December 1986, was not planned: during a high-speed taxi test the aircraft became airborne and ran out of runway, so the crew had to continue the take-off. The flight ended without incident, but the test crew were removed from their duties, even though they had saved the aircraft.\n\n## Design\nThe A-40 is an all-metal flying boat with a high-set swept wing of marked anhedral and balance floats fixed under the wingtips. Its two **Soloviev D-30KPV** turbofans of 117.7 kN sit above the wing roots, atop the main landing gear nacelles. Two **RD-36-35** booster turbojets of 23 kN help it take off, in 1,000 m on land and 2,000 m on water. Weighing 86 tonnes at take-off with a 41.6 m span, it reaches 800 km/h and has a range of 4,100 km.\n\n## Testing\nIn the summer of 1988 the Western press called it ''Tag-D'', before NATO gave it the reporting name **Mermaid**. The secret was only lifted on 20 August 1989 at the Tushino air display, and the aircraft was shown at Le Bourget in 1991 as the Be-42. Between 1989 and 1998 it set 140 world records. But the collapse of the Soviet Union stopped everything: in 1993 the **A-42** search and rescue version was left unfinished. Restored to airworthiness in 2002 at the Russian Navy''s request, the prototype was joined by the A-42, completed in 2006, before the Defence Ministry dropped the programme in 2011.\n\n## Place in history\nThe A-40 remained a one-off, but it proved that a jet flying boat of this size could take off from water and set records. Its civil derivatives, studied from 1994, led to the smaller **Beriev Be-200**, which found customers at home and abroad where its elder never did. The Russian Navy did announce an order for three A-42s with **Progress D-27** propfans in 2019, but those engines came from Ukraine, and the Motor Sich plant in Zaporizhzhia was destroyed in May 2022.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1986-12-08',
    NULL,
    800,
    4100,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-40 Albatros'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-40 Albatros'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-40 Albatros'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev A-40 Albatros'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-40 Albatros'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Beriev A-40 Albatros'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 43.84,
  wingspan          = 41.62,
  height            = 11,
  wing_area         = 200,
  empty_weight      = NULL,
  mtow              = 86000,
  service_ceiling   = 9700,
  climb_rate        = 30,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 8,

  -- Strate 2 : motorisation
  engine_name       = 'Soloviev D-30KPV (+ 2 Rybinsk RD-36-35 d''appoint)',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 117.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **A-40** : version initiale de lutte anti-sous-marine, un seul prototype achevé\n- **A-42 (Be-42)** : version de recherche et de sauvetage destinée à remplacer le Be-12PS, prototype achevé en 2006\n- **A-44** : version de patrouille maritime, fusionnée avec l''A-42 en 1993\n- **Be-40P / Be-40PT** : projets civils de 105 passagers ou mixtes fret-passagers, à l''origine du Be-200\n- **A-42PE** : projet d''exportation à hélices rapides Progress D-27',
  variants_en       = E'- **A-40**: initial anti-submarine version, only one prototype completed\n- **A-42 (Be-42)**: search and rescue version meant to replace the Be-12PS, prototype completed in 2006\n- **A-44**: maritime patrol version, merged with the A-42 in 1993\n- **Be-40P / Be-40PT**: civil projects for 105 passengers or mixed cargo and passengers, which led to the Be-200\n- **A-42PE**: export project with Progress D-27 propfans',

  -- Strate 4 : qualitatif
  nickname          = 'Mermaid',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beriev_Be-42',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beriev_A-40',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Beriev A-40 Albatros';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beriev A-40 Albatros';
