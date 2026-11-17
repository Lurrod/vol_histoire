-- Avro Type 694 Lincoln
--
-- Photo : AvroLincolnA73-20.jpg
--   licence Public domain — JohnnyOneSpeed
--   https://commons.wikimedia.org/wiki/File:AvroLincolnA73-20.jpg

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
    'Avro Lincoln',
    'Avro Lincoln',
    'Avro Type 694 Lincoln',
    'Avro Type 694 Lincoln',
    'Héritier du Lancaster arrivé trop tard pour la guerre, dernier bombardier à pistons de la RAF',
    'The Lancaster''s heir that came too late for the war, the RAF''s last piston-engined bomber',
    '/assets/airplanes/avro-lincoln.jpg',
    E'## Genèse\nLa spécification B.14/43 réclame un bombardier lourd à pistons pour succéder aux Stirling, Halifax et **Lancaster**. **Roy Chadwick** y répond par un Lancaster profondément remanié, d''abord baptisé Lancaster IV et V, puis Lincoln I et II. Assemblé à l''aéroport de Ringway, à Manchester, le prototype vole le 9 juin 1944, et le premier exemplaire de série sort en février 1945. Le Lincoln est destiné à la **Tiger Force**, la force de bombardement du Commonwealth prévue contre le Japon, mais la guerre s''achève avant son engagement ; il est déclaré opérationnel en août 1945.\n\n## Conception\nL''aile, plus longue, gagne en allongement (10,30 contre 8,02 pour le Lancaster), et les **Rolls-Royce Merlin 85** à compresseur à deux étages sont montés en groupes moteurs interchangeables. Le fuselage agrandi emporte plus de carburant et jusqu''à 6,4 t de bombes, voire une bombe Grand Slam de 10 t. La défense repose sur des tourelles de nez et de queue à mitrailleuses de 12,7 mm et une tourelle dorsale à canons de 20 mm. Le Lincoln est construit par Avro, Armstrong Whitworth et Metropolitan-Vickers ; l''Australie en produit 73 sous le nom de Mk 30, le plus gros avion jamais construit dans le pays.\n\n## Carrière opérationnelle\nPrès de 600 Lincoln équipent 29 escadrons de la RAF. Pendant l''**insurrection malaise**, les Lincoln britanniques et australiens, basés à Tengah et Changi, effectuent plus de 3 000 sorties en sept ans et demi et larguent 85 % du tonnage de bombes de la campagne ; d''autres combattent la révolte des Mau Mau au Kenya. Le 12 mars 1953, en pleine **guerre froide**, un Lincoln de la Central Gunnery School en route vers Berlin est abattu par des MiG-15 près de Lunebourg : ses sept hommes périssent. L''Argentine, qui en reçoit 30, dispose alors de la force de bombardement la plus puissante d''Amérique du Sud.\n\n## Place dans l''histoire\nDernier bombardier à moteurs à pistons de la RAF, le Lincoln cède la place aux bombardiers V à partir de 1955 ; les derniers, affectés au Signals Command, sont retirés le 12 mars 1963. L''Australie s''en sépare en 1961, l''Argentine en 1967. Construit à 604 exemplaires, il a aussi servi de banc d''essais à toute une génération de turbopropulseurs et de réacteurs britanniques, et donné naissance au **Shackleton**, patrouilleur maritime d''abord désigné Lincoln ASR.3.',
    E'## Genesis\nSpecification B.14/43 called for a piston-engined heavy bomber to succeed the Stirling, Halifax and **Lancaster**. **Roy Chadwick** answered with a thoroughly reworked Lancaster, first known as the Lancaster IV and V, then as the Lincoln I and II. Assembled at Ringway Airport, Manchester, the prototype flew on 9 June 1944, and the first production aircraft was completed in February 1945. The Lincoln was earmarked for **Tiger Force**, the Commonwealth bomber force planned against Japan, but the war ended before it could take part; it became operational in August 1945.\n\n## Design\nThe longer wing had a higher aspect ratio (10.30 against 8.02 for the Lancaster), and the two-stage supercharged **Rolls-Royce Merlin 85** engines were fitted as interchangeable power plants. The enlarged fuselage held more fuel and up to 6.4 tonnes of bombs, or even a 10-tonne Grand Slam. Defence relied on nose and tail turrets with 12.7 mm machine guns and a dorsal turret with 20 mm cannon. The Lincoln was built by Avro, Armstrong Whitworth and Metropolitan-Vickers; Australia produced 73 as the Mk 30, the largest aircraft ever built in the country.\n\n## Operational career\nNearly 600 Lincolns equipped 29 RAF squadrons. During the **Malayan Emergency**, British and Australian Lincolns based at Tengah and Changi flew more than 3,000 sorties over seven and a half years and dropped 85 per cent of the campaign''s bomb tonnage; others fought the Mau Mau uprising in Kenya. On 12 March 1953, at the height of the **Cold War**, a Central Gunnery School Lincoln flying to Berlin was shot down by MiG-15s near Lüneburg, killing all seven crew. Argentina, which received 30, gained the most powerful bomber force in South America.\n\n## Place in history\nThe RAF''s last piston-engined bomber, the Lincoln gave way to the V-bombers from 1955; the last, serving with Signals Command, were retired on 12 March 1963. Australia withdrew its own in 1961 and Argentina in 1967. Built in 604 examples, it also served as a testbed for a whole generation of British turboprops and jet engines, and gave rise to the **Shackleton**, the maritime patrol aircraft first designated Lincoln ASR.3.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1943-01-01',
    '1944-06-09',
    '1945-08-01',
    500,
    7160,
    (SELECT id FROM manufacturer WHERE code = 'AVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Lincoln'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Avro Lincoln'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Lincoln'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Avro Lincoln'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Lincoln'), (SELECT id FROM wars WHERE name = 'Insurrection malaise')),
((SELECT id FROM airplanes WHERE name = 'Avro Lincoln'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.86,
  wingspan          = 36.58,
  height            = 5.27,
  wing_area         = 132.0,
  empty_weight      = 20043,
  mtow              = 37195,
  service_ceiling   = 9300,
  climb_rate        = 4.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 7,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Merlin 85 (1 750 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = NULL,
  units_built       = 604,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Lincoln B.1** : version de bombardement à long rayon d''action de la RAF, moteurs Merlin 85\n- **Lincoln B.2** : moteurs Merlin 66, 68A ou 300, construit par Avro, Armstrong Whitworth et Metropolitan-Vickers\n- **Lincoln Mk 30** : version australienne, 73 exemplaires, le plus gros avion jamais construit en Australie\n- **Lincoln GR.31 / MR.31** : version australienne de lutte anti-sous-marine, nez allongé de 1,98 m et soute à torpilles\n- **Lincoln ASR.3** : projet de patrouille maritime devenu l''Avro Shackleton\n- **Avro 695 Lincolnian** : dérivé de transport, dont un appareil argentin de soutien en Antarctique',
  variants_en       = E'- **Lincoln B.1**: long-range bomber version for the RAF, Merlin 85 engines\n- **Lincoln B.2**: Merlin 66, 68A or 300 engines, built by Avro, Armstrong Whitworth and Metropolitan-Vickers\n- **Lincoln Mk 30**: Australian version, 73 built, the largest aircraft ever built in Australia\n- **Lincoln GR.31 / MR.31**: Australian anti-submarine version with a nose lengthened by 1.98 m and a torpedo bay\n- **Lincoln ASR.3**: maritime patrol project that became the Avro Shackleton\n- **Avro 695 Lincolnian**: transport derivative, including one Argentine aircraft used for Antarctic support',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_Lincoln',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_Lincoln',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'JohnnyOneSpeed',
  image_licence     = 'Public domain'
WHERE name = 'Avro Lincoln';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro Lincoln';
