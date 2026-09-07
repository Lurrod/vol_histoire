-- Gloster Javelin
--
-- Photo : Gloster Javelin 46 Sqn line up, XA628 nearest. (51458866291).jpg
--   licence PDM-owner — tormentor4555
--   https://commons.wikimedia.org/wiki/File%3AGloster_Javelin_46_Sqn_line_up%2C_XA628_nearest._%2851458866291%29.jpg

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
    'Gloster Javelin',
    'Gloster Javelin',
    'Gloster Javelin',
    'Gloster Javelin',
    'Premier chasseur de nuit delta et biplace au monde',
    'The world’s first delta-wing two-seat night fighter',
    '/assets/airplanes/gloster-javelin.jpg',
    E'## Genèse\nLa Royal Air Force cherche au sortir de la guerre un chasseur de nuit capable d''intercepter les bombardiers soviétiques à haute altitude, par tous les temps. Gloster propose une formule alors inédite : une **aile delta** associée à un empennage horizontal surélevé, et un équipage de deux — pilote et opérateur radar.\n\n## Conception\nL''aile delta épaisse offre une immense surface portante et un volume interne considérable, au prix d''une traînée élevée. Le Javelin monte haut et vole loin, mais tourne mal et ne dépasse jamais Mach 1 en palier. Sa silhouette massive lui vaut le surnom de **Flat Iron**, le fer à repasser.\n\n## Carrière opérationnelle\nJamais engagé en combat aérien. Il assure la veille de l''espace aérien britannique et allemand pendant dix ans, et effectue des déploiements à Chypre, en Zambie et en Malaisie lors de la confrontation indonésienne. Sa mise au point est difficile : plusieurs prototypes sont perdus dans des phénomènes de **super-décrochage** alors mal compris.\n\n## Place dans l''histoire\nDernier avion produit sous le nom Gloster, il est retiré en 1968 au profit du Lightning et du Phantom. Son intérêt tient à ce qu''il documente : le passage de la chasse de nuit artisanale à l''interception guidée par radar, avec un équipage spécialisé.',
    E'## Genesis\nAfter the war the Royal Air Force wanted a night fighter able to intercept Soviet bombers at high altitude in all weathers. Gloster proposed a then-unprecedented formula: a **delta wing** combined with a raised horizontal tail, and a crew of two — pilot and radar operator.\n\n## Design\nThe thick delta wing offered vast lifting area and considerable internal volume, at the cost of high drag. The Javelin climbed high and flew far but turned poorly and never exceeded Mach 1 in level flight. Its bulky silhouette earned it the nickname **Flat Iron**.\n\n## Operational career\nNever engaged in air combat. It stood watch over British and German airspace for ten years and deployed to Cyprus, Zambia and Malaysia during the Indonesian confrontation. Development was difficult: several prototypes were lost to **deep stall** phenomena that were then poorly understood.\n\n## Place in history\nThe last aircraft produced under the Gloster name, it was retired in 1968 in favour of the Lightning and the Phantom. Its interest lies in what it documents: the shift from improvised night fighting to radar-guided interception with a specialised crew.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1948-01-01',
    '1951-11-26',
    '1956-02-01',
    1140.0,
    1530.0,
    (SELECT id FROM manufacturer WHERE code = 'GLO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM tech WHERE name = 'Radar AI.23')),
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM armement WHERE name = 'Firestreak'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.15,
  wingspan          = 15.85,
  height            = 4.88,
  wing_area         = 86.1,
  empty_weight      = 11430,
  mtow              = 19580,
  service_ceiling   = 15900,
  climb_rate        = 51,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 700,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Sapphire Sa.7R',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 49.0,
  thrust_wet        = 56.0,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1960,
  units_built       = 436,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **FAW.1 à FAW.6** : versions successives à canons et radars britanniques\n- **FAW.7** : postcombustion et missiles Firestreak\n- **FAW.9** : version définitive, ravitaillable en vol\n- **T.3** : biplace d''entraînement à double commande',
  variants_en       = E'- **FAW.1 to FAW.6** : successive versions with British guns and radars\n- **FAW.7** : afterburners and Firestreak missiles\n- **FAW.9** : definitive version, air-refuellable\n- **T.3** : dual-control trainer',

  -- Strate 4 : qualitatif
  nickname          = 'Flat Iron',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Gloster_Javelin',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Gloster_Javelin',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'tormentor4555',
  image_licence     = 'PDM-owner'
WHERE name = 'Gloster Javelin';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Gloster Javelin';
