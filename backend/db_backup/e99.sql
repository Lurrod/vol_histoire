-- Embraer E-99 / R-99 (EMB-145 AEW&C)
--
-- Photo : E-99 (4892580406).jpg
--   licence CC BY 2.0 — Andre Gustavo Stumpf Filho from Brasil
--   https://commons.wikimedia.org/wiki/File%3AE-99_%284892580406%29.jpg

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
    'Embraer E-99',
    'Embraer E-99',
    'Embraer E-99 / R-99 (EMB-145 AEW&C)',
    'Embraer E-99 / R-99 (EMB-145 AEW&C)',
    'Le guet aérien brésilien, né d’un avion de ligne régional',
    'Brazil’s airborne early warning, born from a regional airliner',
    '/assets/airplanes/e99.jpg',
    E'## Genèse\nLe Brésil lance en 1990 le programme **SIVAM**, destiné à surveiller les cinq millions de kilomètres carrés de l''Amazonie — déforestation, orpaillage, trafics, incursions aériennes. Cela suppose un radar volant. Acheter un **E-3 Sentry** est hors de prix ; Embraer propose de partir d''un appareil qu''il produit déjà.\n\n## Conception\nL''**EMB-145**, biréacteur régional de cinquante places, reçoit sur le dos une **antenne Erieye** suédoise en forme de poutre — solution plus légère et moins coûteuse qu''un radôme rotatif, au prix d''une couverture non circulaire : l''antenne voit de part et d''autre, mais pas devant ni derrière. Pour surveiller une frontière ou un fleuve, c''est suffisant.\n\n## Carrière opérationnelle\nQuatorze exemplaires. Cinq E-99 et trois R-99 servent au Brésil dans le cadre du SIVAM ; le **Mexique**, la **Grèce** et l''**Inde** en achètent également. Ils assurent la police du ciel pendant la Coupe du monde de 2014 et les Jeux olympiques de 2016, et surveillent en permanence l''espace aérien amazonien.\n\n## Place dans l''histoire\nQuatorze exemplaires. L''E-99 illustre une stratégie que le Brésil applique depuis quarante ans : utiliser une cellule civile à succès comme base militaire, plutôt que d''en concevoir une spécifique. Le **KC-390** en est l''expression la plus aboutie, et l''**EMB-312 Tucano** en fut la première.',
    E'## Genesis\nIn 1990 Brazil launched the **SIVAM** programme to watch the five million square kilometres of Amazonia — deforestation, illegal mining, trafficking, air incursions. That meant a flying radar. Buying an **E-3 Sentry** was out of reach; Embraer proposed starting from an aircraft it already built.\n\n## Design\nThe **EMB-145**, a fifty-seat regional twinjet, receives a Swedish **Erieye** beam array on its spine — lighter and cheaper than a rotating radome, at the price of non-circular coverage: the array sees to either side, but not ahead or behind. For watching a border or a river, that is enough.\n\n## Operational career\nFourteen built. Five E-99s and three R-99s serve in Brazil under SIVAM; **Mexico**, **Greece** and **India** have also bought them. They policed the skies during the 2014 World Cup and the 2016 Olympics, and watch Amazonian airspace continuously.\n\n## Place in history\nFourteen built. The E-99 illustrates a strategy Brazil has applied for forty years: use a successful civil airframe as a military base rather than design a dedicated one. The **KC-390** is its most accomplished expression, and the **EMB-312 Tucano** was its first.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1997-01-01',
    '1999-05-22',
    '2002-07-01',
    833.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer E-99'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'Embraer E-99'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Embraer E-99'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer E-99'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Embraer E-99'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.87,
  wingspan          = 20.04,
  height            = 6.76,
  wing_area         = 51.18,
  empty_weight      = 13500,
  mtow              = 24100,
  service_ceiling   = 11278,
  climb_rate        = 12.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1500,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce AE 3007A1',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 31.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1999,
  production_end    = NULL,
  units_built       = 14,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **E-99** : version de guet aérien, à antenne **Erieye** suédoise sur le dos\n- **R-99** : version de télédétection, radar à ouverture synthétique et capteurs optiques\n- **P-99** : version de patrouille maritime, proposée à l''export\n- Dérivé de l''avion de ligne régional **EMB-145**, produit à plus de mille exemplaires\n- Exporté vers le **Mexique**, la **Grèce** et l''**Inde**',
  variants_en       = E'- **E-99** : airborne early warning version, with a Swedish **Erieye** dorsal array\n- **R-99** : remote sensing version, synthetic aperture radar and optical sensors\n- **P-99** : maritime patrol version, offered for export\n- Derived from the **EMB-145** regional airliner, built in more than a thousand examples\n- Exported to **Mexico**, **Greece** and **India**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Embraer_R-99',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Embraer_R-99',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Andre Gustavo Stumpf Filho from Brasil',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Embraer E-99';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Embraer E-99';
