-- Fouga CM.170 Magister
--
-- Photo : Antwerp Fouga Magister MT-5 2024 05.jpg
--   licence CC BY-SA 4.0 — Ad Meskens You are free to use this picture for any purpose as long as you credit its author, Ad Meskens . Exa
--   https://commons.wikimedia.org/wiki/File%3AAntwerp_Fouga_Magister_MT-5_2024_05.jpg

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
    'Fouga CM.170 Magister',
    'Fouga CM.170 Magister',
    'Fouga CM.170 Magister',
    'Fouga CM.170 Magister',
    'Entraîneur français à empennage papillon, engagé au combat en 1967',
    'French V-tailed trainer, committed to combat in 1967',
    '/assets/airplanes/fouga-magister.jpg',
    E'## Genèse\nFouga part d''un planeur, le Castel-Mauboussin CM.8, et lui greffe deux petits réacteurs **Marboré**. L''idée est de former des pilotes à moindre coût dans une France qui reconstruit son aviation. L''appareil qui en sort ne ressemble à aucun autre : ailes de planeur et **empennage papillon** en V.\n\n## Conception\nL''empennage en V remplace dérive et stabilisateurs par deux surfaces inclinées : moins de traînée, moins de pièces, et une silhouette immédiatement reconnaissable. Les deux Marboré ne délivrent que 4,7 kN chacun — le Magister est lent, mais fin, économique et d''une docilité qui en fait un excellent avion-école.\n\n## Carrière opérationnelle\nVingt utilisateurs, dont Israël qui en produit sous licence. Le 5 juin **1967**, faute d''appareils disponibles — tous engagés dans l''opération Focus — l''aviation israélienne envoie ses Magister d''entraînement attaquer les colonnes blindées jordaniennes et égyptiennes. Plusieurs sont abattus ; c''est le seul emploi au combat massif d''un avion-école moderne.\n\n## Place dans l''histoire\nNeuf cent vingt-neuf exemplaires, et seize ans à la **Patrouille de France**. Son successeur direct dans l''armée de l''air, l''**Alpha Jet**, ne reprendra ni son empennage ni sa modestie — mais bien sa vocation.',
    E'## Genesis\nFouga started from a glider, the Castel-Mauboussin CM.8, and grafted on two small **Marboré** engines. The idea was to train pilots cheaply in a France rebuilding its aviation. The resulting aircraft resembles no other: glider wings and a **butterfly V-tail**.\n\n## Design\nThe V-tail replaces fin and tailplanes with two canted surfaces: less drag, fewer parts, and an instantly recognisable silhouette. The two Marborés deliver only 4.7 kN each — the Magister is slow, but slender, economical and so docile it makes an excellent school aircraft.\n\n## Operational career\nTwenty operators, including Israel, which built it under licence. On 5 June **1967**, with no aircraft to spare — all committed to Operation Focus — the Israeli Air Force sent its training Magisters against Jordanian and Egyptian armoured columns. Several were shot down; it is the only mass combat use of a modern school aircraft.\n\n## Place in history\nNine hundred and twenty-nine built, and sixteen years with the **Patrouille de France**. Its direct successor in the French Air Force, the **Alpha Jet**, would inherit neither its tail nor its modesty — but certainly its purpose.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1948-01-01',
    '1952-07-23',
    '1956-02-01',
    715.0,
    1200.0,
    (SELECT id FROM manufacturer WHERE code = 'FOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie')),
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM wars WHERE name = 'Guerre des Six Jours')),
((SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.06,
  wingspan          = 12.15,
  height            = 2.8,
  wing_area         = 17.3,
  empty_weight      = 2150,
  mtow              = 3200,
  service_ceiling   = 11000,
  climb_rate        = 17,
  g_limit_pos       = 7.0,
  g_limit_neg       = NULL,
  combat_radius     = 450,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turboméca Marboré VI',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 4.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1970,
  units_built       = 929,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 20,
  variants          = E'- **CM.170-1 / -2** : versions d''entraînement successives\n- **CM.175 Zéphyr** : version navalisée à crosse d''appontage pour l''Aéronavale\n- **IAI Tzukit** : version israélienne modernisée, en service jusqu''en 2020\n- Monture de la **Patrouille de France** de 1964 à 1980',
  variants_en       = E'- **CM.170-1 / -2** : successive training versions\n- **CM.175 Zéphyr** : navalised version with arrestor hook for French naval aviation\n- **IAI Tzukit** : upgraded Israeli version, in service until 2020\n- Mount of the **Patrouille de France** from 1964 to 1980',

  -- Strate 4 : qualitatif
  nickname          = 'Fouga',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fouga_CM.170_Magister',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fouga_CM.170_Magister',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ad Meskens You are free to use this picture for any purpose as long as you credit its author, Ad Meskens . Exa',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Fouga CM.170 Magister';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fouga CM.170 Magister';
