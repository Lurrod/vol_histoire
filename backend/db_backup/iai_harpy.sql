-- IAI Harpy
--
-- Photo : Paris Air Show 2007-06-24 n25.jpg
--   licence Public domain — Jastrow
--   https://commons.wikimedia.org/wiki/File:Paris_Air_Show_2007-06-24_n25.jpg

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
    'IAI Harpy',
    'IAI Harpy',
    'IAI Harpy',
    'IAI Harpy',
    'La munition rôdeuse anti-radar qui attend que l''ennemi allume son radar pour plonger dessus',
    'The anti-radar loitering munition that waits for the enemy to switch on its radar, then dives onto it',
    '/assets/airplanes/iai-harpy.jpg',
    E'## Genèse\nLe **Harpy** a une origine sud-africaine. À la fin des années 1980, la firme **Kentron** cède à **Israel Aircraft Industries** les plans de l''**ARD-10**, un drone conçu pour tourner au-dessus d''une zone avant de s''abattre sur sa cible. IAI reprend ces travaux et en tire le Harpy, dont les premiers essais ont lieu en 1989. L''idée est de traiter le problème le plus coûteux de l''aviation d''attaque, les défenses antiaériennes guidées par radar, sans exposer ni pilote ni avion.\n\n## Conception\nLe Harpy n''est ni tout à fait un drone ni tout à fait un missile : c''est une **munition rôdeuse**. Long de 2,7 m pour 2,1 m d''envergure et 135 kg, il vole à 185 km/h grâce à un petit moteur rotatif **Wankel** de 38 ch et peut couvrir 200 km. Son rôle est la suppression des défenses aériennes ennemies : il patrouille au-dessus de la zone, cherche l''émission d''un radar, puis plonge sur l''antenne et la détruit avec sa charge explosive de 32 kg. L''appareil est perdu à chaque mission réussie, mais il menace un réseau de défense aussi longtemps qu''il reste en l''air.\n\n## Carrière opérationnelle\nIsraël vend le Harpy à plusieurs pays, dont la Corée du Sud, l''Inde, l''Azerbaïdjan, le Maroc et la Chine. Cette dernière vente tourne à l''affaire d''État. La Chine en achète en 1994 pour environ 55 millions de dollars et les renvoie en Israël en 2004 pour une modernisation. Washington, qui craint de voir ces armes se retourner contre Taïwan ou contre les forces américaines, exige alors qu''Israël les saisisse et annule le contrat. Israël rétorque que le Harpy, conçu chez lui, ne contient aucun sous-système américain ; les appareils repartent en Chine en 2005, sans avoir été modernisés.\n\n## Place dans l''histoire\nL''affaire refroidit nettement les relations entre les deux alliés : Israël est un temps suspendu de son statut de participant au programme du **F-35**, avant d''y être réadmis le 6 novembre 2005. Sur le plan militaire, le Harpy a ouvert la voie des munitions rôdeuses, aujourd''hui omniprésentes sur les champs de bataille. IAI en a dérivé un Mini Harpy à triple autodirecteur, un Harpy NG et surtout l''**IAI Harop**, capable de choisir sa cible à la caméra et non plus seulement au radar.',
    E'## Genesis\nThe **Harpy** has South African roots. In the late 1980s the firm **Kentron** sold **Israel Aircraft Industries** the designs of the **ARD-10**, a drone built to circle over an area before diving onto its target. IAI took over this work and derived the Harpy from it, first tested in 1989. The idea was to deal with the costliest problem facing attack aviation, radar-guided air defences, without exposing either a pilot or an aircraft.\n\n## Design\nThe Harpy is neither quite a drone nor quite a missile: it is a **loitering munition**. At 2.7 m long, with a 2.1 m span and a weight of 135 kg, it flies at 185 km/h on a small 38 hp **Wankel** rotary engine and can cover 200 km. Its role is the suppression of enemy air defences: it patrols over the area, looks for a radar emission, then dives onto the antenna and destroys it with its 32 kg explosive warhead. The aircraft is lost with every successful mission, but it threatens an air defence network for as long as it stays airborne.\n\n## Operational career\nIsrael sold the Harpy to several countries, including South Korea, India, Azerbaijan, Morocco and China. That last sale became an affair of state. China bought Harpys in 1994 for about 55 million dollars and sent them back to Israel in 2004 for an upgrade. Washington, fearing that these weapons could be turned against Taiwan or American forces, then demanded that Israel seize them and cancel the contract. Israel replied that the Harpy, designed at home, contained no American subsystem; the aircraft went back to China in 2005 without being upgraded.\n\n## Place in history\nThe affair markedly chilled relations between the two allies: Israel was for a time suspended from its participant status in the **F-35** programme, before being readmitted on 6 November 2005. Militarily, the Harpy opened the way for loitering munitions, now ubiquitous on battlefields. IAI derived from it a Mini Harpy with a triple seeker, a Harpy NG and above all the **IAI Harop**, able to pick its target by camera and no longer by radar alone.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    '1989-01-01',
    NULL,
    185,
    200,
    (SELECT id FROM manufacturer WHERE code = 'IAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Harpy'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAI Harpy'), (SELECT id FROM missions WHERE name = 'Suppression des défenses aériennes ennemies'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 2.7,
  wingspan          = 2.1,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 135,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'UEL AR731 (38 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur rotatif',
  engine_type_en    = 'Rotary engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **Harpy** : munition rôdeuse anti-radar d''origine, 135 kg et charge explosive de 32 kg\n- **Mini Harpy** : version de 41 kg, 100 km de portée, deux heures d''endurance et triple autodirecteur (anti-radar et électro-optique de jour et de nuit)\n- **Harpy NG** : nouvelle génération du Harpy\n- **Harop (Harpy 2)** : dérivé plus grand, guidé aussi par caméra',
  variants_en       = E'- **Harpy**: original anti-radar loitering munition, 135 kg with a 32 kg warhead\n- **Mini Harpy**: 41 kg version, 100 km range, two hours'' endurance and a triple seeker (anti-radiation plus day and night electro-optical)\n- **Harpy NG**: new-generation Harpy\n- **Harop (Harpy 2)**: larger derivative, also guided by camera',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/IAI_Harpy',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/IAI_Harpy',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jastrow',
  image_licence     = 'Public domain'
WHERE name = 'IAI Harpy';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAI Harpy';
