-- Lockheed YO-3A Quiet Star
--
-- Photo : Lockheed YO-3.jpg
--   licence Public domain — Lieutenant General John H. Hay, Jr. DEPARTMENT OF THE ARMY.
--   https://commons.wikimedia.org/wiki/File:Lockheed_YO-3.jpg

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
    'Lockheed YO-3 Quiet Star',
    'Lockheed YO-3 Quiet Star',
    'Lockheed YO-3A Quiet Star',
    'Lockheed YO-3A Quiet Star',
    'Un planeur motorisé si silencieux qu''il survolait de nuit les troupes vietnamiennes sans être entendu',
    'A powered glider so quiet it could fly over enemy troops in Vietnam at night without being heard',
    '/assets/airplanes/yo3-quiet-star.jpg',
    E'## Genèse\nAu Vietnam, l''ennemi se déplace la nuit, et le bruit de n''importe quel avion d''observation l''avertit bien avant son passage. En 1968, l''US Army demande un appareil impossible à entendre depuis le sol lorsqu''il vole de nuit à 457 m. **Lockheed Missiles and Space Company**, à Sunnyvale, avait déjà transformé deux planeurs biplaces **Schweizer SGS 2-32** en **QT-2 Quiet Thruster**, puis en **QT-2PC Prize Crew** dotés d''un moteur étouffé et d''une hélice lente. Après leur évaluation au combat au Vietnam, l''Army commande un appareil de série, le **YO-3A**.\n\n## Conception\nLe YO-3A garde l''ADN du planeur : grande envergure de 17 m, vaste verrière pour l''observation, pilote et observateur en tandem, l''observateur à l''avant. La cellule est métallique, mais capotage, verrière et carénages sont en fibre de verre et les gouvernes entoilées ; le train à roulette de queue est escamotable. Le moteur **Continental IO-360D** de 210 ch entraîne l''hélice par courroie, démultipliée 3,33 fois : d''abord à six pales, elle est remplacée en mars 1971 par une tripale en bois lamellé dessinée par **Ole Fahlin**. Le capot est doublé de fibre de verre, et l''échappement, regroupé à droite, traverse un silencieux jusqu''à l''arrière du fuselage.\n\n## Carrière opérationnelle\nNeuf des onze YO-3A construits opèrent au Sud-Vietnam, de nuit, de fin juin 1970 à septembre 1971, depuis Long Thanh Nord, Phu Bai et Binh Thuy. L''observation se fait d''abord à l''œil, puis avec un périscope de vision nocturne à illuminateur infrarouge ; un appareil reçoit un désignateur laser jamais utilisé. Ils volent vers 300 m, parfois à 60 m sans être repérés. Avant chaque mission, les mécaniciens écoutent l''avion passer au-dessus de l''atelier : au moindre sifflement, retour au sol et ruban adhésif. Trois sont détruits par accident, aucun par le feu ennemi.\n\n## Place dans l''histoire\nLe Quiet Star est l''un des premiers avions conçus pour la discrétion, non face aux radars mais face à l''oreille humaine. Après la guerre, deux exemplaires traquent les braconniers pour la Louisiane, puis servent au **FBI** contre des ravisseurs. La **NASA** en récupère un en 1977 : muni de microphones, il enregistre en vol la signature acoustique d''hélicoptères, de convertibles et les bangs du **SR-71**, avant d''être cédé à un musée en 2015.',
    E'## Genesis\nIn Vietnam the enemy moved at night, and the noise of any observation aircraft warned him long before it arrived. In 1968 the US Army called for an aircraft that could not be heard from the ground when flying at night at 457 m. **Lockheed Missiles and Space Company** in Sunnyvale had already turned two **Schweizer SGS 2-32** two-seat gliders into the **QT-2 Quiet Thruster**, then into the **QT-2PC Prize Crew** with a silenced engine and a slow-turning propeller. After their combat evaluation in Vietnam, the Army ordered a production aircraft, the **YO-3A**.\n\n## Design\nThe YO-3A kept the glider''s DNA: a long 17 m span, a large canopy for observation, pilot and observer in tandem with the observer in front. The airframe was metal, but the cowling, canopy and fairings were fibreglass and the control surfaces fabric-covered; the tailwheel undercarriage retracted. The 210 hp **Continental IO-360D** engine drove the propeller through a belt, reduced 3.33 times: first six-bladed, it was replaced in March 1971 by a laminated wooden three-blader designed by **Ole Fahlin**. The cowling was lined with fibreglass, and the exhaust, gathered on the right, ran through a muffler to the rear of the fuselage.\n\n## Operational career\nNine of the eleven YO-3As built operated over South Vietnam, at night, from late June 1970 to September 1971, from Long Thanh North, Phu Bai and Binh Thuy. Observation was at first by eye, then through a night vision periscope with an infrared illuminator; one aircraft received a laser designator that was never used. They flew at around 300 m, sometimes at 60 m without being noticed. Before each sortie, crew chiefs listened to the aircraft passing over the maintenance area: at the slightest whistle, it landed for a dose of duct tape. Three were destroyed in crashes, none by enemy fire.\n\n## Place in history\nThe Quiet Star was one of the first aircraft designed for stealth, not against radar but against the human ear. After the war two of them hunted poachers for Louisiana, then served the **FBI** against kidnappers. **NASA** acquired one in 1977: fitted with microphones, it recorded in flight the acoustic signatures of helicopters, tiltrotors and the sonic booms of the **SR-71**, before being sold to a museum in 2015.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1968-01-01',
    '1969-01-01',
    '1970-06-01',
    166,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'LOC'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed YO-3 Quiet Star'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed YO-3 Quiet Star'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.94,
  wingspan          = 17.37,
  height            = NULL,
  wing_area         = 19.8,
  empty_weight      = NULL,
  mtow              = 1724,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Continental IO-360D (210 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1969,
  production_end    = 1970,
  units_built       = 11,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **QT-2** : deux planeurs Schweizer X-26 biplaces motorisés pour l''évaluation\n- **QT-2PC Prize Crew** : les deux QT-2 équipés de capteurs, évalués au combat au Vietnam\n- **Q-Star** : SGS 2-32 modifié pour la mise au point du moteur et de l''hélice\n- **YO-3A** : version de série pour l''US Army, onze construits, neuf engagés au Vietnam',
  variants_en       = E'- **QT-2**: two powered Schweizer X-26 two-seat sailplanes for evaluation\n- **QT-2PC Prize Crew**: the two QT-2s fitted with sensors, combat-evaluated in Vietnam\n- **Q-Star**: modified SGS 2-32 for engine and propeller development\n- **YO-3A**: production version for the US Army, eleven built, nine deployed to Vietnam',

  -- Strate 4 : qualitatif
  nickname          = 'Quiet Star',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_YO-3A_Quiet_Star',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_YO-3_Quiet_Star',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Lt. Gen. John H. Hay Jr., U.S. Army',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed YO-3 Quiet Star';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed YO-3 Quiet Star';
