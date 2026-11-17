-- Douglas A2D Skyshark
--
-- Photo : Douglas A2D-1 in flight 1954.jpeg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Douglas_A2D-1_in_flight_1954.jpeg

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
    'Douglas A2D Skyshark',
    'Douglas A2D Skyshark',
    'Douglas A2D Skyshark',
    'Douglas A2D Skyshark',
    'Un Skyraider à turbopropulseur de 5 100 ch et hélices contrarotatives, terrassé par son moteur',
    'A Skyraider with a 5,100 hp turboprop and contra-rotating propellers, undone by its engine',
    '/assets/airplanes/a2d-skyshark.jpg',
    E'## Genèse\nLe 25 juin 1945, le Bureau of Aeronautics de l''US Navy demande à Douglas un avion d''attaque propulsé par turbopropulseur. Trois projets successifs, à moteurs General Electric ou Westinghouse, échouent sur les difficultés de mise au point de leurs moteurs, mais la Marine s''obstine : le turbopropulseur promet d''échapper à la consommation effrénée des premiers réacteurs. Le 11 juin 1947, Douglas reçoit une lettre d''intention pour un avion embarqué à turbopropulseur. Il doit opérer depuis les petits porte-avions d''escorte de la classe **Casablanca**, ce qui impose le turbopropulseur plutôt que le réacteur.\n\n## Conception\nVu de l''extérieur, le Skyshark ressemble beaucoup au **Skyraider**, mais il en diffère sur bien des points. Son turbopropulseur **Allison XT40**, de 5 100 ch, offre plus du double de la puissance du Wright R-3350 de son aîné ; pour en exploiter toute la puissance, il entraîne deux **hélices contrarotatives** à six pales au total. L''épaisseur relative de l''aile à l''emplanture passe de 17 à 12 %, tandis que la dérive gagne en hauteur et en surface. L''armement prévu comprend quatre canons de 20 mm et treize points d''emport pour 2,5 t de charge.\n\n## Essais\nRetardé par le moteur, le premier vol n''a lieu que le 26 mai 1950 à Edwards, avec **George Jansen** aux commandes. Le 19 décembre 1950, lors de son quinzième vol, le premier prototype s''écrase à l''atterrissage et tue le commandant **Hugh Wood** : l''une des deux sections du moteur couplé était tombée en panne sans se désaccoupler, absorbant la puissance de l''autre, et les hélices ne s''étaient pas mises en drapeau. Le second prototype, doté d''un découpleur automatique, ne vole que seize mois plus tard. En 1953, sur un moteur de série, la boîte de réduction casse en sortie de piqué et arrache les hélices ; le pilote C. G. Livingston parvient à se poser.\n\n## Place dans l''histoire\nÀ l''été 1954, le Douglas **A4D**, à réaction, est prêt à voler, et les porte-avions d''escorte sont mis en réserve : le Skyshark a perdu sa raison d''être. Douze exemplaires ont été construits, deux prototypes et dix de présérie, presque tous ferraillés ou détruits dans des accidents ; un seul subsiste, au San Diego Air & Space Museum. Avec lui s''éteint le pari de l''US Navy sur un avion d''attaque embarqué à turbopropulseur, censé allier la puissance d''un réacteur à la sobriété d''une hélice.',
    E'## Genesis\nOn 25 June 1945 the US Navy''s Bureau of Aeronautics asked Douglas for a turboprop-powered attack aircraft. Three successive designs, with General Electric or Westinghouse engines, foundered on engine development problems, but the Navy persisted: the turboprop promised to escape the heavy fuel consumption of early jets. On 11 June 1947 Douglas received a letter of intent for a carrier-based turboprop aircraft. It was to operate from the small **Casablanca**-class escort carriers, which dictated a turboprop rather than jet power.\n\n## Design\nFrom the outside the Skyshark looked much like the **Skyraider**, but it differed in many ways. Its 5,100 hp **Allison XT40** turboprop delivered more than twice the power of its forebear''s Wright R-3350; to harness all of it, it drove **contra-rotating propellers** with six blades in total. Wing root thickness fell from 17 to 12 per cent, while the fin grew in height and area. Planned armament comprised four 20 mm cannon and thirteen hardpoints for 2.5 tonnes of stores.\n\n## Testing\nHeld back by its engine, the first flight did not take place until 26 May 1950 at Edwards, with **George Jansen** at the controls. On 19 December 1950, on its fifteenth flight, the first prototype crashed on landing, killing Commander **Hugh Wood**: one power section of the coupled engine had failed without declutching, absorbing the power of the other, and the propellers had not feathered. The second prototype, fitted with an automatic decoupler, flew only sixteen months later. In 1953, with a production engine, the gearbox failed as an aircraft pulled out of a dive and the propellers came off; pilot C. G. Livingston managed to land.\n\n## Place in history\nBy summer 1954 the jet-powered Douglas **A4D** was ready to fly, and the escort carriers were being mothballed: the Skyshark had lost its purpose. Twelve were built, two prototypes and ten pre-production aircraft, almost all scrapped or destroyed in accidents; a single example survives at the San Diego Air & Space Museum. With it ended the US Navy''s bet on a turboprop carrier attack aircraft, meant to combine jet-like power with the frugality of a propeller.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-06-25',
    '1950-05-26',
    NULL,
    792,
    3500,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas A2D Skyshark'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Douglas A2D Skyshark'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas A2D Skyshark'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Douglas A2D Skyshark'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Douglas A2D Skyshark'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.55,
  wingspan          = 15.24,
  height            = 5.21,
  wing_area         = 37,
  empty_weight      = 5871,
  mtow              = 10417,
  service_ceiling   = 14700,
  climb_rate        = 40.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison XT40-A-2 (5 100 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur à hélices contrarotatives',
  engine_type_en    = 'Contra-rotating turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 12,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **D-557A / B / C** : premiers projets de 1945-1947 à moteurs General Electric TG-100 ou Westinghouse 25D, abandonnés\n- **XA2D-1** : deux prototypes, le premier détruit le 19 décembre 1950\n- **A2D-1** : dix avions de présérie, dont quatre n''ont jamais volé\n- **Allison XT40** : turbopropulseur couplé entraînant des hélices contrarotatives, cause principale de l''échec',
  variants_en       = E'- **D-557A / B / C**: early 1945-1947 designs with General Electric TG-100 or Westinghouse 25D engines, abandoned\n- **XA2D-1**: two prototypes, the first destroyed on 19 December 1950\n- **A2D-1**: ten pre-production aircraft, four of which never flew\n- **Allison XT40**: coupled turboprop driving contra-rotating propellers, the main cause of failure',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_A2D_Skyshark',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_A2D_Skyshark',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Douglas A2D Skyshark';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas A2D Skyshark';
