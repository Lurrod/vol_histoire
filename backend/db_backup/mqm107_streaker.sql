-- Beechcraft MQM-107 Streaker
--
-- Photo : MQM107E.jpg
--   licence Public domain — U.S. Air Force photo by Master Sgt. Michael Ammons
--   https://commons.wikimedia.org/wiki/File:MQM107E.jpg

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
    'Beechcraft MQM-107 Streaker',
    'Beechcraft MQM-107 Streaker',
    'Beechcraft MQM-107 Streaker',
    'Beechcraft MQM-107 Streaker',
    'Remorqueur de cibles réutilisable sur lequel l''armée américaine a entraîné ses missiles pendant trente ans',
    'Reusable target tug on which the US forces trained their missiles for thirty years',
    '/assets/airplanes/mqm107-streaker.jpg',
    E'## Genèse\nEn 1972, l''Aviation and Missile Command de l''**US Army** lance le programme **Variable Speed Training Target** (VSTT) : il lui faut une cible capable de faire travailler ses missiles sol-air. **Beech Aircraft** propose le MQM-107, qui vole pour la première fois en 1974, et remporte la compétition en 1975 ; l''armée de terre reçoit le modèle d''origine, le **MQM-107A**, jusqu''en 1979. La cible sert à éprouver le **FIM-92 Stinger** et le **MIM-104 Patriot**, puis l''US Air Force l''adopte pour l''entraînement au tir de ses missiles air-air, de l''**AIM-9 Sidewinder** à l''**AIM-120 AMRAAM**.\n\n## Conception\nLe Streaker est une cible subsonique rapide, aux ailes légèrement en flèche, avec un turboréacteur monté sous l''axe du fuselage. Il décolle du sol propulsé par une fusée d''appoint, jusqu''à ce que le réacteur prenne le relais, et redescend sous parachute pour être réutilisé. Sa spécialité est le remorquage : il traîne derrière lui des cibles radar ou infrarouges pour les missiles, ou une bannière carrée à forte signature radar pour les canons, et peut emporter des nacelles de leurres thermiques ou de paillettes. Long de 5,5 m, il pèse 664 kg au décollage, atteint 925 km/h et monte à plus de 12 000 m.\n\n## Carrière opérationnelle\nPendant deux décennies, les versions se succèdent : le **MQM-107B** de 1982, plus gros et doté d''un **Microturbo TRI 60**, le C qui écoule les stocks de réacteurs du A, le D de 1987, puis le **MQM-107E** de 1992, aux surfaces redessinées pour gagner en maniabilité et construit par BAE Systems. Exporté sous le nom de **Model 999**, il sert en Suède, en Égypte, en Turquie, à Taïwan, en Corée du Sud ou aux Émirats arabes unis. L''Australie choisit le MQM-107E, baptisé **N28 Kalkara**, pour remplacer ses **Jindivik**. En 2012, on apprend que la Corée du Nord en a acquis plusieurs d''occasion auprès d''un pays du Moyen-Orient ; l''année suivante, elle dévoile une cible de sa fabrication qui semble en dériver.\n\n## Place dans l''histoire\nAvec 2 236 exemplaires construits jusqu''en 2003, le Streaker a été la cible de référence des forces américaines pendant près de trente ans, avant de céder la place au **BQM-167 Skeeter**. Son succès tient à une idée simple : plutôt que d''être la cible, il la porte au bout d''un câble, ce qui lui permet d''être récupéré et réemployé d''un exercice à l''autre. Une douzaine de pays l''ont utilisé, de l''Australie à la Jordanie.',
    E'## Genesis\nIn 1972 the **US Army** Aviation and Missile Command launched the **Variable Speed Training Target** (VSTT) requirement: it needed a target able to exercise its surface-to-air missiles. **Beech Aircraft** offered the MQM-107, which first flew in 1974, and was announced the winner in 1975; the Army took delivery of the original model, the **MQM-107A**, until 1979. The target was used to test the **FIM-92 Stinger** and the **MIM-104 Patriot**, and the US Air Force then adopted it for practice engagements with its air-to-air missiles, from the **AIM-9 Sidewinder** to the **AIM-120 AMRAAM**.\n\n## Design\nThe Streaker is a high-subsonic target with slightly swept wings and a turbojet mounted on the fuselage centreline. It is launched from the ground by a rocket booster until the jet engine takes over, and comes down by parachute to be reused. Its speciality is towing: it trails radar or infrared targets for missiles, or a square banner with an enhanced radar signature for guns, and can carry flare or chaff pods. At 5.5 m long, it weighs 664 kg at take-off, reaches 925 km/h and climbs above 12,000 m.\n\n## Operational career\nOver two decades new versions followed one another: the larger **MQM-107B** of 1982 with a **Microturbo TRI 60**, the C built to use up surplus A-model engines, the D of 1987, then the **MQM-107E** of 1992, with redesigned surfaces for greater manoeuvrability and built by BAE Systems. Exported as the **Model 999**, it served in Sweden, Egypt, Turkey, Taiwan, South Korea and the United Arab Emirates. Australia chose the MQM-107E, named **N28 Kalkara**, to replace its **Jindivik** targets. In 2012 it emerged that North Korea had acquired several second-hand from a Middle Eastern country; the following year it revealed an indigenous target drone believed to be based on it.\n\n## Place in history\nWith 2,236 built up to 2003, the Streaker was the standard target of the American forces for nearly thirty years, before giving way to the **BQM-167 Skeeter**. Its success rests on a simple idea: rather than being the target, it carries the target on the end of a cable, which lets it be recovered and reused from one exercise to the next. A dozen countries have used it, from Australia to Jordan.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1972-01-01',
    '1974-01-01',
    NULL,
    925,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Beechcraft MQM-107 Streaker'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 5.5,
  wingspan          = 3.0,
  height            = 1.47,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 664,
  service_ceiling   = 12192,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Microturbo TRI 60',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 2003,
  units_built       = 2236,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 12,
  variants          = E'- **MQM-107A** : modèle d''origine à réacteur Teledyne CAE J402-CA-700, exporté sous le nom de Model 999\n- **MQM-107B** : 1982, fuselage agrandi, réacteur Microturbo TRI 60-2, charge utile accrue\n- **MQM-107C** : cellule du B et réacteur du A, pour écouler les stocks de J402\n- **MQM-107D** : 1987, réacteur J402-CA-702 puis TRI 60-5 en 1989\n- **MQM-107E** : 1992, voilure et empennage redessinés, construit par BAE Systems ; N28 Kalkara en Australie\n- **Super-MQM / Raider** : version Raytheon plus puissante et projet de drone tactique de leurrage (1985)',
  variants_en       = E'- **MQM-107A**: original model with a Teledyne CAE J402-CA-700 turbojet, exported as the Model 999\n- **MQM-107B**: 1982, larger fuselage, Microturbo TRI 60-2 engine, higher payload\n- **MQM-107C**: B-model airframe with the A-model engine, to use up J402 stocks\n- **MQM-107D**: 1987, J402-CA-702 engine, then TRI 60-5 in 1989\n- **MQM-107E**: 1992, redesigned wing and tail, built by BAE Systems; N28 Kalkara in Australia\n- **Super-MQM / Raider**: more powerful Raytheon version and a 1985 tactical decoy UAV proposal',

  -- Strate 4 : qualitatif
  nickname          = 'Streaker',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_MQM-107_Streaker',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_MQM-107_Streaker',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Master Sgt. Michael Ammons, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Beechcraft MQM-107 Streaker';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Beechcraft MQM-107 Streaker';
