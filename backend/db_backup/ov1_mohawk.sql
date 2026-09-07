-- Grumman OV-1 Mohawk
--
-- Photo : Grumman OV-1D Mohawk.jpg
--   licence CC BY 4.0 — Christopher M. Reed
--   https://commons.wikimedia.org/wiki/File%3AGrumman_OV-1D_Mohawk.jpg

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
    'OV-1 Mohawk',
    'OV-1 Mohawk',
    'Grumman OV-1 Mohawk',
    'Grumman OV-1 Mohawk',
    'Avion d’observation du champ de bataille, désarmé par accord entre armées',
    'Battlefield observation aircraft, disarmed by inter-service agreement',
    '/assets/airplanes/ov1-mohawk.jpg',
    E'## Genèse\nL''armée de terre américaine ne veut plus dépendre de l''Air Force pour savoir ce qui se passe quinze kilomètres devant elle. Elle commande donc son propre avion d''observation, capable de décoller d''une bande sommaire près du front, de voler bas et lentement au-dessus de la jungle, et de rentrer criblé. Grumman, habitué aux contraintes navales, sait construire robuste.\n\n## Conception\nDeux turbopropulseurs, une **verrière panoramique** aux vitres latérales bombées qui permet de regarder droit vers le bas, trois dérives, et des sièges éjectables — rareté sur un avion d''observation. Le cockpit est blindé et les réservoirs auto-obturants : l''appareil est conçu pour encaisser le feu depuis le sol. La grande nacelle ventrale des versions B abrite un radar à visée latérale capable de repérer un véhicule en mouvement à trente kilomètres.\n\n## Carrière opérationnelle\nLe Vietnam est son théâtre : les Mohawk y volent des dizaines de milliers d''heures de reconnaissance, souvent de nuit et à basse altitude, et **soixante-trois** sont perdus. Les premiers exemplaires étaient armés de roquettes et de nacelles-canon, jusqu''à ce que l''US Air Force obtienne en 1965, par accord interarmées, que l''armée de terre les **désarme entièrement** — l''appui-feu devait rester une prérogative aérienne. Ils voleront encore au-dessus du Golfe en 1991.\n\n## Place dans l''histoire\nTrois cent quatre-vingts exemplaires, et l''un des rares avions à voilure fixe jamais exploités par l''US Army. Il annonce, trente ans à l''avance, ce que feront les drones de surveillance : voir en continu, de jour comme de nuit, ce que la troupe au sol ne peut pas voir. Son cousin de l''observation légère, l''**OV-10 Bronco**, a gardé ses armes.',
    E'## Genesis\nThe US Army no longer wanted to depend on the Air Force to know what lay fifteen kilometres ahead of it. It therefore ordered its own observation aircraft, able to operate from a rough strip near the front, fly low and slow over jungle, and come home riddled. Grumman, used to naval demands, knew how to build tough.\n\n## Design\nTwo turboprops, a **panoramic canopy** with bulged side panels allowing a straight-down view, three fins, and ejection seats — a rarity on an observation aircraft. The cockpit is armoured and the tanks self-sealing: the aircraft was designed to absorb ground fire. The large belly pod of the B versions houses a side-looking radar able to detect a moving vehicle thirty kilometres away.\n\n## Operational career\nVietnam was its theatre: Mohawks flew tens of thousands of reconnaissance hours there, often at night and low down, and **sixty-three** were lost. The first aircraft carried rockets and gun pods, until in 1965 the US Air Force secured an inter-service agreement requiring the Army to **disarm them completely** — fire support was to remain an air force prerogative. They were still flying over the Gulf in 1991.\n\n## Place in history\nThree hundred and eighty built, and one of the few fixed-wing aircraft the US Army ever operated. It foreshadowed by thirty years what surveillance drones would do: watch continuously, by day and night, what troops on the ground cannot see. Its light observation cousin, the **OV-10 Bronco**, kept its weapons.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1956-01-01',
    '1959-04-14',
    '1961-02-01',
    491.0,
    1610.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.5,
  wingspan          = 14.63,
  height            = 3.86,
  wing_area         = 33.44,
  empty_weight      = 5467,
  mtow              = 8214,
  service_ceiling   = 7620,
  climb_rate        = 17.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 550,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming T53-L-701',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1959,
  production_end    = 1970,
  units_built       = 380,
  unit_cost_usd     = 1200000,
  unit_cost_year    = 1968,
  operators_count   = 4,
  variants          = E'- **OV-1A** : observation visuelle et photographique de jour\n- **OV-1B** : radar à visée latérale SLAR dans une nacelle ventrale de six mètres\n- **OV-1C** : imagerie infrarouge, détection de nuit à travers la végétation\n- **OV-1D** : version finale à capteurs interchangeables en vol\n- Exporté vers l''**Argentine**, Israël et la Corée du Sud après son retrait américain',
  variants_en       = E'- **OV-1A** : daytime visual and photographic observation\n- **OV-1B** : SLAR side-looking radar in a six-metre belly pod\n- **OV-1C** : infrared imaging, night detection through vegetation\n- **OV-1D** : final version with sensors interchangeable in flight\n- Exported to **Argentina**, Israel and South Korea after American retirement',

  -- Strate 4 : qualitatif
  nickname          = 'Mohawk',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_OV-1_Mohawk',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_OV-1_Mohawk',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Christopher M. Reed',
  image_licence     = 'CC BY 4.0'
WHERE name = 'OV-1 Mohawk';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'OV-1 Mohawk';
