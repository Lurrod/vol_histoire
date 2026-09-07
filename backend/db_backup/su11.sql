-- Soukhoï Su-11 (Fishpot-C)
--
-- Photo : Sukhoi Su-11 ’14 red’ (24512014377).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ASukhoi_Su-11_%E2%80%9914_red%E2%80%99_%2824512014377%29.jpg

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
    'Su-11',
    'Su-11',
    'Soukhoï Su-11 (Fishpot-C)',
    'Sukhoi Su-11 (Fishpot-C)',
    'Intercepteur sans canon, entièrement dépendant du sol',
    'Gunless interceptor, wholly dependent on ground control',
    '/assets/airplanes/su11.jpg',
    E'## Genèse\nLe **Su-9**, entré en service en 1960, souffre d''un radar trop faible pour engager un bombardier de nuit. Soukhoï reprend la même cellule et y installe le radar **Oriol**, bien plus lourd, ce qui impose d''agrandir le cône central de l''entrée d''air et d''allonger le nez. Le Su-11 est donc un Su-9 corrigé, pas un appareil neuf.\n\n## Conception\nAile delta pure, entrée d''air frontale à cône mobile, un seul réacteur AL-7F. Le choix le plus frappant est l''absence totale de canon : l''appareil emporte **deux missiles R-8 et rien d''autre**. La doctrine l''assume — l''intercepteur soviétique n''est pas un chasseur, c''est un lanceur piloté que le sol guide jusqu''à portée de tir par le système **Vozdukh-1**. Le pilote n''a, en pratique, presque aucune initiative.\n\n## Carrière opérationnelle\nCent huit exemplaires tiennent l''alerte aux frontières soviétiques, essentiellement dans le Nord et en Extrême-Orient. Le monomoteur AL-7 se révèle peu fiable, et le taux d''accidents est élevé pour une flotte aussi réduite. Aucun Su-11 n''a jamais été exporté ni engagé au combat.\n\n## Place dans l''histoire\nCent huit exemplaires seulement, trois ans de production. Il marque la fin d''une branche : Soukhoï abandonne le monomoteur pour l''intercepteur, et le **Su-15** bimoteur qui lui succède corrige à la fois la fiabilité et le radar. Le Su-11 reste l''expression la plus pure de la doctrine soviétique d''interception téléguidée depuis le sol.',
    E'## Genesis\nThe **Su-9**, in service from 1960, suffered from a radar too weak to engage a bomber at night. Sukhoi took the same airframe and installed the far heavier **Oriol** radar, which meant enlarging the intake centre cone and lengthening the nose. The Su-11 is therefore a corrected Su-9, not a new aircraft.\n\n## Design\nA pure delta wing, a nose intake with a moving cone, a single AL-7F engine. The most striking choice is the total absence of a gun: the aircraft carries **two R-8 missiles and nothing else**. Doctrine embraced this — the Soviet interceptor is not a fighter but a piloted launcher, guided from the ground to firing range by the **Vozdukh-1** system. In practice the pilot has almost no initiative.\n\n## Operational career\nOne hundred and eight aircraft stood alert on the Soviet frontiers, mainly in the north and the Far East. The single AL-7 proved unreliable, and the accident rate was high for so small a fleet. No Su-11 was ever exported or committed to combat.\n\n## Place in history\nOnly one hundred and eight built over three years. It marks the end of a branch: Sukhoi abandoned the single engine for interceptors, and the twin-engined **Su-15** that succeeded it fixed both the reliability and the radar. The Su-11 remains the purest expression of the Soviet doctrine of interception directed from the ground.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1958-01-01',
    '1961-01-01',
    '1964-01-01',
    2340.0,
    1800.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM armement WHERE name = 'R-3S'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.23,
  wingspan          = 8.54,
  height            = 4.88,
  wing_area         = 34.0,
  empty_weight      = 9100,
  mtow              = 13990,
  service_ceiling   = 17000,
  climb_rate        = 140.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 450,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Lyulka AL-7F-2',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 66.6,
  thrust_wet        = 98.0,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1965,
  units_built       = 108,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Su-11** : version de série unique, radar Oriol dans un cône d''entrée d''air agrandi\n- Dérivé direct du **Su-9**, dont il reprend la cellule et l''aile delta\n- **Aucun canon** : deux missiles R-8 seulement, un à guidage radar, un à infrarouge\n- Intégré au système **Vozdukh-1** : l''interception était calculée au sol\n- Remplacé par le **Su-15**, bimoteur et beaucoup plus sûr',
  variants_en       = E'- **Su-11** : the sole production version, Oriol radar in an enlarged intake cone\n- Direct derivative of the **Su-9**, whose airframe and delta wing it reuses\n- **No cannon**: two R-8 missiles only, one radar-guided, one infrared\n- Integrated into the **Vozdukh-1** system: the intercept was computed on the ground\n- Replaced by the twin-engined and far safer **Su-15**',

  -- Strate 4 : qualitatif
  nickname          = 'Fishpot-C',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soukhoï_Su-11',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sukhoi_Su-11',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Su-11';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Su-11';
