-- Mikoyan MiG-35 (Fulcrum-F)
--
-- Photo : MiG-35 at the MAKS-2013 (01).jpg
--   licence Public domain — Doomych
--   https://commons.wikimedia.org/wiki/File%3AMiG-35_at_the_MAKS-2013_%2801%29.jpg

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
    'MiG-35',
    'MiG-35',
    'Mikoyan MiG-35 (Fulcrum-F)',
    'Mikoyan MiG-35 (Fulcrum-F)',
    'Ultime évolution du MiG-29, restée sans client à l’export',
    'The last evolution of the MiG-29, left without an export customer',
    '/assets/airplanes/mig35.jpg',
    E'## Genèse\nLe bureau Mikoyan sort de la chute de l''URSS exsangue, tandis que son rival Soukhoï accumule les contrats d''exportation avec les dérivés du Su-27. Sa seule carte est le **MiG-29**, dont il entreprend une refonte complète : cellule allongée, avionique entièrement nouvelle, capacité de carburant portée de moitié pour corriger le défaut le plus critiqué de son prédécesseur, une autonomie insuffisante.\n\n## Conception\nSous une silhouette presque inchangée, tout diffère : un **radar à antenne active Joukovski-A**, une conduite de tir optronique à recherche infrarouge, des commandes de vol numériques et des matériaux composites qui abaissent modestement la signature radar. Les RD-33MK gagnent sept pour cent de poussée et cessent de fumer — la fumée noire du MiG-29, visible à des kilomètres, était un handicap tactique réel.\n\n## Carrière opérationnelle\nPrésenté à l''exportation dès 2007, il échoue partout : battu en **Inde** par le Rafale, écarté en Égypte, en Algérie et au Pérou. La Russie elle-même n''en commande que six exemplaires en 2018, puis quelques-uns encore. Huit appareils ont été livrés, et l''aviation russe lui a préféré le Su-35 pour ses besoins de première ligne.\n\n## Place dans l''histoire\nTechniquement, c''est le meilleur MiG jamais construit ; commercialement, c''est un échec presque total. Il illustre la difficulté d''un bureau d''études réduit à moderniser indéfiniment un appareil des années 1970 face à des concurrents mieux financés — le **Rafale**, qu''il a affronté et perdu en Inde, en est la mesure la plus nette.',
    E'## Genesis\nThe Mikoyan bureau came out of the collapse of the USSR drained, while its rival Sukhoi piled up export contracts with Su-27 derivatives. Its only card was the **MiG-29**, on which it undertook a complete overhaul: a lengthened airframe, entirely new avionics, and fuel capacity raised by half to correct its predecessor''s most criticised flaw, inadequate range.\n\n## Design\nUnder an almost unchanged silhouette, everything differs: a **Zhuk-A active array radar**, an infrared search and track fire control system, digital flight controls and composite materials that modestly lower the radar signature. The RD-33MKs gain seven per cent thrust and stop smoking — the MiG-29''s black smoke, visible for kilometres, was a real tactical handicap.\n\n## Operational career\nOffered for export from 2007, it failed everywhere: beaten in **India** by the Rafale, passed over in Egypt, Algeria and Peru. Russia itself ordered only six in 2018, then a few more. Eight aircraft have been delivered, and the Russian air force preferred the Su-35 for its front-line needs.\n\n## Place in history\nTechnically it is the best MiG ever built; commercially it is an almost total failure. It illustrates the difficulty facing a design bureau reduced to endlessly modernising a 1970s aircraft against better-funded competitors — the **Rafale**, which it met and lost to in India, is the clearest measure of it.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '2000-01-01',
    '2007-01-01',
    '2019-06-17',
    2400.0,
    2000.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM armement WHERE name = 'Kh-29L')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM armement WHERE name = 'Kh-31A')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM armement WHERE name = 'KAB-500L'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'MiG-35'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.32,
  wingspan          = 11.99,
  height            = 4.73,
  wing_area         = 38.0,
  empty_weight      = 11000,
  mtow              = 29700,
  service_ceiling   = 16000,
  climb_rate        = 330.0,
  g_limit_pos       = 9.0,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov RD-33MK',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 53.0,
  thrust_wet        = 88.3,

  -- Strate 3 : production & service
  production_start  = 2017,
  production_end    = NULL,
  units_built       = 8,
  unit_cost_usd     = 40000000,
  unit_cost_year    = 2019,
  operators_count   = 1,
  variants          = E'- **MiG-35S** : monoplace, version de série russe\n- **MiG-35UB** : biplace de conversion et de combat\n- **MiG-29M / M2** : désignations sous lesquelles le programme a d''abord été présenté\n- **MiG-35D** : proposition à poussée vectorielle, restée sans suite\n- Candidat malheureux à l''appel d''offres **MMRCA** indien de 2011, remporté par le Rafale',
  variants_en       = E'- **MiG-35S** : single-seat, the Russian production version\n- **MiG-35UB** : two-seat conversion and combat trainer\n- **MiG-29M / M2** : designations under which the programme was first presented\n- **MiG-35D** : thrust-vectoring proposal, taken no further\n- Unsuccessful contender in India''s 2011 **MMRCA** tender, won by the Rafale',

  -- Strate 4 : qualitatif
  nickname          = 'Fulcrum-F',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan_MiG-35',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan_MiG-35',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Doomych',
  image_licence     = 'Public domain'
WHERE name = 'MiG-35';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'MiG-35';
