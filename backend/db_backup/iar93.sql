-- Avioane Craiova IAR-93 Vultur
--
-- Photo : IAR 93 on display at Vădeni Airfield.jpg
--   licence CC BY-SA 4.0 — Radu Aramă
--   https://commons.wikimedia.org/wiki/File:IAR_93_on_display_at_Vădeni_Airfield.jpg

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
    'IAR-93 Vultur',
    'IAR-93 Vultur',
    'Avioane Craiova IAR-93 Vultur',
    'Avioane Craiova IAR-93 Vultur',
    'Biréacteur d''attaque roumain, jumeau du J-22 Orao né pour s''affranchir du matériel soviétique',
    'Romanian twinjet attack aircraft, twin of the J-22 Orao, built to break free of Soviet equipment',
    '/assets/airplanes/iar93-vultur.jpg',
    E'## Genèse\nAu début des années 1970, la **Roumanie** et la **Yougoslavie** veulent dépendre moins du matériel soviétique. Le 20 mai 1971, les deux gouvernements signent l''accord du programme **YuRom**, dirigé par **Teodor Zamfirescu** côté roumain et par le colonel **Vidoje Knežević** côté yougoslave. Le cahier des charges demande un avion subsonique léger d''attaque au sol et de reconnaissance tactique, capable de combat aérien à basse altitude, robuste, apte aux pistes en herbe ou endommagées, et construit avec des équipements nationaux compatibles avec l''Occident. En Roumanie, il doit remplacer les **MiG-15** et **MiG-17** dans le rôle de chasseur-bombardier.\n\n## Conception\nC''est un biréacteur classique à aile haute, toutes surfaces en flèche. Le **Rolls-Royce Viper** est retenu parce que Soko le construit déjà sous licence ; la postcombustion prévue tarde tant que ni les avions de présérie ni les premiers de série n''en sont équipés. Le prototype roumain 001 vole le 31 octobre 1974 à Bacău, piloté par le colonel **Gheorghe Stănică**, le même jour que son jumeau yougoslave à Batajnica. Les essais coûtent cher : un biplace perd sa gouverne de profondeur par flottement en novembre 1977, un prototype s''écrase en démonstration à Craiova en février 1979 en tuant son pilote, et le 001 est perdu en septembre 1979 après l''arrêt de ses deux réacteurs.\n\n## Carrière opérationnelle\nQuinze avions de présérie sont livrés en 1979 et l''IAR-93A, sans postcombustion, entre en service en 1981 ; suivent l''IAR-93MB en 1982 puis l''IAR-93B, en service en 1987, avec des Viper Mk 633-47 à postcombustion, plus de carburant et une voilure revue. Ils équipent le 67e régiment de chasseurs-bombardiers à Craiova et le 49e à Ianca. En 1988, l''**Iran** envisage d''en acheter 48, mais le cessez-le-feu avec l''Irak clôt le projet. La guerre en Yougoslavie et l''embargo de l''ONU arrêtent la production en 1992, alors que 125 avions supplémentaires avaient été commandés en 1989.\n\n## Place dans l''histoire\nLe 9 juillet 1997, un IAR-93 explose sur la piste de Craiova pendant la préparation d''essais de bombes à sous-munitions roumaines, tuant seize mécaniciens. Le dernier vol du type a lieu le 9 avril 1998, et les avions restants sont mis sous cocon. Sur 116 cellules lancées, 87 seulement ont été achevées et mises en service, tandis que son jumeau le **Soko J-22 Orao** vole toujours en Serbie. Fruit d''une coopération rare entre deux pays de l''Est soucieux d''indépendance, l''IAR-93 est aujourd''hui exposé dans une vingtaine de musées, d''écoles et de villages de Roumanie et jusqu''en Slovaquie.',
    E'## Genesis\nIn the early 1970s **Romania** and **Yugoslavia** both wanted to depend less on Soviet equipment. On 20 May 1971 the two governments signed the agreement for the **YuRom** programme, led by **Teodor Zamfirescu** for Romania and Colonel **Vidoje Knežević** for Yugoslavia. The requirement called for a light subsonic aircraft for ground attack and tactical reconnaissance, with a secondary low-level air combat capability, tough, able to use grass or damaged runways, and built with local equipment compatible with Western components. In Romania it was to replace the **MiG-15** and **MiG-17** in the fighter-bomber role.\n\n## Design\nThe aircraft was a conventional twin-engined, high-wing monoplane with all flying surfaces swept. The **Rolls-Royce Viper** was chosen because Soko already built it under licence; the planned afterburner ran into such delays that neither the pre-production aircraft nor the early production examples had it. The Romanian prototype 001 flew on 31 October 1974 at Bacău, flown by Colonel **Gheorghe Stănică**, on the same day as its Yugoslav twin at Batajnica. Testing was costly: a two-seater lost its elevator to flutter in November 1977, a prototype crashed during an aerobatic display at Craiova in February 1979, killing its pilot, and 001 was lost in September 1979 when both engines stopped.\n\n## Operational career\nFifteen pre-production aircraft were delivered in 1979 and the non-afterburning IAR-93A entered service in 1981; the IAR-93MB followed in 1982, then the IAR-93B, in service from 1987, with afterburning Viper Mk 633-47s, more fuel and a revised wing. They equipped the 67th Fighter-Bomber Regiment at Craiova and the 49th at Ianca. In 1988 **Iran** considered buying 48, but the ceasefire with Iraq ended the project. The war in Yugoslavia and the UN embargo halted production in 1992, although a further 125 aircraft had been ordered in 1989.\n\n## Place in history\nOn 9 July 1997 an IAR-93 exploded on the runway at Craiova while being prepared for trials of Romanian cluster munitions, killing sixteen ground crew. The type''s last flight took place on 9 April 1998, and the remaining aircraft were mothballed. Of 116 airframes started, only 87 were completed and entered service, while its twin, the **Soko J-22 Orao**, still flies with the Serbian air force. The product of a rare collaboration between two Eastern countries seeking independence, the IAR-93 is now displayed at some twenty museums, schools and villages in Romania and as far afield as Slovakia.',
    (SELECT id FROM countries WHERE code = 'ROU'),
    '1971-05-20',
    '1974-10-31',
    '1981-01-01',
    1086,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'IAR'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM armement WHERE name = 'S-5')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM armement WHERE name = 'R-3S')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'IAR-93 Vultur'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.9,
  wingspan          = 9.3,
  height            = 4.52,
  wing_area         = 26,
  empty_weight      = 5750,
  mtow              = 10900,
  service_ceiling   = 13600,
  climb_rate        = 65,
  g_limit_pos       = 8,
  g_limit_neg       = -4.2,
  combat_radius     = 530,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomecanica / Rolls-Royce Viper Mk 633-47',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 17.79,
  thrust_wet        = 22.24,

  -- Strate 3 : production & service
  production_start  = 1975,
  production_end    = 1992,
  units_built       = 87,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **IAR-93A** : première version, réacteurs Viper Mk 632-41 sans postcombustion, 26 monoplaces et 9 biplaces DC, en service en 1981\n- **IAR-93MB** : cellule de l''IAR-93B et réacteurs sans postcombustion de l''IAR-93A, 15 monoplaces livrés à partir de 1982\n- **IAR-93B** : réacteurs Viper Mk 633-47 à postcombustion, carburant accru, voilure revue, 27 monoplaces et 7 biplaces, en service en 1987\n- **IAR-93 DC** : biplace d''entraînement avancé et de tir, décliné en A et en B ; l''exemplaire 600 a reçu des plans canard expérimentaux\n- **Soko J-22 Orao** : version yougoslave du même programme YuRom, construite par Soko',
  variants_en       = E'- **IAR-93A**: first version, non-afterburning Viper Mk 632-41 engines, 26 single-seaters and 9 DC two-seaters, in service in 1981\n- **IAR-93MB**: IAR-93B airframe with the IAR-93A''s non-afterburning engines, 15 single-seaters delivered from 1982\n- **IAR-93B**: afterburning Viper Mk 633-47 engines, more fuel, revised wing, 27 single-seaters and 7 two-seaters, in service in 1987\n- **IAR-93 DC**: two-seat advanced and weapons trainer, built in A and B versions; aircraft 600 was fitted with experimental canards\n- **Soko J-22 Orao**: Yugoslav version from the same YuRom programme, built by Soko',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAR-93_Vultur',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Radu Aramă',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'IAR-93 Vultur';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAR-93 Vultur';
