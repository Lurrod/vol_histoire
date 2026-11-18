-- Gulfstream C-20 (Gulfstream III)
--
-- Photo : Tech. Sgt. Vanessa Schook performs a preflight safety inspection on a C-20B at Joint Base Andrews (32532740622).jpg
--   licence Public domain — US Air Force from USA Senior Master Sgt. Kevin Wallace/89th Airlift Wing
--   https://commons.wikimedia.org/wiki/File:Tech._Sgt._Vanessa_Schook_performs_a_preflight_safety_inspection_on_a_C-20B_at_Joint_Base_Andrews_(32532740622).jpg

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
    'Gulfstream C-20',
    'Gulfstream C-20',
    'Gulfstream C-20 (Gulfstream III)',
    'Gulfstream C-20 (Gulfstream III)',
    'Gulfstream III des Special Air Missions, qui escorte Air Force One et transporte les chefs militaires américains',
    'Special Air Missions Gulfstream III that shadows Air Force One and carries America''s military leaders',
    '/assets/airplanes/c20-gulfstream.jpg',
    E'## Genèse\nLe Gulfstream III dérive du **Grumman Gulfstream II**. Grumman et Gulfstream American étudient d''abord une aile entièrement nouvelle à profils supercritiques, avant de conclure qu''une bonne part du gain s''obtient en modifiant l''aile existante. Le prototype vole le 2 décembre 1979 et la certification tombe le 22 septembre 1980. En 1983, le Pentagone cherche à remplacer ses **C-140 JetStar** vieillissants, épaulés par quelques CT-39 Sabreliner : après avoir évalué le C-11 des garde-côtes, l''US Air Force retient le Gulfstream III en juillet 1983, sous le nom de **C-20**.\n\n## Conception\nPar rapport au Gulfstream II, l''aile gagne 1,8 m d''envergure, des winglets de 1,5 m et un bord d''attaque redessiné ; le fuselage s''allonge de 61 cm et reçoit un pare-brise courbe. Deux turbosoufflantes **Rolls-Royce Spey** de 51 kN donnent 6 760 km d''autonomie avec huit passagers. Rien ne distingue extérieurement un C-20 d''un Gulfstream III civil, sinon sa livrée, ses cocardes et les antennes de ses transmissions militaires. Le C-20A emporte quatorze passagers et cinq membres d''équipage ; le C-20C reçoit des transmissions sécurisées et durcies.\n\n## Carrière opérationnelle\nLes premiers C-20 entrent en service en 1984. Ceux de l''Air Force assurent les **Special Air Missions** au départ d''Andrews ; le C-20C sert souvent d''appareil de secours aux côtés du VC-25A quand celui-ci vole en Air Force One. La Navy reçoit des C-20D, qui reprennent une partie des missions de transport prioritaire des C-9B Skytrain II, et l''Army des C-20E, qui remplacent ses derniers U-21 et CT-39 ; l''unique C-20B des garde-côtes porte leur commandant et le secrétaire à la Sécurité intérieure. Retirés en 2002, les C-20A cèdent un appareil à la NASA, qui lui accroche un radar en nacelle ventrale.\n\n## Place dans l''histoire\nLe C-20 ouvre une lignée : les C-20F, G, H et J sont des Gulfstream IV, et la famille finit par servir dans les cinq armes américaines. À l''export, le Gulfstream III et le C-20 servent près de vingt opérateurs militaires et gouvernementaux ; le Danemark en tire trois SMA-3 de patrouille maritime à radar APS-127, dont l''un s''écrase aux Féroé le 3 août 1996, tuant le chef d''état-major des armées **Jørgen Garde**. En novembre 2015, l''USAF aligne encore cinq C-20B.',
    E'## Genesis\nThe Gulfstream III was derived from the **Grumman Gulfstream II**. Grumman and Gulfstream American first studied an all-new wing with supercritical sections, before concluding that much of the benefit could be had by modifying the existing wing. The prototype flew on 2 December 1979 and was certified on 22 September 1980. In 1983 the Pentagon sought to replace its ageing **C-140 JetStars**, backed up by a few CT-39 Sabreliners: after evaluating the Coast Guard''s C-11, the US Air Force chose the Gulfstream III in July 1983 as the **C-20**.\n\n## Design\nCompared with the Gulfstream II, the wing gained 1.8 m of span, 1.5 m winglets and a reshaped leading edge; the fuselage was stretched by 61 cm and given a curved windshield. Two 51 kN **Rolls-Royce Spey** turbofans give a range of 6,760 km with eight passengers. Nothing outwardly separates a C-20 from a civil Gulfstream III except its paint, roundels and military communications antennas. The C-20A carries fourteen passengers and five crew; the C-20C received secure, hardened communications.\n\n## Operational career\nThe first C-20s entered service in 1984. The Air Force aircraft fly **Special Air Missions** from Andrews; the C-20C often serves as a backup accompanying the VC-25A when it flies as Air Force One. The Navy received C-20Ds, which took over part of the C-9B Skytrain II''s priority transport work, and the Army C-20Es, which replaced its last U-21s and CT-39s; the Coast Guard''s single C-20B carries its commandant and the Secretary of Homeland Security. When the C-20As were retired in 2002, one went to NASA, which fitted it with a radar pod under the fuselage.\n\n## Place in history\nThe C-20 started a line: the C-20F, G, H and J are Gulfstream IVs, and the family eventually served in all five US armed services. Abroad, the Gulfstream III and C-20 served nearly twenty military and government operators; Denmark took three SMA-3 maritime patrol aircraft with APS-127 radar, one of which crashed in the Faroe Islands on 3 August 1996, killing the Chief of Defence, **Jørgen Garde**. In November 2015 the USAF still flew five C-20Bs.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1979-12-02',
    '1984-01-01',
    928,
    6760,
    (SELECT id FROM manufacturer WHERE code = 'GUL'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Gulfstream C-20'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Spey'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Gulfstream C-20'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 25.32,
  wingspan          = 23.72,
  height            = 7.43,
  wing_area         = 86.83,
  empty_weight      = 17237,
  mtow              = 31615,
  service_ceiling   = 13700,
  climb_rate        = 19.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Spey RB.163 Mk 511-8',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 50.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 19,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 18,
  variants          = E'- **C-20A** : version initiale de l''USAF pour quatorze passagers et cinq membres d''équipage, trois exemplaires, retirée en 2002\n- **C-20B** : électronique améliorée pour les Special Air Missions, huit exemplaires dont un pour les garde-côtes\n- **C-20C** : C-20B à transmissions sécurisées et durcies, appareil de secours d''Air Force One, trois exemplaires\n- **C-20D / C-20E** : transports de soutien de la Navy (trois) et de l''Army (deux)\n- **SMA-3** : version de patrouille maritime à radar APS-127, trois livrées au Danemark en 1983',
  variants_en       = E'- **C-20A**: initial USAF version for fourteen passengers and five crew, three aircraft, retired in 2002\n- **C-20B**: improved electronics for Special Air Missions, eight aircraft including one for the Coast Guard\n- **C-20C**: C-20B with secure, hardened communications, Air Force One backup, three aircraft\n- **C-20D / C-20E**: Navy (three) and Army (two) operational support transports\n- **SMA-3**: maritime patrol version with APS-127 radar, three delivered to Denmark in 1983',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Gulfstream_III',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Gulfstream_III',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Senior Master Sgt. Kevin Wallace, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Gulfstream C-20';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Gulfstream C-20';
