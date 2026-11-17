-- Convair XB-46
--
-- Photo : Convair XB-46 in flight 061023-F-1234S-023.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Convair_XB-46_in_flight_061023-F-1234S-023.jpg

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
    'Convair XB-46',
    'Convair XB-46',
    'Convair XB-46',
    'Convair XB-46',
    'Un fuseau d''aluminium aux commandes pneumatiques, déjà dépassé avant la fin de ses essais',
    'A slender aluminium spindle with pneumatic controls, obsolete before its tests were over',
    '/assets/airplanes/xb46.jpg',
    E'## Genèse\nEn 1944, informé des progrès allemands, le département de la Guerre américain lance un appel d''offres pour des bombardiers moyens à réaction de 36 à plus de 90 tonnes. Il en sort une génération qu''on surnommera la « classe de 45 » : le **North American XB-45**, le **Martin XB-48** et le Convair XB-46. Une lettre-contrat est signée avec Convair le 17 janvier 1945, et trois prototypes sont commandés le 27 février. À l''automne 1945, faute de crédits pour deux programmes, Convair propose d''achever un seul XB-46 dépouillé de son armement, les deux autres étant remplacés par un projet d''avion d''attaque à aile en flèche inversée, le XA-44, lui-même annulé en décembre 1946.\n\n## Conception\nLe XB-46 est d''une rare élégance : un long fuselage ovale en forme de torpille, une aile droite très effilée d''allongement 11,6 et quatre turboréacteurs **Allison J35** groupés par paires dans deux nacelles sous la voilure. Les deux pilotes sont assis en tandem sous une verrière de chasseur, le bombardier-navigateur dans un nez vitré. Des volets Fowler couvrent 90 % de l''envergure, et des spoilers en alliage de magnésium perforé suppléent de très petits ailerons. Surtout, les commandes de vol, le train, les freins et la soute sont actionnés par un **système pneumatique**, et non hydraulique comme sur la plupart des avions de l''époque. La version de série aurait reçu des réacteurs J47 et une tourelle de queue à deux mitrailleuses de 12,7 mm.\n\n## Essais\nAprès un mois d''essais de roulage, le XB-46 décolle le 2 avril 1947 de l''usine Convair de San Diego pour un vol de 90 minutes vers Muroc ; le pilote en loue la maniabilité. En cinq mois, il accumule 127 heures de vol en 64 vols. La stabilité est excellente, mais le dégivrage, la climatisation et des oscillations dues à une résonance entre l''aile et les spoilers posent problème. Le programme est annulé dès août 1947, avant même la fin des essais : le **B-45**, plus avancé, est déjà commandé, et le radar de tir prévu aurait imposé de redessiner le fin fuselage.\n\n## Place dans l''histoire\nLivré à l''US Air Force en novembre 1947, l''unique XB-46 vole encore 44 heures en Floride jusqu''en 1949 pour étudier le bruit et les vibrations, puis sert en 1950 à tester son système pneumatique dans la chambre climatique d''Eglin. Son nez est envoyé au musée de l''US Air Force en janvier 1951 et le reste ferraillé en février 1952. Témoin d''une époque où l''on greffait des réacteurs sur des formes de la guerre, il fut balayé, comme toute la classe de 45, par l''aile en flèche du **B-47 Stratojet**.',
    E'## Genesis\nIn 1944, aware of German advances, the US War Department called for jet medium bombers weighing from 36 to over 90 tonnes. The result was a generation later nicknamed the Class of ''45: the **North American XB-45**, the **Martin XB-48** and the Convair XB-46. A letter contract was signed with Convair on 17 January 1945, and three prototypes were ordered on 27 February. In autumn 1945, lacking funds for two programmes, Convair offered to complete a single XB-46 stripped of armament, the other two being replaced by a forward-swept-wing attack design, the XA-44, itself cancelled in December 1946.\n\n## Design\nThe XB-46 was strikingly elegant: a long, oval, torpedo-shaped fuselage, a very slender straight wing with an aspect ratio of 11.6, and four **Allison J35** turbojets paired in two underwing nacelles. The two pilots sat in tandem under a fighter-style canopy, with the bombardier-navigator in a glazed nose. Fowler flaps covered 90 per cent of the span, and perforated magnesium-alloy spoilers supplemented very small ailerons. Above all, the flight controls, undercarriage, brakes and bomb bay were driven by a **pneumatic system** rather than the hydraulics of most aircraft of the day. The production version would have had J47 engines and a tail turret with two 12.7 mm machine guns.\n\n## Testing\nAfter a month of taxi trials, the XB-46 took off on 2 April 1947 from Convair''s San Diego plant for a 90-minute flight to Muroc; the pilot praised its handling. Over five months it logged 127 hours in 64 flights. Stability was excellent, but engine de-icing, the cabin air system and oscillations caused by resonance between the wing and spoilers caused trouble. The programme was cancelled as early as August 1947, before testing was even complete: the more advanced **B-45** was already on order, and the planned fire-control radar would have forced a redesign of the slim fuselage.\n\n## Place in history\nDelivered to the US Air Force in November 1947, the sole XB-46 flew another 44 hours in Florida until 1949 to investigate noise and vibration, then was used in 1950 to test its pneumatic system in Eglin''s climatic hangar. Its nose went to the US Air Force Museum in January 1951 and the rest was scrapped in February 1952. A witness to an era when jet engines were grafted onto wartime shapes, it was swept aside, like the whole Class of ''45, by the swept wing of the **B-47 Stratojet**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-17',
    '1947-04-02',
    NULL,
    877,
    4620,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XB-46'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Convair XB-46'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 32.23,
  wingspan          = 34.44,
  height            = 8.51,
  wing_area         = 119.4,
  empty_weight      = 21781,
  mtow              = 43363,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J35 (construit par Chevrolet)',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XB-46** : prototype unique (45-59582), achevé sans armement ni équipement opérationnel\n- **Deux autres XB-46** : commandés en février 1945, abandonnés au profit de deux XA-44\n- **XA-44** : projet d''avion d''attaque à aile en flèche inversée, annulé en décembre 1946 avant achèvement\n- **B-46 de série** : prévu avec réacteurs J47 et tourelle de queue Emerson à deux mitrailleuses, jamais commandé',
  variants_en       = E'- **XB-46**: sole prototype (45-59582), completed without armament or operational equipment\n- **Two further XB-46s**: ordered in February 1945, dropped in favour of two XA-44s\n- **XA-44**: forward-swept-wing attack aircraft project, cancelled in December 1946 before completion\n- **Production B-46**: planned with J47 engines and an Emerson tail turret with two machine guns, never ordered',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_XB-46',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_XB-46',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Convair XB-46';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair XB-46';
