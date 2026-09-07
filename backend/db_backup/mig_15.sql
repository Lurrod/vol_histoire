-- Mikoyan-Gourevitch MiG-15
--
-- Photo : MIG-15, Internationales Luftfahrtmuseum Manfred Pflumm pic1.JPG
--   licence CC0 — Alf van Beem
--   https://commons.wikimedia.org/wiki/File%3AMIG-15%2C_Internationales_Luftfahrtmuseum_Manfred_Pflumm_pic1.JPG

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
    'MiG-15',
    'MiG-15',
    'Mikoyan-Gourevitch MiG-15',
    'Mikoyan-Gurevich MiG-15',
    'Chasseur soviétique de la guerre de Corée, 18 000 exemplaires',
    'Soviet fighter of the Korean War, 18,000 built',
    '/assets/airplanes/mig15.jpg',
    E'## Genèse\nEn 1946, le gouvernement britannique autorise la vente de vingt-cinq réacteurs **Rolls-Royce Nene** à l''URSS. Staline, incrédule, aurait demandé : « quel imbécile vendrait ses secrets ? ». Copié sans licence sous le nom de Klimov VK-1, ce moteur donne au MiG-15 une poussée qu''aucun chasseur soviétique n''avait.\n\n## Conception\nAile à 35° de flèche issue des recherches allemandes saisies, fuselage court en tonneau, empennage en T. L''armement est pensé contre les bombardiers : **un canon de 37 mm et deux de 23 mm**, groupés sur un affût descendant au sol pour le rechargement. Cadence faible, mais un seul coup au but suffit à démolir un B-29.\n\n## Carrière opérationnelle\nEn **Corée**, le MiG-15 rend d''un coup obsolètes les B-29 et les chasseurs à aile droite américains. Il faut y envoyer le F-86 Sabre en urgence. Beaucoup sont pilotés par des équipages soviétiques opérant sous couverture, fait nié pendant quarante ans. En 1953, un pilote nord-coréen livre un MiG-15 intact aux Américains contre 100 000 dollars.\n\n## Place dans l''histoire\n**Dix-huit mille exemplaires**, l''avion à réaction le plus produit de tous les temps toutes catégories confondues. Le MiG-15 a fondé la réputation du bureau Mikoyan et le modèle soviétique du chasseur simple, robuste et exporté en masse — modèle que le MiG-21 portera à son apogée.',
    E'## Genesis\nIn 1946 the British government authorised the sale of twenty-five **Rolls-Royce Nene** engines to the USSR. Stalin, incredulous, is said to have asked: “what fool would sell his own secrets?”. Copied without licence as the Klimov VK-1, that engine gave the MiG-15 thrust no Soviet fighter had had.\n\n## Design\nA 35° swept wing derived from captured German research, a short barrel fuselage, a T-tail. The armament was conceived against bombers: **one 37 mm and two 23 mm cannon**, grouped on a tray that lowers to the ground for reloading. A low rate of fire, but one hit was enough to wreck a B-29.\n\n## Operational career\nOver **Korea** the MiG-15 made B-29s and American straight-wing fighters obsolete overnight. The F-86 Sabre had to be rushed in. Many were flown by Soviet crews operating under cover, a fact denied for forty years. In 1953 a North Korean pilot delivered an intact MiG-15 to the Americans for $100,000.\n\n## Place in history\n**Eighteen thousand built**, the most-produced jet aircraft of all time in any category. The MiG-15 founded the Mikoyan bureau’s reputation and the Soviet model of the simple, rugged, mass-exported fighter — a model the MiG-21 would take to its peak.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1946-01-01',
    '1947-12-30',
    '1949-05-01',
    1075.0,
    1330.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM tech WHERE name = 'Réacteur Klimov VK-1'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.1,
  wingspan          = 10.08,
  height            = 3.7,
  wing_area         = 20.6,
  empty_weight      = 3630,
  mtow              = 6106,
  service_ceiling   = 15500,
  climb_rate        = 51,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = 480,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov VK-1',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 26.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1959,
  units_built       = 18000,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 40,
  variants          = E'- **MiG-15bis** : version principale, moteur VK-1 plus puissant\n- **MiG-15UTI** : biplace d''entraînement, produit jusque dans les années 1970\n- **Shenyang J-2** : production sous licence chinoise\n- **PZL Lim-1 / Lim-2** : production polonaise sous licence',
  variants_en       = E'- **MiG-15bis** : main version with the more powerful VK-1 engine\n- **MiG-15UTI** : two-seat trainer, produced into the 1970s\n- **Shenyang J-2** : Chinese licence production\n- **PZL Lim-1 / Lim-2** : Polish licence production',

  -- Strate 4 : qualitatif
  nickname          = 'Fagot',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-15',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-15',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alf van Beem',
  image_licence     = 'CC0'
WHERE name = 'MiG-15';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-15';
