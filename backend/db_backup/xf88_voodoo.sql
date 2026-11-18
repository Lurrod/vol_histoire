-- McDonnell XF-88 Voodoo
--
-- Photo : McDonnell XF-88 (SN 46-525) in flight 060728-F-1234S-037.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:McDonnell_XF-88_(SN_46-525)_in_flight_060728-F-1234S-037.jpg

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
    'McDonnell XF-88 Voodoo',
    'McDonnell XF-88 Voodoo',
    'McDonnell XF-88 Voodoo',
    'McDonnell XF-88 Voodoo',
    'Chasseur d''escorte biréacteur vainqueur d''un concours annulé, matrice du F-101 Voodoo',
    'Twin-jet escort fighter that won a cancelled competition and became the template for the F-101 Voodoo',
    '/assets/airplanes/xf88-voodoo.jpg',
    E'## Genèse\nEn 1946, l''**US Army Air Forces** réclame un « chasseur de pénétration » à long rayon d''action, capable d''escorter les bombardiers jusqu''à leurs cibles : en somme un **P-51 Mustang** à réaction, avec un rayon de combat de 1 450 km. McDonnell entame l''étude de son **Model 36** le 1er avril 1946 et obtient le 20 juin un contrat pour deux prototypes, désignés XP-88. **Dave Lewis** dirige l''aérodynamique du projet. Les prototypes, qui n''ont pas encore volé, deviennent XF-88 le 1er juillet 1948 et reçoivent le surnom de Voodoo.\n\n## Conception\nLe dessin initial, à aile droite et empennage en V, ne résiste pas à la soufflerie : l''avion reçoit un empennage classique et une **aile en flèche à 35°**. Les deux réacteurs **Westinghouse J34** sont logés dans le bas du fuselage, alimentés par des entrées d''air à l''emplanture des ailes, leurs tuyères débouchant sous l''arrière du fuselage ; le long fuselage reste ainsi libre pour le carburant qu''exige l''autonomie demandée. Le nez court, sans radar, doit accueillir six canons **M39** de 20 mm. Le pilote dispose d''une cabine pressurisée et d''un siège éjectable.\n\n## Essais\nLe premier XF-88 vole le 20 octobre 1948 à Muroc, aux mains du chef pilote d''essai **Robert Edholm**, sans armement et avec des J34 dépourvus de postcombustion. L''endurance est au rendez-vous, mais l''avion manque de puissance : à 1 032 km/h au niveau de la mer, il est moins rapide que le F-86A déjà en production. McDonnell dessine alors ses propres postcombustions ; le second prototype, XF-88A, vole le 26 avril 1949 et atteint 1 126 km/h, au prix d''une autonomie réduite. Le Voodoo l''emporte malgré tout sur le **Lockheed XF-90** et le North American YF-93, mais l''évolution des priorités de l''Air Force et le manque de crédits font annuler le programme en août 1950.\n\n## Place dans l''histoire\nLe premier prototype devient le **XF-88B**, banc d''essai d''hélices doté d''un turbopropulseur Allison T38 dans le nez, en plus de ses réacteurs. Jusqu''en 1956, il essaie trois hélices et devient le premier avion à hélice à dépasser Mach 1, en piqué. Les deux appareils sont ferraillés en 1958. Mais la guerre de Corée ramène l''Air Force à l''idée d''un chasseur à long rayon d''action : en 1951, une version très agrandie du dessin est retenue pour le besoin **GOR 101** et devient le **F-101 Voodoo**, dont le premier exemplaire de série vole le 29 septembre 1954.',
    E'## Genesis\nIn 1946 the **US Army Air Forces** called for a long-range ''penetration fighter'' able to escort bombers all the way to their targets: in effect a jet-powered **P-51 Mustang**, with a combat radius of 1,450 km. McDonnell began work on its **Model 36** on 1 April 1946 and on 20 June won a contract for two prototypes, designated XP-88. **Dave Lewis** led the project''s aerodynamics. The prototypes, not yet flown, became XF-88s on 1 July 1948 and took the nickname Voodoo.\n\n## Design\nThe original layout, with straight wings and a V-tail, did not survive the wind tunnel: the aircraft received a conventional tailplane and a **35° swept wing**. The two **Westinghouse J34** engines sat in the lower fuselage, fed by wing-root intakes, with their jetpipes exiting beneath the rear fuselage; this left the long fuselage free for the fuel the required range demanded. The short nose, with no radar, was to house six 20 mm **M39** cannon. The pilot had a pressurised cockpit and an ejection seat.\n\n## Testing\nThe first XF-88 flew from Muroc on 20 October 1948 with chief test pilot **Robert Edholm** at the controls, unarmed and powered by J34s without afterburners. Endurance was there, but the aircraft was underpowered: at 1,032 km/h at sea level it was slower than the F-86A already in production. McDonnell then designed its own afterburners; the second prototype, the XF-88A, flew on 26 April 1949 and reached 1,126 km/h, at the cost of reduced range. The Voodoo still prevailed over the **Lockheed XF-90** and the North American YF-93, but shifting Air Force priorities and a shortage of money led to the programme''s cancellation in August 1950.\n\n## Place in history\nThe first prototype became the **XF-88B**, a propeller testbed with an Allison T38 turboprop in the nose in addition to its jets. Until 1956 it tested three propellers and became the first propeller-equipped aircraft to exceed Mach 1, in a dive. Both aircraft were scrapped by 1958. But the Korean War brought the Air Force back to the idea of a long-range fighter: in 1951 a considerably enlarged version of the design was chosen for the **GOR 101** requirement and became the **F-101 Voodoo**, whose first production aircraft flew on 29 September 1954.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1946-04-01',
    '1948-10-20',
    NULL,
    1136,
    2795,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-88 Voodoo'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-88 Voodoo'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-88 Voodoo'), (SELECT id FROM armement WHERE name = 'M39'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-88 Voodoo'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'McDonnell XF-88 Voodoo'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.5,
  wingspan          = 12.09,
  height            = 5.26,
  wing_area         = 32.5,
  empty_weight      = 5507,
  mtow              = 10478,
  service_ceiling   = 12009,
  climb_rate        = 40.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J34-WE-15',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 16.0,
  thrust_wet        = 21.5,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XF-88 (Model 36C)** : premier prototype, réacteurs Westinghouse J34-13 sans postcombustion, non armé\n- **XF-88A (Model 36D)** : second prototype, réacteurs J34-22 à postcombustion conçue par McDonnell, armé par la suite ; le premier prototype est porté au même standard\n- **XF-88B (Model 36J)** : premier prototype transformé en banc d''essai d''hélices, turbopropulseur Allison XT38 de 2 500 ch dans le nez, premier vol le 14 avril 1953\n- **Versions proposées** : chasseur embarqué, biplace d''entraînement opérationnel et avion de reconnaissance, aucune construite',
  variants_en       = E'- **XF-88 (Model 36C)**: first prototype, non-afterburning Westinghouse J34-13 engines, unarmed\n- **XF-88A (Model 36D)**: second prototype, J34-22 engines with McDonnell-designed afterburners, later armed; the first prototype was brought to the same standard\n- **XF-88B (Model 36J)**: first prototype converted into a propeller testbed with a 2,500 shp Allison XT38 turboprop in the nose, first flown on 14 April 1953\n- **Proposed versions**: naval fighter, two-seat operational trainer and reconnaissance aircraft, none built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_XF-88_Voodoo',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_XF-88_Voodoo',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'McDonnell XF-88 Voodoo';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'McDonnell XF-88 Voodoo';
