-- Fairchild AC-119G Shadow / AC-119K Stinger
--
-- Photo : Ac119 shadow.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:Ac119_shadow.jpg

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
    'Fairchild AC-119',
    'Fairchild AC-119',
    'Fairchild AC-119G Shadow / AC-119K Stinger',
    'Fairchild AC-119G Shadow / AC-119K Stinger',
    'Un cargo des années 1950 hérissé de miniguns, trait d''union entre le Spooky et le Spectre au Vietnam',
    'A 1950s freighter bristling with miniguns, the link between Spooky and Spectre over Vietnam',
    '/assets/airplanes/ac119.jpg',
    E'## Genèse\nÀ la fin de 1967, l''avion-canonnière a fait ses preuves au Vietnam et l''**US Air Force** ne parvient plus à suivre la demande. L''**AC-47 Spooky** est vulnérable et manque de puissance ; les **AC-130** du programme **Gunship II** sont efficaces, mais surtout employés contre la piste Hô Chi Minh, et la cellule du C-130 reste vitale comme transport. Le **C-119 Flying Boxcar**, retiré des unités de première ligne au profit des C-123 et C-130, offre un stock de cellules disponibles dans la réserve. En février 1968, le programme **Gunship III** confie à **Fairchild-Hiller** la conversion de 52 appareils.\n\n## Conception\nVingt-six C-119G deviennent des **AC-119G**, d''abord surnommés « Creep » puis dotés de l''indicatif « Shadow » : quatre miniguns GAU-2/A de 7,62 mm tirant par le flanc, un projecteur au xénon, une visée nocturne, un lance-fusées éclairantes et des contre-mesures électroniques récentes. Vingt-six autres deviennent des **AC-119K Stinger**, conçus pour chasser les camions : ils ajoutent deux canons **M61 Vulcan** de 20 mm, un radar de navigation Doppler, une caméra infrarouge frontale et des radars de recherche, et se reconnaissent à deux réacteurs **J85** en nacelles sous les ailes. Les conversions sont faites à Saint Augustine, en Floride.\n\n## Carrière opérationnelle\nLes AC-119 arrivent au **Vietnam** en novembre 1968, au sein de la 14th Special Operations Wing basée à Nha Trang. Les Shadow équipent le 71st Special Operations Squadron, issu d''une unité de transport de la réserve, puis le 17th après le retour du 71st aux États-Unis en 1969 ; les Stinger rejoignent le 18th. Les premiers appuient les troupes au contact, les seconds traquent les convois sur la piste Hô Chi Minh. La 14th SOW est dissoute en 1971 et les derniers appareils américains opèrent depuis la Thaïlande jusqu''à l''automne 1972. Les deux versions servent ensuite l''aviation sud-vietnamienne, aux escadrons 819 et 821, jusqu''à la chute de Saïgon en 1975 ; cinq AC-119 seulement ont été perdus pendant la guerre.\n\n## Place dans l''histoire\nL''AC-119 est l''étape intermédiaire de la lignée des canonnières américaines : plus moderne que l''AC-47 qu''il remplace, plus simple que l''**AC-130** aux côtés duquel il opère. Il a permis de multiplier les canonnières sans priver les escadres de transport de leurs C-130, en recyclant une cellule déclassée. Retiré de l''US Air Force peu après 1972, il laisse l''AC-130 porter seul la formule.',
    E'## Genesis\nBy late 1967 the gunship had proved itself in Vietnam and the **US Air Force** could no longer keep up with demand. The **AC-47 Spooky** was vulnerable and underpowered; the **AC-130s** of **Project Gunship II** were effective but mostly used against the Ho Chi Minh Trail, and the C-130 airframe remained vital as a transport. The **C-119 Flying Boxcar**, phased out of front-line units in favour of the C-123 and C-130, offered a stock of available airframes in the reserve. In February 1968 **Project Gunship III** gave **Fairchild-Hiller** the conversion of 52 aircraft.\n\n## Design\nTwenty-six C-119Gs became **AC-119Gs**, first nicknamed ''Creep'' and later given the callsign ''Shadow'': four side-firing 7.62 mm GAU-2/A miniguns, a xenon searchlight, a night observation sight, a flare launcher and up-to-date electronic countermeasures. Another twenty-six became **AC-119K Stingers**, built to hunt trucks: they added two 20 mm **M61 Vulcan** cannon, a Doppler navigation radar, forward-looking infrared and search radars, and could be recognised by two **J85** turbojets in underwing pods. The conversions were carried out at St. Augustine, Florida.\n\n## Operational career\nThe AC-119s reached **Vietnam** in November 1968 with the 14th Special Operations Wing at Nha Trang. The Shadows equipped the 71st Special Operations Squadron, formed from a reserve transport unit, then the 17th after the 71st went home in 1969; the Stingers joined the 18th. The former supported troops in contact, the latter hunted convoys on the Ho Chi Minh Trail. The 14th SOW was inactivated in 1971 and the last American aircraft flew from Thailand until autumn 1972. Both versions then served the South Vietnamese air force, with the 819th and 821st squadrons, until the fall of Saigon in 1975; only five AC-119s were lost during the war.\n\n## Place in history\nThe AC-119 is the middle stage of the American gunship line: more advanced than the AC-47 it replaced, simpler than the **AC-130** alongside which it flew. It multiplied the number of gunships without taking C-130s away from the transport wings, by recycling a retired airframe. Withdrawn from the US Air Force shortly after 1972, it left the AC-130 to carry the formula on alone.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1968-02-01',
    NULL,
    '1968-11-01',
    330,
    3110,
    (SELECT id FROM manufacturer WHERE code = 'FRC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM armement WHERE name = 'M134 Minigun')),
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM armement WHERE name = 'M61 Vulcan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild AC-119'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.36,
  wingspan          = 33.31,
  height            = 8.12,
  wing_area         = 130,
  empty_weight      = 18200,
  mtow              = 28123,
  service_ceiling   = 7100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 8,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350-85 Duplex-Cyclone (2 500 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = NULL,
  units_built       = 52,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **AC-119G Shadow** : 26 C-119G convertis pour l''appui des troupes, quatre miniguns de 7,62 mm, équipage de 6 de jour et 8 de nuit\n- **AC-119K Stinger** : 26 conversions pour la chasse aux camions, deux canons M61 de 20 mm en plus et deux réacteurs J85 d''appoint\n- Dérivé du transport **C-119 Flying Boxcar**, dont il reprend la cellule et les moteurs Wright R-3350',
  variants_en       = E'- **AC-119G Shadow**: 26 converted C-119Gs for troop support, four 7.62 mm miniguns, crew of 6 by day and 8 by night\n- **AC-119K Stinger**: 26 conversions for truck hunting, adding two 20 mm M61 cannon and two J85 booster jets\n- Derived from the **C-119 Flying Boxcar** transport, whose airframe and Wright R-3350 engines it retains',

  -- Strate 4 : qualitatif
  nickname          = 'Shadow / Stinger',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairchild_AC-119',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairchild_AC-119',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Fairchild AC-119';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fairchild AC-119';
