-- Rockwell-MBB X-31
--
-- Photo : X-31 No.1 in Flight.jpg
--   licence Public domain — Jim Ross, NASA Dryden Flight Research Center (NASA-DFRC)
--   https://commons.wikimedia.org/wiki/File%3AX-31_No.1_in_Flight.jpg

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
    'X-31',
    'X-31',
    'Rockwell-MBB X-31',
    'Rockwell-MBB X-31',
    'Le manœuvre Herbst : virer sur place au-delà du décrochage',
    'The Herbst manoeuvre: turning on the spot beyond the stall',
    '/assets/airplanes/x31.jpg',
    E'## Genèse\nL''ingénieur allemand **Wolfgang Herbst** défend dans les années 1980 une idée contre-intuitive : dans un combat tournoyant, celui qui pointe son nez le premier gagne, même s''il perd toute sa vitesse en le faisant. Or au-delà du décrochage, un avion classique ne répond plus. Il faudrait un appareil capable de **manœuvrer sans portance**.\n\n## Conception\nLa réponse est la poussée vectorielle. Faute de tuyère orientable disponible, Rockwell et MBB montent **trois palettes en carbone-carbone** autour de la tuyère, qui plongent dans le jet pour le dévier. L''appareil est un delta-canard compact, entièrement piloté par calculateur : à 70 degrés d''incidence, les gouvernes ne servent plus à rien et seule la poussée fait tourner la machine.\n\n## Carrière opérationnelle\nAucune. Cinq cent quatre-vingts vols. Le X-31 exécute le **virage Herbst** : cabrer jusqu''à 70 degrés, pivoter sur place, replonger dans la direction opposée — un demi-tour en une fraction du rayon d''un chasseur classique. En combat simulé contre des F/A-18, il l''emporte dans **quatre-vingt-quatorze pour cent** des engagements rapprochés.\n\n## Place dans l''histoire\nDeux exemplaires, dont un perdu sur une sonde Pitot gelée en 1995. Le X-31 a fourni la démonstration en vol de la supermanœuvrabilité occidentale, que le **F-22 Raptor** intègre aujourd''hui avec une vraie tuyère orientable. Côté russe, le **Su-37** et le **Su-35** ont suivi le même chemin à partir du même constat.',
    E'## Genesis\nThe German engineer **Wolfgang Herbst** argued in the 1980s for a counter-intuitive idea: in a turning fight, whoever points their nose first wins, even at the cost of all their speed. But beyond the stall a conventional aircraft stops responding. What was needed was an aircraft able to **manoeuvre without lift**.\n\n## Design\nThe answer is thrust vectoring. With no swivelling nozzle available, Rockwell and MBB fitted **three carbon-carbon paddles** around the exhaust, dipping into the jet to deflect it. The aircraft is a compact delta-canard, flown entirely by computer: at 70 degrees angle of attack the control surfaces do nothing and only thrust turns the machine.\n\n## Operational career\nNone. Five hundred and eighty flights. The X-31 performed the **Herbst manoeuvre**: pitch up to 70 degrees, rotate on the spot, drop back the other way — a reversal in a fraction of a conventional fighter''s radius. In simulated combat against F/A-18s it won **ninety-four per cent** of close engagements.\n\n## Place in history\nTwo built, one lost to a frozen pitot tube in 1995. The X-31 gave the flight demonstration of Western supermanoeuvrability that the **F-22 Raptor** now embodies with a real vectoring nozzle. On the Russian side the **Su-37** and **Su-35** followed the same path from the same insight.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1986-01-01',
    '1990-10-11',
    NULL,
    1485.0,
    600.0,
    (SELECT id FROM manufacturer WHERE code = 'ROC'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'X-31'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'X-31'), (SELECT id FROM tech WHERE name = 'Aile delta-canard')),
((SELECT id FROM airplanes WHERE name = 'X-31'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'X-31'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'X-31'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.21,
  wingspan          = 7.26,
  height            = 4.44,
  wing_area         = 21.02,
  empty_weight      = 5175,
  mtow              = 7530,
  service_ceiling   = 12500,
  climb_rate        = 130.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 250,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-400',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 47.6,
  thrust_wet        = 71.2,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = 1990,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-31A** : deux exemplaires, cinq cent quatre-vingts vols de 1990 à 1995 puis 2001-2003\n- Programme germano-américain : **Rockwell** et **MBB**, seul avion X non exclusivement américain\n- **Trois palettes** en carbone-carbone dévient le jet, faute de tuyère orientable\n- Exécute le **virage Herbst** : demi-tour à 70° d''incidence, hors de tout domaine de vol\n- Le n°1 s''écrase en 1995 : une sonde de Pitot non chauffée, prise en glace',
  variants_en       = E'- **X-31A** : two aircraft, five hundred and eighty flights, 1990–1995 then 2001–2003\n- German-American programme: **Rockwell** and **MBB**, the only non-US-only X-plane\n- **Three carbon-carbon paddles** deflect the jet, in place of a vectoring nozzle\n- Performed the **Herbst manoeuvre**: a reversal at 70° AoA, outside any flight envelope\n- No. 1 crashed in 1995: an unheated pitot tube, iced over',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Rockwell-MBB_X-31',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Rockwell-MBB_X-31',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jim Ross, NASA Dryden Flight Research Center (NASA-DFRC)',
  image_licence     = 'Public domain'
WHERE name = 'X-31';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'X-31';
