-- Lockheed S-3 Viking
--
-- Photo : S-3A (cropped).jpg
--   licence Public domain — US Navy
--   https://commons.wikimedia.org/wiki/File%3AS-3A_%28cropped%29.jpg

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
    'S-3 Viking',
    'S-3 Viking',
    'Lockheed S-3 Viking',
    'Lockheed S-3 Viking',
    'Chasseur de sous-marins embarqué, à réaction et repliable',
    'Carrier-borne submarine hunter, jet-powered and foldable',
    '/assets/airplanes/s3-viking.jpg',
    E'## Genèse\nLes sous-marins nucléaires soviétiques deviennent, à la fin des années 1960, plus rapides et plus silencieux que le S-2 Tracker à hélices ne peut les suivre. L''US Navy veut un successeur à réaction, capable de rejoindre vite une zone de recherche puis d''y patrouiller lentement des heures — deux exigences contradictoires. Lockheed les concilie avec des turbofans à fort taux de dilution, économiques à basse vitesse.\n\n## Conception\nTout doit tenir sur un pont : la voilure et la dérive se replient, ramenant l''appareil à des dimensions d''ascenseur. Quatre hommes se partagent la détection ; un détecteur d''anomalies magnétiques sort de la queue en vol, soixante bouées acoustiques sont larguées par des tubes ventraux. Le sifflement très particulier des TF34 vaut à l''appareil son surnom de **Hoover**, du nom de l''aspirateur.\n\n## Carrière opérationnelle\nIl traque les sous-marins soviétiques pendant quinze ans, puis se réinvente après 1991 : la menace ayant disparu, on lui retire les capteurs anti-sous-marins et on en fait un **ravitailleur** de flotte et un tireur de Harpoon. Il sert au Golfe, en Yougoslavie et en Irak, et se retire en 2009.\n\n## Place dans l''histoire\nCent quatre-vingt-huit exemplaires. Il est le dernier appareil de lutte anti-sous-marine à voler depuis un porte-avions américain : depuis son retrait, la mission est entièrement confiée aux hélicoptères et aux **P-8 Poseidon** basés à terre. Le porte-avions a perdu, avec lui, sa capacité propre à chasser sous la surface.',
    E'## Genesis\nBy the late 1960s Soviet nuclear submarines had become faster and quieter than the propeller-driven S-2 Tracker could follow. The US Navy wanted a jet successor, able to reach a search area quickly and then loiter there slowly for hours — two contradictory requirements. Lockheed reconciled them with high-bypass turbofans, economical at low speed.\n\n## Design\nEverything had to fit on a deck: the wings and fin fold, bringing the aircraft down to lift dimensions. Four men share the detection work; a magnetic anomaly detector extends from the tail in flight, and sixty sonobuoys are dropped through belly tubes. The very distinctive whine of the TF34s earned the aircraft its nickname, **Hoover**, after the vacuum cleaner.\n\n## Operational career\nIt hunted Soviet submarines for fifteen years, then reinvented itself after 1991: with the threat gone, the anti-submarine sensors were removed and it became a fleet **tanker** and Harpoon shooter. It served in the Gulf, over Yugoslavia and in Iraq, and retired in 2009.\n\n## Place in history\nOne hundred and eighty-eight built. It is the last anti-submarine aircraft to fly from an American carrier: since its retirement the mission has passed entirely to helicopters and shore-based **P-8 Poseidons**. With it, the carrier lost its own ability to hunt beneath the surface.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1969-01-01',
    '1972-01-21',
    '1974-02-20',
    828.0,
    5600.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM armement WHERE name = 'Mk 46')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'S-3 Viking'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.26,
  wingspan          = 20.93,
  height            = 6.93,
  wing_area         = 55.55,
  empty_weight      = 12088,
  mtow              = 23831,
  service_ceiling   = 12465,
  climb_rate        = 21.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1900,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric TF34-GE-400B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 41.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 1978,
  units_built       = 188,
  unit_cost_usd     = 27000000,
  unit_cost_year    = 1974,
  operators_count   = 2,
  variants          = E'- **S-3A** : version initiale de lutte anti-sous-marine\n- **S-3B** : électronique modernisée et emport du missile Harpoon\n- **ES-3A Shadow** : renseignement électronique, seize exemplaires\n- **US-3A** : version de liaison et de transport rapide vers le porte-avions\n- La **Corée du Sud** en a acquis d''anciens exemplaires en 2023 pour la surveillance maritime',
  variants_en       = E'- **S-3A** : initial anti-submarine warfare version\n- **S-3B** : upgraded electronics and Harpoon missile capability\n- **ES-3A Shadow** : signals intelligence, sixteen built\n- **US-3A** : liaison and fast carrier delivery version\n- **South Korea** acquired former aircraft in 2023 for maritime surveillance',

  -- Strate 4 : qualitatif
  nickname          = 'Hoover',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_S-3_Viking',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_S-3_Viking',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'US Navy',
  image_licence     = 'Public domain'
WHERE name = 'S-3 Viking';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'S-3 Viking';
