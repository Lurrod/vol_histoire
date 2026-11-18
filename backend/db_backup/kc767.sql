-- Boeing KC-767A / KC-767J
--
-- Photo : Boeing KC-767A (9423898444).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford and Largs, United Kingdom
--   https://commons.wikimedia.org/wiki/File:Boeing_KC-767A_(9423898444).jpg

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
    'Boeing KC-767',
    'Boeing KC-767',
    'Boeing KC-767A / KC-767J',
    'Boeing KC-767A / KC-767J',
    'Ravitailleur tiré du Boeing 767, perdu par l''US Air Force sur un scandale puis sauvé par l''Italie et le Japon',
    'Boeing 767-based tanker lost by the US Air Force to a scandal, then saved by Italy and Japan',
    '/assets/airplanes/boeing-kc767.jpg',
    E'## Genèse\nAu début des années 2000, les coûts d''entretien des plus vieux **KC-135E** de l''US Air Force s''envolent. En 2002, l''Air Force négocie la location d''une centaine de ravitailleurs tirés du **Boeing 767-200ER**, jugés moins risqués que le concurrent d''Airbus, et l''avion reçoit la désignation **KC-767A**. Le projet tourne au scandale : en décembre 2003, il est gelé après la découverte des négociations d''embauche menées avec Boeing par **Darleen Druyun**, ancienne responsable des achats du Pentagone, condamnée à neuf mois de prison. Le directeur financier de Boeing est condamné, son PDG démissionne, et le contrat est annulé en janvier 2006.\n\n## Conception\nBoeing poursuit le développement, financé en grande partie sur ses fonds propres. Les 767-200ER sont construits comme des avions de ligne, puis transformés à Naples par Aeronavali et à Wichita. Le KC-767 italien emporte une perche rigide télescopique à commandes électriques et des nacelles de ravitaillement par tuyau et panier sous les ailes ; le KC-767J japonais n''a que la perche. L''opérateur ne s''allonge plus à l''arrière comme sur le KC-135 : il guide la perche depuis un poste équipé d''un écran vidéo. L''avion emporte aussi jusqu''à 200 passagers ou 19 palettes.\n\n## Carrière opérationnelle\nLe premier KC-767 italien vole le 21 mai 2005, et le 23 janvier 2007 l''avion d''essais réalise son premier contact avec un **B-52**. Le Japon, qui l''a préféré à l''A310 MRTT, reçoit son premier KC-767J le 19 février 2008 ; ses quatre appareils servent au 404e escadron de Komaki. Retardés par des vibrations des nacelles d''aile, les quatre italiens entrent en service le 17 mai 2011 au 14e Stormo et appuient aussitôt les opérations de l''OTAN en Afghanistan et en Libye. Israel Aerospace Industries convertit en outre un 767 d''occasion pour la Colombie, livré en novembre 2010.\n\n## Place dans l''histoire\nÀ l''export, le KC-767 s''incline face à l''**Airbus A330 MRTT** en Australie, qui lui préfère en 2004 sa plus grande capacité en carburant et en fret, puis au Royaume-Uni, où l''offre montée avec BAE Systems et British Airways est écartée la même année. Mais il prend sa revanche aux États-Unis : le 24 février 2011, une nouvelle version proposée par Boeing remporte le programme KC-X de l''US Air Force et devient le **KC-46 Pegasus**, que le Japon commande à son tour en 2018.',
    E'## Genesis\nIn the early 2000s the maintenance costs of the US Air Force''s oldest **KC-135Es** soared. In 2002 the Air Force negotiated the lease of about a hundred tankers derived from the **Boeing 767-200ER**, judged less risky than the Airbus rival, and the aircraft received the designation **KC-767A**. The project turned into a scandal: in December 2003 it was frozen after it emerged that **Darleen Druyun**, a former Pentagon procurement official, had negotiated a job with Boeing; she was sentenced to nine months in prison. Boeing''s chief financial officer was jailed, its CEO resigned, and the contract was cancelled in January 2006.\n\n## Design\nBoeing pressed on with development, largely at its own expense. The 767-200ERs were built as airliners, then converted in Naples by Aeronavali and in Wichita. The Italian KC-767 carries a fly-by-wire telescoping boom and underwing hose-and-drogue pods; the Japanese KC-767J has only the boom. The operator no longer lies prone at the rear as on the KC-135: he guides the boom from a remote station with a video display. The aircraft can also carry up to 200 passengers or 19 pallets.\n\n## Operational career\nThe first Italian KC-767 flew on 21 May 2005, and on 23 January 2007 the test aircraft made its first contact with a **B-52**. Japan, which preferred it to the A310 MRTT, received its first KC-767J on 19 February 2008; its four aircraft serve with the 404th Squadron at Komaki. Delayed by wing pod flutter, the four Italian aircraft entered service on 17 May 2011 with the 14º Stormo and promptly supported NATO operations in Afghanistan and Libya. Israel Aerospace Industries also converted a second-hand 767 for Colombia, delivered in November 2010.\n\n## Place in history\nOn the export market the KC-767 lost to the **Airbus A330 MRTT** in Australia, which preferred its greater fuel and cargo capacity in 2004, then in the United Kingdom, where the bid put together with BAE Systems and British Airways was turned down the same year. But it took its revenge at home: on 24 February 2011 a new version offered by Boeing won the US Air Force''s KC-X programme and became the **KC-46 Pegasus**, which Japan in turn ordered in 2018.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2002-01-01',
    '2005-05-21',
    '2008-02-19',
    915,
    12200,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Boeing KC-767'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 48.5,
  wingspan          = 47.6,
  height            = 15.8,
  wing_area         = NULL,
  empty_weight      = 82377,
  mtow              = 179169,
  service_ceiling   = 12200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-80C2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 267.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2003,
  production_end    = NULL,
  units_built       = 9,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **KC-767A** : version prévue pour l''US Air Force, commande annulée ; quatre appareils à perche et nacelles de voilure construits pour l''Italie\n- **KC-767J** : version japonaise à perche seule, quatre exemplaires livrés de 2008 à 2010\n- **KC-767 MMTT** : 767 d''occasion converti par Israel Aerospace Industries, un exemplaire livré à la Colombie en novembre 2010\n- **KC-X2** : 767-300ER à convertir par IAI pour la force aérienne brésilienne, projet abandonné\n- **KC-46A** : dérivé du 767-2C retenu en 2011 par l''US Air Force, devenu le KC-46 Pegasus',
  variants_en       = E'- **KC-767A**: version planned for the US Air Force, order cancelled; four aircraft with boom and wing pods built for Italy\n- **KC-767J**: Japanese boom-only version, four delivered from 2008 to 2010\n- **KC-767 MMTT**: second-hand 767 converted by Israel Aerospace Industries, one delivered to Colombia in November 2010\n- **KC-X2**: 767-300ER to be converted by IAI for the Brazilian Air Force, project abandoned\n- **KC-46A**: 767-2C derivative selected by the US Air Force in 2011, which became the KC-46 Pegasus',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_KC-767',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_KC-767',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Boeing KC-767';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing KC-767';
