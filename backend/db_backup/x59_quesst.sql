-- Lockheed Martin X-59 QueSST
--
-- Photo : X-59 Prepares for Supersonic Flight Tests (x-59-prepares-for-supersonic-flight-tests-5).jpg
--   licence Public domain — Jim Ross, NASA
--   https://commons.wikimedia.org/wiki/File:X-59_Prepares_for_Supersonic_Flight_Tests_(x-59-prepares-for-supersonic-flight-tests-5).jpg

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
    'Lockheed Martin X-59 QueSST',
    'Lockheed Martin X-59 QueSST',
    'Lockheed Martin X-59 QueSST',
    'Lockheed Martin X-59 QueSST',
    'Trente mètres de long pour réduire le bang supersonique à un simple coup sourd',
    'Thirty metres long to turn the sonic boom into a muffled thump',
    '/assets/airplanes/x59-quesst.jpg',
    E'## Genèse\nDepuis 1973, les États-Unis interdisent le vol supersonique civil au-dessus des terres à cause du bang sonique, la règle qui a cantonné le **Concorde** aux routes océaniques. La NASA mise sur une idée étudiée depuis des décennies : en façonnant l''avion, on peut étaler les ondes de choc pour qu''au sol le double bang devienne un simple coup sourd. Après une étude préliminaire confiée à **Lockheed Martin** en février 2016, la NASA lui attribue le 2 avril 2018 un contrat de 247,5 millions de dollars pour construire le démonstrateur.\n\n## Conception\nTout est sacrifié à la forme : un fuselage de plus de 30 m pour 9 m d''envergure, dont un nez effilé qui en occupe près d''un tiers, et un réacteur **General Electric F414** monté sur le dos pour que l''aile masque ses ondes de choc. Le nez est si long que le pilote n''a aucune vue directe vers l''avant : il se guide grâce à l''**External Vision System**, une caméra 4K dont l''image s''affiche sur un écran du poste. Pour contenir les coûts, la verrière et le siège éjectable viennent du **T-38**, le train d''atterrissage du **F-16**.\n\n## Carrière opérationnelle\nLe X-59 effectue son premier vol le 28 octobre 2025, de Palmdale à Edwards, en restant subsonique. Le 5 juin 2026, il franchit Mach 1 pour la première fois ; quelques jours plus tard, il atteint Mach 1,4 à près de 16 800 m, ses conditions de mission. Reste la phase pour laquelle il a été construit : survoler des villes américaines et recueillir l''avis des habitants sur le bruit perçu, afin de fournir aux autorités les données d''une nouvelle norme.\n\n## Place dans l''histoire\nLe X-59 prolonge la longue lignée des avions X, du **Bell X-1** au **X-29**, conçus chacun pour répondre à une seule question. La sienne n''est pas militaire mais réglementaire : si son coup sourd, visé autour de 75 PLdB, est jugé acceptable, il pourrait rouvrir la voie au transport supersonique commercial au-dessus des terres, un demi-siècle après l''interdiction.',
    E'## Genesis\nSince 1973 the United States has banned civil supersonic flight over land because of the sonic boom, the rule that confined **Concorde** to ocean routes. NASA bet on an idea studied for decades: by shaping the aircraft, the shock waves can be spread out so that on the ground the double boom becomes a mere thump. After a preliminary design study awarded to **Lockheed Martin** in February 2016, NASA gave it a $247.5 million contract on 2 April 2018 to build the demonstrator.\n\n## Design\nEverything is sacrificed to shape: a fuselage over 30 m long for a 9 m span, nearly a third of it a slender nose, and a **General Electric F414** engine mounted on top so the wing shields its shock waves. The nose is so long that the pilot has no direct forward view: he flies with the **External Vision System**, a 4K camera whose image is shown on a cockpit display. To contain costs, the canopy and ejection seat come from the **T-38** and the landing gear from the **F-16**.\n\n## Operational career\nThe X-59 made its first flight on 28 October 2025, from Palmdale to Edwards, staying subsonic. On 5 June 2026 it went beyond Mach 1 for the first time; a few days later it reached Mach 1.4 at nearly 16,800 m, its mission conditions. What remains is the phase it was built for: flying over American towns and gathering residents'' views on the noise they hear, to give regulators the data for a new standard.\n\n## Place in history\nThe X-59 extends the long line of X-planes, from the **Bell X-1** to the **X-29**, each designed to answer a single question. Its question is not military but regulatory: if its thump, targeted at around 75 PLdB, is judged acceptable, it could reopen the way to commercial supersonic transport over land, half a century after the ban.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2016-02-01',
    '2025-10-28',
    NULL,
    1590.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-59 QueSST'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-59 QueSST'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Martin X-59 QueSST'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.39,
  wingspan          = 8.99,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 14651,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F414-GE-100',
  engine_count      = 1,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = NULL,
  thrust_wet        = 98.0,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Démonstrateur unique**, cœur de la mission **Quesst** de la NASA\n- **Nez effilé** occupant près d''un tiers de la longueur, réacteur F414 monté sur le dos\n- **External Vision System** : vue vers l''avant par caméra 4K, sans vision directe\n- **Premier vol le 28 octobre 2025**, premier vol supersonique le 5 juin 2026\n- Verrière et siège éjectable de **T-38**, train d''atterrissage de **F-16**',
  variants_en       = E'- **Single demonstrator**, centrepiece of NASA''s **Quesst** mission\n- **Slender nose** taking up nearly a third of the length, F414 engine mounted on top\n- **External Vision System** : forward view through a 4K camera, with no direct view\n- **First flight on 28 October 2025**, first supersonic flight on 5 June 2026\n- **T-38** canopy and ejection seat, **F-16** landing gear',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_Martin_X-59_QueSST',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_Martin_X-59_Quesst',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jim Ross, NASA',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed Martin X-59 QueSST';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed Martin X-59 QueSST';
