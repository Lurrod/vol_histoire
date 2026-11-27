-- Lockheed XF-90
--
-- Photo : Lockheed XF-90 USAF.jpg
--   licence Public domain — U.S. Air Force photo
--   https://commons.wikimedia.org/wiki/File:Lockheed_XF-90_USAF.jpg

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
    'Lockheed XF-90',
    'Lockheed XF-90',
    'Lockheed XF-90',
    'Lockheed XF-90',
    'Chasseur de pénétration des Skunk Works, trop lourd et sous-motorisé, qui finit sous trois explosions atomiques',
    'Skunk Works penetration fighter, too heavy and underpowered, which ended up surviving three atomic blasts',
    '/assets/airplanes/xf90.jpg',
    E'## Genèse\nLe XF-90 répond au même besoin que le McDonnell XF-88 : un **chasseur de pénétration** à long rayon d''action, chargé d''escorter les bombardiers de l''US Air Force. Dès 1945, Lockheed propose un avion mû d''abord par son propre réacteur axial L-1000, puis par un General Electric J35, avant de retenir deux **Westinghouse J34** à postcombustion. Le dessin est confié à **Willis Hawkins** et à l''équipe des **Skunk Works** de **Kelly Johnson** ; une aile delta est écartée et la maquette du **Model 90** est construite en 1947. Retardé par des difficultés techniques et politiques, le premier des deux prototypes vole le 3 juin 1949 avec **Tony LeVier** aux commandes.\n\n## Conception\nL''avion hérite du **P-80 Shooting Star** son aile basse et ses entrées d''air, mais avec une **aile en flèche à 35°**, un nez très effilé et deux J34 côte à côte dans le fuselage arrière. Les ailes portent des becs de bord d''attaque et des volets Fowler, la cabine pressurisée reçoit une verrière bulle et un siège éjectable, et des réservoirs en bout d''aile portent le carburant à 6 308 l. Lockheed emploie l''alliage **75ST** au lieu du 24ST alors courant, avec de lourdes pièces forgées et usinées : la cellule est d''une grande robustesse, mais l''avion pèse à vide plus de 50 % de plus que ses concurrents. Six canons de 20 mm sont prévus.\n\n## Essais\nSans postcombustion, le premier XF-90 manque tant de poussée qu''il lui faut des fusées d''appoint au décollage, sauf avec très peu de carburant. Le second, **XF-90A**, reçoit des postcombustions déjà essayées sur un F-80, sans cesser d''être sous-motorisé. Il est pourtant le premier avion à réaction de l''USAF doté d''une postcombustion et le premier jet de Lockheed à passer le mur du son, en piqué ; sa dérive, mobile d''avant en arrière, sert au réglage du stabilisateur. Classé second derrière le XF-88, qui remporte le contrat de production en septembre 1950, il disparaît avec le programme de chasseur de pénétration, abandonné peu après.\n\n## Place dans l''histoire\nLes deux prototypes finissent en cobayes. Le premier, envoyé en 1953 au laboratoire du **NACA** de Cleveland, voit sa cellule extrêmement solide testée jusqu''à la rupture. Le second survit en 1952 à trois explosions atomiques sur Frenchman Flat, au **site d''essais du Nevada** ; récupéré en 2003 et décontaminé, tous ses rivets retirés, il est exposé au musée de l''US Air Force dans une mise en scène de ce site. Le XF-90 vit aussi dans la bande dessinée : ses versions imaginaires équipent l''escadrille des **Blackhawks** jusqu''en 1964.',
    E'## Genesis\nThe XF-90 answered the same requirement as the McDonnell XF-88: a long-range **penetration fighter** to escort US Air Force bombers. As early as 1945 Lockheed proposed an aircraft powered first by its own L-1000 axial-flow turbojet, then by a General Electric J35, before settling on two afterburning **Westinghouse J34s**. The design was entrusted to **Willis Hawkins** and the **Skunk Works** team under **Kelly Johnson**; a delta wing was rejected and the **Model 90** mock-up was built in 1947. Delayed by technical and political difficulties, the first of two prototypes flew on 3 June 1949 with **Tony LeVier** at the controls.\n\n## Design\nThe aircraft took its low wing and intakes from the **P-80 Shooting Star**, but with a **35° swept wing**, a sharply pointed nose and two J34s side by side in the rear fuselage. The wings had leading-edge slats and Fowler flaps, the pressurised cockpit had a bubble canopy and an ejection seat, and tip tanks brought fuel capacity to 6,308 litres. Lockheed used **75ST** aluminium instead of the then-standard 24ST, with heavy forgings and machined parts: the airframe was very sturdy, but the aircraft''s empty weight was more than 50% above its competitors''. Six 20 mm cannon were planned.\n\n## Testing\nWithout afterburners the first XF-90 was so short of thrust that it needed rocket assistance to take off, unless it carried very little fuel. The second, the **XF-90A**, received afterburners already tested on an F-80, yet remained underpowered. It was nonetheless the first USAF jet with an afterburner and the first Lockheed jet to go supersonic, in a dive; its fin could be moved fore and aft to trim the stabiliser. Placed second behind the XF-88, which won the production contract in September 1950, it vanished with the penetration fighter programme, abandoned soon afterwards.\n\n## Place in history\nBoth prototypes ended up as test subjects. The first, shipped in 1953 to the **NACA** laboratory in Cleveland, had its extremely strong airframe tested to destruction. The second survived three atomic blasts at Frenchman Flat, on the **Nevada Test Site**, in 1952; recovered in 2003 and decontaminated, every rivet removed, it is displayed at the National Museum of the US Air Force in a diorama of that site. The XF-90 also lived on in comics: fictional versions equipped the **Blackhawks** squadron until 1964.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-01',
    '1949-06-03',
    NULL,
    1064,
    3680,
    (SELECT id FROM manufacturer WHERE code = 'LOC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed XF-90'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Lockheed XF-90'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed XF-90'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'Lockheed XF-90'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.12,
  wingspan          = 12.2,
  height            = 4.8,
  wing_area         = 32,
  empty_weight      = 8204,
  mtow              = 14118,
  service_ceiling   = 11890,
  climb_rate        = 28.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J34-WE-15',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = NULL,
  thrust_wet        = 18.2,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Model 90** : maquette construite en 1947 après l''abandon d''une formule à aile delta\n- **XF-90 (46-687)** : premier prototype, réacteurs J34-WE-11 sans postcombustion ; testé jusqu''à la rupture au NACA de Cleveland\n- **XF-90A (46-688)** : second prototype, réacteurs à postcombustion ; soumis à trois explosions atomiques en 1952, exposé au musée de l''US Air Force\n- **F-90B et F-90C** : versions monoréacteurs imaginaires, pilotées par les Blackhawks dans la bande dessinée',
  variants_en       = E'- **Model 90**: mock-up built in 1947 after a delta-wing layout was abandoned\n- **XF-90 (46-687)**: first prototype, non-afterburning J34-WE-11 engines; tested to destruction at NACA Cleveland\n- **XF-90A (46-688)**: second prototype, afterburning engines; exposed to three atomic blasts in 1952, displayed at the National Museum of the US Air Force\n- **F-90B and F-90C**: fictional single-engined versions flown by the Blackhawks in comics',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_XF-90',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_XF-90',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed XF-90';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed XF-90';
