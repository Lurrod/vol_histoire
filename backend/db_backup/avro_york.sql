-- Avro 685 York
--
-- Photo : G-ANTK Avro 685 York C.1 Dan-Air London Duxford 1.4.25 - (1).jpg
--   licence CC BY-SA 2.0 — Colin Cooke Photo
--   https://commons.wikimedia.org/wiki/File:G-ANTK_Avro_685_York_C.1_Dan-Air_London_Duxford_1.4.25_-_(1).jpg

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
    'Avro York',
    'Avro York',
    'Avro 685 York',
    'Avro 685 York',
    'Le Lancaster devenu cargo, cheville ouvrière britannique du pont aérien de Berlin',
    'The Lancaster turned freighter, Britain''s workhorse of the Berlin Airlift',
    '/assets/airplanes/avro-york.jpg',
    E'## Genèse\nEn 1941, en pleine guerre et sans commande officielle, **Avro** lance l''étude d''un transport quadrimoteur à long rayon d''action. Son ingénieur en chef **Roy Chadwick** part du bombardier **Lancaster**, qui vient tout juste de voler : le Type 685 en reprend l''aile, l''empennage, le train et les moteurs **Rolls-Royce Merlin**, et les associe à un fuselage de section carrée qui double le volume intérieur. Le prototype LV626 décolle de Ringway, près de Manchester, le 5 juillet 1942. Convaincu par les essais, l''Air Ministry commande trois autres prototypes et une première série au titre de la spécification C.1/42.\n\n## Conception\nLe York est un monoplan à aile haute, entièrement métallique. La surface latérale du fuselage, plus grande que celle du Lancaster en avant de l''aile, oblige à ajouter une troisième dérive centrale aux deux dérives d''origine pour conserver une bonne stabilité de route. Sept réservoirs logés entre les longerons emportent plus de 11 000 litres de carburant. La version militaire transporte jusqu''à 56 passagers ou 7,5 tonnes de fret. Le prototype aménagé pour le largage de parachutistes est en revanche écarté : le souffle des hélices rabattait les voilures vers la roulette de queue.\n\n## Carrière opérationnelle\nFreinée par la priorité donnée au Lancaster, la production ne prend son essor qu''en 1944. Le York devient le premier avion britannique employé en nombre par le **Transport Command** de la RAF, qui en reçoit 208 et l''utilise sur toutes ses grandes lignes, dont la route des Indes ; le prototype LV633 *Ascalon* sert de salle de conférence volante à **Winston Churchill**. Il donne toute sa mesure pendant le **pont aérien de Berlin** de 1948-1949 : les York de sept escadrons y effectuent plus de 58 000 vols et livrent plus de 230 000 tonnes, soit 43 % de la contribution britannique. L''Aéronavale française en exploite encore cinq au Bourget en 1954.\n\n## Place dans l''histoire\nAprès Berlin, la RAF retire l''essentiel de sa flotte, rongée par la corrosion, au profit du **Handley Page Hastings** conçu pour lui succéder. Une quarantaine d''appareils passent aux compagnies civiles, qui assurent encore sous contrat militaire des relèves de troupes vers les garnisons britanniques ; les derniers York de Skyways et de Dan-Air s''arrêtent en 1964. Construit à 258 exemplaires, il incarne la solution de transition de l''immédiat après-guerre : un bombardier éprouvé recarrossé en cargo, en attendant des avions conçus pour ce métier.',
    E'## Genesis\nIn 1941, in the middle of the war and with no official order, **Avro** began studying a long-range four-engined transport. Its chief designer **Roy Chadwick** started from the **Lancaster** bomber, which had only just flown: the Type 685 reused its wing, tail, undercarriage and **Rolls-Royce Merlin** engines, paired with a square-section fuselage that doubled the internal volume. The prototype LV626 took off from Ringway, near Manchester, on 5 July 1942. Convinced by the trials, the Air Ministry ordered three more prototypes and an initial batch under Specification C.1/42.\n\n## Design\nThe York was an all-metal high-wing monoplane. The fuselage''s larger side area ahead of the wing, compared with the Lancaster, required a third central fin to be added to the two original fins to keep adequate directional stability. Seven tanks between the spars held more than 11,000 litres of fuel. The military version carried up to 56 passengers or 7.5 tonnes of freight. The prototype fitted out for dropping paratroops was rejected, however: the propeller slipstream drew the canopies towards the tailwheel.\n\n## Operational career\nHeld back by the priority given to the Lancaster, production only gathered pace in 1944. The York became the first British aircraft used in quantity by RAF **Transport Command**, which received 208 and flew them on all its trunk routes, including the route to India; the prototype LV633 *Ascalon* served as a flying conference room for **Winston Churchill**. It came into its own during the **Berlin Airlift** of 1948-1949: Yorks from seven squadrons flew more than 58,000 sorties and delivered over 230,000 tons, 43% of the British contribution. The French Aéronavale was still operating five of them at Le Bourget in 1954.\n\n## Place in history\nAfter Berlin, the RAF retired most of its fleet, eaten by corrosion, in favour of the **Handley Page Hastings** designed to succeed it. Some forty aircraft went to civil operators, which still flew trooping contracts to British garrisons; the last Yorks of Skyways and Dan-Air were withdrawn in 1964. Built to 258 examples, it embodies the stopgap solution of the immediate post-war years: a proven bomber rebodied as a freighter, pending aircraft designed for the job.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1941-01-01',
    '1942-07-05',
    '1944-01-01',
    480,
    4800,
    (SELECT id FROM manufacturer WHERE code = 'AVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro York'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro York'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.93,
  wingspan          = 31.09,
  height            = 5.03,
  wing_area         = 120.5,
  empty_weight      = 18144,
  mtow              = 29484,
  service_ceiling   = 7000,
  climb_rate        = 4.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Merlin 24 (1 280 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1943,
  production_end    = 1948,
  units_built       = 258,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Avro 685 (prototypes)** : quatre exemplaires, dont LV633 *Ascalon*, salle de conférence volante de Churchill, et LV639 essayé pour le largage de parachutistes\n- **York I** : version civile, 45 exemplaires, livrés notamment à la BOAC\n- **York C.I** : transport militaire de la RAF, 208 exemplaires chez Avro et un chez Victory Aircraft au Canada\n- **York C.II** : exemplaire unique à moteurs en étoile Bristol Hercules, la série restant fidèle au Merlin',
  variants_en       = E'- **Avro 685 (prototypes)**: four built, including LV633 *Ascalon*, Churchill''s flying conference room, and LV639 tested for paratroop dropping\n- **York I**: civil version, 45 built, delivered notably to BOAC\n- **York C.I**: RAF military transport, 208 built by Avro and one by Victory Aircraft in Canada\n- **York C.II**: one-off with Bristol Hercules radial engines, production staying with the Merlin',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_York',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_York',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Colin Cooke',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Avro York';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro York';
