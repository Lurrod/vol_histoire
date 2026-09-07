-- Convair B-36 Peacemaker
--
-- Photo : B-36h bomber in flight.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AB-36h_bomber_in_flight.jpg

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
    'B-36 Peacemaker',
    'B-36 Peacemaker',
    'Convair B-36 Peacemaker',
    'Convair B-36 Peacemaker',
    'Le plus grand bombardier jamais mis en service : six hélices et quatre réacteurs',
    'The largest bomber ever to enter service: six propellers and four jets',
    '/assets/airplanes/b36-peacemaker.jpg',
    E'## Genèse\nEn avril 1941, l''Amérique n''est pas encore en guerre mais envisage le pire : si la Grande-Bretagne tombe, il faudra bombarder l''Allemagne **depuis le sol américain**. Le cahier des charges est vertigineux — dix mille kilomètres avec dix tonnes de bombes, aller et retour, sans escale. Aucun avion au monde n''en approche. Le B-36 vole cinq ans plus tard, quand la guerre est finie et que l''adversaire a changé.\n\n## Conception\nSoixante-dix mètres d''envergure, six moteurs en étoile **montés en propulsion**, hélices tournées vers l''arrière. Cette disposition, rare, réduit la traînée mais fait surchauffer les moteurs, qui prennent feu si souvent qu''un adage circule dans les escadres : « six qui tournent, quatre qui brûlent ». À partir de la version D, on ajoute **quatre réacteurs** sous les ailes pour le décollage et la course sur objectif : dix moteurs au total, cas unique dans l''histoire.\n\n## Carrière opérationnelle\nIl n''a jamais largué une bombe en colère. Sa mission était d''exister : pendant huit ans, il est le **seul appareil au monde** capable d''atteindre l''URSS depuis l''Amérique et d''en revenir. Il vole quarante heures d''affilée, à quinze mille mètres, hors de portée des chasseurs soviétiques de l''époque. Sa version de reconnaissance photographie la Sibérie ; sa version FICON emporte un chasseur dans sa soute et le largue en vol.\n\n## Place dans l''histoire\nTrois cent quatre-vingt-quatre exemplaires. Il incarne un moment très bref de la stratégie nucléaire : celui où la dissuasion tenait à un seul avion, immense et lent. L''arrivée du **B-52 Stratofortress**, tout à réaction et deux fois plus rapide, le rend obsolète en 1959 — onze ans seulement après son entrée en service.',
    E'## Genesis\nIn April 1941 America was not yet at war but was contemplating the worst: if Britain fell, Germany would have to be bombed **from American soil**. The specification was staggering — ten thousand kilometres with ten tonnes of bombs, out and back, without stopping. No aircraft in the world came close. The B-36 flew five years later, when the war was over and the adversary had changed.\n\n## Design\nSeventy metres of span, six radial engines mounted as **pushers**, propellers facing aft. That rare arrangement cuts drag but overheats the engines, which caught fire so often that a saying went round the squadrons: “six turning, four burning”. From the D model, **four jet engines** were added under the wings for take-off and the run to the target: ten engines in all, unique in history.\n\n## Operational career\nIt never dropped a bomb in anger. Its mission was to exist: for eight years it was the **only aircraft in the world** able to reach the USSR from America and return. It flew forty hours at a stretch, at fifteen thousand metres, beyond the reach of contemporary Soviet fighters. Its reconnaissance version photographed Siberia; its FICON version carried a fighter in its bay and released it in flight.\n\n## Place in history\nThree hundred and eighty-four built. It embodies a very brief moment in nuclear strategy: the one where deterrence rested on a single aircraft, vast and slow. The arrival of the all-jet **B-52 Stratofortress**, twice as fast, made it obsolete in 1959 — just eleven years after entering service.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1941-04-11',
    '1946-08-08',
    '1948-06-26',
    672.0,
    16000.0,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 49.42,
  wingspan          = 70.1,
  height            = 14.25,
  wing_area         = 443.3,
  empty_weight      = 77580,
  mtow              = 186000,
  service_ceiling   = 13300,
  climb_rate        = 10.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 6400,
  crew              = 15,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-53 Wasp Major',
  engine_count      = 10,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1954,
  units_built       = 384,
  unit_cost_usd     = 4100000,
  unit_cost_year    = 1949,
  operators_count   = 1,
  variants          = E'- **B-36A / B** : versions initiales à six moteurs à pistons seuls\n- **B-36D** : ajout de **quatre réacteurs J47** en nacelles doubles sous voilure\n- **RB-36** : reconnaissance stratégique, la version la plus produite\n- **NB-36H** : porteur d''un réacteur nucléaire expérimental, 47 vols d''essai\n- **FICON** : emportait un RF-84K sous sa soute, largué puis récupéré en vol',
  variants_en       = E'- **B-36A / B** : initial versions with six piston engines only\n- **B-36D** : addition of **four J47 jets** in twin underwing pods\n- **RB-36** : strategic reconnaissance, the most produced version\n- **NB-36H** : carried an experimental nuclear reactor on 47 test flights\n- **FICON** : carried an RF-84K in its bay, launched and recovered in flight',

  -- Strate 4 : qualitatif
  nickname          = 'Peacemaker',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_B-36',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_B-36_Peacemaker',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'B-36 Peacemaker';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-36 Peacemaker';
