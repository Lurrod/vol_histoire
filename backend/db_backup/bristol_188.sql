-- Bristol Type 188
--
-- Photo : Bristol 188 (27352720863).jpg
--   licence CC BY 2.0 — Tony Hisgett from Birmingham, UK
--   https://commons.wikimedia.org/wiki/File:Bristol_188_(27352720863).jpg

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
    'Bristol 188',
    'Bristol 188',
    'Bristol Type 188',
    'Bristol Type 188',
    '« Crayon flamboyant » en acier inoxydable, construit pour étudier l''échauffement à Mach 2, trop gourmand pour y rester',
    'A stainless steel flaming pencil built to study heating at Mach 2, too thirsty to stay there for long',
    '/assets/airplanes/bristol-188.jpg',
    E'## Genèse\nLe Type 188 naît de la recherche menée pour l''**Avro 730**, un avion de reconnaissance et de bombardement capable de Mach 3 issu de l''Operational Requirement 330. Pour connaître les effets d''un vol prolongé à très grande vitesse, le ministère émet en février 1953 la spécification **ER.134T** : un banc d''essai volant dépassant Mach 2, capable d''y tenir assez longtemps pour étudier l''échauffement cinétique, avec une peau portée vers 300 °C. Le contrat est attribué à **Bristol** le même mois, même si la formule de l''avion n''est arrêtée qu''en 1955. L''Avro 730 est annulé en 1957, mais le 188 est poursuivi comme avion de recherche.\n\n## Conception\nL''avion est bâti en acier inoxydable à 12 % de chrome, en nid d''abeilles, laissé sans peinture. Plutôt que des rivets qu''il aurait fallu fabriquer spécialement, Bristol recourt au **soudage à l''arc sous argon**, avec l''aide d''**Armstrong Whitworth**, qui réalise de grandes sections de la cellule. Le cockpit reçoit un pare-brise en quartz fondu et une réfrigération, et une vaste baie abrite l''enregistrement et la télémesure. Les deux **Rolls-Royce Avon** prévus sont remplacés en 1957 par des **de Havilland Gyron Junior** à postcombustion à réglage continu, plus légers d''une demi-tonne chacun, mais qui limitent l''autonomie à 25 minutes environ.\n\n## Essais\nLe premier exemplaire volant, le XF923, décolle le 14 avril 1962, après des problèmes d''entrée d''air, et paraît au salon de Farnborough en septembre. Le XF926 vole à son tour le 26 avril 1963, avec les moteurs du XF923, puis rejoint le RAE à Bedford. En 51 vols, le 188 atteint Mach 1,88, soit 2 000 km/h, à 11 000 m, mais n''atteint jamais Mach 2 : les Gyron Junior consomment 70 % du carburant pour monter à l''altitude d''essai et pompent au-delà de Mach 1. Ajoutés aux fuites de carburant et à un décollage vers 480 km/h, ces défauts empêchent l''étude de la mise en température de la cellule. Le programme est arrêté début 1964, après un dernier vol le 12 janvier.\n\n## Place dans l''histoire\nAvec 20 millions de livres, le 188 est alors le programme d''avion de recherche le plus cher de l''histoire britannique. Ses résultats servent néanmoins au **Concorde** : faute de conclusion sur l''acier, celui-ci sera construit en alliages d''aluminium classiques, limités à Mach 2,2, et l''expérience du Gyron Junior aide à mettre au point l''**Olympus 593** du Concorde et du **BAC TSR-2**. Le XF926 est conservé au musée de la RAF à Cosford ; le XF923 a été ferraillé.',
    E'## Genesis\nThe Type 188 grew out of research for the **Avro 730**, a Mach 3 reconnaissance and bomber aircraft born of Operational Requirement 330. To learn the effects of sustained very high speed flight, the ministry issued Specification **ER.134T** in February 1953: a flying testbed able to exceed Mach 2 and stay there long enough to study kinetic heating, with its skin running at about 300 degrees C. The contract went to **Bristol** that same month, although the layout was only settled in 1955. The Avro 730 was cancelled in 1957, but the 188 continued as a research aircraft.\n\n## Design\nThe aircraft was built of 12 per cent chromium stainless steel with a honeycomb core, left unpainted. Rather than rivets that would have had to be specially made, Bristol used **argon-shielded arc welding**, helped by **Armstrong Whitworth**, which built major sections of the airframe. The cockpit had a fused-quartz windscreen and refrigeration, and a large bay housed the recording and telemetry equipment. The two planned **Rolls-Royce Avons** were replaced in 1957 by **de Havilland Gyron Juniors** with continuously variable reheat, half a ton lighter each, but limiting endurance to about 25 minutes.\n\n## Testing\nThe first flying aircraft, XF923, took off on 14 April 1962, after intake problems, and appeared at the Farnborough show in September. XF926 followed on 26 April 1963, using XF923''s engines, then joined the RAE at Bedford. In 51 flights the 188 reached Mach 1.88, or 2,000 km/h, at 11,000 m, but never reached Mach 2: the Gyron Juniors used 70 per cent of the fuel just to climb to test altitude and surged beyond Mach 1. Together with fuel leaks and a take-off speed of nearly 480 km/h, these flaws prevented any study of the airframe''s thermal soaking. The programme was halted in early 1964, after a last flight on 12 January.\n\n## Place in history\nAt 20 million pounds, the 188 was then the most expensive research aircraft programme in British history. Its results were nevertheless used for **Concorde**: with no firm conclusion on steel, it was built of conventional aluminium alloys, limited to Mach 2.2, and experience with the Gyron Junior helped develop the **Olympus 593** of Concorde and the **BAC TSR-2**. XF926 is preserved at the RAF Museum Cosford; XF923 was scrapped.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1953-02-01',
    '1962-04-14',
    NULL,
    2000,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BRI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol 188'), (SELECT id FROM tech WHERE name = 'Conception en acier inoxydable')),
((SELECT id FROM airplanes WHERE name = 'Bristol 188'), (SELECT id FROM tech WHERE name = 'Matériaux résistants à la chaleur')),
((SELECT id FROM airplanes WHERE name = 'Bristol 188'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol 188'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.67,
  wingspan          = 10.69,
  height            = 3.66,
  wing_area         = 36.8,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland DGJ.10R Gyron Junior',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 44.5,
  thrust_wet        = 62.3,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Cellule d''essais statiques** : premier exemplaire, livré au RAE de Farnborough en mai 1960 pour des essais à froid et à chaud\n- **XF923** : premier exemplaire volant, premier vol le 14 avril 1962, cannibalisé puis ferraillé à Foulness\n- **XF926** : second exemplaire volant, premier vol le 26 avril 1963, dernier vol le 12 janvier 1964, conservé à Cosford\n- **XK429, XK434, XK436** : trois exemplaires supplémentaires commandés pour l''Avro 730, annulés en 1957',
  variants_en       = E'- **Static test airframe**: first airframe, delivered to the RAE at Farnborough in May 1960 for heated and unheated tests\n- **XF923**: first flying aircraft, first flight on 14 April 1962, cannibalised and later scrapped at Foulness\n- **XF926**: second flying aircraft, first flight on 26 April 1963, last flight on 12 January 1964, preserved at Cosford\n- **XK429, XK434, XK436**: three further aircraft ordered for the Avro 730 programme, cancelled in 1957',

  -- Strate 4 : qualitatif
  nickname          = 'Flaming Pencil',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bristol_188',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bristol_188',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tony Hisgett',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Bristol 188';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bristol 188';
