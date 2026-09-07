-- Mitsubishi F-104J Starfighter
--
-- Photo : F-104J JASDF KwangjuAB 1982.jpeg
--   licence Public domain — SSGT Terry Smith
--   https://commons.wikimedia.org/wiki/File%3AF-104J_JASDF_KwangjuAB_1982.jpeg

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
    'Mitsubishi F-104J',
    'Mitsubishi F-104J',
    'Mitsubishi F-104J Starfighter',
    'Mitsubishi F-104J Starfighter',
    'Starfighter construit sous licence au Japon, épine dorsale de la défense aérienne',
    'Licence-built Japanese Starfighter, backbone of air defence',
    '/assets/airplanes/f104j.jpg',
    E'## Genèse\nLe choix japonais de 1959 fut disputé : le Grumman F11F-1F semblait tenir la corde avant que le F-104 ne l''emporte, dans un contexte de concurrence commerciale intense — le même programme Starfighter qui vaudra à Lockheed le scandale de corruption le plus retentissant de l''après-guerre en Allemagne, aux Pays-Bas et au Japon.\n\n## Conception\nMitsubishi construit 210 des 230 appareils sous licence, moteur compris chez Ishikawajima-Harima. L''aile est si fine — **10 centimètres d''épaisseur** au maître-couple — que les bords d''attaque sont protégés au sol par des housses pour éviter de blesser les mécaniciens. Le F-104J est configuré en intercepteur pur : radar, canon et missiles infrarouges, sans capacité air-sol.\n\n## Carrière opérationnelle\nVingt-trois ans d''alerte permanente face aux incursions soviétiques dans l''espace aérien japonais, sans jamais tirer. Le taux d''accidents japonais est nettement inférieur à celui de la Luftwaffe, ce qui alimentera le débat sur la responsabilité de l''appareil dans les pertes allemandes — trois F-104 japonais perdus pour cent, contre plus du triple en Allemagne.\n\n## Place dans l''histoire\nLe F-104J est le premier avion de combat supersonique produit au Japon, et le fondement de l''industrie qui donnera le **F-15J** et le **F-2**. Il est remplacé à partir de 1981 par le F-15J, puis totalement retiré en 1986.',
    E'## Genesis\nJapan’s 1959 choice was contested: the Grumman F11F-1F seemed to lead before the F-104 won, amid intense commercial competition — the same Starfighter programme that would earn Lockheed the most damaging post-war corruption scandal in Germany, the Netherlands and Japan.\n\n## Design\nMitsubishi built 210 of the 230 aircraft under licence, engine included at Ishikawajima-Harima. The wing is so thin — **10 centimetres thick** at its deepest — that its leading edges are covered on the ground to avoid injuring the ground crew. The F-104J was configured as a pure interceptor: radar, gun and infrared missiles, with no air-to-ground capability.\n\n## Operational career\nTwenty-three years of standing alert against Soviet incursions into Japanese airspace, without ever firing. The Japanese accident rate was markedly lower than the Luftwaffe’s, which fuelled the debate over how much of the German losses the aircraft itself was responsible for — three Japanese F-104s lost per hundred, against more than three times that in Germany.\n\n## Place in history\nThe F-104J was the first supersonic combat aircraft produced in Japan and the foundation of the industry that would deliver the **F-15J** and the **F-2**. It was replaced from 1981 by the F-15J and fully retired in 1986.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1959-01-01',
    '1961-06-30',
    '1963-03-01',
    2137.0,
    2620.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.69,
  wingspan          = 6.68,
  height            = 4.11,
  wing_area         = 18.22,
  empty_weight      = 6350,
  mtow              = 13170,
  service_ceiling   = 15000,
  climb_rate        = 244,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 670,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J79-IHI-11A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 46.7,
  thrust_wet        = 70.3,

  -- Strate 3 : production & service
  production_start  = 1961,
  production_end    = 1967,
  units_built       = 230,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F-104J** : intercepteur monoplace, 210 exemplaires construits au Japon\n- **F-104DJ** : biplace d''entraînement, livré par Lockheed\n- **UF-104J** : cellules converties en drones-cibles après retrait\n- Surnommé **Eiko** (栄光, « gloire ») dans la force aérienne japonaise',
  variants_en       = E'- **F-104J** : single-seat interceptor, 210 built in Japan\n- **F-104DJ** : two-seat trainer, delivered by Lockheed\n- **UF-104J** : airframes converted into target drones after retirement\n- Nicknamed **Eiko** (栄光, “glory”) in the Japanese air force',

  -- Strate 4 : qualitatif
  nickname          = 'Eiko',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'SSGT Terry Smith',
  image_licence     = 'Public domain'
WHERE name = 'Mitsubishi F-104J';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mitsubishi F-104J';
