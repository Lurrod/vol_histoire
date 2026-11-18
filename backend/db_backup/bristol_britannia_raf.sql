-- Bristol Type 175 Britannia C.1 / C.2
--
-- Photo : Bristol Britannia 253 ‘XM496 496’ “Regulus” (51855207829).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Bristol_Britannia_253_%E2%80%98XM496_496%E2%80%99_%E2%80%9CRegulus%E2%80%9D_(51855207829).jpg

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
    'Bristol Britannia',
    'Bristol Britannia',
    'Bristol Type 175 Britannia C.1 / C.2',
    'Bristol Type 175 Britannia C.1 / C.2',
    'Le « géant qui chuchote », premier turbopropulseur du Transport Command de la RAF',
    'The ''Whispering Giant'', RAF Transport Command''s first turboprop',
    '/assets/airplanes/bristol-britannia.jpg',
    E'## Genèse\nLe Britannia répond à la spécification C.2/47, publiée en avril 1947 pour le réseau impérial moyen-courrier de la **BOAC**. Dessiné par l''équipe d''**Archibald Russell**, le Type 175 abandonne vite les moteurs à pistons Centaurus au profit des turbopropulseurs **Bristol Proteus**. Le prototype G-ALBO, piloté par **Bill Pegg**, vole à Filton le 16 août 1952, mais la mise au point s''éternise : perte du deuxième prototype en 1954 après un feu de moteur, puis givrage des entrées d''air découvert au moment des premières livraisons. Le Britannia n''entre en service commercial qu''en février 1957, quand les avions de ligne à réaction sont sur le point d''arriver.\n\n## Conception\nC''est un quadriturbopropulseur pressurisé, si discret vu de l''extérieur qu''on le surnomme « le géant qui chuchote ». Sa série 200 avait été dessinée comme un avion mixte passagers et fret pour les compagnies ; Bristol la propose finalement à la Royal Air Force. Les trois **Model 252**, devenus Britannia C.2, reçoivent un plancher renforcé à l''avant et une porte cargo ; les vingt **Model 253**, ou C.1, ont un plancher renforcé sur toute la longueur et des sièges tournés vers l''arrière, comme les préfère la RAF, pour 115 soldats ou un chargement équivalent.\n\n## Carrière opérationnelle\nAchetés en 1959 par le **Transport Command**, les Britannia sont ses premiers turbopropulseurs ; ils équipent les 99e et 511e escadrons, à Brize Norton et à Lyneham, et portent des noms d''étoiles comme *Arcturus*, *Sirius* ou *Vega*. Ils emmènent des casques bleus au Congo en juillet 1960, de l''aide humanitaire au Belize après un ouragan à la fin de 1961, et participent en 1967 à l''évacuation des troupes britanniques d''**Aden** ; le 12 octobre 1967, *Sirius* est détruit après une sortie de piste à Khormaksar. En 1972, XM496 *Regulus* transporte une partie du trésor de **Toutânkhamon**, dont le masque d''or, pour une exposition au British Museum.\n\n## Place dans l''histoire\nLa RAF retire ses Britannia en 1975, le **Vickers VC10** étant devenu son principal transport stratégique ; les appareils encore jeunes passent aux transporteurs de fret civils, retrouvant le rôle mixte imaginé pour la série 200. Retardé par sa mise au point, le Britannia n''est construit qu''à 85 exemplaires, mais sa cellule engendre au Canada le **Canadair CP-107 Argus** et le **Canadair CC-106 Yukon**. Le tout dernier vol d''un Britannia, en 1997, ramène *Regulus* à l''aérodrome de Cotswold, où il porte de nouveau les couleurs de la RAF.',
    E'## Genesis\nThe Britannia answered Specification C.2/47, issued in April 1947 for **BOAC**''s medium-range Empire routes. Designed by **Archibald Russell**''s team, the Type 175 soon dropped Centaurus piston engines in favour of **Bristol Proteus** turboprops. The prototype G-ALBO, flown by **Bill Pegg**, took off from Filton on 16 August 1952, but development dragged on: the second prototype was lost in 1954 after an engine fire, then engine inlet icing was discovered just as the first aircraft were being delivered. The Britannia only entered airline service in February 1957, when jet airliners were about to arrive.\n\n## Design\nIt was a pressurised four-engined turboprop, so quiet from outside that it became known as the ''Whispering Giant''. Its 200 series had been designed as a mixed passenger and freight aircraft for the airlines; Bristol ended up offering it to the Royal Air Force. The three **Model 252s**, which became Britannia C.2s, had a heavy-duty floor in the forward fuselage and a cargo door; the twenty **Model 253s**, or C.1s, had a full-length heavy-duty floor and rearward-facing seats, as the RAF preferred, for 115 troops or the equivalent in cargo.\n\n## Operational career\nPurchased in 1959 by **Transport Command**, the Britannias were its first turboprops; they equipped Nos. 99 and 511 Squadrons at Brize Norton and Lyneham, and were named after stars such as *Arcturus*, *Sirius* and *Vega*. They carried peacekeepers to the Congo in July 1960 and humanitarian aid to Belize after a hurricane at the end of 1961, and took part in the evacuation of British troops from **Aden** in 1967; on 12 October 1967 *Sirius* was written off after overrunning the runway at Khormaksar. In 1972 XM496 *Regulus* carried part of the treasure of **Tutankhamun**, including the gold mask, for an exhibition at the British Museum.\n\n## Place in history\nThe RAF retired its Britannias in 1975, the **Vickers VC10** having become its main strategic transport; the aircraft that still had hours left went to civil cargo operators, returning to the mixed role imagined for the 200 series. Held back by its protracted development, the Britannia was built in only 85 examples, but its airframe gave rise in Canada to the **Canadair CP-107 Argus** and **Canadair CC-106 Yukon**. The very last Britannia flight, in 1997, brought *Regulus* to Cotswold Airport, where it once again wears RAF colours.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1947-04-01',
    '1952-08-16',
    '1960-03-01',
    639,
    7129,
    (SELECT id FROM manufacturer WHERE code = 'BRI'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol Britannia'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol Britannia'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol Britannia'), (SELECT id FROM wars WHERE name = 'Crise congolaise')),
((SELECT id FROM airplanes WHERE name = 'Bristol Britannia'), (SELECT id FROM wars WHERE name = 'Urgence d''Aden'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 37.87,
  wingspan          = 43.36,
  height            = 11.43,
  wing_area         = 192.8,
  empty_weight      = 39190,
  mtow              = 83915,
  service_ceiling   = 7315,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Proteus 765 (4 450 ch équivalents)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = 1960,
  units_built       = 23,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Britannia C.1 (Model 253)** : version passagers-fret de la RAF, plancher renforcé sur toute la longueur, 115 soldats, vingt exemplaires\n- **Britannia C.2 (Model 252)** : commandée par le ministère de l''Approvisionnement pour des affréteurs, livrée à la RAF avec plancher renforcé à l''avant et porte cargo, trois exemplaires\n- **Séries 100 et 300** : versions civiles de la BOAC et des compagnies étrangères ; la série 310 ouvre la ligne Londres-New York\n- **Série 253F** : C.1 revendus comme cargos aux compagnies civiles après leur retrait de la RAF\n- **Canadair CP-107 Argus et CC-106 Yukon** : dérivés canadiens construits sous licence',
  variants_en       = E'- **Britannia C.1 (Model 253)**: RAF passenger/freight version, full-length heavy-duty floor, 115 troops, twenty built\n- **Britannia C.2 (Model 252)**: ordered by the Ministry of Supply for charter operators, delivered to the RAF with a forward heavy-duty floor and cargo door, three built\n- **Series 100 and 300**: civil versions for BOAC and foreign airlines; the 310 series opened the London-New York route\n- **Series 253F**: C.1s sold on to civil cargo operators after RAF retirement\n- **Canadair CP-107 Argus and CC-106 Yukon**: Canadian licence-built derivatives',

  -- Strate 4 : qualitatif
  nickname          = 'Whispering Giant',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bristol_Britannia',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bristol_Britannia',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Bristol Britannia';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bristol Britannia';
