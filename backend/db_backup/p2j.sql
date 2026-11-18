-- Kawasaki P-2J Neptune (P2V-Kai)
--
-- Photo : Lockheed - Kawasaki P2V-7 - P-2J Neptune ‘82 - 4782 - 海上自衛隊’ (4782) (28976724135).jpg
--   licence CC0 — 先従隗始
--   https://commons.wikimedia.org/wiki/File:Lockheed_-_Kawasaki_P2V-7_-_P-2J_Neptune_%E2%80%9882_-_4782_-_%E6%B5%B7%E4%B8%8A%E8%87%AA%E8%A1%9B%E9%9A%8A%E2%80%99_(4782)_(28976724135).jpg

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
    'Kawasaki P-2J',
    'Kawasaki P-2J',
    'Kawasaki P-2J Neptune (P2V-Kai)',
    'Kawasaki P-2J Neptune (P2V-Kai)',
    'Le dernier Neptune, refait au Japon avec des turbopropulseurs et des réacteurs d''appoint japonais',
    'The last Neptune, rebuilt in Japan with Japanese turboprops and booster jets',
    '/assets/airplanes/kawasaki-p2j.jpg',
    E'## Genèse\nAu début des années 1960, la force maritime d''autodéfense japonaise vole sur des **P-2 Neptune** de Lockheed à moteurs en étoile. Plutôt que d''acheter le **P-3 Orion**, plus gros et bien plus cher, le Japon choisit une autre voie : moderniser l''avion existant, confié à Kawasaki. Le projet, d''abord appelé **P2V-Kai** (« Kai » signifiant modification), démarre en 1961. Un premier exemplaire, transformé à partir d''un P2V-7, vole le **21 juillet 1966**.\n\n## Conception\nLes moteurs en étoile Wright cèdent la place à deux turbopropulseurs **Ishikawajima-Harima T64-IHI-10** de 2 850 ch, à hélices tripales au lieu des quadripales des derniers Neptune. Sous les ailes, deux réacteurs d''appoint J3-IHI-7C de 13,7 kN servent au décollage et en action, et portent la vitesse maximale à 650 km/h. Le fuselage avant est allongé de 1,30 mètre, l''empennage agrandi et redessiné, le radar de recherche AN/APS-80 logé dans un radôme plus petit. Une avionique plus compacte libère de la masse pour du carburant supplémentaire, et le train principal reçoit deux roues par jambe. Jusqu''à douze hommes d''équipage prennent place à bord, avec torpilles, grenades anti-sous-marines, bombes et roquettes.\n\n## Carrière opérationnelle\nAprès le prototype, Kawasaki construit 82 P-2J neufs, le dernier livré en mars 1979. Mis en service en 1969, ils assurent la patrouille maritime et la lutte anti-sous-marine. Dans les années 1980, ils sont progressivement remplacés par le **P-3C Orion** ; la dernière escadrille de reconnaissance maritime passe à l''Orion en 1993. Le P-2J survit encore quelque temps sous d''autres formes : deux **EP-2J** de renseignement électronique et quatre **UP-2J** de soutien aux drones, de remorquage de cibles et d''essais, jusqu''au retrait de 1996.\n\n## Place dans l''histoire\nLe P-2J est la toute dernière version du Neptune à avoir été produite, et la plus profondément transformée. Avec ses moteurs fabriqués au Japon, il montre l''industrie aéronautique japonaise capable de reprendre en profondeur un patrouilleur américain plutôt que d''en acheter un nouveau, et de le faire voler jusqu''en 1996, trente ans après le premier vol du P2V-Kai.',
    E'## Genesis\nIn the early 1960s, the Japan Maritime Self-Defense Force was flying Lockheed **P-2 Neptunes** with radial engines. Rather than buy the **P-3 Orion**, larger and much more expensive, Japan chose another route: modernise the existing aircraft, a task given to Kawasaki. The project, first called **P2V-Kai** ("Kai" meaning modification), began in 1961. A first example, converted from a P2V-7, flew on **21 July 1966**.\n\n## Design\nThe Wright radials gave way to two 2,850 hp **Ishikawajima-Harima T64-IHI-10** turboprops with three-bladed propellers instead of the four-bladed units of late Neptunes. Under the wings, two 13.7 kN J3-IHI-7C booster jets were used for take-off and in action, raising top speed to 650 km/h. The forward fuselage was lengthened by 1.30 metres, the tail surfaces enlarged and reshaped, and the AN/APS-80 search radar housed in a smaller radome. More compact avionics saved weight for extra fuel, and the main gear received two wheels per leg. Up to twelve crew members could be carried, with torpedoes, depth charges, bombs and rockets.\n\n## Operational career\nAfter the prototype, Kawasaki built 82 new P-2Js, the last delivered in March 1979. Introduced in 1969, they flew maritime patrol and anti-submarine warfare missions. In the 1980s they were gradually replaced by the **P-3C Orion**; the last maritime reconnaissance squadron converted to the Orion in 1993. The P-2J survived for a while in other forms: two **EP-2J** electronic intelligence aircraft and four **UP-2J** drone support, target towing and test aircraft, until retirement in 1996.\n\n## Place in history\nThe P-2J is the very last version of the Neptune to have been produced, and the most deeply modified. With its Japanese-built engines, it shows a Japanese aircraft industry able to rework an American patrol aircraft in depth rather than buy a new one, and to keep it flying until 1996, thirty years after the P2V-Kai''s first flight.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1961-01-01',
    '1966-07-21',
    '1969-01-01',
    650,
    4445,
    (SELECT id FROM manufacturer WHERE code = 'KHI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-2J'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-2J'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-2J'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-2J'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-2J'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki P-2J'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.23,
  wingspan          = 30.87,
  height            = 8.93,
  wing_area         = 92.9,
  empty_weight      = 19278,
  mtow              = 34020,
  service_ceiling   = 9100,
  climb_rate        = 9.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 12,

  -- Strate 2 : motorisation
  engine_name       = '2 Ishikawajima-Harima T64-IHI-10 (2 850 ch) + 2 réacteurs d''appoint J3-IHI-7C (13,7 kN)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = 1979,
  units_built       = 83,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **P2V-Kai** : prototype converti d''un P2V-7 (P-2H), premier vol le 21 juillet 1966\n- **P-2J** : version de série, turbopropulseurs T64 et réacteurs d''appoint J3, radar APS-80, 82 exemplaires neufs\n- **EP-2J** : renseignement électronique, deux appareils convertis\n- **UP-2J** : soutien aux drones, remorquage de cibles et essais, quatre appareils convertis',
  variants_en       = E'- **P2V-Kai**: prototype converted from a P2V-7 (P-2H), first flight on 21 July 1966\n- **P-2J**: production version with T64 turboprops, J3 booster jets and APS-80 radar, 82 new-builds\n- **EP-2J**: electronic intelligence, two aircraft converted\n- **UP-2J**: drone support, target towing and testing, four aircraft converted',

  -- Strate 4 : qualitatif
  nickname          = 'Neptune',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kawasaki_P-2J',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '先従隗始',
  image_licence     = 'CC0'
WHERE name = 'Kawasaki P-2J';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kawasaki P-2J';
