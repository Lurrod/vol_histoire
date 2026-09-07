-- Rockwell XFV-12A
--
-- Photo : XFV-12A HC356-0-114G.jpg
--   licence Public domain — North American Aviation
--   https://commons.wikimedia.org/wiki/File%3AXFV-12A_HC356-0-114G.jpg

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
    'Rockwell XFV-12',
    'Rockwell XFV-12',
    'Rockwell XFV-12A',
    'Rockwell XFV-12A',
    'N’a jamais quitté le sol, même suspendu à une grue',
    'Never left the ground, even suspended from a crane',
    '/assets/airplanes/xfv12.jpg',
    E'## Genèse\nL''amiral Zumwalt veut, au début des années 1970, une marine de nombreux petits navires plutôt que de quelques géants : les **Sea Control Ships**, porte-aéronefs de vingt mille tonnes. Il leur faut un chasseur supersonique capable de décoller verticalement — ce que le Harrier, subsonique, ne sait pas faire. Rockwell propose une idée neuve et séduisante.\n\n## Conception\nPlutôt que d''orienter les gaz vers le bas, l''**aile à éjecteurs** les fait circuler dans des fentes ménagées dans la voilure et les canards. Par effet Venturi, ce jet doit **aspirer** l''air environnant et multiplier la poussée par sept — de quoi soulever l''appareil avec un seul réacteur. Pour économiser, la cellule est bricolée : nez d''**A-4 Skyhawk**, entrées d''air de **F-4 Phantom**, réacteur de F-14.\n\n## Carrière opérationnelle\nAucune, au sens le plus strict : l''appareil n''a **jamais volé**. Les essais de 1978, menés sur un portique de levage, révèlent que le multiplicateur d''éjection promis ne se produit pas. La poussée utile plafonne à **55 %** du calcul — l''appareil, suspendu à sa grue, est incapable de soulever son propre poids.\n\n## Place dans l''histoire\nUn exemplaire, zéro vol. Le programme est annulé en 1981, en même temps que les Sea Control Ships. Il illustre un piège classique de l''ingénierie : un effet vérifié en soufflerie sur maquette qui ne se reproduit pas à l''échelle réelle. Les États-Unis n''obtiendront un chasseur supersonique à décollage vertical qu''avec le **F-35B**, trente ans plus tard.',
    E'## Genesis\nIn the early 1970s Admiral Zumwalt wanted a navy of many small ships rather than a few giants: the **Sea Control Ships**, twenty-thousand-tonne aviation vessels. They needed a supersonic fighter able to take off vertically — something the subsonic Harrier could not do. Rockwell proposed a new and attractive idea.\n\n## Design\nRather than deflecting the gas downward, the **ejector wing** routes it through slots cut into the wing and canards. By the Venturi effect this jet was to **entrain** the surrounding air and multiply thrust sevenfold — enough to lift the aircraft on a single engine. To save money the airframe was cobbled together: **A-4 Skyhawk** nose, **F-4 Phantom** intakes, F-14 engine.\n\n## Operational career\nNone, in the strictest sense: the aircraft **never flew**. The 1978 trials, run on a lifting gantry, showed that the promised ejector multiplication did not occur. Useful thrust topped out at **55%** of prediction — the aircraft, hanging from its crane, could not lift its own weight.\n\n## Place in history\nOne built, zero flights. The programme was cancelled in 1981, along with the Sea Control Ships. It illustrates a classic engineering trap: an effect verified on a wind-tunnel model that does not reproduce at full scale. The United States would not get a supersonic vertical take-off fighter until the **F-35B**, thirty years later.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1972-01-01',
    NULL,
    NULL,
    2660.0,
    900.0,
    (SELECT id FROM manufacturer WHERE code = 'ROC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Rockwell XFV-12'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Rockwell XFV-12'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Rockwell XFV-12'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Rockwell XFV-12'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Rockwell XFV-12'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.35,
  wingspan          = 8.69,
  height            = 3.15,
  wing_area         = 27.4,
  empty_weight      = 6260,
  mtow              = 11430,
  service_ceiling   = 18300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 460,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney F401-PW-400',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 64.5,
  thrust_wet        = 133.4,

  -- Strate 3 : production & service
  production_start  = 1974,
  production_end    = 1977,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XFV-12A** : un seul exemplaire, jamais volant\n- Nez et cockpit repris d''un **A-4 Skyhawk**, prises d''air d''un **F-4 Phantom**\n- **Aile à éjecteurs** : les gaz du réacteur devaient aspirer sept fois leur masse d''air\n- Essais en 1978 : la poussée réelle atteint **55 %** du calcul, l''appareil ne décolle pas\n- Devait équiper les **Sea Control Ships**, projet de petits porte-avions abandonné',
  variants_en       = E'- **XFV-12A** : a single aircraft, never flown\n- Nose and cockpit from an **A-4 Skyhawk**, intakes from an **F-4 Phantom**\n- **Ejector wing**: engine gas was to entrain seven times its own mass of air\n- 1978 trials: real thrust reached **55%** of prediction, the aircraft would not lift\n- Was to equip the **Sea Control Ships**, an abandoned small-carrier project',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Rockwell_XFV-12',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Rockwell_XFV-12',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'North American Aviation',
  image_licence     = 'Public domain'
WHERE name = 'Rockwell XFV-12';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Rockwell XFV-12';
