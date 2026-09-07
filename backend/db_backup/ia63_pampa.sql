-- FMA IA 63 Pampa
--
-- Photo : FMA IA 63 Pampa 1991.jpg
--   licence Public domain — JO2 Pete Hatzakos
--   https://commons.wikimedia.org/wiki/File%3AFMA_IA_63_Pampa_1991.jpg

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
    'FMA IA 63 Pampa',
    'FMA IA 63 Pampa',
    'FMA IA 63 Pampa',
    'FMA IA 63 Pampa',
    'Dessiné avec Dornier, produit quarante ans par intermittence',
    'Drawn with Dornier, built in fits and starts for forty years',
    '/assets/airplanes/ia63-pampa.jpg',
    E'## Genèse\nL''Argentine possède depuis 1927 une usine aéronautique d''État, la **FMA** de Córdoba, qui a produit le premier avion à réaction d''Amérique latine en 1947. À la fin des années 1970 il lui faut remplacer ses **MS.760 Paris** français. Faute d''expérience récente, la FMA s''associe à l''allemand **Dornier**, qui sort de l''Alpha Jet.\n\n## Conception\nL''aile est dessinée en Allemagne, avec une flèche légère et un profil supercritique ; la cellule est argentine. Un seul réacteur **TFE731**, deux places en tandem, et un facteur de charge de sept g. La ressemblance avec l''Alpha Jet est nette, en plus petit et à un moteur — donc moins cher à l''heure de vol, ce qui est le seul argument qui compte pour une école.\n\n## Carrière opérationnelle\nUne quarantaine d''exemplaires en quarante ans, chiffre qui dit tout : la production s''arrête en 1993 faute d''argent, reprend en 2006, s''arrête encore, reprend en 2013. La force aérienne argentine l''utilise pour la formation avancée et, faute de chasseurs modernes, l''a un temps envisagé comme intercepteur de circonstance.\n\n## Place dans l''histoire\nQuarante exemplaires. Le Pampa illustre le rapport entre industrie aéronautique et stabilité économique : la conception est bonne, l''appareil vole bien, et rien de tout cela ne suffit quand le financement s''interrompt tous les dix ans. L''Argentine du catalogue conserve aussi le **FMA IA 58 Pucará**, seul appareil argentin engagé au combat.',
    E'## Genesis\nArgentina has had a state aircraft factory since 1927, the **FMA** at Córdoba, which built Latin America''s first jet aircraft in 1947. By the late 1970s it needed to replace its French **MS.760 Paris**. Lacking recent experience, FMA partnered with Germany''s **Dornier**, fresh from the Alpha Jet.\n\n## Design\nThe wing was drawn in Germany, lightly swept with a supercritical section; the airframe is Argentine. A single **TFE731** engine, two seats in tandem, and a seven-g load factor. The resemblance to the Alpha Jet is clear, in a smaller single-engined form — therefore cheaper per flight hour, the only argument that counts for a trainer.\n\n## Operational career\nSome forty aircraft in forty years, a figure that says everything: production stopped in 1993 for lack of money, restarted in 2006, stopped again, restarted in 2013. The Argentine air force uses it for advanced training and, lacking modern fighters, has at times considered it as a makeshift interceptor.\n\n## Place in history\nForty built. The Pampa illustrates the relationship between an aircraft industry and economic stability: the design is sound, the aircraft flies well, and none of that is enough when funding stops every ten years. Argentina in this catalogue also holds the **FMA IA 58 Pucará**, the only Argentine aircraft committed to combat.',
    (SELECT id FROM countries WHERE code = 'ARG'),
    '1979-01-01',
    '1984-10-06',
    '1988-04-01',
    819.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'FMA'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 63 Pampa'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 63 Pampa'), (SELECT id FROM armement WHERE name = 'DEFA 553'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 63 Pampa'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'FMA IA 63 Pampa'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.93,
  wingspan          = 9.69,
  height            = 4.29,
  wing_area         = 15.63,
  empty_weight      = 2821,
  mtow              = 5000,
  service_ceiling   = 12900,
  climb_rate        = 32.5,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell TFE731-40-2N',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 19.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1984,
  production_end    = NULL,
  units_built       = 40,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **IA 63 Pampa** : version d''origine, dix-huit exemplaires livrés à partir de 1988\n- **Pampa II** : avionique modernisée, relance de production en 2006\n- **Pampa III** : cockpit tout-écran et moteur plus puissant, depuis 2013\n- Aile dessinée par **Dornier**, qui venait de faire l''**Alpha Jet** avec Dassault\n- Production interrompue **deux fois** par les crises économiques argentines',
  variants_en       = E'- **IA 63 Pampa** : original version, eighteen delivered from 1988\n- **Pampa II** : upgraded avionics, production restarted in 2006\n- **Pampa III** : glass cockpit and more powerful engine, since 2013\n- Wing designed by **Dornier**, fresh from the **Alpha Jet** with Dassault\n- Production halted **twice** by Argentine economic crises',

  -- Strate 4 : qualitatif
  nickname          = 'Pampa',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/FMA_IA_63_Pampa',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/FMA_IA_63_Pampa',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'JO2 Pete Hatzakos',
  image_licence     = 'Public domain'
WHERE name = 'FMA IA 63 Pampa';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FMA IA 63 Pampa';
