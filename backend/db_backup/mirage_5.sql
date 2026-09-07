-- Dassault Mirage 5
--
-- Photo : BA-05 Mirage 5BA, 1 SM, Arrival at Fairford RIAT 1987.jpg
--   licence CC BY-SA 4.0 — Anidaat
--   https://commons.wikimedia.org/wiki/File%3ABA-05_Mirage_5BA%2C_1_SM%2C_Arrival_at_Fairford_RIAT_1987.jpg

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
    'Mirage 5',
    'Mirage 5',
    'Dassault Mirage 5',
    'Dassault Mirage 5',
    'Version d’attaque simplifiée du Mirage III, pensée pour l’export',
    'Simplified ground-attack Mirage III, designed for export',
    '/assets/airplanes/mirage-5.jpg',
    E'## Genèse\nEn 1966, l''armée de l''air israélienne demande à Dassault un Mirage III allégé : pas de radar d''interception, mais du carburant et des bombes en plus. Le ciel du Proche-Orient étant dégagé la quasi-totalité de l''année, l''avionique tout-temps est un luxe inutile. Dassault accepte : le Mirage 5 est né d''un cahier des charges étranger.\n\n## Conception\nLe radar Cyrano disparaît du nez, remplacé par 470 litres de carburant supplémentaires. Deux points d''emport s''ajoutent sous le fuselage. Plus simple, moins cher, plus endurant que le Mirage III en attaque au sol, il en conserve la cellule delta et les performances en vitesse pure.\n\n## Carrière opérationnelle\nLes 50 appareils israéliens, payés, sont **saisis par de Gaulle** lors de l''embargo de juin 1967. Israël répliquera en développant son propre dérivé, le **IAI Nesher**, à partir de plans obtenus clandestinement. Le Mirage 5 trouve douze autres clients — Belgique, Pakistan, Pérou, Égypte, Colombie, Venezuela, Zaïre, Libye, Émirats — et combat au Kippour dans les rangs égyptiens et libyens.\n\n## Place dans l''histoire\nL''embargo de 1967 est un tournant : il pousse Israël à bâtir sa propre industrie aéronautique, qui donnera le Nesher puis le Kfir. Le Mirage 5 aura donc, involontairement, fondé un concurrent.',
    E'## Genesis\nIn 1966 the Israeli Air Force asked Dassault for a stripped-down Mirage III: no interception radar, but more fuel and more bombs. With clear skies over the Middle East almost all year round, all-weather avionics were a needless luxury. Dassault agreed: the Mirage 5 was born from a foreign specification.\n\n## Design\nThe Cyrano radar disappeared from the nose, replaced by 470 extra litres of fuel. Two more hardpoints were added under the fuselage. Simpler, cheaper and longer-legged than the Mirage III in ground attack, it kept the same delta airframe and outright speed.\n\n## Operational career\nThe 50 Israeli aircraft, already paid for, were **impounded by de Gaulle** during the June 1967 embargo. Israel responded by developing its own derivative, the **IAI Nesher**, from covertly obtained drawings. The Mirage 5 found twelve other customers — Belgium, Pakistan, Peru, Egypt, Colombia, Venezuela, Zaire, Libya, the UAE — and fought in the Yom Kippur War with Egyptian and Libyan units.\n\n## Place in history\nThe 1967 embargo was a turning point: it pushed Israel to build its own aviation industry, which produced the Nesher and then the Kfir. The Mirage 5 thus unintentionally founded a competitor.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1966-01-01',
    '1967-05-19',
    '1970-01-01',
    2350.0,
    4000.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM armement WHERE name = 'AS-30')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM armement WHERE name = 'Bombe lisse 400 kg')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM wars WHERE name = 'Guerre du Kippour')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM wars WHERE name = 'Conflit israélo-arabe')),
((SELECT id FROM airplanes WHERE name = 'Mirage 5'), (SELECT id FROM wars WHERE name = 'Guerre du Liban'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.55,
  wingspan          = 8.22,
  height            = 4.5,
  wing_area         = 35.0,
  empty_weight      = 6600,
  mtow              = 13700,
  service_ceiling   = 18000,
  climb_rate        = 111,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 1300,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 9C',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 41.0,
  thrust_wet        = 60.8,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1992,
  units_built       = 582,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 12,
  variants          = E'- **Mirage 5J** : 50 appareils commandés par Israël, jamais livrés (embargo de 1967)\n- **Mirage 5BA / BR** : versions belges construites sous licence par la SABCA\n- **Mirage 5PA** : version pakistanaise, capacité antinavire Exocet\n- **Mirage 50** : moteur Atar 9K-50 plus puissant',
  variants_en       = E'- **Mirage 5J** : 50 aircraft ordered by Israel, never delivered (1967 embargo)\n- **Mirage 5BA / BR** : Belgian versions licence-built by SABCA\n- **Mirage 5PA** : Pakistani version with Exocet anti-ship capability\n- **Mirage 50** : uprated Atar 9K-50 engine',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_5',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Mirage_5',
  youtube_showcase  = NULL,
  manufacturer_page = 'https://www.dassault-aviation.com/fr/passion/avions/',
  image_credit      = 'Anidaat',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Mirage 5';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mirage 5';
