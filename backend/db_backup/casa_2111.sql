-- CASA 2.111
--
-- Photo : CASA 2.111B in flight.jpg
--   licence CC BY-SA 3.0 — Umeyou
--   https://commons.wikimedia.org/wiki/File:CASA_2.111B_in_flight.jpg

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
    'CASA 2.111',
    'CASA 2.111',
    'CASA 2.111',
    'CASA 2.111',
    'Heinkel He 111 construit sous licence en Espagne, passé au moteur Merlin et en service jusqu''en 1973',
    'Heinkel He 111 licence-built in Spain, re-engined with the Merlin and in service until 1973',
    '/assets/airplanes/casa-2111.jpg',
    E'## Genèse\nPendant la guerre civile, en 1937, l''aviation nationaliste reçoit d''Allemagne des **Heinkel He 111B**, puis des He 111E une fois le conflit terminé. Il lui faut des appareils plus modernes : en 1940, **CASA** (Construcciones Aeronáuticas SA) négocie avec Heinkel la production à Séville de 200 exemplaires du **He 111 H-16**, bien plus récent. La mise en route est lente, l''Allemagne en guerre n''apportant qu''une aide limitée. L''Espagne trouve en France un stock de moteurs **Junkers Jumo 211F-2**, qui permet d''achever 130 avions, dont 117 seulement sont livrés, faute de moteurs en nombre suffisant. Le premier exemplaire construit en Espagne vole le 23 mai 1945.\n\n## Conception\nLe 2.111 reprend pour l''essentiel la cellule du He 111H, avec son nez vitré caractéristique, mais en diffère par de nombreux détails et par un armement plus lourd. Une fois la guerre finie, plus aucun moteur ni pièce allemande ne peut être obtenu. CASA se tourne alors vers le **Rolls-Royce Merlin 500** : en avril 1956, 173 moteurs sont commandés et montés dans des nacelles complètes conçues par Rolls-Royce pour le Beaufighter II puis employées sur le Lancaster. Les bombardiers deviennent des **2.111B**, les avions de reconnaissance des **2.111D** ; certains sont remotorisés, d''autres construits neufs. Un transport de neuf passagers, le **2.111T8**, complète la gamme.\n\n## Carrière opérationnelle\nLe 2.111 sert de bombardier moyen, d''avion de reconnaissance, d''école et de transport dans l''armée de l''air espagnole. Il connaît le combat pendant la **guerre d''Ifni**, en 1957-1958, dans un rôle d''appui aérien rapproché. La plupart des appareils sont retirés au cours des années 1960, les transports au début des années 1970. Un 2.111D aménagé a transporté des personnalités espagnoles, dont le général **Franco**, avant d''être racheté en 1977 par la Confederate Air Force ; dernier He 111 en état de vol, il s''écrase le 10 juillet 2003 à Cheyenne, dans le Wyoming, tuant ses deux pilotes.\n\n## Place dans l''histoire\nCopie espagnole d''un bombardier allemand, propulsée par le moteur emblématique de la RAF, le 2.111 est un produit typique d''une Espagne isolée qui assemble ce qu''elle peut obtenir. Sa ressemblance avec le He 111 lui a valu une carrière au cinéma, dans *La Bataille d''Angleterre* et *Patton*, souvent aux côtés du chasseur **Hispano HA-1112**. Une dizaine d''exemplaires sont conservés, de Madrid au Bourget, de Berlin-Gatow à Sinsheim et jusqu''aux musées américains.',
    E'## Genesis\nDuring the Civil War, in 1937, the Nationalist air force received **Heinkel He 111B**s from Germany, followed by He 111Es once the conflict was over. It needed more modern aircraft: in 1940 **CASA** (Construcciones Aeronáuticas SA) negotiated with Heinkel to build 200 of the far more recent **He 111 H-16** in Seville. Setting up production was slow, with Germany at war providing little support. Spain found a store of **Junkers Jumo 211F-2** engines in France, which allowed 130 aircraft to be completed, only 117 of them delivered for lack of enough engines. The first Spanish-built example flew on 23 May 1945.\n\n## Design\nThe 2.111 essentially retained the He 111H airframe, with its characteristic glazed nose, but differed in many details and carried heavier armament. Once the war was over, no German engines or parts could be obtained. CASA turned to the **Rolls-Royce Merlin 500**: in April 1956, 173 engines were ordered and installed in complete power-plant nacelles designed by Rolls-Royce for the Beaufighter II and later used on the Lancaster. The bombers became **2.111B**s and the reconnaissance aircraft **2.111D**s; some were re-engined, others built new. A nine-passenger transport, the **2.111T8**, completed the range.\n\n## Operational career\nThe 2.111 served as a medium bomber, reconnaissance aircraft, trainer and transport with the Spanish Air Force. It saw combat in the **Ifni War** of 1957-1958, in the close air support role. Most aircraft were retired during the 1960s, the transports in the early 1970s. One modified 2.111D carried Spanish VIPs, including General **Franco**, before being bought in 1977 by the Confederate Air Force; the last airworthy He 111, it crashed on 10 July 2003 at Cheyenne, Wyoming, killing both pilots.\n\n## Place in history\nA Spanish copy of a German bomber, powered by the RAF''s emblematic engine, the 2.111 is a typical product of an isolated Spain assembling whatever it could obtain. Its resemblance to the He 111 earned it a film career, in *Battle of Britain* and *Patton*, often alongside the **Hispano HA-1112** fighter. Around a dozen survive, from Madrid to Le Bourget, from Berlin-Gatow to Sinsheim and in American museums.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '1940-01-01',
    '1945-05-23',
    NULL,
    440,
    1950,
    (SELECT id FROM manufacturer WHERE code = 'CASA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA 2.111'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CASA 2.111'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'CASA 2.111'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'CASA 2.111'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'CASA 2.111'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.4,
  wingspan          = 22.5,
  height            = 3.9,
  wing_area         = 86.5,
  empty_weight      = NULL,
  mtow              = 14000,
  service_ceiling   = 7800,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Merlin 500-29 (1 577 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1956,
  units_built       = 236,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **2.111A** : bombardier moyen, He 111H-16 sous licence à moteurs Junkers Jumo 211\n- **2.111B** : bombardier remotorisé avec des Rolls-Royce Merlin 500-29\n- **2.111C et 2.111D** : versions de reconnaissance, à moteurs Jumo puis Merlin\n- **2.111E et 2.111T8** : transports, le T8 pour neuf passagers\n- **2.111F** : biplace d''entraînement à double commande',
  variants_en       = E'- **2.111A**: medium bomber, licence-built He 111H-16 with Junkers Jumo 211 engines\n- **2.111B**: bomber re-engined with Rolls-Royce Merlin 500-29s\n- **2.111C and 2.111D**: reconnaissance versions, with Jumo and then Merlin engines\n- **2.111E and 2.111T8**: transports, the T8 carrying nine passengers\n- **2.111F**: dual-control trainer',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CASA_2.111',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CASA_2.111',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Umeyou',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'CASA 2.111';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CASA 2.111';
