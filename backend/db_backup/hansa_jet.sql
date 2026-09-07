-- HFB 320 Hansa Jet
--
-- Photo : HFB 320 Hansa Jet ECM beim MHM Berlin-Gatow (2019).jpg
--   licence CC BY-SA 4.0 — JoachimKohler-HB
--   https://commons.wikimedia.org/wiki/File%3AHFB_320_Hansa_Jet_ECM_beim_MHM_Berlin-Gatow_%282019%29.jpg

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
    'HFB 320 Hansa Jet',
    'HFB 320 Hansa Jet',
    'HFB 320 Hansa Jet',
    'HFB 320 Hansa Jet',
    'Le seul avion d’affaires à réaction à aile inversée jamais produit',
    'The only forward-swept-wing business jet ever built',
    '/assets/airplanes/hansa-jet.jpg',
    E'## Genèse\nL''Allemagne fédérale des années 1960 retrouve le droit de concevoir des avions et **Hamburger Flugzeugbau** veut y revenir par le marché naissant de l''aviation d''affaires. Le cahier des charges pose un problème géométrique : sur un biréacteur à moteurs en queue, le longeron d''aile traverse la cabine à l''endroit exact où les passagers voudraient s''asseoir.\n\n## Conception\nLa solution retenue est audacieuse : **incliner l''aile vers l''avant** de quinze degrés, ce qui recule le longeron derrière la cabine. La flèche inversée pose les problèmes connus de divergence aéroélastique, mais à cette faible valeur et à cette vitesse, une structure renforcée suffit — vingt ans avant que le **X-29** ne s''y attaque au composite.\n\n## Carrière opérationnelle\nQuarante-sept exemplaires seulement, le marché civil ayant préféré les Learjet américains. La **Luftwaffe** en récupère seize : huit pour la liaison et **huit convertis en brouilleurs**, chargés de simuler l''agression électronique lors des exercices de l''OTAN jusqu''en 1994.\n\n## Place dans l''histoire\nQuarante-sept exemplaires. Le Hansa Jet reste **le seul appareil de série à aile en flèche inversée**, toutes catégories confondues — le X-29 et le Su-47 étant restés des prototypes. C''est aussi le premier avion à réaction allemand de l''après-guerre, quatre ans avant le **VJ 101**.',
    E'## Genesis\nWest Germany in the 1960s regained the right to design aircraft, and **Hamburger Flugzeugbau** wanted to return through the emerging business aviation market. The requirement posed a geometric problem: on a rear-engined twin, the wing spar crosses the cabin exactly where passengers would like to sit.\n\n## Design\nThe chosen solution is audacious: **sweep the wing forward** fifteen degrees, which moves the spar behind the cabin. Forward sweep brings the known problems of aeroelastic divergence, but at that small angle and that speed a strengthened structure suffices — twenty years before the **X-29** attacked the problem with composites.\n\n## Operational career\nOnly forty-seven built, the civil market having preferred American Learjets. The **Luftwaffe** took sixteen: eight for liaison and **eight converted into jammers**, tasked with simulating electronic attack in NATO exercises until 1994.\n\n## Place in history\nForty-seven built. The Hansa Jet remains **the only production aircraft with a forward-swept wing**, in any category — the X-29 and Su-47 having stayed prototypes. It is also the first post-war German jet aircraft, four years before the **VJ 101**.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1961-01-01',
    '1964-04-21',
    '1967-01-01',
    825.0,
    2370.0,
    (SELECT id FROM manufacturer WHERE code = 'HFB'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Guerre électronique'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'HFB 320 Hansa Jet'), (SELECT id FROM tech WHERE name = 'Aile en flèche inversée')),
((SELECT id FROM airplanes WHERE name = 'HFB 320 Hansa Jet'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'HFB 320 Hansa Jet'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'HFB 320 Hansa Jet'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'HFB 320 Hansa Jet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.61,
  wingspan          = 14.49,
  height            = 4.94,
  wing_area         = 30.14,
  empty_weight      = 5425,
  mtow              = 9200,
  service_ceiling   = 11580,
  climb_rate        = 20.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CJ610-9',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = 1973,
  units_built       = 47,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **HFB 320** : version civile d''affaires, onze passagers\n- **HFB 320 ECM** : version de guerre électronique de la **Luftwaffe**, huit exemplaires\n- **HFB 320 MPA** : projet de patrouille maritime, resté sans suite\n- **Aile en flèche inversée** de 15° : choisie pour dégager la cabine du longeron\n- Premier avion à réaction conçu en Allemagne depuis 1945',
  variants_en       = E'- **HFB 320** : civil business version, eleven passengers\n- **HFB 320 ECM** : **Luftwaffe** electronic warfare version, eight aircraft\n- **HFB 320 MPA** : proposed maritime patrol version, never pursued\n- **Forward-swept wing** of 15°: chosen to clear the cabin of the wing spar\n- The first jet aircraft designed in Germany since 1945',

  -- Strate 4 : qualitatif
  nickname          = 'Hansa Jet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/HFB_320_Hansa_Jet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/HFB_320_Hansa_Jet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'JoachimKohler-HB',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'HFB 320 Hansa Jet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'HFB 320 Hansa Jet';
