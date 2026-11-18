-- Hunting H.126
--
-- Photo : H-126 (Hunting) Jet Flap Aircraft- 40 x 80 ft (ARC-1969-AC-42409).jpg
--   licence Public domain — NASA Ames Research Center / Joe March
--   https://commons.wikimedia.org/wiki/File:H-126_(Hunting)_Jet_Flap_Aircraft-_40_x_80_ft_(ARC-1969-AC-42409).jpg

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
    'Hunting H.126',
    'Hunting H.126',
    'Hunting H.126',
    'Hunting H.126',
    'Banc d''essai du volet soufflé, qui décollait à 51 km/h en soufflant la moitié de son jet sur ses ailes',
    'A jet-flap testbed that took off at 51 km/h by blowing half its exhaust over its wings',
    '/assets/airplanes/hunting-h126.jpg',
    E'## Genèse\nÀ la fin des années 1940, le National Gas Turbine Establishment, le Royal Aircraft Establishment et plusieurs industriels britanniques s''intéressent au **volet soufflé**, que les Britanniques appellent « jet flap » : souffler les gaz d''un réacteur sur le bord de fuite promet des vitesses de décollage et d''atterrissage bien plus faibles. Le NGTE en fait breveter le principe en 1951. Pour le vérifier en vraie grandeur, le ministère de l''Aviation émet la spécification **ER.189D**, et **Hunting Aircraft**, rompue aux conduits de gaz chauds par ses recherches sur les hélicoptères, obtient en 1959 la commande de deux avions.\n\n## Conception\nLe **H.126** est un monoplace à aile haute haubanée, dont les haubans servent aussi de conduits d''air. Tout le jet de son unique **Bristol Siddeley Orpheus** est envoyé dans un collecteur vertical : environ la moitié ressort par seize buses réparties le long du bord de fuite, sur les volets et les ailerons, une autre part alimente des buses de contrôle en bout d''aile et dans la queue, et le reste sort par deux tuyères latérales. Il reste peu de poussée pour avancer, mais l''avion décolle à 51 km/h. Le pilote est installé au-dessus du moteur, sur un siège éjectable **Martin-Baker**, et l''arrière du fuselage est rempli d''instruments de mesure, notamment de températures.\n\n## Essais\nAchevé à l''été 1962 et roulé à Luton, l''avion est transporté par la route jusqu''au RAE de Bedford. Le XN714 y vole pour la première fois le 26 mars 1963, piloté par **S. B. Oliver**, qui le décrit comme un avion qui « flotte » au-dessus de la piste avant de monter « comme un ascenseur ». Le RAE l''emploie pour cent vols d''essais jusqu''en 1967 ; le second exemplaire, XN719, n''est jamais achevé. En 1969, le H.126 part aux États-Unis pour des essais dans la grande soufflerie de la **NASA** à Ames, puis revient en mai 1970 et est rayé des effectifs en septembre 1972.\n\n## Place dans l''histoire\nLe H.126 a fourni des données précieuses sur le volet soufflé, un concept alors mal connu, et a poursuivi sa carrière d''outil de recherche jusque dans la soufflerie d''Ames. Ses buses de contrôle en bout d''aile, destinées à garder la maîtrise du roulis à très basse vitesse, préfigurent un système comparable employé plus tard sur le **Harrier**. Remis au musée de la RAF en 1974, l''unique exemplaire est exposé à Cosford dans sa livrée jaune.',
    E'## Genesis\nIn the late 1940s the National Gas Turbine Establishment, the Royal Aircraft Establishment and several British manufacturers took an interest in the **jet flap**: blowing engine exhaust over the trailing edge promised far lower take-off and landing speeds. The NGTE patented the principle in 1951. To test it at full scale, the Ministry of Aviation issued Specification **ER.189D**, and **Hunting Aircraft**, experienced in hot-gas ducting from its helicopter research, won a contract for two aircraft in 1959.\n\n## Design\nThe **H.126** was a single-seater with a strut-braced shoulder wing, the struts doubling as air ducts. The whole exhaust of its single **Bristol Siddeley Orpheus** went into a vertical manifold: about half left through sixteen nozzles along the trailing edge, over the flaps and ailerons, another share fed control nozzles at the wingtips and in the tail, and the rest left through two side nozzles. Little thrust remained for forward flight, but the aircraft took off at 51 km/h. The pilot sat above the engine on a **Martin-Baker** ejection seat, and the rear fuselage was packed with test instrumentation, including extensive temperature monitoring.\n\n## Testing\nCompleted in summer 1962 and taxied at Luton, the aircraft was taken by road to RAE Bedford. XN714 first flew there on 26 March 1963, flown by **S. B. Oliver**, who described how it ''just floats off the ground'' and then goes up ''like a lift''. The RAE used it for a hundred test flights until 1967; the second aircraft, XN719, was never completed. In 1969 the H.126 went to the United States for tests in **NASA**''s large wind tunnel at Ames, returned in May 1970 and was struck off charge in September 1972.\n\n## Place in history\nThe H.126 provided valuable data on the jet flap, a little-known concept, and continued its research career as far as the Ames wind tunnel. Its wingtip control nozzles, meant to keep roll control at very low speed, foreshadowed a similar system later used on the **Harrier**. Handed to the RAF Museum in 1974, the sole example is displayed at Cosford in its yellow finish.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1959-01-01',
    '1963-03-26',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'HUN'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Hunting H.126'), (SELECT id FROM tech WHERE name = 'Volets soufflés par les réacteurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Hunting H.126'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.29,
  wingspan          = 13.82,
  height            = 4.72,
  wing_area         = 20.5,
  empty_weight      = 3738,
  mtow              = 4872,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley BOr.3 Orpheus Mk.805',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XN714** : seul exemplaire achevé, premier vol le 26 mars 1963, cent vols au RAE jusqu''en 1967, essais en soufflerie à la NASA en 1969, exposé à Cosford\n- **XN719** : second exemplaire commandé, abandonné en cours de construction puis ferraillé',
  variants_en       = E'- **XN714**: the only completed aircraft, first flight on 26 March 1963, a hundred RAE flights until 1967, NASA wind tunnel tests in 1969, displayed at Cosford\n- **XN719**: second aircraft ordered, abandoned during construction and scrapped',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Hunting_H.126',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Ames Research Center / Joe March',
  image_licence     = 'Public domain'
WHERE name = 'Hunting H.126';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Hunting H.126';
