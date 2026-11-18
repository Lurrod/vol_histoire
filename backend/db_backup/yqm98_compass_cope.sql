-- Teledyne Ryan YQM-98A Compass Cope R
--
-- Photo : Ryan Compass Cope Pima.JPG
--   licence CC BY-SA 3.0 — YSSYguy
--   https://commons.wikimedia.org/wiki/File:Ryan_Compass_Cope_Pima.JPG

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
    'Teledyne Ryan YQM-98 Compass Cope',
    'Teledyne Ryan YQM-98 Compass Cope',
    'Teledyne Ryan YQM-98A Compass Cope R',
    'Teledyne Ryan YQM-98A Compass Cope R',
    'Héritier à aile droite du Firefly, jugé meilleur sur certains points mais battu au prix par Boeing',
    'Straight-winged heir to the Firefly, judged better in some respects but beaten on price by Boeing',
    '/assets/airplanes/yqm98-compass-cope.jpg',
    E'## Genèse\nLancé par l''US Air Force en 1971, le programme **Compass Cope** doit fournir un drone de reconnaissance qui décolle et se pose sur piste comme un avion piloté et reste jusqu''à 24 heures en haute altitude, pour la surveillance, le relais de communications ou le prélèvement atmosphérique. **Boeing** en est d''abord le seul titulaire avec son **YQM-94**. **Ryan Aeronautical** propose alors une alternative, et l''Air Force lui commande l''année suivante deux démonstrateurs YQM-98A, plus tard redésignés YGQM-98A, sous le nom de Compass Cope R.\n\n## Conception\nLe **Model 235** de Ryan est une version modernisée du Model 154, l''**AQM-91 Firefly** conçu pour espionner la Chine, dont il garde un air de famille évident, mais avec une aile droite au lieu d''une aile en flèche. Sa formule rejoint celle de son concurrent : un planeur à réaction à double dérive, train tricycle rétractable et moteur dans une nacelle dorsale. L''aile de 24,75 m d''envergure atteint un allongement de 19, et le moteur est un turboréacteur double flux Garrett YF104-GA-100 de 18 kN. Selon le Jane''s de 1976-1977, qui ne donne que des performances estimées, il devait tenir 30 heures en vol à Mach 0,6.\n\n## Essais\nLe premier Compass Cope R prend l''air le 17 août 1974, plus d''un an après le premier YQM-94 de Boeing. Les évaluations comparatives montrent que le drone de Ryan est supérieur à son rival sur certains points. En août 1976 pourtant, l''Air Force donne la victoire à Boeing, moins cher, et lui confie la construction de prototypes de présérie du YQM-94B opérationnel. Ryan conteste aussitôt l''attribution du marché.\n\n## Place dans l''histoire\nLa contestation reste sans effet : en juillet 1977, l''ensemble du programme Compass Cope est annulé, apparemment à cause des difficultés de mise au point des capteurs. Le YQM-98 n''en prolonge pas moins une lignée : il transpose sur un drone qui décolle d''une piste les leçons du Firefly, que l''on devait larguer d''un DC-130 et récupérer par hélicoptère. Un YQM-98A a été exposé sans son moteur, en plein air, au **Pima Air & Space Museum** de Tucson, en Arizona.',
    E'## Genesis\nLaunched by the US Air Force in 1971, the **Compass Cope** programme was to provide a reconnaissance drone that could take off and land from a runway like a manned aircraft and stay at high altitude for up to 24 hours, for surveillance, communications relay or atmospheric sampling. **Boeing** was initially sole contractor with its **YQM-94**. **Ryan Aeronautical** then pitched an alternative, and the following year the Air Force ordered two YQM-98A demonstrators from it, later redesignated YGQM-98A, under the name Compass Cope R.\n\n## Design\nRyan''s **Model 235** was an updated version of the Model 154, the **AQM-91 Firefly** designed to spy on China, with which it shared an obvious family likeness, but with straight wings instead of swept ones. Its layout matched that of its competitor: a jet sailplane with twin fins, retractable tricycle landing gear and an engine in a pod on its back. The 24.75 m wing had an aspect ratio of 19, and the engine was an 18 kN Garrett YF104-GA-100 turbofan. According to Jane''s 1976-77, which only gives estimated performance, it was to stay aloft for 30 hours at Mach 0.6.\n\n## Testing\nThe first Compass Cope R flew on 17 August 1974, more than a year after Boeing''s first YQM-94. Comparative evaluation showed Ryan''s drone to be superior to its rival in some respects. Yet in August 1976 the Air Force gave victory to Boeing on lower cost and awarded it a contract for preproduction prototypes of the operational YQM-94B. Ryan promptly challenged the award.\n\n## Place in history\nThe challenge did no good: in July 1977 the entire Compass Cope programme was cancelled, apparently because of difficulties developing sensor payloads. The YQM-98 nonetheless extended a lineage, carrying the lessons of the Firefly, which had to be launched from a DC-130 and recovered by helicopter, over to a drone that took off from a runway. One YQM-98A was displayed outdoors without its engine at the **Pima Air & Space Museum** in Tucson, Arizona.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1972-01-01',
    '1974-08-17',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Teledyne Ryan YQM-98 Compass Cope'), (SELECT id FROM tech WHERE name = 'Conception aérodynamique pour haute altitude')),
((SELECT id FROM airplanes WHERE name = 'Teledyne Ryan YQM-98 Compass Cope'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Teledyne Ryan YQM-98 Compass Cope'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.68,
  wingspan          = 24.75,
  height            = 2.44,
  wing_area         = 32.24,
  empty_weight      = 2540,
  mtow              = 6490,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett YF104-GA-100',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 18.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 235** : désignation Ryan, version modernisée à aile droite du Model 154 Firefly\n- **YQM-98A Compass Cope R** : deux démonstrateurs commandés par l''US Air Force, premier vol le 17 août 1974\n- **YGQM-98A** : nouvelle désignation des démonstrateurs\n- **R-Tern** : surnom du drone, son concurrent de Boeing étant surnommé B-Gull',
  variants_en       = E'- **Model 235**: Ryan designation, a straight-winged update of the Model 154 Firefly\n- **YQM-98A Compass Cope R**: two demonstrators ordered by the US Air Force, first flight on 17 August 1974\n- **YGQM-98A**: later designation of the demonstrators\n- **R-Tern**: the drone''s nickname, its Boeing competitor being nicknamed B-Gull',

  -- Strate 4 : qualitatif
  nickname          = 'R-Tern',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_YQM-98_R-Tern',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'YSSYguy',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Teledyne Ryan YQM-98 Compass Cope';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Teledyne Ryan YQM-98 Compass Cope';
