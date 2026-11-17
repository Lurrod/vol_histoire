-- FMA IA 50 Guaraní II
--
-- Photo : FMA IA-50B Guarani II.jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert
--   https://commons.wikimedia.org/wiki/File:FMA_IA-50B_Guarani_II.jpg

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
    'FMA IA 50 Guaraní II',
    'FMA IA 50 Guaraní II',
    'FMA IA 50 Guaraní II',
    'FMA IA 50 Guaraní II',
    'Bimoteur utilitaire argentin à turbopropulseurs, premier avion latino-américain à traverser l''Atlantique',
    'Argentine twin-turboprop utility aircraft, the first Latin American-built aircraft to fly the Atlantic',
    '/assets/airplanes/ia50-guarani.jpg',
    E'## Genèse\nAu début des années 1960, la **DINFIA**, le conglomérat aéronautique d''État argentin qui succède à l''Instituto Aerotécnico, constate que son bimoteur de transport léger à pistons, l''**IA 35 Huanquero**, vieillit. Elle décide d''en tirer un dérivé à turbopropulseurs. Le premier **Guaraní** garde la disposition générale du Huanquero, monoplan à aile basse tout métal à double dérive, mais ne partage que 20 % de sa structure. Propulsé par deux **Turbomeca Bastan III** de 850 ch, il vole le 6 février 1962.\n\n## Conception\nL''appareil est aussitôt repris sous la forme du **Guaraní II**. La double dérive cède la place à une dérive unique en flèche, le fuselage arrière est raccourci et les moteurs passent au **Bastan VI-A** de 930 ch. Le fuselage semi-monocoque, de section carrée, porte une aile droite et un empennage en flèche ; la cabine accueille deux pilotes et jusqu''à quinze passagers. Le prototype du Guaraní I, reconstruit à ce standard, vole sous sa nouvelle forme le 26 avril 1963.\n\n## Carrière opérationnelle\nEn juin 1965, le prototype TX-01 est présenté en vol au **Salon du Bourget**, puis évalué pendant 200 heures de vol au Centre d''essais en vol d''Istres. Rentré en Argentine en février 1966, il devient le premier avion construit en Amérique latine à traverser l''Atlantique. Mis en service la même année, le Guaraní II est produit à 32 exemplaires de série, en plus de trois prototypes. L''armée de l''air, la marine, la police fédérale, l''administration pénitentiaire, une compagnie provinciale et plusieurs gouvernements provinciaux l''emploient comme transport léger, avion sanitaire, de liaison, d''étalonnage, de photographie aérienne ou d''entraînement. Le dernier exemplaire en vol est retiré le 7 janvier 2007 à la IIe brigade aérienne de Paraná, puis convoyé au musée de Morón.\n\n## Place dans l''histoire\nLe Guaraní II témoigne d''une industrie argentine capable, dans les années 1960, de passer du moteur à pistons à la turbine et de présenter un produit national au Salon du Bourget. Resté au service de son seul pays, il y a volé plus de quarante ans, surtout au profit de l''État. Il appartient à la même famille de petits bimoteurs utilitaires à turbopropulseurs que l''**Embraer Bandeirante** brésilien.',
    E'## Genesis\nIn the early 1960s **DINFIA**, the Argentine state aviation conglomerate that succeeded the Instituto Aerotécnico, realised that its piston-engined light twin transport, the **IA 35 Huanquero**, was becoming outdated. It decided to develop a turboprop derivative. The first **Guaraní** kept the Huanquero''s general layout, an all-metal low-wing monoplane with a twin tail, but shared only 20% of its structure. Powered by two 850 shp **Turbomeca Bastan III** engines, it flew on 6 February 1962.\n\n## Design\nThe aircraft was immediately reworked as the **Guaraní II**. The twin tail gave way to a single swept fin, the rear fuselage was shortened and the engines became 930 shp **Bastan VI-A**s. The semi-monocoque fuselage, of square cross-section, carried an unswept wing and swept tail surfaces; the cabin held two pilots and up to fifteen passengers. The Guaraní I prototype, rebuilt to this standard, flew in its new form on 26 April 1963.\n\n## Operational career\nIn June 1965 the TX-01 prototype was shown in flight at the **Paris Air Show**, then evaluated for 200 flying hours at the Istres flight test centre. Flown back to Argentina in February 1966, it became the first Latin American-built aircraft to cross the Atlantic. Entering service the same year, the Guaraní II was built in 32 production examples, plus three prototypes. The air force, the navy, the federal police, the prison service, a provincial airline and several provincial governments used it as a light transport, air ambulance, liaison, calibration, aerial photography and training aircraft. The last flying example was retired on 7 January 2007 at the 2nd Air Brigade at Paraná, then ferried to the Morón museum.\n\n## Place in history\nThe Guaraní II reflects an Argentine industry able, in the 1960s, to move from piston engine to turbine and to present a domestic product at the Paris Air Show. Used only in its home country, it flew there for more than forty years, mainly for the state. It belongs to the same family of small twin-turboprop utility aircraft as Brazil''s **Embraer Bandeirante**.',
    (SELECT id FROM countries WHERE code = 'ARG'),
    NULL,
    '1963-04-26',
    '1966-01-01',
    500,
    1995,
    (SELECT id FROM manufacturer WHERE code = 'FMA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 50 Guaraní II'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FMA IA 50 Guaraní II'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.86,
  wingspan          = 19.53,
  height            = 5.81,
  wing_area         = 41.81,
  empty_weight      = 3924,
  mtow              = 7120,
  service_ceiling   = 12500,
  climb_rate        = 13.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Bastan VI-A (930 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 35,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **IA 50 Guaraní I** : prototype à double dérive et moteurs Turbomeca Bastan III de 850 ch, premier vol le 6 février 1962\n- **IA 50 Guaraní II** : dérive unique en flèche, fuselage arrière raccourci, moteurs Bastan VI-A de 930 ch ; le prototype TX-01 est présenté au Bourget en 1965\n- **Série** : 32 exemplaires pour l''armée de l''air, la marine, la police fédérale et des administrations civiles',
  variants_en       = E'- **IA 50 Guaraní I**: twin-tail prototype with 850 shp Turbomeca Bastan III engines, first flight on 6 February 1962\n- **IA 50 Guaraní II**: single swept fin, shortened rear fuselage, 930 shp Bastan VI-A engines; the TX-01 prototype was shown at Le Bourget in 1965\n- **Production**: 32 aircraft for the air force, the navy, the federal police and civil agencies',

  -- Strate 4 : qualitatif
  nickname          = 'Guaraní',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/FMA_IA_50_Guaraní_II',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/FMA_IA_50_Guaraní_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'FMA IA 50 Guaraní II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FMA IA 50 Guaraní II';
