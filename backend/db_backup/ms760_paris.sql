-- Morane-Saulnier MS.760 Paris
--
-- Photo : MORASNE SAULNIER PARIS PARISAIRLEGEND 2018 (31283591868).jpg
--   licence CC BY-SA 2.0 — ERIC SALARD from PARIS, FRANCE
--   https://commons.wikimedia.org/wiki/File:MORASNE_SAULNIER_PARIS_PARISAIRLEGEND_2018_(31283591868).jpg

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
    'Morane-Saulnier MS.760 Paris',
    'Morane-Saulnier MS.760 Paris',
    'Morane-Saulnier MS.760 Paris',
    'Morane-Saulnier MS.760 Paris',
    'Biréacteur quadriplace d''école et de liaison, né d''un échec face au Magister et pionnier de l''avion d''affaires',
    'Four-seat twin-jet trainer and liaison aircraft, born of defeat by the Magister and a business jet pioneer',
    '/assets/airplanes/ms760-paris.jpg',
    E'## Genèse\nAu début des années 1950, l''armée de l''air cherche un avion d''école à réaction pour la formation initiale. **Morane-Saulnier** propose le **MS.755 Fleuret**, biplace côte à côte qui vole le 26 janvier 1953, mais l''État lui préfère le **Fouga Magister**. Plutôt que d''abandonner, la firme transforme le deuxième prototype en quadriplace de liaison rapide : le Fleuret II, rebaptisé **MS.760 Paris**. Le premier vole le 29 juillet 1954 à Melun-Villaroche ; deux mois plus tard, il relie Villacoublay à Alger et revient dans la journée, à plus de 530 km/h de moyenne.\n\n## Conception\nLe Paris garde l''aile basse et les qualités de vol du Fleuret, mais ajoute une seconde rangée de deux sièges sous une grande verrière d''une seule pièce, dans une cabine pressurisée et climatisée. Deux petits turboréacteurs **Turbomeca Marboré** sont logés côte à côte dans l''arrière du fuselage, sous un empennage en T ; selon le bureau d''études, il aurait fallu un turbopropulseur de 2 000 ch pour faire aussi bien. Volets, aérofrein et train tricycle sont manœuvrés électriquement, et l''empennage se démonte entier pour accéder aux moteurs. L''appareil peut recevoir des mitrailleuses, des roquettes et de petites bombes : il reste un avion d''école autant qu''un avion de liaison.\n\n## Carrière opérationnelle\nL''armée de l''air et la Marine commandent 50 appareils dès 1956 ; le premier est livré le 9 février 1959 à l''aéronautique navale, qui l''emploie quarante ans à la liaison et à l''entraînement au vol sans visibilité des pilotes de **Super Étendard** et de **F-8 Crusader**, jusqu''à son retrait à Landivisiau en octobre 1997. L''Argentine en reçoit 48, dont 36 assemblés sur place par la FMA, et s''en sert pour bombarder les rebelles lors de la révolte de la marine argentine en 1963 ; elle le garde jusqu''en 2007. Le Brésil en exploite aussi. En 1962, le patron de l''ENI, **Enrico Mattei**, meurt dans le crash de son Paris près de Milan.\n\n## Place dans l''histoire\nAvec Beechcraft, Morane-Saulnier tente dès 1955 de vendre le Paris comme premier jet d''affaires sur le marché nord-américain, sans succès face aux Lockheed JetStar et Sabreliner. Il reste l''un des rares biréacteurs à quatre places et l''un des tout premiers avions à réaction légers. En 2009, une société américaine rachète le certificat de type et plusieurs dizaines de cellules réformées pour les remettre en vol.',
    E'## Genesis\nIn the early 1950s the French Air Force sought a jet trainer for initial training. **Morane-Saulnier** proposed the **MS.755 Fleuret**, a side-by-side two-seater that flew on 26 January 1953, but the state chose the **Fouga Magister** instead. Rather than give up, the firm turned the second prototype into a fast four-seat liaison aircraft: the Fleuret II, renamed **MS.760 Paris**. It first flew on 29 July 1954 at Melun-Villaroche; two months later it flew from Villacoublay to Algiers and back in a single day, averaging more than 530 km/h.\n\n## Design\nThe Paris kept the Fleuret''s low wing and flying qualities but added a second row of two seats under a large one-piece canopy, in a pressurised and air-conditioned cabin. Two small **Turbomeca Marboré** turbojets sat side by side in the rear fuselage, under a T-tail; according to the design office, a 2,000 hp turboprop would have been needed to match them. Flaps, airbrake and tricycle undercarriage were electrically operated, and the whole tail unit came off for engine access. The aircraft could carry machine guns, rockets and small bombs: it remained a trainer as much as a liaison aircraft.\n\n## Operational career\nThe French Air Force and Navy ordered 50 aircraft in 1956; the first was delivered on 9 February 1959 to naval aviation, which used it for forty years for liaison and for instrument flight training of **Super Étendard** and **F-8 Crusader** pilots, until its retirement at Landivisiau in October 1997. Argentina received 48, including 36 assembled locally by FMA, and used them to bomb rebels during the 1963 Argentine Navy revolt; it kept them until 2007. Brazil also operated it. In 1962 the head of ENI, **Enrico Mattei**, died in the crash of his Paris near Milan.\n\n## Place in history\nWith Beechcraft, Morane-Saulnier tried from 1955 to sell the Paris as the first business jet in North America, without success against the Lockheed JetStar and the Sabreliner. It remains one of the rare four-seat twin jets and one of the very first light jets. In 2009 an American company bought the type certificate and several dozen retired airframes to return them to flight.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1953-01-01',
    '1954-07-29',
    '1959-02-09',
    650,
    1500,
    (SELECT id FROM manufacturer WHERE code = 'MS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.760 Paris'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.760 Paris'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.760 Paris'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.05,
  wingspan          = 10.15,
  height            = 2.6,
  wing_area         = 18.0,
  empty_weight      = 1945,
  mtow              = 3470,
  service_ceiling   = 10000,
  climb_rate        = 11.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Marboré II',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 3.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = NULL,
  units_built       = 219,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **MS.755 Fleuret** : biplace d''école à l''origine du Paris, battu par le Fouga Magister\n- **MS.760 Paris I** : version initiale à deux réacteurs Marboré II de 400 kgp\n- **MS.760B Paris II** : Marboré VI de 480 kgp, réservoirs dans le bord d''attaque, climatisation et soute agrandie ; premier vol le 12 décembre 1960\n- **MS.760C Paris III** : version à six places, un seul prototype en 1964\n- **C-41** : désignation brésilienne du MS.760A',
  variants_en       = E'- **MS.755 Fleuret**: two-seat trainer from which the Paris derived, beaten by the Fouga Magister\n- **MS.760 Paris I**: initial version with two 400 kgf Marboré II engines\n- **MS.760B Paris II**: 480 kgf Marboré VI engines, leading-edge fuel tanks, air conditioning and larger baggage hold; first flight on 12 December 1960\n- **MS.760C Paris III**: six-seat version, a single prototype in 1964\n- **C-41**: Brazilian designation of the MS.760A',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Morane-Saulnier_MS.760_Paris',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Morane-Saulnier_MS.760_Paris',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Eric Salard',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Morane-Saulnier MS.760 Paris';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Morane-Saulnier MS.760 Paris';
