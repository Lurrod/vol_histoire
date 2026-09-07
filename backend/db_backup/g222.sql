-- Aeritalia G.222
--
-- Photo : G222 at fairford 2009 arp.jpg
--   licence Public domain — Adrian Pingstone ( Arpingstone )
--   https://commons.wikimedia.org/wiki/File%3AG222_at_fairford_2009_arp.jpg

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
    'Aeritalia G.222',
    'Aeritalia G.222',
    'Aeritalia G.222',
    'Aeritalia G.222',
    'Le transport tactique italien, ancêtre du C-27J',
    'The Italian tactical transport, ancestor of the C-27J',
    '/assets/airplanes/g222.jpg',
    E'## Genèse\nEn 1962, l''OTAN publie un cahier des charges pour un transport tactique à décollage court capable de ravitailler des unités dispersées. Neuf industriels répondent ; l''OTAN ne choisit personne. L''Italie, seule, poursuit son étude sur fonds nationaux et fait voler le G.222 huit ans plus tard.\n\n## Conception\nAile haute, deux turbopropulseurs **T64**, rampe arrière et train à voie large : c''est un C-130 réduit de moitié, dimensionné pour dix tonnes de fret ou quarante-six parachutistes. Le choix d''une taille intermédiaire est délibéré — trop gros pour les pistes de campagne, le Hercules laisse un créneau que rien n''occupe en Europe.\n\n## Carrière opérationnelle\nCent onze exemplaires, dix pays. L''Italie l''emploie quarante ans, notamment pour le soutien de ses contingents au Liban, en Somalie et dans les Balkans. Les **États-Unis** en achètent dix sous le nom de C-27A pour opérer depuis les pistes courtes du Panama, avant de les revendre.\n\n## Place dans l''histoire\nCent onze exemplaires. Le G.222 est le seul appareil issu du programme OTAN de 1962 à avoir été construit, et il a fondé une lignée : l''**Alenia C-27J Spartan**, qui lui succède en 1999 avec les moteurs et l''avionique du **C-130J**, est aujourd''hui vendu dans une quinzaine de pays.',
    E'## Genesis\nIn 1962 NATO issued a requirement for a short take-off tactical transport able to resupply dispersed units. Nine manufacturers answered; NATO chose none of them. Italy alone carried on with national money and flew the G.222 eight years later.\n\n## Design\nA high wing, two **T64** turboprops, a rear ramp and wide-track landing gear: it is a C-130 halved, sized for ten tonnes of freight or forty-six paratroopers. The intermediate size is deliberate — too big for country strips, the Hercules leaves a gap nothing fills in Europe.\n\n## Operational career\nOne hundred and eleven built, ten countries. Italy flew it for forty years, notably supporting its contingents in Lebanon, Somalia and the Balkans. The **United States** bought ten as the C-27A to work from Panama''s short strips, before selling them on.\n\n## Place in history\nOne hundred and eleven built. The G.222 is the only aircraft from NATO''s 1962 programme actually built, and it founded a line: the **Alenia C-27J Spartan**, which succeeded it in 1999 with the engines and avionics of the **C-130J**, is now sold in some fifteen countries.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1962-01-01',
    '1970-07-18',
    '1978-04-01',
    540.0,
    4633.0,
    (SELECT id FROM manufacturer WHERE code = 'AIT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.222'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.222'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.222'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.222'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.222'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.7,
  wingspan          = 28.7,
  height            = 9.8,
  wing_area         = 82.0,
  empty_weight      = 15400,
  mtow              = 28000,
  service_ceiling   = 7620,
  climb_rate        = 8.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1370,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric T64-GE-P4D',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1970,
  production_end    = 1993,
  units_built       = 111,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 10,
  variants          = E'- **G.222TCM** : version de transport de base, la plus produite\n- **G.222VS** : version de guerre électronique, deux exemplaires italiens\n- **G.222SAA** : version de lutte contre l''incendie, à réservoir largable\n- **C-27A Spartan** : dix exemplaires achetés par l''**US Air Force** pour Panama\n- Né d''un cahier des charges **OTAN** de 1962 auquel aucun autre pays n''a donné suite',
  variants_en       = E'- **G.222TCM** : basic transport version, the most produced\n- **G.222VS** : electronic warfare version, two Italian aircraft\n- **G.222SAA** : firefighting version with a jettisonable tank\n- **C-27A Spartan** : ten bought by the **US Air Force** for Panama\n- Born of a 1962 **NATO** requirement no other country followed up',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aeritalia_G.222',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aeritalia_G.222',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Adrian Pingstone ( Arpingstone )',
  image_licence     = 'Public domain'
WHERE name = 'Aeritalia G.222';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aeritalia G.222';
