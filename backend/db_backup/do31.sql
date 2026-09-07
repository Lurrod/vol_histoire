-- Dornier Do 31 E
--
-- Photo : Dornier Do-31 E1 (47659347462).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany, Germany
--   https://commons.wikimedia.org/wiki/File%3ADornier_Do-31_E1_%2847659347462%29.jpg

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
    'Dornier Do 31',
    'Dornier Do 31',
    'Dornier Do 31 E',
    'Dornier Do 31 E',
    'Seul transport à réaction à décollage vertical jamais construit',
    'The only jet transport with vertical take-off ever built',
    '/assets/airplanes/do31.jpg',
    E'## Genèse\nLa doctrine ouest-allemande des années 1960 tient en une phrase : les bases aériennes seront détruites dans la première heure. D''où le **Fiat G.91** dispersé sur des routes et dans des clairières — mais un chasseur dispersé doit être ravitaillé en carburant, en munitions et en mécaniciens. Un transport classique a besoin d''une piste. Il fallait donc un transport qui n''en ait pas besoin.\n\n## Conception\nDornier empile les deux formules concurrentes plutôt que de choisir. Deux **Pegasus** orientables assurent à la fois la sustentation partielle et la propulsion ; **huit** petits RB.162 logés dans des nacelles en bout d''aile fournissent le reste de la portance au décollage, puis se taisent. Dix moteurs pour vingt-sept tonnes. L''appareil emporte trente-six soldats ou trois tonnes de fret, et se pose n''importe où.\n\n## Carrière opérationnelle\nAucune. Trois cellules, deux volantes, une centaine de vols entre 1967 et 1970. Le Do 31 se présente au **Salon du Bourget de 1969** et y bat trois records du monde ADAV qu''il détient encore. Il est aussi le seul transport à réaction à décollage vertical jamais construit — et le restera.\n\n## Place dans l''histoire\nTrois exemplaires. Le calcul a fini par le condamner : les huit réacteurs de sustentation sont du poids mort pendant tout le vol, l''appareil consomme le double d''un **C-160 Transall** pour la moitié de la charge, et son rayon d''action fond. L''Allemagne arrête en 1970 et achète des hélicoptères, qui font le même travail moins vite mais infiniment moins cher.',
    E'## Genesis\nWest German doctrine in the 1960s came down to one sentence: the air bases will be destroyed in the first hour. Hence the **Fiat G.91** dispersed onto roads and into clearings — but a dispersed fighter must be resupplied with fuel, ammunition and mechanics. A conventional transport needs a runway. So a transport was needed that did not.\n\n## Design\nDornier stacked the two competing formulas rather than choosing between them. Two swivelling **Pegasus** provide both partial lift and propulsion; **eight** small RB.162s in wingtip pods supply the rest of the lift on take-off, then fall silent. Ten engines for twenty-seven tonnes. The aircraft carries thirty-six soldiers or three tonnes of freight, and lands anywhere.\n\n## Operational career\nNone. Three airframes, two of them flying, about a hundred flights between 1967 and 1970. The Do 31 appeared at the **1969 Paris Air Show** and set three world VTOL records there that it still holds. It is also the only vertical take-off jet transport ever built — and will remain so.\n\n## Place in history\nThree built. Arithmetic condemned it in the end: the eight lift engines are dead weight throughout the flight, the aircraft burns twice the fuel of a **C-160 Transall** for half the load, and its range melts away. Germany stopped in 1970 and bought helicopters, which do the same job more slowly but incomparably more cheaply.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1960-01-01',
    '1967-02-10',
    NULL,
    730.0,
    1800.0,
    (SELECT id FROM manufacturer WHERE code = 'DOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 31'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'Dornier Do 31'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 31'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Dornier Do 31'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier Do 31'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.53,
  wingspan          = 18.06,
  height            = 8.53,
  wing_area         = 57.0,
  empty_weight      = 15000,
  mtow              = 27442,
  service_ceiling   = 10500,
  climb_rate        = 25.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 650,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Pegasus 5-2 + 8 Rolls-Royce RB.162',
  engine_count      = 10,
  engine_type       = 'Turboréacteur à poussée vectorielle et réacteurs de sustentation',
  engine_type_en    = 'Vectored-thrust turbofan and lift jets',
  thrust_dry        = 69.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1967,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Do 31 E1 / E2 / E3** : trois exemplaires, dont un cellule d''essais statiques\n- **Dix moteurs** : deux Pegasus orientables en nacelle, huit RB.162 en bouts d''aile\n- Détient encore **trois records du monde** ADAV de vitesse, altitude et distance\n- Conçu pour ravitailler les **G.91 dispersés en forêt** en cas de guerre en Europe\n- Programme arrêté en 1970 : consommation et complexité jugées rédhibitoires',
  variants_en       = E'- **Do 31 E1 / E2 / E3** : three aircraft, one of them a static test airframe\n- **Ten engines**: two swivelling Pegasus in nacelles, eight RB.162 in wingtip pods\n- Still holds **three world VTOL records** for speed, altitude and distance\n- Designed to resupply **G.91s dispersed into forests** in a European war\n- Stopped in 1970: fuel consumption and complexity judged prohibitive',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dornier_Do_31',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dornier_Do_31',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters from Viersen, Germany, Germany',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Dornier Do 31';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dornier Do 31';
