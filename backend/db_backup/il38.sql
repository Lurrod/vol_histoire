-- Iliouchine Il-38 (May)
--
-- Photo : A-7E VA-27 IL-38 1981.jpeg
--   licence Public domain — Photographer's Name: Lt. David M. Kennedy, USN
--   https://commons.wikimedia.org/wiki/File%3AA-7E_VA-27_IL-38_1981.jpeg

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
    'Iliouchine Il-38',
    'Ilyushin Il-38',
    'Iliouchine Il-38 (May)',
    'Ilyushin Il-38 (May)',
    'Patrouilleur maritime soviétique, pendant direct du P-3 Orion',
    'Soviet maritime patroller, direct counterpart of the P-3 Orion',
    '/assets/airplanes/il38.jpg',
    E'## Genèse\nL''arrivée des sous-marins lance-missiles américains change la donne : l''URSS doit pouvoir les chercher au large, et non plus seulement défendre ses approches. Comme Lockheed l''a fait avec l''Electra pour le **P-3 Orion**, Iliouchine part d''un avion de ligne existant, l''Il-18, et le convertit — la solution la plus rapide et la moins coûteuse.\n\n## Conception\nL''aile est avancée de trois mètres pour compenser le déplacement du centre de gravité qu''imposent les équipements de détection, logés à l''avant. Une **soute à armement** occupe la place de la soute à bagages, un détecteur d''anomalies magnétiques allonge la queue. Quatre turbopropulseurs AI-20 donnent douze heures de vol. La cabine, en revanche, n''accueille que sept hommes contre onze sur le P-3 : l''automatisation soviétique est plus poussée, mais les capteurs moins fins.\n\n## Carrière opérationnelle\nIl patrouille la mer de Barents, la Baltique et le Pacifique nord pendant toute la guerre froide, et opère depuis l''Égypte, la Syrie, la Libye et le Yémen au gré des accords soviétiques. L''**Inde** en exploite cinq à partir de 1977. La version modernisée Il-38N vole toujours dans l''aéronavale russe, cinquante-huit ans après la mise en service.\n\n## Place dans l''histoire\nSoixante-cinq exemplaires seulement, contre sept cent cinquante-sept P-3 : l''URSS n''a jamais eu les moyens navals de son rival. Il forme malgré tout, avec le **Tu-142**, l''essentiel de la lutte anti-sous-marine soviétique, et se retrouve face au **Breguet Atlantique** européen dans les mêmes eaux, pour la même mission, pendant trente ans.',
    E'## Genesis\nThe arrival of American missile submarines changed everything: the USSR had to be able to hunt them far out to sea, not merely defend its approaches. As Lockheed had done with the Electra for the **P-3 Orion**, Ilyushin started from an existing airliner, the Il-18, and converted it — the quickest and cheapest solution.\n\n## Design\nThe wing was moved three metres forward to offset the shift in centre of gravity caused by the detection equipment housed in the nose. A **weapons bay** takes the place of the baggage hold, and a magnetic anomaly detector extends the tail. Four AI-20 turboprops give twelve hours aloft. The cabin, however, seats only seven men against eleven in the P-3: Soviet automation went further, but the sensors were less capable.\n\n## Operational career\nIt patrolled the Barents Sea, the Baltic and the North Pacific throughout the Cold War, and operated from Egypt, Syria, Libya and Yemen as Soviet agreements allowed. **India** has flown five since 1977. The upgraded Il-38N still serves in Russian naval aviation, fifty-eight years after entering service.\n\n## Place in history\nOnly sixty-five built, against seven hundred and fifty-seven P-3s: the USSR never had its rival''s naval means. It nevertheless formed, with the **Tu-142**, the backbone of Soviet anti-submarine warfare, and faced the European **Breguet Atlantique** in the same waters, on the same mission, for thirty years.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1960-01-01',
    '1961-09-27',
    '1967-01-01',
    650.0,
    9500.0,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM armement WHERE name = 'APR-3')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM armement WHERE name = 'RGB-75')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 40.19,
  wingspan          = 37.42,
  height            = 10.16,
  wing_area         = 140.0,
  empty_weight      = 36000,
  mtow              = 63500,
  service_ceiling   = 10000,
  climb_rate        = 10.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2200,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-20M',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1972,
  units_built       = 65,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Il-38** : version initiale à système de détection Berkut\n- **Il-38N** : modernisation russe au système Novella, en service depuis 2014\n- **Il-38SD Sea Dragon** : version livrée à l''**Inde**, seul client à l''exportation\n- **Il-20 Coot-A** : dérivé de renseignement électronique sur la même cellule\n- Bâti sur le transport civil **Il-18**, dont il reprend l''aile et les turbopropulseurs',
  variants_en       = E'- **Il-38** : initial version with the Berkut detection system\n- **Il-38N** : Russian upgrade to the Novella system, in service since 2014\n- **Il-38SD Sea Dragon** : version delivered to **India**, the only export customer\n- **Il-20 Coot-A** : signals intelligence derivative on the same airframe\n- Built on the **Il-18** civil transport, whose wing and turboprops it retains',

  -- Strate 4 : qualitatif
  nickname          = 'May',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-38',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-38',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Photographer''s Name: Lt. David M. Kennedy, USN',
  image_licence     = 'Public domain'
WHERE name = 'Iliouchine Il-38';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-38';
