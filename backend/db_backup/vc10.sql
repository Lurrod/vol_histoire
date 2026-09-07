-- Vickers VC10 C1K / K3
--
-- Photo : Vickers VC10 C1K (50125463166).jpg
--   licence CC BY-SA 2.0 — Hugh Llewelyn from Keynsham, UK
--   https://commons.wikimedia.org/wiki/File%3AVickers_VC10_C1K_%2850125463166%29.jpg

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
    'Vickers VC10',
    'Vickers VC10',
    'Vickers VC10 C1K / K3',
    'Vickers VC10 C1K / K3',
    'Avion de ligne devenu le ravitailleur de la Royal Air Force',
    'Airliner turned Royal Air Force tanker',
    '/assets/airplanes/vc10.jpg',
    E'## Genèse\nVickers conçoit le VC10 pour une contrainte très particulière : desservir les **routes africaines et asiatiques de l''Empire**, dont les aérodromes sont courts, chauds et en altitude — conditions où un jet ordinaire ne décolle pas à pleine charge. D''où une aile très portante et quatre réacteurs groupés à l''arrière, qui la laissent parfaitement propre. L''appareil est superbe et commercialement décevant : Boeing vend dix fois plus de 707.\n\n## Conception\nCette même aile, dessinée pour les terrains difficiles, en fait un excellent ravitailleur : l''appareil tient bien à basse vitesse, ce qui facilite le rendez-vous avec des chasseurs lourds. La Royal Air Force lui installe **trois postes de transfert** — deux nacelles sous voilure et un enrouleur ventral — et remplit la cabine de réservoirs supplémentaires. Le silence relatif de la cabine, réacteurs à l''arrière, en fait aussi un transport de personnalités apprécié.\n\n## Carrière opérationnelle\nAux **Malouines** en 1982, les VC10 assurent le relais vers l''île de l''Ascension et ravitaillent les Vulcan lors du raid Black Buck, la plus longue mission de bombardement de l''histoire à cette date. Ils servent ensuite dans les deux guerres du Golfe, en Yougoslavie, en Afghanistan et au-dessus de la Libye, et rapatrient les blessés britanniques pendant trente ans.\n\n## Place dans l''histoire\nCinquante-quatre exemplaires seulement, dont l''essentiel finit sous cocarde militaire — un échec commercial devenu une réussite opérationnelle de quarante-sept ans. Son retrait en 2013 a laissé la RAF entièrement dépendante d''une flotte d''**A330 MRTT** louée à un consortium privé, arrangement toujours contesté.',
    E'## Genesis\nVickers designed the VC10 for a very particular constraint: serving the **African and Asian routes of the Empire**, whose airfields were short, hot and high — conditions in which an ordinary jet cannot take off fully loaded. Hence a very high-lift wing and four engines grouped at the rear, leaving it perfectly clean. The aircraft is superb and commercially disappointing: Boeing sold ten times as many 707s.\n\n## Design\nThat same wing, drawn for difficult fields, makes it an excellent tanker: the aircraft handles well at low speed, which eases the join-up with heavy fighters. The Royal Air Force fitted **three transfer stations** — two underwing pods and a fuselage drum — and filled the cabin with additional tanks. The relative quiet of the cabin, with the engines at the back, also made it a valued VIP transport.\n\n## Operational career\nIn the **Falklands** in 1982 the VC10s ran the shuttle to Ascension Island and refuelled the Vulcans on the Black Buck raid, the longest bombing mission in history at that date. They went on to serve in both Gulf wars, over Yugoslavia, Afghanistan and Libya, and repatriated British wounded for thirty years.\n\n## Place in history\nOnly fifty-four built, most of which ended up in military markings — a commercial failure turned into a forty-seven-year operational success. Its retirement in 2013 left the RAF wholly dependent on a fleet of **A330 MRTTs** leased from a private consortium, an arrangement still disputed.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1957-01-01',
    '1962-06-29',
    '1966-07-07',
    933.0,
    7600.0,
    (SELECT id FROM manufacturer WHERE code = 'VIC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 48.36,
  wingspan          = 44.55,
  height            = 12.04,
  wing_area         = 272.0,
  empty_weight      = 66670,
  mtow              = 151950,
  service_ceiling   = 12800,
  climb_rate        = 15.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3800,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Conway Mk 301',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 97.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1970,
  units_built       = 54,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **VC10 C1** : transport de troupes et de personnalités, quatorze exemplaires\n- **VC10 C1K** : C1 converti en ravitailleur mixte, deux nacelles sous voilure\n- **VC10 K2 / K3 / K4** : anciens avions de ligne convertis en ravitailleurs purs\n- **Quatre réacteurs groupés en queue** : configuration rare, choisie pour les pistes courtes\n- Retiré le **20 septembre 2013**, après quarante-sept ans de service',
  variants_en       = E'- **VC10 C1** : troop and VIP transport, fourteen aircraft\n- **VC10 C1K** : C1 converted to a combined tanker, with two underwing pods\n- **VC10 K2 / K3 / K4** : former airliners converted to pure tankers\n- **Four engines grouped at the tail** : a rare layout, chosen for short runways\n- Retired on **20 September 2013**, after forty-seven years of service',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vickers_VC10',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vickers_VC10',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hugh Llewelyn from Keynsham, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Vickers VC10';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vickers VC10';
