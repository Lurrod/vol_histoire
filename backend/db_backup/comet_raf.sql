-- de Havilland DH.106 Comet C2 / C4
--
-- Photo : XR395 DH106 Comet C4 RAF LHR 02SEP63 (6812608815).jpg
--   licence CC BY-SA 3.0 — Ken Fielding
--   https://commons.wikimedia.org/wiki/File:XR395_DH106_Comet_C4_RAF_LHR_02SEP63_(6812608815).jpg

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
    'de Havilland Comet',
    'de Havilland Comet',
    'de Havilland DH.106 Comet C2 / C4',
    'de Havilland DH.106 Comet C2 / C4',
    'Le premier avion de ligne à réaction, devenu transport et avion d''écoute de la RAF',
    'The first jet airliner, turned RAF transport and signals intelligence aircraft',
    '/assets/airplanes/dh-comet-c4.jpg',
    E'## Genèse\nLe Comet naît d''une recommandation du comité Brabazon : en 1945, **de Havilland** reçoit le contrat du « Type IV », un avion de ligne à réaction que l''équipe de **Ronald Bishop** dessine avec une aile en flèche de 20 degrés et quatre réacteurs noyés dans l''emplanture. Le prototype vole le 27 juillet 1949 et le Comet 1 inaugure en mai 1952 le premier service commercial à réaction au monde. Mais trois accidents, dont deux dus à la fatigue du métal, clouent la flotte au sol en 1954. Le Comet 2, plus grand et propulsé par des **Rolls-Royce Avon**, est alors renforcé ; ses commandes civiles sont annulées, et la plupart des appareils construits partent à la **Royal Air Force**.\n\n## Conception\nLe Comet 2 se distingue du Comet 1 par une aile un peu plus grande, davantage de carburant, un fuselage allongé de 0,94 m et des réacteurs Avon de 31 kN. Reconstruits avec un revêtement plus épais et des hublots arrondis, les appareils de la RAF reçoivent des aménagements adaptés à leurs missions : cabine de transport de personnalités, équipement médical capable d''accueillir des poumons d''acier, puis, pour certains, des moyens de renseignement électromagnétique. La série 4, définitive, double la poussée des premiers Comet grâce à de nouveaux Avon et allonge encore le fuselage.\n\n## Carrière opérationnelle\nLes livraisons à la RAF commencent en 1955 : deux Comet T2 forment les équipages, le premier volant le 9 décembre 1955, et huit Comet C2 achevés pour l''armée de l''air rejoignent en 1956 le **216e escadron** du Transport Command. Trois Comet 2R, modifiés pour l''électronique, servent aux 192e puis 51e escadrons : à partir de 1958, ils écoutent le trafic des transmissions du **pacte de Varsovie**. Le 216e escadron reçoit ensuite des **Comet C4**, version militaire de la série 4, et les exploite avec ses C2 jusqu''en 1975, date à laquelle le 51e escadron se sépare aussi des siens. L''aviation royale canadienne utilise de son côté des Comet 1A, de 1953 à 1963.\n\n## Place dans l''histoire\nDans la RAF, le Comet n''a pas seulement transporté troupes et personnalités : il a fourni la base d''un avion bien plus durable : les deux derniers Comet 4C construits servent de prototypes au **Hawker Siddeley Nimrod** de patrouille maritime, entré en service en 1969 et retiré en juin 2011, plus de soixante ans après le premier vol du Comet. Le C2 XK699 *Sagittarius* a longtemps gardé l''entrée de la base de Lyneham avant d''être en grande partie démoli en 2013, et le dernier Comet à avoir volé, le 4C XS235 *Canopus*, est entretenu en état de rouler à Bruntingthorpe.',
    E'## Genesis\nThe Comet grew out of a Brabazon Committee recommendation: in 1945 **de Havilland** was awarded the contract for the ''Type IV'', a jet airliner that **Ronald Bishop**''s team designed with a 20-degree swept wing and four engines buried in the wing roots. The prototype flew on 27 July 1949 and in May 1952 the Comet 1 opened the world''s first commercial jet service. But three accidents, two of them caused by metal fatigue, grounded the fleet in 1954. The larger, **Rolls-Royce Avon**-powered Comet 2 was then strengthened; its airline orders were cancelled, and most of the aircraft built went to the **Royal Air Force**.\n\n## Design\nThe Comet 2 differed from the Comet 1 in its slightly larger wing, greater fuel capacity, a fuselage 0.94 m longer and 31 kN Avon engines. Rebuilt with heavier-gauge skin and rounded windows, the RAF aircraft were fitted out for their roles: VIP cabins, medical equipment able to take iron lungs, and later, on some airframes, signals intelligence equipment. The definitive Comet 4 series doubled the thrust of the first Comets with new Avons and stretched the fuselage further.\n\n## Operational career\nDeliveries to the RAF began in 1955: two Comet T2s trained the crews, the first flying on 9 December 1955, and eight Comet C2s completed for the air force joined Transport Command''s **No. 216 Squadron** in 1956. Three Comet 2Rs, modified for electronic work, served with Nos. 192 and 51 Squadrons: from 1958 they monitored **Warsaw Pact** signals traffic. No. 216 Squadron later received **Comet C4s**, the military version of the 4 series, and flew them alongside its C2s until 1975, when No. 51 Squadron also gave up its Comets. The Royal Canadian Air Force, for its part, used Comet 1As from 1953 to 1963.\n\n## Place in history\nIn RAF service the Comet did more than carry troops and VIPs: it provided the basis for a far longer-lived aircraft: the last two Comet 4Cs built served as prototypes for the **Hawker Siddeley Nimrod** maritime patrol aircraft, which entered service in 1969 and was retired in June 2011, more than sixty years after the Comet''s first flight. Comet C2 XK699 *Sagittarius* long stood at the gate of RAF Lyneham before being largely scrapped in 2013, and the last Comet to fly, 4C XS235 *Canopus*, is kept in taxiable condition at Bruntingthorpe.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1945-01-01',
    '1949-07-27',
    '1956-01-01',
    NULL,
    4184,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Comet'), (SELECT id FROM tech WHERE name = 'Aile en flèche légère'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Comet'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Comet'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Comet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.29,
  wingspan          = 35.05,
  height            = 8.99,
  wing_area         = 187.2,
  empty_weight      = NULL,
  mtow              = 54431,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon Mk 503/504',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 31.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Comet T2** : deux des dix Comet 2 destinés à la RAF, aménagés pour la formation des équipages ; premier vol de XK669 le 9 décembre 1955\n- **Comet C2** : huit Comet 2 prévus pour le marché civil, achevés pour la RAF et affectés au 216e escadron\n- **Comet 2R** : trois appareils d''électronique et d''écoute des transmissions du pacte de Varsovie (192e puis 51e escadrons), à partir de 1958\n- **Comet C4** : version de transport de la série 4, en service au 216e escadron jusqu''en 1975\n- **Comet 1A / 1XB** : appareils de l''aviation royale canadienne (412e escadron, 1953-1963)',
  variants_en       = E'- **Comet T2**: two of the ten Comet 2s for the RAF, fitted out as crew trainers; XK669 first flew on 9 December 1955\n- **Comet C2**: eight Comet 2s intended for the civil market, completed for the RAF and assigned to No. 216 Squadron\n- **Comet 2R**: three electronic and signals-monitoring aircraft watching Warsaw Pact traffic (Nos. 192 then 51 Squadrons), from 1958\n- **Comet C4**: transport version of the 4 series, in service with No. 216 Squadron until 1975\n- **Comet 1A / 1XB**: Royal Canadian Air Force aircraft (No. 412 Squadron, 1953-1963)',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Comet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Comet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ken Fielding',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'de Havilland Comet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'de Havilland Comet';
