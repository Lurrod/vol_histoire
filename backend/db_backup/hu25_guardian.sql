-- Dassault HU-25 Guardian (Falcon 20G)
--
-- Photo : Dassault HU-25C Falcon 2104 Andrews AFB MD1.jpg
--   licence CC BY-SA 4.0 — Acroterion
--   https://commons.wikimedia.org/wiki/File:Dassault_HU-25C_Falcon_2104_Andrews_AFB_MD1.jpg

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
    'Dassault HU-25 Guardian',
    'Dassault HU-25 Guardian',
    'Dassault HU-25 Guardian (Falcon 20G)',
    'Dassault HU-25 Guardian (Falcon 20G)',
    'Falcon 20 des garde-côtes américains, seul jet de leur flotte opérationnelle, chasseur de naufragés et de trafiquants',
    'US Coast Guard Falcon 20, the only jet in its operational fleet, hunting for castaways and smugglers',
    '/assets/airplanes/hu25-guardian.jpg',
    E'## Genèse\nLe Falcon 20 répond d''abord à une demande de l''État français pour un biréacteur de liaison et d''entraînement. **Marcel Dassault** lance en décembre 1961 le **Mystère 20**, dont l''aérodynamique dérive du chasseur Mystère IV ; le prototype vole le 4 mai 1963 à Bordeaux-Mérignac. Pan Am, qui le distribue en Amérique sous le nom de Fan Jet Falcon, impose des réacteurs General Electric CF700 et finit par en commander 160. Les commandes militaires suivent, et en 1977 l''**US Coast Guard** achète 41 Falcon 20G à moteurs américains sous le nom de **HU-25 Guardian**.\n\n## Conception\nLe Guardian est la version de surveillance maritime du Falcon 20, motorisée par deux turbosoufflantes **Garrett ATF3-6-2C**. Il conserve l''aile à forte flèche du Falcon, dont les becs se déploient automatiquement aux grands angles d''attaque, et des commandes hydrauliques qui restent pilotables sans assistance. Des conversions spécialisent ensuite la flotte : sept HU-25B reçoivent un radar latéral de détection des marées noires, neuf HU-25C le radar de recherche **APG-66** et une tourelle infrarouge pour la lutte antidrogue, et quinze HU-25D un radar à synthèse d''ouverture inverse APS-143B.\n\n## Carrière opérationnelle\nLes 41 Guardian sont livrés entre 1982 et décembre 1983. Avion de repérage rapide, le HU-25 localise les naufragés puis guide vers eux les avions plus lents et les navires de sauvetage ; il traque aussi les trafiquants de drogue en mer comme dans les airs. Il compte parmi les moyens essentiels des garde-côtes déployés pendant la **guerre du Golfe** en 1991. Le dernier HU-25 opérationnel est retiré le 26 septembre 2014, après 32 ans de service, et ses remplaçants, les turbopropulseurs HC-144 Ocean Sentry, n''offrent plus la même vitesse.\n\n## Place dans l''histoire\nLe HU-25 reste le seul avion à réaction jamais intégré à la flotte opérationnelle des garde-côtes américains. Il a aussi servi la recherche : en 2006, l''USAF en confie un au laboratoire Lincoln du MIT, et en 2011 la NASA engage un ancien HU-25C dans l''opération **IceBridge**, équipé d''un altimètre laser qui relève la topographie de l''Arctique. Il témoigne du succès militaire du Falcon 20, employé aussi par la Marine nationale, l''Iran, le Pakistan ou la Norvège, souvent pour la guerre électronique.',
    E'## Genesis\nThe Falcon 20 first answered a French government request for a twin-jet liaison and training aircraft. **Marcel Dassault** launched the **Mystère 20** in December 1961, its aerodynamics drawn from the Mystère IV fighter; the prototype flew on 4 May 1963 at Bordeaux-Mérignac. Pan Am, which distributed it in the Americas as the Fan Jet Falcon, insisted on General Electric CF700 engines and eventually ordered 160. Military orders followed, and in 1977 the **US Coast Guard** bought 41 American-engined Falcon 20Gs as the **HU-25 Guardian**.\n\n## Design\nThe Guardian is the maritime surveillance version of the Falcon 20, powered by two **Garrett ATF3-6-2C** turbofans. It keeps the Falcon''s highly swept wing, whose slats deploy automatically at high angles of attack, and hydraulic controls that remain flyable without assistance. Conversions later specialised the fleet: seven HU-25Bs received a side-looking radar to detect oil spills, nine HU-25Cs the **APG-66** search radar and an infrared turret for drug interdiction, and fifteen HU-25Ds an APS-143B inverse synthetic aperture radar.\n\n## Operational career\nThe 41 Guardians were delivered between 1982 and December 1983. A fast spotter, the HU-25 located shipwreck survivors and then guided slower aircraft and rescue vessels to them; it also hunted drug traffickers at sea and in the air. It was one of the Coast Guard''s critical assets deployed during the 1991 **Gulf War**. The last operational HU-25 was retired on 26 September 2014 after 32 years of service, and its replacements, HC-144 Ocean Sentry turboprops, could not match its speed.\n\n## Place in history\nThe HU-25 remains the only jet ever to join the US Coast Guard''s operational fleet. It also served research: in 2006 the USAF gave one to MIT''s Lincoln Laboratory, and in 2011 NASA committed a former HU-25C to **Operation IceBridge**, fitted with a laser altimeter to map Arctic surface topography. It reflects the military success of the Falcon 20, also flown by the French Navy, Iran, Pakistan and Norway, often for electronic warfare.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1977-01-01',
    NULL,
    '1982-02-01',
    862,
    3350,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault HU-25 Guardian'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault HU-25 Guardian'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Dassault HU-25 Guardian'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.15,
  wingspan          = 16.3,
  height            = 5.32,
  wing_area         = 41.0,
  empty_weight      = 7530,
  mtow              = 13000,
  service_ceiling   = 12800,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett AiResearch ATF3-6-2C',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1982,
  production_end    = 1983,
  units_built       = 41,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **HU-25A** : version de base des garde-côtes, tirée du Falcon 20G à ATF3-6-2C, 41 construits\n- **HU-25B** : lutte contre la pollution, radar latéral aéroporté sous le fuselage, sept convertis\n- **HU-25C / C+** : lutte antidrogue, radar Westinghouse APG-66 et tourelle infrarouge WF-360, neuf convertis puis modernisés\n- **HU-25D** : HU-25A modernisés avec un radar à synthèse d''ouverture inverse AN/APS-143B(V)3, quinze convertis\n- **Guardian 2** : version de patrouille maritime proposée sur la base du Falcon 200, jamais produite',
  variants_en       = E'- **HU-25A**: basic Coast Guard version derived from the ATF3-6-2C-powered Falcon 20G, 41 built\n- **HU-25B**: pollution control, side-looking airborne radar under the fuselage, seven converted\n- **HU-25C / C+**: drug interdiction, Westinghouse APG-66 radar and WF-360 infrared turret, nine converted then upgraded\n- **HU-25D**: HU-25As upgraded with an AN/APS-143B(V)3 inverse synthetic aperture radar, fifteen converted\n- **Guardian 2**: proposed maritime patrol version based on the Falcon 200, never produced',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mystère_20',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Falcon_20',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Acroterion',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Dassault HU-25 Guardian';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dassault HU-25 Guardian';
