-- Northrop Grumman MQ-4C Triton
--
-- Photo : First MQ-4C Triton test flight.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:First_MQ-4C_Triton_test_flight.jpg

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
    'MQ-4C Triton',
    'MQ-4C Triton',
    'Northrop Grumman MQ-4C Triton',
    'Northrop Grumman MQ-4C Triton',
    'Le Global Hawk de la marine : trente heures de veille sur l’océan, en équipe avec le P-8',
    'The navy’s Global Hawk: thirty hours watching the ocean, teamed with the P-8',
    '/assets/airplanes/mq4c-triton.jpg',
    E'## Genèse\nAu début des années 2000, l''US Navy prépare le remplacement de ses **P-3 Orion** par le **P-8 Poseidon**, moins nombreux. Pour que ces avions pilotés se concentrent sur la chasse aux sous-marins, la marine lance le programme BAMS (*Broad Area Maritime Surveillance*) : un drone de haute altitude chargé de la surveillance permanente des grandes étendues océaniques. Le 22 avril 2008, **Northrop Grumman** l''emporte avec une version navale du **RQ-4 Global Hawk**.\n\n## Conception\nLa cellule reprend celle du Global Hawk, avec ses 39,9 mètres d''envergure et son réacteur **Rolls-Royce AE 3007** installé sur le dos. Elle est renforcée et dotée d''un dégivrage pour pouvoir descendre à travers les nuages et identifier un navire à basse altitude, puis remonter vers 17 000 mètres. Le capteur principal est le radar **AN/ZPY-3** à antenne active tournante, qui couvre 360° en permanence, complété par une boule optronique et des capteurs électroniques. L''endurance dépasse trente heures et la distance franchissable atteint 15 200 kilomètres.\n\n## Carrière opérationnelle\nPremier vol le **22 mai 2013** à Palmdale. Le 26 janvier 2020, l''escadron VUP-19 déploie les deux premiers Triton à **Guam** : c''est la première mise en œuvre opérationnelle ; la capacité opérationnelle initiale est déclarée en 2023. Les déploiements suivants couvrent le Pacifique occidental et le Moyen-Orient. L''Australie, qui exploite aussi le P-8, en a commandé quatre pour la Royal Australian Air Force. Le volume de la commande américaine, d''abord fixé à 68 appareils, a été revu à la baisse.\n\n## Place dans l''histoire\nLe Triton est l''un des premiers grands drones de patrouille maritime mis en service. Il incarne la répartition des tâches que les marines occidentales cherchent à généraliser : le drone veille sans relâche et à haute altitude, l''avion piloté intervient. Son prédécesseur direct dans l''US Navy est la petite flotte de RQ-4A d''essai du programme BAMS-D, qui a servi de 2008 aux années 2020.',
    E'## Genesis\nIn the early 2000s the US Navy was preparing to replace its **P-3 Orions** with fewer **P-8 Poseidons**. So that these crewed aircraft could concentrate on submarine hunting, the navy launched the BAMS (*Broad Area Maritime Surveillance*) programme: a high-altitude drone responsible for persistent surveillance of vast ocean areas. On 22 April 2008 **Northrop Grumman** won with a naval version of the **RQ-4 Global Hawk**.\n\n## Design\nThe airframe is that of the Global Hawk, with its 39.9-metre span and its **Rolls-Royce AE 3007** engine mounted on the back. It is strengthened and fitted with de-icing so that it can descend through cloud and identify a ship at low altitude, then climb back to around 17,000 metres. The main sensor is the **AN/ZPY-3** radar with a rotating active array, giving permanent 360° coverage, supplemented by an electro-optical turret and electronic sensors. Endurance exceeds thirty hours and range reaches 15,200 kilometres.\n\n## Operational career\nFirst flight on **22 May 2013** at Palmdale. On 26 January 2020 squadron VUP-19 deployed the first two Tritons to **Guam**: the first operational use; initial operational capability was declared in 2023. Subsequent deployments covered the western Pacific and the Middle East. Australia, which also operates the P-8, has ordered four for the Royal Australian Air Force. The size of the American order, first set at 68 aircraft, has been reduced.\n\n## Place in history\nThe Triton is one of the first large maritime patrol drones to enter service. It embodies the division of labour Western navies seek to generalise: the drone watches relentlessly from high altitude, the crewed aircraft intervenes. Its direct predecessor in the US Navy is the small fleet of RQ-4A test aircraft of the BAMS-D programme, which served from 2008 into the 2020s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2008-04-22',
    '2013-05-22',
    '2020-01-26',
    575.0,
    15200.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-4C Triton'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'MQ-4C Triton'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'MQ-4C Triton'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'MQ-4C Triton'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-4C Triton'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'MQ-4C Triton'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.5,
  wingspan          = 39.9,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 6781,
  mtow              = 14630,
  service_ceiling   = 17000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce AE 3007H',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 39.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **MQ-4C Triton** : version navale du **RQ-4 Global Hawk**, cellule renforcée et dégivrée\n- **Multi-INT** : standard ultérieur à capteurs de renseignement électronique étendus\n- Radar **AN/ZPY-3** à antenne active tournante, couverture permanente sur 360°\n- Exploité par l''**US Navy** (VUP-11 et VUP-19) et la **Royal Australian Air Force**\n- Conçu pour opérer en équipe avec le **P-8 Poseidon**',
  variants_en       = E'- **MQ-4C Triton** : naval version of the **RQ-4 Global Hawk**, strengthened and de-iced airframe\n- **Multi-INT** : later standard with extended electronic intelligence sensors\n- **AN/ZPY-3** radar with a rotating active array, permanent 360° coverage\n- Operated by the **US Navy** (VUP-11 and VUP-19) and the **Royal Australian Air Force**\n- Designed to work as a team with the **P-8 Poseidon**',

  -- Strate 4 : qualitatif
  nickname          = 'Triton',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Grumman_MQ-4C_Triton',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_MQ-4C_Triton',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'MQ-4C Triton';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MQ-4C Triton';
