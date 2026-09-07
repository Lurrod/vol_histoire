-- Soukhoï Su-33
--
-- Photo : Sukhoi Su-33 launching from the Admiral Kuznetsov.jpg
--   licence CC BY 4.0 — И. Руденко
--   https://commons.wikimedia.org/wiki/File%3ASukhoi_Su-33_launching_from_the_Admiral_Kuznetsov.jpg

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
    'Su-33',
    'Su-33',
    'Soukhoï Su-33',
    'Sukhoi Su-33',
    'Version navalisée du Su-27, matrice du Shenyang J-15',
    'Navalised Su-27, template of the Shenyang J-15',
    '/assets/airplanes/su33.jpg',
    E'## Genèse\nL''URSS construit dans les années 1980 son premier porte-avions à pont continu, l''**Amiral Kouznetsov**, sans catapultes : les appareils devront décoller par leurs propres moyens depuis un tremplin. Il faut donc un chasseur au rapport poussée/poids exceptionnel. Le Su-27, déjà surmotorisé, est le candidat évident.\n\n## Conception\nAux modifications navales habituelles — train renforcé, crosse d''appontage, ailes et empennage repliables, protection contre la corrosion — s''ajoutent des **plans canard** qui améliorent la portance à basse vitesse et raccourcissent l''approche. C''est le seul Flanker de série à en recevoir. Une perche de ravitaillement escamotable compense l''emport de carburant réduit au décollage sur tremplin.\n\n## Carrière opérationnelle\nTrente-cinq exemplaires seulement, tous russes. Leur unique déploiement de combat a lieu en **2016-2017** au large de la Syrie ; il est écourté après la perte de deux appareils lors d''incidents d''appontage. La flotte est modernisée pour la frappe au sol à partir de 2016.\n\n## Place dans l''histoire\nFaute d''un porte-avions disponible, le Su-33 n''aura jamais servi comme prévu. Sa vraie postérité est chinoise : un prototype **T-10K** inachevé acheté à l''Ukraine en 2001 a servi de base au **Shenyang J-15**, aujourd''hui produit en bien plus grand nombre que l''original.',
    E'## Genesis\nIn the 1980s the USSR built its first full-deck carrier, the **Admiral Kuznetsov**, without catapults: aircraft would have to take off under their own power from a ski-jump. That demanded a fighter with an exceptional thrust-to-weight ratio. The already over-powered Su-27 was the obvious candidate.\n\n## Design\nTo the usual naval modifications — strengthened gear, arrestor hook, folding wings and tailplanes, corrosion protection — were added **canards** that improve low-speed lift and shorten the approach. It is the only production Flanker to have them. A retractable refuelling probe offsets the reduced fuel load possible on a ski-jump take-off.\n\n## Operational career\nOnly thirty-five built, all Russian. Their single combat deployment came in **2016-2017** off Syria; it was cut short after two aircraft were lost in landing accidents. The fleet was upgraded for ground attack from 2016.\n\n## Place in history\nFor want of an available carrier, the Su-33 never served as intended. Its real legacy is Chinese: an unfinished **T-10K** prototype bought from Ukraine in 2001 became the basis of the **Shenyang J-15**, now built in far greater numbers than the original.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1984-01-01',
    '1987-08-17',
    '1998-08-31',
    2300.0,
    3000.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM tech WHERE name = 'Radar N001')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM armement WHERE name = 'GSh-30-1')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM armement WHERE name = 'R-27R')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM armement WHERE name = 'R-77')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM armement WHERE name = 'Kh-31A'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-33'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.19,
  wingspan          = 14.7,
  height            = 5.93,
  wing_area         = 62.0,
  empty_weight      = 18400,
  mtow              = 33000,
  service_ceiling   = 17000,
  climb_rate        = 246,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Saturn AL-31F3',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 74.5,
  thrust_wet        = 125.5,

  -- Strate 3 : production & service
  production_start  = 1987,
  production_end    = 1999,
  units_built       = 35,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Su-27K** : désignation soviétique d''origine\n- **Su-33** : désignation russe de série\n- **Su-33UB** : biplace côte à côte, resté prototype\n- **Shenyang J-15** : dérivé chinois développé à partir d''un prototype T-10K acquis en Ukraine',
  variants_en       = E'- **Su-27K** : original Soviet designation\n- **Su-33** : Russian production designation\n- **Su-33UB** : side-by-side two-seater, remained a prototype\n- **Shenyang J-15** : Chinese derivative developed from a T-10K prototype acquired in Ukraine',

  -- Strate 4 : qualitatif
  nickname          = 'Flanker-D',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soukho%C3%AF_Su-33',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sukhoi_Su-33',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'И. Руденко',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Su-33';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Su-33';
