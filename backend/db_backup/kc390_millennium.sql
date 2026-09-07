-- Embraer KC-390 Millennium
--
-- Photo : Embraer KC-390, Paris Air Show 2019, Le Bourget (SIAE0824).jpg
--   licence CC BY-SA 4.0 — Matti Blume
--   https://commons.wikimedia.org/wiki/File%3AEmbraer_KC-390%2C_Paris_Air_Show_2019%2C_Le_Bourget_%28SIAE0824%29.jpg

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
    'Embraer KC-390 Millennium',
    'Embraer KC-390 Millennium',
    'Embraer KC-390 Millennium',
    'Embraer KC-390 Millennium',
    'Premier transport à réaction sud-américain, transport et ravitailleur à la fois',
    'First South American jet transport, tanker and airlifter in one',
    '/assets/airplanes/kc390.jpg',
    E'## Genèse\nLe Brésil exploite des **C-130** achetés d''occasion, certains construits dans les années 1960, et doit les remplacer. Plutôt que d''en racheter, Embraer — qui a bâti sa réputation sur les avions régionaux — propose de concevoir le successeur brésilien du Hercules, et de le vendre au monde. Le pari est considérable pour une firme sans expérience du transport militaire lourd.\n\n## Conception\nLe choix décisif est le **réacteur plutôt que l''hélice** : deux V2500, empruntés à l''Airbus A320, donnent au KC-390 une vitesse de croisière supérieure de deux cents kilomètres-heure à celle d''un C-130J, et une soute plus vaste. Les commandes de vol sont **entièrement électriques**, une première sur un transport tactique, ce qui autorise des protections automatiques de domaine de vol en largage à très basse altitude. Le ravitaillement est natif : deux nacelles sous voilure, sans conversion ni matériel additionnel.\n\n## Carrière opérationnelle\nEn service depuis 2019, il ravitaille l''Antarctique brésilienne, largue en Amazonie, combat les incendies et transporte du fret humanitaire. Sa percée réelle est européenne : le **Portugal, la Hongrie, les Pays-Bas, l''Autriche et la Tchéquie** l''ont commandé entre 2019 et 2024, souvent contre le C-130J américain. La Suède et la Corée du Sud l''étudient.\n\n## Place dans l''histoire\nDouze exemplaires livrés à ce jour, mais un carnet de commandes qui dépasse la cinquantaine. C''est le premier avion de transport militaire à réaction conçu dans l''hémisphère sud, et le premier appareil sud-américain à disputer sérieusement un marché occidental à Lockheed. Il représente pour **Embraer** ce que le Tucano avait amorcé quarante ans plus tôt : l''entrée dans la cour des grands.',
    E'## Genesis\nBrazil operated second-hand **C-130s**, some built in the 1960s, and had to replace them. Rather than buy more, Embraer — which had built its reputation on regional airliners — proposed to design the Brazilian successor to the Hercules and sell it to the world. It was a considerable gamble for a firm with no experience of heavy military transport.\n\n## Design\nThe decisive choice is **jets rather than propellers**: two V2500s, borrowed from the Airbus A320, give the KC-390 a cruising speed two hundred kilometres an hour higher than a C-130J''s, and a larger hold. The flight controls are **fully fly-by-wire**, a first on a tactical transport, which allows automatic envelope protection during very low-level drops. Refuelling is native: two underwing pods, with no conversion or additional equipment.\n\n## Operational career\nIn service since 2019, it resupplies Brazilian Antarctica, drops in Amazonia, fights fires and carries humanitarian freight. Its real breakthrough is European: **Portugal, Hungary, the Netherlands, Austria and Czechia** ordered it between 2019 and 2024, often against the American C-130J. Sweden and South Korea are studying it.\n\n## Place in history\nTwelve delivered so far, but an order book past fifty. It is the first jet military transport designed in the southern hemisphere, and the first South American aircraft to seriously contest a Western market with Lockheed. For **Embraer** it represents what the Tucano began forty years earlier: entry into the front rank.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '2007-01-01',
    '2015-02-03',
    '2019-09-04',
    870.0,
    6019.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.2,
  wingspan          = 35.05,
  height            = 11.84,
  wing_area         = 132.0,
  empty_weight      = 36600,
  mtow              = 87000,
  service_ceiling   = 11000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2815,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'International Aero Engines V2500-E5',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 139.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2014,
  production_end    = NULL,
  units_built       = 12,
  unit_cost_usd     = 85000000,
  unit_cost_year    = 2022,
  operators_count   = 6,
  variants          = E'- **KC-390** : version unique, transport et ravitailleur sans conversion\n- Commandé par le **Brésil**, le Portugal, la Hongrie, les Pays-Bas, l''Autriche et la Tchéquie\n- Peut **ravitailler et être ravitaillé**, y compris d''un autre KC-390\n- Commandes de vol **entièrement électriques**, première sur un transport tactique\n- Version bombardier d''eau équipée d''un module largable de douze mille litres',
  variants_en       = E'- **KC-390** : single version, transport and tanker with no conversion\n- Ordered by **Brazil**, Portugal, Hungary, the Netherlands, Austria and Czechia\n- Can **refuel and be refuelled**, including from another KC-390\n- **Fully fly-by-wire** flight controls, a first on a tactical transport\n- Firefighting version fitted with a twelve-thousand-litre roll-on module',

  -- Strate 4 : qualitatif
  nickname          = 'Millennium',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Embraer_KC-390',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Embraer_C-390_Millennium',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Matti Blume',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Embraer KC-390 Millennium';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Embraer KC-390 Millennium';
