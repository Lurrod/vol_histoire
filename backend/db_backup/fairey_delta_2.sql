-- Fairey Delta 2 (FD.2)
--
-- Photo : Fairey Delta FD2 (50093386941).jpg
--   licence CC BY-SA 2.0 — Hugh Llewelyn from Keynsham, UK
--   https://commons.wikimedia.org/wiki/File%3AFairey_Delta_FD2_%2850093386941%29.jpg

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
    'Fairey Delta 2',
    'Fairey Delta 2',
    'Fairey Delta 2 (FD.2)',
    'Fairey Delta 2 (FD.2)',
    'Premier avion à dépasser 1 600 km/h, dont la Grande-Bretagne n’a rien fait',
    'First aircraft past 1,600 km/h, and Britain did nothing with it',
    '/assets/airplanes/fairey-delta-2.jpg',
    E'## Genèse\nLe ministère de l''Air britannique commande en 1947 un appareil de recherche pure : mesurer le comportement d''une **aile delta mince** au-delà du mur du son. Fairey, constructeur naval sans expérience du supersonique, obtient le marché. Deux exemplaires sont construits, sans armement ni vocation opérationnelle — c''est un instrument de mesure volant.\n\n## Conception\nDelta pur à faible épaisseur, fuselage effilé et un seul Avon à postcombustion. Le pilote, assis très en avant, ne voit rien au décollage et à l''atterrissage à cause de l''assiette cabrée : Fairey invente donc le **nez basculant**, qui s''incline de dix degrés pour dégager la vue. Le dispositif sera repris tel quel sur le Concorde, puis sur le Tu-144 et le Soukhoï T-4.\n\n## Carrière opérationnelle\nAucune, mais un exploit. Le **10 mars 1956**, Peter Twiss porte le record du monde de vitesse à 1 822 km/h — il pulvérise le précédent, détenu par un **F-100 Super Sabre**, de plus de cinq cents kilomètres-heure, marge sans équivalent dans l''histoire du record. La Grande-Bretagne est la première nation à dépasser mille miles par heure.\n\n## Place dans l''histoire\nDeux exemplaires, et une occasion manquée devenue proverbiale : Londres ne donne aucune suite. Fairey propose un chasseur dérivé, il est refusé. Les ingénieurs de **Dassault**, eux, étudient de près la cellule — le **Mirage III**, qui vole deux ans plus tard, en reprend la formule et devient l''un des plus grands succès à l''exportation de l''histoire. Le WG774 finira reconstruit en banc d''essai pour l''aile de Concorde.',
    E'## Genesis\nIn 1947 the British Air Ministry ordered a pure research aircraft: to measure the behaviour of a **thin delta wing** beyond the sound barrier. Fairey, a naval manufacturer with no supersonic experience, won the contract. Two aircraft were built, unarmed and with no operational purpose — a flying measuring instrument.\n\n## Design\nA pure thin delta, a slender fuselage and a single afterburning Avon. The pilot, seated well forward, could see nothing on take-off and landing because of the nose-high attitude: Fairey therefore invented the **drooping nose**, tilting ten degrees to clear the view. The device was carried over unchanged to Concorde, then to the Tu-144 and the Sukhoi T-4.\n\n## Operational career\nNone, but one feat. On **10 March 1956** Peter Twiss raised the world speed record to 1,822 km/h — beating the previous mark, held by an **F-100 Super Sabre**, by more than five hundred kilometres per hour, a margin without equal in the history of the record. Britain was the first nation past a thousand miles an hour.\n\n## Place in history\nTwo aircraft, and a missed opportunity that became proverbial: London did nothing with it. Fairey proposed a derived fighter and was refused. **Dassault**''s engineers, on the other hand, studied the airframe closely — the **Mirage III**, flying two years later, took up its formula and became one of the greatest export successes in history. WG774 ended up rebuilt as a testbed for Concorde''s wing.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1947-01-01',
    '1954-10-06',
    NULL,
    1822.0,
    1336.0,
    (SELECT id FROM manufacturer WHERE code = 'FAI'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Delta 2'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Fairey Delta 2'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairey Delta 2'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.74,
  wingspan          = 8.18,
  height            = 3.35,
  wing_area         = 33.44,
  empty_weight      = 4990,
  mtow              = 6300,
  service_ceiling   = 15240,
  climb_rate        = 51.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon RA.28',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 44.5,
  thrust_wet        = 57.8,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1956,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **WG774** : premier exemplaire, auteur du record du monde de vitesse en 1956\n- **WG777** : second exemplaire, essais aérodynamiques, conservé à Cosford\n- **BAC 221** : WG774 reconstruit avec une aile ogivale pour préparer **Concorde**\n- Nez **basculant de 10°** à l''atterrissage, dispositif repris sur Concorde\n- Le record du **10 mars 1956** — 1 822 km/h — bat le précédent de plus de 500 km/h',
  variants_en       = E'- **WG774** : first aircraft, holder of the world speed record in 1956\n- **WG777** : second aircraft, aerodynamic trials, preserved at Cosford\n- **BAC 221** : WG774 rebuilt with an ogee wing to prepare **Concorde**\n- **Nose drooping 10°** on landing, a device carried over to Concorde\n- The record of **10 March 1956** — 1,822 km/h — beat the previous one by over 500 km/h',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairey_Delta_2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairey_Delta_2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Hugh Llewelyn from Keynsham, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Fairey Delta 2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fairey Delta 2';
