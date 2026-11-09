-- Vought F4U Corsair
--
-- Photo : Texas Flying Legends FG-1D After Takeoff 2.jpg
--   licence CC BY-SA 3.0 — Noah Wulf
--   https://commons.wikimedia.org/wiki/File:Texas_Flying_Legends_FG-1D_After_Takeoff_2.jpg

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
    'F4U Corsair',
    'F4U Corsair',
    'Vought F4U Corsair',
    'Vought F4U Corsair',
    'De la Corée à la guerre du Football de 1969 : la longue après-guerre du Corsair',
    'From Korea to the 1969 Football War: the Corsair’s long post-war career',
    '/assets/airplanes/f4u-corsair.jpg',
    E'## Genèse\nEn 1938, Vought dessine un chasseur embarqué autour du moteur le plus puissant disponible, le **Pratt & Whitney R-2800** de 2 000 ch. Pour qu''une hélice aussi grande ne touche pas le pont avec un train court, l''aile est coudée en **W** — la silhouette en « aile de mouette inversée » qui fera sa célébrité. Premier vol le 29 mai 1940 ; le Corsair se bat dans le Pacifique à partir de 1943. Mais l''essentiel de son histoire, pour ce catalogue, commence en 1945 : il reste en production huit ans de plus.\n\n## Conception\nLes versions d''après-guerre en font un appareil d''attaque autant qu''un chasseur. Le **F4U-4**, moteur R-2800-18W et hélice quadripale, atteint 718 km/h. Le **F4U-5** remplace les six mitrailleuses de 12,7 mm par quatre canons de 20 mm et existe en chasseur de nuit à radar, le F4U-5N. L''**AU-1**, blindé et chargé de roquettes et de bombes, est conçu pour l''appui des Marines. Le dernier, le **F4U-7**, est construit pour la France : sa livraison, le 31 janvier 1953, met un terme à la production du Corsair.\n\n## Carrière opérationnelle\nEn **Corée**, le Corsair est la bête de somme de l''appui rapproché de l''US Navy et des Marines. Le 4 décembre 1950, près du réservoir de Chosin, **Jesse Brown**, premier aviateur afro-américain de l''aéronavale, est abattu ; **Thomas Hudner** pose volontairement son avion à côté de lui pour tenter de le dégager, ce qui lui vaut la Medal of Honor. **Guy Bordelon**, sur F4U-5N, devient le seul as de l''US Navy de la guerre, et le 10 septembre 1952 Jesse Folmar abat un MiG-15. L''**Aéronavale** française engage ses Corsair en **Indochine** en 1954, à **Suez** en 1956 depuis l''Arromanches et La Fayette, puis en **Algérie**, et les garde jusqu''en 1964. Le 17 juillet 1969, pendant la **guerre du Football**, le capitaine hondurien **Fernando Soto** abat trois appareils salvadoriens : ce sont les derniers combats aériens entre avions à hélice. Le Honduras retire ses Corsair en 1979.\n\n## Place dans l''histoire\nDouze mille cinq cent soixante et onze exemplaires de 1942 à 1953, la plus longue production d''un chasseur à pistons américain. Né contre le Japon, le Corsair a fait l''essentiel de sa carrière après 1945, en Corée, en Indochine, à Suez, en Algérie et jusqu''en Amérique centrale. Dans l''Aéronavale, il laisse la place à l''**Étendard IV**.',
    E'## Genesis\nIn 1938 Vought designed a carrier fighter around the most powerful engine available, the 2,000 hp **Pratt & Whitney R-2800**. So that such a large propeller would clear the deck with a short undercarriage, the wing was cranked into a **W** — the inverted gull wing that would make it famous. First flight on 29 May 1940; the Corsair fought in the Pacific from 1943. But for this catalogue the heart of its story begins in 1945: it stayed in production for eight more years.\n\n## Design\nThe post-war versions made it an attack aircraft as much as a fighter. The **F4U-4**, with the R-2800-18W engine and a four-bladed propeller, reached 718 km/h. The **F4U-5** replaced the six 12.7 mm machine guns with four 20 mm cannon and came as a radar-equipped night fighter, the F4U-5N. The **AU-1**, armoured and loaded with rockets and bombs, was built for Marine close support. The last, the **F4U-7**, was built for France: its delivery on 31 January 1953 brought Corsair production to an end.\n\n## Operational career\nOver **Korea** the Corsair was the workhorse of US Navy and Marine close support. On 4 December 1950, near the Chosin Reservoir, **Jesse Brown**, the first African-American naval aviator, was shot down; **Thomas Hudner** deliberately crash-landed beside him to try to free him, earning the Medal of Honor. **Guy Bordelon**, in an F4U-5N, became the US Navy’s only ace of the war, and on 10 September 1952 Jesse Folmar shot down a MiG-15. The French **Aéronavale** committed its Corsairs in **Indochina** in 1954, at **Suez** in 1956 from Arromanches and La Fayette, then in **Algeria**, and kept them until 1964. On 17 July 1969, during the **Football War**, Honduran Captain **Fernando Soto** shot down three Salvadoran aircraft: the last air combats between propeller-driven aircraft. Honduras retired its Corsairs in 1979.\n\n## Place in history\nTwelve thousand five hundred and seventy-one built from 1942 to 1953, the longest production run of any American piston fighter. Born to fight Japan, the Corsair spent most of its career after 1945, in Korea, Indochina, Suez, Algeria and as far as Central America. In the Aéronavale it gave way to the **Étendard IV**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1938-06-01',
    '1940-05-29',
    '1942-12-28',
    718.0,
    1617.0,
    (SELECT id FROM manufacturer WHERE code = 'VOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F4U Corsair'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.27,
  wingspan          = 12.5,
  height            = 4.5,
  wing_area         = 29.17,
  empty_weight      = 4175,
  mtow              = 6654,
  service_ceiling   = 12650,
  climb_rate        = 22.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-18W Double Wasp',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons en étoile, 18 cylindres',
  engine_type_en    = '18-cylinder radial piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1942,
  production_end    = 1953,
  units_built       = 12571,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **F4U-1 / FG-1 / F3A** : versions de guerre, construites aussi par Goodyear et Brewster\n- **F4U-4** : version principale de la guerre de Corée, moteur R-2800-18W\n- **F4U-5 / F4U-5N** : quatre canons de 20 mm, chasseur de nuit à radar de Guy Bordelon\n- **AU-1** : avion d''attaque blindé des Marines, puis de l''Aéronavale en Indochine\n- **F4U-7** : 94 exemplaires pour l''Aéronavale, derniers Corsair construits (1953)',
  variants_en       = E'- **F4U-1 / FG-1 / F3A** : wartime versions, also built by Goodyear and Brewster\n- **F4U-4** : main Korean War version, R-2800-18W engine\n- **F4U-5 / F4U-5N** : four 20 mm cannon, radar night fighter flown by Guy Bordelon\n- **AU-1** : armoured attack aircraft for the Marines, then the Aéronavale in Indochina\n- **F4U-7** : 94 built for the Aéronavale, the last Corsairs built (1953)',

  -- Strate 4 : qualitatif
  nickname          = 'Corsair',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vought_F4U_Corsair',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vought_F4U_Corsair',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Noah Wulf',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'F4U Corsair';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F4U Corsair';
