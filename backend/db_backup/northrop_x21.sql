-- Northrop X-21A
--
-- Photo : Northrop X-21A takeoff.jpg
--   licence Public domain — Unknown author
--   https://commons.wikimedia.org/wiki/File:Northrop_X-21A_takeoff.jpg

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
    'Northrop X-21',
    'Northrop X-21',
    'Northrop X-21A',
    'Northrop X-21A',
    'B-66 transformé en laboratoire volant, dont l''aile percée de 800 000 fentes aspirait l''air pour réduire la traînée',
    'A B-66 turned into a flying laboratory, its wing pierced by 800,000 slots that sucked in air to cut drag',
    '/assets/airplanes/northrop-x21.jpg',
    E'## Genèse\nAu début des années 1960, le contrôle de l''écoulement laminaire promet un gain qu''aucune autre technologie aéronautique ne laisse espérer à elle seule : si 80 % de l''aile restent en écoulement laminaire, la traînée totale baisse de 25 %, au profit de la consommation, du rayon d''action ou de l''endurance. Le frottement de l''air est en effet bien plus fort dans une couche limite turbulente que dans une couche laminaire. La méthode principale consiste à aspirer une petite partie de cet air à travers des matériaux poreux, de fines fentes ou des microperforations. Pour l''éprouver en vol, **Northrop** transforme deux **Douglas WB-66D**, versions météorologiques du **B-66 Destroyer**, en **X-21A**.\n\n## Conception\nLes réacteurs **Allison J71** sous les ailes cèdent la place à deux **General Electric XJ79-GE-13** de 42 kN sans postcombustion, en nacelles de part et d''autre de l''arrière du fuselage, ce qui libère de la place pour des compresseurs. De l''air prélevé sur ces réacteurs entraîne deux turbines logées dans des carénages sous l''aile, qui aspirent la couche limite. L''aile, entièrement neuve, gagne en envergure et en surface, sa flèche passe de 35 à 30 degrés, et elle est percée de fentes parallèles à l''envergure, 800 000 au total. Le poste avant accueille un pilote et deux mécaniciens navigants, deux ingénieurs d''essai travaillant dans une baie centrale sous l''aile.\n\n## Essais\nLe X-21A vole pour la première fois le 18 avril 1963, piloté par **Jack Wells**. Dès les premiers essais, les surfaces poreuses et les fentes se bouchent sous l''effet des débris, des insectes, voire de la pluie. Dans certaines conditions, des cristaux de glace se forment au contact de l''air brusquement refroidi et rompent l''écoulement laminaire, qui redevient turbulent. On visait 95 % d''écoulement laminaire sur les zones traitées ; l''entretien minutieux qu''exige ce système complexe finit par condamner le programme, arrêté en 1968.\n\n## Place dans l''histoire\nLes vols du X-21 livrent pourtant des données pionnières : effets des défauts de surface, contamination de la couche limite par l''écoulement le long de l''envergure, influence des cristaux de glace présents dans l''atmosphère. Ils montrent aussi combien un tel système reste vulnérable à la saleté et au givre, qui suffisent à ruiner le bénéfice attendu. Remisés à Edwards, les deux appareils sont peu à peu devenus des épaves servant de cibles photographiques ; aucune restauration n''a été entreprise.',
    E'## Genesis\nIn the early 1960s laminar flow control promised a gain that no other single aeronautical technology could match: if 80 per cent of the wing stays laminar, overall drag falls by 25 per cent, to the benefit of fuel use, range or endurance. Friction between air and skin is far greater in a turbulent boundary layer than in a laminar one. The main method is to remove a small amount of that air by suction through porous materials, narrow slots or small perforations. To prove it in flight, **Northrop** converted two **Douglas WB-66D**s, weather reconnaissance versions of the **B-66 Destroyer**, into **X-21A**s.\n\n## Design\nThe underwing **Allison J71** engines gave way to two 42 kN non-afterburning **General Electric XJ79-GE-13**s in pods on either side of the rear fuselage, freeing space for air compressors. Bleed air from these engines drove two turbines housed in underwing fairings, which sucked away the boundary layer. The completely new wing had greater span and area, its sweep reduced from 35 to 30 degrees, and it was pierced by spanwise slots, 800,000 in all. The forward cockpit held a pilot and two flight engineers, while two flight test engineers worked in a central bay beneath the wing.\n\n## Testing\nThe X-21A first flew on 18 April 1963, piloted by **Jack Wells**. From the first tests, the porous surfaces and slots became plugged with debris, insects and even rain. In certain conditions, ice crystals formed in the rapidly cooled air and abruptly disrupted laminar flow, which turned turbulent again. The target was 95 per cent laminar flow over the treated areas; the heavy maintenance demanded by the intricate system eventually doomed the programme, which ended in 1968.\n\n## Place in history\nThe X-21 flights nonetheless produced pioneering data: the effects of surface irregularities, contamination of the boundary layer by spanwise flow, and the influence of ice crystals in the atmosphere. They also showed how vulnerable such a system remains to dirt and icing, either of which can wipe out the expected benefit. Stored at Edwards, both aircraft gradually became derelicts used as photo targets; no restoration has been attempted.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1963-04-18',
    NULL,
    896,
    7697,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop X-21'), (SELECT id FROM tech WHERE name = 'Aspiration de la couche limite'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop X-21'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.94,
  wingspan          = 28.51,
  height            = 7.8,
  wing_area         = 116.17,
  empty_weight      = 20783,
  mtow              = 37727,
  service_ceiling   = 12957,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric XJ79-GE-13',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 42.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **WB-66D** : version de reconnaissance météorologique du B-66 Destroyer, cellule de départ\n- **X-21A 55-0408** : premier des deux appareils transformés, premier vol le 18 avril 1963\n- **X-21A 55-0410** : second appareil transformé\n- **Aile à aspiration** : aile neuve, flèche ramenée à 30 degrés, 800 000 fentes et deux turbines d''aspiration sous carénage\n- **Motorisation** : J71 sous les ailes remplacés par deux XJ79-GE-13 à l''arrière du fuselage',
  variants_en       = E'- **WB-66D**: weather reconnaissance version of the B-66 Destroyer, the starting airframe\n- **X-21A 55-0408**: first of the two converted aircraft, first flight on 18 April 1963\n- **X-21A 55-0410**: second converted aircraft\n- **Suction wing**: new wing, sweep reduced to 30 degrees, 800,000 slots and two suction turbines in fairings\n- **Powerplant**: underwing J71s replaced by two XJ79-GE-13s on the rear fuselage',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_X-21',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_X-21',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Northrop X-21';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop X-21';
