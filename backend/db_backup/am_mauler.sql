-- Martin AM-1 Mauler
--
-- Photo : Martin AM-1 NATC in flight.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Martin_AM-1_NATC_in_flight.jpg

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
    'Martin AM Mauler',
    'Martin AM Mauler',
    'Martin AM-1 Mauler',
    'Martin AM-1 Mauler',
    'Le monomoteur à pistons qui souleva près de 5 t d''armes, et que les pilotes surnommaient « Awful Monster »',
    'The single piston-engined aircraft that lifted nearly 5 tonnes of weapons, nicknamed Awful Monster by its pilots',
    '/assets/airplanes/am-mauler.jpg',
    E'## Genèse\nLa guerre du Pacifique montre qu''un pilote seul peut viser, bombarder, torpiller et naviguer, et que des moteurs plus puissants rendent inutile le mitrailleur arrière. L''US Navy décide donc de fondre bombardier en piqué et avion torpilleur en un seul monoplace. En septembre 1943, elle retient quatre projets, dont le Douglas qui deviendra le **Skyraider** et le XBTM de Martin. Celui-ci est conçu comme une solution de repli, volontairement sans audace, autour du gigantesque moteur en étoile **Pratt & Whitney R-4360 Wasp Major** ; deux prototypes sont commandés le 31 mai 1944.\n\n## Conception\nMonoplan à aile basse entièrement métallique, le Mauler possède des ailes repliables, un train classique et 135 kg de blindage. Un immense aérofrein de bord de fuite, ajouré en dents de peigne, sert aussi de volet d''atterrissage, au prix d''ailerons étroits et peu efficaces. Quatre canons de 20 mm et quinze points d''emport lui permettent de porter bombes, torpilles et roquettes HVAR. Le 30 mars 1949, il soulève 4 830 kg de charge, dont trois torpilles et douze bombes de 113 kg, sans doute la plus lourde jamais emportée par un monomoteur à pistons. Son indicatif AM lui vaut le surnom d''« Able Mabel ».\n\n## Carrière opérationnelle\nLe premier XBTM-1 vole le 26 août 1944. Commandé à 750 exemplaires en janvier 1945, le Mauler voit sa commande réduite à 99 après la capitulation japonaise, et sa mise au point s''éternise jusqu''en 1950. Le VA-17A le reçoit en mars 1948, mais les appontages sont redoutés : l''avion rebondit par-dessus les brins d''arrêt jusque dans la barrière, et dix Maulers du CVG-8 la percutent lors d''une seule campagne de qualification. Ce groupe aérien est créé en septembre 1948 en réponse au blocus de Berlin, au début de la **guerre froide**. Les AM-1Q de guerre électronique, à deuxième membre d''équipage, servent au VC-4.\n\n## Place dans l''histoire\nPlus stable en piqué que le **Skyraider** et capable d''emporter un tiers de charge en plus, le Mauler perd pourtant face à lui : le Douglas, plus petit, est plus fiable et plus facile à poser sur un pont. Dès 1950, la Navy le cantonne aux bases terrestres, puis aux seules unités de réserve, qui l''utilisent jusqu''en 1953. Construit à 151 exemplaires, cauchemar de maintenance aux circuits hydrauliques fuyants, il reste dans les mémoires sous son autre surnom, « Awful Monster ».',
    E'## Genesis\nThe Pacific war showed that a single pilot could aim bombs and torpedoes and navigate, and that more powerful engines made the rear gunner unnecessary. The US Navy therefore decided to merge the dive bomber and the torpedo bomber into one single-seater. In September 1943 it selected four designs, including the Douglas that would become the **Skyraider** and Martin''s XBTM. The Martin was conceived as a backup, deliberately unadventurous, around the huge **Pratt & Whitney R-4360 Wasp Major** radial; two prototypes were ordered on 31 May 1944.\n\n## Design\nAn all-metal low-wing monoplane, the Mauler had folding wings, conventional undercarriage and 135 kg of armour. A huge trailing-edge dive brake with intermeshing fingers doubled as a landing flap, at the cost of narrow, ineffective ailerons. Four 20 mm cannon and fifteen hardpoints let it carry bombs, torpedoes and HVAR rockets. On 30 March 1949 it lifted 4,830 kg of ordnance, including three torpedoes and twelve 113 kg bombs, perhaps the heaviest load ever carried by a single piston-engined aircraft. Its AM designation earned it the nickname **Able Mabel**.\n\n## Operational career\nThe first XBTM-1 flew on 26 August 1944. Ordered in 750 examples in January 1945, the Mauler saw its order cut to 99 after Japan''s surrender, and its development dragged on until 1950. VA-17A received it in March 1948, but carrier landings were dreaded: the aircraft bounced over the arrester wires into the barrier, and ten CVG-8 Maulers hit it during a single qualification period. That air group had been formed in September 1948 in response to the Berlin Blockade, at the start of the **Cold War**. The AM-1Q electronic-warfare version, with a second crewman, served with VC-4.\n\n## Place in history\nSteadier in a dive than the **Skyraider** and able to carry a third more ordnance, the Mauler still lost out to it: the smaller Douglas was more reliable and easier to land on a deck. From 1950 the Navy confined the Mauler to shore bases, then to reserve units alone, which flew it until 1953. Built in 151 examples, a maintenance nightmare with leaking hydraulics, it is remembered by its other nickname, Awful Monster.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1943-09-01',
    '1944-08-26',
    '1948-03-01',
    538,
    2452,
    (SELECT id FROM manufacturer WHERE code = 'MAR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Martin AM Mauler'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.57,
  wingspan          = 15.24,
  height            = 5.13,
  wing_area         = 46.1,
  empty_weight      = 6920,
  mtow              = 11674,
  service_ceiling   = 8200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-4 Wasp Major (3 000 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = NULL,
  units_built       = 151,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XBTM-1** : deux prototypes, premier vol le 26 août 1944\n- **BTM-1 / AM-1** : version de série, rebaptisée en avril 1946 avec la nouvelle catégorie « attaque », 131 exemplaires\n- **AM-1Q** : guerre électronique, opérateur logé à la place du réservoir de fuselage, lance-paillettes, 18 exemplaires\n- **JR2M-1 Mercury** : projet d''avion de liaison embarqué, jamais construit',
  variants_en       = E'- **XBTM-1**: two prototypes, first flight on 26 August 1944\n- **BTM-1 / AM-1**: production version, redesignated in April 1946 under the new Attack category, 131 built\n- **AM-1Q**: electronic-warfare version, operator housed in place of the fuselage tank, chaff chute, 18 built\n- **JR2M-1 Mercury**: proposed carrier onboard delivery aircraft, never built',

  -- Strate 4 : qualitatif
  nickname          = 'Able Mabel',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Martin_AM_Mauler',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Martin_AM_Mauler',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'Martin AM Mauler';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Martin AM Mauler';
