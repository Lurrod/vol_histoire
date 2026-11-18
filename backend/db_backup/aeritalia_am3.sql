-- Aermacchi AM.3CM Bosbok
--
-- Photo : Aermacchi AM.3C Bosbok '959' (ZU-CXA) (16682865356).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Aermacchi_AM.3C_Bosbok_%27959%27_(ZU-CXA)_(16682865356).jpg

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
    'Aermacchi AM.3 Bosbok',
    'Aermacchi AM.3 Bosbok',
    'Aermacchi AM.3CM Bosbok',
    'Aermacchi AM.3CM Bosbok',
    'Refusé par l''Italie, il marqua les cibles à la roquette fumigène pour l''aviation sud-africaine en Angola',
    'Turned down by Italy, it marked targets with smoke rockets for the South African Air Force in Angola',
    '/assets/airplanes/aermacchi-am3-bosbok.jpg',
    E'## Genèse\nL''armée de Terre italienne veut remplacer ses **Cessna L-19**. **Aermacchi** et **Aerfer** s''associent pour lui proposer le **MB-335**, rebaptisé ensuite AM.3 : un monoplan à aile haute contreventée et train classique fixe. Le premier prototype, construit par Aermacchi, vole le 12 mai 1967 et paraît au Salon du Bourget le mois suivant ; le second, construit par Aerfer, vole le 22 août 1968. Mais l''armée italienne lui préfère le **SIAI-Marchetti SM.1019**. **Aeritalia**, qui absorbe Aerfer, poursuit malgré tout le développement.\n\n## Conception\nL''AM.3 reprend l''aile de l''utilitaire **Aermacchi AL-60**, renforcée pour porter deux points d''emport, sur un fuselage entièrement nouveau. Pilote et observateur sont assis en tandem avec double commande ; l''arrière de la cabine peut recevoir deux civières, des passagers ou du fret, et des équipements de reconnaissance peuvent être montés sur ou dans le fuselage. Le troisième prototype remplace le Continental d''origine par un six-cylindres à plat **Lycoming GSO-480** de 340 ch construit sous licence par Piaggio : c''est l''**AM.3C**, qui décolle en 85 m et se pose en 66 m.\n\n## Carrière opérationnelle\nEn septembre 1970, l''aviation sud-africaine commande 40 AM.3C, baptisés **AM.3CM Bosbok** (« guib », une antilope de brousse). Livrés de mars 1973 à décembre 1975 aux 41 et 42 Squadrons, ils portent quatre points d''emport pour des nacelles de mitrailleuses, des bombes légères ou des paniers de roquettes fumigènes. Pendant la **guerre de la frontière sud-africaine**, de 1975 à 1989, les Bosbok repeints en vert olive et terre sombre servent au contrôle aérien avancé, au relais radio — le « Telstar duty » —, à la reconnaissance, au réglage d''artillerie, à l''évacuation sanitaire et à la liaison. Leur spécialité est le marquage des cibles : arrivée au ras des arbres, ressource jusqu''à 90 m à l''aplomb de l''objectif, tir des roquettes fumigènes, puis dégagement en piqué vers la cime des arbres. Une de ces roquettes détruit un jour, d''un coup au but, toute une position antiaérienne de 37 mm.\n\n## Place dans l''histoire\nAprès le retrait sud-africain d''Angola en 1989 et la réduction de l''aviation, les Bosbok sont réformés en 1992 ; le Rwanda, seul autre client avec trois appareils livrés en 1974, retire les siens en 1993. L''AM.3 montre qu''un avion écarté par son pays d''origine peut trouver ailleurs une vraie guerre. Un exemplaire vole encore au sein du vol historique de l''aviation sud-africaine.',
    E'## Genesis\nThe Italian Army wanted to replace its **Cessna L-19s**. **Aermacchi** and **Aerfer** joined forces to offer the **MB-335**, later renamed AM.3: a strut-braced high-wing monoplane with fixed tailwheel landing gear. The first prototype, built by Aermacchi, flew on 12 May 1967 and appeared at the Paris Air Show the following month; the second, built by Aerfer, flew on 22 August 1968. But the Italian Army chose the **SIAI-Marchetti SM.1019** instead. **Aeritalia**, which absorbed Aerfer, nevertheless continued development.\n\n## Design\nThe AM.3 used the wing of the **Aermacchi AL-60** utility aircraft, strengthened to carry two hardpoints, on an all-new fuselage. Pilot and observer sat in tandem with dual controls; the rear cabin could take two stretchers, passengers or freight, and reconnaissance equipment could be fitted on or inside the fuselage. The third prototype replaced the original Continental with a 340 hp **Lycoming GSO-480** flat-six licence-built by Piaggio: this was the **AM.3C**, which took off in 85 m and landed in 66 m.\n\n## Operational career\nIn September 1970 the South African Air Force ordered 40 AM.3Cs, named **AM.3CM Bosbok** (bushbuck). Delivered between March 1973 and December 1975 to 41 and 42 Squadrons, they had four hardpoints for machine-gun pods, light bombs or smoke-rocket pods. During the **South African Border War**, from 1975 to 1989, the Bosboks, repainted olive drab and dark earth, flew forward air control, radio relay — ''Telstar duty'' —, reconnaissance, artillery spotting, casualty evacuation and liaison. Their speciality was target marking: approach at treetop height, pull up to about 90 m over the target, fire the smoke rockets, then turn and dive back to treetop level. One such rocket once destroyed an entire 37 mm anti-aircraft gun position with a lucky direct hit.\n\n## Place in history\nAfter South Africa''s withdrawal from Angola in 1989 and the downsizing of the air force, the Bosboks were retired in 1992; Rwanda, the only other customer with three aircraft delivered in 1974, retired its own in 1993. The AM.3 shows that an aircraft rejected at home can find a real war elsewhere. One example still flies with the South African Air Force historic flight.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    NULL,
    '1967-05-12',
    '1973-03-01',
    278,
    990,
    (SELECT id FROM manufacturer WHERE code = 'AIT'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi AM.3 Bosbok'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi AM.3 Bosbok'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi AM.3 Bosbok'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi AM.3 Bosbok'), (SELECT id FROM wars WHERE name = 'Guerre de la frontière sud-africaine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.73,
  wingspan          = 11.73,
  height            = 2.72,
  wing_area         = 19.04,
  empty_weight      = 1080,
  mtow              = 1700,
  service_ceiling   = 8400,
  climb_rate        = 7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming GSO-480-B1B6 construit par Piaggio (340 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1973,
  production_end    = 1975,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **MB-335 / AM.3** : deux prototypes à moteur Continental, premiers vols le 12 mai 1967 et le 22 août 1968\n- **AM.3C** : troisième prototype à moteur Lycoming GSO-480 construit par Piaggio\n- **AM.3CM Bosbok** : version de l''aviation sud-africaine, 40 commandés, quatre points d''emport\n- **AM.3C rwandais** : trois appareils livrés en 1974, retirés en mai 1993',
  variants_en       = E'- **MB-335 / AM.3**: two Continental-engined prototypes, first flights on 12 May 1967 and 22 August 1968\n- **AM.3C**: third prototype with a Piaggio-built Lycoming GSO-480\n- **AM.3CM Bosbok**: South African Air Force version, 40 ordered, four hardpoints\n- **Rwandan AM.3C**: three aircraft delivered in 1974, retired in May 1993',

  -- Strate 4 : qualitatif
  nickname          = 'Bosbok',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aermacchi_AM.3',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aermacchi_AM.3',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Aermacchi AM.3 Bosbok';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aermacchi AM.3 Bosbok';
