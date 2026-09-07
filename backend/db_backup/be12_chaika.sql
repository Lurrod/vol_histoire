-- Beriev Be-12 Chaïka (Mail)
--
-- Photo : Ukrainian Beriev Be-12 in flight over the Black Sea in September 2014.jpg
--   licence Public domain — U.S. Navy photo by Mass Communication Specialist 2nd Class John Herman
--   https://commons.wikimedia.org/wiki/File%3AUkrainian_Beriev_Be-12_in_flight_over_the_Black_Sea_in_September_2014.jpg

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
    'Beriev Be-12 Chaïka',
    'Beriev Be-12 Chaika',
    'Beriev Be-12 Chaïka (Mail)',
    'Beriev Be-12 Chaika (Mail)',
    'Dernier hydravion de combat au monde encore en service',
    'The last combat flying boat still in service anywhere',
    '/assets/airplanes/be12-chaika.jpg',
    E'## Genèse\nÀ la fin des années 1950, l''URSS surveille ses mers fermées — Baltique, mer Noire, Caspienne — avec des hydravions à pistons dépassés. Beriev, le seul bureau soviétique spécialisé dans l''hydraviation, propose un successeur à turbopropulseurs. Le choix de l''amphibie n''est pas nostalgique : il permet de se poser près d''un sous-marin détecté, de couper les moteurs et **d''écouter la mer directement**, chose qu''aucun avion classique ne sait faire.\n\n## Conception\nCoque de bateau, aile en mouette au dièdre brisé pour écarter les hélices des embruns, empennage bidérive et flotteurs de bout d''aile escamotables. Un détecteur d''anomalies magnétiques prolonge la queue. Le train rentrant lui permet d''opérer aussi bien depuis une piste que depuis l''eau — d''où *amphibie*. Le nom **Tchaïka**, la mouette, vient de la silhouette de l''aile.\n\n## Carrière opérationnelle\nIl patrouille la mer Noire et la Baltique pendant toute la guerre froide, en traque anti-sous-marine et en sauvetage. L''**Ukraine** en a hérité une poignée à l''indépendance et les exploitait encore au-dessus de la mer Noire en 2014. La Russie en conserve quelques-uns, dont des bombardiers d''eau capables d''écoper en surface.\n\n## Place dans l''histoire\nCent quarante-trois exemplaires. Il détient un titre que personne ne lui disputera : **dernier hydravion de combat au monde encore en service**, soixante ans après son premier vol. L''hydraviation militaire, qui fut une branche entière de l''aéronautique, s''éteint avec lui — seul le japonais **ShinMaywa US-2** en perpétue encore l''idée, et uniquement pour le sauvetage.',
    E'## Genesis\nBy the late 1950s the USSR was watching its enclosed seas — Baltic, Black Sea, Caspian — with outdated piston flying boats. Beriev, the only Soviet bureau specialising in marine aircraft, proposed a turboprop successor. The choice of an amphibian was not nostalgia: it allows the aircraft to land near a detected submarine, shut down and **listen to the sea directly**, something no conventional aeroplane can do.\n\n## Design\nA boat hull, a gull wing with cranked dihedral to lift the propellers clear of spray, twin fins and retractable wingtip floats. A magnetic anomaly detector extends the tail. Retractable landing gear lets it work from a runway as readily as from water — hence *amphibian*. The name **Chaika**, the gull, comes from the wing''s silhouette.\n\n## Operational career\nIt patrolled the Black Sea and the Baltic throughout the Cold War, hunting submarines and rescuing at sea. **Ukraine** inherited a handful at independence and was still flying them over the Black Sea in 2014. Russia keeps a few, including water bombers able to scoop on the surface.\n\n## Place in history\nOne hundred and forty-three built. It holds a title nobody will contest: **the last combat flying boat in service anywhere**, sixty years after its first flight. Military marine aviation, once a whole branch of the discipline, ends with it — only Japan''s **ShinMaywa US-2** still carries the idea forward, and for rescue alone.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1956-01-01',
    '1960-10-18',
    '1965-01-01',
    550.0,
    3300.0,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM armement WHERE name = 'APR-3')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM armement WHERE name = 'RGB-75')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.17,
  wingspan          = 29.84,
  height            = 7.94,
  wing_area         = 99.0,
  empty_weight      = 24000,
  mtow              = 36000,
  service_ceiling   = 8000,
  climb_rate        = 9.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1200,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-20D',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1973,
  units_built       = 143,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Be-12** : version de lutte anti-sous-marine de base\n- **Be-12PS** : version de sauvetage en mer, sans armement\n- **Be-12P** : bombardier d''eau, écope quatre tonnes en surface sans se poser\n- **Be-12N** : modernisation à électronique nouvelle des années 1970\n- **Aile en mouette** : le dièdre brisé éloigne les hélices des embruns',
  variants_en       = E'- **Be-12** : baseline anti-submarine version\n- **Be-12PS** : sea rescue version, unarmed\n- **Be-12P** : water bomber, scooping four tonnes on the surface without landing\n- **Be-12N** : 1970s upgrade with new electronics\n- **Gull wing** : the cranked dihedral lifts the propellers clear of the spray',

  -- Strate 4 : qualitatif
  nickname          = 'Mail',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beriev_Be-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beriev_Be-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy photo by Mass Communication Specialist 2nd Class John Herman',
  image_licence     = 'Public domain'
WHERE name = 'Beriev Be-12 Chaïka';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beriev Be-12 Chaïka';
