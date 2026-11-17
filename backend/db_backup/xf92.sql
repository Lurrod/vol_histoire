-- Convair XF-92A
--
-- Photo : Convair XF-92A.jpg
--   licence Public domain — NACA (now NASA)
--   https://commons.wikimedia.org/wiki/File:Convair_XF-92A.jpg

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
    'Convair XF-92',
    'Convair XF-92',
    'Convair XF-92A',
    'Convair XF-92A',
    'Démonstrateur à aile delta mal aimé de ses pilotes, mais qui ouvrit la lignée des F-102, F-106 et B-58',
    'A delta-wing demonstrator its pilots disliked, yet the one that opened the line of the F-102, F-106 and B-58',
    '/assets/airplanes/convair-xf92.jpg',
    E'## Genèse\nEn août 1945, les United States Army Air Forces demandent un intercepteur supersonique capable de 1 100 km/h et de monter à 15 000 m en quatre minutes. **Consolidated-Vultee**, futur **Convair**, l''emporte en mai 1946 avec un projet à statoréacteur et aile en flèche de 45°. Mais la soufflerie révèle de nombreux problèmes ; en redressant le bord de fuite et en augmentant la flèche du bord d''attaque, les ingénieurs aboutissent à une aile **delta** mince. Convair affirme l''avoir trouvée seul : sa rencontre avec **Alexander Lippisch** n''aurait apporté qu''un soutien moral. Le projet devient le XP-92, et, pour acquérir l''expérience du delta, l''USAAF accepte en novembre 1946 un appareil d''essai plus petit, le **Model 7002**.\n\n## Conception\nPour gagner du temps et de l''argent, le Model 7002 est assemblé avec des pièces d''autres avions : le train principal d''un **FJ-1 Fury**, la roulette avant d''un **P-63 Kingcobra**, le réacteur et l''hydraulique d''un **P-80**, le siège et la verrière du **XP-81**. Le premier moteur est un **Allison J33**. Lorsque l''avion est prêt, l''intercepteur de défense ponctuelle paraît déjà dépassé et le F-92 est annulé, mais l''appareil d''essai est achevé sous le nom de XF-92A.\n\n## Essais\nAprès un saut de puce le 9 juin 1948 à Muroc, l''XF-92A vole le 18 septembre 1948 aux mains d''**Ellis Shannon**. Livré à l''US Air Force en août 1949, il est confié à **Frank Everest** et **Chuck Yeager**, qui atteint Mach 1,05 en piqué et découvre que l''avion refuse de décrocher : cabré à 45°, il se pose à 108 km/h. Remotorisé en 1951 avec un J33 à postcombustion, il ne gagne presque rien. À partir d''avril 1953, **Scott Crossfield** révèle pour le NACA un cabré violent en virage rapide, jusqu''à 8 g ; le train avant cède après son dernier vol, en octobre 1953. « Personne ne voulait voler sur le XF-92 », dira-t-il.\n\n## Place dans l''histoire\nL''avion était peu aimé, mais l''aile delta, mince, légère et solide, promettait à la fois de bonnes performances à grande vitesse et un comportement docile à basse vitesse. Convair l''adopte pour le **F-102 Delta Dagger**, le **F-106 Delta Dart**, le **B-58 Hustler**, le **F2Y Sea Dart** et le **FY Pogo**. Le tourbillon qui collait à l''extrados aux grands angles, observé par Yeager, mènera aux plans canard et aux extensions de bord d''attaque des chasseurs modernes. L''appareil est conservé au musée de l''US Air Force.',
    E'## Genesis\nIn August 1945 the United States Army Air Forces called for a supersonic interceptor capable of 1,100 km/h and of climbing to 15,000 m in four minutes. **Consolidated-Vultee**, the future **Convair**, won in May 1946 with a ramjet design with a 45-degree swept wing. But wind tunnel tests revealed many problems; by straightening the trailing edge and increasing leading-edge sweep, the engineers arrived at a thin **delta** wing. Convair maintained it found it on its own: meeting **Alexander Lippisch** had provided no more than moral support. The project became the XP-92 and, to gain experience with the delta, the USAAF accepted a smaller test aircraft, the **Model 7002**, in November 1946.\n\n## Design\nTo save time and money, the Model 7002 was assembled from parts of other aircraft: the main gear of an **FJ-1 Fury**, the nosewheel of a **P-63 Kingcobra**, the engine and hydraulics of a **P-80**, and the seat and canopy of the **XP-81**. The first engine was an **Allison J33**. By the time the aircraft was ready, the point-defence interceptor already looked outdated and the F-92 was cancelled, but the test aircraft was completed as the XF-92A.\n\n## Testing\nAfter a short hop on 9 June 1948 at Muroc, the XF-92A flew on 18 September 1948 with **Ellis Shannon** at the controls. Handed over to the US Air Force in August 1949, it was assigned to **Frank Everest** and **Chuck Yeager**, who reached Mach 1.05 in a dive and found the aircraft simply would not stall: nose up at 45 degrees, he landed at 108 km/h. Re-engined in 1951 with an afterburning J33, it gained very little. From April 1953 **Scott Crossfield** revealed for the NACA a violent pitch-up in high-speed turns, up to 8 g; the nose gear collapsed after his last flight in October 1953. Nobody wanted to fly the XF-92, he would say.\n\n## Place in history\nThe aircraft was disliked, but the thin, light and strong delta wing promised both good high-speed performance and docile low-speed handling. Convair adopted it for the **F-102 Delta Dagger**, the **F-106 Delta Dart**, the **B-58 Hustler**, the **F2Y Sea Dart** and the **FY Pogo**. The vortex that clung to the upper wing at high angles of attack, noticed by Yeager, would lead to the canards and leading-edge extensions of modern fighters. The aircraft is preserved at the US Air Force museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-08-01',
    '1948-09-18',
    NULL,
    1156,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'CVR'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XF-92'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Convair XF-92'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Convair XF-92'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.95,
  wingspan          = 9.55,
  height            = 5.41,
  wing_area         = 39.5,
  empty_weight      = 4118,
  mtow              = 6626,
  service_ceiling   = 15470,
  climb_rate        = 41.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J33-A-29',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 20.0,
  thrust_wet        = 33.4,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **XP-92** : intercepteur de défense ponctuelle à propulsion mixte, réacteur J30 et six fusées, cockpit logé au centre de l''entrée d''air, jamais construit\n- **Model 7002 / XF-92A** (46-682) : appareil d''essai du delta, seul exemplaire construit\n- **J33-A-21** puis **J33-A-29** à postcombustion (1951), enfin **J33-A-16** : trois moteurs successifs\n- **Cinéma** : « MiG-23 » de Jet Pilot, rôle coupé au montage, puis faux F-102 dans Toward the Unknown (1956)',
  variants_en       = E'- **XP-92**: mixed-power point-defence interceptor, J30 turbojet and six rockets, cockpit housed in the centre of the intake, never built\n- **Model 7002 / XF-92A** (46-682): delta test aircraft, the only one built\n- **J33-A-21**, then afterburning **J33-A-29** (1951), finally **J33-A-16**: three successive engines\n- **Cinema**: the MiG-23 of Jet Pilot, a role cut in editing, then a stand-in F-102 in Toward the Unknown (1956)',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Convair_XF-92',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Convair_XF-92',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NACA',
  image_licence     = 'Public domain'
WHERE name = 'Convair XF-92';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Convair XF-92';
