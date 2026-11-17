-- Martin P6M SeaMaster
--
-- Photo : Martin YP6M-1 Seamaster in flight.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Martin_YP6M-1_Seamaster_in_flight.jpg

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
    'Martin P6M SeaMaster',
    'Martin P6M SeaMaster',
    'Martin P6M SeaMaster',
    'Martin P6M SeaMaster',
    'Hydravion à réaction de frappe nucléaire, annulé à six mois de sa mise en service par le missile Polaris',
    'A jet-powered nuclear strike flying boat, cancelled six months from service by the Polaris missile',
    '/assets/airplanes/p6m-seamaster.jpg',
    E'## Genèse\nAu lendemain de la guerre, la dissuasion nucléaire américaine repose tout entière sur le Strategic Air Command de l''US Air Force. L''US Navy, qui voit son prestige et ses budgets menacés, perd en 1950 le super porte-avions **USS United States**, conçu pour lancer des bombardiers stratégiques. Elle imagine alors une **force de frappe d''hydravions**, mobile et difficile à neutraliser, soutenue par des navires ravitailleurs ou des sous-marins. La spécification d''avril 1951 réclame un hydravion capable d''emporter 14 t d''armement à 2 400 km de sa base et de filer à Mach 0,9 au ras des flots ; Martin l''emporte face à Convair.\n\n## Conception\nLes quatre turboréacteurs, des **Allison J71** sur les premiers exemplaires, sont montés par paires au-dessus de l''aile pour échapper aux embruns. L''aile en flèche de 40° présente un net dièdre négatif, et ses réservoirs de bout d''aile servent de flotteurs. Le SeaMaster reprend plusieurs idées du **XB-51** : un empennage en T monobloc et une **soute rotative**, ici rendue étanche à l''eau de mer. Elle peut recevoir une bombe thermonucléaire **Mark 28**, des mines, des caméras de reconnaissance ou un kit de ravitaillement en vol. Sa structure est si robuste que le revêtement atteint plus de 25 mm d''épaisseur à l''emplanture.\n\n## Essais\nLe XP6M-1 vole le 14 juillet 1955, mais le premier prototype se désintègre en vol le 7 décembre 1955 à la suite d''une panne de commande, tuant ses quatre membres d''équipage ; le second est perdu le 9 novembre 1956, son équipage s''éjectant. Les six YP6M-1 de présérie reprennent les essais en 1958 depuis Harvey Point, en Caroline du Nord, mais leurs J71 sont peu fiables et l''avion avale des embruns à forte masse. Le **P6M-2**, à réacteurs **Pratt & Whitney J75** et perche de ravitaillement, sort au début de 1959 ; trois exemplaires volent et des équipages de la Navy sont en conversion quand le programme est annulé le 21 août 1959.\n\n## Place dans l''histoire\nÀ six mois de sa mise en service, le SeaMaster est sacrifié aux restrictions budgétaires et éclipsé par le missile balistique **Polaris**, tiré depuis des sous-marins, qui offre à la Navy une dissuasion autrement plus sûre. Martin tente sans succès d''en vendre une version civile, la SeaMistress, puis abandonne l''aviation pour les missiles et l''électronique : le P6M est le dernier avion de la Glenn L. Martin Company. Sur seize cellules, aucune n''a été conservée entière.',
    E'## Genesis\nAfter the war, American nuclear deterrence rested entirely on the US Air Force''s Strategic Air Command. The US Navy, seeing its prestige and budgets threatened, lost in 1950 the supercarrier **USS United States**, designed to launch strategic bombers. It then devised a **Seaplane Striking Force**, mobile and hard to neutralise, supported by tenders or submarines. The April 1951 specification called for a flying boat able to carry 14 tonnes of weapons 2,400 km from its base and to dash at Mach 0.9 at wave-top height; Martin won against Convair.\n\n## Design\nThe four turbojets, **Allison J71s** on the first aircraft, were paired above the wing to keep them clear of spray. The 40° swept wing had marked anhedral, and its tip tanks doubled as floats. The SeaMaster borrowed several ideas from the **XB-51**: an all-moving T-tail and a **rotating bomb bay**, here sealed against seawater. It could take a **Mark 28** thermonuclear bomb, mines, reconnaissance cameras or an in-flight refuelling kit. The structure was so strong that the skin at the wing roots was over 25 mm thick.\n\n## Testing\nThe XP6M-1 flew on 14 July 1955, but the first prototype broke up in flight on 7 December 1955 after a control failure, killing its crew of four; the second was lost on 9 November 1956, its crew ejecting. The six YP6M-1 pre-production aircraft resumed testing in 1958 from Harvey Point, North Carolina, but their J71s were unreliable and the aircraft ingested spray at high weights. The **P6M-2**, with **Pratt & Whitney J75** engines and a refuelling probe, appeared in early 1959; three flew, and Navy crews were converting to the type when the programme was cancelled on 21 August 1959.\n\n## Place in history\nSix months from service entry, the SeaMaster was sacrificed to budget cuts and eclipsed by the submarine-launched **Polaris** ballistic missile, which offered the Navy a far more secure deterrent. Martin tried in vain to sell a civil version, the SeaMistress, then left aircraft for missiles and electronics: the P6M was the last aircraft built by the Glenn L. Martin Company. Of sixteen airframes, none was preserved complete.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-04-01',
    '1955-07-14',
    NULL,
    1104,
    3352,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM tech WHERE name = 'Soute à bombes rotative')),
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM armement WHERE name = 'B28'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Martin P6M SeaMaster'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 40.94,
  wingspan          = 31.27,
  height            = 10.31,
  wing_area         = 180,
  empty_weight      = 44198,
  mtow              = 86183,
  service_ceiling   = 15000,
  climb_rate        = 37.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J75-P-2',
  engine_count      = 4,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 77.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1958,
  production_end    = 1959,
  units_built       = 16,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **XP6M-1** : deux prototypes à réacteurs Allison J71, tous deux perdus en 1955 et 1956\n- **YP6M-1** : six avions de présérie équipés pour le bombardement, le mouillage de mines et la reconnaissance\n- **P6M-2** : version de série à réacteurs J75, perche de ravitaillement et verrière améliorée, huit construits dont trois ont volé\n- **SeaMistress** : version civile proposée par Martin, sans acheteur',
  variants_en       = E'- **XP6M-1**: two prototypes with Allison J71 engines, both lost in 1955 and 1956\n- **YP6M-1**: six pre-production aircraft equipped for bombing, minelaying and reconnaissance\n- **P6M-2**: production version with J75 engines, refuelling probe and improved canopy, eight built of which three flew\n- **SeaMistress**: civil version offered by Martin, with no buyers',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_P6M_SeaMaster',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_P6M_SeaMaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Martin P6M SeaMaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin P6M SeaMaster';
