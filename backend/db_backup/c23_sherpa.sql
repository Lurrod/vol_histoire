-- Short C-23 Sherpa
--
-- Photo : C-23A Sherpa in flight over Rhine valley 1988.JPEG
--   licence Public domain — Camera Operator: MSgt. Bill Thompson, USAF
--   https://commons.wikimedia.org/wiki/File:C-23A_Sherpa_in_flight_over_Rhine_valley_1988.JPEG

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
    'Short C-23 Sherpa',
    'Short C-23 Sherpa',
    'Short C-23 Sherpa',
    'Short C-23 Sherpa',
    'La « boîte à chaussures » volante qui ravitaillait les bases américaines d''Europe, puis la Garde nationale',
    'The flying shoebox that resupplied US bases in Europe, then served the Army National Guard',
    '/assets/airplanes/c23-sherpa.jpg',
    E'## Genèse\nAu début des années 1980, l''**US Air Force** cherche un petit cargo pour relier ses bases d''Europe occidentale et y livrer surtout des pièces d''avion : c''est le programme **EDSA** (European Distribution System Aircraft). **Short Brothers**, à Belfast, part de son avion de ligne **Short 330**, lui-même dérivé du Skyvan, et en tire en 1981 une version cargo militaire. Ce **Sherpa** vole pour la première fois le 23 décembre 1982 et l''emporte sur le **CASA C-212 Aviocar** : l''US Air Force en commande 18 en mars 1983.\n\n## Conception\nLe Sherpa garde le fuselage à section carrée de la famille Short : une soute de 1,98 m de large et de haut sur 8,84 m de long, soit près de 35 m³ et 3,6 t de fret. Sa nouveauté est une **rampe arrière sur toute la largeur**, logée entre les deux dérives, complétée par un plancher renforcé à rouleaux et une porte cargo avant. Deux turbopropulseurs **Pratt & Whitney Canada PT6A-45R** et une aile de près de 23 m d''envergure lui permettent d''opérer depuis des pistes non revêtues. Le **C-23B** ajoute des hublots, un train renforcé et des portes de parachutage.\n\n## Carrière opérationnelle\nLe **C-23A** entre en service en 1985 à Zweibrücken, en Allemagne de l''Ouest, et assure la navette entre les bases de l''USAFE jusqu''en novembre 1990, quand la fin de la guerre froide réduit les forces. Les Sherpa repartent alors vers l''US Army, l''école des pilotes d''essai d''Edwards et le Service des forêts. L''**US Army** et sa **Garde nationale** deviennent les grands utilisateurs : 16 C-23B neufs, puis 28 **Short 360** d''occasion convertis en **C-23B+** avec la queue et la rampe du Sherpa. Pendant la **guerre d''Irak**, le C-23 transporte une vingtaine d''hommes ou trois palettes à l''intérieur du théâtre. Le 3 mars 2001, un C-23B de la Garde nationale de Floride se disloque en vol en Géorgie : 21 morts, la pire catastrophe aérienne de la Garde nationale en temps de paix.\n\n## Place dans l''histoire\nL''**Alenia C-27J Spartan**, choisi en 2007 pour lui succéder, part finalement à la Garde côtière en 2012 ; le Sherpa quitte la Garde nationale en janvier 2014 avec une réputation de bête de somme, notamment en secours aux sinistrés. Une soixantaine d''appareils ont servi les forces américaines. Les survivants passent au Service des forêts, à la NASA, qui en fait un laboratoire atmosphérique, et à l''étranger : il vole encore dans l''armée philippine et l''armée de l''Air de Djibouti. En 2024, **De Havilland Canada** étudie même son retour en production.',
    E'## Genesis\nIn the early 1980s the **US Air Force** wanted a small freighter to link its Western European bases and deliver, above all, aircraft parts: the **EDSA** (European Distribution System Aircraft) programme. **Short Brothers** of Belfast started from its **Short 330** airliner, itself derived from the Skyvan, and drew a military cargo version from it. This **Sherpa** first flew on 23 December 1982 and beat the **CASA C-212 Aviocar**: the US Air Force ordered 18 in March 1983.\n\n## Design\nThe Sherpa kept the square-section fuselage of the Short family: a hold 1.98 m wide and high and 8.84 m long, giving nearly 35 m³ and 3.6 tonnes of cargo. Its novelty was a **full-width rear ramp** set between the twin fins, together with a strengthened roller floor and a forward cargo door. Two **Pratt & Whitney Canada PT6A-45R** turboprops and a wing spanning almost 23 m let it operate from unpaved strips. The **C-23B** added cabin windows, stronger landing gear and paratroop doors.\n\n## Operational career\nThe **C-23A** entered service in 1985 at Zweibrücken, West Germany, shuttling between USAFE bases until November 1990, when the end of the Cold War cut the force. The Sherpas then went to the US Army, the Edwards Test Pilot School and the Forest Service. The **US Army** and its **National Guard** became the main users: 16 new C-23Bs, then 28 second-hand **Short 360s** converted to **C-23B+** with the Sherpa''s tail and ramp. During the **Iraq War** the C-23 carried some twenty people or three pallets within the theatre. On 3 March 2001 a Florida National Guard C-23B broke up in flight over Georgia, killing 21: the National Guard''s worst peacetime air disaster.\n\n## Place in history\nThe **Alenia C-27J Spartan**, selected in 2007 to succeed it, ended up with the Coast Guard in 2012; the Sherpa left the National Guard in January 2014 with a reputation as a workhorse, notably in disaster relief. Around sixty aircraft served the US forces. Survivors went to the Forest Service, to NASA, which uses one as an atmospheric laboratory, and abroad: it still flies with the Philippine Army and the Djibouti Air Force. In 2024 **De Havilland Canada** even studied returning it to production.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1981-01-01',
    '1982-12-23',
    '1985-01-01',
    467,
    2195,
    (SELECT id FROM manufacturer WHERE code = 'SHO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Short C-23 Sherpa'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Short C-23 Sherpa'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Short C-23 Sherpa'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Short C-23 Sherpa'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Short C-23 Sherpa'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.69,
  wingspan          = 22.76,
  height            = 4.95,
  wing_area         = 42.1,
  empty_weight      = 6680,
  mtow              = 10387,
  service_ceiling   = NULL,
  climb_rate        = 6.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-45R (1 198 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1984,
  production_end    = 1997,
  units_built       = 60,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **C-23A** : version de l''US Air Force pour le programme EDSA, plancher à rouleaux, porte cargo avant et rampe arrière ; 18 construits\n- **C-23B** : version de la Garde nationale de l''US Army, avec hublots, train renforcé, portes de parachutage et rampe en deux parties ; 16 construits\n- **C-23B+ Super Sherpa** : Short 360 d''occasion dont la dérive unique est remplacée par la queue bidérive et la rampe du Sherpa ; 28 convertis\n- **C-23C** : C-23B et B+ dotés d''une nouvelle avionique de poste de pilotage ; 43 modifiés\n- **C-23D** : C-23C à avionique de sécurité modernisée à partir de 2010, programme interrompu après 4 appareils',
  variants_en       = E'- **C-23A**: US Air Force version for the EDSA programme, with roller floor, forward cargo door and rear ramp; 18 built\n- **C-23B**: Army National Guard version with cabin windows, stronger landing gear, paratroop doors and a two-section ramp; 16 built\n- **C-23B+ Super Sherpa**: second-hand Short 360s whose single fin was replaced by the Sherpa''s twin tail and ramp; 28 converted\n- **C-23C**: C-23Bs and B+s fitted with new flight-deck avionics; 43 modified\n- **C-23D**: C-23Cs with upgraded safety avionics from 2010, programme stopped after 4 aircraft',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Short_C-23_Sherpa',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Short_C-23_Sherpa',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'MSgt. Bill Thompson, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Short C-23 Sherpa';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Short C-23 Sherpa';
