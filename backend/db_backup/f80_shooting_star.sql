-- Lockheed P-80 / F-80 Shooting Star
--
-- Photo : 45-8612 LOCKHEED P-80B SHOOTING STAR (11888616644).jpg
--   licence CC BY-SA 2.0 — Eric Salard
--   https://commons.wikimedia.org/wiki/File%3A45-8612_LOCKHEED_P-80B_SHOOTING_STAR_%2811888616644%29.jpg

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
    'F-80 Shooting Star',
    'F-80 Shooting Star',
    'Lockheed P-80 / F-80 Shooting Star',
    'Lockheed P-80 / F-80 Shooting Star',
    'Premier avion à réaction opérationnel de l’aviation américaine',
    'The first operational jet aircraft of the American air force',
    '/assets/airplanes/f80-shooting-star.jpg',
    E'## Genèse\nEn juin 1943, l''Amérique découvre que l''Allemagne et la Grande-Bretagne ont des chasseurs à réaction en vol et qu''elle n''a rien. Lockheed confie le projet à **Clarence « Kelly » Johnson**, qui promet un prototype en cent quatre-vingts jours. Son équipe travaille à l''écart, dans un atelier improvisé sous une tente de cirque montée près d''une usine de plastique dont l''odeur vaudra au lieu son surnom : la **Skunk Works**. Le prototype vole en cent quarante-trois jours. Le bureau d''études secret qui donnera plus tard le U-2, le SR-71 et le F-117 vient de naître avec cet avion.\n\n## Conception\nAile droite et fuselage lisse construit autour du réacteur Halford britannique, remplacé en série par l''Allison J33. Les entrées d''air sont placées **à la racine de l''aile**, laissant le nez libre pour six mitrailleuses de 12,7 mm groupées. La formule est classique, presque conservatrice : l''enjeu n''est pas d''innover mais de mettre au plus vite un chasseur à réaction fiable en escadre.\n\n## Carrière opérationnelle\nArrivé trop tard pour la Seconde Guerre mondiale, il est en revanche le premier chasseur américain engagé en **Corée**. Le 8 novembre 1950, un F-80C revendique la destruction d''un MiG-15 : c''est, selon les sources américaines, **le premier combat aérien de l''histoire entre deux avions à réaction**. La suite est plus rude — l''aile droite du F-80 ne peut rien contre l''aile en flèche du MiG, et il est vite reversé à l''attaque au sol, où il effectue quatre-vingt-dix-huit mille sorties.\n\n## Place dans l''histoire\nIl n''a été supérieur à personne bien longtemps, et c''est presque secondaire. Il a fait entrer l''aviation de chasse américaine dans l''ère de la réaction, engendré le **T-33** sur lequel des dizaines de milliers de pilotes occidentaux apprendront leur métier, et fondé la Skunk Works. Le **F-86 Sabre**, qui reprendra le flambeau en Corée avec une aile en flèche, lui doit sa place.',
    E'## Genesis\nIn June 1943 America discovered that Germany and Britain had jet fighters flying and that it had nothing. Lockheed handed the project to **Clarence “Kelly” Johnson**, who promised a prototype in one hundred and eighty days. His team worked apart, in a makeshift shop under a circus tent pitched near a plastics plant whose smell earned the place its nickname: the **Skunk Works**. The prototype flew in one hundred and forty-three days. The secret design office that would later produce the U-2, the SR-71 and the F-117 was born with this aircraft.\n\n## Design\nA straight wing and a clean fuselage built around the British Halford engine, replaced in production by the Allison J33. The intakes sit **at the wing roots**, leaving the nose free for six grouped 12.7 mm machine guns. The formula is conventional, almost conservative: the point was not to innovate but to get a reliable jet fighter into squadrons as fast as possible.\n\n## Operational career\nToo late for the Second World War, it was on the other hand the first American fighter committed in **Korea**. On 8 November 1950 an F-80C claimed a MiG-15 destroyed: by American accounts, **the first air combat in history between two jet aircraft**. What followed was harder — the F-80''s straight wing could do nothing against the MiG''s swept wing, and it was soon switched to ground attack, where it flew ninety-eight thousand sorties.\n\n## Place in history\nIt was not superior to anyone for very long, and that is almost beside the point. It took American fighter aviation into the jet age, fathered the **T-33** on which tens of thousands of Western pilots would learn their trade, and founded the Skunk Works. The **F-86 Sabre**, which took over in Korea with a swept wing, owes it its place.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1943-06-17',
    '1944-01-08',
    '1945-02-01',
    965.0,
    1930.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.49,
  wingspan          = 11.81,
  height            = 3.43,
  wing_area         = 22.07,
  empty_weight      = 3819,
  mtow              = 7646,
  service_ceiling   = 14265,
  climb_rate        = 23.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 360,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J33-A-35',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 24.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1944,
  production_end    = 1950,
  units_built       = 1715,
  unit_cost_usd     = 93000,
  unit_cost_year    = 1950,
  operators_count   = 12,
  variants          = E'- **P-80A / B** : versions initiales, mises en service en 1945\n- **F-80C** : version de combat principale, celle de la guerre de Corée\n- **RF-80** : version de reconnaissance photographique\n- **T-33 Shooting Star** : dérivé biplace d''entraînement, produit en bien plus grand nombre\n- **F-94 Starfire** : chasseur de nuit dérivé de la même cellule',
  variants_en       = E'- **P-80A / B** : initial versions, entering service in 1945\n- **F-80C** : the main combat version, the one of the Korean War\n- **RF-80** : photographic reconnaissance version\n- **T-33 Shooting Star** : two-seat trainer derivative, built in far greater numbers\n- **F-94 Starfire** : night fighter derived from the same airframe',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_P-80_Shooting_Star',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_P-80_Shooting_Star',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Eric Salard',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'F-80 Shooting Star';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-80 Shooting Star';
