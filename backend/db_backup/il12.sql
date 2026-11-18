-- Iliouchine Il-12 (Coach)
--
-- Photo : Ilyushin Il-12T ’10 red’ (27768645139).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Ilyushin_Il-12T_%E2%80%9910_red%E2%80%99_(27768645139).jpg

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
    'Iliouchine Il-12',
    'Ilyushin Il-12',
    'Iliouchine Il-12 (Coach)',
    'Ilyushin Il-12 (Coach)',
    'Le successeur soviétique du Li-2, cargo et avion de ligne dont l''Il-14 corrigera les défauts',
    'The Soviet successor to the Li-2, freighter and airliner whose flaws the Il-14 would correct',
    '/assets/airplanes/il12.jpg',
    E'## Genèse\nPendant la guerre, l''Union soviétique produit sous licence le DC-3 américain sous le nom de **Lissounov Li-2**, qui devient son principal avion de transport civil et militaire. Dès l''automne 1943, le bureau d''études **Iliouchine** étudie de sa propre initiative un remplaçant plus capable. Le premier projet prévoit un quadrimoteur pressurisé de 29 places ; en 1944, il devient un bimoteur non pressurisé à moteurs Diesel ACh-31, le premier appareil de la maison à train tricycle. Le prototype vole le 15 août 1945, puis, faute de Diesel assez fiables, il est remotorisé en moteurs en étoile **Shvetsov ASh-82** et revole le 9 janvier 1946.\n\n## Conception\nL''Il-12 est un monoplan à aile basse, à dérive unique et train tricycle escamotable, mû par deux ASh-82FN de 1 850 ch entraînant des hélices quadripales. Son vaste fuselage, éclairé par huit fenêtres rectangulaires de chaque côté, accueille 32 soldats, 32 parachutistes ou du fret ; une béquille sous l''arrière du fuselage évite à l''avion de basculer au chargement. Les pilotes d''essai louent ses performances et sa tenue en vol, bien supérieures à celles du Li-2, mais il vibre et se comporte mal après une panne moteur. Après un accident mortel près de Voronej en 1949, le magnésium voisin des moteurs est remplacé par de l''alliage d''aluminium.\n\n## Carrière opérationnelle\nPrésenté en vol au-dessus de la place Rouge le 1er mai 1947, l''Il-12 entre en service chez **Aeroflot** en juin, puis assure la longue ligne Moscou-Khabarovsk, 28 heures et cinq escales, et à partir de 1956 le soutien des expéditions soviétiques en Antarctique. L''armée de l''air soviétique reçoit dès 1948 l''Il-12D, qui emporte 38 parachutistes ou 3,7 tonnes de fret. La Pologne, la Tchécoslovaquie, la Roumanie et la Chine l''achètent ; l''armée populaire de libération en importe 42 qui servent jusqu''en 1986. Le 27 juillet 1953, un Il-12 de la marine soviétique abattu par un F-86 Sabre est le dernier avion détruit de la **guerre de Corée**.\n\n## Place dans l''histoire\nLimité en service à 18 ou 21 passagers au lieu de 32, l''Il-12 n''est pas rentable comme avion de ligne. Il est pourtant produit à 663 exemplaires de 1946 à 1949, et son expérience nourrit directement l''**Iliouchine Il-14**, qui en corrige les défauts et prend sa suite. L''OTAN le baptise *Coach*. Aeroflot l''utilise sur certaines lignes jusqu''à la fin de 1970.',
    E'## Genesis\nDuring the war the Soviet Union licence-built the American DC-3 as the **Lisunov Li-2**, which became its main civil and military transport. From autumn 1943 the **Ilyushin** design bureau began, on its own initiative, to study a more capable replacement. The first project was a pressurised four-engined 29-seater; in 1944 it became an unpressurised twin with ACh-31 diesel engines, the bureau''s first aircraft with tricycle gear. The prototype flew on 15 August 1945, then, as the diesels were not reliable enough, it was re-engined with **Shvetsov ASh-82** radials and flew again on 9 January 1946.\n\n## Design\nThe Il-12 was a low-wing monoplane with a single fin and retractable tricycle undercarriage, powered by two 1,850 hp ASh-82FNs driving four-bladed propellers. Its roomy fuselage, with eight rectangular windows on each side, took 32 soldiers, 32 paratroops or freight; a strut under the rear fuselage stopped the aircraft tipping during loading. Test pilots praised its performance and handling, far better than the Li-2''s, but it suffered from vibration and behaved poorly after an engine failure. After a fatal crash near Voronezh in 1949, the magnesium near the engines was replaced by aluminium alloy.\n\n## Operational career\nShown in a flypast over Red Square on 1 May 1947, the Il-12 entered **Aeroflot** service in June, then flew the long Moscow-Khabarovsk route, 28 hours with five stops, and from 1956 supported Soviet expeditions to Antarctica. The Soviet Air Force received the Il-12D from 1948, carrying 38 paratroops or 3.7 tonnes of freight. Poland, Czechoslovakia, Romania and China bought it; the People''s Liberation Army imported 42, which served until 1986. On 27 July 1953 a Soviet Navy Il-12 shot down by an F-86 Sabre was the last aircraft destroyed in the **Korean War**.\n\n## Place in history\nLimited in service to 18 or 21 passengers instead of 32, the Il-12 was uneconomic as an airliner. It was nonetheless built to 663 examples from 1946 to 1949, and its experience led directly to the **Ilyushin Il-14**, which corrected its faults and took over from it. NATO named it *Coach*. Aeroflot kept it on some routes until the end of 1970.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1943-01-01',
    '1945-08-15',
    '1947-06-01',
    407,
    1500,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-12'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-12'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-12'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-12'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.31,
  wingspan          = 31.7,
  height            = 8.07,
  wing_area         = 103,
  empty_weight      = 11045,
  mtow              = 17250,
  service_ceiling   = 6500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Shvetsov ASh-82FN (1 850 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1949,
  units_built       = 663,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 9,
  variants          = E'- **Il-12A** : version de ligne de base, 27 places, déclinée de 6 à 21 sièges\n- **Il-12B** : à partir de 1948, dégivrage amélioré, jambe de train avant allongée et petite arête dorsale\n- **Il-12D** : transport militaire lancé en 1948, 38 parachutistes ou 3,7 tonnes de fret\n- **Il-12P** : version de ligne de 32 places\n- **Il-12T** : transport pour l''Arctique, à grande porte cargo sur le flanc gauche',
  variants_en       = E'- **Il-12A**: basic airliner version, 27 seats, also offered with 6 to 21 seats\n- **Il-12B**: from 1948, improved de-icing, lengthened nose gear leg and small dorsal fin fillet\n- **Il-12D**: military transport launched in 1948, 38 paratroops or 3.7 tonnes of freight\n- **Il-12P**: 32-seat airliner version\n- **Il-12T**: Arctic transport with a large cargo door on the left side',

  -- Strate 4 : qualitatif
  nickname          = 'Coach',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Iliouchine Il-12';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-12';
