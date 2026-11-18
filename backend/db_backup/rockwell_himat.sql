-- Rockwell RPRV-870 HiMAT
--
-- Photo : HiMAT in flight.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:HiMAT_in_flight.jpg

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
    'Rockwell HiMAT',
    'Rockwell HiMAT',
    'Rockwell RPRV-870 HiMAT',
    'Rockwell RPRV-870 HiMAT',
    'Chasseur miniature télépiloté, largué d''un B-52 pour tirer 8 g à l''approche du mur du son',
    'A remotely piloted miniature fighter, dropped from a B-52 to pull 8 g close to the speed of sound',
    '/assets/airplanes/rockwell-himat.jpg',
    E'## Genèse\nDans les années 1970, la maniabilité devient le maître mot des chasseurs américains. Les commandes de vol électriques et les composites graphite-époxy, aussi solides que le métal mais plus légers, autorisent des formes que personne n''ose encore essayer avec un pilote à bord. En août 1975, l''US Air Force confie à **Rockwell International** un contrat de 17,3 millions de dollars pour deux engins téléguidés, dans le cadre du programme **Highly Maneuverable Aircraft Technology**, ou HiMAT, mené avec la **NASA**. Piloter depuis le sol coûte moins cher, épargne la vie d''un pilote et dispense de siège éjectable.\n\n## Conception\nLe HiMAT concentre les idées du chasseur de demain : plan canard rapproché, aile à profil supercritique avec winglets, structure en composites graphite et fibre de verre, commandes de vol entièrement numériques jusqu''à la gestion du réacteur, un **General Electric J85-21**. Le pilote, installé dans un poste au sol, vole sur l''image d''une caméra de nez ou sur un affichage de vision synthétique en trois dimensions. L''engin est largué en altitude par le **NB-52B** de la NASA, et un TF-104G d''accompagnement porte des commandes de secours capables de reprendre la main.\n\n## Essais\nLe premier vol libre a lieu le 27 juillet 1979, avec **William H. Dana** aux commandes depuis le sol. Le 8 juillet 1980, une panne logicielle empêche la sortie des patins : l''engin se pose sur le ventre près d''Edwards, puis revole en octobre. Le second exemplaire tire 8 g le 18 février 1982, passe Mach 1,2 le 11 mai et Mach 1,45 trois jours plus tard. Les deux HiMAT accomplissent 26 vols d''une trentaine de minutes, jusqu''au 12 janvier 1983. Il faut presque tout le bureau des pilotes pour une mission, d''où la plaisanterie : combien de pilotes pour faire voler un avion sans pilote ?\n\n## Place dans l''histoire\nPlus complexe et plus lourd à préparer que prévu, le HiMAT laisse un bilan contrasté, mais ses performances impressionnent : virages soutenus à 8 g près du mur du son et endurance supersonique au-delà des objectifs. Les progrès des commandes de vol numériques profitent au **Grumman X-29**, et la construction en composites se généralise sur les avions civils comme militaires. Les deux exemplaires sont conservés, au National Air and Space Museum et au centre Armstrong de la NASA.',
    E'## Genesis\nIn the 1970s manoeuvrability became the watchword for American fighters. Fly-by-wire controls and graphite-epoxy composites, as strong as metal but lighter, allowed shapes that nobody yet dared to try with a pilot on board. In August 1975 the US Air Force gave **Rockwell International** a $17.3 million contract for two remotely piloted vehicles under the **Highly Maneuverable Aircraft Technology** programme, or HiMAT, run with **NASA**. Flying from the ground was cheaper, spared a pilot''s life and did away with the ejection seat.\n\n## Design\nHiMAT gathered the ideas of the fighter of the future: close-coupled canards, a supercritical wing with winglets, a graphite and fibreglass composite structure, and fully digital flight controls extending to the engine, a **General Electric J85-21**. The pilot, in a ground cockpit, flew from a nose camera picture or a three-dimensional synthetic vision display. The vehicle was dropped at altitude by NASA''s **NB-52B**, and a TF-104G chase aircraft carried backup controls able to take over.\n\n## Testing\nThe first free flight took place on 27 July 1979, with **William H. Dana** flying from the ground. On 8 July 1980 a software glitch stopped the landing skids from deploying: the vehicle belly-landed near Edwards, then flew again in October. The second aircraft pulled 8 g on 18 February 1982, passed Mach 1.2 on 11 May and Mach 1.45 three days later. The two HiMATs made 26 flights of about thirty minutes each, until 12 January 1983. A mission needed almost the entire pilot office, hence the joke: how many pilots does it take to fly an unmanned aircraft?\n\n## Place in history\nMore complex and harder to prepare than expected, HiMAT left a mixed record, but its performance was impressive: sustained 8 g turns near the speed of sound and supersonic endurance beyond its targets. Advances in digital flight control fed into the **Grumman X-29**, and composite construction became widespread on civil and military aircraft alike. Both vehicles survive, at the National Air and Space Museum and at NASA''s Armstrong centre.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1975-08-01',
    '1979-07-27',
    NULL,
    1960,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'ROC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Rockwell HiMAT'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards')),
((SELECT id FROM airplanes WHERE name = 'Rockwell HiMAT'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Rockwell HiMAT'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Rockwell HiMAT'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.86,
  wingspan          = 4.75,
  height            = 1.31,
  wing_area         = NULL,
  empty_weight      = 1529,
  mtow              = 1828,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-21',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1975,
  production_end    = 1979,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **RPRV 870** : ouverture du domaine de vol, premier vol le 27 juillet 1979, 14 vols\n- **RPRV 871** : collecte de données, premier vol libre le 24 juillet 1981, Mach 1,45 le 14 mai 1982, 12 vols\n- **Lancement aérien** depuis le NB-52B de la NASA, retour sur patins à Edwards\n- **Poste au sol** : image de caméra de nez ou vision synthétique en trois dimensions',
  variants_en       = E'- **RPRV 870**: envelope expansion, first flight on 27 July 1979, 14 flights\n- **RPRV 871**: data gathering, first free flight on 24 July 1981, Mach 1.45 on 14 May 1982, 12 flights\n- **Air launch** from NASA''s NB-52B, recovery on skids at Edwards\n- **Ground cockpit**: nose camera picture or three-dimensional synthetic vision',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Rockwell_HiMAT',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Rockwell_HiMAT',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Rockwell HiMAT';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Rockwell HiMAT';
