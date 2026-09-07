-- Airbus A400M Atlas
--
-- Photo : German Air Force Airbus A400M (out cropped).jpg
--   licence CC BY-SA 4.0 — Peng Chen
--   https://commons.wikimedia.org/wiki/File%3AGerman_Air_Force_Airbus_A400M_%28out_cropped%29.jpg

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
    'Airbus A400M Atlas',
    'Airbus A400M Atlas',
    'Airbus A400M Atlas',
    'Airbus A400M Atlas',
    'Transport européen tenant à la fois du tactique et du stratégique',
    'European transport that is at once tactical and strategic',
    '/assets/airplanes/a400m-atlas.jpg',
    E'## Genèse\nL''Europe a un problème structurel : ses **C-130** et **Transall** peuvent se poser près du front mais ne traversent pas un océan, et les gros porteurs qui le font — C-17, An-124 — doivent être loués aux Américains ou aux Ukrainiens. Sept pays décident donc en 1982 de construire un appareil qui ferait les deux. Le programme mettra **vingt-sept ans** à voler, et manquera d''être annulé en 2010 quand son surcoût atteindra onze milliards d''euros.\n\n## Conception\nLa difficulté est d''associer la vitesse et l''altitude d''un jet à la capacité de se poser court. La réponse est le **TP400**, turbopropulseur de onze mille chevaux, le plus puissant jamais construit en Occident — et la principale cause des retards du programme. Les hélices à huit pales tournent **en sens inverse deux à deux** sur chaque aile, ce qui supprime le couple et améliore la portance soufflée. La soute accepte un hélicoptère complet ou un véhicule blindé.\n\n## Carrière opérationnelle\nDepuis 2013, il assure la projection française au **Sahel**, le pont aérien allemand vers l''Afghanistan puis l''évacuation de Kaboul, les livraisons humanitaires en Ukraine et après les séismes en Turquie. Sa capacité native de ravitailleur lui permet d''accompagner des chasseurs sans conversion. Un crash à l''essai à Séville en 2015, dû à une erreur logicielle d''installation moteur, a coûté la vie à quatre membres d''équipage.\n\n## Place dans l''histoire\nCent trente exemplaires livrés à neuf pays. Le programme reste l''exemple type des difficultés de la coopération européenne — sept clients, sept cahiers des charges, un consortium moteur créé de toutes pièces. L''appareil qui en est sorti n''a pourtant aucun équivalent : ni le **C-130J** ni le **C-17** ne font simultanément ce qu''il fait.',
    E'## Genesis\nEurope had a structural problem: its **C-130s** and **Transalls** could land near the front but could not cross an ocean, and the heavy lifters that could — C-17, An-124 — had to be chartered from the Americans or the Ukrainians. In 1982 seven countries therefore decided to build an aircraft that would do both. The programme took **twenty-seven years** to fly, and came close to cancellation in 2010 when its overrun reached eleven billion euros.\n\n## Design\nThe difficulty is combining a jet''s speed and altitude with the ability to land short. The answer is the **TP400**, an eleven-thousand-horsepower turboprop, the most powerful ever built in the West — and the main cause of the programme''s delays. The eight-blade propellers turn **in opposite directions in pairs** on each wing, which cancels torque and improves blown lift. The hold takes a complete helicopter or an armoured vehicle.\n\n## Operational career\nSince 2013 it has carried French power projection into the **Sahel**, the German air bridge to Afghanistan and then the Kabul evacuation, humanitarian deliveries to Ukraine and after the earthquakes in Turkey. Its native tanker capability lets it accompany fighters without conversion. A test crash at Seville in 2015, caused by an engine software installation error, killed four crew.\n\n## Place in history\nOne hundred and thirty delivered to nine countries. The programme remains the textbook illustration of the difficulties of European collaboration — seven customers, seven specifications, an engine consortium created from nothing. The aircraft that emerged nevertheless has no equivalent: neither the **C-130J** nor the **C-17** does simultaneously what it does.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '1982-01-01',
    '2009-12-11',
    '2013-08-01',
    780.0,
    8700.0,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 45.1,
  wingspan          = 42.4,
  height            = 14.7,
  wing_area         = 225.0,
  empty_weight      = 76500,
  mtow              = 141000,
  service_ceiling   = 11300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4540,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Europrop TP400-D6',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2007,
  production_end    = NULL,
  units_built       = 130,
  unit_cost_usd     = 180000000,
  unit_cost_year    = 2019,
  operators_count   = 9,
  variants          = E'- **A400M Atlas** : version unique, standards logiciels successifs\n- **A400M ravitailleur** : deux nacelles sous voilure, capacité native sans conversion\n- Exploité par la **France**, l''Allemagne, l''Espagne, le Royaume-Uni, la Turquie, la Belgique,\n  le Luxembourg, la Malaisie et le Kazakhstan\n- **Hélices contrarotatives par paire** : les deux moteurs d''une même aile tournent en sens inverse\n- Programme lancé en 1982, premier vol en 2009 : vingt-sept ans de gestation',
  variants_en       = E'- **A400M Atlas** : single version, with successive software standards\n- **A400M tanker** : two underwing pods, a native capability requiring no conversion\n- Operated by **France**, Germany, Spain, the United Kingdom, Turkey, Belgium,\n  Luxembourg, Malaysia and Kazakhstan\n- **Counter-rotating propellers in pairs** : the two engines on each wing turn opposite ways\n- Programme launched in 1982, first flight in 2009: twenty-seven years of gestation',

  -- Strate 4 : qualitatif
  nickname          = 'Grizzly',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Airbus_A400M_Atlas',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Airbus_A400M_Atlas',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Peng Chen',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Airbus A400M Atlas';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Airbus A400M Atlas';
