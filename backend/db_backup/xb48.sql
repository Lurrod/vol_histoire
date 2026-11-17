-- Martin XB-48
--
-- Photo : Martin XB-48 in flight 061025-F-1234S-016.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:Martin_XB-48_in_flight_061025-F-1234S-016.jpg

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
    'Martin XB-48',
    'Martin XB-48',
    'Martin XB-48',
    'Martin XB-48',
    'Six réacteurs sur une aile de Marauder, et le premier train monotrace jamais dessiné pour un avion',
    'Six jet engines on a Marauder-style wing, and the first aircraft designed with bicycle landing gear',
    '/assets/airplanes/xb48.jpg',
    E'## Genèse\nEn 1944, le département de la Guerre américain, averti des progrès de l''aviation allemande, réclame une gamme de bombardiers moyens à réaction pesant de 36 à plus de 90 tonnes. De cet appel d''offres naît la « classe de 45 » : le **North American XB-45**, le **Convair XB-46** et le Martin XB-48. La **Glenn L. Martin Company** en tire un bombardier de transition, qui marie la puissance des turboréacteurs à l''aérodynamique de la Seconde Guerre mondiale : aile et empennages droits, fuselage rond. Deux prototypes sont construits, immatriculés 45-59585 et 45-59586.\n\n## Conception\nL''influence du **B-26 Marauder** est évidente. Mais là où le Marauder se contentait de deux gros moteurs en étoile à 18 cylindres, le XB-48 a besoin de pas moins de six turboréacteurs **General Electric J35**, tant la poussée des premiers réacteurs est faible. Il semble porter six nacelles ; il n''en a en réalité que deux, très larges, abritant chacune trois réacteurs séparés par un réseau complexe de conduits d''air de refroidissement. Son aile étant trop mince pour loger un train classique, le XB-48 devient le **premier avion conçu avec un train monotrace** : deux diabolos en tandem dans le fuselage et des balancines sous les ailes, une formule d''abord éprouvée sur un B-26 modifié.\n\n## Essais\nLe 22 juin 1947, le premier prototype effectue un vol de 37 minutes et de 117 km entre l''usine Martin de Baltimore et la base aéronavale de Patuxent River. À l''atterrissage, le pilote **Pat Tibbs** appuie fort sur le levier de freinage, conçu spécialement mais très lent à réagir : les quatre pneus éclatent. Ni lui ni son copilote Dutch Gelvin ne sont blessés. Pendant ce temps, Boeing exploite les recherches allemandes sur l''aile en flèche pour mettre au point le **B-47 Stratojet**, qui surclasse toute la classe de 45. Le XB-48 n''est plus poursuivi que comme solution de secours si le Boeing rencontrait des difficultés, ce qui n''arrive pas, et le programme est annulé en 1948.\n\n## Place dans l''histoire\nAucun des concurrents de 1944 ne réussit vraiment : seul le **B-45 Tornado** est construit en série, et il ne sert que quelques années comme bombardier avant d''être remplacé par le B-47. La formule qu''il a inaugurée, un train monotrace logé dans le fuselage, équipe pourtant aussi le B-47 et le **XB-51** du même constructeur. Il reste l''image d''une technique en transition, où l''on multipliait les réacteurs faute de pouvoir les rendre puissants.',
    E'## Genesis\nIn 1944 the US War Department, aware of German advances, called for a range of jet medium bombers weighing from 36 to over 90 tonnes. That competition produced the Class of ''45: the **North American XB-45**, the **Convair XB-46** and the Martin XB-48. The **Glenn L. Martin Company** turned out a transitional bomber that combined the power of turbojets with Second World War aerodynamics: straight wings and tail surfaces and a round fuselage. Two prototypes were built, serials 45-59585 and 45-59586.\n\n## Design\nThe influence of the **B-26 Marauder** was plain. But where the Marauder made do with two massive 18-cylinder radials, the XB-48 needed no fewer than six **General Electric J35** turbojets, so weak were the early jet engines. It appeared to have six nacelles; in fact it had only two very wide ones, each housing three engines separated by an intricate set of cooling air ducts. With a wing too thin for conventional undercarriage, the XB-48 became the **first aircraft designed with bicycle landing gear**: two tandem wheel units in the fuselage and outriggers under the wings, a layout first proven on a modified B-26.\n\n## Testing\nOn 22 June 1947 the first prototype made a 37-minute, 117 km flight from Martin''s Baltimore plant to Naval Air Station Patuxent River. On landing, pilot **Pat Tibbs** pressed hard on the specially designed but very slow-acting brake lever, and all four tyres burst. Neither he nor co-pilot Dutch Gelvin was hurt. Meanwhile Boeing was using German swept-wing research to develop the **B-47 Stratojet**, which outclassed the whole Class of ''45. The XB-48 was kept going only as a fallback in case the Boeing ran into trouble, which it did not, and the programme was cancelled in 1948.\n\n## Place in history\nNone of the 1944 contenders truly succeeded: only the **B-45 Tornado** was built in series, and it served just a few years as a bomber before being replaced by the B-47. Yet the layout it pioneered, a bicycle undercarriage housed in the fuselage, was also used on the B-47 and on the same company''s **XB-51**. It remains the image of a technology in transition, when engines were multiplied because they could not yet be made powerful.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-11-17',
    '1947-06-22',
    NULL,
    841,
    2900,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin XB-48'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Martin XB-48'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.14,
  wingspan          = 33.02,
  height            = 8.08,
  wing_area         = 123.5,
  empty_weight      = 26535,
  mtow              = 46540,
  service_ceiling   = 12000,
  climb_rate        = 21,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J35',
  engine_count      = 6,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XB-48** (45-59585) : premier prototype, premier vol le 22 juin 1947\n- **XB-48** (45-59586) : second prototype, aucune version de série ne suit\n- **Train monotrace** : deux diabolos en tandem dans le fuselage et balancines d''aile, éprouvés sur un B-26 modifié\n- **Armement prévu** : une bombe de 9 t ou 36 bombes de 113 kg, deux mitrailleuses de 12,7 mm en tourelle de queue',
  variants_en       = E'- **XB-48** (45-59585): first prototype, first flight on 22 June 1947\n- **XB-48** (45-59586): second prototype, no production version followed\n- **Bicycle undercarriage**: two tandem wheel units in the fuselage and wing outriggers, proven on a modified B-26\n- **Planned armament**: one 9-tonne bomb or 36 bombs of 113 kg, two 12.7 mm machine guns in a tail turret',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_XB-48',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_XB-48',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Martin XB-48';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin XB-48';
