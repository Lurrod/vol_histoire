-- British Aerospace EAP (Experimental Aircraft Programme)
--
-- Photo : BAe EAP (27898306501).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany, Germany
--   https://commons.wikimedia.org/wiki/File:BAe_EAP_(27898306501).jpg

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
    'British Aerospace EAP',
    'British Aerospace EAP',
    'British Aerospace EAP (Experimental Aircraft Programme)',
    'British Aerospace EAP (Experimental Aircraft Programme)',
    'Démonstrateur à aile delta et plans canard qui a ouvert la voie à l''Eurofighter Typhoon',
    'A canard-delta demonstrator that paved the way for the Eurofighter Typhoon',
    '/assets/airplanes/bae-eap.jpg',
    E'## Genèse\nL''EAP naît de l''**Agile Combat Aircraft**, une étude menée à la fin des années 1970 par **British Aerospace**, qui rassemble ses propres recherches et des travaux comparables de l''allemand **MBB** et de l''italien **Aeritalia**. Commandes de vol électriques numériques, aptes à piloter un avion instable, et nouveaux procédés de fabrication en sont le cœur. Une maquette paraît à Farnborough en 1982, et l''**Experimental Aircraft Programme** est lancé l''année suivante pour construire deux démonstrateurs. Mais l''Allemagne de l''Ouest refuse de financer le projet : le second avion est abandonné, et l''unique EAP est payé par l''État britannique, qui y investit près de 80 millions de livres, et par l''industrie.\n\n## Conception\nL''EAP associe une aile delta à double flèche à des plans canard, avec une grande dérive et une entrée d''air rectangulaire sous le fuselage. L''avant du fuselage fait largement appel aux composites de fibre de carbone et à l''alliage aluminium-lithium ; l''aile droite, construite à Samlesbury, est un assemblage composite collé, l''aile gauche vient de l''usine d''Aeritalia à Turin. Pour réduire les coûts, l''arrière du fuselage et la dérive dérivent de ceux du **Tornado**, dont l''avion reprend les deux réacteurs **Turbo-Union RB199** à postcombustion. Le cockpit compte trois écrans cathodiques et un collimateur tête haute ; aucun système d''armes n''est installé, les missiles exhibés sont factices.\n\n## Essais\nPrésenté à Warton le 18 avril 1986, le ZF534 vole le 8 août 1986 aux mains de **David Eagles** et dépasse d''emblée Mach 1,1. Il paraît à Farnborough dès septembre, puis enchaîne les démonstrations en meeting, dont son centième vol au salon du Bourget de 1987. Testant quelque 36 technologies, dont la commande vocale et les écrans multifonctions du futur Eurofighter, il atteint Mach 2 et reste contrôlable au-delà de 35° d''incidence. Il est retiré le 1er mai 1991, après 259 vols et 195 heures de vol.\n\n## Place dans l''histoire\nSelon la commission des comptes de la Chambre des communes, l''EAP a raccourci d''un an le développement de l''**Eurofighter Typhoon**, pour une économie de 850 millions de livres. Le Typhoon en diffère pourtant : aile delta simple, dérive réduite, entrée d''air « souriante ». Après vingt ans comme support d''enseignement à l''université de Loughborough, l''appareil a été restauré et exposé au musée de la RAF de Cosford en 2013.',
    E'## Genesis\nThe EAP grew out of the **Agile Combat Aircraft**, a study led in the late 1970s by **British Aerospace** that pooled its own research with similar work by Germany''s **MBB** and Italy''s **Aeritalia**. Full-authority digital fly-by-wire, able to fly an unstable aircraft, and new manufacturing processes were at its heart. A mock-up appeared at Farnborough in 1982, and the **Experimental Aircraft Programme** was launched the next year to build two demonstrators. But West Germany declined to fund it: the second aircraft was dropped, and the sole EAP was paid for by the British government, which put in almost 80 million pounds, and by industry.\n\n## Design\nThe EAP combined a cranked delta wing with canard foreplanes, a large fin and a rectangular intake under the fuselage. The front fuselage made extensive use of carbon-fibre composites and aluminium-lithium alloy; the right wing, built at Samlesbury, was a co-bonded composite assembly, while the left came from Aeritalia''s plant in Turin. To save money, the rear fuselage and fin were based on those of the **Tornado**, whose two afterburning **Turbo-Union RB199** engines it also used. The cockpit had three cathode-ray tube displays and a head-up display; no weapons system was ever fitted, and the missiles it carried were dummies.\n\n## Testing\nRolled out at Warton on 18 April 1986, ZF534 flew on 8 August 1986 with **David Eagles** at the controls, passing Mach 1.1 on that first flight. It appeared at Farnborough in September, then flew many airshow displays, its hundredth flight coming at the 1987 Paris Air Show. Testing some 36 technologies, including the direct voice input and multi-function displays of the future Eurofighter, it reached Mach 2 and stayed controllable beyond 35 degrees of angle of attack. It was retired on 1 May 1991, after 259 sorties and 195 flight hours.\n\n## Place in history\nAccording to the House of Commons Accounts Committee, the EAP cut a year from the development of the **Eurofighter Typhoon**, saving 850 million pounds. Yet the Typhoon differs from it: a plain delta wing, a smaller fin and a ''smiling'' intake. After two decades as a teaching aid at Loughborough University, the aircraft was restored and put on display at the RAF Museum Cosford in 2013.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1983-01-01',
    '1986-08-08',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'British Aerospace EAP'), (SELECT id FROM tech WHERE name = 'Aile delta-canard')),
((SELECT id FROM airplanes WHERE name = 'British Aerospace EAP'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'British Aerospace EAP'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'British Aerospace EAP'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'British Aerospace EAP'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.7,
  wingspan          = 11.76,
  height            = 5.52,
  wing_area         = 52,
  empty_weight      = 10002,
  mtow              = 14515,
  service_ceiling   = 18000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Turbo-Union RB199-104D',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 40.0,
  thrust_wet        = 76.0,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Agile Combat Aircraft (ACA)** : étude et maquette présentée à Farnborough en 1982 et au Bourget en 1983\n- **EAP (ZF534)** : seul exemplaire, premier vol le 8 août 1986, retiré le 1er mai 1991, exposé à Cosford\n- **Second démonstrateur** : prévu au lancement du programme, abandonné faute de financement ouest-allemand',
  variants_en       = E'- **Agile Combat Aircraft (ACA)**: study and mock-up shown at Farnborough in 1982 and Paris in 1983\n- **EAP (ZF534)**: sole example, first flight on 8 August 1986, retired on 1 May 1991, displayed at Cosford\n- **Second demonstrator**: planned at the programme launch, dropped for lack of West German funding',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/British_Aerospace_EAP',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/British_Aerospace_EAP',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters',
  image_licence     = 'CC BY 2.0'
WHERE name = 'British Aerospace EAP';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'British Aerospace EAP';
