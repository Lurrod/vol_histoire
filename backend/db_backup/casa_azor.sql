-- CASA C-207 Azor
--
-- Photo : CASA C-207C Azor Spanish Air Force T.7-17 405-17 (8740173217).jpg
--   licence CC BY 2.0 — Curimedia
--   https://commons.wikimedia.org/wiki/File:CASA_C-207C_Azor_Spanish_Air_Force_T.7-17_405-17_(8740173217).jpg

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
    'CASA C-207 Azor',
    'CASA C-207 Azor',
    'CASA C-207 Azor',
    'CASA C-207 Azor',
    'L''avion de ligne espagnol sans clients devenu transport et avion de parachutage de l''armée de l''Air',
    'The Spanish airliner without customers that became an air force transport and paradrop aircraft',
    '/assets/airplanes/casa-c207-azor.jpg',
    E'## Genèse\nDans les années 1950, l''armée de l''Air espagnole transporte encore ses hommes et son matériel sur des **CASA 2.111**, des Heinkel He 111 construits sous licence, et sur des CASA 352, version espagnole du Junkers Ju 52. **CASA** cherche à les remplacer, mais ses premiers bimoteurs de transport, les C-201 Alcotán et C-202 Halcón, souffrent de moteurs trop faibles et sont abandonnés. Le C-207 Azor, version agrandie du Halcón, est d''abord pensé pour les lignes court et moyen-courriers d''Espagne et d''Europe ; son prototype vole le 28 septembre 1955.\n\n## Conception\nL''Azor est un bimoteur propulsé par deux moteurs en étoile britanniques **Bristol Hercules 730** de 2 040 ch. Avec un équipage de quatre, il emporte quarante passagers ou quatre tonnes de fret, croise à 400 km/h et franchit 2 350 km. La version de transport tactique C-207C se distingue par de grandes portes cargo à l''arrière du fuselage et accueille 37 parachutistes. Deux appareils de la première série reçoivent à titre expérimental des moteurs américains **Pratt & Whitney Double Wasp**, sans suite.\n\n## Carrière opérationnelle\nAucune compagnie ne le commande : jugé dépassé et peu économique face aux avions disponibles, l''Azor est réorienté vers l''**armée de l''Air espagnole**, qui souhaite un transport moderne. Elle en commande dix, désignés T.7A, qui entrent en service en 1960, puis dix autres configurés pour le parachutage et le fret, les C-207C ou T.7B. Avec les deux prototypes, intégrés eux aussi aux unités, vingt-deux Azor servent jusqu''au début des années 1980, la plupart au sein de la 35e escadre de transport.\n\n## Place dans l''histoire\nL''Azor est l''un des premiers avions conçus par CASA pour remplacer les transports d''origine allemande de l''armée de l''Air espagnole. Arrivé tard et jugé dépassé dès sa sortie, il ne connaît pas de suite : la version à turbopropulseurs étudiée avec l''allemand **Hamburger Flugzeugbau** est abandonnée, CASA disposant bientôt du **C-212 Aviocar**. Cinq Azor sont aujourd''hui exposés, dont deux au musée de l''Air de Cuatro Vientos, à Madrid.',
    E'## Genesis\nIn the 1950s the Spanish Air Force still moved its men and equipment in **CASA 2.111s**, licence-built Heinkel He 111s, and CASA 352s, the Spanish version of the Junkers Ju 52. **CASA** sought to replace them, but its first twin-engined transports, the C-201 Alcotán and C-202 Halcón, suffered from underpowered engines and were cancelled. The C-207 Azor, a scaled-up Halcón, was first conceived for the short- and medium-haul routes of Spain and Europe; its prototype flew on 28 September 1955.\n\n## Design\nThe Azor was a twin powered by two 2,040 hp British **Bristol Hercules 730** radial engines. With a crew of four it carried forty passengers or four tonnes of cargo, cruised at 400 km/h and had a range of 2,350 km. The C-207C tactical transport version stood out for its large cargo doors in the rear fuselage and held 37 paratroopers. Two aircraft of the first batch were experimentally fitted with American **Pratt & Whitney Double Wasp** engines, without follow-up.\n\n## Operational career\nNo airline ordered it: judged obsolete and uneconomical against the aircraft available, the Azor was redirected to the **Spanish Air Force**, which wanted a modern transport. It ordered ten, designated T.7A, which entered service in 1960, then ten more configured for paratroop and cargo transport, the C-207C or T.7B. Together with the two prototypes, which also joined the units, twenty-two Azors served until the early 1980s, most of them with the 35th Transport Wing.\n\n## Place in history\nThe Azor was one of the first aircraft designed by CASA to replace the Spanish Air Force''s German-designed transports. Arriving late and judged obsolete from the outset, it had no successor of its own: the turboprop version studied with Germany''s **Hamburger Flugzeugbau** was dropped, as CASA soon had the **C-212 Aviocar**. Five Azors are on display today, two of them at the Museo del Aire at Cuatro Vientos, Madrid.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    NULL,
    '1955-09-28',
    '1960-01-01',
    420,
    2350,
    (SELECT id FROM manufacturer WHERE code = 'CASA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-207 Azor'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA C-207 Azor'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'CASA C-207 Azor'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.85,
  wingspan          = 27.8,
  height            = 7.75,
  wing_area         = 85.8,
  empty_weight      = 10600,
  mtow              = 16500,
  service_ceiling   = 8000,
  climb_rate        = 5.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Hercules 730 (2 040 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1967,
  units_built       = 22,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **C-207A** : les deux prototypes, versés ensuite à l''armée de l''Air\n- **C-207B (T.7A)** : transport de quarante passagers ou quatre tonnes de fret, dix exemplaires, dont deux essayés avec des moteurs Pratt & Whitney Double Wasp\n- **C-207C (T.7B)** : grandes portes cargo à l''arrière du fuselage, 37 parachutistes, dix exemplaires\n- **Version à turbopropulseurs** : proposée avec Hamburger Flugzeugbau, abandonnée au profit du C-212 Aviocar',
  variants_en       = E'- **C-207A**: the two prototypes, later taken on by the air force\n- **C-207B (T.7A)**: transport for forty passengers or four tonnes of cargo, ten built, two of them tested with Pratt & Whitney Double Wasp engines\n- **C-207C (T.7B)**: large rear-fuselage cargo doors, 37 paratroopers, ten built\n- **Turboprop version**: offered with Hamburger Flugzeugbau, dropped in favour of the C-212 Aviocar',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CASA_C-207_Azor',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASA_C-207_Azor',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Curimedia',
  image_licence     = 'CC BY 2.0'
WHERE name = 'CASA C-207 Azor';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASA C-207 Azor';
