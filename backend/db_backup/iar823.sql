-- IAR-823
--
-- Photo : IAR 823 (c-n 10, F-AZLQ) 2025-09-13 Andre Gerwing Collection ID 026463.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:IAR_823_(c-n_10,_F-AZLQ)_2025-09-13_Andre_Gerwing_Collection_ID_026463.jpg

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
    'IAR-823',
    'IAR-823',
    'IAR-823',
    'IAR-823',
    'L''école roumaine à aile basse et train rentrant, qui a aussi fondé l''école de pilotage militaire de l''Angola',
    'The Romanian low-wing trainer with retractable gear, which also founded Angola''s military flying school',
    '/assets/airplanes/iar-823.jpg',
    E'## Genèse\nEn 1970, une équipe de l''**IMFCA** de Bucarest, l''institut roumain de mécanique des fluides et de recherches aérospatiales, dessine sous la direction de **Radu Manicatide** un nouvel avion d''entraînement. L''armée de l''air roumaine doit remplacer l''**IAR-813** dans l''instruction de base. La construction du prototype commence à l''automne 1971 à l''usine ICA de Brașov, et l''appareil vole pour la première fois le 10 juin 1973. Le second exemplaire est présenté au salon de Farnborough dès septembre 1974.\n\n## Conception\nL''IAR-823 est un monoplan à aile basse classique, à train tricycle escamotable. L''élève et l''instructeur sont assis côte à côte, et trois sièges peuvent être ajoutés derrière eux ; la cabine peut aussi recevoir un brancard et un infirmier, ou 500 kg de fret. Un six-cylindres à plat Lycoming de 290 ch lui donne 310 km/h, 1 800 km de distance franchissable et six heures d''endurance, avec des facteurs de charge de +6 et −3 g. Bien qu''il ne soit pas destiné au combat, l''avion porte deux points d''emport sous voilure de 100 kg chacun.\n\n## Carrière opérationnelle\nLes livraisons commencent en 1974, d''abord au 20e régiment de Boboc, puis au 19e régiment, sur le terrain en herbe de Focșani ; les aéroclubs roumains en reçoivent quelques-uns. En 1980, l''**Angola** commande douze appareils : des instructeurs roumains fondent en 1981 à Negage l''école nationale d''aviation militaire, où le premier élève angolais vole seul le 30 juillet. Aucune mission de combat n''y est effectuée, et en 1983 les Roumains rentrent en laissant les avions à la force aérienne angolaise. En Roumanie, le service se termine mal : quatre accidents mortels, un carburant qu''il faut importer de Grèce au début des années 1990, et la concurrence du **Yak-52**, bien moins coûteux, qui reprend tout son rôle au milieu de la décennie.\n\n## Place dans l''histoire\nSoixante-dix-huit IAR-823 sont produits de 1974 à 1983. Interdits de vol vers 1995-1996 et stockés à Brașov, la plupart sont vendus à des particuliers américains entre 1999 et 2004, puis remis en état de vol. De l''avion dérivent l''**IAR-831 Pelican**, à places en tandem, et l''**IAR-825TP Triumph** à turbopropulseur. Plusieurs exemplaires sont conservés à Bucarest, au musée militaire national et au musée national de l''aviation.',
    E'## Genesis\nIn 1970 a team at the **IMFCA** in Bucharest, the Romanian institute of fluid mechanics and aerospace research, designed a new trainer under the direction of **Radu Manicatide**. The Romanian Air Force had to replace the **IAR-813** in the basic training role. Construction of the prototype began in the autumn of 1971 at the ICA factory in Brașov, and the aircraft flew for the first time on 10 June 1973. The second example was shown at the Farnborough Air Show as early as September 1974.\n\n## Design\nThe IAR-823 is a conventional low-wing monoplane with a retractable tricycle undercarriage. Student and instructor sit side by side, and three more seats can be fitted behind them; the cabin can also take a stretcher and a paramedic, or 500 kg of freight. A 290 hp Lycoming flat-six gave it 310 km/h, a range of 1,800 km and six hours'' endurance, with load factors of +6 and −3 g. Although it was not intended for combat, the aircraft had two underwing hardpoints of 100 kg each.\n\n## Operational career\nDeliveries began in 1974, first to the 20th Regiment at Boboc, then to the 19th Regiment on the grass airfield at Focșani; the Romanian aero clubs received a few. In 1980 **Angola** ordered twelve aircraft: Romanian instructors founded the national military aviation school at Negage in 1981, where the first Angolan student flew solo on 30 July. No combat missions were flown there, and in 1983 the Romanians went home, leaving the aircraft to the Angolan Air Force. In Romania the type''s service ended badly: four fatal crashes, fuel that had to be imported from Greece in the early 1990s, and competition from the much cheaper **Yak-52**, which took over its whole role by the middle of the decade.\n\n## Place in history\nSeventy-eight IAR-823s were built from 1974 to 1983. Grounded around 1995-1996 and stored at Brașov, most were sold to private American owners between 1999 and 2004, then restored to flying condition. The aircraft gave rise to the **IAR-831 Pelican**, with tandem seating, and the turboprop **IAR-825TP Triumph**. Several examples are preserved in Bucharest, at the National Military Museum and the National Aviation Museum.',
    (SELECT id FROM countries WHERE code = 'ROU'),
    '1970-01-01',
    '1973-06-10',
    '1974-01-01',
    310,
    1800,
    (SELECT id FROM manufacturer WHERE code = 'IAR'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-823'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-823'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'IAR-823'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.24,
  wingspan          = 10.0,
  height            = 2.52,
  wing_area         = 15.0,
  empty_weight      = 900,
  mtow              = 1500,
  service_ceiling   = 5600,
  climb_rate        = 7.49,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-540-G1D5 (290 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 1983,
  units_built       = 78,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **IAR-823** : version unique d''entraînement et de liaison, certains exemplaires construits sans points d''emport\n- Évolutions de série : verrière tubulaire remplacée par une verrière entièrement en fibre de verre, planche de bord monobloc coulissante\n- **IAR-831 Pelican** : dérivé à places en tandem, présenté au Bourget en 1985\n- **IAR-825TP Triumph** : dérivé du Pelican à turbopropulseur',
  variants_en       = E'- **IAR-823**: single training and liaison version, some aircraft built without hardpoints\n- Production changes: tubular canopy replaced by an all-fibreglass canopy, single-piece slide-out instrument panel\n- **IAR-831 Pelican**: tandem-seat derivative, shown at Le Bourget in 1985\n- **IAR-825TP Triumph**: turboprop derivative of the Pelican',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAR_823',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'IAR-823';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAR-823';
