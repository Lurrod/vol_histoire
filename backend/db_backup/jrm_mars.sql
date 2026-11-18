-- Martin JRM Mars
--
-- Photo : JRM NAN4-54.jpg
--   licence Public domain — USN
--   https://commons.wikimedia.org/wiki/File:JRM_NAN4-54.jpg

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
    'Martin JRM Mars',
    'Martin JRM Mars',
    'Martin JRM Mars',
    'Martin JRM Mars',
    'Le plus grand hydravion allié de la guerre, cargo du Pacifique devenu bombardier d''eau',
    'The largest Allied flying boat of the war, Pacific freighter turned water bomber',
    '/assets/airplanes/jrm-mars.jpg',
    E'## Genèse\nÀ la fin des années 1930, la **Glenn L. Martin Company** produit pour l''US Navy l''hydravion de patrouille **PBM Mariner** et en étudie un dérivé quadrimoteur bien plus grand, le Model 170. En août 1938, la marine commande un prototype, le **XPB2M-1 Mars**. Prévu comme patrouilleur à long rayon d''action, armé de bombes logées sous l''aile et de cinq tourelles, il est en novembre 1941 le plus grand hydravion du monde. Un incendie moteur pendant les essais au sol retarde son premier vol au 23 juin 1942.\n\n## Conception\nLe Mars reprend la coque et les deux dérives du Mariner, à une tout autre échelle : 61 m d''envergure et quatre moteurs en étoile **Wright R-3350 Duplex-Cyclone**. Mais la marine mise désormais sur ses porte-avions, et le patrouilleur est jugé dépassé avant même d''avoir servi. Désarmé, doté de trappes de chargement et d''un plancher renforcé, il devient le transport XPB2M-1R. En juin 1944, la Navy commande vingt **JRM-1** de série, à dérive unique et coque allongée, capables d''emporter 133 soldats, 84 blessés couchés ou plus de 14 tonnes de fret, jeeps comprises. Leur pilotage est physique : seule la gouverne de direction est assistée.\n\n## Carrière opérationnelle\nLe prototype transformé commence ses rotations de fret vers Hawaï et les îles du Pacifique en janvier 1944. La fin de la guerre ramène la commande aux appareils en chaîne : le premier JRM-1, *Hawaii Mars*, sombre dans la baie de Chesapeake quelques semaines après son premier vol, et cinq autres sont achevés. Basés à Alameda avec l''escadron VR-2, ils assurent la liaison San Francisco-Honolulu. Le dernier, *Caroline Mars*, motorisé en R-4360 sous le nom de JRM-2, transporte le 4 mars 1949 un record de 269 personnes. La Navy cesse d''employer des hydravions de transport en 1956 : le dernier vol militaire a lieu le 22 août.\n\n## Place dans l''histoire\nPromis à la ferraille, les quatre survivants sont rachetés en 1959 par un consortium forestier canadien et transformés en **bombardiers d''eau**, capables d''écoper 27 tonnes en 22 secondes. *Hawaii Mars* et *Philippine Mars* combattent les feux de Colombie-Britannique et de Californie pendant des décennies. Le dernier vol d''un Mars a lieu en février 2025, vers l''Arizona : *Philippine Mars* est exposé au musée de Pima, *Hawaii Mars* à celui de Victoria.',
    E'## Genesis\nIn the late 1930s the **Glenn L. Martin Company** was producing the **PBM Mariner** patrol flying boat for the US Navy and studying a much larger four-engined derivative, the Model 170. In August 1938 the Navy ordered a prototype, the **XPB2M-1 Mars**. Planned as a long-range patroller, with bombs carried under the wing and five turrets, it was in November 1941 the largest flying boat in the world. An engine fire during ground testing delayed its first flight to 23 June 1942.\n\n## Design\nThe Mars took the Mariner''s hull and twin fins on an entirely different scale: a 61 m span and four **Wright R-3350 Duplex-Cyclone** radials. But the Navy was now betting on its carriers, and the patroller was judged obsolete before it had even served. Disarmed, given cargo hatches and a reinforced deck, it became the XPB2M-1R transport. In June 1944 the Navy ordered twenty production **JRM-1s**, with a single fin and a longer hull, able to carry 133 troops, 84 stretcher cases or more than 14 tonnes of freight, jeeps included. Flying them was hard physical work: only the rudder was boosted.\n\n## Operational career\nThe converted prototype began cargo runs to Hawaii and the Pacific islands in January 1944. The end of the war cut the order back to the aircraft already on the line: the first JRM-1, *Hawaii Mars*, sank in Chesapeake Bay a few weeks after its first flight, and five others were completed. Based at Alameda with squadron VR-2, they flew the San Francisco-Honolulu route. The last, *Caroline Mars*, powered by R-4360s as the JRM-2, carried a record 269 people on 4 March 1949. The Navy stopped using cargo flying boats in 1956: the last military flight took place on 22 August.\n\n## Place in history\nDestined for scrap, the four survivors were bought in 1959 by a Canadian forestry consortium and converted into **water bombers**, able to scoop 27 tonnes in 22 seconds. *Hawaii Mars* and *Philippine Mars* fought fires in British Columbia and California for decades. The last flight of a Mars took place in February 2025, to Arizona: *Philippine Mars* is displayed at the Pima museum, *Hawaii Mars* at Victoria.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1938-08-01',
    '1942-06-23',
    '1944-01-23',
    356,
    8000,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin JRM Mars'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Martin JRM Mars'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin JRM Mars'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.74,
  wingspan          = 60.96,
  height            = 11.71,
  wing_area         = 342.4,
  empty_weight      = 34279,
  mtow              = 74843,
  service_ceiling   = 4500,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350 Duplex-Cyclone (2 500 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1948,
  units_built       = 7,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XPB2M-1** : prototype de patrouilleur à deux dérives, premier vol le 23 juin 1942\n- **XPB2M-1R** : le même, désarmé et converti en transport en décembre 1943\n- **JRM-1** : transport de série à dérive unique et coque allongée, cinq construits sur vingt commandés\n- **JRM-2** : *Caroline Mars*, dernier construit, à moteurs Pratt & Whitney R-4360 de 3 000 ch\n- **JRM-3** : JRM-1 survivants remotorisés en Wright R-3350, puis convertis en bombardiers d''eau',
  variants_en       = E'- **XPB2M-1**: twin-fin patrol prototype, first flight on 23 June 1942\n- **XPB2M-1R**: the same aircraft, disarmed and converted to a transport in December 1943\n- **JRM-1**: single-fin production transport with a longer hull, five built out of twenty ordered\n- **JRM-2**: *Caroline Mars*, the last built, with 3,000 hp Pratt & Whitney R-4360 engines\n- **JRM-3**: surviving JRM-1s re-engined with Wright R-3350s, later converted into water bombers',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_M-170',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_JRM_Mars',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Martin JRM Mars';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin JRM Mars';
