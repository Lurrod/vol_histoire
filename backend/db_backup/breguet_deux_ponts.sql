-- Breguet Br 763 Provence / Br 765 Sahara
--
-- Photo : Bréguet Br.765 Sahara ‘501’.jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File:Br%C3%A9guet_Br.765_Sahara_%E2%80%98501%E2%80%99.jpg

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
    'Breguet Deux-Ponts',
    'Breguet Deux-Ponts',
    'Breguet Br 763 Provence / Br 765 Sahara',
    'Breguet Br 763 Provence / Br 765 Sahara',
    'Le transport français à deux ponts, d''Air France aux sites d''essais nucléaires du Pacifique',
    'France''s double-deck transport, from Air France to the Pacific nuclear test sites',
    '/assets/airplanes/breguet-765-sahara.jpg',
    E'## Genèse\n**Breguet** lance l''étude de son avion de transport à deux ponts dès 1944, avant même la fin de la guerre : un moyen-courrier de plus de cent places, conçu autour de moteurs disponibles pour voler tôt et se construire facilement. Le prototype Br 761 décolle de Villacoublay le 15 février 1949. Trop peu puissant, il est suivi de trois Br 761S de présérie à moteurs **Pratt & Whitney R-2800**, puis d''une commande gouvernementale de douze Br 763 de série, partagés entre Air France et le ministère des Transports. Le Br 763 vole le 20 juillet 1951 et entre en ligne chez Air France le 10 mars 1953 sous le nom de *Provence*.\n\n## Conception\nLe Deux-Ponts doit son surnom, jamais officiel, à son fuselage ventru à deux niveaux reliés par un ascenseur : 59 passagers en haut et 48 en bas chez Air France, jusqu''à 135 en version haute densité. L''aile est médiane, le train tricycle escamotable à roues jumelées, l''empennage à deux dérives complété sur certains appareils par une petite dérive centrale. Le Br 763 reçoit des moteurs plus puissants, une envergure accrue de 1,20 m, une aile renforcée et un équipage ramené à trois. La version militaire **Br 765 Sahara**, propulsée par des R-2800 de 2 500 ch, se distingue par ses portes cargo amovibles.\n\n## Carrière opérationnelle\nEn octobre 1955, l''armée de l''Air annonce une commande de trente Br 765 Sahara ; elle est annulée avant la fin de l''année, mais quatre appareils trop avancés sont achevés et rejoignent la **64e escadre de transport**. L''armée de l''Air reprend aussi les trois Br 761S, puis, en 1964, six Br 763 cédés par Air France. Cette flotte devient un outil précieux pour acheminer hommes et matériel vers les sites d''**essais nucléaires du Pacifique**. Le Deux-Ponts avait déjà montré sa capacité d''emport en Algérie : six appareils d''Air France y avaient transporté en quatre jours 60 tonnes d''équipement lourd et 200 personnes vers un chantier pétrolier du désert en difficulté.\n\n## Place dans l''histoire\nChez Air France, la **Caravelle**, plus rapide et plus confortable, rend vite le Deux-Ponts obsolète comme avion de passagers : les derniers Br 763, transformés en cargos *Universel*, volent jusqu''au 31 mars 1971. Les Sahara de l''armée de l''Air sont retirés en 1972 et cèdent la place au **Transall C-160**. Construit à vingt exemplaires seulement, doté d''un excellent bilan de sécurité, le Deux-Ponts fut le premier avion français à deux ponts ; trois exemplaires sont préservés, dont le Br 765 n° 501, longtemps gardien de la base d''Évreux.',
    E'## Genesis\n**Breguet** began designing its double-deck transport as early as 1944, before the war had even ended: a medium-range aircraft seating more than a hundred, built around readily available engines so that it could fly early and be easy to manufacture. The Br 761 prototype took off from Villacoublay on 15 February 1949. Underpowered, it was followed by three Br 761S pre-production aircraft with **Pratt & Whitney R-2800** engines, then by a government order for twelve production Br 763s, shared between Air France and the Ministry of Transport. The Br 763 first flew on 20 July 1951 and entered Air France service on 10 March 1953 as the *Provence*.\n\n## Design\nThe Deux-Ponts owed its nickname, never official, to its bulky fuselage with two decks linked by a lift: 59 passengers upstairs and 48 downstairs with Air France, up to 135 in a high-density layout. The wing was mid-mounted, the retractable tricycle undercarriage had twin-wheel main units, and the twin-fin tail was supplemented on some aircraft by a small central fin. The Br 763 had more powerful engines, a span increased by 1.20 m, a strengthened wing and a crew reduced to three. The military **Br 765 Sahara**, powered by 2,500 hp R-2800s, stood out for its removable cargo doors.\n\n## Operational career\nIn October 1955 the Armée de l''Air announced an order for thirty Br 765 Saharas; it was cancelled before the end of the year, but four aircraft were too far advanced and were completed for **64 Escadre de Transport**. The air force also took over the three Br 761S aircraft and, in 1964, six Br 763s handed over by Air France. This fleet became a valuable means of moving personnel and materiel to the **Pacific nuclear testing** areas. The Deux-Ponts had already shown its lifting capacity in Algeria, where six Air France aircraft moved 60 tonnes of heavy equipment and 200 people in four days to and from a desert oil exploration site in trouble.\n\n## Place in history\nAt Air France the faster, more comfortable **Caravelle** soon made the Deux-Ponts obsolete as a passenger aircraft: the last Br 763s, converted into *Universel* freighters, flew until 31 March 1971. The air force''s Saharas were retired in 1972 and gave way to the **Transall C-160**. Built in only twenty examples and with an excellent safety record, the Deux-Ponts was France''s first double-deck aircraft; three survive, including Br 765 No. 501, long the gate guardian at Évreux.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1944-01-01',
    '1949-02-15',
    '1953-03-10',
    NULL,
    2290,
    (SELECT id FROM manufacturer WHERE code = 'BRG'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Deux-Ponts'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Deux-Ponts'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 28.94,
  wingspan          = 42.96,
  height            = 9.56,
  wing_area         = 185.4,
  empty_weight      = 32535,
  mtow              = 50000,
  service_ceiling   = NULL,
  climb_rate        = 5.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-CA18 (2 400 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 4,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Br 761** : prototype à moteurs SNECMA 14R-24 de 1 580 ch, un exemplaire\n- **Br 761S** : présérie à moteurs Pratt & Whitney R-2800-B31, trois exemplaires, repris par l''armée de l''Air\n- **Br 763 Provence** : série d''Air France à R-2800-CA18 de 2 400 ch, douze exemplaires, dont six cédés à l''armée de l''Air en 1964 et six convertis en cargos *Universel*\n- **Br 764** : projet de version anti-sous-marine pour l''Aéronavale, abandonné\n- **Br 765 Sahara** : cargo militaire à portes amovibles et R-2800-CB17 de 2 500 ch, quatre exemplaires sur trente commandés ; l''armée de l''Air a aligné treize Deux-Ponts en tout',
  variants_en       = E'- **Br 761**: prototype with 1,580 hp SNECMA 14R-24 engines, one built\n- **Br 761S**: pre-production aircraft with Pratt & Whitney R-2800-B31 engines, three built, later taken over by the Armée de l''Air\n- **Br 763 Provence**: Air France production version with 2,400 hp R-2800-CA18s, twelve built, six of them transferred to the air force in 1964 and six converted into *Universel* freighters\n- **Br 764**: proposed anti-submarine version for the French Navy, abandoned\n- **Br 765 Sahara**: military freighter with removable doors and 2,500 hp R-2800-CB17s, four built out of thirty ordered; the air force operated thirteen Deux-Ponts in all',

  -- Strate 4 : qualitatif
  nickname          = 'Deux-Ponts',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Breguet_Deux-Ponts',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Breguet_763_Deux-Ponts',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Breguet Deux-Ponts';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Breguet Deux-Ponts';
