-- Vickers Valetta
--
-- Photo : Vickers Valetta C2 (c-n 432, s-n VX580) 1990-04-30 Andre Gerwing Collection ID 029795.jpg
--   licence CC BY-SA 4.0 — André Gerwing
--   https://commons.wikimedia.org/wiki/File:Vickers_Valetta_C2_(c-n_432,_s-n_VX580)_1990-04-30_Andre_Gerwing_Collection_ID_029795.jpg

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
    'Vickers Valetta',
    'Vickers Valetta',
    'Vickers Valetta',
    'Vickers Valetta',
    'Le Viking militarisé qui remplace les Dakota de la RAF et parachute ses troupes sur Suez',
    'The militarised Viking that replaced the RAF''s Dakotas and dropped its troops over Suez',
    '/assets/airplanes/vickers-valetta.jpg',
    E'## Genèse\nAu sortir de la guerre, le Transport Command de la RAF vole sur des appareils usés et cherche à les remplacer vite. Pendant les évaluations du **Vickers VC.1 Viking**, petit avion de ligne lui-même issu du bombardier Wellington, plusieurs responsables souhaitent en obtenir une version militaire. L''Air Ministry formalise ce besoin dans la spécification C.9/46, rédigée pour l''avion de Vickers et jugée en avance sur son temps : l''appareil doit passer rapidement d''un rôle à l''autre. Le prototype, construit à l''origine comme un Viking, vole à Brooklands le 30 juin 1947 aux mains de **Mutt Summers**. Il doit son nom à La Valette, capitale de Malte, mais l''écrit avec un seul « l ».\n\n## Conception\nPar rapport au Viking, le Valetta prend environ 900 kg de plus : il reçoit des moteurs en étoile **Bristol Hercules 230** de 2 000 ch, un plancher renforcé muni de points d''ancrage, une grande double porte de chargement latérale et un train consolidé pour encaisser des atterrissages plus rudes. Sièges, treuil, rampes pour véhicules, rouleaux, crochet de remorquage de planeur et réservoirs supplémentaires se démontent rapidement. Il transporte ainsi 34 soldats équipés, 20 blessés couchés avec deux infirmiers, ou 20 parachutistes et neuf conteneurs largables, d''autres charges pouvant être accrochées sous le fuselage.\n\n## Carrière opérationnelle\nEntré en service en 1948, le Valetta C.1 remplace rapidement les Douglas Dakota du Transport Command, jusque dans les escadrons du Moyen-Orient et d''Extrême-Orient. Il opère au-dessus de zones de combat : pendant la **crise de Suez**, en 1956, il effectue de nombreux largages de parachutistes sur l''Égypte. Il soutient aussi les opérations britanniques de l''**insurrection malaise** et d''**Aden**. Le C.2 transporte les personnalités, et le T.3, reconnaissable à ses astrodômes, sert de salle de classe volante aux navigateurs du RAF College de Cranwell ; dix-huit sont convertis en T.4 avec un radar dans le nez pour former à l''interception.\n\n## Place dans l''histoire\nAvec 262 exemplaires, le Valetta a été un pilier du Transport Command dans les opérations britanniques des années 1950. Son plus beau prolongement est le **Vickers Varsity**, avion d''entraînement d''équipages plus grand, à train tricycle, qui remplace à son tour les Valetta T.3 et T.4. Deux C.2 subsistent, à Blackbushe et au musée de Flixton, et le film *High Flight* (1957) en garde une longue séquence de cours de navigation.',
    E'## Genesis\nAt the end of the war, RAF Transport Command was flying worn-out aircraft and wanted to replace them quickly. During evaluations of the **Vickers VC.1 Viking**, a small airliner itself derived from the Wellington bomber, several officials wanted a military version. The Air Ministry formalised the need in Specification C.9/46, written around Vickers'' aircraft and considered forward-looking: the aircraft had to switch rapidly between roles. The prototype, originally built as a Viking, flew at Brooklands on 30 June 1947 in the hands of **Mutt Summers**. It was named after Valletta, the capital of Malta, but spelt with a single "l".\n\n## Design\nCompared with the Viking, the Valetta gained roughly 900 kg: it received 2,000 hp **Bristol Hercules 230** radials, a strengthened floor with anchoring points, a large side double cargo door and a reinforced undercarriage for rough landings. Seats, winch, vehicle ramps, rollers, glider-towing gear and extra tanks could all be removed quickly. It could thus carry 34 equipped troops, 20 stretcher cases with two attendants, or 20 paratroops and nine air-drop containers, with further loads slung beneath the fuselage.\n\n## Operational career\nEntering service in 1948, the Valetta C.1 quickly replaced Transport Command''s Douglas Dakotas, including the squadrons in the Middle East and the Far East. It flew over combat zones: during the **Suez Crisis** in 1956 it carried out numerous paratroop drops over Egypt. It also supported British operations in the **Malayan Emergency** and in **Aden**. The C.2 carried VIPs, and the T.3, recognisable by its astrodomes, served as a flying classroom for navigators at the RAF College Cranwell; eighteen were converted to T.4s with a nose radar to train interception crews.\n\n## Place in history\nWith 262 built, the Valetta was a mainstay of Transport Command in the British operations of the 1950s. Its finest offspring is the **Vickers Varsity**, a larger crew trainer with tricycle undercarriage, which in turn replaced the Valetta T.3 and T.4. Two C.2s survive, at Blackbushe and at the Flixton museum, and the film *High Flight* (1957) preserves a long sequence of navigation lessons aboard one.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1946-01-01',
    '1947-06-30',
    '1948-01-01',
    415,
    2350,
    (SELECT id FROM manufacturer WHERE code = 'VIC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valetta'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valetta'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Vickers Valetta'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Vickers Valetta'), (SELECT id FROM wars WHERE name = 'Crise de Suez')),
((SELECT id FROM airplanes WHERE name = 'Vickers Valetta'), (SELECT id FROM wars WHERE name = 'Insurrection malaise'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.18,
  wingspan          = 27.2,
  height            = 5.97,
  wing_area         = 81.9,
  empty_weight      = 11331,
  mtow              = 16556,
  service_ceiling   = 6600,
  climb_rate        = 6.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Hercules 230 (2 000 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 262,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Valetta C.1** : transport polyvalent, 211 exemplaires\n- **Valetta C.2** : transport de personnalités à plus grande autonomie, 11 exemplaires\n- **Valetta T.3** : salle de classe volante pour navigateurs, à astrodômes, 40 exemplaires livrés d''août 1951 à septembre 1952\n- **Valetta T.4** : 18 T.3 convertis avec un radar dans un nez allongé, pour la formation à l''interception',
  variants_en       = E'- **Valetta C.1**: multi-role transport, 211 built\n- **Valetta C.2**: longer-range VIP transport, 11 built\n- **Valetta T.3**: flying classroom for navigators, with astrodomes, 40 delivered from August 1951 to September 1952\n- **Valetta T.4**: 18 T.3s converted with radar in an enlarged nose, for interception training',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vickers_Valetta',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vickers_Valetta',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'André Gerwing',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Vickers Valetta';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Vickers Valetta';
