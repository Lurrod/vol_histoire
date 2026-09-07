-- Yakovlev Yak-130 Mitten
--
-- Photo : Yakovlev Yak- 130 (modify).jpg
--   licence CC BY 4.0 — Ministry of Defence
--   https://commons.wikimedia.org/wiki/File%3AYakovlev_Yak-_130_%28modify%29.jpg

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
    'Yak-130',
    'Yak-130',
    'Yakovlev Yak-130 Mitten',
    'Yakovlev Yak-130 Mitten',
    'Jumeau russe du M-346, issu de la même coopération rompue',
    'Russian twin of the M-346, from the same broken partnership',
    '/assets/airplanes/yak130.jpg',
    E'## Genèse\nL''URSS s''effondre en pleine recherche d''un remplaçant au L-39 Albatros tchécoslovaque. Faute de budget, Yakovlev s''associe en 1993 à l''italien **Aermacchi**. La coopération dure sept ans, produit un dessin commun, puis se rompt en 2000 : chacun repart avec les plans et développe son appareil.\n\n## Conception\nAile à emplantures prolongées offrant un vol contrôlé jusqu''à **35° d''incidence** — l''appareil peut reproduire le comportement d''un chasseur lourd sans en avoir les performances. Les commandes de vol électriques sont reprogrammables : un même Yak-130 peut simuler le maniement d''un MiG-29, d''un Su-30 ou d''un appareil étranger, ce qui en fait un argument d''exportation autant qu''un avion-école.\n\n## Carrière opérationnelle\nDeux cents exemplaires environ, en Russie et à l''export : Algérie, Biélorussie, Bangladesh, Birmanie, Laos, Iran, Vietnam. La Russie a engagé des Yak-130 en **Syrie** pour des frappes légères. Plusieurs exemplaires ont été perdus à l''entraînement, et les livraisons ont souffert des sanctions sur les composants étrangers.\n\n## Place dans l''histoire\nLe Yak-130 et le **M-346 Master** sont le cas le plus net de cette encyclopédie : deux appareils issus du même dessin, développés par d''anciens partenaires devenus concurrents, et vendus aujourd''hui sur les mêmes marchés à des clients qui les opposent.',
    E'## Genesis\nThe USSR collapsed in the middle of its search for a replacement for the Czechoslovak L-39 Albatros. Short of money, Yakovlev partnered in 1993 with Italy’s **Aermacchi**. The cooperation lasted seven years, produced a joint design, then broke up in 2000: each side left with the drawings and developed its own aircraft.\n\n## Design\nA wing with extended root leading edges giving controlled flight to **35° angle of attack** — the aircraft can reproduce a heavy fighter’s behaviour without its performance. The fly-by-wire controls are reprogrammable: one Yak-130 can simulate the handling of a MiG-29, a Su-30 or a foreign type, which makes it an export argument as much as a school aircraft.\n\n## Operational career\nAround two hundred built, in Russia and for export: Algeria, Belarus, Bangladesh, Myanmar, Laos, Iran, Vietnam. Russia has used Yak-130s in **Syria** for light strikes. Several have been lost in training, and deliveries have suffered from sanctions on foreign components.\n\n## Place in history\nThe Yak-130 and the **M-346 Master** are the clearest case in this encyclopedia: two aircraft from the same drawing, developed by former partners turned competitors, and sold today in the same markets to customers who set them against each other.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1991-01-01',
    '1996-04-25',
    '2010-02-01',
    1060.0,
    2000.0,
    (SELECT id FROM manufacturer WHERE code = 'YAK'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM tech WHERE name = 'Système de gestion de mission avancé')),
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM armement WHERE name = 'R-73')),
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM armement WHERE name = 'FAB-250')),
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM armement WHERE name = 'S-8'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Yak-130'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.49,
  wingspan          = 9.72,
  height            = 4.76,
  wing_area         = 23.52,
  empty_weight      = 4600,
  mtow              = 9000,
  service_ceiling   = 12500,
  climb_rate        = 65,
  g_limit_pos       = 8.0,
  g_limit_neg       = -3.0,
  combat_radius     = 900,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko-Progress AI-222-25',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 24.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2008,
  production_end    = NULL,
  units_built       = 200,
  unit_cost_usd     = 15000000,
  unit_cost_year    = 2019,
  operators_count   = 8,
  variants          = E'- **Yak-130** : entraîneur avancé de série\n- **Yak-130M** : version d''attaque légère à capteurs et armement étendus\n- **Yak-131** : projet de version de combat monoplace\n- **M-346 Master** : jumeau italien, issu du même projet commun avant la séparation de 2000',
  variants_en       = E'- **Yak-130** : production advanced trainer\n- **Yak-130M** : light attack version with expanded sensors and weapons\n- **Yak-131** : proposed single-seat combat version\n- **M-346 Master** : Italian twin, from the same joint project before the 2000 split',

  -- Strate 4 : qualitatif
  nickname          = 'Mitten',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Yakovlev_Yak-130',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Yakovlev_Yak-130',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ministry of Defence',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Yak-130';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Yak-130';
