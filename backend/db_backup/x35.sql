-- Lockheed Martin X-35 JSF
--
-- Photo : X-35B Edwards.jpg
--   licence Public domain — U.S. Air Force - Tom Reynolds
--   https://commons.wikimedia.org/wiki/File:X-35B_Edwards.jpg

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
    'Lockheed Martin X-35',
    'Lockheed Martin X-35',
    'Lockheed Martin X-35 JSF',
    'Lockheed Martin X-35 JSF',
    'Démonstrateur du Joint Strike Fighter, vainqueur du X-32 grâce à sa soufflante de sustentation, devenu le F-35',
    'The Joint Strike Fighter demonstrator that beat the X-32 thanks to its lift fan, and became the F-35',
    '/assets/airplanes/x35b.jpg',
    E'## Genèse\nLe programme **Joint Strike Fighter** naît de plusieurs besoins de chasseur commun, dont le programme **CALF**, et vise à remplacer de nombreux appareils tout en contenant les coûts de développement, de production et d''exploitation. La recette : trois versions d''un même avion partageant plus de 70 % de leurs pièces, une classique pour l''US Air Force, une à décollage court et atterrissage vertical pour les Marines et les Britanniques, une embarquée pour l''US Navy. Le contrat de développement est signé le 16 novembre 1996, et **Lockheed Martin** et **Boeing** construisent chacun deux démonstrateurs.\n\n## Conception\nLe X-35 reprend des éléments du **F-22 Raptor**, et sa tuyère orientable à trois paliers doit beaucoup au Convair Model 200 de 1972 ; Lockheed a aussi acheté en 1991 les données de celle du **Yak-141**. Sa pièce maîtresse est la **soufflante de sustentation** brevetée par **Paul Bevilaqua** et développée par **Rolls-Royce** : un arbre prélève la puissance du réacteur **Pratt & Whitney JSF119-PW-611**, dérivé du F119, pour entraîner une soufflante contrarotative verticale placée derrière le cockpit. Avec la tuyère principale orientée vers le bas et deux buses de roulis dans les ailes, elle permet le vol stationnaire en soufflant un air frais, moins agressif pour les pistes et les ponts.\n\n## Essais\nLe X-35A vole le 24 octobre 2000 à Edwards pour évaluer les performances et la maniabilité. Après 28 vols, il est transformé en **X-35B**, qui reçoit la soufflante, la tuyère orientable et les buses de roulis. Le 20 juillet 2001, le X-35B décolle en moins de 150 m, passe en supersonique et se pose à la verticale. Le **X-35C**, à voilure agrandie, vole le 16 décembre 2000 et simule les appontages. Le 26 octobre 2001, le X-35 est déclaré vainqueur du **Boeing X-32**, et Lockheed Martin obtient le contrat de développement du F-35.\n\n## Place dans l''histoire\nL''avion de série diffère peu du démonstrateur : fuselage avant allongé de 13 cm pour l''avionique, entrée d''air sans séparateur à trois côtés au lieu de quatre, fuselage plus plein pour les soutes. Les trois versions deviennent les F-35A, B et C, et le **F-35 Lightning II** entre en production au début du XXIe siècle. Le X-35B est exposé au Steven F. Udvar-Hazy Center près de Washington, le X-35C au musée de l''aéronavale de Patuxent River.',
    E'## Genesis\nThe **Joint Strike Fighter** programme grew out of several requirements for a common fighter, including the **CALF** programme, and aimed to replace many aircraft while holding down development, production and operating costs. The formula: three versions of one aircraft sharing over 70 per cent of their parts, a conventional one for the US Air Force, a short take-off and vertical landing one for the Marines and the British, and a carrier one for the US Navy. The development contract was signed on 16 November 1996, and **Lockheed Martin** and **Boeing** each built two demonstrators.\n\n## Design\nThe X-35 drew on the **F-22 Raptor**, and its three-bearing swivel nozzle owed much to the 1972 Convair Model 200; Lockheed also bought the data of the **Yak-141**''s nozzle in 1991. Its centrepiece was the **shaft-driven lift fan** patented by **Paul Bevilaqua** and developed by **Rolls-Royce**: a shaft took power from the **Pratt & Whitney JSF119-PW-611** engine, derived from the F119, to drive a vertical contra-rotating fan behind the cockpit. With the main nozzle swivelled down and two roll posts in the wings, it allowed hovering while blowing cooler air, less damaging to runways and decks.\n\n## Testing\nThe X-35A flew on 24 October 2000 at Edwards to assess performance and handling. After 28 flights it was converted into the **X-35B**, which received the lift fan, the swivelling nozzle and the roll posts. On 20 July 2001 the X-35B took off in less than 150 m, went supersonic and landed vertically. The larger-winged **X-35C** flew on 16 December 2000 and simulated carrier landings. On 26 October 2001 the X-35 was declared the winner over the **Boeing X-32**, and Lockheed Martin received the F-35 development contract.\n\n## Place in history\nThe production aircraft differs little from the demonstrator: a forward fuselage lengthened by 13 cm for avionics, a three-sided diverterless inlet instead of four, and a fuller fuselage for the weapons bays. The three versions became the F-35A, B and C, and the **F-35 Lightning II** entered production early in the 21st century. The X-35B is displayed at the Steven F. Udvar-Hazy Center near Washington, the X-35C at the Patuxent River Naval Air Museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1996-11-16',
    '2000-10-24',
    NULL,
    1590,
    2200,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-35'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-35'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-35'), (SELECT id FROM tech WHERE name = 'Soufflante de sustentation'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-35'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-35'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-35'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.4,
  wingspan          = 10.05,
  height            = 4.05,
  wing_area         = 41.8,
  empty_weight      = 12020,
  mtow              = 22680,
  service_ceiling   = 15240,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney JSF119-PW-611',
  engine_count      = 1,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 111.2,
  thrust_wet        = 177.9,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **X-35A** : version classique, premier vol le 24 octobre 2000, 28 vols avant sa transformation\n- **X-35B** : le X-35A équipé de la soufflante de sustentation, de la tuyère orientable et des buses de roulis ; exposé au Udvar-Hazy Center\n- **X-35C** : version embarquée à voilure et gouvernes agrandies, premier vol le 16 décembre 2000 ; exposée à Patuxent River\n- **Moteur JSF119-PW-611** : dérivé du F119, couplé à la soufflante Rolls-Royce sur le X-35B',
  variants_en       = E'- **X-35A**: conventional version, first flight on 24 October 2000, 28 flights before its conversion\n- **X-35B**: the X-35A fitted with the lift fan, swivelling nozzle and roll posts; displayed at the Udvar-Hazy Center\n- **X-35C**: carrier version with larger wing and control surfaces, first flight on 16 December 2000; displayed at Patuxent River\n- **JSF119-PW-611 engine**: derived from the F119, coupled to the Rolls-Royce lift fan on the X-35B',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_X-35',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_Martin_X-35',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tom Reynolds, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed Martin X-35';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Lockheed Martin X-35';
