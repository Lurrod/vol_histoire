-- Convair Model 48 Charger
--
-- Photo : 23 0070668 Convair Negative Image - Convair Model 48 production (54222727303).jpg
--   licence Public domain — San Diego Air & Space Museum Archives
--   https://commons.wikimedia.org/wiki/File:23_0070668_Convair_Negative_Image_-_Convair_Model_48_production_(54222727303).jpg

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
    'Convair Model 48 Charger',
    'Convair Model 48 Charger',
    'Convair Model 48 Charger',
    'Convair Model 48 Charger',
    'Bipoutre de contre-insurrection à décollage court, battu par l''OV-10 Bronco et dernier avion complet de Convair',
    'Twin-boom STOL counter-insurgency aircraft beaten by the OV-10 Bronco, and the last complete Convair aircraft',
    '/assets/airplanes/convair-charger.jpg',
    E'## Genèse\nEn 1959, deux officiers du **Corps des Marines** imaginent un petit avion bon marché capable d''appuyer la troupe en opérant depuis des routes proches du front : c''est le concept **L2VMA**, pour Light Light Marine Attack Aircraft. L''US Army s''intéressant à un appareil semblable, la division Convair de **General Dynamics** lance en 1961 ses propres études d''avion de contre-insurrection. En 1963, les besoins fusionnent dans un programme interarmées, le **LARA** (Light Armed Reconnaissance Aircraft), destiné aussi à l''US Air Force pour la contre-insurrection et le contrôle aérien avancé, et ouvert à l''exportation. Neuf constructeurs répondent ; Convair remet son Model 48 Charger en mars 1964.\n\n## Conception\nLe Charger est un bipoutre à deux turbopropulseurs **Pratt & Whitney Canada PT6**, désignés T74 par les militaires, construit en aluminium avec nez, fuselage arrière et saumons en fibre de verre. Son aile courte place presque toute la voilure dans le souffle des hélices : volets à fente sur toute l''envergure et becs de bord d''attaque défléchissent ce souffle, une forme de poussée orientée qui raccourcit décollages et atterrissages. Pilote et observateur sont assis en tandem ; la soute arrière, fermée par un cône de queue articulé, emporte 910 kg de fret ou cinq parachutistes très à l''étroit. Quatre mitrailleuses de 7,62 mm et 910 kg de charges sous l''aile et le fuselage composent l''armement, et deux flotteurs peuvent être montés.\n\n## Essais\nEn août 1964, l''US Navy désigne vainqueur le NA-300 de **North American**, futur **OV-10 Bronco**. Le Corps des Marines et l''US Air Force, qui préféraient le Charger, protestent, et Convair achève le prototype commencé sur ses fonds propres. Il vole le 25 novembre 1964. Après les premiers essais, l''envergure est agrandie et l''empennage modifié pour améliorer le contrôle à basse vitesse. L''avion franchit un obstacle de 15 m après 148 m de roulage, mieux que les 244 m exigés et mieux que le Bronco. Un contrat d''essais de 100 heures est accordé, avec des pilotes des quatre armées, mais il s''écrase lors de son 196e vol, le 19 octobre 1965, sur une erreur de son pilote de l''US Navy.\n\n## Place dans l''histoire\nLe développement est abandonné après l''accident. Seul exemplaire construit, le Charger est aussi le dernier avion complet sorti des ateliers de Convair. Il reste le témoin d''une idée défendue par les Marines au tournant des années 1960 : un petit avion d''appui à décollage court opérant au plus près des troupes. Le Bronco, son vainqueur à la formule si proche, reprendra ce principe.',
    E'## Genesis\nIn 1959 two **US Marine Corps** officers came up with the idea of a small, low-cost aircraft able to support the troops while operating from roads close to the battlefield: the **L2VMA** concept, for Light Light Marine Attack Aircraft. With the US Army interested in a similar type, the Convair Division of **General Dynamics** began its own counter-insurgency studies in 1961. In 1963 the requirements were merged into a tri-service specification, the **LARA** (Light Armed Reconnaissance Aircraft), also meant for the US Air Force in the counter-insurgency and forward air control roles, and open to export. Nine manufacturers responded; Convair submitted its Model 48 Charger in March 1964.\n\n## Design\nThe Charger was a twin-boom aircraft powered by two **Pratt & Whitney Canada PT6** turboprops, designated T74 by the military, built mainly of aluminium with a glass-fibre nose, rear fuselage and wingtips. Its short wing put almost the whole span in the propeller slipstream: full-span slotted flaps and leading-edge slats deflected that slipstream, a form of vectored thrust that shortened take-off and landing runs. Pilot and observer sat in tandem; the rear cargo bay, closed by a hinged tail cone, carried 910 kg of cargo or five paratroopers in very cramped conditions. Four 7.62 mm machine guns and 910 kg of stores under the wings and fuselage made up the armament, and two large floats could be fitted.\n\n## Testing\nIn August 1964 the US Navy declared **North American**''s NA-300, the future **OV-10 Bronco**, the winner. The Marine Corps and the US Air Force, which favoured the Charger, protested, and Convair completed the prototype it had begun as a private venture. It flew on 25 November 1964. After initial testing the wingspan was increased and the tail modified to improve low-speed control. The aircraft cleared a 15 m obstacle after a 148 m run, better than the 244 m required and better than the Bronco. A 100-hour joint-service test contract followed, with pilots from all four services, but the prototype crashed on its 196th flight on 19 October 1965 through the error of its US Navy pilot.\n\n## Place in history\nDevelopment was abandoned after the crash. The only example built, the Charger was also the last complete aircraft produced by Convair. It remains a witness to an idea championed by the Marines at the turn of the 1960s: a small STOL support aircraft operating right alongside the troops. The Bronco, its winner and close cousin in layout, would carry that principle forward.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1961-01-01',
    '1964-11-25',
    NULL,
    513,
    4800,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair Model 48 Charger'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair Model 48 Charger'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Convair Model 48 Charger'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Convair Model 48 Charger'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.62,
  wingspan          = 9.18,
  height            = 4.14,
  wing_area         = 20.1,
  empty_weight      = 2022,
  mtow              = 4745,
  service_ceiling   = 6500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada T74-CP-8/10 (650 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Model 48 (aile courte)** : prototype d''origine, envergure de 8,38 m, premier vol le 25 novembre 1964\n- **Model 48 (aile longue)** : prototype modifié après les premiers essais, envergure de 9,18 m et empennage revu\n- **Version amphibie** : deux grands flotteurs prévus par le cahier des charges LARA\n- **Version de série prévue** : fuselage plus long et plus profond, double commande complète, jamais construite',
  variants_en       = E'- **Model 48 (short wing)**: original prototype, 8.38 m span, first flown on 25 November 1964\n- **Model 48 (long wing)**: prototype as modified after initial testing, 9.18 m span and revised tail\n- **Amphibious version**: two large floats to meet the LARA requirement\n- **Planned production version**: longer, deeper fuselage with full dual controls, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_Model_48_Charger',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'San Diego Air & Space Museum Archives',
  image_licence     = 'Public domain'
WHERE name = 'Convair Model 48 Charger';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair Model 48 Charger';
