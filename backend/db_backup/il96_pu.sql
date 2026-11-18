-- Iliouchine Il-96-300PU
--
-- Photo : Il96-300pu-96016.jpg
--   licence CC BY-SA 3.0 — E233renmei
--   https://commons.wikimedia.org/wiki/File:Il96-300pu-96016.jpg

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
    'Iliouchine Il-96-300PU',
    'Ilyushin Il-96-300PU',
    'Iliouchine Il-96-300PU',
    'Ilyushin Il-96-300PU',
    'Quadriréacteur long-courrier devenu l''avion des présidents russes, de Boris Eltsine à Vladimir Poutine',
    'Four-engined long-haul jet that became the aircraft of Russia''s presidents, from Boris Yeltsin to Vladimir Putin',
    '/assets/airplanes/ilyushin-il96-300pu.jpg',
    E'## Genèse\nL''**Il-86**, gros-porteur qui représente un grand progrès technique pour l''Union soviétique, déçoit par son rayon d''action. Iliouchine étudie d''abord un Il-86D à long rayon d''action, dont la conception s''achève en 1976 avant d''être abandonnée, puis en tire l''**Il-96** : une aile plus grande, un fuselage raccourci, une avionique moderne et de nouveaux réacteurs à double flux **Aviadvigatel PS-90A**, bien plus sobres. Le prototype vole le 28 septembre 1988 à Moscou, l''avion est certifié en 1992 et Aeroflot l''exploite à partir de 1993. Il doit remplacer les Il-62 vieillissants ; il devient surtout, dans sa version **Il-96-300PU**, l''avion du président de la Russie.\n\n## Conception\nLe sigle **PU** signifie en russe « poste de commandement » (*punkt oupravlenia*) : plus qu''un avion de transport de personnalités, l''Il-96-300PU est, comme son nom l''indique, un poste de commandement volant, tiré d''une version très profondément personnalisée de l''Il-96-300. La cellule reste celle du long-courrier : quatre PS-90A de 157 kN, aile en flèche de 30° et de 60 mètres d''envergure, fuselage de 6,08 mètres de diamètre et 250 tonnes au décollage. Avec 262 passagers, l''Il-96-300 de ligne franchit environ 11 000 km, de quoi relier Moscou à la côte ouest des États-Unis.\n\n## Carrière opérationnelle\nDepuis **Boris Eltsine**, l''Il-96-300PU est l''avion principal de la flotte présidentielle russe : cinq appareils ont servi aux présidents Eltsine, **Vladimir Poutine** et **Dmitri Medvedev**, au sein d''une escadrille spéciale de la compagnie Rossiya. En 2005, un incident technique contraint Vladimir Poutine à prendre un avion de réserve lors d''une visite en Finlande ; quelques semaines plus tard, à la suite de problèmes de freinage, tous les Il-96-300 sont cloués au sol d''août à octobre, et le directeur de la production comme l''ingénieur en chef du programme sont démis de leurs fonctions. Le type n''a pourtant jamais connu d''accident mortel.\n\n## Place dans l''histoire\nIssu d''un programme commercial resté modeste — 29 Il-96 seulement construits entre 1988 et 2013 —, l''Il-96 reste en 2026 le principal avion présidentiel russe. Son rôle s''étend même au commandement militaire : un Il-96-400 modifié, l''**Il-96-400VPU**, est en cours de conversion en poste de commandement aéroporté pour les forces aérospatiales, afin de remplacer les **Il-80**. Le dirigeant cubain voyage lui aussi en Il-96-300.',
    E'## Genesis\nThe **Il-86**, a wide-body that represented a huge technological advance for the Soviet Union, disappointed with its range. Ilyushin first studied a long-range Il-86D, whose design was completed in 1976 before being cancelled, and then derived the **Il-96** from it: a larger wing, a shorter fuselage, modern avionics and new, far more economical **Aviadvigatel PS-90A** high-bypass turbofans. The prototype flew on 28 September 1988 in Moscow, the aircraft was certified in 1992 and Aeroflot flew it from 1993. It was meant to replace the ageing Il-62s; above all, in its **Il-96-300PU** version, it became the aircraft of the President of Russia.\n\n## Design\nThe letters **PU** stand in Russian for "command post" (*punkt upravleniya*): more than a VIP transport, the Il-96-300PU is, as its name says, a flying command post, derived from a very highly customised version of the Il-96-300. The airframe remains that of the long-haul airliner: four 157 kN PS-90As, a wing swept at 30° spanning 60 metres, a 6.08-metre diameter fuselage and a 250-tonne take-off weight. With 262 passengers, the airline Il-96-300 covers about 11,000 km, enough to link Moscow with the US West Coast.\n\n## Operational career\nSince **Boris Yeltsin**, the Il-96-300PU has been the main aircraft of the Russian presidential fleet: five aircraft have served Presidents Yeltsin, **Vladimir Putin** and **Dmitry Medvedev**, with a special squadron of Rossiya Airlines. In 2005 a technical glitch forced Vladimir Putin to take a back-up aircraft during a visit to Finland; a few weeks later, following braking problems, all Il-96-300s were grounded from August to October, and the production director and the programme''s chief engineer were dismissed. The type has nevertheless never suffered a fatal accident.\n\n## Place in history\nBorn of a commercial programme that remained modest — only 29 Il-96s were built between 1988 and 2013 — the Il-96 remains in 2026 the main Russian presidential aircraft. Its role even extends to military command: a modified Il-96-400, the **Il-96-400VPU**, is being converted into an airborne command post for the Aerospace Forces to replace the **Il-80**s. The Cuban leadership also travels in an Il-96-300.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1988-09-28',
    NULL,
    870,
    11000,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-96-300PU'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-96-300PU'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-96-300PU'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 55.35,
  wingspan          = 60.12,
  height            = 17.55,
  wing_area         = 350,
  empty_weight      = 120400,
  mtow              = 250000,
  service_ceiling   = 13100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel PS-90A',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 156.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Il-96-300** : long-courrier de base, réacteurs PS-90A, premier vol le 28 septembre 1988\n- **Il-96-300PU** : avion présidentiel à poste de commandement, exploité par l''escadrille spéciale de Rossiya\n- **Il-96-400VPU** : Il-96-400 converti en poste de commandement aéroporté (projet Zveno-3S) pour remplacer les Il-80\n- **Il-96-400TZ** : ravitailleur commandé à deux exemplaires par le ministère de la Défense en 2015, contrat annulé en 2018',
  variants_en       = E'- **Il-96-300**: baseline long-haul airliner, PS-90A engines, first flight on 28 September 1988\n- **Il-96-300PU**: presidential aircraft with a command post, operated by Rossiya''s special squadron\n- **Il-96-400VPU**: Il-96-400 converted into an airborne command post (Project Zveno-3S) to replace the Il-80s\n- **Il-96-400TZ**: tanker, two ordered by the Ministry of Defence in 2015, contract cancelled in 2018',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-96',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-96',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'E233renmei',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Iliouchine Il-96-300PU';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-96-300PU';
