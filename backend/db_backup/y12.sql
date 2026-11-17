-- Harbin Y-12 (Yunshuji-12)
--
-- Photo : SriLanka-Independence - 4 Feb 2019 (44).jpg
--   licence CC BY-SA 4.0 — Rehman Abubakr
--   https://commons.wikimedia.org/wiki/File:SriLanka-Independence_-_4_Feb_2019_(44).jpg

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
    'Harbin Y-12',
    'Harbin Y-12',
    'Harbin Y-12 (Yunshuji-12)',
    'Harbin Y-12 (Yunshuji-12)',
    'Le petit utilitaire à décollage court, premier avion chinois certifié par la FAA, adopté par une vingtaine d''armées',
    'The short take-off utility twin, the first Chinese aircraft certified by the FAA, flown by many air forces',
    '/assets/airplanes/harbin-y12.jpg',
    E'## Genèse\nLe Y-12 naît en 1980 d''une évolution du **Harbin Y-11**, d''abord appelée Y-11T. Par rapport à son aîné, il reçoit une aile redessinée à profil de faible traînée, un fuselage agrandi et une structure collée plutôt que rivetée, tandis que les moteurs en étoile cèdent la place à des turbopropulseurs. Le prototype vole le 14 juillet 1982 ; une trentaine de Y-12 (I) sont construits avant le Y-12 (II), plus puissant et privé de becs de bord d''attaque, qui vole le 16 août 1984 et obtient sa certification chinoise en décembre 1985.\n\n## Conception\nBimoteur à aile haute contreventée, le Y-12 (II) est propulsé par deux **Pratt & Whitney Canada PT6A-27** de 620 ch. Il emporte 17 passagers ou 1 700 kg de charge, décolle en 370 m et se pose en 340 m, ce qui en fait un utilitaire taillé pour les terrains courts. Pour obtenir la certification américaine, Harbin agrandit l''aile, ajoute des winglets et renforce le train : en mars 1995, le Y-12 (IV) devient le premier avion conçu et construit en Chine à recevoir un certificat de type de la **FAA**. À cette date, 61 exemplaires ont déjà été vendus dans 13 pays.\n\n## Carrière opérationnelle\nAu-delà des compagnies régionales, le Y-12 trouve sa place dans les forces aériennes aux moyens modestes : une vingtaine en Birmanie, d''autres au Sri Lanka, au Kenya, en Zambie, en Tanzanie, au Pakistan, au Pérou, en Iran, au Cambodge, à Djibouti ou au Mali. En Chine, la version militaire **Y-12D** sert à l''entraînement au parachutisme du corps aéroporté de l''APL, et le **Y-12C**, à turbopropulseurs WJ-9, aux relevés aériens. Les Y-12 sri-lankais volent en surveillance, et en 2020 un Y-12 kényan qui ravitaillait la mission de l''Union africaine en Somalie est gravement endommagé au décollage de Dhobley.\n\n## Place dans l''histoire\nEnviron 300 exemplaires ont été livrés jusqu''en 2023. Le **Y-12F**, presque entièrement redessiné avec un fuselage élargi et un train rentrant, vole le 29 décembre 2010 et obtient les certifications chinoise en 2015, américaine en 2016 et européenne en 2023. Premier avion chinois reconnu par la FAA, le Y-12 a servi de banc d''essai à la compatibilité des règles de certification chinoises avec les normes américaines pour les petits avions.',
    E'## Genesis\nThe Y-12 began in 1980 as a development of the **Harbin Y-11**, at first called the Y-11T. Compared with its predecessor it had a redesigned low-drag wing, a larger fuselage and bonded rather than riveted construction, while the radial engines gave way to turboprops. The prototype flew on 14 July 1982; about thirty Y-12 (I)s were built before the more powerful Y-12 (II), without leading-edge slats, which flew on 16 August 1984 and received Chinese certification in December 1985.\n\n## Design\nA high-wing, strut-braced twin, the Y-12 (II) is powered by two **Pratt & Whitney Canada PT6A-27** turboprops of 620 hp. It carries 17 passengers or 1,700 kg of payload, takes off in 370 m and lands in 340 m, making it a utility aircraft built for short strips. To gain US certification, Harbin enlarged the wing, added winglets and strengthened the landing gear: in March 1995 the Y-12 (IV) became the first aircraft designed and built in China to receive an **FAA** type certificate. By then 61 had been sold to 13 countries.\n\n## Operational career\nBeyond regional airlines, the Y-12 found its place with air forces of modest means: some twenty in Myanmar, others in Sri Lanka, Kenya, Zambia, Tanzania, Pakistan, Peru, Iran, Cambodia, Djibouti and Mali. In China the military **Y-12D** is used by the PLA Airborne Corps for parachute training, and the **Y-12C**, with WJ-9 turboprops, for aerial survey. Sri Lankan Y-12s fly surveillance missions, and in 2020 a Kenyan Y-12 resupplying the African Union mission in Somalia was seriously damaged on take-off from Dhobley.\n\n## Place in history\nAround 300 had been delivered by 2023. The **Y-12F**, almost entirely redesigned with a wider fuselage and retractable landing gear, flew on 29 December 2010 and received Chinese certification in 2015, American in 2016 and European in 2023. As the first Chinese aircraft recognised by the FAA, the Y-12 served to demonstrate that Chinese certification rules for small aircraft were compatible with American standards.',
    (SELECT id FROM countries WHERE code = 'CHN'),
    '1980-01-01',
    '1982-07-14',
    NULL,
    328,
    1340,
    (SELECT id FROM manufacturer WHERE code = 'HAMC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Harbin Y-12'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Harbin Y-12'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Harbin Y-12'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.86,
  wingspan          = 17.235,
  height            = 5.575,
  wing_area         = 34.27,
  empty_weight      = 2840,
  mtow              = 5300,
  service_ceiling   = 7000,
  climb_rate        = 8.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-27 (620 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 300,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 18,
  variants          = E'- **Y-12 (I)** : première série d''une trentaine d''exemplaires, moteurs PT6A-11 de 500 ch\n- **Y-12 (II)** : moteurs PT6A-27 de 620 ch, sans becs de bord d''attaque, version la plus répandue\n- **Y-12 (IV)** : envergure portée à 19,2 m, premier avion chinois certifié par la FAA en 1995\n- **Y-12C / Y-12D** : versions militaires chinoises de relevé aérien et d''entraînement au parachutisme\n- **Y-12F** : version redessinée à fuselage élargi et train rentrant, premier vol en 2010',
  variants_en       = E'- **Y-12 (I)**: first batch of about thirty, 500 hp PT6A-11 engines\n- **Y-12 (II)**: 620 hp PT6A-27 engines, no leading-edge slats, the most widespread version\n- **Y-12 (IV)**: span increased to 19.2 m, first Chinese aircraft certified by the FAA in 1995\n- **Y-12C / Y-12D**: Chinese military aerial survey and parachute training versions\n- **Y-12F**: redesigned version with a wider fuselage and retractable gear, first flight in 2010',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Harbin_Y-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Harbin_Y-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rehman Abubakr',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Harbin Y-12';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Harbin Y-12';
