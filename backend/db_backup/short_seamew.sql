-- Short SB.6 Seamew
--
-- Photo : Short Seamew landing on HMS Bulwark (R08) 1955.jpg
--   licence Public domain — Royal Navy official photographer
--   https://commons.wikimedia.org/wiki/File:Short_Seamew_landing_on_HMS_Bulwark_(R08)_1955.jpg

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
    'Short Seamew',
    'Short Seamew',
    'Short SB.6 Seamew',
    'Short SB.6 Seamew',
    'Avion anti-sous-marin léger et rustique de la Fleet Air Arm, emporté par le Livre blanc de 1957',
    'A light, austere Fleet Air Arm anti-submarine aircraft, swept away by the 1957 Defence White Paper',
    '/assets/airplanes/short-seamew.jpg',
    E'## Genèse\nAu début des années 1950, la montée en puissance de la flotte sous-marine soviétique inquiète l''Amirauté. La spécification M.123D demande un avion anti-sous-marin simple et léger, capable d''opérer sans assistance depuis n''importe quel porte-avions britannique, y compris les porte-avions d''escorte encore nombreux, assez simple pour être produit en masse et confié aux réservistes de la **Royal Naval Volunteer Reserve**. Dessiné en 1951 par **David Keith-Lucas** chez **Short Brothers**, le SB.6 Seamew doit remplacer leurs Grumman Avenger. Trois prototypes sont commandés en avril 1952 et le premier vole le 23 août 1953.\n\n## Conception\nPilote et observateur sont juchés en tandem tout à l''avant d''un fuselage haut et étroit, au-dessus d''un turbopropulseur **Armstrong Siddeley Mamba** de 1 590 ch : la marine voulait se passer de l''essence aviation, trop inflammable à bord. Sous le moteur tourne l''antenne du radar ; derrière, une soute de 4,3 m reçoit torpille, grenades ou bombes anti-sous-marines, et l''avion emporte aussi des bouées acoustiques. Un train fixe à roulette de queue et à très grand débattement donne à l''appareil une assiette inquiétante au sol. Pour la RAF, une version MR.2 doit opérer depuis des terrains sommaires.\n\n## Essais\nLe pilotage est le point faible : malgré becs, fentes et retouches multiples, il n''est jamais pleinement satisfaisant, et seul le pilote d''essai **Wally Runciman** semble en maîtriser les vices. Commandé à 60 exemplaires en février 1955, partagés entre marine et RAF, le Seamew réussit ses essais d''appontage sur HMS Bulwark en juillet et décembre 1955. Runciman le présente en Italie, en Yougoslavie et en Allemagne de l''Ouest en 1956, avant de se tuer à son bord le 9 juin 1956 en tentant une boucle au meeting de Sydenham, à Belfast.\n\n## Place dans l''histoire\nLa RAF se désintéresse vite du programme. Le **Livre blanc de la défense de 1957** dissout les escadrilles de réserve de la marine en mars 1957, avant qu''aucun Seamew ne leur soit attribué. Sur 26 avions construits, sept livrés à la Fleet Air Arm sont ferraillés à Lossiemouth et onze autres, achevés, à Sydenham ; le dernier, racheté par Shorts pour son école d''apprentis, disparaît en 1967. Décrit comme « un chameau parmi des chevaux de course », il figure en bonne place dans les ouvrages consacrés aux pires avions de l''histoire.',
    E'## Genesis\nIn the early 1950s the growing strength of the Soviet submarine fleet alarmed the Admiralty. Specification M.123D called for a simple, lightweight anti-submarine aircraft able to operate unassisted from any British carrier, including the escort carriers still available in numbers, simple enough to be mass-produced and flown by reservists of the **Royal Naval Volunteer Reserve**. Designed in 1951 by **David Keith-Lucas** at **Short Brothers**, the SB.6 Seamew was to replace their Grumman Avengers. Three prototypes were ordered in April 1952 and the first flew on 23 August 1953.\n\n## Design\nPilot and observer sat in tandem, perched at the very front of a deep, narrow fuselage, above an **Armstrong Siddeley Mamba** turboprop of 1,590 shp: the Navy wanted to stop carrying highly flammable aviation petrol. The radar scanner sat below the engine; behind it, a 4.3 m weapons bay took a torpedo, depth charges or anti-submarine bombs, and the aircraft also carried sonobuoys. A fixed, long-stroke tailwheel undercarriage gave it an alarming attitude on the ground. For the RAF, an MR.2 version was to operate from hastily prepared airstrips.\n\n## Testing\nHandling was its weak point: despite slats, slots and repeated modifications it was never wholly satisfactory, and only test pilot **Wally Runciman** seemed able to outwit its vicious tendencies. Ordered in 60 examples in February 1955, split between the Navy and the RAF, the Seamew completed carrier trials on HMS Bulwark in July and December 1955. Runciman took it on sales tours to Italy, Yugoslavia and West Germany in 1956, before being killed in it on 9 June 1956 while attempting a loop at the Sydenham air display in Belfast.\n\n## Place in history\nThe RAF soon lost interest. The **1957 Defence White Paper** disbanded the Navy''s reserve squadrons in March 1957, before any Seamews had been allocated to them. Of 26 aircraft built, seven delivered to the Fleet Air Arm were scrapped at Lossiemouth and eleven more, complete, at Sydenham; the last, bought back by Shorts for its apprentice school, was scrapped in 1967. Described as "a camel among racehorses", it features prominently in books devoted to the world''s worst aircraft.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1951-01-01',
    '1953-08-23',
    NULL,
    380,
    1210,
    (SELECT id FROM manufacturer WHERE code = 'SHO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Short Seamew'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Short Seamew'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Short Seamew'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.5,
  wingspan          = 16.76,
  height            = 4.09,
  wing_area         = 51.0,
  empty_weight      = 4443,
  mtow              = 6804,
  service_ceiling   = NULL,
  climb_rate        = 8.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Armstrong Siddeley Mamba (1 590 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 26,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **SB.6 Seamew** : trois prototypes, dont un achevé comme banc d''essai structural\n- **Seamew AS.1** : version anti-sous-marine de la Fleet Air Arm, commande ramenée de 60 à 30 avions, 24 achevés\n- **Seamew MR.2** : version de patrouille de la RAF pour terrains sommaires, pneus basse pression et repliage manuel des ailes, quatre construits puis convertis au standard AS.1',
  variants_en       = E'- **SB.6 Seamew**: three prototypes, one completed as a structural test rig\n- **Seamew AS.1**: Fleet Air Arm anti-submarine version, order cut from 60 to 30 aircraft, 24 completed\n- **Seamew MR.2**: RAF patrol version for rough airstrips, low-pressure tyres and manual wing folding, four built and later converted to AS.1 standard',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Short_Seamew',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Short_Seamew',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Royal Navy',
  image_licence     = 'Public domain'
WHERE name = 'Short Seamew';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Short Seamew';
