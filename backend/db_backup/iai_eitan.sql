-- IAI Eitan (Heron TP)
--
-- Photo : IAI Heron TP (c-n 123, 92+52) 2025-06-28 Andre Gerwing Collection ID 024162.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:IAI_Heron_TP_(c-n_123,_92%2B52)_2025-06-28_Andre_Gerwing_Collection_ID_024162.jpg

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
    'IAI Eitan',
    'IAI Eitan',
    'IAI Eitan (Heron TP)',
    'IAI Eitan (Heron TP)',
    'Le grand drone israélien à turbopropulseur, envergure d''avion de ligne, qui vole au-dessus du trafic commercial',
    'The large turboprop Israeli drone with an airliner''s wingspan, flying above commercial traffic',
    '/assets/airplanes/iai-eitan.jpg',
    E'## Genèse\nAu début des années 2000, la division Malat d''**Israel Aerospace Industries** développe une version très agrandie de son drone **Heron**. Le programme reste longtemps entouré de silence : en avril 2004, la revue de l''armée de l''air israélienne révèle que deux prototypes volent déjà, mais d''autres annonces situent le premier vol en 2006, puis en 2007. L''américain **Aurora Flight Sciences** annonce en 2005 vouloir le commercialiser sous le nom d''Orion, sans suite. L''appareil, baptisé **Eitan** (« solide ») et exporté sous le nom de **Heron TP**, est présenté à la presse le 8 octobre 2007 sur la base de Tel Nof.\n\n## Conception\nL''Eitan est un drone de moyenne altitude et longue endurance (MALE) capable d''opérer au-dessus du trafic aérien commercial. Il reprend la formule du Heron : aile haute de grand allongement, deux poutres portant un empennage commun, turbopropulseur **PT6** de 1 200 ch entraînant une hélice propulsive. Avec 26 m d''envergure, il approche celle d''un Boeing 737 ; il pèse 5,4 t au décollage, monte à 14 000 m et tient plus de trente heures. Entièrement en composites, il est conçu pour tous les temps, avec dégivrage, décollage et atterrissage automatiques et avionique triplée. Présenté avec un radar à synthèse d''ouverture, une boule optronique et des antennes d''écoute électronique, il peut aussi porter des armes sous les ailes.\n\n## Carrière opérationnelle\nSelon un rapport, des Eitan auraient participé en 2009 à la frappe d''un convoi d''armes iranien traversant le Soudan vers Gaza. L''armée de l''air israélienne dévoile sa flotte en février 2010 et le 210e escadron est créé à Tel Nof en décembre de la même année. Tsahal ne commente pas l''armement de ses drones, mais l''Eitan est décrit dans des rôles armés. Pendant la **guerre de Gaza** de 2023-2024, des Eitan se relaient jour et nuit au-dessus du territoire pour désigner des cibles du Hamas.\n\n## Place dans l''histoire\nL''Eitan a fait passer le drone israélien de l''outil tactique au système stratégique, comparable au **MQ-9 Reaper** américain. Il s''exporte pourtant avec peine : la France le retient en 2011 avant que le Sénat n''annule l''achat, et l''Inde renonce en raison des restrictions israéliennes sur les technologies embarquées. L''Allemagne en fait son drone MALE et la Grèce en loue trois exemplaires à partir de 2020.',
    E'## Genesis\nIn the early 2000s the Malat division of **Israel Aerospace Industries** developed a much enlarged version of its **Heron** drone. The programme long remained shrouded in silence: in April 2004 the Israeli Air Force magazine revealed that two prototypes were already flying, but other announcements placed the first flight in 2006, then in 2007. The American firm **Aurora Flight Sciences** announced in 2005 that it would market it as the Orion, to no avail. The aircraft, named **Eitan** ("steadfast") and exported as the **Heron TP**, was shown to the press on 8 October 2007 at Tel Nof air base.\n\n## Design\nThe Eitan is a medium-altitude long-endurance (MALE) drone able to operate above commercial air traffic. It keeps the Heron formula: high-aspect-ratio high wing, twin booms carrying a common tailplane, and a 1,200 hp **PT6** turboprop driving a pusher propeller. Its 26 m span approaches that of a Boeing 737; it weighs 5.4 t at take-off, climbs to 14,000 m and stays aloft for more than thirty hours. Built entirely of composites, it is designed for all weather, with de-icing, automatic take-off and landing and triple-redundant avionics. Shown with a synthetic aperture radar, an electro-optical ball and signals intelligence antennas, it can also carry weapons under its wings.\n\n## Operational career\nAccording to one report, Eitans took part in 2009 in a strike on an Iranian arms convoy crossing Sudan towards Gaza. The Israeli Air Force unveiled its fleet in February 2010 and 210 Squadron was formed at Tel Nof in December of that year. The IDF does not comment on arming its drones, but the Eitan is described in armed roles. During the 2023-2024 **Gaza war**, Eitans took turns day and night over the territory to designate Hamas targets.\n\n## Place in history\nThe Eitan took the Israeli drone from tactical tool to strategic system, comparable to the American **MQ-9 Reaper**. Yet it has struggled to sell abroad: France chose it in 2011 before the Senate cancelled the purchase, and India gave up because of Israeli restrictions on the technologies on board. Germany made it its MALE drone and Greece has leased three from 2020.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    '2004-01-01',
    '2010-12-01',
    407,
    7400,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Eitan'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'IAI Eitan'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'IAI Eitan'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Eitan'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'IAI Eitan'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Eitan'), (SELECT id FROM wars WHERE name = 'Guerre Israël-Hamas'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14,
  wingspan          = 26,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 5400,
  service_ceiling   = 14000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6-67A (1 200 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Eitan** : version de l''armée de l''air israélienne, en service depuis 2010 au 210e escadron\n- **Heron TP** : désignation d''exportation, retenue par l''Allemagne et louée par la Grèce en configuration maritime\n- **Orion** : nom prévu pour une commercialisation aux États-Unis par Aurora Flight Sciences, restée sans suite',
  variants_en       = E'- **Eitan**: Israeli Air Force version, in service with 210 Squadron since 2010\n- **Heron TP**: export designation, chosen by Germany and leased by Greece in maritime configuration\n- **Orion**: name planned for marketing in the United States by Aurora Flight Sciences, which came to nothing',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Eitan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Eitan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'IAI Eitan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI Eitan';
