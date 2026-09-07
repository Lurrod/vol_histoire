-- Boeing C-17 Globemaster III
--
-- Photo : C-17 test sortie.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File%3AC-17_test_sortie.jpg

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
    'C-17 Globemaster III',
    'C-17 Globemaster III',
    'Boeing C-17 Globemaster III',
    'Boeing C-17 Globemaster III',
    'Porteur stratégique capable de se poser sur un terrain sommaire',
    'Strategic airlifter able to land on a rough field',
    '/assets/airplanes/c17-globemaster.jpg',
    E'## Genèse\nL''aviation de transport américaine est coupée en deux : le **C-5 Galaxy** porte lourd mais exige de grandes bases, le **C-130** se pose partout mais porte peu. Entre les deux, il faut décharger, recharger, perdre des jours. L''US Air Force demande donc en 1981 un appareil unique qui emporte un char sur un continent **et** le dépose sur une piste sommaire de neuf cents mètres.\n\n## Conception\nLa contrainte tient dans le rapport entre la masse et la longueur de piste. La solution est le **soufflage des volets** : les réacteurs sont placés très en avant, leur jet est dirigé sur des volets fendus qui le rabattent vers le bas et créent une portance supplémentaire à basse vitesse. Les inverseurs de poussée fonctionnent au sol comme en vol, ce qui autorise des descentes très raides et une marche arrière au roulage. Les winglets réduisent la traînée en croisière.\n\n## Carrière opérationnelle\nIl devient l''outil du pont aérien immédiat : Kosovo, Afghanistan, Irak, Haïti après le séisme, évacuation de **Kaboul en août 2021** — où un C-17 décollera avec huit cent vingt-trois personnes à bord, record absolu pour le type. Il transporte aussi bien un hôpital de campagne qu''un hélicoptère d''attaque ou le véhicule présidentiel.\n\n## Place dans l''histoire\nDeux cent soixante-dix-neuf exemplaires, production close en 2015. Il a résolu un problème que personne n''avait su traiter avant lui : la rupture de charge entre le transport intercontinental et la livraison au plus près. Aucun successeur n''est prévu, et sa chaîne est définitivement fermée — les huit pays qui l''exploitent devront le faire durer.',
    E'## Genesis\nAmerican airlift was split in two: the **C-5 Galaxy** carried heavy loads but needed large bases, the **C-130** could land anywhere but carried little. Between the two lay unloading, reloading and days lost. In 1981 the US Air Force therefore asked for a single aircraft that could carry a tank across a continent **and** put it down on a rough nine-hundred-metre strip.\n\n## Design\nThe constraint lies in the ratio between weight and runway length. The answer is **externally blown flaps**: the engines sit well forward, their exhaust directed onto slotted flaps that deflect it downward and create extra lift at low speed. The thrust reversers work on the ground and in flight, allowing very steep descents and backing up while taxiing. Winglets cut cruise drag.\n\n## Operational career\nIt became the instrument of the immediate air bridge: Kosovo, Afghanistan, Iraq, Haiti after the earthquake, the evacuation of **Kabul in August 2021** — where one C-17 took off with eight hundred and twenty-three people aboard, an absolute record for the type. It carries a field hospital as readily as an attack helicopter or the presidential vehicle.\n\n## Place in history\nTwo hundred and seventy-nine built, production closed in 2015. It solved a problem nobody had managed before it: the break in the chain between intercontinental transport and delivery close to the point of need. No successor is planned and its line is permanently shut — the eight countries operating it will have to make it last.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1981-01-01',
    '1991-09-15',
    '1995-01-17',
    830.0,
    4482.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM wars WHERE name = 'Intervention en Libye')),
((SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 53.04,
  wingspan          = 51.75,
  height            = 16.79,
  wing_area         = 353.0,
  empty_weight      = 128100,
  mtow              = 265350,
  service_ceiling   = 13716,
  climb_rate        = 15.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4482,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney F117-PW-100',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 180.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1991,
  production_end    = 2015,
  units_built       = 279,
  unit_cost_usd     = 340000000,
  unit_cost_year    = 2007,
  operators_count   = 8,
  variants          = E'- **C-17A** : version unique de série, produite jusqu''en 2015\n- **C-17ER** : capacité de carburant accrue, standard à partir de 2001\n- Exporté au **Royaume-Uni**, au Canada, en Australie, en Inde, au Qatar et aux Émirats\n- Trois exemplaires exploités en commun par douze pays de l''**OTAN** depuis la Hongrie\n- Capable de faire demi-tour sur une piste de 27 mètres de large, en marche arrière',
  variants_en       = E'- **C-17A** : the sole production version, built until 2015\n- **C-17ER** : increased fuel capacity, standard from 2001\n- Exported to the **United Kingdom**, Canada, Australia, India, Qatar and the UAE\n- Three aircraft jointly operated by twelve **NATO** countries from Hungary\n- Able to turn around on a 27-metre-wide runway, using reverse thrust',

  -- Strate 4 : qualitatif
  nickname          = 'Moose',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_C-17_Globemaster_III',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_C-17_Globemaster_III',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'C-17 Globemaster III';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-17 Globemaster III';
