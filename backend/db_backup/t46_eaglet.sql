-- Fairchild Republic T-46A Eaglet
--
-- Photo : Fairchild T-46-4.jpg
--   licence Public domain — U.S. Department of Defense
--   https://commons.wikimedia.org/wiki/File:Fairchild_T-46-4.jpg

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
    'Fairchild T-46',
    'Fairchild T-46',
    'Fairchild Republic T-46A Eaglet',
    'Fairchild Republic T-46A Eaglet',
    'Biplace d''entraînement à réaction choisi pour remplacer le T-37, annulé par les coupes budgétaires après trois avions',
    'Jet trainer chosen to replace the T-37, cancelled by budget cuts after three aircraft had been built',
    '/assets/airplanes/t46-eaglet.jpg',
    E'## Genèse\nEn 1981, l''US Air Force lance le programme **NGT** (Next Generation Trainer) pour remplacer son avion d''entraînement initial, le **Cessna T-37 Tweet**. Elle veut un biréacteur où élève et instructeur sont assis côte à côte, comme sur le T-37, mais avec cette fois une cabine pressurisée et des sièges éjectables : voler plus haut doit éloigner les élèves d''une aviation générale toujours plus dense. Fairchild Republic, General Dynamics, North American Rockwell et Vought reçoivent des contrats d''étude, tandis que Cessna étudie un T-37 amélioré. Le 2 juillet 1982, le projet de Fairchild Republic l''emporte : deux prototypes sont commandés avec 54 avions de série en option, sur 650 prévus d''ici 1991.\n\n## Conception\nLe T-46 est un monoplan à aile haute, à double dérive en « H » comme l''**A-10** du même constructeur, propulsé par deux turbofans **Garrett F109**. Pour valider la formule, Fairchild fait construire par Ames Industries une maquette volante à l''échelle 62 %, essayée à Mojave par **Dick Rutan** pour la société de **Burt Rutan** sous le nom de **Model 73 NGT**. Elle vole le 10 septembre 1981 et démontre que l''avion entre en vrille et en sort facilement, comme l''exige le cahier des charges. Le constructeur envisage aussi des ventes à l''export, y compris comme avion d''attaque légère.\n\n## Essais\nLe T-46 vole le 15 octobre 1985, six mois après la date prévue. Entre-temps, son coût unitaire estimé a doublé, de 1,5 million de dollars en 1982 à 3 millions en février 1985. La loi **Gramm-Rudman-Hollings** de 1985 impose des coupes dans le budget fédéral : bien que les essais ne révèlent aucun problème majeur, le secrétaire à l''Air Force **Russell Rourke** arrête les achats et ne laisse continuer qu''un développement limité. Le Congrès tente de relancer le programme, puis interdit toute dépense tant que le T-46 n''a pas été comparé au T-37 et à d''autres avions d''entraînement.\n\n## Place dans l''histoire\nLe programme est formellement annulé le 13 mars 1987. Sans autre contrat, Fairchild ferme l''usine Republic de Farmingdale, dans l''État de New York : le T-46 est le dernier avion conçu par Fairchild Republic. Les trois exemplaires construits sont conservés, au musée des essais en vol d''Edwards, au musée de l''US Air Force et au parc de stockage de Davis-Monthan, tout comme la maquette Model 73 au Cradle of Aviation Museum de New York.',
    E'## Genesis\nIn 1981 the US Air Force launched the **NGT** (Next Generation Trainer) programme to replace its primary trainer, the **Cessna T-37 Tweet**. It wanted a twin-jet with trainee and instructor seated side by side, as in the T-37, but this time with a pressurised cockpit and ejection seats: flying higher would keep students clear of ever-busier general aviation traffic. Fairchild Republic, General Dynamics, North American Rockwell and Vought received study contracts, while Cessna looked at an improved T-37. On 2 July 1982 Fairchild Republic''s design was declared the winner: two prototypes were ordered with options on 54 production aircraft, out of 650 planned by 1991.\n\n## Design\nThe T-46 was a shoulder-wing monoplane with an ''H'' twin tail like the same company''s **A-10**, powered by two **Garrett F109** turbofans. To validate the layout, Fairchild had Ames Industries build a 62% scale flying model, tested at Mojave by **Dick Rutan** for **Burt Rutan**''s company as the **Model 73 NGT**. It flew on 10 September 1981 and showed that the aircraft would enter a spin and recover from it easily, as the specification required. The manufacturer also saw export potential, including as a light attack aircraft.\n\n## Testing\nThe T-46 flew on 15 October 1985, six months later than planned. Meanwhile its predicted unit cost had doubled, from 1.5 million dollars in 1982 to 3 million in February 1985. The 1985 **Gramm–Rudman–Hollings** Act mandated cuts in federal spending: although testing revealed no major problems, Secretary of the Air Force **Russell Rourke** cancelled procurement and allowed only limited development to continue. Congress tried to revive the programme, then barred any spending until the T-46 had been evaluated against the T-37 and other trainers.\n\n## Place in history\nThe programme was formally cancelled on 13 March 1987. With no other work, Fairchild closed the Republic factory at Farmingdale, New York: the T-46 was the last aircraft designed by Fairchild Republic. All three aircraft built survive, at the Edwards flight test museum, the National Museum of the US Air Force and in storage at Davis-Monthan, as does the Model 73 at New York''s Cradle of Aviation Museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1981-01-01',
    '1985-10-15',
    NULL,
    735,
    2200,
    (SELECT id FROM manufacturer WHERE code = 'FRC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild T-46'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Fairchild T-46'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild T-46'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Fairchild T-46'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.99,
  wingspan          = 11.78,
  height            = 3.04,
  wing_area         = 14.95,
  empty_weight      = 2393,
  mtow              = 3158,
  service_ceiling   = 14200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett F109-GA-100',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 5.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 73 NGT** : démonstrateur volant à l''échelle 62 %, construit par Ames Industries et essayé par Rutan Aircraft Factory, premier vol le 10 septembre 1981\n- **T-46A** : trois exemplaires construits (84-0492, 84-0493, 85-1596), tous conservés\n- **T-46A de série** : 650 avions prévus pour l''US Air Force, annulés en 1987\n- **Version d''attaque légère** : dérivé envisagé pour l''export, jamais développé',
  variants_en       = E'- **Model 73 NGT**: 62% scale flying demonstrator, built by Ames Industries and tested by Rutan Aircraft Factory, first flight on 10 September 1981\n- **T-46A**: three aircraft built (84-0492, 84-0493, 85-1596), all preserved\n- **Production T-46A**: 650 aircraft planned for the US Air Force, cancelled in 1987\n- **Light attack version**: export derivative considered, never developed',

  -- Strate 4 : qualitatif
  nickname          = 'Eaglet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairchild_T-46',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairchild_T-46',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Department of Defense',
  image_licence     = 'Public domain'
WHERE name = 'Fairchild T-46';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fairchild T-46';
