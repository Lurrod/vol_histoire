-- Antonov An-178
--
-- Photo : Antonov An-178 prototype in flight (2).jpeg
--   licence CC BY-SA 3.0 — Oleg Belyakov
--   https://commons.wikimedia.org/wiki/File:Antonov_An-178_prototype_in_flight_(2).jpeg

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
    'Antonov An-178',
    'Antonov An-178',
    'Antonov An-178',
    'Antonov An-178',
    'Biréacteur de transport ukrainien conçu pour succéder aux An-12, An-26 et An-32 de l''ère soviétique',
    'Ukrainian twinjet transport designed to succeed the Soviet-era An-12, An-26 and An-32',
    '/assets/airplanes/antonov-an178.jpg',
    E'## Genèse\nEn 2009, Antonov lance sur ses fonds propres le successeur direct de ses transports de l''ère soviétique, les **An-12**, **An-26** et **An-32**, et vise au-delà des remplaçants pour des appareils comme le Transall C-160. Une étude de marché fixe la charge utile idéale entre 13 et 18 tonnes. Le projet est annoncé le 5 février 2010 et la conception détaillée commence en 2011 : le constructeur de Kiev décide de bâtir son nouvel avion sur la base de ses biréacteurs régionaux **An-148** et **An-158**, déjà produits en série.\n\n## Conception\nL''An-178 reprend de l''An-158 la pointe avant, le poste de pilotage, les panneaux d''aile, l''empennage en T et la plupart des systèmes, mais reçoit un fuselage neuf, élargi de 3,35 à 3,9 mètres, dont la soute mesure 2,75 mètres de côté. Aile haute à flèche modérée et winglets, structure en alliages d''aluminium et matériaux composites, **commandes de vol électriques** à quatre canaux avec secours mécanique : face à l''An-12, il remplace quatre moteurs par deux réacteurs Progress D-436-148FM, réduit l''équipage et l''entretien. Sa soute entièrement pressurisée accepte passagers et denrées périssables ; il emporte 18 tonnes sur 1 000 km ou 10 tonnes sur 4 000 km, ou jusqu''à 80 parachutistes.\n\n## Essais\nLe prototype sort d''usine à Kiev le 16 avril 2015 et vole le **7 mai 2015**, avec environ deux ans de retard. Il fait ses débuts occidentaux au salon du Bourget en 2015 ; en mai 2017, il totalise 115 vols d''essai et plus de 194 heures. Les commandes et lettres d''intention se succèdent, de l''Azerbaïdjan à l''Arabie saoudite, qui envisage 30 appareils, mais plusieurs sont annulées. Le marché ukrainien prend le relais : le ministère de l''Intérieur en commande 13 en juin 2019, l''armée de l''air trois fin 2020. Le premier avion de série est achevé en décembre 2021 et ses essais de certification commencent.\n\n## Place dans l''histoire\nL''An-178 est la tentative d''Antonov de remplacer par un seul biréacteur moderne la famille de transports qui avait fait sa réputation pendant la guerre froide. Concurrent potentiel de l''**Embraer KC-390**, il illustre aussi la fragilité d''un programme porté par un constructeur aux ressources limitées : annoncé pour plus de 200 exemplaires, il n''était encore, en 2021, en service dans aucune force aérienne.',
    E'## Genesis\nIn 2009 Antonov launched, with its own money, a direct successor to its Soviet-era transports, the **An-12**, **An-26** and **An-32**, also aiming to replace types such as the Transall C-160. Market research set the ideal payload at between 13 and 18 tonnes. The project was announced on 5 February 2010 and detailed design began in 2011: the Kyiv manufacturer decided to base its new aircraft on its **An-148** and **An-158** regional jets, already in production.\n\n## Design\nThe An-178 takes from the An-158 the nose section, the flight deck, the wing panels, the T-tail and most of the systems, but has a new fuselage widened from 3.35 to 3.9 metres, with a cargo hold 2.75 metres square. A high wing with moderate sweep and winglets, an aluminium-alloy and composite structure and four-channel **fly-by-wire controls** with a mechanical back-up: compared with the An-12, it replaces four engines with two Progress D-436-148FM turbofans and needs a smaller crew and less maintenance. Its fully pressurised hold accepts passengers and perishables; it carries 18 tonnes over 1,000 km or 10 tonnes over 4,000 km, or up to 80 paratroopers.\n\n## Testing\nThe prototype was rolled out in Kyiv on 16 April 2015 and flew on **7 May 2015**, some two years behind schedule. It made its Western debut at the 2015 Paris Air Show; by May 2017 it had made 115 test flights and logged more than 194 hours. Orders and letters of intent followed, from Azerbaijan to Saudi Arabia, which considered 30 aircraft, but several were cancelled. The Ukrainian market took over: the Ministry of Internal Affairs ordered 13 in June 2019 and the air force three in late 2020. The first production aircraft was completed in December 2021 and certification testing began.\n\n## Place in history\nThe An-178 is Antonov''s attempt to replace, with a single modern twinjet, the family of transports that had made its name during the Cold War. A potential competitor of the **Embraer KC-390**, it also shows the fragility of a programme carried by a manufacturer with limited resources: announced for more than 200 aircraft, it was still, in 2021, in service with no air force.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '2009-01-01',
    '2015-05-07',
    NULL,
    990,
    5300,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-178'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-178'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-178'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-178'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-178'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-178'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.23,
  wingspan          = 30.57,
  height            = 9.57,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 52400,
  service_ceiling   = 12200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Progress D-436-148FM',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 76.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2021,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **An-178** : prototype UR-EXP, premier vol le 7 mai 2015, réacteurs D-436-148FM\n- **An-178-100P** : version de série commandée à trois exemplaires par l''armée de l''air ukrainienne\n- **Version allongée** envisagée : envergure accrue, masse au décollage portée à environ 56 tonnes, réacteurs AI-28 plus puissants\n- **Versions dérivées** proposées : transport civil, recherche et sauvetage, évacuation sanitaire, situations d''urgence',
  variants_en       = E'- **An-178**: prototype UR-EXP, first flight on 7 May 2015, D-436-148FM engines\n- **An-178-100P**: production version, three ordered by the Ukrainian Air Force\n- **Stretched version** envisaged: greater span, take-off weight raised to about 56 tonnes, more powerful AI-28 engines\n- **Derived versions** proposed: civil freighter, search and rescue, medical evacuation, emergency response',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-178',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-178',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Oleg Belyakov',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Antonov An-178';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-178';
