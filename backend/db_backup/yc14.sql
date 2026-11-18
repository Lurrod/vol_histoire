-- Boeing YC-14
--
-- Photo : AIRCRAFT - NARA - 17444445 (cropped).jpg
--   licence Public domain — Unknown authorUnknown author or not provided
--   https://commons.wikimedia.org/wiki/File:AIRCRAFT_-_NARA_-_17444445_(cropped).jpg

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
    'Boeing YC-14',
    'Boeing YC-14',
    'Boeing YC-14',
    'Boeing YC-14',
    'Biréacteur de transport à décollage court qui soufflait ses réacteurs sur l''aile, abandonné avec le programme AMST',
    'Twin-jet STOL transport that blew its engine exhaust over the wing, dropped along with the AMST programme',
    '/assets/airplanes/yc14.jpg',
    E'## Genèse\nAu début des années 1970, l''US Air Force cherche un successeur au **C-130 Hercules** capable d''opérer depuis des terrains très courts : c''est le programme **AMST** (Advanced Medium STOL Transport). L''appel d''offres de janvier 1972 exige de se poser sur 610 m de terrain sommairement préparé avec 12 tonnes de charge, à 930 km et retour sans ravitaillement ; le C-130 de l''époque demande deux fois plus de piste pour la même charge. Boeing présente son **Model 953** en mars 1972 et, le 10 novembre, remporte avec McDonnell Douglas un contrat pour deux prototypes.\n\n## Conception\nBoeing s''appuie sur deux travaux de la NASA. Le premier est le **soufflage de l''extrados** : les deux réacteurs, posés au-dessus de l''aile, soufflent sur les volets ; volets baissés, l''effet Coandă colle le jet à leur surface et le rabat vers le sol. Le second est l''**aile supercritique** de **Richard Whitcomb**, qui réduit la traînée transsonique tout en restant propice au vol lent : le YC-14 est le premier avion non expérimental à l''adopter. Les essais en soufflerie, menés avec le centre de Langley, imposent des générateurs de tourbillons escamotables sur l''aile et une dérive plus verticale qui avance la gouverne de profondeur. Les deux turbofans **General Electric CF6-50D** développent chacun 230 kN.\n\n## Essais\nLe premier YC-14 vole le 9 août 1976, près d''un an après son concurrent, le **YC-15**. Les essais comparatifs commencent à Edwards en novembre 1976. Le YC-14 vole de 109 km/h à Mach 0,78, décolle et se pose en 240 m, et emporte un char M60A2 de 49,5 tonnes, ce que le YC-15 ne démontre pas. Sa traînée se révèle 11 % plus forte que prévu ; des retouches ramènent l''écart à 7 %. À la fin des essais, à l''été 1977, les prototypes retournent chez Boeing.\n\n## Place dans l''histoire\nDès mars 1976, le chef d''état-major **David C. Jones** demande si un même avion pourrait servir au transport tactique et stratégique. Les études concluent qu''il faudrait des appareils bien plus grands, et le transport stratégique prend le pas : l''AMST est arrêté en décembre 1979 au profit du programme C-X, qui retiendra un YC-15 agrandi, futur **C-17 Globemaster III**. Les deux YC-14 sont conservés en Arizona, l''un au Pima Air & Space Museum, l''autre au parc de stockage de Davis-Monthan. Le soufflage de l''extrados reste rare ; l''**Antonov An-72** est l''un des seuls à l''avoir repris.',
    E'## Genesis\nIn the early 1970s the US Air Force wanted a successor to the **C-130 Hercules** able to operate from very short fields: this was the **AMST** (Advanced Medium STOL Transport) programme. The January 1972 request for proposals called for operations into a 610 m semi-prepared strip with a 12-tonne payload, 930 km out and back without refuelling; the C-130 of the day needed twice the runway for the same load. Boeing submitted its **Model 953** in March 1972 and on 10 November, along with McDonnell Douglas, won a contract for two prototypes.\n\n## Design\nBoeing drew on two pieces of NASA research. The first was **upper-surface blowing**: the two engines, mounted above the wing, blew over the flaps; with the flaps lowered, the Coandă effect made the exhaust cling to them and turned it down towards the ground. The second was **Richard Whitcomb**''s **supercritical wing**, which cut transonic drag while remaining well suited to slow flight: the YC-14 was the first non-experimental aircraft to use it. Wind tunnel work with NASA Langley led to retractable vortex generators on the wing and a more upright fin moving the elevator forward. The two **General Electric CF6-50D** turbofans each delivered 230 kN.\n\n## Testing\nThe first YC-14 flew on 9 August 1976, almost a year after its competitor, the **YC-15**. Head-to-head testing began at Edwards in November 1976. The YC-14 flew from 109 km/h up to Mach 0.78, took off and landed in 240 m, and carried a 49.5-tonne M60A2 tank, something the YC-15 never demonstrated. Its drag proved 11% higher than predicted; modifications brought the excess down to 7%. At the end of testing, in summer 1977, the prototypes returned to Boeing.\n\n## Place in history\nAs early as March 1976, Chief of Staff **David C. Jones** asked whether a single aircraft could serve both tactical and strategic airlift. Studies found it would take much larger aircraft, and the strategic mission took precedence: AMST ended in December 1979 in favour of the C-X programme, which would select an enlarged YC-15, the future **C-17 Globemaster III**. Both YC-14s survive in Arizona, one at the Pima Air & Space Museum, the other in storage at Davis-Monthan. Upper-surface blowing remains rare; the **Antonov An-72** is one of the few aircraft to have used it since.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1970-01-01',
    '1976-08-09',
    NULL,
    811,
    5136,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YC-14'), (SELECT id FROM tech WHERE name = 'Volets soufflés par les réacteurs')),
((SELECT id FROM airplanes WHERE name = 'Boeing YC-14'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing YC-14'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Boeing YC-14'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 40.14,
  wingspan          = 39.32,
  height            = 14.74,
  wing_area         = 163.7,
  empty_weight      = 53410,
  mtow              = 113850,
  service_ceiling   = 13716,
  climb_rate        = 32.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-50D',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 230,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 953** : projet présenté par Boeing en mars 1972 à l''appel d''offres AMST\n- **YC-14 72-1873** : premier prototype, premier vol le 9 août 1976 ; exposé au Pima Air & Space Museum\n- **YC-14 72-1874** : second prototype, stocké au parc de Davis-Monthan',
  variants_en       = E'- **Model 953**: Boeing''s March 1972 submission to the AMST competition\n- **YC-14 72-1873**: first prototype, first flight on 9 August 1976; displayed at the Pima Air & Space Museum\n- **YC-14 72-1874**: second prototype, stored at Davis-Monthan',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_YC-14',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_YC-14',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Greg Lewis',
  image_licence     = 'Public domain'
WHERE name = 'Boeing YC-14';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing YC-14';
