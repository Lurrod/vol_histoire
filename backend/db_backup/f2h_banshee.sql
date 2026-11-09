-- McDonnell F2H Banshee
--
-- Photo : F2H-3 Banshees of VF-31 in flight over the Mediterranean Sea in January 1954.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:F2H-3_Banshees_of_VF-31_in_flight_over_the_Mediterranean_Sea_in_January_1954.jpg

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
    'F2H Banshee',
    'F2H Banshee',
    'McDonnell F2H Banshee',
    'McDonnell F2H Banshee',
    'Escorteur de haute altitude en Corée, puis chasseur embarqué de la Marine royale canadienne',
    'High-altitude escort over Korea, then the Royal Canadian Navy’s carrier fighter',
    '/assets/airplanes/f2h-banshee.jpg',
    E'## Genèse\nLe 2 mars 1945, avant même que le FH-1 Phantom ait fait ses preuves, l''US Navy demande à **McDonnell** un successeur plus lourd, plus rapide et mieux armé. Le bureau d''études garde la formule qui fonctionne — deux réacteurs dans les emplantures d''une aile droite — et l''agrandit autour du **Westinghouse J34**, deux fois plus puissant que le J30. Le prototype vole le **11 janvier 1947** ; les premières flottilles sont livrées en août 1948.\n\n## Conception\nUne cellule simple et robuste, quatre canons de 20 mm dans le nez, des réservoirs en bout d''aile sur le F2H-2 qui portent l''autonomie bien au-delà de celle des premiers jets embarqués. Les versions se multiplient : le **F2H-2P** de reconnaissance photographique, le **F2H-2B** capable d''emporter une arme nucléaire, puis les **F2H-3 et F2H-4**, allongés et dotés d''un radar pour la chasse tout-temps. Le Banshee vole haut, plus haut que le F9F Panther, son contemporain de Grumman.\n\n## Carrière opérationnelle\nEn **Corée**, les Banshee entrent au combat en août 1951 depuis l''**USS Essex**. Leur plafond leur vaut d''escorter des bombardiers de l''US Air Force en profondeur au-dessus du Nord, mais c''est la version photographique qui rend le plus de services : les F2H-2P des Marines photographient objectifs et résultats de frappes jusqu''à la fin de la guerre. L''appareil n''y remporte aucune victoire aérienne. En 1955, la **Marine royale canadienne** reçoit trente-neuf F2H-3, armés de missiles **AIM-9 Sidewinder**, qui opèrent depuis le porte-avions **HMCS Bonaventure** et remplacent ses Sea Fury. Douze sont perdus en accident. Les derniers sont retirés le 12 septembre 1962, un an après les ultimes appareils de la réserve américaine.\n\n## Place dans l''histoire\nHuit cent quatre-vingt-quinze exemplaires de 1947 à 1953. Le Banshee est l''avion qui installe McDonnell comme fournisseur majeur de l''aéronavale américaine. Son successeur, le **F3H Demon**, mènera directement au **F-4 Phantom II**. Pour le Canada, il reste le seul chasseur à réaction jamais embarqué par sa marine.',
    E'## Genesis\nOn 2 March 1945, before the FH-1 Phantom had even proved itself, the US Navy asked **McDonnell** for a heavier, faster and better-armed successor. The design office kept the formula that worked — two engines in the roots of a straight wing — and enlarged it around the **Westinghouse J34**, twice as powerful as the J30. The prototype flew on **11 January 1947**; the first squadrons were equipped in August 1948.\n\n## Design\nA simple, sturdy airframe, four 20 mm cannon in the nose, and wingtip tanks on the F2H-2 that took its range well beyond that of the first carrier jets. Variants multiplied: the **F2H-2P** photo-reconnaissance model, the **F2H-2B** able to carry a nuclear weapon, then the **F2H-3 and F2H-4**, lengthened and fitted with radar for all-weather fighting. The Banshee flew high, higher than the F9F Panther, its Grumman contemporary.\n\n## Operational career\nOver **Korea** Banshees went into action in August 1951 from **USS Essex**. Their ceiling earned them the job of escorting US Air Force bombers deep over the North, but the photographic version was the most useful: Marine F2H-2Ps photographed targets and strike results until the end of the war. The type scored no air-to-air victory there. In 1955 the **Royal Canadian Navy** received thirty-nine F2H-3s, armed with **AIM-9 Sidewinder** missiles, which flew from the carrier **HMCS Bonaventure** and replaced its Sea Furies. Twelve were lost in accidents. The last were retired on 12 September 1962, a year after the last aircraft of the American reserve.\n\n## Place in history\nEight hundred and ninety-five built between 1947 and 1953. The Banshee is the aircraft that established McDonnell as a major supplier to American naval aviation. Its successor, the **F3H Demon**, would lead directly to the **F-4 Phantom II**. For Canada it remains the only jet fighter its navy ever took to sea.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-03-02',
    '1947-01-11',
    '1948-08-01',
    933.0,
    1880.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F2H Banshee'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.68,
  wingspan          = 12.73,
  height            = 4.42,
  wing_area         = 27.3,
  empty_weight      = 5980,
  mtow              = 11437,
  service_ceiling   = 14330,
  climb_rate        = 30.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J34-WE-34',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 14.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1953,
  units_built       = 895,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **F2H-1** : première série, 56 exemplaires\n- **F2H-2** : version principale, réservoirs en bout d''aile, 308 exemplaires ; **F2H-2B** à capacité nucléaire\n- **F2H-2P** : reconnaissance photographique, 89 exemplaires, très employée en Corée\n- **F2H-3 / F2H-4** : chasseurs tout-temps allongés à radar, 250 et 150 exemplaires\n- **Marine royale canadienne** : 39 F2H-3 d''occasion, armés de Sidewinder (1955-1962)',
  variants_en       = E'- **F2H-1** : first batch, 56 built\n- **F2H-2** : main version, wingtip tanks, 308 built; nuclear-capable **F2H-2B**\n- **F2H-2P** : photo reconnaissance, 89 built, widely used over Korea\n- **F2H-3 / F2H-4** : lengthened radar-equipped all-weather fighters, 250 and 150 built\n- **Royal Canadian Navy** : 39 second-hand F2H-3s, armed with Sidewinders (1955–1962)',

  -- Strate 4 : qualitatif
  nickname          = 'Banshee',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_F2H_Banshee',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_F2H_Banshee',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F2H Banshee';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F2H Banshee';
