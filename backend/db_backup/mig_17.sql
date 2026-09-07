-- Mikoyan-Gourevitch MiG-17
--
-- Photo : MiG-17 Takes to the Sky (cropped).jpg
--   licence CC0 — Balon Greyjoy
--   https://commons.wikimedia.org/wiki/File%3AMiG-17_Takes_to_the_Sky_%28cropped%29.jpg

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
    'MiG-17',
    'MiG-17',
    'Mikoyan-Gourevitch MiG-17',
    'Mikoyan-Gurevich MiG-17',
    'Chasseur soviétique subsonique produit à plus de dix mille exemplaires',
    'Subsonic Soviet fighter built in more than ten thousand examples',
    '/assets/airplanes/mig17.jpg',
    E'## Genèse\nLe MiG-15 avait révélé ses limites en Corée : instabilité à grande vitesse, tendance à partir en vrille. Le MiG-17 n''est pas un nouvel avion mais une **correction méthodique** — aile plus fine à flèche accentuée de 45°, fuselage allongé, empennage redessiné. Aucune rupture, mais un appareil enfin sûr.\n\n## Conception\nL''armement reste celui du MiG-15 : un canon de 37 mm et deux de 23 mm, calibrés pour détruire un bombardier en une passe. Contre un chasseur, la cadence est faible et la trajectoire courbe, mais la puissance destructrice est sans équivalent. Le MiG-17 ne dépasse Mach 1 qu''en piqué — sa force est ailleurs : il **vire plus serré que tout ce qui vole en 1965**.\n\n## Carrière opérationnelle\nAu **Vietnam**, des MiG-17 subsoniques abattent des F-4 Phantom deux fois plus rapides, en les attirant dans le combat tournant à basse vitesse où les missiles américains sont inefficaces. Ces pertes déclenchent la création de l''école **Top Gun** et le retour du canon sur les chasseurs américains.\n\n## Place dans l''histoire\nPlus de **10 800 exemplaires** et quarante utilisateurs, du Vietnam au Nigeria. Le MiG-17 est la démonstration la plus citée qu''en combat rapproché, la manœuvrabilité peut compenser deux générations de retard technologique.',
    E'## Genesis\nThe MiG-15 had shown its limits over Korea: instability at high speed and a tendency to spin. The MiG-17 is not a new aircraft but a **methodical correction** — a thinner wing with sweep increased to 45°, a lengthened fuselage, a redesigned tail. No breakthrough, but an aircraft that was finally safe.\n\n## Design\nThe armament stayed that of the MiG-15: one 37 mm and two 23 mm cannon, sized to destroy a bomber in one pass. Against a fighter the rate of fire is low and the trajectory curved, but the destructive power is unmatched. The MiG-17 only passes Mach 1 in a dive — its strength lies elsewhere: it **out-turns anything flying in 1965**.\n\n## Operational career\nOver **Vietnam**, subsonic MiG-17s shot down F-4 Phantoms twice their speed by drawing them into low-speed turning fights where American missiles were useless. Those losses triggered the creation of the **Top Gun** school and the return of the gun to American fighters.\n\n## Place in history\nMore than **10,800 built** and forty operators, from Vietnam to Nigeria. The MiG-17 is the most-cited demonstration that in close combat, manoeuvrability can offset two generations of technological disadvantage.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1949-01-01',
    '1950-01-14',
    '1952-10-01',
    1145.0,
    2060.0,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM tech WHERE name = 'Réacteur Klimov VK-1'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM armement WHERE name = 'FAB-250'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.26,
  wingspan          = 9.63,
  height            = 3.8,
  wing_area         = 22.6,
  empty_weight      = 3930,
  mtow              = 6070,
  service_ceiling   = 16600,
  climb_rate        = 65,
  g_limit_pos       = 8.0,
  g_limit_neg       = NULL,
  combat_radius     = 700,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Klimov VK-1F',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 26.5,
  thrust_wet        = 33.1,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1958,
  units_built       = 10800,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 40,
  variants          = E'- **MiG-17F** : version de jour à postcombustion, la plus produite\n- **MiG-17PF** : intercepteur tout-temps à radar\n- **Shenyang J-5** : production sous licence chinoise, plus de 1 800 exemplaires\n- **PZL Lim-5 / Lim-6** : production polonaise sous licence',
  variants_en       = E'- **MiG-17F** : afterburning day fighter, the most produced version\n- **MiG-17PF** : radar-equipped all-weather interceptor\n- **Shenyang J-5** : Chinese licence production, more than 1,800 built\n- **PZL Lim-5 / Lim-6** : Polish licence production',

  -- Strate 4 : qualitatif
  nickname          = 'Fresco',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-17',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan-Gurevich_MiG-17',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Balon Greyjoy',
  image_licence     = 'CC0'
WHERE name = 'MiG-17';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'MiG-17';
