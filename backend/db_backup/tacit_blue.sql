-- Northrop Tacit Blue
--
-- Photo : Northrop Tacit Blue Whale.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Northrop_Tacit_Blue_Whale.jpg

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
    'Northrop Tacit Blue',
    'Northrop Tacit Blue',
    'Northrop Tacit Blue',
    'Northrop Tacit Blue',
    'La « baleine » de Groom Lake : la furtivité par les courbes, avant le B-2',
    'The “Whale” of Groom Lake: stealth through curves, before the B-2',
    '/assets/airplanes/tacit-blue.jpg',
    E'## Genèse\nÀ la fin des années 1970, le Pentagone cherche à briser une offensive des divisions blindées du pacte de Varsovie par des frappes massives à distance de sécurité : c''est le programme **Assault Breaker**. Il faut pour cela un avion capable de surveiller le champ de bataille au radar, en profondeur, sans se faire abattre. En décembre 1976, la DARPA lance le programme BSAX (Battlefield Surveillance Aircraft-Experimental), auquel Northrop répond par un dessin qui ne ressemble à rien de connu.\n\n## Conception\nLà où le **F-117** de Lockheed, contemporain, réduit sa signature par des facettes planes, Tacit Blue explore la voie inverse : des **surfaces courbes** continues qui dévient les ondes radar. Le fuselage massif, presque rectangulaire, abrite un radar à faible probabilité d''interception ; l''entrée d''air unique est placée sur le dos, hors de vue des radars au sol. L''appareil est si instable qu''il exige une commande de vol électrique à quadruple redondance. Ses formes lui valent le surnom de **Whale**, la baleine.\n\n## Carrière opérationnelle\nAucune au sens militaire. L''unique exemplaire vole pour la première fois le 5 février 1982 sur la base secrète de **Groom Lake**, aux mains de Richard G. Thomas. En trois ans, il accomplit 135 vols et environ 250 heures, souvent trois ou quatre fois par semaine, avant d''être stocké en 1985. Son existence reste secrète jusqu''au 30 avril 1996 ; il est aujourd''hui exposé au musée national de l''US Air Force, à Dayton.\n\n## Place dans l''histoire\nTacit Blue a prouvé qu''une forme courbe pouvait être furtive et qu''on savait la calculer. Northrop en reprend les leçons sur le **B-2 Spirit**, dont l''aile volante aux surfaces arrondies prolonge les mêmes principes, et le radar du programme nourrit celui de l''avion de surveillance Joint STARS. Le démonstrateur, lui, ne sera jamais reproduit : un second exemplaire, construit à moitié, ne servit que de réserve de pièces.',
    E'## Genesis\nIn the late 1970s the Pentagon sought to break an offensive by Warsaw Pact armoured divisions through massed stand-off strikes: the **Assault Breaker** programme. That required an aircraft able to watch the battlefield by radar, in depth, without being shot down. In December 1976 DARPA launched the BSAX (Battlefield Surveillance Aircraft-Experimental) programme, to which Northrop responded with a design unlike anything seen before.\n\n## Design\nWhere Lockheed''s contemporary **F-117** reduced its signature with flat facets, Tacit Blue explored the opposite path: continuous **curved surfaces** that deflect radar waves. The massive, almost rectangular fuselage houses a low-probability-of-intercept radar; the single air intake sits on top, out of sight of ground radars. The aircraft was so unstable that it required a quadruple-redundant fly-by-wire system. Its shape earned it the nickname **Whale**.\n\n## Operational career\nNone in the military sense. The only example first flew on 5 February 1982 at the secret **Groom Lake** base, flown by Richard G. Thomas. In three years it made 135 flights and about 250 hours, often three or four times a week, before being placed in storage in 1985. Its existence remained secret until 30 April 1996; it is now displayed at the National Museum of the US Air Force in Dayton.\n\n## Place in history\nTacit Blue proved that a curved shape could be stealthy and that it could be calculated. Northrop carried its lessons over to the **B-2 Spirit**, whose rounded flying wing extends the same principles, and the programme''s radar fed into that of the Joint STARS surveillance aircraft. The demonstrator itself was never reproduced: a second, half-built airframe served only as a source of spare parts.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1976-12-01',
    '1982-02-05',
    NULL,
    463.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop Tacit Blue'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Northrop Tacit Blue'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Northrop Tacit Blue'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop Tacit Blue'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Northrop Tacit Blue'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop Tacit Blue'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.02,
  wingspan          = 14.68,
  height            = 3.23,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 13608,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett ATF3-6',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux sans postcombustion',
  engine_type_en    = 'Non-afterburning turbofan',
  thrust_dry        = 24.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Exemplaire unique**, un second construit à moitié servant de réserve de pièces\n- **135 vols**, environ 250 heures, de février 1982 à 1985\n- **Surfaces courbes** et entrée d''air dorsale pour réduire la signature radar\n- **Radar à faible probabilité d''interception**, précurseur de celui du Joint STARS\n- Déclassifié le **30 avril 1996**, exposé au musée national de l''US Air Force',
  variants_en       = E'- **Single example**, a second half-built airframe serving as a spares source\n- **135 flights**, about 250 hours, from February 1982 to 1985\n- **Curved surfaces** and a dorsal intake to reduce the radar signature\n- **Low-probability-of-intercept radar**, forerunner of the Joint STARS radar\n- Declassified on **30 April 1996**, displayed at the National Museum of the US Air Force',

  -- Strate 4 : qualitatif
  nickname          = 'Whale',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Tacit_Blue',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Tacit_Blue',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Northrop Tacit Blue';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'tres_elevee' WHERE name = 'Northrop Tacit Blue';
