-- Hunting Percival P.66 Pembroke
--
-- Photo : Hunting percival p-66 pembroke c1 flying arp.jpg
--   licence Public domain — Adrian Pingstone (Arpingstone)
--   https://commons.wikimedia.org/wiki/File:Hunting_percival_p-66_pembroke_c1_flying_arp.jpg

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
    'Percival Pembroke',
    'Percival Pembroke',
    'Hunting Percival P.66 Pembroke',
    'Hunting Percival P.66 Pembroke',
    'Le bimoteur de liaison de la RAF, aux sièges tournés vers l''arrière, en service trente-cinq ans',
    'The RAF''s twin-engined communications aircraft, with rearward-facing seats, in service for 35 years',
    '/assets/airplanes/percival-pembroke.jpg',
    E'## Genèse\nLe Pembroke dérive du **Percival Prince**, un petit transport civil bimoteur. Pour la Royal Air Force, qui cherche à remplacer ses **Avro Anson** dans les missions de transport léger, Percival allonge l''aile afin d''autoriser une masse plus élevée à pleine charge. Le prototype vole le 21 novembre 1952 et l''avion entre en service dès 1953 sous la désignation Pembroke C.1. La production, assurée par la firme devenue **Hunting Percival**, s''achève au début de 1958 après 128 exemplaires.\n\n## Conception\nC''est un bimoteur à aile haute, propulsé par deux moteurs en étoile **Alvis Leonides** de 540 ch, qui emporte deux pilotes et six à dix passagers. Comme sur les autres transports de la RAF, les sièges sont tournés vers l''arrière pour mieux protéger les occupants en cas d''accident. Six appareils sont construits en version de reconnaissance photographique C(PR).1, avec un nez vitré et des vitrages latéraux supplémentaires, et deux C.1 sont convertis au même standard. Des doubles commandes peuvent être installées pour l''instruction.\n\n## Carrière opérationnelle\nLa RAF reçoit 56 Pembroke à partir de 1953 et les répartit entre une dizaine d''escadrons de liaison et de transport. Les C(PR).1 du 81e escadron servent à la reconnaissance photographique pendant l''**insurrection malaise**. Les avions reçoivent en 1970 des modifications prolongeant leur vie ; le 60e escadron, basé à Wildenrath en Allemagne de l''Ouest, est le dernier à les utiliser, jusqu''en 1988. À l''export, la Belgique exploite douze C.51 de 1954 à 1976, et la Suède, sous le nom de Tp 83, l''Allemagne de l''Ouest, la Finlande, le Soudan, la Rhodésie du Sud et la Zambie en achètent aussi ; les deux Pembroke finlandais photographient le territoire pour l''office national de topographie de 1956 à 1968.\n\n## Place dans l''histoire\nRemplacé dans la RAF par le **Hawker Siddeley Andover**, le Pembroke a servi trente-cinq ans d''avion de liaison, de transport de personnalités et d''appareil photographique volant. L''un d''eux, WV746, fut dans les années 1970 l''avion personnel du commandant en chef de l''Air Support Command, modifié pour embarquer une rampe pour fauteuil roulant ; il est exposé au musée de la RAF à Londres. Plusieurs C.51 belges ont connu une fin moins glorieuse : vendus en 1977 à un négociant américain se faisant appeler « Air America », la plupart seraient tombés entre les mains de trafiquants de drogue.',
    E'## Genesis\nThe Pembroke was developed from the **Percival Prince**, a small twin-engined civil transport. For the Royal Air Force, which wanted to replace its **Avro Ansons** on light transport duties, Percival lengthened the wing to allow a higher fully laden weight. The prototype flew on 21 November 1952 and the aircraft entered service as early as 1953 as the Pembroke C.1. Production, by the company that had become **Hunting Percival**, ended in early 1958 after 128 aircraft.\n\n## Design\nIt was a high-wing twin powered by two 540 hp **Alvis Leonides** radial engines, carrying two pilots and six to ten passengers. As in other RAF transports, the seats faced rearwards to better protect the occupants in a crash. Six aircraft were built as C(PR).1 photographic reconnaissance aircraft, with a glazed nose and extra side windows, and two C.1s were converted to the same standard. Dual controls could be fitted for instruction.\n\n## Operational career\nThe RAF received 56 Pembrokes from 1953 and spread them among some ten communications and transport squadrons. The C(PR).1s of No. 81 Squadron flew photographic reconnaissance during the **Malayan Emergency**. In 1970 the aircraft were modified to extend their lives; No. 60 Squadron at RAF Wildenrath in West Germany was the last unit to fly them, until 1988. For export, Belgium operated twelve C.51s from 1954 to 1976, and Sweden, as the Tp 83, West Germany, Finland, Sudan, Southern Rhodesia and Zambia bought them too; the two Finnish Pembrokes photographed the country for the National Land Survey from 1956 to 1968.\n\n## Place in history\nReplaced in the RAF by the **Hawker Siddeley Andover**, the Pembroke served for thirty-five years as a communications aircraft, VIP transport and flying camera platform. One of them, WV746, was the personal aircraft of the Commander-in-Chief of Air Support Command in the 1970s, modified to carry a wheelchair ramp; it is displayed at the RAF Museum in London. Several Belgian C.51s met a less glorious end: sold in 1977 to an American dealer styling itself ''Air America'', most of them are believed to have fallen into the hands of drug runners.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    NULL,
    '1952-11-21',
    '1953-01-01',
    354,
    1658,
    (SELECT id FROM manufacturer WHERE code = 'HUN'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Percival Pembroke'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Percival Pembroke'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Percival Pembroke'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Percival Pembroke'), (SELECT id FROM wars WHERE name = 'Insurrection malaise'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.02,
  wingspan          = 19.66,
  height            = 4.9,
  wing_area         = 37.2,
  empty_weight      = 4068,
  mtow              = 5897,
  service_ceiling   = 6700,
  climb_rate        = 7.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Alvis Leonides 127 (540 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1958,
  units_built       = 128,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 10,
  variants          = E'- **Pembroke C.1** : transport et liaison de la RAF, 44 exemplaires selon la liste des versions\n- **Pembroke C(PR).1** : reconnaissance photographique à nez vitré, six exemplaires et deux C.1 convertis\n- **Pembroke C.51 à C.55** : exportations vers la Belgique, la Suède (Tp 83), la Finlande, l''Allemagne de l''Ouest et le Soudan\n- **President** : version civile, cinq exemplaires',
  variants_en       = E'- **Pembroke C.1**: RAF transport and communications version, 44 built according to the variant list\n- **Pembroke C(PR).1**: photographic reconnaissance version with a glazed nose, six built and two C.1s converted\n- **Pembroke C.51 to C.55**: export versions for Belgium, Sweden (Tp 83), Finland, West Germany and Sudan\n- **President**: civil version, five built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Hunting_Percival_Pembroke_C-51',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Percival_Pembroke',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Adrian Pingstone',
  image_licence     = 'Public domain'
WHERE name = 'Percival Pembroke';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Percival Pembroke';
