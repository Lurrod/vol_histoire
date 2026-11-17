-- Lockheed EP-3E ARIES II
--
-- Photo : Lockheed EP-3E Aries II of VQ-1 in flight over the Mediterranean Sea on 28 February 2019 (190228-N-HG389-0061).JPG
--   licence Public domain — U.S. Navy photo by Mass Communication Specialist 2nd Class Brandon Parker
--   https://commons.wikimedia.org/wiki/File:Lockheed_EP-3E_Aries_II_of_VQ-1_in_flight_over_the_Mediterranean_Sea_on_28_February_2019_(190228-N-HG389-0061).JPG

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
    'Lockheed EP-3',
    'Lockheed EP-3',
    'Lockheed EP-3E ARIES II',
    'Lockheed EP-3E ARIES II',
    'L''Orion d''écoute de l''US Navy, resté célèbre pour sa collision avec un chasseur chinois en 2001',
    'The US Navy''s eavesdropping Orion, remembered for its 2001 collision with a Chinese fighter',
    '/assets/airplanes/ep3-aries.jpg',
    E'## Genèse\nLe patrouilleur maritime **P-3 Orion** sert très tôt de base à des avions d''écoute électronique. Les premières conversions sont secrètes : en 1963, la CIA obtient de la Navy trois P-3A qui, modifiés pour le renseignement électronique et les communications, rejoignent en 1966 l''escadrille taïwanaise des « Chauves-souris noires » et longent les côtes chinoises en pleine **guerre froide** pour recueillir signaux et échantillons d''air. Rendus en 1967, deux deviennent les seuls **EP-3B**, qui rejoignent l''escadron VQ-1 en 1969 et se déploient à Da Nang pendant la **guerre du Vietnam**. Sept **EP-3A** servent parallèlement aux essais.\n\n## Conception\nLa version définitive porte le nom d''**ARIES**, pour *Airborne Reconnaissance Integrated Electronic System*. L''EP-3E intercepte aussi bien les communications que les émissions des radars adverses. Dix P-3A et les deux EP-3B forment la première génération d''EP-3E ; elle est remplacée dans les années 1990 par douze P-3C convertis en **EP-3E ARIES II**, le dernier livré en 1997. Quatre turbopropulseurs **Allison T56** et une cabine assez vaste pour un équipage d''environ vingt-quatre personnes, linguistes, cryptologues et techniciens, l''emportent sur de longues missions en espace aérien international.\n\n## Carrière opérationnelle\nLes escadrons qui l''exploitent volaient auparavant sur **EC-121 Warning Star** et EA-3B Skywarrior, et l''EP-3 reprend leurs missions d''écoute. Le 1er avril 2001, à 110 km de l''île de Hainan, un EP-3E ARIES II est intercepté par deux **J-8II** chinois ; l''un d''eux le percute et s''abîme en mer avec son pilote. L''Orion, un temps presque sur le dos, se pose en urgence à Lingshui. L''équipage est retenu puis rapatrié, l''avion exploité par les services chinois avant d''être démonté et ramené en pièces aux États-Unis à bord de deux **An-124**. D''autres interceptions rapprochées suivent, par des Su-27 russes en mer Noire en 2018 et par un Su-30 vénézuélien en 2019.\n\n## Place dans l''histoire\nL''incident de Hainan a fait de l''EP-3 le symbole des tensions sino-américaines dans le ciel du Pacifique. Le programme **EP-X**, qui devait lui donner un successeur sur base de Boeing 737, est annulé en 2010 ; la Navy confie sa mission au drone **MQ-4C Triton** et à l''hélicoptère sans pilote MQ-8B. Les derniers EP-3E sont retirés en février 2025, mais le Japon continue d''exploiter cinq EP-3 de renseignement électronique.',
    E'## Genesis\nThe **P-3 Orion** maritime patrol aircraft served early on as the basis for electronic eavesdropping aircraft. The first conversions were secret: in 1963 the CIA obtained three P-3As from the Navy which, modified for electronic and communications intelligence, joined Taiwan''s "Black Bat" squadron in 1966 and flew along the Chinese coast at the height of the **Cold War** to collect signals and air samples. Returned in 1967, two became the only **EP-3B**s, which joined squadron VQ-1 in 1969 and deployed to Da Nang during the **Vietnam War**. Seven **EP-3A**s served for testing in parallel.\n\n## Design\nThe definitive version is called **ARIES**, for Airborne Reconnaissance Integrated Electronic System. The EP-3E intercepts both communications and emissions from enemy radars. Ten P-3As and the two EP-3Bs formed the first generation of EP-3Es; it was replaced in the 1990s by twelve P-3Cs converted to **EP-3E ARIES II**, the last delivered in 1997. Four **Allison T56** turboprops and a cabin large enough for a crew of around twenty-four, linguists, cryptologists and technicians, carry it on long missions in international airspace.\n\n## Operational career\nThe squadrons flying it had previously operated the **EC-121 Warning Star** and the EA-3B Skywarrior, and the EP-3 took over their eavesdropping missions. On 1 April 2001, 110 km from Hainan island, an EP-3E ARIES II was intercepted by two Chinese **J-8II** fighters; one struck it and fell into the sea with its pilot. The Orion, at one point almost inverted, made an emergency landing at Lingshui. The crew was detained then repatriated, the aircraft exploited by Chinese intelligence before being dismantled and flown back in pieces to the United States aboard two **An-124**s. Other close intercepts followed, by Russian Su-27s over the Black Sea in 2018 and a Venezuelan Su-30 in 2019.\n\n## Place in history\nThe Hainan incident made the EP-3 the symbol of Sino-American tension in Pacific skies. The **EP-X** programme, meant to give it a Boeing 737-based successor, was cancelled in 2010; the Navy handed its mission to the **MQ-4C Triton** drone and the MQ-8B unmanned helicopter. The last EP-3Es were retired in February 2025, but Japan still operates five electronic intelligence EP-3s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    '1969-01-01',
    704,
    4074,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed EP-3'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Lockheed EP-3'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed EP-3'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed EP-3'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Lockheed EP-3'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.61,
  wingspan          = 30.38,
  height            = 10.27,
  wing_area         = 120.8,
  empty_weight      = 27892,
  mtow              = 64410,
  service_ceiling   = 8534,
  climb_rate        = 11.05,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 24,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-14 (4 910 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = 1997,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **EP-3A** : sept appareils modifiés pour les essais de reconnaissance électronique\n- **EP-3B « Bat Rack »** : deux P-3A passés par la CIA et l''escadrille taïwanaise des Chauves-souris noires, au VQ-1 à partir de 1969\n- **EP-3E ARIES** : dix P-3A et les deux EP-3B convertis, retirés dans les années 1990\n- **EP-3E ARIES II** : douze P-3C convertis, le dernier livré en 1997, retirés en février 2025\n- **EP-3 japonais** : cinq appareils de renseignement électronique de la Force maritime d''autodéfense',
  variants_en       = E'- **EP-3A**: seven aircraft modified for electronic reconnaissance testing\n- **EP-3B "Bat Rack"**: two P-3As that served with the CIA and Taiwan''s Black Bat squadron, with VQ-1 from 1969\n- **EP-3E ARIES**: ten P-3As and the two EP-3Bs converted, retired in the 1990s\n- **EP-3E ARIES II**: twelve converted P-3Cs, the last delivered in 1997, retired in February 2025\n- **Japanese EP-3**: five electronic intelligence aircraft of the Maritime Self-Defense Force',

  -- Strate 4 : qualitatif
  nickname          = 'ARIES',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_EP-3',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_EP-3',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mass Communication Specialist 2nd Class Brandon Parker, U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed EP-3';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed EP-3';
