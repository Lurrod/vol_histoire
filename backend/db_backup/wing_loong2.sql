-- Chengdu Wing Loong II (Yilong 2)
--
-- Photo : Wing Loong II side view.jpg
--   licence CC BY-SA 4.0 — Mztourist
--   https://commons.wikimedia.org/wiki/File%3AWing_Loong_II_side_view.jpg

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
    'Wing Loong II',
    'Wing Loong II',
    'Chengdu Wing Loong II (Yilong 2)',
    'Chengdu Wing Loong II (Yilong 2)',
    'Le Reaper chinois, vendu à ceux à qui l’Amérique refuse le sien',
    'The Chinese Reaper, sold to those America refuses its own',
    '/assets/airplanes/wing-loong2.jpg',
    E'## Genèse\nLe **MQ-9 Reaper** est soumis au régime américain de contrôle des technologies de missiles, qui en interdit la vente à la plupart des pays. Il existe donc une demande considérable et non satisfaite. La Chine s''y engouffre : le Wing Loong II est explicitement conçu pour le marché d''exportation, à un quart du prix.\n\n## Conception\nL''architecture est celle du Reaper trait pour trait : vingt mètres d''envergure, empennage en V inversé, hélice propulsive, turbopropulseur, boule optronique sous le nez. Douze points d''emport et quatre tonnes deux au décollage. Il n''y a là aucune innovation, et ce n''est pas le sujet : l''appareil est **disponible**, ce que son modèle américain n''est pas.\n\n## Carrière opérationnelle\nUne dizaine de clients : Émirats arabes unis, Arabie saoudite, Égypte, Nigeria, Pakistan, Serbie, Éthiopie, Kazakhstan. Il est employé au combat en **Libye** en 2019 et 2020 par les forces du maréchal Haftar, où plusieurs exemplaires sont détruits par des **Bayraktar TB2** turcs — le premier affrontement de l''histoire entre deux flottes de drones armés.\n\n## Place dans l''histoire\nLe Wing Loong II est le premier drone armé à avoir contourné la maîtrise américaine sur cette technologie. Avec le **TB2** turc, il a rendu le drone armé accessible à une trentaine de pays qui n''auraient jamais pu s''en procurer — changement stratégique dont les guerres de la décennie 2020 portent la marque.',
    E'## Genesis\nThe **MQ-9 Reaper** falls under the American missile technology control regime, which forbids its sale to most countries. There is therefore a considerable unmet demand. China moved into it: the Wing Loong II was explicitly designed for the export market, at a quarter of the price.\n\n## Design\nThe architecture copies the Reaper feature for feature: twenty metres of span, inverted V-tail, pusher propeller, turboprop, sensor ball under the nose. Twelve hardpoints and four point two tonnes at take-off. There is no innovation here, and that is not the point: the aircraft is **available**, which its American model is not.\n\n## Operational career\nSome ten customers: the United Arab Emirates, Saudi Arabia, Egypt, Nigeria, Pakistan, Serbia, Ethiopia, Kazakhstan. It was used in combat in **Libya** in 2019 and 2020 by Marshal Haftar''s forces, where several were destroyed by Turkish **Bayraktar TB2s** — the first clash in history between two fleets of armed drones.\n\n## Place in history\nThe Wing Loong II is the first armed drone to have broken the American hold on the technology. With the Turkish **TB2**, it has put the armed drone within reach of some thirty countries that could never have obtained one — a strategic shift the wars of the 2020s bear the mark of.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '2015-01-01',
    '2017-02-27',
    '2018-01-01',
    370.0,
    4000.0,
    (SELECT id FROM manufacturer WHERE code = 'CAC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Wing Loong II'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Wing Loong II'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Wing Loong II'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Wing Loong II'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.0,
  wingspan          = 20.5,
  height            = 4.1,
  wing_area         = 30.0,
  empty_weight      = 1900,
  mtow              = 4200,
  service_ceiling   = 9000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1500,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'WJ-9',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2017,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 2000000,
  unit_cost_year    = 2018,
  operators_count   = 10,
  variants          = E'- **Wing Loong I** : version initiale de 2007, plus légère, exportée à grande échelle\n- **Wing Loong II** : version agrandie à turbopropulseur, **douze points d''emport**\n- **Wing Loong 10** : dérivé à réaction, en développement\n- *Yilong* signifie « **dragon ailé** » en chinois\n- Vendu autour de **deux millions de dollars**, soit un quart du prix d''un MQ-9',
  variants_en       = E'- **Wing Loong I** : the 2007 original, lighter and widely exported\n- **Wing Loong II** : enlarged turboprop version with **twelve hardpoints**\n- **Wing Loong 10** : jet-powered derivative, in development\n- *Yilong* means ''**winged dragon**'' in Chinese\n- Sold at around **two million dollars**, a quarter the price of an MQ-9',

  -- Strate 4 : qualitatif
  nickname          = 'Yilong 2',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Chengdu_Pterodactyl_I',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Chengdu_Wing_Loong_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mztourist',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Wing Loong II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Wing Loong II';
