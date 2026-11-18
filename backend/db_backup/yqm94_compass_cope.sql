-- Boeing YQM-94A Compass Cope B
--
-- Photo : U.S. Air Force Museum C (11).jpg
--   licence CC BY-SA 3.0 — Bubba73
--   https://commons.wikimedia.org/wiki/File:U.S._Air_Force_Museum_C_(11).jpg

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
    'Boeing YQM-94 Compass Cope',
    'Boeing YQM-94 Compass Cope',
    'Boeing YQM-94A Compass Cope B',
    'Boeing YQM-94A Compass Cope B',
    'Planeur à réaction sans pilote, décollant d''une piste pour veiller des heures durant à plus de 16 000 m',
    'An unmanned jet sailplane taking off from a runway to keep watch for hours on end above 16,000 m',
    '/assets/airplanes/yqm94-compass-cope.jpg',
    E'## Genèse\nEn 1971, l''US Air Force lance le programme **Compass Cope** : un drone de reconnaissance de nouvelle génération qui décollerait et se poserait sur une piste comme un avion piloté, et tiendrait jusqu''à 24 heures en haute altitude pour la surveillance, le relais de communications ou le prélèvement atmosphérique. **Boeing** est d''abord retenu seul et reçoit la même année un contrat pour deux démonstrateurs YQM-94A, plus tard redésignés YGQM-94A. Mais **Ryan Aeronautical** propose une solution concurrente, et l''Air Force lui commande l''année suivante deux YQM-98A : le Compass Cope B de Boeing aura un rival.\n\n## Conception\nLe YQM-94A est en somme un planeur à réaction : longue aile haute et droite, double dérive, train tricycle rétractable et turboréacteur General Electric J97 dans une nacelle dorsale. La moitié inférieure du fuselage est en nid d''abeilles de fibre de verre, le matériau des radômes, et les ailes en nid d''abeilles revêtu d''aluminium isolent les réservoirs du froid de l''altitude. Démonstrateur oblige, il réutilise des éléments existants : liaison de données dérivée du radar AN/TPW-2A, commandes de vol issues du système Sperry du Beechcraft QU-22B Pave Eagle, train de Rockwell Commander. Sans guidage autonome, il est piloté depuis le sol grâce à une caméra de nez, un système d''abord éprouvé sur un **Cessna 172** télépiloté pendant 150 vols, dont 90 de nuit.\n\n## Essais\nLe premier exemplaire vole le 28 juillet 1973 à Edwards, mais il est détruit dès son deuxième vol, le 4 août : un isolant de mylar endommagé provoque un court-circuit dans un accéléromètre de gouverne de direction, et, avec une fausse indication de vitesse et une aile gauche trop lourde, l''atterrissage brutal qui s''ensuit lui est fatal. Le second vole le 2 novembre 1974, mène le programme d''évaluation à son terme et tient 17 heures 24 minutes au-dessus de 16 800 m. En août 1976, Boeing remporte la compétition grâce à un coût plus faible et reçoit un contrat de prototypes de présérie du YQM-94B opérationnel.\n\n## Place dans l''histoire\nRyan, dont le YQM-98 s''était montré supérieur sur certains points, conteste ce choix ; la question devient sans objet en juillet 1977, quand tout le programme Compass Cope est annulé, apparemment faute de capteurs au point. Avec son rival, le YQM-94 marque pourtant un tournant : un drone de reconnaissance qui décolle et se pose sur piste comme un avion piloté, là où le **Firefly** devait être largué d''un DC-130 et récupéré par hélicoptère. Le second exemplaire est confié en septembre 1979 au musée national de l''US Air Force.',
    E'## Genesis\nIn 1971 the US Air Force launched the **Compass Cope** programme: a new-generation reconnaissance drone that would take off and land from a runway like a manned aircraft and stay at high altitude for up to 24 hours for surveillance, communications relay or atmospheric sampling. **Boeing** was first chosen as sole source and received a contract that year for two YQM-94A demonstrators, later redesignated YGQM-94A. But **Ryan Aeronautical** pitched an alternative, and the following year the Air Force ordered two YQM-98As from it: Boeing''s Compass Cope B would have a rival.\n\n## Design\nThe YQM-94A was essentially a jet-powered sailplane: long straight shoulder wing, twin fins, retractable tricycle landing gear and a General Electric J97 turbojet in a pod on its back. The lower half of the fuselage was fibreglass honeycomb, the material used for radomes, and the aluminium-skinned honeycomb wings insulated the fuel tanks from the cold at altitude. Being a demonstrator, it reused existing equipment: a datalink based on the AN/TPW-2A radar, flight controls derived from Sperry''s system for the Beechcraft QU-22B Pave Eagle, and Rockwell Commander landing gear. With no autonomous guidance, it was flown from the ground through a nose camera, a system first proven on a remotely flown **Cessna 172** over 150 flights, 90 of them at night.\n\n## Testing\nThe first aircraft flew on 28 July 1973 at Edwards, but was destroyed on its second flight, on 4 August: damaged mylar insulation caused a short circuit in a rudder accelerometer and, combined with a false airspeed reading and an overweight left wing, the resulting hard landing was fatal. The second flew on 2 November 1974, completed the evaluation programme and stayed aloft for 17 hours 24 minutes above 16,800 m. In August 1976 Boeing won the competition on lower cost and received a contract for preproduction prototypes of the operational YQM-94B.\n\n## Place in history\nRyan, whose YQM-98 had proved superior in some respects, challenged the award; the point became moot in July 1977, when the whole Compass Cope programme was cancelled, apparently because of difficulties developing sensor payloads. Together with its rival, the YQM-94 nonetheless marked a turning point: a reconnaissance drone that took off and landed on a runway like a manned aircraft, whereas the **Firefly** had to be launched from a DC-130 and recovered by helicopter. The second aircraft went to the National Museum of the United States Air Force in September 1979.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1971-01-01',
    '1973-07-28',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YQM-94 Compass Cope'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude')),
((SELECT id FROM airplanes WHERE name = 'Boeing YQM-94 Compass Cope'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YQM-94 Compass Cope'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.8,
  wingspan          = 27.43,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 5897,
  service_ceiling   = 21340,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J97-GE-100',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 23.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **YQM-94A n° 1** : premier vol le 28 juillet 1973, détruit à l''atterrissage de son deuxième vol le 4 août 1973\n- **YQM-94A n° 2** : premier vol le 2 novembre 1974, vol de 17 h 24 min, au musée de l''US Air Force depuis 1979\n- **YGQM-94A** : nouvelle désignation des deux démonstrateurs\n- **YQM-94B** : version opérationnelle commandée en présérie en 1976, abandonnée avec le programme en 1977',
  variants_en       = E'- **YQM-94A No. 1**: first flight on 28 July 1973, destroyed landing from its second flight on 4 August 1973\n- **YQM-94A No. 2**: first flight on 2 November 1974, 17 h 24 min flight, at the US Air Force museum since 1979\n- **YGQM-94A**: later designation of both demonstrators\n- **YQM-94B**: operational version ordered as preproduction prototypes in 1976, dropped with the programme in 1977',

  -- Strate 4 : qualitatif
  nickname          = 'B-Gull',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_YQM-94_B-Gull',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bubba73',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Boeing YQM-94 Compass Cope';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing YQM-94 Compass Cope';
