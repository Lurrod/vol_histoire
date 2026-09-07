-- Beechcraft T-34 Mentor
--
-- Photo : T-34C-2.jpg
--   licence Public domain — DON S. MONTGOMERY, USN (RET.)
--   https://commons.wikimedia.org/wiki/File%3AT-34C-2.jpg

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
    'T-34 Mentor',
    'T-34 Mentor',
    'Beechcraft T-34 Mentor',
    'Beechcraft T-34 Mentor',
    'Un avion d’affaires transformé en école, produit pendant quarante ans',
    'A business aircraft turned trainer, built for forty years',
    '/assets/airplanes/t34-mentor.jpg',
    E'## Genèse\nWalter Beech ne répond à aucun appel d''offres : il construit le Mentor **sur fonds propres** en 1948, convaincu que les militaires finiront par vouloir remplacer leurs T-6 Texan de la guerre. Il gagne du temps en partant de son avion d''affaires à succès, le **Bonanza**, dont il conserve l''aile et le fuselage arrière en remplaçant l''empennage papillon par un empennage classique.\n\n## Conception\nDeux places en tandem sous une longue verrière, train rentrant, structure métallique : c''est un avion léger civil militarisé, et c''est précisément ce qui le rend bon marché. La transformation décisive vient en 1973, quand l''US Navy fait remplacer le moteur à pistons par un **turbopropulseur PT6** — le T-34C Turbo Mentor gagne cent chevaux et une fiabilité qui lui vaudra trente ans de service supplémentaires.\n\n## Carrière opérationnelle\nEnviron deux mille trois cents exemplaires, vingt forces aériennes. Il forme les pilotes de l''US Air Force puis de l''US Navy jusqu''en 2015, et il est produit sous licence au Japon, en Argentine et au Chili. Sa version armée T-34C-1 est engagée en Amérique latine, notamment lors des conflits internes péruviens.\n\n## Place dans l''histoire\nDeux mille trois cents exemplaires sur trente-sept ans de production. Le Mentor illustre une logique restée valable : partir d''une cellule civile éprouvée plutôt que de dessiner un avion-école de zéro. Le **Pilatus PC-7** et l''**Embraer Tucano** appliqueront la même recette avec le même succès.',
    E'## Genesis\nWalter Beech answered no requirement: he built the Mentor **with his own money** in 1948, convinced the services would eventually want to replace their wartime T-6 Texans. He saved time by starting from his successful business aircraft, the **Bonanza**, keeping its wing and rear fuselage while replacing the V-tail with a conventional one.\n\n## Design\nTwo seats in tandem under a long canopy, retractable gear, metal structure: it is a militarised civil light aircraft, and that is precisely what makes it cheap. The decisive change came in 1973, when the US Navy had the piston engine replaced by a **PT6 turboprop** — the T-34C Turbo Mentor gained a hundred horsepower and a reliability that would earn it thirty more years of service.\n\n## Operational career\nSome two thousand three hundred built, twenty air forces. It trained US Air Force and then US Navy pilots until 2015, and was licence-built in Japan, Argentina and Chile. Its armed T-34C-1 version was used in Latin America, notably in Peru''s internal conflicts.\n\n## Place in history\nTwo thousand three hundred built over thirty-seven years of production. The Mentor illustrates a logic still valid today: start from a proven civil airframe rather than draw a trainer from scratch. The **Pilatus PC-7** and the **Embraer Tucano** would apply the same recipe with the same success.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1948-01-01',
    '1948-12-02',
    '1953-06-01',
    518.0,
    1310.0,
    (SELECT id FROM manufacturer WHERE code = 'BEE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-34 Mentor'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'T-34 Mentor'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-34 Mentor'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'T-34 Mentor'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'T-34 Mentor'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.75,
  wingspan          = 10.16,
  height            = 2.92,
  wing_area         = 16.7,
  empty_weight      = 1342,
  mtow              = 1950,
  service_ceiling   = 9145,
  climb_rate        = 7.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-25',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1990,
  units_built       = 2300,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **T-34A / B** : versions à moteur à pistons, USAF et US Navy\n- **T-34C Turbo Mentor** : remotorisé en **turbopropulseur** PT6, la version définitive\n- **T-34C-1** : version armée, exportée vers l''Amérique latine et l''Asie du Sud-Est\n- Dérivé du **Beechcraft Bonanza** civil, dont il reprend l''aile et le fuselage arrière\n- Construit sous licence au **Japon**, en **Argentine** et au **Chili**',
  variants_en       = E'- **T-34A / B** : piston-engined versions, USAF and US Navy\n- **T-34C Turbo Mentor** : re-engined with a PT6 **turboprop**, the definitive version\n- **T-34C-1** : armed version, exported to Latin America and South-East Asia\n- Derived from the civil **Beechcraft Bonanza**, reusing its wing and rear fuselage\n- Licence-built in **Japan**, **Argentina** and **Chile**',

  -- Strate 4 : qualitatif
  nickname          = 'Mentor',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Beechcraft_T-34_Mentor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Beechcraft_T-34_Mentor',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'DON S. MONTGOMERY, USN (RET.)',
  image_licence     = 'Public domain'
WHERE name = 'T-34 Mentor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-34 Mentor';
