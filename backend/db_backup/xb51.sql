-- Martin XB-51
--
-- Photo : Xb51-6.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:Xb51-6.jpg

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
    'Martin XB-51',
    'Martin XB-51',
    'Martin XB-51',
    'Martin XB-51',
    'Triréacteur d''attaque plus rapide que les chasseurs de son temps, battu par l''endurance du Canberra',
    'A trijet attack bomber faster than the fighters of its day, beaten by the Canberra''s endurance',
    '/assets/airplanes/xb51.jpg',
    E'## Genèse\nEn 1945, les United States Army Air Forces émettent la spécification V-8237-1 pour un avion de bombardement à basse altitude et d''appui rapproché. La **Glenn L. Martin Company** y répond d''abord par un projet à propulsion mixte, désigné XA-45 dans la catégorie des avions d''attaque ; deux prototypes sont commandés par lettre-contrat le 23 mai 1946. La catégorie « A » disparaissant, l''avion devient le XB-51, et la spécification, modifiée en 1947, aboutit à un triréacteur à aile en flèche pour deux hommes d''équipage seulement.\n\n## Conception\nLe dessin est hors normes : trois turboréacteurs **General Electric J47**, deux en nacelles sous l''avant du fuselage et le troisième dans la queue, alimenté par une entrée d''air au pied de la dérive. L''aile, en flèche de 35° et en dièdre négatif de 6°, est à **incidence variable** pour raccourcir le décollage ; des spoilers assurent l''essentiel du contrôle en roulis. Le train monotrace, à la manière du B-47, se complète de balancines en bout d''aile. Signature de Martin, une **soute à bombes rotative** emporte jusqu''à 4,7 t de bombes, et la série devait recevoir huit canons de 20 mm dans le nez. Quatre fusées d''appoint permettent des décollages spectaculaires.\n\n## Essais\nLe premier prototype vole le 28 octobre 1949. En 1950, la guerre de Corée pousse l''US Air Force à chercher un intrus de nuit pour remplacer l''**A-26 Invader** : le XB-51 affronte notamment l''**English Electric Canberra**. Très maniable à basse altitude, il est nettement plus rapide que le britannique et que la plupart des chasseurs de l''époque. Mais son endurance est bien inférieure, son facteur de charge limité à 3,67 g, et son train inadapté aux terrains sommaires : le Canberra l''emporte, et Martin le construira sous licence. Le second prototype s''écrase le 9 mai 1952 lors d''acrobaties à basse altitude, tuant le major Neil Lathrop.\n\n## Place dans l''histoire\nLe premier prototype poursuit des vols de recherche et apparaît au cinéma, sous le nom de « Gilbert XF-120 », dans Toward the Unknown, avant de s''écraser au décollage à El Paso le 25 mars 1956. Le XB-51 n''a pas eu de descendance directe, mais sa soute rotative a été reprise sur les **B-57 Canberra** de série, et plusieurs de ses idées, empennage en T et soute étanche, se retrouvent sur l''hydravion **P6M SeaMaster** du même constructeur.',
    E'## Genesis\nIn 1945 the United States Army Air Forces issued Specification V-8237-1 for a low-level bombing and close-support aircraft. The **Glenn L. Martin Company** first answered with a mixed-power design, designated XA-45 in the attack category; two prototypes were ordered under a letter contract on 23 May 1946. When the A category was abolished, the aircraft became the XB-51, and the specification, revised in 1947, led to a swept-wing trijet with a crew of only two.\n\n## Design\nThe layout was unorthodox: three **General Electric J47** turbojets, two in pods under the forward fuselage and the third in the tail, fed by an intake at the base of the fin. The wing, swept at 35° with 6° of anhedral, had **variable incidence** to shorten the take-off run; spoilers provided most of the roll control. The bicycle undercarriage, like the B-47''s, was completed by wingtip outriggers. A Martin trademark, a **rotating bomb bay** carried up to 4.7 tonnes of bombs, and production aircraft were to have eight 20 mm cannon in the nose. Four rocket bottles made for spectacular take-offs.\n\n## Testing\nThe first prototype flew on 28 October 1949. In 1950 the Korean War led the US Air Force to seek a night intruder to replace the **A-26 Invader**, and the XB-51 faced, among others, the **English Electric Canberra**. Highly manoeuvrable at low level, it was much faster than the British aircraft and most fighters of the day. But its endurance was far lower, its load factor was limited to 3.67 g, and its undercarriage was unsuited to rough forward airfields: the Canberra won, and Martin would build it under licence. The second prototype crashed during low-level aerobatics on 9 May 1952, killing Major Neil Lathrop.\n\n## Place in history\nThe first prototype went on flying for research and appeared on screen as the Gilbert XF-120 in Toward the Unknown, before crashing on take-off at El Paso on 25 March 1956. The XB-51 had no direct descendant, but its rotating bomb bay was adopted on production **B-57 Canberras**, and several of its ideas, the T-tail and a sealed rotating bomb bay, reappeared on the same company''s **P6M SeaMaster** flying boat.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-01',
    '1949-10-28',
    NULL,
    1036,
    2324,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin XB-51'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Martin XB-51'), (SELECT id FROM tech WHERE name = 'Aile à incidence variable')),
((SELECT id FROM airplanes WHERE name = 'Martin XB-51'), (SELECT id FROM tech WHERE name = 'Soute à bombes rotative'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin XB-51'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Martin XB-51'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Martin XB-51'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 25.93,
  wingspan          = 16.18,
  height            = 5.28,
  wing_area         = 50.9,
  empty_weight      = 14019,
  mtow              = 28328,
  service_ceiling   = 12730,
  climb_rate        = 34,
  g_limit_pos       = 3.67,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-13',
  engine_count      = 3,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 23.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XA-45** : désignation initiale du projet, classé avion d''attaque, à propulsion mixte\n- **XB-51** (46-685) : premier prototype, premier vol le 28 octobre 1949, détruit au décollage le 25 mars 1956\n- **XB-51** (46-686) : second prototype, premier vol en 1950, écrasé le 9 mai 1952\n- **Super Canberra** : projet de Canberra reprenant l''aile et l''empennage en flèche du XB-51, jamais construit',
  variants_en       = E'- **XA-45**: initial designation of the project, classed as an attack aircraft, with mixed power\n- **XB-51** (46-685): first prototype, first flight on 28 October 1949, destroyed on take-off on 25 March 1956\n- **XB-51** (46-686): second prototype, first flight in 1950, crashed on 9 May 1952\n- **Super Canberra**: proposed Canberra with the XB-51''s swept wing and tail, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_XB-51',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_XB-51',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Martin XB-51';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin XB-51';
