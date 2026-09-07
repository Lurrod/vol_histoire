-- Tupolev Tu-22 Blinder
--
-- Photo : Энгельс Ту-22РДМ-18 фото 1.jpg
--   licence Public domain — Зимин Василий
--   https://commons.wikimedia.org/wiki/File%3A%D0%AD%D0%BD%D0%B3%D0%B5%D0%BB%D1%8C%D1%81_%D0%A2%D1%83-22%D0%A0%D0%94%D0%9C-18_%D1%84%D0%BE%D1%82%D0%BE_1.jpg

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
    'Tu-22',
    'Tu-22',
    'Tupolev Tu-22 Blinder',
    'Tupolev Tu-22 Blinder',
    'Premier bombardier supersonique soviétique, redouté de ses propres équipages',
    'First Soviet supersonic bomber, feared by its own crews',
    '/assets/airplanes/tu22-blinder.jpg',
    E'## Genèse\nRéponse soviétique au B-58 Hustler américain, le Tu-22 doit voler à Mach 1,5 et emporter une arme nucléaire jusqu''en Europe occidentale. Il est présenté au défilé de Toushino en 1961 sous une forme spectaculaire — deux réacteurs perchés de part et d''autre de la dérive, silhouette qu''aucun autre appareil n''aura.\n\n## Conception\nCette implantation des moteurs **au-dessus de la queue** libère le fuselage pour la soute et le carburant, mais rend l''appareil instable à basse vitesse et très difficile à poser. La vitesse d''approche dépasse 300 km/h. Les équipages le surnomment *Chilo* — l''alêne — pour son long nez ; la réputation est mauvaise dès le début.\n\n## Carrière opérationnelle\nLe taux d''accidents est parmi les plus élevés de l''aviation soviétique : les sièges éjectables tirent **vers le bas**, condamnant tout équipage devant s''éjecter à basse altitude. Engagé en Afghanistan pour des bombardements de saturation, et par la **Libye** et l''**Irak**, qui l''utilise contre l''Iran puis contre les Kurdes.\n\n## Place dans l''histoire\nLe Tu-22 est l''échec dont naîtra une réussite : ses défauts imposent une refonte totale, qui donnera le **Tu-22M** à géométrie variable — un appareil sans aucun rapport, dont la désignation trompeuse a longtemps servi les négociations soviétiques sur la limitation des armements.',
    E'## Genesis\nThe Soviet answer to the American B-58 Hustler, the Tu-22 had to fly at Mach 1.5 and carry a nuclear weapon to Western Europe. It was shown at the 1961 Tushino parade in spectacular form — two engines perched either side of the fin, a silhouette no other aircraft would have.\n\n## Design\nMounting the engines **above the tail** freed the fuselage for the bay and fuel, but made the aircraft unstable at low speed and very hard to land. Approach speed exceeds 300 km/h. Crews nicknamed it *Shilo* — the awl — for its long nose; its reputation was poor from the start.\n\n## Operational career\nIts accident rate was among the highest in Soviet aviation: the ejection seats fired **downwards**, condemning any crew forced to eject at low altitude. It was used in Afghanistan for saturation bombing, and by **Libya** and **Iraq**, which flew it against Iran and later against the Kurds.\n\n## Place in history\nThe Tu-22 is the failure from which a success grew: its flaws forced a complete redesign that produced the variable-geometry **Tu-22M** — an unrelated aircraft whose misleading designation long served Soviet arms limitation negotiations.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1954-01-01',
    '1958-06-21',
    '1962-09-01',
    1510.0,
    4900.0,
    (SELECT id FROM manufacturer WHERE code = 'TUP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM armement WHERE name = 'NR-23')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM armement WHERE name = 'Kh-22')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM armement WHERE name = 'FAB-1500')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM armement WHERE name = 'FAB-3000'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM wars WHERE name = 'Guerre Iran-Irak')),
((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 41.6,
  wingspan          = 23.17,
  height            = 10.13,
  wing_area         = 162.25,
  empty_weight      = 40000,
  mtow              = 92000,
  service_ceiling   = 13300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2200,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Dobrynin RD-7M2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 107.9,
  thrust_wet        = 161.9,

  -- Strate 3 : production & service
  production_start  = 1959,
  production_end    = 1969,
  units_built       = 311,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Tu-22B** : bombardier classique, version initiale\n- **Tu-22K** : porteur du missile de croisière Kh-22\n- **Tu-22R** : reconnaissance stratégique\n- **Tu-22M** : successeur à géométrie variable, appareil entièrement différent malgré la désignation',
  variants_en       = E'- **Tu-22B** : conventional bomber, initial version\n- **Tu-22K** : carrier of the Kh-22 cruise missile\n- **Tu-22R** : strategic reconnaissance\n- **Tu-22M** : variable-geometry successor, an entirely different aircraft despite the designation',

  -- Strate 4 : qualitatif
  nickname          = 'Blinder',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tupolev_Tu-22',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tupolev_Tu-22',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Зимин Василий',
  image_licence     = 'Public domain'
WHERE name = 'Tu-22';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tu-22';
