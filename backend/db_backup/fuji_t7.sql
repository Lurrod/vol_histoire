-- Fuji T-7
--
-- Photo : 56-5928 Fuji T-7 trainer 11 Hiko Kyoiku (5239087142).jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File%3A56-5928_Fuji_T-7_trainer_11_Hiko_Kyoiku_%285239087142%29.jpg

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
    'Fuji T-7',
    'Fuji T-7',
    'Fuji T-7',
    'Fuji T-7',
    'L’école primaire japonaise, dernière descendante du T-34 Mentor',
    'Japan’s primary trainer, last descendant of the T-34 Mentor',
    '/assets/airplanes/fuji-t7.jpg',
    E'## Genèse\nLe Japon forme ses pilotes depuis 1974 sur le **Fuji T-3**, dérivé local du Beechcraft T-34 Mentor à moteur à pistons. À la fin des années 1990, les pièces se raréfient et le moteur appartient à une autre époque que les appareils sur lesquels les élèves passeront. Fuji propose la modernisation minimale : la même cellule, un turbopropulseur.\n\n## Conception\nDeux places en tandem, aile droite, train tricycle fixe, une turbine **Rolls-Royce M250** de cinq cent cinquante chevaux. La lignée remonte au **T-34 Mentor** de 1948, lui-même dérivé du Beechcraft Bonanza : soixante-dix-sept ans séparent la cellule d''origine de l''appareil en service. Peu d''architectures aéronautiques ont duré aussi longtemps.\n\n## Carrière opérationnelle\nQuarante-neuf exemplaires, un seul opérateur. Le T-7 assure la formation élémentaire de tous les pilotes de l''armée de l''air japonaise depuis 2002 ; sa version navale **T-5** fait de même pour la marine. Le choix contre le Pilatus PC-7 a donné lieu à une enquête pour irrégularité dans l''attribution du marché.\n\n## Place dans l''histoire\nQuarante-neuf exemplaires. Le T-7 n''a rien inventé et n''y prétend pas : il illustre la continuité japonaise, où l''on préfère prolonger et raffiner une cellule éprouvée plutôt que d''en dessiner une neuve. C''est la même logique qui a mené du **T-2** au **F-1**, et du **F-1** au **F-2**.',
    E'## Genesis\nJapan had trained its pilots since 1974 on the **Fuji T-3**, a local derivative of the piston Beechcraft T-34 Mentor. By the late 1990s parts were scarce and the engine belonged to a different era from the aircraft its pupils would move on to. Fuji offered the minimal modernisation: the same airframe, a turboprop.\n\n## Design\nTwo seats in tandem, straight wing, fixed tricycle gear, a five-hundred-and-fifty-horsepower **Rolls-Royce M250** turbine. The line goes back to the 1948 **T-34 Mentor**, itself derived from the Beechcraft Bonanza: seventy-seven years separate the original airframe from the aircraft in service. Few aeronautical architectures have lasted so long.\n\n## Operational career\nForty-nine built, a single operator. The T-7 has provided elementary training for every Japanese air force pilot since 2002; its naval **T-5** version does the same for the navy. The choice over the Pilatus PC-7 led to an investigation into irregularities in the award.\n\n## Place in history\nForty-nine built. The T-7 invented nothing and claims nothing: it illustrates Japanese continuity, where a proven airframe is extended and refined rather than replaced. It is the same logic that led from the **T-2** to the **F-1**, and from the **F-1** to the **F-2**.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1998-01-01',
    '1998-07-01',
    '2002-09-01',
    376.0,
    950.0,
    (SELECT id FROM manufacturer WHERE code = 'FUJ'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-7'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-7'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.59,
  wingspan          = 10.04,
  height            = 2.96,
  wing_area         = 16.5,
  empty_weight      = 1100,
  mtow              = 1585,
  service_ceiling   = 7620,
  climb_rate        = 7.5,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 400,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce M250-B17F',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2000,
  production_end    = 2015,
  units_built       = 49,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **T-7** : version de l''armée de l''air, quarante-neuf exemplaires\n- **T-5** : version de la marine, à moteur et hélice différents\n- Remplace le **T-3**, lui-même dérivé du **Beechcraft T-34 Mentor**\n- Passage du moteur à pistons au **turbopropulseur** : seule vraie évolution\n- Choisi en 1998 contre le Pilatus PC-7 dans un appel d''offres contesté',
  variants_en       = E'- **T-7** : air force version, forty-nine aircraft\n- **T-5** : navy version, with a different engine and propeller\n- Replaces the **T-3**, itself derived from the **Beechcraft T-34 Mentor**\n- Piston engine to **turboprop**: the only real change\n- Chosen in 1998 over the Pilatus PC-7 in a disputed competition',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fuji_T-7',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fuji_T-7',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner from Lincoln, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Fuji T-7';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fuji T-7';
