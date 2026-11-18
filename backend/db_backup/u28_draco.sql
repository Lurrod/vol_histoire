-- Pilatus U-28A Draco
--
-- Photo : Trojan Footprint 22 tests interoperability, increases allied partnership (7191674).jpg
--   licence Public domain — U.S. Air Force photo by Staff Sgt. Candin Muniz
--   https://commons.wikimedia.org/wiki/File:Trojan_Footprint_22_tests_interoperability,_increases_allied_partnership_(7191674).jpg

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
    'Pilatus U-28A Draco',
    'Pilatus U-28A Draco',
    'Pilatus U-28A Draco',
    'Pilatus U-28A Draco',
    'Monomoteur suisse d''apparence anodine, devenu l''œil des forces spéciales américaines de l''Afghanistan à l''Afrique',
    'Innocuous-looking Swiss single turboprop that became the eye of US special forces from Afghanistan to Africa',
    '/assets/airplanes/pilatus-u28a-draco.jpg',
    E'## Genèse\nEn 2005, le commandement des opérations spéciales américain (**USSOCOM**) cherche, pour les opérations Enduring Freedom et Iraqi Freedom, un avion du commerce capable d''opérer depuis des pistes courtes, non revêtues et isolées. Il choisit le **Pilatus PC-12** : les premiers exemplaires sont achetés d''occasion sur le marché privé, puis modifiés par **Sierra Nevada Corporation**. Officiellement, il s''agit de « soutien intra-théâtre », avec un ou deux pilotes et un navigateur facultatif ; en réalité, le U-28A est un moyen de renseignement, de surveillance et de reconnaissance (ISR) tactique au service des forces spéciales.\n\n## Conception\nL''équipement varie d''un avion à l''autre et reste en partie classé. Une boule électro-optique et infrarouge **MTS** sort de la queue, une tourelle **Wescam MX-15** loge dans une gondole ventrale, et une suite d''écoute localise les communications adverses ; certains avions portent un radar à synthèse d''ouverture. Treize radios, la Liaison 16 et des liaisons satellites transmettent la vidéo en temps réel aux troupes au sol, et des capteurs AN/AAR-47 avertissent l''équipage des tirs de missiles. Deux pilotes, un officier systèmes de combat et un opérateur systèmes tactiques forment l''équipage ; certains avions gardent une livrée civile pour les missions clandestines.\n\n## Carrière opérationnelle\nLe 319th Special Operations Squadron est activé le 1er octobre 2005 à Hurlburt Field et le U-28A part au combat dès juin 2006, en Afghanistan et en Irak, puis au Moyen-Orient et en Afrique. Il coordonne l''appui aérien sous l''indicatif « Warden » et traque des cibles terroristes de haute valeur. Deux accidents tuent leurs équipages, près de Djibouti en 2012 et à Clovis en 2017. Baptisé **Draco** le 19 juin 2019, il couvre en août 2021 l''évacuation de Kaboul : pris sous le feu, le pilote de « Draco 42 », **Samuel McIntyre**, à court de carburant, pose son avion dans une trouée de la foule qui couvre la piste. Dix membres d''équipage reçoivent la Distinguished Flying Cross en 2023.\n\n## Place dans l''histoire\nLe U-28A incarne l''aviation légère des guerres asymétriques, où un monomoteur civil peut tourner des heures au-dessus d''un adversaire sans défense aérienne. Sa succession reste incertaine : le remplacer par le **MC-12W Liberty** est refusé par le Congrès, l''**OA-1K Skyraider II** ne reprend qu''une partie de ses missions, et le projet de successeur direct est abandonné en juin 2026. On s''interroge aussi sur la survie de tels avions face à un adversaire de même niveau.',
    E'## Genesis\nIn 2005 US Special Operations Command (**USSOCOM**) sought, for Operations Enduring Freedom and Iraqi Freedom, a commercial aircraft able to operate from short, unpaved and remote airstrips. It chose the **Pilatus PC-12**: the first examples were bought second-hand on the private market, then modified by **Sierra Nevada Corporation**. Officially the mission was "intra-theater support", with one or two pilots and an optional navigator; in reality the U-28A is a tactical intelligence, surveillance and reconnaissance (ISR) asset for special forces.\n\n## Design\nThe equipment varies from one aircraft to the next and remains partly classified. An **MTS** electro-optical and infrared ball deploys from the tail, a **Wescam MX-15** turret sits in a belly gondola, and a signals intelligence suite geolocates enemy communications; some aircraft carry a synthetic aperture radar. Thirteen radios, Link 16 and satellite links relay full-motion video in real time to troops on the ground, and AN/AAR-47 sensors warn the crew of missile launches. Two pilots, a combat systems officer and a tactical systems operator form the crew; some aircraft keep a civilian paint scheme for clandestine missions.\n\n## Operational career\nThe 319th Special Operations Squadron was activated on 1 October 2005 at Hurlburt Field and the U-28A went to war in June 2006, in Afghanistan and Iraq, then in the Middle East and Africa. It coordinates close air support under the call sign "Warden" and hunts high-value terrorist targets. Two crashes killed their crews, near Djibouti in 2012 and at Clovis in 2017. Named **Draco** on 19 June 2019, it covered the evacuation of Kabul in August 2021: under fire and short of fuel, the pilot of "Draco 42", **Samuel McIntyre**, landed in a gap in the crowd covering the runway. Ten crew members received the Distinguished Flying Cross in 2023.\n\n## Place in history\nThe U-28A embodies the light aviation of asymmetric wars, in which a civil single-engine aircraft can orbit for hours over an enemy without air defences. Its succession remains uncertain: replacing it with the **MC-12W Liberty** was blocked by Congress, the **OA-1K Skyraider II** takes on only part of its missions, and the plan for a direct successor was dropped in June 2026. Questions also remain about whether such aircraft could survive against a peer adversary.',
    (SELECT id FROM countries WHERE code = 'CHE'),
    '2005-10-01',
    NULL,
    '2006-01-01',
    NULL,
    2778,
    (SELECT id FROM manufacturer WHERE code = 'PIL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus U-28A Draco'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Pilatus U-28A Draco'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus U-28A Draco'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Pilatus U-28A Draco'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Pilatus U-28A Draco'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.4,
  wingspan          = 16.23,
  height            = 4.25,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 4960,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-67B (1 200 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 16500000,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **U-28A** : PC-12 d''occasion modifiés par Sierra Nevada Corporation, désignation unique de la flotte quelle que soit sa configuration\n- **U-28A EQ** : configuration d''origine, avec hélice à quatre ou cinq pales et gondole ventrale selon les avions, progressivement portée au standard EQ+\n- **U-28A EQ+** : nouvelle tourelle multispectrale haute définition, alerte de proximité du sol améliorée, liaisons satellites modernisées et navigation sans GPS\n- **PC-12 des forces spéciales** : appareils non transformés, utilisés pour l''entraînement des équipages et le transport léger vers des terrains isolés',
  variants_en       = E'- **U-28A**: second-hand PC-12s modified by Sierra Nevada Corporation, a single designation for the whole fleet whatever its configuration\n- **U-28A EQ**: original configuration, with a four- or five-bladed propeller and, on some aircraft, a belly gondola, gradually brought up to EQ+ standard\n- **U-28A EQ+**: new high-definition multispectral turret, enhanced ground proximity warning, upgraded satellite links and GPS-denied navigation\n- **Special operations PC-12**: unconverted aircraft used for crew training and light transport to remote airfields',

  -- Strate 4 : qualitatif
  nickname          = 'Draco',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Pilatus_U-28_Draco',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Candin Muniz, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Pilatus U-28A Draco';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Pilatus U-28A Draco';
