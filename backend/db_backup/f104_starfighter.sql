-- Lockheed F-104 Starfighter
--
-- Photo : Lockheed F-104G Starfighter D-8114 (9179542542).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File%3ALockheed_F-104G_Starfighter_D-8114_%289179542542%29.jpg

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
    'F-104 Starfighter',
    'F-104 Starfighter',
    'Lockheed F-104 Starfighter',
    'Lockheed F-104 Starfighter',
    'Intercepteur à aile minuscule, « le missile habité »',
    'Interceptor with a tiny wing, “the missile with a man in it”',
    '/assets/airplanes/f104-starfighter.jpg',
    E'## Genèse\nEn 1951, **Clarence « Kelly » Johnson** interroge des pilotes de chasse rentrant de Corée. Leur demande est unanime : un avion plus petit, plus simple, plus rapide, qui monte plus vite. Le Starfighter est la réponse littérale à cette demande — et la démonstration de ses limites.\n\n## Conception\nL''aile fait **6,68 mètres d''envergure** et 4 % d''épaisseur relative : ses bords d''attaque sont si coupants qu''on les protège au sol par des housses. Le fuselage est un tube autour du J79. Le résultat monte à 15 000 mètres en moins de deux minutes et bat les records d''altitude et de vitesse en 1958, mais vire mal, décroche sans prévenir et pardonne peu.\n\n## Carrière opérationnelle\nL''US Air Force s''en débarrasse vite. C''est l''**Europe** qui en fait un avion de masse : la version F-104G, renforcée pour la pénétration nucléaire à basse altitude — l''exact opposé de sa vocation — est produite à plus de 1 100 exemplaires par un consortium germano-italo-néerlando-belge. La Luftwaffe en perdra **292 sur 916**, avec 116 pilotes tués.\n\n## Place dans l''histoire\nLe Starfighter porte deux héritages lourds : la controverse allemande sur l''inadéquation d''un intercepteur de haute altitude à la frappe basse, et le **scandale Lockheed** de 1976, l''affaire de corruption la plus retentissante de l''industrie aéronautique d''après-guerre.',
    E'## Genesis\nIn 1951 **Clarence “Kelly” Johnson** interviewed fighter pilots returning from Korea. Their request was unanimous: a smaller, simpler, faster aircraft that climbed better. The Starfighter is the literal answer to that request — and the demonstration of its limits.\n\n## Design\nThe wing spans **6.68 metres** at 4% thickness: its leading edges are so sharp they are covered on the ground. The fuselage is a tube around the J79. The result climbs to 15,000 metres in under two minutes and took the altitude and speed records in 1958, but turns poorly, stalls without warning and forgives little.\n\n## Operational career\nThe US Air Force shed it quickly. It was **Europe** that made it a mass aircraft: the F-104G, strengthened for low-level nuclear penetration — the exact opposite of its design purpose — was built in more than 1,100 examples by a German-Italian-Dutch-Belgian consortium. The Luftwaffe lost **292 out of 916**, with 116 pilots killed.\n\n## Place in history\nThe Starfighter carries two heavy legacies: the German controversy over fitting a high-altitude interceptor to the low-level strike role, and the **Lockheed bribery scandal** of 1976, the most damaging corruption affair in post-war aviation.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-01-01',
    '1954-03-04',
    '1958-02-20',
    2137.0,
    2620.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.69,
  wingspan          = 6.68,
  height            = 4.11,
  wing_area         = 18.22,
  empty_weight      = 6350,
  mtow              = 13170,
  service_ceiling   = 15000,
  climb_rate        = 244,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 670,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J79-GE-11A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 46.7,
  thrust_wet        = 70.3,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1979,
  units_built       = 2578,
  unit_cost_usd     = 1700000,
  unit_cost_year    = 1960,
  operators_count   = 15,
  variants          = E'- **F-104A / C** : intercepteur et chasseur-bombardier de l''US Air Force\n- **F-104G** : version multirôle renforcée, produite en Europe sous licence\n- **F-104S** : version italienne à missiles Sparrow, la plus tardive\n- **F-104J** : version japonaise d''interception, construite par Mitsubishi',
  variants_en       = E'- **F-104A / C** : US Air Force interceptor and fighter-bomber\n- **F-104G** : strengthened multirole version, licence-built in Europe\n- **F-104S** : Italian Sparrow-armed version, the last built\n- **F-104J** : Japanese interceptor version, built by Mitsubishi',

  -- Strate 4 : qualitatif
  nickname          = 'Missile with a man in it',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'F-104 Starfighter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-104 Starfighter';
