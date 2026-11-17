-- North American B-45 Tornado
--
-- Photo : B-45c tornado.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:B-45c_tornado.jpg

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
    'B-45 Tornado',
    'B-45 Tornado',
    'North American B-45 Tornado',
    'North American B-45 Tornado',
    'Premier bombardier à réaction de l''US Air Force, entre guerre de Corée et survols secrets de l''URSS',
    'The US Air Force''s first jet bomber, from the Korean War to secret overflights of the USSR',
    '/assets/airplanes/b45-tornado.jpg',
    E'## Genèse\nÀ l''automne 1944, l''apparition du bombardier à réaction allemand **Arado Ar 234** pousse le département de la Guerre américain à réclamer une famille de bombardiers à réaction : l''exigence formelle de l''USAAF tombe le 17 novembre 1944. **North American Aviation** y répond avec son projet NA-130, dont trois prototypes sont mis en chantier. La fin de la guerre gèle le programme, que les tensions avec l''URSS relancent en 1946. Le XB-45 et le **Convair XB-46** sont alors presque achevés, quand le **Boeing XB-47** et le **Martin XB-48** ont encore deux ans de retard : plus avancé et moins cher, le North American décroche un contrat de production le 2 janvier 1947.\n\n## Conception\nLes historiens **Bill Gunston** et Peter Gilchrist le décrivent comme un bombardier classique sur lequel on a monté des réacteurs : aile droite, train tricycle et quatre turboréacteurs **General Electric J47** groupés par paires sous la voilure. Quatre hommes d''équipage, dont un mitrailleur de queue servant deux mitrailleuses de 12,7 mm, et jusqu''à 10 t de bombes en soute. Le premier vol a lieu le 17 mars 1947 à Muroc, avec George Krebs et Paul Brewer ; les essais coûtent le premier prototype et ses deux pilotes. Le **B-45C**, doté de réservoirs en bout d''aile, devient le premier bombardier multiréacteur ravitaillé en vol.\n\n## Carrière opérationnelle\nLa **guerre de Corée** lui rend son utilité. Le 4 décembre 1950, un RB-45C est abattu au-dessus de la Chine par le MiG-15 d''**Aleksandr Andrianov** : c''est la première interception d''un bombardier à réaction par un chasseur à réaction. Les RB-45C livrent ensuite de précieux renseignements, de nuit à partir de 1952. L''opération **Fandango** adapte 40 appareils à l''arme nucléaire, déployés au Royaume-Uni dès mai 1952 comme première ligne de dissuasion en Europe. Sous l''opération **Ju-jitsu**, des équipages de la RAF menés par **John Crampton** survolent l''Union soviétique à bord de RB-45C aux cocardes britanniques, comme le 17 avril 1952 en direction de Kiev.\n\n## Place dans l''histoire\nConstruit à 142 exemplaires, le Tornado n''était qu''une solution d''attente, vite éclipsée par le **B-47 Stratojet** qui remplace ses versions de reconnaissance dès 1954. Les derniers quittent le service actif à la fin des années 1950. Il a pourtant ouvert la voie : premier bombardier à réaction opérationnel de l''USAF, premier jet multimoteur ravitaillé en vol, auteur le 29 juillet 1952 de la première traversée sans escale du Pacifique, il a porté la dissuasion nucléaire américaine en Europe au début des années 1950.',
    E'## Genesis\nIn autumn 1944 the appearance of the German **Arado Ar 234** jet bomber prompted the US War Department to call for a family of jet bombers: the USAAF''s formal requirement was issued on 17 November 1944. **North American Aviation** answered with its NA-130 design, and three prototypes were laid down. The end of the war froze the programme, but rising tension with the Soviet Union revived it in 1946. The XB-45 and the **Convair XB-46** were then nearly complete, while the **Boeing XB-47** and **Martin XB-48** were still two years away: more advanced and cheaper, the North American design won a production contract on 2 January 1947.\n\n## Design\nHistorians **Bill Gunston** and Peter Gilchrist described it as a traditional bomber onto which jet engines had been fitted: a straight wing, tricycle undercarriage and four **General Electric J47** turbojets paired under the wing. It carried a crew of four, including a tail gunner with two 12.7 mm machine guns, and up to 10 tonnes of bombs. The first flight took place at Muroc on 17 March 1947, with George Krebs and Paul Brewer at the controls; the rushed test programme cost the first prototype and its two pilots. The **B-45C**, fitted with wingtip tanks, became the first multi-engined jet bomber to be refuelled in flight.\n\n## Operational career\nThe **Korean War** made it useful again. On 4 December 1950 an RB-45C was shot down over China by the MiG-15 of **Aleksandr Andrianov**: the first interception of a jet bomber by a jet fighter. The RB-45Cs went on to provide valuable intelligence, flying at night from 1952. Operation **Fandango** adapted 40 aircraft to carry nuclear weapons, and they deployed to the United Kingdom from May 1952 as the first line of deterrence in Europe. Under Operation **Ju-jitsu**, RAF crews led by **John Crampton** overflew the Soviet Union in RB-45Cs wearing British roundels, as on 17 April 1952 on a run towards Kyiv.\n\n## Place in history\nBuilt in 142 examples, the Tornado was only a stopgap, soon eclipsed by the **B-47 Stratojet**, which replaced its reconnaissance versions from 1954. The last left active service at the end of the 1950s, while a few served as test aircraft into the early 1970s. Yet it opened the way: the USAF''s first operational jet bomber, the first multi-engined jet refuelled in flight, the first aircraft to fly the Pacific non-stop on 29 July 1952, it carried American nuclear deterrence in Europe in the early 1950s.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-11-17',
    '1947-03-17',
    '1948-04-22',
    911,
    3490,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'B-45 Tornado'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.96,
  wingspan          = 27.13,
  height            = 7.67,
  wing_area         = 109.2,
  empty_weight      = 20726,
  mtow              = 41628,
  service_ceiling   = 14000,
  climb_rate        = 26,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J47-GE-13',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 23.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = 1951,
  units_built       = 142,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **XB-45** : trois prototypes, dont un détruit au début des essais avec ses deux pilotes\n- **B-45A** : première version de série, 96 exemplaires, les premiers à réacteurs J35 puis J47\n- **B-45C** : réservoirs en bout d''aile et réceptacle de ravitaillement en vol, dix exemplaires\n- **RB-45C** : reconnaissance, nez vitré remplacé par des caméras obliques, jusqu''à douze appareils photo, 33 exemplaires\n- **B-45 Fandango** : 40 appareils modifiés pour l''arme nucléaire et déployés au Royaume-Uni en 1952',
  variants_en       = E'- **XB-45**: three prototypes, one of them lost early in testing with both pilots\n- **B-45A**: first production version, 96 built, the first with J35 engines and then J47s\n- **B-45C**: wingtip tanks and in-flight refuelling receptacle, ten built\n- **RB-45C**: reconnaissance version, glazed nose replaced by oblique cameras, up to twelve cameras, 33 built\n- **B-45 Fandango**: 40 aircraft modified to carry nuclear weapons and deployed to the United Kingdom in 1952',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_B-45_Tornado',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_B-45_Tornado',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'B-45 Tornado';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'B-45 Tornado';
