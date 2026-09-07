-- ENAER T-35 Pillán
--
-- Photo : Enaer Pillan CC-PZD, Paris Air Show 1993.jpg
--   licence CC BY 2.0 — Dick Gilbert
--   https://commons.wikimedia.org/wiki/File%3AEnaer_Pillan_CC-PZD%2C_Paris_Air_Show_1993.jpg

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
    'ENAER T-35 Pillán',
    'ENAER T-35 Pillán',
    'ENAER T-35 Pillán',
    'ENAER T-35 Pillán',
    'L’avion qui a donné au Chili une industrie aéronautique',
    'The aircraft that gave Chile an aircraft industry',
    '/assets/airplanes/enaer-pillan.jpg',
    E'## Genèse\nLe Chili des années 1970 est sous embargo : les États-Unis suspendent leurs livraisons d''armement après le coup d''État de 1973. Le pays découvre brutalement ce que signifie dépendre entièrement d''un fournisseur, et décide de construire au moins ses avions-écoles. **ENAER** est créée pour cela.\n\n## Conception\nFaute d''expérience, le Chili achète du savoir-faire : le bureau d''études américain **Piper** dessine l''appareil à partir de son PA-28 Dakota, en tandem au lieu de côte à côte, avec une aile renforcée à six g et une verrière coulissante. Les deux premiers prototypes sont construits aux États-Unis ; les suivants sortent de Santiago. C''est un transfert de technologie autant qu''un avion.\n\n## Carrière opérationnelle\nEnviron cent cinquante exemplaires. Il forme les pilotes chiliens depuis 1985 et il est exporté vers le **Panama**, le **Paraguay**, l''**Équateur** et la **République dominicaine**. L''Espagne l''assemble sous licence sous le nom d''**E.26 Tamiz** pour sa propre académie de l''air, quatre-vingt-dix exemplaires.\n\n## Place dans l''histoire\nCent cinquante exemplaires. Le Pillán n''a rien inventé, et c''est précisément ce qui en fait un succès : le Chili n''a pas cherché à concevoir un appareil original mais à **acquérir une compétence**. ENAER modernisera ensuite ses Mirage sous le nom de **Pantera** et participera au programme brésilien AMX.',
    E'## Genesis\nChile in the 1970s was under embargo: the United States suspended arms deliveries after the 1973 coup. The country discovered abruptly what it means to depend entirely on one supplier, and decided to build at least its own trainers. **ENAER** was created for that.\n\n## Design\nLacking experience, Chile bought know-how: the American **Piper** design office drew the aircraft from its PA-28 Dakota, in tandem rather than side by side, with a wing stressed to six g and a sliding canopy. The first two prototypes were built in the United States; the rest came out of Santiago. It is a technology transfer as much as an aircraft.\n\n## Operational career\nSome one hundred and fifty built. It has trained Chilean pilots since 1985 and has been exported to **Panama**, **Paraguay**, **Ecuador** and the **Dominican Republic**. Spain assembles it under licence as the **E.26 Tamiz** for its own air academy, ninety aircraft.\n\n## Place in history\nOne hundred and fifty built. The Pillán invented nothing, and that is precisely why it succeeded: Chile did not set out to design an original aircraft but to **acquire a capability**. ENAER would go on to upgrade its Mirages as the **Pantera** and to take part in the Brazilian AMX programme.',
    (SELECT id FROM countries WHERE code = 'CHL'),
    '1980-01-01',
    '1981-03-06',
    '1985-01-01',
    311.0,
    1360.0,
    (SELECT id FROM manufacturer WHERE code = 'ENA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'ENAER T-35 Pillán'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'ENAER T-35 Pillán'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.0,
  wingspan          = 8.84,
  height            = 2.64,
  wing_area         = 13.69,
  empty_weight      = 930,
  mtow              = 1315,
  service_ceiling   = 5800,
  climb_rate        = 7.4,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 450,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming IO-540-K1K5',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1982,
  production_end    = NULL,
  units_built       = 150,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **T-35A / B** : versions d''entraînement élémentaire et de navigation\n- **T-35DT Turbo Pillán** : remotorisation en **turbopropulseur**, resté marginal\n- Dérivé du **Piper PA-28 Dakota** américain, dont il reprend des sous-ensembles\n- Assemblé sous licence en **Espagne** par CASA sous le nom de **E.26 Tamiz**\n- *Pillán* désigne un esprit de la mythologie **mapuche**',
  variants_en       = E'- **T-35A / B** : elementary training and navigation versions\n- **T-35DT Turbo Pillán** : **turboprop** conversion, which stayed marginal\n- Derived from the American **Piper PA-28 Dakota**, reusing some of its assemblies\n- Licence-assembled in **Spain** by CASA as the **E.26 Tamiz**\n- *Pillán* is a spirit of **Mapuche** mythology',

  -- Strate 4 : qualitatif
  nickname          = 'Pillán',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/ENAER_T-35_Pill%C3%A1n',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/ENAER_T-35_Pill%C3%A1n',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Dick Gilbert',
  image_licence     = 'CC BY 2.0'
WHERE name = 'ENAER T-35 Pillán';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'ENAER T-35 Pillán';
