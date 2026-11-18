-- Douglas C-74 Globemaster
--
-- Photo : Douglas C-74 (4790013757).jpg
--   licence CC BY-SA 2.0 — Bill Larkins
--   https://commons.wikimedia.org/wiki/File:Douglas_C-74_(4790013757).jpg

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
    'Douglas C-74 Globemaster',
    'Douglas C-74 Globemaster',
    'Douglas C-74 Globemaster',
    'Douglas C-74 Globemaster',
    'Quatorze géants nés trop tard pour la guerre, qui ont appris à l''US Air Force le transport lourd',
    'Fourteen giants born too late for the war, which taught the US Air Force heavy airlift',
    '/assets/airplanes/c74-globemaster.jpg',
    E'## Genèse\nAprès Pearl Harbor, les distances à franchir au-dessus de l''Atlantique et surtout du Pacifique imposent un transport militaire lourd transocéanique. Au début de 1942, le « C-74 Project Group » de **Douglas** part du DC-4 pour concevoir un cargo sans fioritures, capable d''emporter chars légers, obusiers de 105 mm avec leurs tracteurs ou bulldozers. Le 25 juin 1942, un contrat de plus de 50 millions de dollars porte sur 50 avions. Les difficultés de mise au point repoussent le premier vol au 5 septembre 1945, à Long Beach, trois jours après la capitulation du Japon.\n\n## Conception\nLe C-74 est alors le plus gros avion terrestre lancé en série, avec 78 tonnes au décollage : plus long de 9,4 m que le **C-54 Skymaster**, il emporte 125 soldats, 115 civières ou plus de 21 tonnes de fret. Une section du plancher peut descendre par un puits ventral grâce à deux palans mobiles, ce qui allège le chargement sans matériel au sol, et des coursives dans l''aile permettent au mécanicien d''intervenir sur les moteurs en vol. Ses quatre **Pratt & Whitney R-4360 Wasp Major** sont portés à 3 250 ch. Les deux verrières séparées du pilote et du copilote, mal aimées des équipages, sont remplacées par un poste classique.\n\n## Carrière opérationnelle\nLa commande est annulée en janvier 1946 après quatorze exemplaires, ce qui tue aussi la version de ligne commandée par la Pan Am. Onze servent à l''Air Transport Command puis au **MATS**, sur des lignes régulières vers Panama, Hawaï, l''Alaska, le Maroc ou l''Angleterre, et en soutien des bombardiers B-47 du Strategic Air Command. Pendant le **pont aérien de Berlin**, un seul C-74 réalise 24 rotations en six semaines de l''été 1948 et livre 559 tonnes, dont des engins de chantier découpés au chalumeau pour bâtir Tegel. Pendant la **guerre de Corée**, la flotte vole plus de 7 000 heures vers Hawaï avec des troupes et du fret, et ramène 2 486 blessés.\n\n## Place dans l''histoire\nÀ partir de 1952, les pièces manquent ; les C-74 sont retirés en 1956, et l''un d''eux finit au cinéma dans *L''or se barre* en 1969. Leur production confidentielle a pourtant donné à l''Air Force l''expérience des très gros porteurs, et Berlin a montré qu''il lui en fallait. Le cinquième exemplaire, doté d''un fuselage bien plus vaste sur la même aile, devient le prototype du **C-124 Globemaster II**, qui reprend le flambeau du transport stratégique pendant de longues années.',
    E'## Genesis\nAfter Pearl Harbor, the distances across the Atlantic and above all the Pacific called for a heavy transoceanic military transport. In early 1942 the **Douglas** "C-74 Project Group" started from the DC-4 to design a no-frills freighter able to carry light tanks, 105 mm howitzers with their tractors, or bulldozers. On 25 June 1942 a contract worth more than 50 million dollars covered 50 aircraft. Development problems delayed the first flight to 5 September 1945, at Long Beach, three days after Japan''s surrender.\n\n## Design\nThe C-74 was then the largest landplane to enter production, at 78 tonnes for take-off: 9.4 m longer than the **C-54 Skymaster**, it carried 125 troops, 115 stretchers or more than 21 tonnes of freight. A section of floor could be lowered through a belly well by two travelling hoists, easing loading without ground equipment, and crawlways in the wing let the flight engineer service the engines in flight. Its four **Pratt & Whitney R-4360 Wasp Majors** were uprated to 3,250 hp. The separate bubble canopies for pilot and co-pilot, disliked by crews, were replaced by a conventional flight deck.\n\n## Operational career\nThe order was cancelled in January 1946 after fourteen aircraft, which also killed the airliner version ordered by Pan Am. Eleven served with Air Transport Command and then **MATS**, on scheduled routes to Panama, Hawaii, Alaska, Morocco and England, and in support of Strategic Air Command''s B-47 bombers. During the **Berlin Airlift**, a single C-74 flew 24 missions in six weeks in the summer of 1948 and delivered 559 tonnes, including construction equipment cut up with torches to build Tegel. During the **Korean War**, the fleet logged more than 7,000 hours to Hawaii carrying troops and cargo, and flew home 2,486 wounded.\n\n## Place in history\nFrom 1952 spare parts ran short; the C-74s were retired in 1956, and one ended up on screen in *The Italian Job* in 1969. Their tiny production run nevertheless gave the Air Force experience of very large transports, and Berlin showed that it needed them. The fifth aircraft, given a much larger fuselage on the same wing, became the prototype of the **C-124 Globemaster II**, which carried on strategic airlift for many years.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1942-01-01',
    '1945-09-05',
    '1947-01-01',
    528,
    5500,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-74 Globemaster'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-74 Globemaster'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-74 Globemaster'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Douglas C-74 Globemaster'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 37.83,
  wingspan          = 52.81,
  height            = 13.34,
  wing_area         = 233,
  empty_weight      = 39087,
  mtow              = 78018,
  service_ceiling   = 6500,
  climb_rate        = 13.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360 Wasp Major (3 250 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1947,
  units_built       = 14,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **C-74 Globemaster** : version unique, 14 construits sur 50 commandés, dont 11 en service opérationnel\n- **Cellule d''essais statiques** : le quatrième exemplaire, testé jusqu''à la rupture à Wright Field de 1946 à 1948\n- **YC-124** : le cinquième exemplaire, doté d''un fuselage agrandi, prototype du C-124 Globemaster II\n- **DC-7 (Model 415A)** : version de ligne pressurisée de 108 places commandée par la Pan Am, abandonnée en 1946\n- **Exemplaires civils** : quatre C-74 revendus, surtout à Aeronaves de Panama pour le transport de bétail en Europe',
  variants_en       = E'- **C-74 Globemaster**: sole version, 14 built out of 50 ordered, 11 of which saw operational service\n- **Static test airframe**: the fourth aircraft, tested to destruction at Wright Field from 1946 to 1948\n- **YC-124**: the fifth aircraft, given an enlarged fuselage, prototype of the C-124 Globemaster II\n- **DC-7 (Model 415A)**: pressurised 108-seat airliner version ordered by Pan Am, abandoned in 1946\n- **Civil aircraft**: four C-74s sold off, mostly to Aeronaves de Panama for cattle flights in Europe',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_C-74_Globemaster',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_C-74_Globemaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bill Larkins',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Douglas C-74 Globemaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas C-74 Globemaster';
