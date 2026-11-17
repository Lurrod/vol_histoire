-- IAI / Gulfstream G550 CAEW Eitam
--
-- Photo : RSAF Gulfstream IAI G550 CAEW (Conformal Airborne Early Warning).jpg
--   licence CC BY-SA 2.0 — Owen65
--   https://commons.wikimedia.org/wiki/File:RSAF_Gulfstream_IAI_G550_CAEW_(Conformal_Airborne_Early_Warning).jpg

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
    'IAI G550 CAEW',
    'IAI G550 CAEW',
    'IAI / Gulfstream G550 CAEW Eitam',
    'IAI / Gulfstream G550 CAEW Eitam',
    'Un avion d''affaires Gulfstream devenu radar volant, ses antennes moulées dans le fuselage',
    'A Gulfstream business jet turned flying radar, its antennas moulded into the fuselage',
    '/assets/airplanes/g550-caew.jpg',
    E'## Genèse\nL''armée de l''air israélienne exploite d''abord le système **EL/M-2075 Phalcon** monté sur Boeing 707, plus ancien et plus coûteux à exploiter. Pour la génération suivante, **Israel Aerospace Industries** et **Elta Electronics Industries** développent un radar multibande, l''**EL/W-2085**, et le logent dans un appareil beaucoup plus petit : l''avion d''affaires **Gulfstream G550**. En 2005, Israël achète ces appareils, baptisés **Eitam** : ils sont plus capables et moins chers à exploiter que leurs prédécesseurs.\n\n## Conception\nLe CAEW, pour *Conformal Airborne Early Warning*, renonce au radôme rotatif. Son radar est une **antenne active** à balayage électronique dont les modules d''émission-réception orientent le faisceau sans aucune pièce mobile. IAI greffe sur le fuselage des radômes en **matériaux composites** épousant ses formes : une antenne en bande L de chaque côté, une antenne en bande S dans le nez et une autre dans la queue. Les fréquences changent de façon pseudo-aléatoire, ce qui rend le radar difficile à détecter et à brouiller. Il suit jusqu''à 1 000 cibles à 450 km et rafraîchit leur position toutes les deux à quatre secondes, contre dix pour un AWACS à dôme tournant.\n\n## Carrière opérationnelle\nBasés à Nevatim, les Eitam israéliens sont rejoints en 2007 par une commande de Singapour : quatre appareils destinés à remplacer ses **E-2C Hawkeye** modernisés, qui entrent en service le 13 avril 2012. L''Italie suit avec deux exemplaires livrés en 2018, appelés localement **E-550A**, et en commande deux autres en 2024. En 2018, l''US Navy reçoit à son tour un G550 de ce type, que Raytheon doit transformer en banc d''essai **NC-37B**.\n\n## Place dans l''histoire\nLe G550 CAEW a montré qu''un avion de guet aérien n''avait plus besoin d''être un quadriréacteur de ligne coiffé d''un champignon : un avion d''affaires suffit, pourvu que les antennes fassent corps avec la cellule. Ce pari sur la sobriété l''a imposé dans trois pays, Israël, Singapour et l''Italie. En septembre 2025, la Corée du Sud choisit à son tour le radar EL/W-2085, cette fois sur le Phoenix de L3Harris.',
    E'## Genesis\nThe Israeli Air Force first operated the **EL/M-2075 Phalcon** system mounted on the Boeing 707, older and more expensive to operate. For the next generation, **Israel Aerospace Industries** and **Elta Electronics Industries** developed a multi-band radar, the **EL/W-2085**, and housed it in a much smaller aircraft: the **Gulfstream G550** business jet. In 2005 Israel bought these aircraft, named **Eitam**: they are more capable and cheaper to operate than their predecessors.\n\n## Design\nThe CAEW, for Conformal Airborne Early Warning, does without a rotodome. Its radar is an **active electronically scanned array** whose transmit/receive modules steer the beam with no moving parts. IAI grafted onto the fuselage **composite** radomes that follow its contours: an L-band array on each side, an S-band antenna in the nose and another in the tail. Frequencies change in a pseudorandom pattern, making the radar hard to detect and jam. It tracks up to 1,000 targets at 450 km and refreshes their positions every two to four seconds, against ten for a rotating-dome AWACS.\n\n## Operational career\nBased at Nevatim, the Israeli Eitams were joined in 2007 by an order from Singapore: four aircraft to replace its upgraded **E-2C Hawkeyes**, which entered service on 13 April 2012. Italy followed with two examples delivered in 2018, known locally as **E-550A**, and ordered two more in 2024. In 2018 the US Navy in turn received a G550 of this type, to be converted by Raytheon into the **NC-37B** test aircraft.\n\n## Place in history\nThe G550 CAEW showed that an early warning aircraft no longer had to be a four-engined airliner topped by a mushroom: a business jet will do, provided the antennas are part of the airframe. That bet on economy won it three countries, Israel, Singapore and Italy. In September 2025 South Korea also chose the EL/W-2085 radar, this time on L3Harris''s Phoenix.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI G550 CAEW'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'IAI G550 CAEW'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI G550 CAEW'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'IAI G550 CAEW'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = NULL,
  engine_type       = NULL,
  engine_type_en    = NULL,
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Eitam** : version de l''armée de l''air israélienne, basée à Nevatim\n- **G550 CAEW de Singapour** : quatre appareils commandés en 2007, en service le 13 avril 2012 à la place des E-2C\n- **E-550A** : désignation italienne, deux livrés en 2018 et deux commandés en 2024\n- **NC-37B** : G550 livré à l''US Navy en 2018 pour être transformé par Raytheon en banc d''essai\n- **Radar EL/W-2085** : antennes en bande L sur les flancs, en bande S dans le nez et la queue',
  variants_en       = E'- **Eitam**: Israeli Air Force version, based at Nevatim\n- **Singapore G550 CAEW**: four aircraft ordered in 2007, in service on 13 April 2012 in place of the E-2C\n- **E-550A**: Italian designation, two delivered in 2018 and two ordered in 2024\n- **NC-37B**: G550 delivered to the US Navy in 2018 for conversion by Raytheon into a test aircraft\n- **EL/W-2085 radar**: L-band arrays on the sides, S-band antennas in the nose and tail',

  -- Strate 4 : qualitatif
  nickname          = 'Eitam',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/EL/W-2085',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Owen65',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'IAI G550 CAEW';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI G550 CAEW';
