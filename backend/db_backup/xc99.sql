-- Convair XC-99
--
-- Photo : Convair XC-99 in flight c1948.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:Convair_XC-99_in_flight_c1948.jpg

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
    'Convair XC-99',
    'Convair XC-99',
    'Convair XC-99',
    'Convair XC-99',
    'Le B-36 transformé en cargo à deux ponts, plus grand transport terrestre à pistons jamais construit',
    'The B-36 turned double-deck freighter, the largest land-based piston transport ever built',
    '/assets/airplanes/convair-xc99.jpg',
    E'## Genèse\nEn pleine guerre, **Consolidated** étudie, à côté du bombardier intercontinental **XB-36**, un transport à grande capacité qui en reprendrait la voilure et les moteurs. Le contrat d''un prototype, désigné XC-99, est signé le 31 décembre 1942, mais des programmes plus urgents retardent sa construction dans l''usine de San Diego : l''avion ne sort qu''à l''été 1947 et vole pour la première fois le 24 novembre. Pan American commande même quinze exemplaires d''une version de ligne, le **Model 37**, qui ne sera jamais construite faute de rentabilité.\n\n## Conception\nLe XC-99 associe l''aile, l''empennage et les six moteurs en étoile **Pratt & Whitney R-4360 Wasp Major** du **B-36** à un fuselage entièrement nouveau, à deux ponts sur toute sa longueur. Long de 55,6 m pour 70,1 m d''envergure, il peut emporter 45 tonnes de fret ou 400 soldats équipés ; ses hélices, montées derrière l''aile, sont propulsives. Deux portes cargo s''ouvrent sous le fuselage et un monte-charge dessert le pont supérieur. Fin 1948, les deux grandes roues du train principal, qui concentraient la masse sur une petite surface, sont remplacées par des bogies à quatre roues.\n\n## Carrière opérationnelle\nLivré à l''US Air Force le 26 mai 1949, l''appareil effectue en juillet 1950 sa première mission de fret, l''« opération Elephant » : 45,9 tonnes de moteurs et d''hélices de B-36 entre San Diego et la base de Kelly, au Texas. Remotorisé en 1951 et doté d''un système de chargement, il relie deux fois par semaine Kelly au dépôt de McClellan, en Californie, pour la logistique du B-36, et sert beaucoup pendant la **guerre de Corée**. En août 1953, il gagne l''Allemagne par les Bermudes et les Açores, avec plus de 27 tonnes dans chaque sens.\n\n## Place dans l''histoire\nL''Air Force conclut qu''elle n''a pas besoin d''un transport aussi grand et n''en commande pas d''autre : l''exemplaire unique est retiré en 1957, après quelque 7 400 heures de vol. Il reste le plus grand avion de transport terrestre à moteurs à pistons jamais construit. Exposé à Kelly, rongé par la corrosion de sa cellule riche en magnésium, il a été démonté et attend à Davis-Monthan une restauration que le musée de l''US Air Force n''a pas les moyens d''entreprendre.',
    E'## Genesis\nIn the middle of the war, **Consolidated** studied, alongside the **XB-36** intercontinental bomber, a high-capacity transport that would reuse its wing and engines. The contract for a prototype, designated XC-99, was signed on 31 December 1942, but more urgent programmes delayed its construction at the San Diego plant: the aircraft was only rolled out in the summer of 1947 and first flew on 24 November. Pan American even ordered fifteen examples of an airliner version, the **Model 37**, which was never built because it would not have paid its way.\n\n## Design\nThe XC-99 paired the wing, tail and six **Pratt & Whitney R-4360 Wasp Major** radial engines of the **B-36** with an entirely new fuselage, double-decked along its whole length. At 55.6 m long with a 70.1 m span, it could carry 45 tonnes of cargo or 400 equipped troops; its propellers, mounted behind the wing, were pushers. Two cargo doors opened under the fuselage and a lift served the upper deck. At the end of 1948 the two large main wheels, which concentrated the weight on a small area, were replaced by four-wheel bogies.\n\n## Operational career\nDelivered to the US Air Force on 26 May 1949, the aircraft flew its first cargo mission in July 1950, ''Operation Elephant'': 45.9 tonnes of B-36 engines and propellers from San Diego to Kelly Air Force Base, Texas. Re-engined in 1951 and given a cargo-loading system, it flew twice a week between Kelly and the McClellan depot in California in support of the B-36, and saw much use during the **Korean War**. In August 1953 it flew to Germany via Bermuda and the Azores, carrying more than 27 tonnes each way.\n\n## Place in history\nThe Air Force concluded that it had no need for such a large transport and ordered no more: the sole example was retired in 1957 after some 7,400 flying hours. It remains the largest land-based piston-engined transport aircraft ever built. Displayed at Kelly and eaten away by corrosion of its magnesium-rich airframe, it was dismantled and now waits at Davis-Monthan for a restoration that the US Air Force museum lacks the resources to undertake.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1942-12-31',
    '1947-11-24',
    '1949-05-26',
    494,
    13000,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XC-99'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XC-99'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 55.63,
  wingspan          = 70.1,
  height            = 17.53,
  wing_area         = 443.3,
  empty_weight      = 61340,
  mtow              = 145150,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-41 Wasp Major (3 500 ch)',
  engine_count      = 6,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XC-99** : prototype unique (43-52436), livré à l''US Air Force le 26 mai 1949 et en service jusqu''en 1957\n- **Train à bogies** (fin 1948) : chaque grande roue principale remplacée par un bogie à quatre roues pour mieux répartir la masse\n- **Remotorisation de 1951** : moteurs R-4360-53 de 3 800 ch, train renforcé, système de chargement avec monte-charge intérieur\n- **Model 37** : version de ligne à deux ponts pour 204 passagers, quinze exemplaires commandés par Pan American, jamais construite',
  variants_en       = E'- **XC-99**: sole prototype (43-52436), delivered to the US Air Force on 26 May 1949 and in service until 1957\n- **Bogie undercarriage** (late 1948): each large main wheel replaced by a four-wheel bogie to spread the weight\n- **1951 re-engining**: 3,800 hp R-4360-53 engines, strengthened undercarriage, cargo-loading system with internal lift\n- **Model 37**: double-deck airliner for 204 passengers, fifteen ordered by Pan American, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_XC-99',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_XC-99',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Convair XC-99';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair XC-99';
