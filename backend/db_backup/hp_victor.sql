-- Handley Page Victor
--
-- Photo : Handley Page Victor in Jubail naval airport.jpg
--   licence CC BY-SA 2.0 — Hugh Llewelyn from Keynsham, UK
--   https://commons.wikimedia.org/wiki/File%3AHandley_Page_Victor_K2_%2850111247058%29.jpg

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
    'Handley Page Victor',
    'Handley Page Victor',
    'Handley Page Victor',
    'Handley Page Victor',
    'Le plus rapide des trois bombardiers nucléaires britanniques',
    'The fastest of Britain’s three nuclear V-bombers',
    '/assets/airplanes/hp-victor.jpg',
    E'## Genèse\nAprès 1945, le Royaume-Uni veut une force de frappe nucléaire autonome. Plutôt que de choisir, il commande **trois bombardiers différents** au même cahier des charges : le Valiant en solution de repli, le Vulcan à aile delta, et le Victor de Handley Page — le plus audacieux des trois.\n\n## Conception\nL''aile est en **croissant** : la flèche diminue par paliers de l''emplanture au saumon, de sorte que le nombre de Mach critique reste constant sur toute l''envergure. Le résultat est le plus rapide des V-bombers, seul capable de dépasser Mach 1 en piqué — ce qu''il fit accidentellement lors d''un vol d''essai, devenant le plus gros avion à avoir franchi le mur du son à l''époque.\n\n## Carrière opérationnelle\nLa dissuasion passe aux sous-marins en 1969 ; les Victor deviennent **ravitailleurs**. C''est en cette qualité qu''ils entrent dans l''histoire : aux **Malouines** en 1982, il faut onze Victor ravitaillant en chaîne pour permettre à un seul Vulcan de bombarder Port Stanley depuis l''île de l''Ascension — la mission de bombardement la plus longue jamais effectuée à cette date.\n\n## Place dans l''histoire\nRetiré en 1993 après la guerre du Golfe, il est le dernier V-bomber en service. Handley Page, plus ancien constructeur aéronautique britannique, avait fait faillite vingt ans plus tôt : le Victor est son dernier avion.',
    E'## Genesis\nAfter 1945 Britain wanted an autonomous nuclear strike force. Rather than choose, it ordered **three different bombers** to the same specification: the Valiant as a fallback, the delta-winged Vulcan, and Handley Page’s Victor — the boldest of the three.\n\n## Design\nThe wing is a **crescent**: sweep decreases in steps from root to tip so that the critical Mach number stays constant across the span. The result was the fastest of the V-bombers, the only one able to exceed Mach 1 in a dive — which it did accidentally on a test flight, becoming the largest aircraft to have broken the sound barrier at the time.\n\n## Operational career\nDeterrence passed to submarines in 1969 and the Victors became **tankers**. It is in that role that they entered history: in the **Falklands** in 1982 it took eleven Victors refuelling in a chain to let a single Vulcan bomb Port Stanley from Ascension Island — the longest bombing mission ever flown at that date.\n\n## Place in history\nRetired in 1993 after the Gulf War, it was the last V-bomber in service. Handley Page, Britain’s oldest aircraft manufacturer, had gone bankrupt twenty years earlier: the Victor is its last aircraft.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1947-01-01',
    '1952-12-24',
    '1958-04-01',
    1030.0,
    7400.0,
    (SELECT id FROM manufacturer WHERE code = 'HP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM tech WHERE name = 'Système de navigation attaque à basse altitude'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Victor'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.05,
  wingspan          = 33.53,
  height            = 8.57,
  wing_area         = 223.5,
  empty_weight      = 40468,
  mtow              = 101000,
  service_ceiling   = 17000,
  climb_rate        = 25,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2400,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Conway RCo.17',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 91.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1963,
  units_built       = 86,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Victor B.1** : bombardier nucléaire à haute altitude\n- **Victor B.2** : envergure accrue, moteurs Conway, missile Blue Steel\n- **Victor SR.2** : reconnaissance stratégique et maritime\n- **Victor K.2** : ravitailleur en vol, en service jusqu''en 1993\n- Troisième des **V-bombers** avec le Vulcan et le Valiant',
  variants_en       = E'- **Victor B.1** : high-altitude nuclear bomber\n- **Victor B.2** : greater span, Conway engines, Blue Steel missile\n- **Victor SR.2** : strategic and maritime reconnaissance\n- **Victor K.2** : air-to-air tanker, in service until 1993\n- Third of the **V-bombers** alongside the Vulcan and the Valiant',

  -- Strate 4 : qualitatif
  nickname          = 'Victor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Handley_Page_Victor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Handley_Page_Victor',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Photo by LT. COL. PAUL BACKS',
  image_licence     = 'Public domain'
WHERE name = 'Handley Page Victor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Handley Page Victor';
