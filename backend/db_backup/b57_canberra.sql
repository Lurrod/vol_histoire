-- Martin B-57 Canberra
--
-- Photo : Martin B-57B Canberra of the 8th Bomb Squadron in flight over Southeast Asia, circa in 1968.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Martin_B-57B_Canberra_of_the_8th_Bomb_Squadron_in_flight_over_Southeast_Asia,_circa_in_1968.jpg

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
    'Martin B-57 Canberra',
    'Martin B-57 Canberra',
    'Martin B-57 Canberra',
    'Martin B-57 Canberra',
    'Le Canberra britannique construit en Amérique, seul bombardier étranger de l’US Air Force',
    'The British Canberra built in America, the US Air Force’s only foreign bomber',
    '/assets/airplanes/b57-canberra.jpg',
    E'## Genèse\nEn 1950, la guerre de Corée montre que le **B-26 Invader** à hélices ne suffit plus pour l''interdiction de nuit. L''US Air Force cherche un bombardier à réaction et, fait exceptionnel, accepte d''évaluer des appareils étrangers. Le 21 février 1951, un **Canberra** britannique traverse l''Atlantique sans escale en 4 h 37, puis surclasse lors d''une démonstration à Andrews le Martin XB-51, le North American B-45, l''AJ Savage et le **CF-100** canadien. Pour désarmer l''opposition politique, sa production est confiée sous licence à **Martin**, par un contrat du 23 mars 1951.\n\n## Conception\nLe B-57A reste très proche du Canberra B.2, mais reçoit des réacteurs **Wright J65** — le Sapphire britannique construit sous licence —, des réservoirs de bout d''aile, un équipage réduit à deux et une soute à porte rotative. Le B-57B, version définitive, adopte une verrière de chasseur en tandem, des points d''emport sous les ailes et un armement fixe : huit mitrailleuses de 12,7 mm, puis quatre canons de 20 mm. Martin puis General Dynamics en tirent des versions de reconnaissance à très haute altitude, dont le **RB-57F** à voilure très agrandie.\n\n## Carrière opérationnelle\nLe B-57 est le premier bombardier à réaction américain à larguer des bombes au combat, à partir du 19 février 1965. Au **Vietnam**, il chasse les camions sur la piste Hô Chi Minh ; 58 appareils y sont perdus, dont dix dans une seule explosion au sol à Biên Hòa en mai 1965. Le Pakistan l''engage contre l''Inde en 1965 et 1971 ; Taïwan perd en 1959 un RB-57D abattu au-dessus de la Chine par un missile **SA-2**, première victoire d''un missile sol-air. L''US Air Force le retire en 1983.\n\n## Place dans l''histoire\nQuatre cent trois exemplaires. Comme le rappelle la fiche du **Canberra**, c''est le seul bombardier étranger jamais adopté par l''US Air Force. Plus de soixante-dix ans après son premier vol, des WB-57F volent encore pour la NASA, au service de la recherche atmosphérique.',
    E'## Genesis\nIn 1950 the Korean War showed that the piston-engined **B-26 Invader** was no longer adequate for night interdiction. The US Air Force wanted a jet bomber and, unusually, agreed to evaluate foreign aircraft. On 21 February 1951 a British **Canberra** crossed the Atlantic non-stop in 4 h 37 min, then outclassed the Martin XB-51, the North American B-45, the AJ Savage and the Canadian **CF-100** in a demonstration at Andrews. To disarm political opposition, its production was entrusted under licence to **Martin**, by a contract of 23 March 1951.\n\n## Design\nThe B-57A stayed very close to the Canberra B.2, but received **Wright J65** engines — the British Sapphire built under licence —, wingtip tanks, a crew cut to two and a bomb bay with a rotating door. The B-57B, the definitive version, adopted a fighter-style tandem canopy, underwing hardpoints and fixed armament: eight 12.7 mm machine guns, then four 20 mm cannon. Martin and later General Dynamics derived very high altitude reconnaissance versions from it, including the **RB-57F** with a greatly enlarged wing.\n\n## Operational career\nThe B-57 was the first American jet bomber to drop bombs in combat, from 19 February 1965. Over **Vietnam** it hunted trucks on the Ho Chi Minh trail; 58 were lost there, ten of them in a single explosion on the ground at Bien Hoa in May 1965. Pakistan used it against India in 1965 and 1971; in 1959 Taiwan lost an RB-57D shot down over China by an **SA-2**, the first victory by a surface-to-air missile. The US Air Force retired it in 1983.\n\n## Place in history\nFour hundred and three built. As the **Canberra** entry recalls, it is the only foreign bomber ever adopted by the US Air Force. More than seventy years after its first flight, WB-57Fs are still flying for NASA, in the service of atmospheric research.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-03-23',
    '1953-07-20',
    '1954-01-01',
    960.0,
    4380.0,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.0,
  wingspan          = 19.5,
  height            = 4.52,
  wing_area         = 89.0,
  empty_weight      = 12285,
  mtow              = 24365,
  service_ceiling   = 13745,
  climb_rate        = 31.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Wright J65-W-5',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 32.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1957,
  units_built       = 403,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **B-57A / RB-57A** : premiers modèles, très proches du Canberra B.2 britannique\n- **B-57B** : version de bombardement définitive, verrière en tandem et armement fixe\n- **RB-57D / RB-57F** : reconnaissance à très haute altitude, voilure fortement agrandie\n- **B-57G** : intrus de nuit à radar, infrarouge et désignateur laser (*Tropic Moon III*), seize exemplaires\n- **WB-57F** : recherche atmosphérique, toujours en vol à la NASA',
  variants_en       = E'- **B-57A / RB-57A** : first models, very close to the British Canberra B.2\n- **B-57B** : definitive bomber version, tandem canopy and fixed armament\n- **RB-57D / RB-57F** : very high altitude reconnaissance, greatly enlarged wing\n- **B-57G** : night intruder with radar, infrared and laser designator (*Tropic Moon III*), sixteen aircraft\n- **WB-57F** : atmospheric research, still flying with NASA',

  -- Strate 4 : qualitatif
  nickname          = 'Canberra',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_B-57',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_B-57_Canberra',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Martin B-57 Canberra';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin B-57 Canberra';
