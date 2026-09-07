-- Boeing KC-46 Pegasus
--
-- Photo : KC-46 Pegasus prepares to refuel C-17 (cropped).jpg
--   licence Public domain — USAF Christopher Okula
--   https://commons.wikimedia.org/wiki/File%3AKC-46_Pegasus_prepares_to_refuel_C-17_%28cropped%29.jpg

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
    'KC-46 Pegasus',
    'KC-46 Pegasus',
    'Boeing KC-46 Pegasus',
    'Boeing KC-46 Pegasus',
    'Successeur du KC-135, livré avec une perche qu’il a fallu redessiner',
    'Successor to the KC-135, delivered with a boom that had to be redesigned',
    '/assets/airplanes/kc46-pegasus.jpg',
    E'## Genèse\nRemplacer le **KC-135**, en service depuis 1957, occupe l''US Air Force depuis vingt ans. Le premier appel d''offres, remporté par Airbus et Northrop en 2008, est annulé après le recours de Boeing. Le second, en 2011, est gagné par Boeing avec une offre à prix ferme : la firme s''engage à absorber tout dépassement. Elle absorbera, à ce jour, plus de **sept milliards de dollars** de sa poche.\n\n## Conception\nLe KC-46 est un Boeing 767 renforcé, doté d''un plancher cargo et de réservoirs supplémentaires. L''innovation, et le problème, tient au **système de vision à distance** : l''opérateur ne s''allonge plus à l''arrière pour voir la perche, il la pilote depuis l''avant sur des écrans tridimensionnels. En pratique, l''image se déforme selon l''angle du soleil et la perche a rayé des appareils ravitaillés — un défaut classé au niveau de gravité le plus élevé, et non résolu avant 2027.\n\n## Carrière opérationnelle\nLivré depuis 2019, il n''a été autorisé à ravitailler l''ensemble des types qu''à partir de 2022, et sa mise en service opérationnelle complète reste conditionnelle. Il a néanmoins participé aux convoyages transatlantiques et au soutien des déploiements en Europe après 2022. Le **Japon** en a reçu quatre, Israël en attend huit.\n\n## Place dans l''histoire\nQuatre-vingt-neuf exemplaires livrés sur cent soixante-dix-neuf commandés. Son histoire est surtout celle d''un contrat : le prix ferme, censé protéger l''État, a transféré à l''industriel un risque qu''il avait sous-estimé, et retardé de sept ans le retrait des **KC-135** qu''il devait remplacer. Ceux-ci voleront finalement au-delà de 2050.',
    E'## Genesis\nReplacing the **KC-135**, in service since 1957, has occupied the US Air Force for twenty years. The first competition, won by Airbus and Northrop in 2008, was cancelled after a Boeing protest. The second, in 2011, went to Boeing on a fixed-price bid: the firm undertook to absorb any overrun. It has so far absorbed more than **seven billion dollars** of its own money.\n\n## Design\nThe KC-46 is a strengthened Boeing 767 with a cargo floor and additional tanks. The innovation, and the problem, lies in the **remote vision system**: the operator no longer lies at the rear to see the boom but flies it from the front on three-dimensional screens. In practice the image distorts with the angle of the sun and the boom has scraped receiving aircraft — a deficiency rated at the highest severity, and not resolved before 2027.\n\n## Operational career\nDelivered since 2019, it was cleared to refuel every type only from 2022, and full operational release remains conditional. It has nevertheless taken part in transatlantic ferry flights and in supporting European deployments after 2022. **Japan** has received four and Israel expects eight.\n\n## Place in history\nEighty-nine delivered out of a hundred and seventy-nine ordered. Its story is above all that of a contract: the fixed price, meant to protect the government, transferred to the manufacturer a risk it had underestimated, and delayed by seven years the retirement of the **KC-135s** it was meant to replace. Those will now fly beyond 2050.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2011-02-24',
    '2015-09-25',
    '2019-01-25',
    915.0,
    12200.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 50.5,
  wingspan          = 48.1,
  height            = 15.8,
  wing_area         = 283.0,
  empty_weight      = 82377,
  mtow              = 188240,
  service_ceiling   = 12200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 6500,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney PW4062',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 282.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2014,
  production_end    = NULL,
  units_built       = 89,
  unit_cost_usd     = 239000000,
  unit_cost_year    = 2019,
  operators_count   = 3,
  variants          = E'- **KC-46A** : version unique, bâtie sur la cellule du Boeing 767-2C\n- Commandé par le **Japon** et Israël, en plus de l''US Air Force\n- Perche rigide **et** deux nacelles souples : ravitaille l''Air Force, la Navy et les alliés\n- Le poste de ravitaillement est **déporté à l''avant**, opéré sur écrans 3D et non à vue\n- Ce système de vision, cause de déficiences majeures, est remplacé à partir de 2027',
  variants_en       = E'- **KC-46A** : the sole version, built on the Boeing 767-2C airframe\n- Ordered by **Japan** and Israel in addition to the US Air Force\n- Flying boom **and** two hose pods: refuels the Air Force, the Navy and allies\n- The boom station is **moved forward**, operated on 3D screens rather than by eye\n- That vision system, the cause of major deficiencies, is being replaced from 2027',

  -- Strate 4 : qualitatif
  nickname          = 'Pegasus',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_KC-46_Pegasus',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_KC-46_Pegasus',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF Christopher Okula',
  image_licence     = 'Public domain'
WHERE name = 'KC-46 Pegasus';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KC-46 Pegasus';
