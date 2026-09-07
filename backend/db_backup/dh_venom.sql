-- de Havilland DH.112 Venom
--
-- Photo : Venom 3 (4703782203).jpg
--   licence CC BY 2.0 — Tony Hisgett from Birmingham, UK
--   https://commons.wikimedia.org/wiki/File%3AVenom_3_%284703782203%29.jpg

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
    'de Havilland Venom',
    'de Havilland Venom',
    'de Havilland DH.112 Venom',
    'de Havilland DH.112 Venom',
    'Le Vampire réétudié pour la haute altitude',
    'The Vampire redesigned for high altitude',
    '/assets/airplanes/dh-venom.jpg',
    E'## Genèse\nLe **Vampire** vieillit vite : son réacteur Goblin plafonne et l''appareil s''essouffle en altitude, là où se joueront les interceptions. De Havilland conçoit en 1948 une évolution que la firme présente d''abord comme un simple Vampire remotorisé — le nom initial est d''ailleurs Vampire FB.8. Les modifications sont telles qu''un nom propre s''impose.\n\n## Conception\nIl conserve la formule caractéristique du Vampire, **fuselage court en nacelle et double poutre de queue**, mais reçoit une aile entièrement nouvelle, plus fine et plus mince, dotée de réservoirs de bout d''aile. Le réacteur Ghost développe la moitié de poussée en plus que le Goblin. L''ensemble gagne cent cinquante kilomètres-heure et deux mille mètres de plafond — l''appareil de haute altitude que le Vampire n''était pas.\n\n## Carrière opérationnelle\nIl sert en **Malaisie** contre l''insurrection communiste, à **Aden** et au Yémen, et à **Suez** en 1956 dans sa version embarquée Sea Venom. Mais sa carrière la plus longue est neutre : la **Suisse** l''exploite depuis ses bases alpines pendant trente et un ans, jusqu''en 1983, bien après que la Grande-Bretagne l''a retiré.\n\n## Place dans l''histoire\nMille quatre cent trente et un exemplaires, et le dernier chasseur à double poutre de l''histoire. Il clôt une formule aérodynamique et une époque : le **Sea Vixen**, qui lui succède dans la Fleet Air Arm, sera le dernier avion à porter le nom de Havilland avant l''absorption de la firme par Hawker Siddeley.',
    E'## Genesis\nThe **Vampire** aged fast: its Goblin engine had reached its ceiling and the aircraft ran out of breath at altitude, where interceptions would be decided. In 1948 de Havilland designed an evolution the firm first presented as merely a re-engined Vampire — the initial name was in fact Vampire FB.8. The changes proved great enough to require a name of its own.\n\n## Design\nIt keeps the Vampire''s characteristic layout, a **short pod fuselage and twin tail booms**, but receives an entirely new wing, thinner and slimmer, with wingtip tanks. The Ghost engine develops half as much thrust again as the Goblin. The result gains a hundred and fifty kilometres per hour and two thousand metres of ceiling — the high-altitude aircraft the Vampire was not.\n\n## Operational career\nIt served in **Malaya** against the communist insurgency, at **Aden** and in Yemen, and at **Suez** in 1956 in its Sea Venom carrier form. But its longest career was a neutral one: **Switzerland** flew it from Alpine bases for thirty-one years, until 1983, long after Britain had retired it.\n\n## Place in history\nOne thousand four hundred and thirty-one built, and the last twin-boom fighter in history. It closes an aerodynamic formula and an era: the **Sea Vixen**, which succeeded it in the Fleet Air Arm, would be the last aircraft to carry the de Havilland name before the firm was absorbed by Hawker Siddeley.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1948-01-01',
    '1949-09-02',
    '1952-08-01',
    1030.0,
    1730.0,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.71,
  wingspan          = 12.7,
  height            = 1.88,
  wing_area         = 25.99,
  empty_weight      = 3992,
  mtow              = 6945,
  service_ceiling   = 14600,
  climb_rate        = 40.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Ghost 103',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 21.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1957,
  units_built       = 1431,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 8,
  variants          = E'- **Venom FB.1 / FB.4** : chasseurs-bombardiers monoplaces, versions principales\n- **Venom NF.2 / NF.3** : chasseurs de nuit biplaces à radar\n- **Sea Venom** : version embarquée de la Royal Navy, engagée à Suez\n- **Aquilon** : Sea Venom construit sous licence en **France** par la SNCASE\n- La **Suisse** en a volé jusqu''en 1983, soit trente et un ans de service',
  variants_en       = E'- **Venom FB.1 / FB.4** : single-seat fighter-bombers, the main versions\n- **Venom NF.2 / NF.3** : two-seat radar night fighters\n- **Sea Venom** : Royal Navy carrier version, committed at Suez\n- **Aquilon** : Sea Venom built under licence in **France** by SNCASE\n- **Switzerland** flew it until 1983, thirty-one years of service',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Venom',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Venom',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tony Hisgett from Birmingham, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'de Havilland Venom';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'de Havilland Venom';
