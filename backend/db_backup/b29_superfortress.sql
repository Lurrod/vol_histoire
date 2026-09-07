-- Boeing B-29 Superfortress
--
-- Photo : B-29 Superfortress from NACA Langley in flight in 1946.jpeg
--   licence CC BY-SA 4.0 — Acroterion
--   https://commons.wikimedia.org/wiki/File%3ABoeing_TB-29_Superfortress_%E2%80%98469972%E2%80%99_%E2%80%9CDoc%E2%80%9D_MD1.jpg

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
    'B-29 Superfortress',
    'B-29 Superfortress',
    'Boeing B-29 Superfortress',
    'Boeing B-29 Superfortress',
    'Le bombardier le plus coûteux de la Seconde Guerre mondiale, encore en ligne en Corée',
    'The costliest bomber of the Second World War, still in the line over Korea',
    '/assets/airplanes/b29-superfortress.jpg',
    E'## Genèse\nLe programme B-29 coûte **trois milliards de dollars de 1945**, soit davantage que le projet Manhattan qui produira la bombe qu''il emportera. Boeing y répond à une exigence sans précédent : porter quatre tonnes de bombes sur cinq mille kilomètres, à dix mille mètres, au-dessus du Pacifique. Rien de ce qui existe n''en approche.\n\n## Conception\nTout y est nouveau et tout y est risqué. Le fuselage est **entièrement pressurisé**, une première sur un bombardier : l''équipage vole en tenue normale à dix mille mètres. Les tourelles sont commandées à distance depuis des postes de tir vitrés, un calculateur analogique corrigeant la parallaxe. Les moteurs Wright R-3350, poussés au-delà du raisonnable, prennent feu si souvent que les incendies moteur tueront plus d''équipages en essais que le combat.\n\n## Carrière opérationnelle\nIl incendie les villes japonaises en 1945, puis largue les deux armes nucléaires. Sa seconde carrière est moins connue et plus douloureuse : en **Corée**, les B-29 bombardent de jour jusqu''à ce que les MiG-15 les décime — le 12 avril 1951, dix appareils sont abattus ou perdus en une seule mission. Ils sont alors relégués aux frappes de nuit. Le KB-29 invente au passage le ravitaillement en vol opérationnel.\n\n## Place dans l''histoire\nTrois mille neuf cent soixante-dix exemplaires. Sa descendance est double et paradoxale : à l''Ouest il engendre le B-50 puis, par la pressurisation et la portée, toute la lignée qui mène au **B-47 Stratojet** ; à l''Est, l''URSS le copie boulon par boulon sous le nom de **Tupolev Tu-4** et fonde ainsi son aviation stratégique sur un avion américain.',
    E'## Genesis\nThe B-29 programme cost **three billion 1945 dollars**, more than the Manhattan Project that produced the bomb it would carry. Boeing was answering an unprecedented requirement: carry four tonnes of bombs five thousand kilometres, at ten thousand metres, across the Pacific. Nothing in existence came close.\n\n## Design\nEverything about it was new and everything was risky. The fuselage is **fully pressurised**, a first on a bomber: the crew flew in ordinary clothing at ten thousand metres. The turrets are remotely controlled from glazed sighting stations, an analogue computer correcting for parallax. The Wright R-3350 engines, pushed beyond reason, caught fire so often that engine fires killed more crews in testing than combat did.\n\n## Operational career\nIt burned Japan''s cities in 1945, then dropped the two nuclear weapons. Its second career is less well known and more painful: over **Korea**, B-29s bombed by day until the MiG-15s cut them down — on 12 April 1951 ten aircraft were shot down or lost on a single mission. They were then relegated to night strikes. The KB-29 meanwhile invented operational aerial refuelling.\n\n## Place in history\nThree thousand nine hundred and seventy built. Its descent is double and paradoxical: in the West it fathered the B-50 and then, through pressurisation and range, the whole line leading to the **B-47 Stratojet**; in the East, the USSR copied it bolt for bolt as the **Tupolev Tu-4** and thus founded its strategic air arm on an American aircraft.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1938-01-01',
    '1942-09-21',
    '1944-05-08',
    574.0,
    5230.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.18,
  wingspan          = 43.05,
  height            = 8.46,
  wing_area         = 161.3,
  empty_weight      = 33800,
  mtow              = 60560,
  service_ceiling   = 9710,
  climb_rate        = 4.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2600,
  crew              = 11,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-23 Duplex-Cyclone',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1943,
  production_end    = 1946,
  units_built       = 3970,
  unit_cost_usd     = 639188,
  unit_cost_year    = 1944,
  operators_count   = 4,
  variants          = E'- **B-29A** : version de série principale, voilure renforcée\n- **B-29B** : allégée de ses tourelles pour les missions nocturnes à basse altitude\n- **Silverplate** : soixante-cinq cellules modifiées pour l''arme nucléaire, dont l''*Enola Gay*\n- **KB-29** : premier ravitailleur en vol opérationnel au monde\n- **Tupolev Tu-4** : copie soviétique intégrale, réalisée à partir de trois exemplaires internés',
  variants_en       = E'- **B-29A** : main production version, with a strengthened wing\n- **B-29B** : stripped of its turrets for low-level night missions\n- **Silverplate** : sixty-five airframes modified for nuclear weapons, including *Enola Gay*\n- **KB-29** : the world''s first operational aerial tanker\n- **Tupolev Tu-4** : complete Soviet copy, made from three interned aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Superfort',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_B-29_Superfortress',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_B-29_Superfortress',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'B-29 Superfortress';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-29 Superfortress';
