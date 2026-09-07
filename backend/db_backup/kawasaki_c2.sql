-- Kawasaki C-2
--
-- Photo : JASDF C-2 fly over at Miho Air Base.jpg
--   licence CC BY-SA 4.0 — Hunini
--   https://commons.wikimedia.org/wiki/File%3AJASDF_C-2_fly_over_at_Miho_Air_Base.jpg

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
    'Kawasaki C-2',
    'Kawasaki C-2',
    'Kawasaki C-2',
    'Kawasaki C-2',
    'Transport japonais rapide, conçu autour d’une contrainte constitutionnelle',
    'Fast Japanese transport, designed around a constitutional constraint',
    '/assets/airplanes/kawasaki-c2.jpg',
    E'## Genèse\nLe Japon exploite des C-1 dont le rayon d''action a été délibérément **bridé à mille kilomètres** : l''article 9 de la Constitution interdisant toute capacité offensive, un transport capable d''atteindre le continent aurait été politiquement inacceptable en 1970. Trente ans plus tard, l''interprétation a évolué et le pays veut pouvoir participer aux opérations de paix de l''ONU. Kawasaki reçoit la commande en 2000.\n\n## Conception\nLe choix distinctif est **deux réacteurs seulement**, mais très gros — des CF6 d''avion de ligne long-courrier, produisant chacun vingt-sept tonnes de poussée. Le C-2 croise donc plus vite et plus haut que tout autre transport tactique, à Mach 0,8, tout en conservant une rampe arrière et l''aptitude aux terrains sommaires. La soute est plus large que celle d''un C-130 et accepte un hélicoptère Patriot ou un véhicule blindé.\n\n## Carrière opérationnelle\nEn service depuis 2016, il assure les rotations vers Djibouti, les livraisons humanitaires en Asie du Sud-Est, l''évacuation de ressortissants japonais du **Soudan en 2023** et de l''Afghanistan en 2021. La version de renseignement RC-2 surveille les approches maritimes de l''archipel, mission devenue centrale face à l''activité chinoise en mer de Chine orientale.\n\n## Place dans l''histoire\nDix-neuf exemplaires livrés, production en cours. C''est le premier avion militaire que le Japon propose activement à l''exportation depuis 1945 — les Émirats et la Nouvelle-Zélande l''ont étudié — ce qui en fait autant un marqueur politique qu''un appareil. Il partage une partie de sa cellule avec le patrouilleur maritime **P-1**, développé en parallèle pour mutualiser les coûts.',
    E'## Genesis\nJapan operated C-1s whose range had been deliberately **capped at a thousand kilometres**: with Article 9 of the Constitution barring any offensive capability, a transport able to reach the mainland would have been politically unacceptable in 1970. Thirty years on the interpretation had shifted and the country wanted to take part in UN peace operations. Kawasaki received the order in 2000.\n\n## Design\nThe distinctive choice is **only two engines**, but very large ones — long-haul airliner CF6s, each producing twenty-seven tonnes of thrust. The C-2 therefore cruises faster and higher than any other tactical transport, at Mach 0.8, while keeping a rear ramp and rough-field capability. The hold is wider than a C-130''s and takes a helicopter, a Patriot battery or an armoured vehicle.\n\n## Operational career\nIn service since 2016, it runs rotations to Djibouti, humanitarian deliveries in South-East Asia, and the evacuation of Japanese nationals from **Sudan in 2023** and Afghanistan in 2021. The RC-2 intelligence version watches the archipelago''s maritime approaches, a mission that has become central given Chinese activity in the East China Sea.\n\n## Place in history\nNineteen delivered, production continuing. It is the first military aircraft Japan has actively offered for export since 1945 — the UAE and New Zealand have studied it — which makes it as much a political marker as an aeroplane. It shares part of its airframe with the **P-1** maritime patroller, developed in parallel to share costs.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '2000-01-01',
    '2010-01-26',
    '2016-06-30',
    917.0,
    7600.0,
    (SELECT id FROM manufacturer WHERE code = 'KHI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 43.9,
  wingspan          = 44.4,
  height            = 14.2,
  wing_area         = 213.0,
  empty_weight      = 60800,
  mtow              = 141400,
  service_ceiling   = 12200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4500,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-80C2K1F',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 266.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2010,
  production_end    = NULL,
  units_built       = 19,
  unit_cost_usd     = 142000000,
  unit_cost_year    = 2020,
  operators_count   = 1,
  variants          = E'- **C-2** : version de transport standard de la force aérienne japonaise\n- **RC-2** : version de renseignement électronique, carénages latéraux caractéristiques\n- **C-2 ravitailleur** : variante à l''étude, non encore commandée\n- Développé **conjointement avec le P-1**, patrouilleur maritime partageant des éléments de cellule\n- Premier avion militaire japonais activement proposé à l''exportation depuis 1945',
  variants_en       = E'- **C-2** : the standard transport version of the Japanese air force\n- **RC-2** : signals intelligence version, with distinctive side fairings\n- **C-2 tanker** : variant under study, not yet ordered\n- Developed **alongside the P-1** maritime patroller, sharing airframe elements\n- First Japanese military aircraft actively offered for export since 1945',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Kawasaki_C-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kawasaki_C-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hunini',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Kawasaki C-2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kawasaki C-2';
