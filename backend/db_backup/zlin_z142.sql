-- Moravan Zlín Z 142
--
-- Photo : Zlin 142C-AF 0566 (8215830534).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File:Zlin_142C-AF_0566_(8215830534).jpg

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
    'Zlín Z 142',
    'Zlín Z 142',
    'Moravan Zlín Z 142',
    'Moravan Zlín Z 142',
    'Biplace d''école et de voltige tchécoslovaque à sièges côte à côte, version la plus répandue de la famille Z 42',
    'Czechoslovak side-by-side aerobatic trainer, the most popular member of the Z 42 family',
    '/assets/airplanes/zlin-z142.jpg',
    E'## Genèse\nLe Z 142 est construit par **Moravan**, à Otrokovice, une entreprise fondée en 1934 par **Tomáš Baťa** en Tchécoslovaquie. Pour succéder à ses **Zlín Trenér**, biplaces d''école et de voltige en tandem, Moravan lance une nouvelle famille d''avions légers à sièges côte à côte : le biplace **Z 42** et le quadriplace **Z 43**. Le Z 42 vole le 17 octobre 1967 et obtient son certificat de navigabilité le 7 septembre 1970 ; une version revue, le **Z 42M**, suit en novembre 1972. Le **Z 142**, cellule biplace légèrement agrandie, vole pour la première fois le 29 décembre 1978.\n\n## Conception\nLa partie centrale du fuselage est en tubes d''acier soudés, habillée de tôle et de panneaux de fibre de verre, avec un cône arrière monocoque, une aile bilongeron entièrement métallique et un train tricycle fixe à roulette avant orientable. Conçue pour l''enseignement de la voltige, la famille est certifiée à +6 g et −4 g et dispose de circuits d''essence et d''huile permettant le vol dos prolongé. Le Z 142 reprend le moteur du Z 43, un six-cylindres en ligne inversé **Walter M 337** à injection et compresseur, plus puissant que le M 137 du Z 42. Il se reconnaît à sa verrière bulle coulissant vers l''avant.\n\n## Carrière opérationnelle\nLe Z 142 devient la version la plus populaire de la gamme du constructeur, appréciée des organismes de formation au pilotage. Il équipe l''armée de l''air **cubaine**, le centre de formation au vol de **Pardubice**, en République tchèque, et l''armée de l''air **algérienne**, qui le produit sous licence : l''**ECA-Fernas 142**, doté de modifications de voltige, vole en 1993. Son emploi le plus inattendu est celui des **Tigres de libération de l''Îlam tamoul** : en 2007, deux Zlín de leurs « Air Tigers », de la famille Z 142 / Z 143 (l''identification exacte reste discutée), bombardent des bases de l''armée de l''air sri-lankaise. En octobre 2008, ils attaquent encore une base de l''armée et une centrale électrique aux abords de Colombo.\n\n## Place dans l''histoire\nLe Z 142 prolonge une lignée d''avions d''école tchécoslovaques qui remonte au Trenér. À la fin des années 1980, Moravan remplace le moteur en ligne inversé par un quatre-cylindres à plat **Lycoming IO-360** : c''est le **Z 242L**, reconnaissable à son capot plus large, adopté par les forces aériennes de Croatie, de Hongrie, de Macédoine du Nord ou de Slovénie. En 2021, une version redessinée, le **Zeus**, prend la suite. Près de soixante ans après le premier vol du Z 42, la famille est toujours produite.',
    E'## Genesis\nThe Z 142 was built by **Moravan** of Otrokovice, a company founded in 1934 by **Tomáš Baťa** in Czechoslovakia. To follow on from its **Zlín Trenér** tandem aerobatic trainers, Moravan developed a new family of light aircraft with side-by-side seating: the two-seat **Z 42** and the four-seat **Z 43**. The Z 42 first flew on 17 October 1967 and was certified airworthy on 7 September 1970; a revised version, the **Z 42M**, followed in November 1972. The **Z 142**, a slightly enlarged two-seat airframe, first flew on 29 December 1978.\n\n## Design\nThe centre fuselage is of welded steel tube covered with sheet metal and fibreglass panels, with a monocoque tailcone, an all-metal two-spar wing and fixed tricycle landing gear with a steerable nosewheel. Designed for aerobatic instruction, the family was certified to +6 g and −4 g and had full inverted fuel and oil systems for extended inverted flight. The Z 142 took the engine of the Z 43, a fuel-injected, supercharged inverted six-cylinder inline **Walter M 337**, more powerful than the Z 42''s M 137. It can be recognised by its forward-sliding bubble canopy.\n\n## Operational career\nThe Z 142 became the most popular variant in the manufacturer''s range, favoured by flying training organisations. It served with the **Cuban** Air Force, the Flight Training Center at **Pardubice** in the Czech Republic and the **Algerian** Air Force, which built it under licence: the **ECA-Fernas 142**, with aerobatic modifications, first flew in 1993. Its most unexpected users were the **Liberation Tigers of Tamil Eelam**: in 2007 two Zlíns of their ''Air Tigers'', of the Z 142 / Z 143 family (the exact identification is still debated), carried out bombing sorties against Sri Lanka Air Force bases. In October 2008 they also attacked a Sri Lanka Army base and a power station on the outskirts of Colombo.\n\n## Place in history\nThe Z 142 continued a line of Czechoslovak trainers going back to the Trenér. In the late 1980s Moravan replaced the inverted inline engine with a flat-four **Lycoming IO-360**: this was the **Z 242L**, recognisable by its wider cowling, adopted by the air forces of Croatia, Hungary, North Macedonia and Slovenia. In 2021 a redesigned version, the **Zeus**, took over. Nearly sixty years after the Z 42''s first flight, the family remains in production.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    NULL,
    '1978-12-29',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'ZLIN'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Zlín Z 142'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Zlín Z 142'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Zlín Z 142'), (SELECT id FROM wars WHERE name = 'Guerre civile du Sri Lanka'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Walter M 337AK (210 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Z 42** : version initiale à moteur Avia M 137 de 180 ch, premier vol le 17 octobre 1967 ; 48 construits\n- **Z 42M** : dérive revue et hélice à vitesse constante, premier vol en novembre 1972 ; 149 construits\n- **Z 142** : cellule légèrement agrandie, verrière bulle coulissante et moteur M 337, premier vol le 29 décembre 1978\n- **ECA-Fernas 142** : Z 142 produit sous licence en Algérie avec des modifications de voltige, premier vol en 1993\n- **Z 242L Guru / Zeus** : moteur à plat Lycoming IO-360 à partir de la fin des années 1980, puis version redessinée en 2021',
  variants_en       = E'- **Z 42**: initial version with a 180 hp Avia M 137 engine, first flown on 17 October 1967; 48 built\n- **Z 42M**: revised fin and constant-speed propeller, first flown in November 1972; 149 built\n- **Z 142**: slightly enlarged airframe, sliding bubble canopy and M 337 engine, first flown on 29 December 1978\n- **ECA-Fernas 142**: Z 142 built under licence in Algeria with aerobatic modifications, first flown in 1993\n- **Z 242L Guru / Zeus**: Lycoming IO-360 flat engine from the late 1980s, then a redesigned version in 2021',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Zlín_Z_42',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Zlín_Z_42',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Zlín Z 142';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Zlín Z 142';
