-- Grumman F7F Tigercat
--
-- Photo : Vintage Aircraft Weekend, Paine Field, 2016 Grumman F7F Tigercat "Bad Kitty" (29432417581).jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File:Vintage_Aircraft_Weekend,_Paine_Field,_2016_Grumman_F7F_Tigercat_%22Bad_Kitty%22_(29432417581).jpg

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
    'F7F Tigercat',
    'F7F Tigercat',
    'Grumman F7F Tigercat',
    'Grumman F7F Tigercat',
    'Premier chasseur bimoteur de l''US Navy, chasseur de nuit des Marines au-dessus de la Corée',
    'The US Navy''s first twin-engined fighter, a Marine Corps night fighter over Korea',
    '/assets/airplanes/f7f-tigercat.jpg',
    E'## Genèse\nLe Tigercat descend d''un chasseur d''armée annulé, le **Grumman XP-50**, dont Grumman tire un projet de « chasseur de convoi », le XP-65. Le contrat du prototype **XF7F-1** est signé le 30 juin 1941, et le travail sur le XP-65 cesse en 1943 au profit de ce nouvel appareil. L''ambition de **Grumman** est sans détour : un chasseur plus rapide et mieux armé que tous ceux qui existent, capable en plus d''attaquer au sol. Conçu pour les grands porte-avions de la classe **Midway**, il devient le premier chasseur bimoteur mis en service par l''US Navy.\n\n## Conception\nDeux moteurs en étoile **Pratt & Whitney R-2800 Double Wasp** de 2 100 ch en font l''un des chasseurs à pistons les plus rapides de son temps : 114 km/h de plus qu''un F6F Hellcat au niveau de la mer. Le pilote d''essai **Fred Trapnell** le tient pour « le meilleur satané chasseur » qu''il ait piloté. L''armement est massif, quatre canons de 20 mm et quatre mitrailleuses de 12,7 mm, avec bombes ou torpille sous la voilure et le fuselage. La rançon : un poids élevé, une vitesse d''appontage forte et surtout une mauvaise stabilité de route sur un seul moteur. Les premières séries échouent aux qualifications embarquées ; seul le **F7F-4N**, renforcé, sera admis à bord.\n\n## Carrière opérationnelle\nLivré trop tard pour combattre en 1945, le Tigercat sert d''abord à terre, dans le **Corps des Marines**. L''escadrille de reconnaissance VMP-354, arrivée à Guam en juin 1945, photographie depuis Okinawa les plages prévues pour l''invasion du Kyushu. Pendant la **guerre de Corée**, les F7F-3N de l''escadrille de chasse de nuit VMF(N)-513 mènent des missions d''interdiction et de chasse nocturnes et abattent deux biplans Polikarpov Po-2 : ce sera son seul engagement au combat. La plupart des F7F-2N finissent en avions de contrôle de drones pour l''entraînement au tir.\n\n## Place dans l''histoire\nConstruit à 364 exemplaires entre 1943 et 1946, le Tigercat quitte le service en 1954, dépassé par les chasseurs à réaction. En 1945, la **Royal Navy** en évalue deux exemplaires, puis lui préfère la version navale du **de Havilland Hornet**, son homologue britannique. Les avions vendus en surplus deviennent bombardiers d''eau contre les feux de forêt dans les années 1960 et 1970, et plusieurs volent encore aujourd''hui. Son premier nom, Tomcat, jugé trop suggestif à l''époque, reviendra trente ans plus tard sur un autre Grumman embarqué, le **F-14**.',
    E'## Genesis\nThe Tigercat descends from a cancelled army fighter, the **Grumman XP-50**, which Grumman developed into a "convoy fighter" project, the XP-65. The contract for the **XF7F-1** prototype was signed on 30 June 1941, and work on the XP-65 ended in 1943 in favour of the new aircraft. **Grumman**''s aim was blunt: a fighter that would outperform and outgun every existing fighter, with a ground-attack capability on top. Designed for the large **Midway**-class carriers, it became the first twin-engined fighter deployed by the US Navy.\n\n## Design\nTwo **Pratt & Whitney R-2800 Double Wasp** radials of 2,100 hp made it one of the fastest piston-engined fighters of its day: 71 mph faster than an F6F Hellcat at sea level. Test pilot **Fred Trapnell** called it "the best damn fighter I''ve ever flown". The armament was massive, four 20 mm cannon and four 12.7 mm machine guns, with bombs or a torpedo under the wings and fuselage. The price was heavy weight, a high landing speed and, above all, poor directional stability on one engine. The early batches failed carrier qualification; only the strengthened **F7F-4N** was cleared for deck operations.\n\n## Operational career\nDelivered too late to fight in 1945, the Tigercat first served ashore with the **Marine Corps**. Photographic squadron VMP-354, which reached Guam in June 1945, flew from Okinawa to photograph the beaches planned for the invasion of Kyushu. During the **Korean War**, the F7F-3Ns of night-fighter squadron VMF(N)-513 flew night interdiction and fighter missions and shot down two Polikarpov Po-2 biplanes: this was the type''s only combat use. Most F7F-2Ns ended their careers as drone-control aircraft for combat training.\n\n## Place in history\nBuilt in 364 examples between 1943 and 1946, the Tigercat left service in 1954, overtaken by jet fighters. In 1945 the **Royal Navy** evaluated two examples, then chose the naval version of the **de Havilland Hornet**, its British counterpart, instead. Surplus aircraft became water bombers fighting wildfires in the 1960s and 1970s, and several still fly today. Its original name, Tomcat, judged too suggestive at the time, returned thirty years later on another Grumman carrier aircraft, the **F-14**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1941-06-30',
    '1943-11-02',
    '1944-01-01',
    740,
    1900,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM armement WHERE name = '1000 lb GP'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F7F Tigercat'), (SELECT id FROM wars WHERE name = 'Guerre de Corée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.82,
  wingspan          = 15.7,
  height            = 5.05,
  wing_area         = 42.3,
  empty_weight      = 7380,
  mtow              = 11666,
  service_ceiling   = 12300,
  climb_rate        = 23.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-34W Double Wasp (2 100 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1943,
  production_end    = 1946,
  units_built       = 364,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **XF7F-1** : deux prototypes\n- **F7F-1** : première version de série, chasseur-bombardier monoplace à moteurs R-2800-22W, 34 exemplaires\n- **F7F-2N** : chasseur de nuit biplace avec opérateur radar, 65 exemplaires, la plupart convertis ensuite en avions de contrôle de drones (F7F-2D)\n- **F7F-3** : chasseur-bombardier à moteurs R-2800-34W et dérive agrandie, 189 exemplaires, dont des conversions de reconnaissance (F7F-3P) et de guerre électronique (F7F-3E)\n- **F7F-3N** : chasseur de nuit biplace, 60 exemplaires, engagé en Corée\n- **F7F-4N** : chasseur de nuit renforcé et doté d''une crosse d''appontage, seule version qualifiée sur porte-avions, 12 exemplaires',
  variants_en       = E'- **XF7F-1**: two prototypes\n- **F7F-1**: first production version, single-seat fighter-bomber with R-2800-22W engines, 34 built\n- **F7F-2N**: two-seat night fighter with a radar operator, 65 built, most later converted to drone-control aircraft (F7F-2D)\n- **F7F-3**: fighter-bomber with R-2800-34W engines and an enlarged fin, 189 built, including reconnaissance (F7F-3P) and electronic-warfare (F7F-3E) conversions\n- **F7F-3N**: two-seat night fighter, 60 built, used in Korea\n- **F7F-4N**: strengthened night fighter fitted with a tailhook, the only carrier-qualified version, 12 built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_F7F_Tigercat',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_F7F_Tigercat',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clemens Vasters',
  image_licence     = 'CC BY 2.0'
WHERE name = 'F7F Tigercat';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F7F Tigercat';
