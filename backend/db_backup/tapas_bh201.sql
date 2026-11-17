-- ADE TAPAS-BH-201 (Rustom-II)
--
-- Photo : Rustom flight 1.jpg
--   licence CC BY-SA 4.0 — Government of India
--   https://commons.wikimedia.org/wiki/File:Rustom_flight_1.jpg

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
    'DRDO TAPAS-BH-201',
    'DRDO TAPAS-BH-201',
    'ADE TAPAS-BH-201 (Rustom-II)',
    'ADE TAPAS-BH-201 (Rustom-II)',
    'Le drone MALE indien bimoteur qui a volé 18 heures à 8 500 m sans atteindre ce que l''armée exigeait',
    'India''s twin-engined MALE drone that flew 18 hours at 8,500 m without reaching what the forces demanded',
    '/assets/airplanes/tapas-bh201.jpg',
    E'## Genèse\nL''Inde veut son propre drone de moyenne altitude et longue endurance. L''**Aeronautical Development Establishment** (ADE), laboratoire de la **DRDO**, travaille d''abord sur le démonstrateur **Rustom**, puis lance une version bien plus ambitieuse, le **Rustom-II**, rebaptisé en 2016 **TAPAS-BH-201** (« Tactical Airborne Platform for Aerial Surveillance - Beyond Horizon »). En 2010, un responsable de la DRDO reconnaît que le **MQ-1 Predator** américain est le modèle évident, y compris dans sa transformation de drone de surveillance en drone de combat. La conception est achevée début 2012 et les essais de roulage commencent en septembre 2013 à Kolar, près de Bangalore.\n\n## Conception\nLe TAPAS est un bimoteur à hélices tractives, aile haute et empennage en T, posé sur un train tricycle rétractable. Long de 9,5 m pour 20,6 m d''envergure, il doit emporter 350 kg de charge utile : radar à synthèse d''ouverture, caméras électro-optiques de moyenne et longue portée, capteurs d''écoute électronique, le tout relié au sol par satellite. Ses premiers prototypes volent avec des Rotax 914 de 125 ch, puis des moteurs Austro de 180 ch. Le poids est son talon d''Achille : prévu à 1 800 kg à vide, il atteint 2 200 kg sur les prototypes et 2 850 kg en charge.\n\n## Essais\nLe premier vol a lieu le 16 novembre 2016 à Challakere, dans le Karnataka. Le prototype AF-6 s''écrase le 17 septembre 2019 après une perte de liaison suivie de fortes turbulences ; son successeur reçoit une navigation inertielle indienne et une liaison satellite. Le drone tient huit heures à 4 900 m en octobre 2020, puis 18 heures à 8 500 m en mars 2022. En juin 2023, son contrôle est transféré en vol à une station installée sur le navire INS Subhadra, et le 27 juin il effectue son 200e vol devant les trois armées.\n\n## Place dans l''histoire\nEn janvier 2024, le TAPAS perd son statut de projet prioritaire : il n''a pas atteint les 9 100 m et les 24 heures d''endurance exigés par les forces armées, et son coût est passé de 1 540 à 1 786 crores de roupies. La décision fait polémique, certains y voyant une manœuvre au profit du Drishti-10 Starliner, produit par l''industriel indien Adani avec l''israélien Elbit. L''ADE poursuit pourtant le développement, et la marine s''intéresse à l''appareil pour surveiller les îles Andaman-et-Nicobar. Il illustre la difficulté, pour une industrie nationale, de rattraper les drones israéliens et américains qu''elle voulait remplacer.',
    E'## Genesis\nIndia wanted its own medium-altitude long-endurance drone. The **Aeronautical Development Establishment** (ADE), a **DRDO** laboratory, first worked on the **Rustom** demonstrator, then launched a far more ambitious version, the **Rustom-II**, renamed in 2016 the **TAPAS-BH-201** ("Tactical Airborne Platform for Aerial Surveillance - Beyond Horizon"). In 2010 a DRDO official acknowledged that the American **MQ-1 Predator** was the obvious template, including its conversion from surveillance drone to combat drone. Design was completed in early 2012 and taxi trials began in September 2013 at Kolar, near Bengaluru.\n\n## Design\nThe TAPAS is a twin-engined aircraft with tractor propellers, a high wing and a T-tail, on a retractable tricycle undercarriage. At 9.5 m long with a 20.6 m span, it is meant to carry a 350 kg payload: synthetic aperture radar, medium- and long-range electro-optical cameras and electronic intelligence sensors, all linked to the ground by satellite. Its first prototypes flew with 125 hp Rotax 914s, then 180 hp Austro engines. Weight is its Achilles'' heel: planned at 1,800 kg empty, it reached 2,200 kg on the prototypes and 2,850 kg loaded.\n\n## Testing\nThe first flight took place on 16 November 2016 at Challakere, in Karnataka. Prototype AF-6 crashed on 17 September 2019 after a link loss followed by severe turbulence; its successor received an Indian inertial navigation system and a satellite link. The drone stayed up for eight hours at 4,900 m in October 2020, then 18 hours at 8,500 m in March 2022. In June 2023 its control was transferred in flight to a station aboard the ship INS Subhadra, and on 27 June it made its 200th flight in front of the three services.\n\n## Place in history\nIn January 2024 the TAPAS lost its priority project status: it had not reached the 9,100 m and 24 hours'' endurance demanded by the armed forces, and its cost had risen from 1,540 to 1,786 crore rupees. The decision was controversial, some seeing it as a move to favour the Drishti-10 Starliner, built by the Indian firm Adani with Israel''s Elbit. ADE nevertheless continues development, and the navy is interested in the aircraft for watching the Andaman and Nicobar Islands. It illustrates how hard it is for a national industry to catch up with the Israeli and American drones it sought to replace.',
    (SELECT id FROM countries WHERE code = 'IND'),
    NULL,
    '2016-11-16',
    NULL,
    224,
    1000,
    (SELECT id FROM manufacturer WHERE code = 'ADE'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'DRDO TAPAS-BH-201'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique')),
((SELECT id FROM airplanes WHERE name = 'DRDO TAPAS-BH-201'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'DRDO TAPAS-BH-201'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'DRDO TAPAS-BH-201'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'DRDO TAPAS-BH-201'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.5,
  wingspan          = 20.6,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 2850,
  service_ceiling   = 8530,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 250,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914 (125 ch), puis Austro Engine (180 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Rustom-H** : démonstrateur bimoteur du programme Rustom, dont dérive le TAPAS\n- **Rustom-II / TAPAS-BH-201** : prototypes successifs, Rotax 914 puis moteurs Austro à partir de l''AF-5\n- **AF-6A** : prototype reconstruit après l''accident de 2019, navigation inertielle indienne, batteries lithium-ion et liaison satellite',
  variants_en       = E'- **Rustom-H**: twin-engined demonstrator of the Rustom programme, from which the TAPAS derives\n- **Rustom-II / TAPAS-BH-201**: successive prototypes, Rotax 914 then Austro engines from AF-5\n- **AF-6A**: prototype rebuilt after the 2019 crash, Indian inertial navigation, lithium-ion batteries and satellite link',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/HAL_TAPAS_BH-201',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Government of India',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'DRDO TAPAS-BH-201';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'DRDO TAPAS-BH-201';
