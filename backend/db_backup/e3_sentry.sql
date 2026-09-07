-- Boeing E-3 Sentry AWACS
--
-- Photo : Boeing E-3 Sentry AWAC (26251589403).jpg
--   licence CC BY 2.0 — Ronnie Macdonald from Chelmsford and Largs, United Kingdom
--   https://commons.wikimedia.org/wiki/File%3ABoeing_E-3_Sentry_AWAC_%2826251589403%29.jpg

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
    'E-3 Sentry',
    'E-3 Sentry',
    'Boeing E-3 Sentry AWACS',
    'Boeing E-3 Sentry AWACS',
    'Poste de commandement aéroporté de l’OTAN, reconnaissable à son radôme',
    'NATO’s airborne command post, unmistakable for its rotodome',
    '/assets/airplanes/e3-sentry.jpg',
    E'## Genèse\nLe programme naît du même constat que le Hawkeye, à l''échelle d''un théâtre entier : un radar au sol ne voit pas derrière les reliefs, et l''URSS s''entraîne à pénétrer à très basse altitude. Boeing reprend la cellule de son **707**, dont les chaînes tournent depuis quinze ans, et y installe un radar de surveillance et vingt postes d''opérateurs.\n\n## Conception\nLe radôme **rotatif de 9,1 mètres** tourne à six tours par minute, monté sur deux pylônes au-dessus du fuselage. Le radar AN/APY suit simultanément des centaines de pistes jusqu''à 400 kilomètres. L''appareil n''est pas un capteur mais un **poste de commandement** : les contrôleurs à bord attribuent les cibles, coordonnent les ravitaillements et dirigent la bataille aérienne.\n\n## Carrière opérationnelle\nSoixante-huit exemplaires. Pendant la **guerre du Golfe**, les E-3 dirigent 120 000 sorties et assurent la coordination de toutes les victoires aériennes de la coalition. Ils opèrent depuis dans les Balkans, en Afghanistan, en Libye et en Syrie. Les quatorze appareils de la flotte OTAN sont le seul matériel militaire que l''Alliance possède en propre.\n\n## Place dans l''histoire\nL''AWACS a changé la nature du combat aérien : la supériorité ne se joue plus seulement sur les performances des chasseurs mais sur la **connaissance de la situation**. Un appareil de 4e génération connecté à un E-3 l''emporte sur un appareil supérieur qui vole aveugle.',
    E'## Genesis\nThe programme grew from the same observation as the Hawkeye, on the scale of a whole theatre: ground radar cannot see behind terrain, and the USSR was training to penetrate at very low level. Boeing reused the airframe of its **707**, whose lines had been running for fifteen years, and installed a surveillance radar and twenty operator stations.\n\n## Design\nThe **9.1-metre rotodome** turns at six revolutions per minute on two pylons above the fuselage. The AN/APY radar tracks hundreds of contacts simultaneously out to 400 kilometres. The aircraft is not a sensor but a **command post**: the controllers aboard assign targets, coordinate refuelling and direct the air battle.\n\n## Operational career\nSixty-eight built. During the **Gulf War** E-3s directed 120,000 sorties and coordinated every coalition aerial victory. They have since operated over the Balkans, Afghanistan, Libya and Syria. The fourteen aircraft of the NATO fleet are the only military equipment the Alliance owns outright.\n\n## Place in history\nAWACS changed the nature of air combat: superiority is no longer decided by fighter performance alone but by **situational awareness**. A fourth-generation aircraft linked to an E-3 beats a better aircraft flying blind.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1963-01-01',
    '1975-10-31',
    '1977-03-24',
    855.0,
    7400.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Intervention en Libye')),
((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.61,
  wingspan          = 44.42,
  height            = 12.6,
  wing_area         = 283.4,
  empty_weight      = 73480,
  mtow              = 147420,
  service_ceiling   = 12500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1600,
  crew              = 16,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney TF33-PW-100A',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 93.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1975,
  production_end    = 1992,
  units_built       = 68,
  unit_cost_usd     = 270000000,
  unit_cost_year    = 1998,
  operators_count   = 5,
  variants          = E'- **E-3B / C** : versions américaines successivement modernisées\n- **E-3D Sentry AEW.1** : version britannique, retirée en 2021\n- **E-3F** : version française, en service jusqu''en 2035\n- **Flotte OTAN** : quatorze appareils immatriculés au Luxembourg, seul matériel militaire détenu en commun par l''Alliance',
  variants_en       = E'- **E-3B / C** : successively upgraded American versions\n- **E-3D Sentry AEW.1** : British version, retired in 2021\n- **E-3F** : French version, in service until 2035\n- **NATO fleet** : fourteen aircraft registered in Luxembourg, the Alliance’s only commonly owned military equipment',

  -- Strate 4 : qualitatif
  nickname          = 'AWACS',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_E-3_Sentry',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_E-3_Sentry',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ronnie Macdonald from Chelmsford and Largs, United Kingdom',
  image_licence     = 'CC BY 2.0'
WHERE name = 'E-3 Sentry';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'E-3 Sentry';
