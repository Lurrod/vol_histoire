-- Handley Page HP.115
--
-- Photo : Handley page 115.jpg
--   licence CC BY-SA 3.0 — Terryjoyce
--   https://commons.wikimedia.org/wiki/File:Handley_page_115.jpg

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
    'Handley Page HP.115',
    'Handley Page HP.115',
    'Handley Page HP.115',
    'Handley Page HP.115',
    'Delta élancé à 75° de flèche qui a prouvé à basse vitesse la voilure du futur Concorde',
    'A slender 75-degree delta that proved the future Concorde''s wing at low speed',
    '/assets/airplanes/hp115.jpg',
    E'## Genèse\nDans les années 1950, les études britanniques d''avion de ligne supersonique butent sur un dilemme : une aile courte, efficace à grande vitesse, ne porte presque rien à basse vitesse. Vers 1955, **Johanna Weber** et **Dietrich Küchemann**, au Royal Aircraft Establishment, constatent qu''une aile delta très élancée, à plus de 65° de flèche, engendre aux grands angles d''attaque des tourbillons qui accroissent fortement la portance. Dès 1956, le Supersonic Transport Committee juge indispensable un banc d''essai à basse vitesse. Un planeur, le **Slingsby T.48**, est d''abord lancé, mais une version motorisée promet beaucoup plus d''heures de vol pour un coût horaire bien moindre : une nouvelle spécification est émise en décembre 1959 et **Handley Page** construit le **HP.115** à Cricklewood.\n\n## Conception\nL''aile delta, de très faible allongement, est en flèche de 75° et porte des élevons au bord de fuite ; son profil biconvexe est représentatif d''un futur avion supersonique, et son bord d''attaque en contreplaqué devait pouvoir être remplacé par d''autres cambrures. Le fuselage, une simple poutre rectangulaire en alliage d''aluminium, porte le cockpit dans une nacelle avant, avec un siège éjectable **Martin-Baker**. Le train fixe vient du **Jet Provost**, et un unique turboréacteur **Bristol Siddeley Viper** est perché au-dessus de l''aile, au pied de la dérive, dont le sommet abrite une caméra filmant les fumées de visualisation des écoulements.\n\n## Essais\nLe HP.115 XP841 vole pour la première fois le 17 août 1961 au RAE de Bedford, piloté par **J. M. Henderson**, et se présente au salon de la SBAC un mois plus tard. Ses pilotes y enchaînent de brusques changements d''inclinaison tout en gardant le contrôle jusqu''à 111 km/h. **Neil Armstrong**, prévu en 1962 mais retenu par la NASA après sa sélection comme astronaute, le pilote finalement le 22 juin 1970. Le programme, marqué par deux incidents mineurs, se poursuit jusqu''au dernier vol du 1er février 1974, après quelque 500 heures de vol, la limite prévue.\n\n## Place dans l''histoire\nPendant que le **BAC 221**, un Fairey Delta 2 modifié, explorait les grandes vitesses, le HP.115 a fourni des données essentielles sur le décollage et l''atterrissage d''un delta élancé. Il a ainsi validé la voilure retenue pour le **Concorde**, entré en service en 1976. Conservé à Colerne, puis à Cosford, il est aujourd''hui exposé au Fleet Air Arm Museum de Yeovilton, aux côtés du BAC 221 et d''un prototype du Concorde.',
    E'## Genesis\nIn the 1950s, British supersonic airliner studies ran into a dilemma: a short-span wing, efficient at high speed, gives very little lift at low speed. Around 1955 **Johanna Weber** and **Dietrich Küchemann**, at the Royal Aircraft Establishment, noticed that a very slender delta, swept beyond 65 degrees, generated vortices at high angles of attack that greatly increased lift. In 1956 the Supersonic Transport Committee decided that a low-speed testbed was essential. A glider, the **Slingsby T.48**, was started first, but a powered aircraft promised far more flying time at much lower cost per hour: a new specification followed in December 1959, and **Handley Page** built the **HP.115** at Cricklewood.\n\n## Design\nThe very low aspect ratio delta wing was swept at 75 degrees, with trailing-edge elevons; its bi-convex section was representative of a supersonic transport, and its plywood leading edge was meant to be swappable for other cambers. The fuselage, a plain rectangular aluminium girder, carried the cockpit in a nose nacelle with a **Martin-Baker** ejection seat. The fixed undercarriage came from the **Jet Provost**, and a single **Bristol Siddeley Viper** turbojet sat above the wing at the base of the fin, whose tip housed a cine-camera filming smoke flow-visualisation tests.\n\n## Testing\nHP.115 XP841 first flew on 17 August 1961 at RAE Bedford, flown by **J. M. Henderson**, and appeared at the SBAC show a month later. Its pilots made rapid changes of bank while keeping control at speeds as low as 111 km/h. **Neil Armstrong**, scheduled to fly it in 1962 but kept back by NASA after his selection as an astronaut, finally flew it on 22 June 1970. Despite two minor mishaps, the programme ran until a last flight on 1 February 1974, after some 500 flight hours, the design limit.\n\n## Place in history\nWhile the **BAC 221**, a modified Fairey Delta 2, explored high speeds, the HP.115 supplied essential data on the take-off and landing of a slender delta. It thus validated the wing adopted for **Concorde**, which entered service in 1976. Kept at Colerne, then Cosford, it is now displayed at the Fleet Air Arm Museum at Yeovilton, alongside the BAC 221 and a Concorde prototype.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1959-12-01',
    '1961-08-17',
    NULL,
    399,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'HP'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page HP.115'), (SELECT id FROM tech WHERE name = 'Aile delta'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page HP.115'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.34,
  wingspan          = 6.25,
  height            = 3.89,
  wing_area         = 40.1,
  empty_weight      = 1669,
  mtow              = 2291,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley Viper BSV.9',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 8.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Slingsby T.48** : planeur d''essais à basse vitesse étudié d''abord, abandonné au profit d''un avion motorisé\n- **HP.115 (XP841)** : seul exemplaire, premier vol le 17 août 1961, dernier vol le 1er février 1974, exposé à Yeovilton\n- **Maquettes radiocommandées** : plusieurs modèles réduits du HP.115 ont accompagné les essais en vol',
  variants_en       = E'- **Slingsby T.48**: low-speed research glider studied first, dropped in favour of a powered aircraft\n- **HP.115 (XP841)**: sole example, first flight on 17 August 1961, last flight on 1 February 1974, displayed at Yeovilton\n- **Radio-controlled models**: several scale models of the HP.115 supported the flight test programme',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Handley_Page_HP.115',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Philip Salt',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Handley Page HP.115';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Handley Page HP.115';
