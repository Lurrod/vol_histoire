-- Airbus A310 MRTT (Multi-Role Tanker Transport)
--
-- Photo : Airbus A310-304MRTT 10+25 (9409588365).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File:Airbus_A310-304MRTT_10%2B25_(9409588365).jpg

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
    'Airbus A310 MRTT',
    'Airbus A310 MRTT',
    'Airbus A310 MRTT (Multi-Role Tanker Transport)',
    'Airbus A310 MRTT (Multi-Role Tanker Transport)',
    'Avion de ligne d''occasion converti en ravitailleur et transport polyvalent pour l''Allemagne et le Canada',
    'Second-hand airliner converted into a multi-role tanker transport for Germany and Canada',
    '/assets/airplanes/airbus-a310-mrtt.jpg',
    E'## Genèse\nÀ la fin des années 1990, l''Allemagne et le Canada doivent remplacer de vieux Boeing 707. Plutôt qu''un avion neuf, ils choisissent de transformer des **Airbus A310-300** de ligne d''occasion : d''abord en **A310 MRT**, transport militaire de passagers, de fret et d''évacuation sanitaire, puis en **A310 MRTT**, qui y ajoute le ravitaillement en vol. Le travail est confié à Airbus et à EADS, avec Airbus Deutschland et Lufthansa Technik ; le premier appareil converti, le 10+27 de la Luftwaffe, est présenté à Dresde le 9 décembre 2003.\n\n## Conception\nLa conversion ajoute deux **nacelles de ravitaillement** Mk32B à tuyau et panier sous les ailes, près des saumons, cinq réservoirs centraux supplémentaires portant la capacité à 77,5 tonnes de carburant, un poste d''opérateur derrière le commandant de bord et une caméra de surveillance capable de voir de nuit. Ailes et plancher sont renforcés. L''avion ravitaille deux appareils à la fois, à 15 000 litres par minute, et peut délivrer 33 tonnes de carburant sur une mission de 5 600 km. Sa grande porte cargo latérale lui permet aussi d''emporter 37 tonnes de fret, 214 passagers ou six unités de soins intensifs et 56 civières.\n\n## Carrière opérationnelle\nLes premières livraisons ont lieu en octobre 2004. La Luftwaffe convertit quatre de ses sept A310 MRT, et l''Aviation royale canadienne deux de ses cinq **CC-150 Polaris**. En juin 2007, un A310 MRTT doté d''une nouvelle avionique de mission permet à l''Allemagne d''affecter l''appareil aux forces de réaction de l''OTAN. Le premier emploi opérationnel allemand a lieu le 4 février 2009 : un ravitailleur accompagne trois **Eurofighter Typhoon** du Jagdgeschwader 73 de Laage jusqu''à Bangalore, près de 8 200 km avec une escale aux Émirats, pour la compétition indienne du chasseur multirôle. La Luftwaffe retire ses derniers appareils en 2022, tandis que le Canada en conserve deux.\n\n## Place dans l''histoire\nRavitailleur aux capacités proches du **KC-135R**, mais bien plus polyvalent grâce à sa cabine, l''A310 MRTT a montré qu''un avion de ligne d''occasion pouvait devenir un ravitailleur moderne à moindre coût. La fin de la production de l''A310 en 2007 limite sa diffusion, mais le concept survit dans l''**A330 MRTT**, plus gros de 30 %, qui lui succède jusque dans les forces canadiennes.',
    E'## Genesis\nIn the late 1990s, Germany and Canada needed to replace ageing Boeing 707s. Rather than a new aircraft, they chose to convert second-hand **Airbus A310-300** airliners: first into the **A310 MRT**, a military passenger, cargo and medical evacuation transport, then into the **A310 MRTT**, which adds air-to-air refuelling. The work went to Airbus and EADS, with Airbus Deutschland and Lufthansa Technik; the first converted aircraft, Luftwaffe 10+27, was presented at Dresden on 9 December 2003.\n\n## Design\nThe conversion adds two Mk32B hose-and-drogue **refuelling pods** under the wings near the tips, five additional centre tanks bringing fuel capacity to 77.5 tonnes, an operator station behind the captain and a night-capable surveillance camera. The wings and floor are strengthened. The aircraft refuels two receivers at a time at 15,000 litres per minute and can deliver 33 tonnes of fuel on a 5,600 km mission. Its large side cargo door also allows it to carry 37 tonnes of freight, 214 passengers or six intensive care units and 56 stretchers.\n\n## Operational career\nThe first deliveries took place in October 2004. The Luftwaffe converted four of its seven A310 MRTs, and the Royal Canadian Air Force two of its five **CC-150 Polaris**. In June 2007 an A310 MRTT with new mission avionics allowed Germany to assign the aircraft to the NATO Response Forces. The first German operational use came on 4 February 2009: a tanker accompanied three **Eurofighter Typhoons** of Jagdgeschwader 73 from Laage to Bangalore, nearly 8,200 km with a stopover in the Emirates, for India''s multi-role fighter competition. The Luftwaffe retired its last aircraft in 2022, while Canada kept two.\n\n## Place in history\nA tanker with capabilities close to the **KC-135R** but far more versatile thanks to its cabin, the A310 MRTT showed that a second-hand airliner could become a modern tanker at lower cost. The end of A310 production in 2007 limited its spread, but the concept lives on in the **A330 MRTT**, 30% larger, which succeeds it even in the Canadian forces.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1996-01-01',
    NULL,
    '2004-10-01',
    978,
    13000,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A310 MRTT'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Airbus A310 MRTT'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Airbus A310 MRTT'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A310 MRTT'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Airbus A310 MRTT'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 47.4,
  wingspan          = 43.9,
  height            = 15.81,
  wing_area         = NULL,
  empty_weight      = 113999,
  mtow              = 164000,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-80C2 ou Pratt & Whitney PW4152',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 262,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2003,
  production_end    = NULL,
  units_built       = 6,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **A310 MRT** : transport militaire de passagers, de fret et d''évacuation sanitaire converti d''A310-300 de ligne, base du MRTT\n- **A310 MRTT** : ravitailleur à deux nacelles Mk32B et cinq réservoirs centraux supplémentaires, quatre appareils allemands\n- **CC-150 Polaris** : désignation canadienne ; deux des cinq appareils convertis en ravitailleurs\n- **A310 MRTT à perche** : système de ravitaillement par perche rigide développé par EADS pour 90 millions de dollars, repris sur l''A330 MRTT',
  variants_en       = E'- **A310 MRT**: military passenger, cargo and medical evacuation transport converted from A310-300 airliners, basis of the MRTT\n- **A310 MRTT**: tanker with two Mk32B pods and five additional centre tanks, four German aircraft\n- **CC-150 Polaris**: Canadian designation; two of the five aircraft converted into tankers\n- **Boom-equipped A310 MRTT**: flying boom refuelling system developed by EADS for $90 million, carried over to the A330 MRTT',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Airbus_A310_MRTT',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Airbus_A310_MRTT',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Airbus A310 MRTT';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Airbus A310 MRTT';
