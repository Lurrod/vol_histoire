-- Northrop HL-10
--
-- Photo : The HL-10 Lifting Body is seen here in flight over Rogers Dry lakebed (E-21089).jpg
--   licence Public domain — NASA Armstrong Flight Research Center / NASA
--   https://commons.wikimedia.org/wiki/File:The_HL-10_Lifting_Body_is_seen_here_in_flight_over_Rogers_Dry_lakebed_(E-21089).jpg

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
    'Northrop HL-10',
    'Northrop HL-10',
    'Northrop HL-10',
    'Northrop HL-10',
    'Corps portant de la NASA à profil inversé, le plus rapide et le plus haut du programme, à Mach 1,86 et 27 440 m',
    'NASA lifting body with an inverted aerofoil, fastest and highest of the programme at Mach 1.86 and 27,440 m',
    '/assets/airplanes/northrop-hl10.jpg',
    E'## Genèse\nCommandé à **Northrop** en même temps que le **M2-F2**, pour 1,8 million de dollars les deux, le HL-10 est un dessin de la **NASA** : « HL » pour « horizontal landing », « 10 » pour la dixième forme étudiée au centre de **Langley**. Son profil à cambrure négative, une sorte d''aile inversée sur un plan en delta, s''impose en 1962 après de longs débats internes : il remplit neuf des dix objectifs fixés, contre cinq pour un profil symétrique. Il doit valider la manœuvre et l''atterrissage sûrs d''un engin de faible finesse conçu pour revenir de l''espace.\n\n## Conception\nLe HL-10 a le ventre plat et des élevons au bord de fuite, qui braquent ensemble pour le tangage et en sens contraire pour le roulis. Pour réduire les coûts, il emprunte le train principal d''un **T-38**, la roulette de nez d''un **T-39** et le système d''éjection d''un **F-106** ; relevé à la main au sol, le train est descendu en vol par de l''azote sous pression. Le moteur-fusée **Reaction Motors XLR11** à quatre chambres, le même que celui du **Bell X-1**, fournit 35,7 kN, et quatre petites fusées à peroxyde d''hydrogène aident à l''arrondi.\n\n## Essais\n**Bruce Peterson** fait le premier vol le 22 décembre 1966. Posé à 518 km/h au bout de 189 secondes, l''engin vibre et se pilote mal : il reste au sol quinze mois, le temps de recourber vers l''extérieur le bord d''attaque de ses surfaces latérales. Les onze premiers largages du **B-52** sont des vols planés, puis le moteur entre en jeu : largué vers 13 700 m, le HL-10 brûle une centaine de secondes de carburant avant de revenir planer vers le lac asséché de **Rogers**. Le 18 février 1970, le pilote de l''US Air Force **Peter Hoag** l''emmène à Mach 1,86, soit 1 976 km/h ; neuf jours plus tard, **Bill Dana** atteint 27 440 m. Le 37e et dernier vol a lieu le 17 juillet 1970.\n\n## Place dans l''histoire\nJugé le plus agréable à piloter des trois premiers corps portants lourds, le HL-10 détient les records de vitesse et d''altitude du programme. Au début de la conception de la **navette spatiale**, des projets reprenant sa forme figurent parmi les trois grandes familles de propositions, avant d''être écartés : on logeait mal des réservoirs cylindriques dans un fuselage tout en courbes. L''ingénieur **Dale Reed** proposa même de l''envoyer en orbite avec du matériel **Apollo** resté sans emploi, idée restée sans suite. Il est exposé à l''entrée du centre de recherche Armstrong, à Edwards.',
    E'## Genesis\nOrdered from **Northrop** together with the **M2-F2**, for $1.8 million for the pair, the HL-10 was a **NASA** design: ''HL'' for horizontal landing, ''10'' for the tenth shape studied at the **Langley** centre. Its negatively cambered profile, a kind of inverted aerofoil on a delta planform, won out in 1962 after long internal debate: it met nine of the ten stated objectives, against five for a symmetrical profile. Its task was to validate the safe manoeuvring and landing of a low lift-to-drag craft designed to return from space.\n\n## Design\nThe HL-10 had a flat bottom and trailing-edge elevons, moving together for pitch and differentially for roll. To cut costs it borrowed the main gear of a **T-38**, the nose gear of a **T-39** and the ejection system of an **F-106**; retracted by hand on the ground, the gear was lowered in flight by pressurised nitrogen. The four-chamber **Reaction Motors XLR11** rocket engine, the type used in the **Bell X-1**, gave 35.7 kN, and four small hydrogen peroxide rockets assisted the landing flare.\n\n## Testing\n**Bruce Peterson** made the first flight on 22 December 1966. Landing at 518 km/h after 189 seconds, the craft vibrated and handled poorly: it stayed grounded for fifteen months while the leading edges of its outboard surfaces were curved outwards. The first eleven drops from the **B-52** were glide flights, then the engine came into play: released at about 13,700 m, the HL-10 burned some hundred seconds of fuel before gliding back to **Rogers** Dry Lake. On 18 February 1970 US Air Force pilot **Peter Hoag** took it to Mach 1.86, or 1,976 km/h; nine days later **Bill Dana** reached 27,440 m. The 37th and last flight took place on 17 July 1970.\n\n## Place in history\nJudged the best handling of the three original heavyweight lifting bodies, the HL-10 holds the programme''s speed and altitude records. Early in **Space Shuttle** development, designs patterned on its shape were one of the three main families of proposals, before being dropped: cylindrical tanks fitted badly into a fuselage made of curves. Engineer **Dale Reed** even proposed sending it into orbit with surplus **Apollo** hardware, an idea that came to nothing. It is displayed at the entrance to the Armstrong Flight Research Center at Edwards.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1964-06-01',
    '1966-12-22',
    NULL,
    1976,
    72,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop HL-10'), (SELECT id FROM tech WHERE name = 'Corps portant')),
((SELECT id FROM airplanes WHERE name = 'Northrop HL-10'), (SELECT id FROM tech WHERE name = 'Moteur-fusée'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop HL-10'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.45,
  wingspan          = 4.15,
  height            = 2.92,
  wing_area         = 14.9,
  empty_weight      = 2397,
  mtow              = 4540,
  service_ceiling   = 27440,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Reaction Motors XLR11',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 35.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **HL-10 (NASA 804)** : exemplaire unique, 37 vols de décembre 1966 à juillet 1970\n- **Configuration initiale** : un seul vol, vibrations et pilotage délicat, posé à 518 km/h\n- **Configuration modifiée** : bords d''attaque des surfaces latérales recourbés vers l''extérieur après quinze mois au sol\n- **Version orbitale** : projet de Dale Reed, avec bouclier ablatif et contrôle par réaction, lancé avec du matériel Apollo ; sans suite',
  variants_en       = E'- **HL-10 (NASA 804)**: sole example, 37 flights from December 1966 to July 1970\n- **Initial configuration**: a single flight, vibration and tricky handling, landed at 518 km/h\n- **Modified configuration**: leading edges of the outboard surfaces curved outwards after fifteen months on the ground\n- **Orbital version**: Dale Reed''s proposal, with an ablative heat shield and reaction controls, launched with Apollo hardware; not pursued',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_HL-10',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_HL-10',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Armstrong Flight Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Northrop HL-10';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Northrop HL-10';
