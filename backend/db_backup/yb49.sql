-- Northrop YB-49
--
-- Photo : YB49-7 300.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:YB49-7_300.jpg

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
    'Northrop YB-49',
    'Northrop YB-49',
    'Northrop YB-49 Flying Wing',
    'Northrop YB-49 Flying Wing',
    'Huit réacteurs, une aile et rien d’autre : le bombardier de 1947 dont le B-2 est l’héritier',
    'Eight jets, one wing and nothing else: the 1947 bomber whose heir is the B-2',
    '/assets/airplanes/yb49.jpg',
    E'## Genèse\n**Jack Northrop** poursuit depuis les années 1930 une idée fixe : supprimer le fuselage et l''empennage, qui ne portent rien et freinent tout, pour ne garder qu''une aile. En 1941, l''US Army Air Forces lui commande le **XB-35**, bombardier stratégique en aile volante à quatre moteurs à pistons et hélices propulsives contrarotatives. Les réducteurs d''hélice vibrent et cassent, le programme glisse. En 1945, l''armée fait convertir deux cellules de présérie en avions à réaction : ce sont les YB-49.\n\n## Conception\nUne aile de **52,4 mètres** d''envergure, sans rien qui dépasse, où sont noyés huit réacteurs **Allison J35** de 18 kN. L''équipage loge dans l''épaisseur de l''aile. Les arbres d''hélice du XB-35 jouaient le rôle de dérives : pour compenser leur disparition, quatre petites dérives et des cloisons de décrochage sont ajoutées au bord de fuite. La stabilité en lacet reste médiocre, ce qui gêne la visée : un bombardier qui ondule en cap pendant l''approche de l''objectif est un mauvais bombardier.\n\n## Carrière opérationnelle\nAucune. Premier vol le **21 octobre 1947**. L''appareil tient six heures et demie au-dessus de 12 000 mètres et traverse les États-Unis à grande vitesse. Le 5 juin 1948, le second YB-49 se disloque en vol lors d''un essai de décrochage ; ses cinq occupants sont tués, dont le copilote **Glen Edwards**, qui donnera son nom à la base de Muroc, devenue Edwards. La commande de série est annulée, le premier exemplaire est détruit au roulage en mars 1950, et le dernier dérivé, le YRB-49A de reconnaissance, est ferraillé en 1953. Les crédits vont au **B-36 Peacemaker** de Convair. Jack Northrop affirmera plus tard que l''annulation sanctionnait son refus de fusionner avec Convair ; aucune preuve n''en a été établie.\n\n## Place dans l''histoire\nTrois appareils construits, aucun conservé. Trente ans plus tard, l''informatique de commande de vol résout le problème de stabilité qui avait condamné l''aile volante, et la furtivité lui donne une raison d''être. Le **B-2 Spirit**, conçu par Northrop, reprend la même formule et exactement la même envergure de 52,4 mètres. Jack Northrop, mort en 1981, aurait été autorisé peu avant à en voir une maquette.',
    E'## Genesis\nSince the 1930s **Jack Northrop** had pursued a fixed idea: get rid of the fuselage and tail, which carry nothing and drag everything, and keep only a wing. In 1941 the US Army Air Forces ordered the **XB-35** from him, a flying-wing strategic bomber with four piston engines driving contra-rotating pusher propellers. The propeller gearboxes vibrated and failed, and the programme slipped. In 1945 the Army had two pre-production airframes converted to jet power: these were the YB-49s.\n\n## Design\nA wing of **52.4 metres** span with nothing protruding, in which eight **Allison J35** jets of 18 kN were buried. The crew sat within the thickness of the wing. The XB-35’s propeller shafts had acted as fins: to make up for their loss, four small fins and wing fences were added at the trailing edge. Directional stability remained poor, which hampered aiming: a bomber that wanders in heading on the bomb run is a bad bomber.\n\n## Operational career\nNone. First flight on **21 October 1947**. The aircraft stayed six and a half hours above 12,000 metres and crossed the United States at high speed. On 5 June 1948 the second YB-49 broke up in flight during a stall test; its five occupants were killed, among them co-pilot **Glen Edwards**, who gave his name to Muroc air base, which became Edwards. The production order was cancelled, the first aircraft was destroyed in a taxiing accident in March 1950, and the last derivative, the YRB-49A reconnaissance aircraft, was scrapped in 1953. The money went to Convair’s **B-36 Peacemaker**. Jack Northrop later claimed the cancellation punished his refusal to merge with Convair; no proof of this has ever been established.\n\n## Place in history\nThree aircraft built, none preserved. Thirty years later, flight-control computers solved the stability problem that had doomed the flying wing, and stealth gave it a reason to exist. The **B-2 Spirit**, designed by Northrop, uses the same formula and exactly the same 52.4-metre span. Jack Northrop, who died in 1981, is said to have been allowed to see a model of it shortly before.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-01',
    '1947-10-21',
    NULL,
    793.0,
    6437.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YB-49'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude'));

-- 'Aile volante' : nouvelle entrée de référentiel (voir _newrefs_lot27.sql),
-- à déclarer dans db.sql avant chargement de cette fiche.
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YB-49'), (SELECT id FROM tech WHERE name = 'Aile volante'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop YB-49'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Northrop YB-49'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.18,
  wingspan          = 52.43,
  height            = 4.62,
  wing_area         = 371.6,
  empty_weight      = 40116,
  mtow              = 87969,
  service_ceiling   = 13930,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J35-A-15',
  engine_count      = 8,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XB-35 / YB-35** : ailes volantes à moteurs à pistons et hélices propulsives, dont dérivent les YB-49\n- **YB-49** : deux YB-35 convertis à huit réacteurs J35 ; le second perdu le 5 juin 1948\n- **YRB-49A** : version de reconnaissance à six réacteurs, premier vol le 4 mai 1950, ferraillée en 1953\n- **RB-49** : série de reconnaissance commandée puis annulée\n- Charge militaire prévue : **7 250 kg** de bombes',
  variants_en       = E'- **XB-35 / YB-35** : piston-engined flying wings with pusher propellers, from which the YB-49s derive\n- **YB-49** : two YB-35s converted to eight J35 jets; the second lost on 5 June 1948\n- **YRB-49A** : six-engined reconnaissance version, first flight on 4 May 1950, scrapped in 1953\n- **RB-49** : reconnaissance production series ordered then cancelled\n- Planned load: **7,250 kg** of bombs',

  -- Strate 4 : qualitatif
  nickname          = 'Flying Wing',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_YB-49',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_YB-49',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Northrop YB-49';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop YB-49';
