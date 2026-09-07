-- Atlas Cheetah
--
-- Photo : SAAF Cheetah-C 344 (13703004263).jpg
--   licence CC BY-SA 2.0 — Bob Adams from George, South Africa
--   https://commons.wikimedia.org/wiki/File%3ASAAF_Cheetah-C_344_%2813703004263%29.jpg

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
    'Atlas Cheetah',
    'Atlas Cheetah',
    'Atlas Cheetah',
    'Atlas Cheetah',
    'Mirage III refondu par l’Afrique du Sud sous embargo',
    'Mirage III rebuilt by South Africa under embargo',
    '/assets/airplanes/atlas-cheetah.jpg',
    E'## Genèse\nL''embargo des Nations unies de 1977 coupe l''Afrique du Sud de tout achat d''armement. Sa flotte de **Mirage III**, achetée dans les années 1960, vieillit face aux MiG-23 angolais et cubains. Faute de pouvoir acheter, Pretoria décide de reconstruire — avec l''assistance discrète d''**Israël**, alors dans une situation comparable.\n\n## Conception\nLe Cheetah n''est pas une modernisation mais une refonte : **cinquante pour cent de la cellule** est remplacée. Nez allongé abritant un nouveau radar, plans canard rapprochés, dents de chien sur le bord d''attaque, perche de ravitaillement, avionique et poste de pilotage entièrement neufs. La parenté avec le **IAI Kfir** israélien est évidente et n''a jamais été officiellement expliquée.\n\n## Carrière opérationnelle\nLivré en 1987, trop tard pour la guerre frontalière avec l''Angola qui s''achève en 1989. Le Cheetah C reste l''épine dorsale de la chasse sud-africaine jusqu''en 2008, date de son remplacement par le **Gripen**. Treize appareils sont revendus à l''Équateur en 2011.\n\n## Place dans l''histoire\nLe Cheetah complète une famille que cette encyclopédie documente maintenant en entier : à partir du même Mirage III, l''**IAI Nesher** et le **Kfir** en Israël, le Cheetah en Afrique du Sud — trois pays sous embargo ayant chacun reconstruit le même appareil, chacun de son côté et souvent en s''entraidant.',
    E'## Genesis\nThe 1977 United Nations embargo cut South Africa off from all arms purchases. Its **Mirage III** fleet, bought in the 1960s, was ageing against Angolan and Cuban MiG-23s. Unable to buy, Pretoria decided to rebuild — with discreet assistance from **Israel**, then in a comparable position.\n\n## Design\nThe Cheetah is not an upgrade but a rebuild: **fifty per cent of the airframe** was replaced. A lengthened nose housing a new radar, close-coupled canards, dog-tooth leading edges, a refuelling probe, and entirely new avionics and cockpit. The kinship with Israel’s **IAI Kfir** is obvious and has never been officially explained.\n\n## Operational career\nDelivered in 1987, too late for the border war with Angola that ended in 1989. The Cheetah C remained the backbone of South African fighter aviation until 2008, when it was replaced by the **Gripen**. Thirteen aircraft were sold to Ecuador in 2011.\n\n## Place in history\nThe Cheetah completes a family this encyclopedia now documents in full: from the same Mirage III came the **IAI Nesher** and the **Kfir** in Israel, and the Cheetah in South Africa — three embargoed countries each rebuilding the same aircraft, separately and often helping one another.',
    (SELECT id FROM countries WHERE code = 'ZAF'),
    '1983-01-01',
    '1986-07-16',
    '1987-07-01',
    2350.0,
    2600.0,
    (SELECT id FROM manufacturer WHERE code = 'ATL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM armement WHERE name = 'DEFA 552')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM armement WHERE name = 'Python 3')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

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
  service_ceiling   = 17000,
  climb_rate        = 111,
  g_limit_pos       = 7.5,
  g_limit_neg       = -3.5,
  combat_radius     = 1200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA Atar 9K-50',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 49.2,
  thrust_wet        = 70.6,

  -- Strate 3 : production & service
  production_start  = 1986,
  production_end    = 1992,
  units_built       = 38,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Cheetah D** : biplace, première version livrée\n- **Cheetah E** : monoplace d''interception, retirée dès 1992\n- **Cheetah C** : version définitive, radar Elta et perche de ravitaillement\n- Treize Cheetah C revendus à l''**Équateur** en 2011, derniers exemplaires en service',
  variants_en       = E'- **Cheetah D** : two-seat, the first version delivered\n- **Cheetah E** : single-seat interceptor, withdrawn as early as 1992\n- **Cheetah C** : definitive version with Elta radar and refuelling probe\n- Thirteen Cheetah Cs sold to **Ecuador** in 2011, the last in service',

  -- Strate 4 : qualitatif
  nickname          = 'Cheetah',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Atlas_Cheetah',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Atlas_Cheetah',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bob Adams from George, South Africa',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Atlas Cheetah';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Atlas Cheetah';
