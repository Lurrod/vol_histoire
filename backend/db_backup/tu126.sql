-- Tupolev Tu-126 (Moss)
--
-- Photo : Tu-126.jpg
--   licence Public domain — Unknown author (U.S. Department of Defense, VIRIN DF-SN-83-01231)
--   https://commons.wikimedia.org/wiki/File:Tu-126.jpg

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
    'Tupolev Tu-126',
    'Tupolev Tu-126',
    'Tupolev Tu-126 (Moss)',
    'Tupolev Tu-126 (Moss)',
    'Un avion de ligne Tu-114 coiffé d''un radôme tournant, sentinelle soviétique face aux bombardiers venus du Nord',
    'A Tu-114 airliner topped with a rotodome, the Soviet sentinel against bombers coming from the north',
    '/assets/airplanes/tu126.jpg',
    E'## Genèse\nEn 1958, l''URSS s''inquiète d''une frappe nucléaire américaine venue du Nord. Couvrir l''immense littoral arctique soviétique de radars au sol serait aussi complexe que coûteux : Moscou commande donc au bureau **Tupolev** un avion de guet aérien. Les ingénieurs essaient de loger le système radar dans un **Tu-95**, puis dans un Tu-116, avant de retenir l''avion de ligne **Tu-114**, dont le fuselage plus large règle les problèmes de refroidissement et de place pour les opérateurs.\n\n## Conception\nLe radar **Liana**, « Flap Jack » pour l''OTAN, tourne dans un radôme rotatif monté au-dessus du fuselage. Douze hommes servent à bord, plus un équipage complet de relève, car une perche de ravitaillement en vol porte l''endurance à 20 heures, contre 10 sans ravitaillement. Quatre turbopropulseurs **Kouznetsov NK-12MV** de 14 795 ch, entraînant chacun deux hélices contrarotatives, emmènent ses 171 tonnes à 790 km/h. Mais ces grandes hélices perturbent le radar, efficace au-dessus de la mer et nettement moins au-dessus des terres ; un nouveau radar, le **Shmel**, n''améliore les choses que marginalement. Surtout, le Tu-126 ne sait pas détecter vers le bas.\n\n## Carrière opérationnelle\nLe prototype vole le 23 janvier 1962 et les essais se poursuivent jusqu''à l''automne 1964. Le Tu-126 entre en service en 1965 ; huit exemplaires de série sont construits jusqu''en 1968, tous rattachés à la base de **Šiauliai**. L''Occident ne l''identifie qu''en 1968, après son apparition dans un documentaire soviétique. Le renseignement occidental le juge inférieur à ses homologues, incapable de repérer missiles de croisière et petits avions à basse altitude, mais doté de puissants moyens de brouillage. Le passage de l''OTAN à la pénétration à basse altitude le rend largement dépassé.\n\n## Place dans l''histoire\nLe Tu-126 sert dans l''armée de l''air soviétique jusqu''en 1984, année où le dernier exemplaire est retiré au profit du **Beriev A-50**. Issu de la même famille que le bombardier Tu-95 et le patrouilleur **Tu-142**, il incarne la réponse soviétique à la menace des bombardiers venus de l''Arctique : un radar volant capable de veiller loin au-dessus de la mer, mais aveugle au ras du sol, une faiblesse qui l''a vite rendu dépassé.',
    E'## Genesis\nIn 1958 the Soviet Union grew concerned about an American nuclear strike from the north. Covering the enormous Soviet Arctic coast with ground radars would be both complex and expensive, so Moscow ordered the **Tupolev** bureau to design an airborne early warning aircraft. Engineers tried to fit the radar system into a **Tu-95** and then a Tu-116, before settling on the **Tu-114** airliner, whose wider fuselage solved the problems of cooling and operator space.\n\n## Design\nThe **Liana** radar, ''Flap Jack'' to NATO, turned inside a rotodome mounted above the fuselage. Twelve men served on board, plus a full relief crew, because an in-flight refuelling probe extended endurance to 20 hours, against 10 without refuelling. Four **Kuznetsov NK-12MV** turboprops of 14,795 hp, each driving two contra-rotating propellers, took its 171 tonnes to 790 km/h. But those large propellers seriously compromised the radar, which worked well over water and much less well over land; a new radar, the **Shmel**, improved matters only marginally. Above all, the Tu-126 had no look-down capability.\n\n## Operational career\nThe prototype flew on 23 January 1962 and testing continued until the autumn of 1964. The Tu-126 entered service in 1965; eight production aircraft were built up to 1968, all nominally based at **Šiauliai**. The West only identified it in 1968, after it appeared in a Soviet documentary film. Western intelligence judged it inferior to its Western equivalents, unable to detect cruise missiles or small aircraft at low level, but fitted with powerful jamming equipment. NATO''s switch to low-level penetration made it largely irrelevant.\n\n## Place in history\nThe Tu-126 served with the Soviet Air Force until 1984, when the last example was retired in favour of the **Beriev A-50**. From the same family as the Tu-95 bomber and the **Tu-142** patrol aircraft, it embodied the Soviet answer to the threat of bombers coming over the Arctic: a flying radar able to keep watch far out over the sea, but blind close to the ground, a weakness that soon left it outdated.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1958-01-01',
    '1962-01-23',
    '1965-01-01',
    790,
    7000,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-126'), (SELECT id FROM tech WHERE name = 'Radôme rotatif')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-126'), (SELECT id FROM tech WHERE name = 'Réacteur Kuznetsov NK-12')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-126'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-126'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-126'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-126'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 56.5,
  wingspan          = 51.4,
  height            = 16.05,
  wing_area         = 311.1,
  empty_weight      = 103000,
  mtow              = 171000,
  service_ceiling   = 10700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 12,

  -- Strate 2 : motorisation
  engine_name       = 'Kuznetsov NK-12MV (14 795 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1968,
  units_built       = 9,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Prototype** : premier vol le 23 janvier 1962, essais jusqu''à l''automne 1964\n- **Tu-126 de série** : huit exemplaires construits de 1965 à 1968, basés à Šiauliai\n- **Radar Liana** (Flap Jack) dans un radôme rotatif au-dessus du fuselage\n- **Radar Shmel** : radar de remplacement, gain jugé marginal\n- **Perche de ravitaillement en vol** : endurance portée de 10 à 20 heures',
  variants_en       = E'- **Prototype**: first flight on 23 January 1962, testing until autumn 1964\n- **Production Tu-126**: eight built from 1965 to 1968, based at Šiauliai\n- **Liana radar** (Flap Jack) in a rotodome above the fuselage\n- **Shmel radar**: replacement radar, judged only a marginal improvement\n- **In-flight refuelling probe**: endurance extended from 10 to 20 hours',

  -- Strate 4 : qualitatif
  nickname          = 'Moss',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-126',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-126',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Tupolev Tu-126';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tupolev Tu-126';
