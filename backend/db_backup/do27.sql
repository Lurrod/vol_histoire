-- Dornier Do 27
--
-- Photo : Dornier Do 27 H-2 (c-n 2008, HB-HKD) 2025-09-12 Andre Gerwing Collection ID 025137.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:Dornier_Do_27_H-2_(c-n_2008,_HB-HKD)_2025-09-12_Andre_Gerwing_Collection_ID_025137.jpg

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
    'Dornier Do 27',
    'Dornier Do 27',
    'Dornier Do 27',
    'Dornier Do 27',
    'Premier avion construit en grande série en Allemagne après 1945, bête de somme de la Bundeswehr et du Portugal',
    'Germany''s first mass-produced aircraft after 1945, workhorse of the Bundeswehr and of Portugal in Africa',
    '/assets/airplanes/do27.jpg',
    E'## Genèse\nAprès 1945, l''Allemagne n''a plus le droit de construire d''avions militaires, et **Dornier** se tourne vers l''Espagne, où il avait produit sous licence le Messerschmitt Bf 109. En janvier 1951, la firme ouvre un bureau technique à Madrid et obtient la même année un contrat pour un avion de liaison à décollage court. Le **Do 25**, doté d''un ENMA Tigre de 150 ch, vole en juillet 1954 mais manque de puissance ; le second prototype reçoit un **Continental O-470** et sert de démonstrateur au **Do 27**, dont le premier exemplaire vole en Espagne le 27 juin 1955.\n\n## Conception\nLe Do 27 est un monoplan classique à aile haute et train fixe à roulette de queue, avec de grands volets et un large pare-brise enveloppant. Sa cabine, large et confortable, accueille quatre à six personnes. Le **Lycoming GO-480** de 275 ch lui fait franchir 15 m de hauteur après 170 m de course, et il se pose en 160 m. Les variantes multiplient les usages : double commande pour l''école, train élargi, flotteurs, ou **Do 27H-2** pour l''aviation militaire suisse, à moteur de 340 ch et hélice tripale.\n\n## Carrière opérationnelle\nQuand la République fédérale est autorisée à se réarmer, en pleine **guerre froide**, la capacité du Do 27 à opérer depuis des terrains exigus et non préparés séduit les planificateurs : la Luftwaffe et l''armée de terre commandent 428 Do 27A et B, construits en Allemagne à partir de 1956, tandis que **CASA** en produit 40 en Espagne. L''avion sert à la liaison et au transport utilitaire jusque dans les années 1980, avant d''être relayé par les hélicoptères. Le Portugal en reçoit 40 neufs et 106 d''occasion allemands : de 1961 à 1975, son aviation les engage intensément sur les trois théâtres africains de la **guerre coloniale portugaise**, et deux sont abattus en Guinée portugaise en avril 1973 par des missiles portables SA-7.\n\n## Place dans l''histoire\nProduit à 571 exemplaires jusqu''en 1965, le Do 27 est le premier avion construit en grande série en Allemagne après la Seconde Guerre mondiale, le signe de la renaissance de son industrie aéronautique. Exporté en Israël, en Belgique, en Turquie, en Suède ou au Nigeria, il a ouvert la voie au bimoteur **Do 28**, et les derniers Do 27H-2 suisses n''ont quitté le service qu''en 2008. En 1959, un Do 27 a été le premier avion à se poser sur l''île de Saba, aux Antilles, sur la plus courte piste commerciale du monde.',
    E'## Genesis\nAfter 1945 Germany was forbidden to build military aircraft, and **Dornier** turned to Spain, where it had built the Messerschmitt Bf 109 under licence. In January 1951 the firm opened a technical office in Madrid and that year won a contract for a short take-off liaison aircraft. The **Do 25**, with a 150 hp ENMA Tigre, flew in July 1954 but lacked power; the second prototype received a **Continental O-470** and served as the demonstrator for the **Do 27**, the first of which flew in Spain on 27 June 1955.\n\n## Design\nThe Do 27 is a conventional high-wing monoplane with fixed tailwheel landing gear, large flaps and a wide wraparound windscreen. Its wide, comfortable cabin seats four to six. The 275 hp **Lycoming GO-480** clears a 15 m obstacle after a 170 m run, and it lands in 160 m. Variants multiplied its uses: dual controls for training, a wider-track undercarriage, floats, or the **Do 27H-2** for the Swiss Air Force, with a 340 hp engine and three-blade propeller.\n\n## Operational career\nWhen West Germany was allowed to rearm, at the height of the **Cold War**, the Do 27''s ability to operate from small unprepared strips won over military planners: the Luftwaffe and the Army ordered 428 Do 27As and Bs, built in Germany from 1956, while **CASA** produced 40 in Spain. It served for liaison and utility transport into the 1980s before helicopters took over. Portugal received 40 new and 106 ex-German aircraft: from 1961 to 1975 its air force used them extensively in the three African theatres of the **Portuguese Colonial War**, and two were shot down in Portuguese Guinea in April 1973 by SA-7 shoulder-launched missiles.\n\n## Place in history\nBuilt to 571 examples until 1965, the Do 27 was the first aircraft mass-produced in Germany after the Second World War, a sign of the rebirth of its aircraft industry. Exported to Israel, Belgium, Turkey, Sweden and Nigeria, it paved the way for the twin-engined **Do 28**, and the last Swiss Do 27H-2s left service only in 2008. In 1959 a Do 27 became the first aircraft to land on the Caribbean island of Saba, on the world''s shortest commercial runway.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1951-01-01',
    '1955-06-27',
    NULL,
    250,
    870,
    (SELECT id FROM manufacturer WHERE code = 'DOR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 27'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Dornier Do 27'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 27'), (SELECT id FROM wars WHERE name = 'Guerre coloniale portugaise'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.08,
  wingspan          = 12.0,
  height            = 4.18,
  wing_area         = 19.4,
  empty_weight      = 985,
  mtow              = 1570,
  service_ceiling   = 5500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming GO-480-B1A6 (275 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1965,
  units_built       = 571,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 22,
  variants          = E'- **Do 25** : prédécesseur conçu pour l''Espagne, à moteur ENMA Tigre de 150 ch\n- **Do 27A** : version militaire de transport utilitaire à cinq places, 177 Do 27A-1 puis A-3 et A-4 à masse accrue\n- **Do 27B** : version à double commande pour l''entraînement\n- **Do 27H-2** : version de l''aviation militaire suisse, Lycoming GSO-480 de 340 ch et hélice tripale\n- **CASA C-127** : 40 exemplaires construits sous licence en Espagne',
  variants_en       = E'- **Do 25**: predecessor designed for Spain, with a 150 hp ENMA Tigre engine\n- **Do 27A**: five-seat military utility transport, 177 Do 27A-1s then heavier A-3s and A-4s\n- **Do 27B**: dual-control training version\n- **Do 27H-2**: Swiss Air Force version, 340 hp Lycoming GSO-480 and three-blade propeller\n- **CASA C-127**: 40 built under licence in Spain',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dornier_Do_27',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dornier_Do_27',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Dornier Do 27';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dornier Do 27';
