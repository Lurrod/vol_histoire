-- HESA Saeqeh
--
-- Photo : A HESA Saeqeh of IRIAF.jpg
--   licence CC BY-SA 4.0 — Shahram Sharifi
--   https://commons.wikimedia.org/wiki/File%3AA_HESA_Saeqeh_of_IRIAF.jpg

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
    'HESA Saeqeh',
    'HESA Saeqeh',
    'HESA Saeqeh',
    'HESA Saeqeh',
    'Chasseur iranien dérivé du F-5, né de quarante ans d’embargo',
    'Iranian fighter derived from the F-5, born of forty years of embargo',
    '/assets/airplanes/saeqeh.jpg',
    E'## Genèse\nAvant 1979, l''Iran était l''un des meilleurs clients de l''industrie aéronautique américaine : F-4, F-5, et même des **F-14 Tomcat**, seuls exemplaires jamais exportés. La révolution puis l''embargo coupent net l''accès aux pièces. Pendant la guerre contre l''Irak, maintenir cette flotte devient un exercice de rétro-ingénierie permanent.\n\n## Conception\nLe Saeqeh est un **F-5E redessiné** : cellule reprise, mais empennage remplacé par une double dérive inclinée qui évoque le F/A-18. Le gain aérodynamique réel est débattu ; la démonstration politique, elle, est claire. Le J85 est produit localement à partir des stocks et des plans hérités de l''ère du Chah.\n\n## Carrière opérationnelle\nUne douzaine d''exemplaires seulement, en unité d''essai et de démonstration. L''appareil n''a jamais été engagé au combat et sa disponibilité réelle reste inconnue. Il apparaît régulièrement aux défilés et aux exercices, fonction qui semble être sa principale raison d''être.\n\n## Place dans l''histoire\nLe Saeqeh illustre ce que produit un embargo prolongé : non pas une industrie de rupture, mais une **industrie de survie**, capable de maintenir et de recombiner un patrimoine technique vieux de cinquante ans. C''est le pendant iranien de ce que le Ching-kuo fut pour Taïwan et le Lavi pour Israël.',
    E'## Genesis\nBefore 1979 Iran was one of the American aviation industry’s best customers: F-4s, F-5s, and even **F-14 Tomcats**, the only ones ever exported. The revolution and then the embargo cut off access to spares. During the war against Iraq, keeping that fleet flying became a permanent reverse-engineering exercise.\n\n## Design\nThe Saeqeh is a **redrawn F-5E**: the same airframe, but with the tail replaced by canted twin fins recalling the F/A-18. The real aerodynamic gain is debated; the political demonstration is not. The J85 is produced locally from stocks and drawings inherited from the Shah’s era.\n\n## Operational career\nOnly about a dozen aircraft, in a test and demonstration unit. It has never been committed to combat and its real availability is unknown. It appears regularly at parades and exercises, a function that seems to be its main purpose.\n\n## Place in history\nThe Saeqeh illustrates what a prolonged embargo produces: not a breakthrough industry but a **survival industry**, able to maintain and recombine a fifty-year-old technical inheritance. It is the Iranian counterpart of what the Ching-kuo was for Taiwan and the Lavi for Israel.',
    (SELECT id FROM countries WHERE code = 'IRN'),
    '1997-01-01',
    '2004-07-06',
    '2007-09-01',
    1700.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'HESA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'HESA Saeqeh'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.45,
  wingspan          = 8.13,
  height            = 4.01,
  wing_area         = 17.3,
  empty_weight      = 4349,
  mtow              = 11400,
  service_ceiling   = 15240,
  climb_rate        = 175,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-21 (production locale)',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 15.6,
  thrust_wet        = 22.2,

  -- Strate 3 : production & service
  production_start  = 2004,
  production_end    = NULL,
  units_built       = 12,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Azarakhsh** : premier dérivé du F-5, prototype de 1997\n- **Saeqeh** : version à double dérive inclinée, la plus produite\n- **Saeqeh-2** : biplace d''entraînement et de conversion\n- **Kowsar** : évolution ultérieure à avionique numérique\n\n*Programme peu documenté : les caractéristiques publiées proviennent de sources iraniennes officielles et n''ont pas été vérifiées indépendamment.*',
  variants_en       = E'- **Azarakhsh** : first F-5 derivative, 1997 prototype\n- **Saeqeh** : canted twin-tail version, the most produced\n- **Saeqeh-2** : two-seat trainer and conversion version\n- **Kowsar** : later evolution with digital avionics\n\n*Poorly documented programme: published characteristics come from official Iranian sources and have not been independently verified.*',

  -- Strate 4 : qualitatif
  nickname          = 'Saeqeh',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/HESA_Saeqeh',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/HESA_Saeqeh',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Shahram Sharifi',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'HESA Saeqeh';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HESA Saeqeh';
