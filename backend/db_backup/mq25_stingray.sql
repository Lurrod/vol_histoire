-- Boeing MQ-25 Stingray
--
-- Photo : MQ-25 refuels F-35C.jpg
--   licence Public domain — United States Navy photo courtesy of Boeing
--   https://commons.wikimedia.org/wiki/File%3AMQ-25_refuels_F-35C.jpg

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
    'MQ-25 Stingray',
    'MQ-25 Stingray',
    'Boeing MQ-25 Stingray',
    'Boeing MQ-25 Stingray',
    'Premier drone ravitailleur : il rend leur allonge aux porte-avions',
    'The first tanker drone: it gives carriers their reach back',
    '/assets/airplanes/mq25-stingray.jpg',
    E'## Genèse\nDepuis le retrait du **S-3 Viking** en 2009, l''US Navy ravitaille ses avions avec ses propres chasseurs : un Super Hornet sur cinq porte des nourrices au lieu d''armes, et use ses heures de cellule à faire le plein des autres. Le calcul est absurde. Il faut un ravitailleur — mais un ravitailleur embarqué occupe une place précieuse sur le pont.\n\n## Conception\nD''où un appareil sans pilote, plus compact qu''un avion habité à capacité égale, et suffisamment discret pour ne pas trahir la position du groupe aéronaval. Une aile haute de vingt-trois mètres, un réacteur unique, une nacelle de ravitaillement sous l''aile. La furtivité est modérée : l''appareil n''entre pas dans les défenses ennemies, il attend en retrait.\n\n## Carrière opérationnelle\nPas encore. Le démonstrateur **T1** vole en 2019 et accomplit le **4 juin 2021** ce qu''aucun engin sans pilote n''avait fait : ravitailler un avion habité en vol — un F/A-18 Super Hornet. Il récidive avec un E-2D puis un **F-35C**. Les premiers MQ-25A de série doivent embarquer vers 2026.\n\n## Place dans l''histoire\nSept exemplaires d''essai à ce jour. Le MQ-25 est le **premier aéronef sans équipage conçu d''emblée pour servir un avion habité** plutôt que pour le remplacer. Il porte aussi tout l''héritage opérationnel du **X-47B**, dont la Navy a repris l''appontage automatique en abandonnant la mission de frappe.',
    E'## Genesis\nSince the **S-3 Viking** retired in 2009, the US Navy has refuelled its aircraft with its own fighters: one Super Hornet in five carries fuel tanks instead of weapons and burns its airframe hours filling up the others. The arithmetic is absurd. A tanker was needed — but a carrier-based tanker takes up precious deck space.\n\n## Design\nHence an unmanned aircraft, more compact than a manned one of equal capacity and discreet enough not to betray the carrier group''s position. A twenty-three-metre high wing, a single engine, a refuelling pod under the wing. Stealth is moderate: the aircraft does not penetrate enemy defences, it waits behind.\n\n## Operational career\nNot yet. The **T1** demonstrator flew in 2019 and on **4 June 2021** did what no unmanned machine had done: refuel a manned aircraft in flight — an F/A-18 Super Hornet. It repeated the feat with an E-2D and then an **F-35C**. The first production MQ-25As are due aboard around 2026.\n\n## Place in history\nSeven test aircraft so far. The MQ-25 is the **first unmanned aircraft designed from the outset to serve a manned one** rather than replace it. It also carries the entire operational legacy of the **X-47B**, whose automatic carrier landing the Navy kept while abandoning the strike mission.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2016-01-01',
    '2019-09-19',
    NULL,
    740.0,
    2200.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.5,
  wingspan          = 22.9,
  height            = 3.0,
  wing_area         = 70.0,
  empty_weight      = 9000,
  mtow              = 20000,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 930,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce AE 3007N',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 44.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2021,
  production_end    = NULL,
  units_built       = 7,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **T1** : démonstrateur, premier vol en septembre 2019, immatriculé N234MQ\n- **MQ-25A** : version de série, sept exemplaires d''essai commandés\n- **4 juin 2021** : le T1 ravitaille un **F/A-18**, première mondiale\n- Doit délivrer **6 800 kg de carburant à 930 km** du porte-avions\n- Libère les **F/A-18 Super Hornet** du rôle de ravitailleur, qui use un tiers de la flotte',
  variants_en       = E'- **T1** : demonstrator, first flight September 2019, registered N234MQ\n- **MQ-25A** : production version, seven test aircraft ordered\n- **4 June 2021** : T1 refuelled an **F/A-18**, a world first\n- Designed to deliver **6,800 kg of fuel at 930 km** from the carrier\n- Frees the **F/A-18 Super Hornets** from tanking, which consumes a third of the fleet',

  -- Strate 4 : qualitatif
  nickname          = 'Stingray',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_MQ-25_Stingray',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_MQ-25_Stingray',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'United States Navy photo courtesy of Boeing',
  image_licence     = 'Public domain'
WHERE name = 'MQ-25 Stingray';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'MQ-25 Stingray';
