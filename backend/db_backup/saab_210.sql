-- Saab 210 Lilldraken
--
-- Photo : Saab 210 Lilldraken.jpg
--   licence Public domain — Saab AB
--   https://commons.wikimedia.org/wiki/File:Saab_210_Lilldraken.jpg

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
    'Saab 210',
    'Saab 210',
    'Saab 210 Lilldraken',
    'Saab 210 Lilldraken',
    'Draken réduit à 70 %, construit pour apprivoiser à basse vitesse l''aile en double delta du futur chasseur suédois',
    'A 70 per cent scale Draken built to tame the Swedish fighter''s double-delta wing at low speed',
    '/assets/airplanes/saab-210.jpg',
    E'## Genèse\nAu début des années 1950, **Saab** étudie, sous la direction de l''ingénieur **Erik Bratt**, un chasseur supersonique doté d''une aile en double delta. La formule est inédite et très avancée, et nul ne sait encore comment elle se comportera à basse vitesse, au décollage comme à l''atterrissage. Plutôt que d''exposer le futur chasseur à cette inconnue, Saab construit un petit avion d''essais aérodynamiques, le **Type 210**, qui reproduit sa voilure à environ 70 % de l''échelle. Le chasseur prend entre-temps la désignation **J 35 Draken**, et le petit appareil hérite du surnom officieux de **Lilldraken**, le « petit dragon » ou le « petit cerf-volant ».\n\n## Conception\nLe 210 n''a pas d''empennage horizontal : son aile en double delta s''étend presque jusqu''au nez. Les entrées d''air, intégrées à l''emplanture, s''ouvrent juste derrière un nez minuscule, et le pilote est assis sous une verrière en bulle saillante, devant une dérive en flèche. Le train tricycle n''est que partiellement escamotable. Un petit turboréacteur **Armstrong Siddeley Adder** de 4,67 kN suffit à pousser cet avion de 6,1 m de long jusqu''à 644 km/h, largement assez pour étudier le vol lent.\n\n## Essais\nLe 210 effectue son premier vol le 21 janvier 1952, aux mains de **Bengt Olow**, puis mène une longue campagne d''essais. Il est ensuite modifié pour une seconde phase : les entrées d''air sont reculées de part et d''autre du cockpit, pour élargir le champ de vision du pilote, et un parachute de freinage est ajouté. L''avion devient alors le **210B**, et sa configuration d''origine est rebaptisée a posteriori 210A. À son dernier vol, le 25 octobre 1955, le Lilldraken totalise 887 sorties sous ses deux formes.\n\n## Place dans l''histoire\nLe 210 a validé en vol la formule en double delta qui donne au **Saab 35 Draken** sa silhouette si particulière. Le nom de Draken viendrait d''ailleurs de l''allure du prototype du Type 35, qui évoquait vu de dessus un cerf-volant de papier, et le petit banc d''essai a pris le sien par ricochet. Seul exemplaire construit, le Saab 210B est aujourd''hui exposé au **Flygvapenmuseum** de Linköping, le musée de l''armée de l''air suédoise.',
    E'## Genesis\nIn the early 1950s **Saab**, under designer **Erik Bratt**, was working on a supersonic fighter with a double-delta wing. The layout was novel and highly advanced, and nobody yet knew how it would behave at low speed, on take-off and landing. Rather than expose the future fighter to that unknown, Saab built a small aerodynamic test aircraft, the **Type 210**, reproducing its wing at roughly 70 per cent scale. By then the fighter had become the **J 35 Draken**, and the little aircraft picked up the unofficial nickname **Lilldraken**, the ''Little Dragon'' or ''Little Kite''.\n\n## Design\nThe 210 had no tailplane: its double-delta wing ran almost to the nose. The integral wing-root intakes opened just behind a tiny nose, and the pilot sat under a protruding bubble canopy, ahead of a swept fin. The tricycle undercarriage was only semi-retractable. A small **Armstrong Siddeley Adder** turbojet of 4.67 kN was enough to push this 6.1 m aircraft to 644 km/h, ample for slow-flight research.\n\n## Testing\nThe 210 first flew on 21 January 1952, flown by **Bengt Olow**, and went on to an extensive flight test programme. It was then modified for a second phase: the intakes were moved back alongside the cockpit to improve the pilot''s field of view, and a drogue parachute was added. In this form it became the **210B**, and the original configuration was retrospectively called the 210A. By its last flight, on 25 October 1955, the Lilldraken had flown 887 sorties in its two forms.\n\n## Place in history\nThe 210 proved in flight the double-delta layout that gives the **Saab 35 Draken** its distinctive shape. The Draken name itself is said to come from the look of the Type 35 prototype, which resembled a paper kite when seen from above, and the little testbed took its own nickname from it. The only example built, the Saab 210B is now displayed at the **Flygvapenmuseum** in Linköping, the Swedish Air Force Museum.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    NULL,
    '1952-01-21',
    NULL,
    644,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 210'), (SELECT id FROM tech WHERE name = 'Configuration aérodynamique en double delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 210'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.1,
  wingspan          = 4.88,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Adder',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 4.67,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **210 (210A)** : configuration d''origine, entrées d''air à l''emplanture juste derrière le nez, premier vol le 21 janvier 1952\n- **210B** : entrées d''air reculées de part et d''autre du cockpit pour la visibilité, parachute de freinage, dernier vol le 25 octobre 1955, conservé au Flygvapenmuseum',
  variants_en       = E'- **210 (210A)**: original configuration with wing-root intakes just behind the nose, first flight on 21 January 1952\n- **210B**: intakes moved back alongside the cockpit for visibility, drogue parachute, last flight on 25 October 1955, preserved at the Flygvapenmuseum',

  -- Strate 4 : qualitatif
  nickname          = 'Lilldraken',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_210',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Saab AB',
  image_licence     = 'Public domain'
WHERE name = 'Saab 210';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 210';
