-- Nord 2501 Noratlas
--
-- Photo : Nord Noratlas (50071743762).jpg
--   licence CC BY 2.0 — Thomas Vogt from Paderborn, Deutschland
--   https://commons.wikimedia.org/wiki/File%3ANord_Noratlas_%2850071743762%29.jpg

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
    'Nord Noratlas',
    'Nord Noratlas',
    'Nord 2501 Noratlas',
    'Nord 2501 Noratlas',
    'Le transport de toutes les guerres françaises d’après-guerre',
    'The transport of every French war after 1945',
    '/assets/airplanes/noratlas.jpg',
    E'## Genèse\nL''armée de l''air française sort de la guerre avec des Ju 52 allemands récupérés et des C-47 américains prêtés. Il lui faut un transport national, et vite. Nord Aviation reprend la formule que Fairchild vient d''imposer avec le **C-119** — soute droite entre deux poutres, ouverture arrière — et l''adapte aux moyens français : moteurs Bristol construits sous licence, structure simple, entretien rustique.\n\n## Conception\nDeux poutres de queue laissant l''arrière entièrement dégagé, plancher bas, portes de soute s''ouvrant en vol. La cabine accueille quarante-cinq parachutistes ou dix-huit brancards. La silhouette grise et anguleuse lui vaut son surnom d''usage dans les régiments : **la Grise**. L''appareil est lent, bruyant, non pressurisé — et capable de se poser à peu près partout.\n\n## Carrière opérationnelle\nIl est de toutes les opérations françaises pendant trente ans. Il largue les parachutistes à **Suez** en 1956, transporte la guerre d''**Algérie** de bout en bout, dessert le Sahara et l''Afrique équatoriale, évacue les ressortissants du Tchad et du Zaïre. L''Allemagne fédérale en construit cent quatre-vingt-six sous licence — première coopération industrielle entre les deux pays, avant même le Transall.\n\n## Place dans l''histoire\nQuatre cent vingt-cinq exemplaires, neuf forces aériennes. Son successeur, le **Transall C-160**, naît directement de son remplacement, et du constat que la France et l''Allemagne pouvaient construire ensemble — constat que le Noratlas avait déjà établi à petite échelle. Les derniers quittent le service français en 1989.',
    E'## Genesis\nThe French air force came out of the war with captured German Ju 52s and borrowed American C-47s. It needed a national transport, quickly. Nord Aviation took up the formula Fairchild had just established with the **C-119** — a straight hold between two booms, opening at the rear — and adapted it to French means: licence-built Bristol engines, simple structure, rough maintenance.\n\n## Design\nTwo tail booms leaving the rear entirely clear, a low floor, and hold doors that open in flight. The cabin takes forty-five paratroops or eighteen stretchers. Its grey, angular silhouette earned it the nickname used throughout the regiments: **la Grise**, the grey one. The aircraft is slow, noisy, unpressurised — and able to land almost anywhere.\n\n## Operational career\nIt took part in every French operation for thirty years. It dropped paratroops at **Suez** in 1956, carried the **Algerian** war from beginning to end, served the Sahara and equatorial Africa, and evacuated nationals from Chad and Zaire. West Germany built one hundred and eighty-six under licence — the first industrial collaboration between the two countries, before even the Transall.\n\n## Place in history\nFour hundred and twenty-five built, nine air forces. Its successor, the **Transall C-160**, was born directly of its replacement, and of the finding that France and Germany could build together — a finding the Noratlas had already established on a smaller scale. The last left French service in 1989.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1947-01-01',
    '1949-09-10',
    '1953-01-01',
    440.0,
    2500.0,
    (SELECT id FROM manufacturer WHERE code = 'NRD'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord Noratlas'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord Noratlas'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Nord Noratlas'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Nord Noratlas'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord Noratlas'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.96,
  wingspan          = 32.5,
  height            = 6.0,
  wing_area         = 101.2,
  empty_weight      = 13075,
  mtow              = 22000,
  service_ceiling   = 7000,
  climb_rate        = 6.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Bristol Hercules 758',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1952,
  production_end    = 1961,
  units_built       = 425,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 9,
  variants          = E'- **Nord 2501** : version de série française, la plus nombreuse\n- **Nord 2501D** : construite sous licence en **Allemagne**, 186 exemplaires\n- **Nord 2508** : version à deux réacteurs d''appoint en bout d''aile\n- **Nord 2501 Gabriel** : renseignement électronique, ancêtre du Transall Gabriel\n- Exploité par la **Grèce**, Israël, le Portugal, le Niger et l''Allemagne fédérale',
  variants_en       = E'- **Nord 2501** : the main French production version\n- **Nord 2501D** : licence-built in **Germany**, 186 aircraft\n- **Nord 2508** : version with two auxiliary jets at the wingtips\n- **Nord 2501 Gabriel** : signals intelligence, ancestor of the Transall Gabriel\n- Operated by **Greece**, Israel, Portugal, Niger and West Germany',

  -- Strate 4 : qualitatif
  nickname          = 'La Grise',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Nord_2501_Noratlas',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Nord_Noratlas',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Thomas Vogt from Paderborn, Deutschland',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Nord Noratlas';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Nord Noratlas';
