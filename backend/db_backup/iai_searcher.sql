-- IAI Searcher (Hugla)
--
-- Photo : Republic of Singapore Air Force IAI Searcher II Unmanned Aerial Vehicle at Henry Post Army Airfield, Fort Sill, Lawton, Oklahoma - 20091114.jpg
--   licence Public domain — Jeff Crawley
--   https://commons.wikimedia.org/wiki/File:Republic_of_Singapore_Air_Force_IAI_Searcher_II_Unmanned_Aerial_Vehicle_at_Henry_Post_Army_Airfield,_Fort_Sill,_Lawton,_Oklahoma_-_20091114.jpg

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
    'IAI Searcher',
    'IAI Searcher',
    'IAI Searcher (Hugla)',
    'IAI Searcher (Hugla)',
    'Le drone tactique israélien vendu à quinze pays, jusqu''à la Russie qui en a tiré son Forpost',
    'The Israeli tactical drone sold to fifteen countries, including Russia, which turned it into its Forpost',
    '/assets/airplanes/iai-searcher.jpg',
    E'## Genèse\nDans les années 1980, **Israel Aircraft Industries** prépare la relève des petits drones qui ont fait la réputation de l''armée israélienne, le **Tadiran Mastiff** et l''**IAI Scout**. Le résultat, le **Searcher**, appelé Hugla dans les forces israéliennes, vole en 1992 et entre en service la même année. Il remplace dans la décennie suivante le Mastiff et le Scout. Son moteur se révèle toutefois trop bruyant pour un appareil censé observer sans être entendu : IAI propose dès 1998 un **Searcher II**, plus discret et plus performant.\n\n## Conception\nAu premier coup d''œil, le Searcher ressemble trait pour trait au Scout et au **Pioneer** américain : aile haute, double poutre, hélice propulsive et train fixe. Il est pourtant plus de deux fois plus grand que le Scout. Un moteur à pistons **Limbach** de 47 ch entraîne une hélice tripale, et le Searcher II Mk3 atteint 450 kg au décollage, 6 100 m de plafond et une vingtaine d''heures d''endurance. Il décolle et se pose sur piste ; ses capteurs optiques sont logés sous le fuselage. Non armé, il se consacre au renseignement, à la surveillance et à l''acquisition d''objectifs.\n\n## Carrière opérationnelle\nLe Searcher devient un grand succès d''exportation. L''Inde en reçoit plus d''une centaine pour ses trois armées ; le 7 juin 2002, un F-16 pakistanais abat l''un d''eux près de Lahore d''un missile Sidewinder. En 1996, des Searcher prêtés par Singapour aident l''Indonésie à rechercher des otages pendant la crise de Mapenduma. Après la guerre russo-géorgienne de 2008, Israël refuse de vendre des drones armés à la Russie mais accepte de lui livrer des Searcher Mk II : produits sous licence sous le nom de **Forpost**, puis armés dans la version Forpost-R, ils sont engagés dès mars 2022 dans l''**invasion de l''Ukraine**.\n\n## Place dans l''histoire\nLe Searcher est le chaînon entre les petits drones israéliens des années 1980 et les grands drones d''endurance qui les ont suivis : Singapour l''a remplacé en 2011 par l''**IAI Heron**. Une quinzaine de pays l''ont utilisé, de l''Espagne à la Corée du Sud. Son histoire russe est la plus singulière : un drone israélien de reconnaissance, devenu drone de combat dans une usine russe, s''est retrouvé en première ligne d''une guerre européenne.',
    E'## Genesis\nIn the 1980s **Israel Aircraft Industries** prepared the successor to the small drones that had made the Israeli army''s reputation, the **Tadiran Mastiff** and the **IAI Scout**. The result, the **Searcher**, known as Hugla in Israeli service, flew in 1992 and entered service the same year. Over the following decade it replaced the Mastiff and the Scout. Its engine proved too noisy, however, for an aircraft meant to watch without being heard: as early as 1998 IAI offered a quieter and more capable **Searcher II**.\n\n## Design\nAt first glance the Searcher looks just like the Scout and the American **Pioneer**: high wing, twin booms, pusher propeller and fixed undercarriage. Yet it is more than twice the size of the Scout. A 47 hp **Limbach** piston engine drives a three-blade propeller, and the Searcher II Mk3 reaches 450 kg at take-off, a 6,100 m ceiling and around twenty hours'' endurance. It takes off and lands on a runway; its optical sensors are housed under the fuselage. Unarmed, it is devoted to intelligence, surveillance and target acquisition.\n\n## Operational career\nThe Searcher became a major export success. India received more than a hundred for its three services; on 7 June 2002 a Pakistani F-16 shot one down near Lahore with a Sidewinder missile. In 1996 Searchers lent by Singapore helped Indonesia search for hostages during the Mapenduma crisis. After the 2008 Russo-Georgian War, Israel refused to sell armed drones to Russia but agreed to deliver Searcher Mk IIs: built under licence as the **Forpost**, then armed in the Forpost-R version, they were committed from March 2022 to the **invasion of Ukraine**.\n\n## Place in history\nThe Searcher is the link between the small Israeli drones of the 1980s and the large endurance drones that followed them: Singapore replaced it in 2011 with the **IAI Heron**. Some fifteen countries have used it, from Spain to South Korea. Its Russian story is the most unusual: an Israeli reconnaissance drone, turned into a combat drone in a Russian factory, ended up on the front line of a European war.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    '1992-01-01',
    '1992-01-01',
    201,
    350,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Searcher'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'IAI Searcher'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Searcher'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Searcher'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 5.85,
  wingspan          = 8.55,
  height            = 1.25,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 450,
  service_ceiling   = 6100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Limbach L 550 (47 ch)',
  engine_count      = 1,
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
  operators_count   = 15,
  variants          = E'- **Searcher I** : version initiale, en service en 1992, moteur jugé trop bruyant\n- **Searcher II** : moteur plus silencieux et performances accrues, proposé en 1998\n- **Searcher III** : performances encore améliorées ; la variante Searcher II Mk3 atteint 450 kg au décollage et 20 heures d''endurance\n- **Forpost** : Searcher Mk II produit sous licence en Russie, 250 km de portée\n- **Forpost-R** : version russe entièrement nationale, armée, premier vol en août 2019',
  variants_en       = E'- **Searcher I**: initial version, in service in 1992, engine judged too noisy\n- **Searcher II**: quieter engine and improved performance, offered in 1998\n- **Searcher III**: further improved performance; the Searcher II Mk3 variant reaches 450 kg at take-off and 20 hours'' endurance\n- **Forpost**: Searcher Mk II built under licence in Russia, 250 km range\n- **Forpost-R**: fully domestic, armed Russian version, first flight in August 2019',

  -- Strate 4 : qualitatif
  nickname          = 'Hugla',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Searcher',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Searcher',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jeff Crawley',
  image_licence     = 'Public domain'
WHERE name = 'IAI Searcher';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI Searcher';
