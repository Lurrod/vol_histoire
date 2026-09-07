-- North American F-86 Sabre
--
-- Photo : F-86 Sabre at the Southern Museum of Flight.JPG
--   licence CC BY-SA 3.0 — 205weeman17
--   https://commons.wikimedia.org/wiki/File%3AF-86_Sabre_at_the_Southern_Museum_of_Flight.JPG

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
    'F-86 Sabre',
    'F-86 Sabre',
    'North American F-86 Sabre',
    'North American F-86 Sabre',
    'Premier chasseur à aile en flèche occidental, symbole de la guerre de Corée',
    'First Western swept-wing fighter, symbol of the Korean War',
    '/assets/airplanes/f86-sabre.jpg',
    E'## Genèse\nLe projet part d''un chasseur à aile droite, le FJ-1 Fury. En 1945, les ingénieurs de North American consultent les rapports allemands saisis sur l''**aile en flèche** et redessinent l''appareil : la flèche de 35° repousse les effets de compressibilité et fait gagner près de 100 km/h. C''est le premier chasseur occidental à en tirer parti.\n\n## Conception\nEntrée d''air frontale, six mitrailleuses de 12,7 mm groupées dans le nez, et surtout des **becs de bord d''attaque automatiques** qui préservent la maniabilité à basse vitesse. Le F-86E introduit un empennage entièrement mobile — le *flying tail* — qui conserve l''autorité en tangage à l''approche de Mach 1, avantage décisif face au MiG-15.\n\n## Carrière opérationnelle\nEn **Corée**, le Sabre affronte le MiG-15 dans le premier duel de chasseurs à réaction de l''histoire, au-dessus de la zone que les pilotes baptisent *MiG Alley*. Le MiG monte plus haut et grimpe plus vite ; le Sabre vire mieux, vise mieux et sert des équipages mieux formés. Il équipera ensuite trente pays, du Pakistan à l''Argentine, jusque dans les années 1990.\n\n## Place dans l''histoire\nPrès de **10 000 exemplaires**, l''avion de combat occidental le plus produit de l''après-guerre. Le Sabre fonde la lignée qui mène au F-100 Super Sabre et à toute la série des Century ; son duel avec le MiG-15 reste la matrice de tous les débats sur la comparaison des chasseurs.',
    E'## Genesis\nThe project began as a straight-wing fighter, the FJ-1 Fury. In 1945 North American’s engineers read the captured German reports on the **swept wing** and redrew the aircraft: a 35° sweep pushed back compressibility effects and gained nearly 100 km/h. It was the first Western fighter to exploit it.\n\n## Design\nA nose intake, six 12.7 mm machine guns grouped in the nose, and above all **automatic leading-edge slats** preserving handling at low speed. The F-86E introduced an all-moving tailplane — the *flying tail* — which keeps pitch authority approaching Mach 1, a decisive advantage over the MiG-15.\n\n## Operational career\nOver **Korea** the Sabre met the MiG-15 in the first jet fighter duel in history, above the area pilots named *MiG Alley*. The MiG flew higher and climbed faster; the Sabre turned better, aimed better and carried better-trained crews. It went on to equip thirty countries, from Pakistan to Argentina, into the 1990s.\n\n## Place in history\nNearly **10,000 built**, the most-produced Western combat aircraft of the post-war era. The Sabre founded the line leading to the F-100 Super Sabre and the whole Century series; its duel with the MiG-15 remains the template for every debate about comparing fighters.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-01-01',
    '1947-10-01',
    '1949-02-01',
    1106.0,
    2450.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM tech WHERE name = 'Système de navigation semi-automatique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.44,
  wingspan          = 11.3,
  height            = 4.5,
  wing_area         = 26.76,
  empty_weight      = 5046,
  mtow              = 8234,
  service_ceiling   = 14600,
  climb_rate        = 45,
  g_limit_pos       = 7.33,
  g_limit_neg       = NULL,
  combat_radius     = 700,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-27',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 26.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1956,
  units_built       = 9860,
  unit_cost_usd     = 219457,
  unit_cost_year    = 1950,
  operators_count   = 30,
  variants          = E'- **F-86A / E / F** : chasseurs de jour, versions de la guerre de Corée\n- **F-86D Sabre Dog** : intercepteur tout-temps à radar, armé de roquettes\n- **F-86H** : chasseur-bombardier à quatre canons de 20 mm\n- **CAC Sabre / Canadair Sabre** : productions australienne et canadienne remotorisées',
  variants_en       = E'- **F-86A / E / F** : day fighters, the Korean War versions\n- **F-86D Sabre Dog** : radar-equipped all-weather interceptor with rockets\n- **F-86H** : fighter-bomber with four 20 mm cannon\n- **CAC Sabre / Canadair Sabre** : re-engined Australian and Canadian production',

  -- Strate 4 : qualitatif
  nickname          = 'Sabre',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_F-86_Sabre',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_F-86_Sabre',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '205weeman17',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'F-86 Sabre';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-86 Sabre';
