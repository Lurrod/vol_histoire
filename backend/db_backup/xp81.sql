-- Consolidated Vultee XP-81
--
-- Photo : Convzir XP-81.jpg
--   licence Public domain — US Air Force
--   https://commons.wikimedia.org/wiki/File:Convzir_XP-81.jpg

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
    'Convair XP-81',
    'Convair XP-81',
    'Consolidated Vultee XP-81',
    'Consolidated Vultee XP-81',
    'Chasseur d''escorte à turbopropulseur et réacteur, premier avion américain à voler propulsé par un turbopropulseur',
    'Escort fighter combining a turboprop and a jet, the first American aircraft to fly on turboprop power',
    '/assets/airplanes/xp81.jpg',
    E'## Genèse\nLe 11 février 1944, l''**US Army Air Forces** commande à **Consolidated Vultee** deux prototypes d''un chasseur d''escorte monoplace à long rayon d''action, le **XP-81**. L''idée est d''associer deux moteurs que tout oppose : la vitesse du turboréacteur et l''endurance du moteur à hélice. Le turbopropulseur doit assurer le vol normal et la croisière, le réacteur s''y ajouter pour les pointes de vitesse. Treize avions de présérie YP-81 sont commandés à la suite des prototypes.\n\n## Conception\nLe XP-81 doit recevoir dans le nez un turbopropulseur **General Electric TG-100**, futur XT31, entraînant une hélice quadripale de 3,7 m, et dans le fuselage arrière un turboréacteur **General Electric J33**. Les YP-81 devaient être pour l''essentiel identiques, avec un turbopropulseur TG-110 plus léger et plus puissant, une aile reculée de 25 cm et un armement de six mitrailleuses de 12,7 mm ou six canons de 20 mm. Les performances annoncées, 816 km/h en altitude et 4 000 km de distance franchissable, supposaient un TG-100 développant toute sa puissance.\n\n## Essais\nLe premier XP-81 est achevé en janvier 1945, mais son turbopropulseur n''est pas prêt : on monte à sa place, en une semaine, le Merlin V-1650-7 complet d''un **P-51D Mustang**. Ainsi équipé, l''avion vole le 11 février 1945 à Muroc et montre de bonnes qualités de vol, hormis une stabilité de route insuffisante, corrigée par une dérive agrandie. Le TG-100 enfin installé, il réalise le 21 décembre 1945 le premier vol d''un avion américain propulsé par turbopropulseur. Mais le moteur ne délivre que 1 490 ch, autant que le Merlin, et les performances n''en sont pas meilleures.\n\n## Place dans l''histoire\nLa prise de Guam et de Saipan a ôté sa raison d''être au chasseur d''escorte rapide à long rayon d''action : juste avant la victoire sur le Japon, la commande des YP-81 est annulée alors que 85 % de l''ingénierie est achevée. Les deux prototypes, rebaptisés plus tard ZXF-81, poursuivent leurs essais jusqu''en 1947, puis finissent comme cibles photographiques sur un champ de tir de bombardement. Tous deux sont aujourd''hui stockés au musée de l''US Air Force, près de Dayton. Faute d''un moteur au point, le XP-81 reste surtout le premier turbopropulseur américain à avoir volé.',
    E'## Genesis\nOn 11 February 1944 the **US Army Air Forces** ordered from **Consolidated Vultee** two prototypes of a single-seat, long-range escort fighter, the **XP-81**. The idea was to pair two engines with nothing in common: the speed of the jet and the endurance of the propeller engine. The turboprop would handle normal flight and cruise, with the jet added for high-speed dashes. Thirteen YP-81 pre-production aircraft were ordered after the prototypes.\n\n## Design\nThe XP-81 was designed around a **General Electric TG-100** turboprop, later the XT31, in the nose driving a 3.7 m four-bladed propeller, and a **General Electric J33** turbojet in the rear fuselage. The YP-81s were to be essentially the same, with a lighter and more powerful TG-110 turboprop, the wing moved 25 cm aft and an armament of six 12.7 mm machine guns or six 20 mm cannon. The quoted performance, 816 km/h at altitude and a 4,000 km range, assumed a TG-100 delivering its full power.\n\n## Testing\nThe first XP-81 was completed in January 1945, but its turboprop was not ready: in its place, within a week, the complete V-1650-7 Merlin installation of a **P-51D Mustang** was fitted. So equipped, the aircraft flew from Muroc on 11 February 1945 and showed good handling, apart from inadequate directional stability, cured by an enlarged fin. With the TG-100 finally installed, on 21 December 1945 it made the first flight by an American turboprop-powered aircraft. But the engine produced only 1,490 hp, the same as the Merlin, and performance was no better.\n\n## Place in history\nThe capture of Guam and Saipan had removed the need for a fast long-range escort fighter: just before VJ Day the YP-81 contract was cancelled, with 85% of the engineering completed. The two prototypes, later redesignated ZXF-81, continued testing until 1947, then ended up as photographic targets on a bombing range. Both are now in storage at the National Museum of the US Air Force near Dayton. Lacking a mature engine, the XP-81 is remembered above all as the first American turboprop aircraft to fly.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-02-11',
    '1945-02-11',
    NULL,
    816,
    4000,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XP-81'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XP-81'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'Convair XP-81'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.61,
  wingspan          = 15.39,
  height            = 4.11,
  wing_area         = 39.5,
  empty_weight      = 5887,
  mtow              = 11181,
  service_ceiling   = 14326,
  climb_rate        = 27,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric TG-100 / XT31 (2 300 ch) + General Electric J33-GE-5 (16,7 kN)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur et turboréacteur',
  engine_type_en    = 'Turboprop and turbojet',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XP-81 à moteur Merlin** : premier prototype doté provisoirement du Merlin V-1650-7 d''un P-51D, premier vol le 11 février 1945\n- **XP-81 à turbopropulseur** : même cellule avec le TG-100, premier vol d''un turbopropulseur américain le 21 décembre 1945\n- **YP-81** : treize avions de présérie commandés, turbopropulseur TG-110 (XT41), aile reculée et armement de six armes de bord ; commande annulée en 1945\n- **ZXF-81** : désignation ultérieure des deux prototypes',
  variants_en       = E'- **Merlin-powered XP-81**: first prototype temporarily fitted with the V-1650-7 Merlin of a P-51D, first flight on 11 February 1945\n- **Turboprop XP-81**: same airframe with the TG-100, first flight of an American turboprop on 21 December 1945\n- **YP-81**: thirteen pre-production aircraft ordered, TG-110 (XT41) turboprop, wing moved aft and six-gun armament; order cancelled in 1945\n- **ZXF-81**: later designation of the two prototypes',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Consolidated_Vultee_XP-81',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Consolidated_Vultee_XP-81',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Convair XP-81';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair XP-81';
