-- Northrop F-20 Tigershark
--
-- Photo : F-20 flying.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File%3AF-20_flying.jpg

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
    'F-20 Tigershark',
    'F-20 Tigershark',
    'Northrop F-20 Tigershark',
    'Northrop F-20 Tigershark',
    'Chasseur privé sans client, victime de la politique d’exportation américaine',
    'Privately funded fighter with no customer, killed by US export policy',
    '/assets/airplanes/f20-tigershark.jpg',
    E'## Genèse\nEn 1977, l''administration Carter crée la catégorie de l''**FX** : un chasseur destiné aux alliés, assez capable pour être utile mais volontairement inférieur au F-16, afin de limiter la prolifération. Northrop investit **1,2 milliard de dollars de fonds propres** pour occuper ce créneau en dérivant son F-5 vers un appareil entièrement neuf.\n\n## Conception\nUn seul **F404**, deux fois la poussée des deux J85 du F-5. Le résultat est spectaculaire : accélération et taux de montée supérieurs à ceux du F-16, radar multimode, et surtout un temps de mise en œuvre de **60 secondes** entre l''arrivée du pilote et le décollage — record inégalé. Le coût d''exploitation visé était la moitié de celui d''un F-16.\n\n## Carrière opérationnelle\nAucune. En 1980, l''administration Reagan lève la restriction et autorise la vente du F-16 aux mêmes clients : le F-20 perd sa raison d''être du jour au lendemain. Deux prototypes s''écrasent en démonstration en Corée et au Canada, tuant leurs pilotes. Aucune commande n''est jamais passée.\n\n## Place dans l''histoire\nLe F-20 est le contre-exemple le plus cité de l''industrie aéronautique : un appareil techniquement réussi, financé sans un dollar public, tué par un **changement de politique d''exportation**. Northrop n''a plus jamais développé de chasseur seul ; l''entreprise s''est tournée vers le B-2 puis vers le partenariat, sur le F/A-18 puis le F-35.',
    E'## Genesis\nIn 1977 the Carter administration created the **FX** category: a fighter for allies, capable enough to be useful but deliberately inferior to the F-16, in order to limit proliferation. Northrop invested **$1.2 billion of its own money** to fill that slot, developing its F-5 into an entirely new aircraft.\n\n## Design\nA single **F404**, twice the thrust of the F-5’s two J85s. The result was spectacular: acceleration and climb rate better than the F-16’s, a multimode radar, and above all a **60-second** turnaround from the pilot arriving to take-off — an unmatched record. Target operating cost was half that of an F-16.\n\n## Operational career\nNone. In 1980 the Reagan administration lifted the restriction and authorised F-16 sales to the same customers: the F-20 lost its rationale overnight. Two prototypes crashed during demonstrations in Korea and Canada, killing their pilots. No order was ever placed.\n\n## Place in history\nThe F-20 is aviation’s most-cited counter-example: a technically successful aircraft, funded without a dollar of public money, killed by a **change in export policy**. Northrop never again developed a fighter alone; the company turned to the B-2 and then to partnership, on the F/A-18 and later the F-35.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1975-01-01',
    '1982-08-30',
    NULL,
    2124.0,
    2759.0,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM armement WHERE name = 'M39')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-20 Tigershark'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.4,
  wingspan          = 8.53,
  height            = 4.2,
  wing_area         = 18.6,
  empty_weight      = 5090,
  mtow              = 12474,
  service_ceiling   = 16800,
  climb_rate        = 265,
  g_limit_pos       = 9.0,
  g_limit_neg       = -3.0,
  combat_radius     = 890,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-100',
  engine_count      = 1,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 48.0,
  thrust_wet        = 71.2,

  -- Strate 3 : production & service
  production_start  = 1982,
  production_end    = 1986,
  units_built       = 3,
  unit_cost_usd     = 15000000,
  unit_cost_year    = 1985,
  operators_count   = 0,
  variants          = E'- **F-20A** : version unique, trois prototypes construits\n- Deux appareils perdus en démonstration en **1984 et 1985**, les deux pilotes tués\n- Programme abandonné par Northrop en **1986** après 1,2 milliard de dollars investis sur fonds propres\n- Le troisième exemplaire est conservé au California Science Center',
  variants_en       = E'- **F-20A** : the only version, three prototypes built\n- Two aircraft lost in demonstration crashes in **1984 and 1985**, both pilots killed\n- Programme abandoned by Northrop in **1986** after $1.2 billion of company money\n- The third aircraft is preserved at the California Science Center',

  -- Strate 4 : qualitatif
  nickname          = 'Tigershark',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_F-20_Tigershark',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_F-20_Tigershark',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'F-20 Tigershark';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-20 Tigershark';
