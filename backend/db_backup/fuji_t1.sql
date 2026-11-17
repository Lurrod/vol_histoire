-- Fuji T-1 Hatsutaka
--
-- Photo : Fuji T-1A.jpg
--   licence Public domain — SDASM
--   https://commons.wikimedia.org/wiki/File:Fuji_T-1A.jpg

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
    'Fuji T-1',
    'Fuji T-1',
    'Fuji T-1 Hatsutaka',
    'Fuji T-1 Hatsutaka',
    'Premier avion à réaction de série et premier avion à aile en flèche conçus au Japon après la guerre',
    'Japan''s first production jet and first swept-wing aircraft designed after the war',
    '/assets/airplanes/fuji-t1.jpg',
    E'## Genèse\nAprès 1945, le Japon n''a plus le droit de construire ni même d''étudier des avions. L''interdiction est levée le 28 avril 1952, dans le contexte de la guerre de Corée et de la guerre froide. Au printemps 1954, l''Agence de défense annonce vouloir un avion d''école à réaction national. Le débat est vif : l''Agence et le ministère des Finances préfèrent une production sous licence, le ministère du Commerce international et de l''Industrie veut un appareil japonais pour relancer l''industrie. Au terme d''une compétition, le projet de **Fuji Heavy Industries**, héritière de **Nakajima**, est retenu.\n\n## Conception\nLe T-1 est le premier avion à réaction conçu au Japon depuis le **Nakajima Kikka** de 1945, et le premier avion japonais à **aile en flèche**. Biplace en tandem, il emporte en option une mitrailleuse de 12,7 mm dans le nez et deux missiles **AIM-9 Sidewinder** ou deux bombes sous les ailes. Le moteur devait être national : le turboréacteur **Ishikawajima-Harima J3**, lancé en 1955, prend du retard. Les premiers **T-1A** reçoivent donc un **Bristol Siddeley Orpheus** britannique ; le premier vol a lieu en janvier 1958. Les 20 **T-1B**, construits de juin 1962 à juin 1963, sont enfin propulsés par le J3.\n\n## Carrière opérationnelle\nLa force aérienne d''autodéfense prévoit d''abord plus de 200 exemplaires. Mais le rapprochement militaire avec les États-Unis change la donne : les industriels américains cèdent des licences, et le Japon achète en nombre le **Lockheed T-33A** pour l''essentiel de la formation. La production s''arrête à 66 appareils, et l''Australie, approchée, n''en commande pas. Entré en service au début des années 1960, le T-1 forme pourtant des générations de pilotes japonais. En décembre 2000, peu après l''arrivée du **Kawasaki T-4**, il cesse l''entraînement en vol ; le dernier est retiré le 3 mars 2006.\n\n## Place dans l''histoire\nLe T-1 marque la renaissance de l''aéronautique militaire japonaise : premier jet produit en série, premier avion de Fuji fabriqué en quantité, et premier couple cellule-moteur entièrement national avec le T-1B. Son destin reste celui de beaucoup d''appareils d''après-guerre, freiné par la concurrence d''avions américains moins chers. Il a ouvert la voie au T-4, autre école réalisée entièrement au Japon.',
    E'## Genesis\nAfter 1945 Japan was forbidden to build or even study aircraft. The ban was lifted on 28 April 1952, against the background of the Korean War and the Cold War. In the spring of 1954 the Defense Agency announced it wanted a domestic jet trainer. The debate was sharp: the Agency and the Ministry of Finance favoured licence production, while the Ministry of International Trade and Industry wanted a Japanese aircraft to revive the industry. After a competition, the design of **Fuji Heavy Industries**, successor to **Nakajima**, was selected.\n\n## Design\nThe T-1 was the first jet designed in Japan since the **Nakajima Kikka** of 1945, and the first Japanese aircraft with a **swept wing**. A tandem two-seater, it could optionally carry a 12.7 mm machine gun in the nose and two **AIM-9 Sidewinder** missiles or two bombs under the wings. The engine was meant to be domestic: the **Ishikawajima-Harima J3** turbojet, launched in 1955, fell behind schedule. The first **T-1A**s therefore received a British **Bristol Siddeley Orpheus**; the first flight took place in January 1958. The 20 **T-1B**s, built from June 1962 to June 1963, were at last powered by the J3.\n\n## Operational career\nThe Air Self-Defense Force initially planned more than 200 aircraft. But closer military ties with the United States changed everything: American manufacturers granted licences, and Japan bought the **Lockheed T-33A** in quantity for most of its training. Production stopped at 66, and Australia, which was approached, placed no order. Entering service in the early 1960s, the T-1 nonetheless trained generations of Japanese pilots. In December 2000, shortly after the arrival of the **Kawasaki T-4**, it ended flight training; the last was retired on 3 March 2006.\n\n## Place in history\nThe T-1 marks the rebirth of Japanese military aviation: first production jet, first Fuji design built in quantity, and with the T-1B the first fully domestic airframe-engine pairing. Its fate was that of many post-war aircraft, held back by competition from cheaper American designs. It paved the way for the T-4, another trainer built entirely in Japan.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1954-01-01',
    '1958-01-01',
    '1960-05-01',
    925,
    1300,
    (SELECT id FROM manufacturer WHERE code = 'FUJ'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-1'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Fuji T-1'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-1'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-1'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.12,
  wingspan          = 10.5,
  height            = 4.08,
  wing_area         = 22.22,
  empty_weight      = 2420,
  mtow              = 5000,
  service_ceiling   = 14400,
  climb_rate        = 33,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley Orpheus Mk 805',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.79,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = 1963,
  units_built       = 66,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **T1F1 et T1F2** : prototypes, le premier avec un réacteur national J3, les deux autres avec un Bristol Orpheus\n- **T-1A** : version de série à réacteur Bristol Siddeley Orpheus Mk 805, 46 exemplaires\n- **T-1B** : réacteur japonais Ishikawajima-Harima J3-IHI-3, 20 exemplaires construits de 1962 à 1963\n- **T-1C** : T-1B remotorisés avec le J3-IHI-7, plus puissant',
  variants_en       = E'- **T1F1 and T1F2**: prototypes, the first with a domestic J3 engine, the other two with a Bristol Orpheus\n- **T-1A**: production version with Bristol Siddeley Orpheus Mk 805 engine, 46 built\n- **T-1B**: Japanese Ishikawajima-Harima J3-IHI-3 engine, 20 built from 1962 to 1963\n- **T-1C**: T-1Bs re-engined with the more powerful J3-IHI-7',

  -- Strate 4 : qualitatif
  nickname          = 'Hatsutaka',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fuji_T-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fuji_T-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'SDASM Archives',
  image_licence     = 'Public domain'
WHERE name = 'Fuji T-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fuji T-1';
