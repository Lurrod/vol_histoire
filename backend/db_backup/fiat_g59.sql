-- Fiat G.59
--
-- Photo : Fiat G-59-4B I-MRSV (cn 181) Formazione Legend (21902939898).jpg
--   licence CC BY 2.0 — Gian Marco Anzellotti from Roma, Italia
--   https://commons.wikimedia.org/wiki/File:Fiat_G-59-4B_I-MRSV_(cn_181)_Formazione_Legend_(21902939898).jpg

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
    'Fiat G.59',
    'Fiat G.59',
    'Fiat G.59',
    'Fiat G.59',
    'Dernier descendant du chasseur Centauro, remotorisé au Merlin pour former les pilotes italiens d''après-guerre',
    'The last descendant of the Centauro fighter, re-engined with the Merlin to train Italy''s post-war pilots',
    '/assets/airplanes/fiat-g59.jpg',
    E'## Genèse\nLe **Fiat G.59** naît d''une pénurie. Pendant la guerre, **Giuseppe Gabrielli** avait dessiné pour Fiat le **G.55 Centauro**, chasseur propulsé par une copie sous licence du moteur allemand Daimler-Benz DB 605, que des officiels de la Luftwaffe avaient jugé en 1943 « le meilleur chasseur de l''Axe ». En 1946, Fiat relance sa fabrication en puisant dans les cellules et pièces restées dans ses usines, en deux versions : le G.55A monoplace, chasseur et avion d''entraînement avancé, et le G.55B biplace. L''armée de l''air italienne et l''armée de l''air argentine en commandent, si bien que le stock de moteurs construits en Italie s''épuise.\n\n## Conception\nPlutôt que d''abandonner un avion toujours demandé, Fiat le convertit au **Rolls-Royce Merlin**, beaucoup plus facile à obtenir. La première conversion vole au début de 1948 et se révèle réussie : l''**Aeronautica Militare** décide de remotoriser ses G.55. Les avions reconstruits deviennent G.59-1A, monoplace, et G.59-1B, biplace, tous deux destinés à l''entraînement avancé. Les dernières versions, G.59-4A et G.59-4B, sont entièrement neuves et reçoivent une verrière en goutte d''eau qui améliore nettement la visibilité ; l''Italie en produit vingt et dix.\n\n## Carrière opérationnelle\nLes G.59 entrent en service en 1950 à l''école de pilotage de **Lecce**. L''Aeronautica Militare en aligne 74 au total et les garde jusqu''en 1964. La **Syrie** commande trente appareils, tous neufs car les pièces de G.55 sont désormais épuisées : vingt-six monoplaces G.59-2A et quatre biplaces G.59-2B. L''**Argentine** acquiert un G.59-2A pour évaluation, sans commande à la clé. En septembre 1951, cet unique exemplaire du Grupo 2 de Caza tente avec les G.55 de rallier les auteurs d''un coup d''État manqué contre **Juan Perón** ; pilotes et avions sont immobilisés dès leur arrivée à la base de Punta Indio.\n\n## Place dans l''histoire\nLe G.59 prolonge de près de quinze ans la carrière d''une cellule dessinée en pleine guerre, preuve de l''ingéniosité d''une industrie italienne qui se relève avec les moyens du bord. Il a formé les pilotes de l''Aeronautica Militare naissante. Aucun G.55 n''ayant survécu, c''est un G.59-2A, retransformé, qui représente le Centauro au musée de l''armée de l''air italienne à Vigna di Valle. Plusieurs G.59 sont conservés dans leur configuration d''après-guerre, et deux G.59-4B biplaces volent encore.',
    E'## Genesis\nThe **Fiat G.59** was born of a shortage. During the war **Giuseppe Gabrielli** had designed the **G.55 Centauro** for Fiat, a fighter powered by a licence-built copy of the German Daimler-Benz DB 605 that Luftwaffe officials had called "the best Axis fighter" in 1943. In 1946 Fiat restarted production using the airframes and parts left in its factories, in two versions: the single-seat G.55A fighter and advanced trainer, and the two-seat G.55B. The Italian and Argentine air forces placed orders, and the stock of Italian-built engines soon ran out.\n\n## Design\nRather than abandon an aircraft that was still in demand, Fiat converted it to the far more readily available **Rolls-Royce Merlin**. The first conversion flew in early 1948 and proved successful, so the **Italian Air Force** decided to re-engine its G.55s. The rebuilt aircraft became the single-seat G.59-1A and the two-seat G.59-1B, both used as advanced trainers. The final versions, the G.59-4A and G.59-4B, were newly built and fitted with bubble canopies for much better visibility; Italy produced twenty and ten respectively.\n\n## Operational career\nThe G.59 entered service at the **Lecce** flying school in 1950. The Italian Air Force operated 74 in all and kept them until 1964. **Syria** ordered thirty, all newly built as the stock of G.55 components was by then exhausted: twenty-six single-seat G.59-2As and four two-seat G.59-2Bs. **Argentina** acquired a single G.59-2A for evaluation, but no order followed. In September 1951 that lone aircraft of Grupo 2 de Caza tried, together with the G.55s, to defect to the plotters of a failed coup against **Juan Perón**; pilots and aircraft were immobilised on arrival at Punta Indio.\n\n## Place in history\nThe G.59 extended by some fifteen years the career of an airframe designed in the middle of the war, a sign of the resourcefulness of an Italian industry rebuilding with whatever it had. It trained the pilots of the young post-war Italian Air Force. As no G.55 survives, a G.59-2A converted back to resemble one represents the Centauro at the Italian Air Force Museum at Vigna di Valle. Several G.59s are preserved in their post-war configuration, and two two-seat G.59-4Bs are still airworthy.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    NULL,
    '1948-01-01',
    '1950-01-01',
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'FIAT'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.59'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Merlin',
  engine_count      = 1,
  engine_type       = 'Moteur en V',
  engine_type_en    = 'V engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1948,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **G.59-1A** : G.55 italiens convertis au Merlin, monoplace d''entraînement avancé\n- **G.59-1B** : version biplace d''entraînement des G.55 convertis\n- **G.59-2A / G.59-2B** : 26 monoplaces et 4 biplaces neufs pour la Syrie, un G.59-2A évalué par l''Argentine\n- **G.59-4A** : 20 monoplaces neufs pour l''Italie, verrière en goutte d''eau\n- **G.59-4B** : 10 biplaces neufs pour l''Italie, verrière en goutte d''eau',
  variants_en       = E'- **G.59-1A**: Italian G.55s converted to the Merlin, single-seat advanced trainer\n- **G.59-1B**: two-seat trainer version of the converted G.55s\n- **G.59-2A / G.59-2B**: 26 single-seaters and 4 two-seaters newly built for Syria, one G.59-2A evaluated by Argentina\n- **G.59-4A**: 20 single-seaters newly built for Italy, bubble canopy\n- **G.59-4B**: 10 two-seaters newly built for Italy, bubble canopy',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fiat_G.55_Centauro',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fiat_G.55_Centauro',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Gian Marco Anzellotti',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Fiat G.59';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fiat G.59';
