-- Saunders-Roe SR.53
--
-- Photo : Saunders Roe SR53 (50093618687).jpg
--   licence CC BY-SA 2.0 — Hugh Llewelyn from Keynsham, UK
--   https://commons.wikimedia.org/wiki/File%3ASaunders_Roe_SR53_%2850093618687%29.jpg

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
    'Saunders-Roe SR.53',
    'Saunders-Roe SR.53',
    'Saunders-Roe SR.53',
    'Saunders-Roe SR.53',
    'Intercepteur mixte fusée et réacteur, tué par un Livre blanc',
    'Mixed rocket-and-jet interceptor, killed by a White Paper',
    '/assets/airplanes/sr53.jpg',
    E'## Genèse\nLe calcul britannique de 1951 est simple et terrifiant : face à des bombardiers soviétiques détectés au radar côtier, un intercepteur classique n''a pas le temps de monter. Il faut atteindre **vingt mille mètres en moins de trois minutes**. Aucun réacteur n''en est capable. La fusée, oui — mais elle brûle son carburant en deux minutes et laisse l''appareil sans moteur pour rentrer.\n\n## Conception\nD''où la formule mixte : une **fusée Spectre** de trois tonnes cinq de poussée pour la montée, et un petit **réacteur Viper** pour le retour et l''attente. La fusée brûle du peroxyde d''hydrogène et du kérosène — le peroxyde est si corrosif que les mécaniciens travaillaient en combinaison étanche. L''aile delta est minuscule, le fuselage effilé : la montée se fait presque à la verticale, à deux cent cinquante mètres par seconde.\n\n## Carrière opérationnelle\nAucune. Deux prototypes volent cinquante-six fois entre 1957 et 1959. Le second s''écrase au décollage en 1958, tuant son pilote. Entre-temps, le **Livre blanc de la Défense de 1957** a décrété que le missile sol-air rendrait tout chasseur piloté obsolète — et annulé, d''un trait, presque tous les programmes britanniques en cours.\n\n## Place dans l''histoire\nDeux exemplaires. Sa version opérationnelle, le **SR.177**, était en cours de négociation avec l''Allemagne fédérale, qui envisageait cent cinquante appareils ; l''annulation britannique a rompu l''affaire, et Bonn a acheté des **F-104 Starfighter**. L''intercepteur à fusée disparaît avec lui : personne n''a plus jamais essayé.',
    E'## Genesis\nThe British calculation of 1951 was simple and terrifying: against Soviet bombers detected by coastal radar, a conventional interceptor has no time to climb. It had to reach **twenty thousand metres in under three minutes**. No jet engine could do it. A rocket could — but it burns its fuel in two minutes and leaves the aircraft without power to get home.\n\n## Design\nHence the mixed formula: a **Spectre rocket** of three and a half tonnes thrust for the climb, and a small **Viper jet** for the return and the loiter. The rocket burned hydrogen peroxide and kerosene — the peroxide so corrosive that ground crews worked in sealed suits. The delta wing is tiny and the fuselage slender: the climb is almost vertical, at two hundred and fifty metres per second.\n\n## Operational career\nNone. Two prototypes flew fifty-six times between 1957 and 1959. The second crashed on take-off in 1958, killing its pilot. In the meantime the **1957 Defence White Paper** had decreed that the surface-to-air missile would render every manned fighter obsolete — and cancelled, at a stroke, almost every British programme then running.\n\n## Place in history\nTwo built. Its operational version, the **SR.177**, was under negotiation with West Germany, which was considering a hundred and fifty aircraft; the British cancellation broke the deal, and Bonn bought **F-104 Starfighters** instead. The rocket interceptor disappeared with it: nobody has tried again.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1951-01-01',
    '1957-05-16',
    NULL,
    2130.0,
    640.0,
    (SELECT id FROM manufacturer WHERE code = 'SRO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.53'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.53'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.53'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.72,
  wingspan          = 7.68,
  height            = 3.3,
  wing_area         = 25.1,
  empty_weight      = 3175,
  mtow              = 8618,
  service_ceiling   = 20000,
  climb_rate        = 250.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 200,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Spectre + Armstrong Siddeley Viper',
  engine_count      = 2,
  engine_type       = 'Fusée et turboréacteur',
  engine_type_en    = 'Rocket and turbojet',
  thrust_dry        = 7.3,
  thrust_wet        = 35.6,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1957,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **SR.53** : deux prototypes construits, 56 vols au total\n- **SR.177** : version opérationnelle prévue, à radar et fusée plus puissante\n- L''**Allemagne fédérale** était sur le point d''en commander cent cinquante\n- Fusée **Spectre** au peroxyde d''hydrogène, poussée modulable, coupable et rallumable\n- Annulé par le **Livre blanc de la Défense de 1957**, qui misait tout sur le missile',
  variants_en       = E'- **SR.53** : two prototypes built, fifty-six flights in all\n- **SR.177** : planned operational version, with radar and a more powerful rocket\n- **West Germany** was on the point of ordering a hundred and fifty\n- **Spectre** hydrogen-peroxide rocket: throttleable, shut down and relit in flight\n- Cancelled by the **1957 Defence White Paper**, which staked everything on missiles',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saunders-Roe_SR.53',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saunders-Roe_SR.53',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hugh Llewelyn from Keynsham, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Saunders-Roe SR.53';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saunders-Roe SR.53';
