-- PZL-104 Wilga 35
--
-- Photo : Wilgas Formation Takeoff (8117939376).jpg
--   licence CC BY-SA 2.0 — Bill Larkins
--   https://commons.wikimedia.org/wiki/File:Wilgas_Formation_Takeoff_(8117939376).jpg

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
    'PZL-104 Wilga',
    'PZL-104 Wilga',
    'PZL-104 Wilga 35',
    'PZL-104 Wilga 35',
    'Le « loriot » polonais à décollage court, avion polonais le plus produit de l''histoire, de l''aéro-club à l''armée',
    'Poland''s STOL golden oriole, the most-produced Polish aircraft ever, from flying clubs to border guards',
    '/assets/airplanes/pzl104-wilga.jpg',
    E'## Genèse\nChez **PZL Warszawa-Okęcie**, le Wilga — le « loriot » — est d''abord pensé pour l''aviation sportive et civile : remorquer des planeurs, larguer des parachutistes. Le prototype du Wilga 1 vole le 24 avril 1962 avec un moteur à plat polonais de 220 ch, mais les essais révèlent un appareil trop lourd, dont le pilote voit mal le planeur qu''il remorque. Les ingénieurs **Bronisław Żurakowski** et **Andrzej Frydrychewicz** reprennent alors entièrement le dessin.\n\n## Conception\nLe Wilga 2, qui vole le 1er août 1963, conserve l''aile mais reçoit un fuselage neuf, plus fin et plus robuste, avec une excellente vue vers l''arrière et des portes latérales qui s''ouvrent vers le haut, de quoi observer ou larguer des parachutistes en vol, portes ouvertes. Son moteur n''étant pas au point, on adopte le moteur en étoile **Ivchenko AI-14R** de 260 ch : le Wilga 3 vole le 31 décembre 1965, puis le **Wilga 35**, à voie élargie, le 29 juin 1967. Monoplan à aile haute en porte-à-faux, tout en aluminium, il porte des becs anti-décrochage et des volets à fente ; sa puissance et son aile lui donnent, à vide, une montée de 11 m/s.\n\n## Carrière opérationnelle\nLe Wilga sert surtout dans le civil, et d''abord à l''Aéro-club de Pologne, dont il forme longtemps l''ossature. Les forces armées qui l''adoptent l''emploient comme avion d''entraînement, de liaison, de récupération et d''observation légère : l''armée de l''air polonaise en aligne 27 de 1971 à 1993, et une version militaire de liaison, le **Wilga 35P**, vole dès 1968. Il passe aussi en Égypte, en Mongolie, dans les pays baltes et au Paraguay ; l''Indonésie le construit sous licence sous le nom de **Gelatik**. En 1996, PZL propose une version armée de deux points d''emport pour la patrouille des frontières et la contre-insurrection, et les garde-frontières polonais reçoivent des **Wilga 2000** de patrouille.\n\n## Place dans l''histoire\nRachetée par **EADS** en 2001, l''usine arrête la production en novembre 2006, à la surprise de ses propres revendeurs. Avec plus de 1 000 exemplaires, dont environ 935 Wilga 35 et 80, le Wilga est l''avion polonais le plus produit de l''histoire. Ses droits ont été cédés en 2024 à Draco Aircraft, qui veut le relancer sous une forme modernisée.',
    E'## Genesis\nAt **PZL Warszawa-Okęcie**, the Wilga — the ''golden oriole'' — was first conceived for sporting and civil flying: towing gliders and dropping parachutists. The Wilga 1 prototype flew on 24 April 1962 with a 220 hp Polish flat engine, but testing revealed an aircraft that was too heavy, whose pilot could barely see the glider he was towing. Engineers **Bronisław Żurakowski** and **Andrzej Frydrychewicz** then redesigned it from end to end.\n\n## Design\nThe Wilga 2, which flew on 1 August 1963, kept the wing but received a new fuselage, slimmer and much stronger, with an excellent rearward view and side doors opening upwards, so that the crew could observe or drop parachutists in flight with the doors open. Its engine not being ready, the 260 hp **Ivchenko AI-14R** radial was adopted: the Wilga 3 flew on 31 December 1965, then the wider-track **Wilga 35** on 29 June 1967. An all-aluminium cantilever high-wing monoplane, it has anti-stall slats and slotted flaps; its power and wing gave it a climb rate of 11 m/s when lightly loaded.\n\n## Operational career\nThe Wilga served mainly in civil hands, above all with the Polish Aero Club, whose backbone it long formed. The air arms that adopted it used it for training, liaison, recovery and light observation: the Polish Air Force flew 27 between 1971 and 1993, and a military liaison version, the **Wilga 35P**, flew from 1968. It also went to Egypt, Mongolia, the Baltic states and Paraguay, while Indonesia built it under licence as the **Gelatik**. In 1996 PZL offered an armed version with two hardpoints for border patrol and counter-insurgency, and the Polish Border Guard received **Wilga 2000** patrol aircraft.\n\n## Place in history\nAfter **EADS** bought the factory in 2001, production ended in November 2006, to the surprise of the company''s own dealers. With more than 1,000 built, around 935 of them Wilga 35s and 80s, the Wilga is the most-produced Polish aircraft in history. Its rights were sold in 2024 to Draco Aircraft, which plans to relaunch it in modernised form.',
    (SELECT id FROM countries WHERE code = 'POL'),
    NULL,
    '1962-04-24',
    '1963-01-01',
    195,
    670,
    (SELECT id FROM manufacturer WHERE code = 'PZLW'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL-104 Wilga'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'PZL-104 Wilga'), (SELECT id FROM tech WHERE name = 'Hypersustentation ADAC'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'PZL-104 Wilga'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'PZL-104 Wilga'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.1,
  wingspan          = 11.12,
  height            = 2.96,
  wing_area         = 15.5,
  empty_weight      = 900,
  mtow              = 1300,
  service_ceiling   = 4040,
  climb_rate        = 5.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-14RA (260 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 2006,
  units_built       = 1000,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 11,
  variants          = E'- **Wilga 2** : premier modèle de série, moteur à plat WN-6, une dizaine d''exemplaires\n- **Wilga C / Wilga 32** : versions à moteur Continental pour l''Indonésie, construites sous licence comme **Gelatik**\n- **Wilga 35** : version de grande série à moteur en étoile AI-14, premier vol le 29 juin 1967\n- **Wilga 35P** : version militaire de liaison et de transport de passagers, sans crochet de remorquage\n- **Wilga 2000** : moteur Lycoming, aile modifiée ; variante **PZL-104MF** de patrouille pour les garde-frontières polonais',
  variants_en       = E'- **Wilga 2**: first production model, WN-6 flat engine, about ten built\n- **Wilga C / Wilga 32**: Continental-engined versions for Indonesia, licence-built as the **Gelatik**\n- **Wilga 35**: mass-production version with the AI-14 radial, first flight on 29 June 1967\n- **Wilga 35P**: military liaison and passenger version, without towing hook\n- **Wilga 2000**: Lycoming engine, modified wing; **PZL-104MF** patrol variant for the Polish Border Guard',

  -- Strate 4 : qualitatif
  nickname          = 'Loriot',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/PZL-104_Wilga',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/PZL-104_Wilga',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bill Larkins',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'PZL-104 Wilga';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'PZL-104 Wilga';
