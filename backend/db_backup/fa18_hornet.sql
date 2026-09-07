-- McDonnell Douglas F/A-18 Hornet
--
-- Photo : F-18C Hornet of VFA-136 in flight 1992.JPEG
--   licence Public domain — Cmdr. John Leenhouts, USN
--   https://commons.wikimedia.org/wiki/File%3AF-18C_Hornet_of_VFA-136_in_flight_1992.JPEG

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
    'F/A-18 Hornet',
    'F/A-18 Hornet',
    'McDonnell Douglas F/A-18 Hornet',
    'McDonnell Douglas F/A-18 Hornet',
    'Chasseur-bombardier embarqué polyvalent de l’US Navy',
    'Versatile US Navy carrier-borne strike fighter',
    '/assets/airplanes/fa18-hornet.jpg',
    E'## Genèse\nLe Hornet naît d''un perdant. Le **YF-17 Cobra** de Northrop s''incline face au YF-16 dans le concours *Lightweight Fighter* de l''US Air Force en 1975. Mais l''US Navy, qui refuse un monoréacteur au-dessus de l''océan, reprend le projet : Northrop s''associe à McDonnell Douglas pour le navaliser. Le bimoteur recalé devient l''un des avions embarqués les plus produits de l''histoire.\n\n## Conception\nSa véritable rupture est doctrinale : le trait d''union de **F/A** signifie qu''un même appareil, avec le même équipage et un simple changement de configuration entre deux missions, assure la chasse et l''attaque au sol. Là où l''US Navy alignait F-4, A-7 et A-6, elle n''aligne plus qu''un type. Les commandes de vol électriques et une aile à grande portance lui donnent des qualités d''appontage exceptionnelles.\n\n## Carrière opérationnelle\nBaptême du feu en **1986** au-dessus de la Libye. Pendant la guerre du Golfe, deux Hornet abattent deux MiG-21 irakiens puis, sans se déserrer de leur formation, poursuivent leur mission de bombardement le même jour — la démonstration la plus citée du concept multirôle. Il sert ensuite dans les Balkans, en Afghanistan, en Irak et en Syrie.\n\n## Place dans l''histoire\nExporté vers huit pays, il équipe encore le corps des Marines et plusieurs forces aériennes. Sa descendance directe, le **Super Hornet**, plus grand de 25 %, a remplacé le F-14 Tomcat sur les porte-avions américains.',
    E'## Genesis\nThe Hornet was born from a loser. Northrop’s **YF-17 Cobra** lost to the YF-16 in the US Air Force *Lightweight Fighter* contest in 1975. But the US Navy, unwilling to fly a single-engine aircraft over the ocean, picked the design up: Northrop teamed with McDonnell Douglas to navalise it. The rejected twin-engine fighter became one of the most-produced carrier aircraft in history.\n\n## Design\nIts real breakthrough was doctrinal: the slash in **F/A** meant one aircraft, with the same crew and a simple configuration change between sorties, could fly both fighter and attack missions. Where the US Navy had fielded F-4s, A-7s and A-6s, it now fielded one type. Fly-by-wire controls and a high-lift wing give it exceptional carrier landing qualities.\n\n## Operational career\nFirst combat in **1986** over Libya. During the Gulf War two Hornets shot down two Iraqi MiG-21s and then, without breaking formation, carried on with their bombing mission the same day — the most-cited demonstration of the multirole concept. It went on to serve in the Balkans, Afghanistan, Iraq and Syria.\n\n## Place in history\nExported to eight countries, it still equips the Marine Corps and several air forces. Its direct descendant, the 25% larger **Super Hornet**, replaced the F-14 Tomcat aboard US carriers.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1975-01-01',
    '1978-11-18',
    '1983-01-07',
    1915.0,
    3330.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric F404')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'AIM-120 AMRAAM')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'AGM-84 Harpoon')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'AGM-88 HARM')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM missions WHERE name = 'Escorte'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.07,
  wingspan          = 11.43,
  height            = 4.66,
  wing_area         = 37.16,
  empty_weight      = 10433,
  mtow              = 23541,
  service_ceiling   = 15240,
  climb_rate        = 254,
  g_limit_pos       = 7.5,
  g_limit_neg       = -3.0,
  combat_radius     = 740,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-402',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 48.9,
  thrust_wet        = 78.7,

  -- Strate 3 : production & service
  production_start  = 1978,
  production_end    = 2000,
  units_built       = 1480,
  unit_cost_usd     = 29000000,
  unit_cost_year    = 1998,
  operators_count   = 8,
  variants          = E'- **F/A-18A/B** : première génération, monoplace et biplace\n- **F/A-18C/D** : avionique et armement modernisés, capacité tout-temps\n- **CF-188** : version canadienne\n- **EF-18A Hornet** : version espagnole',
  variants_en       = E'- **F/A-18A/B** : first generation, single- and two-seat\n- **F/A-18C/D** : upgraded avionics and weapons, all-weather capability\n- **CF-188** : Canadian version\n- **EF-18A Hornet** : Spanish version',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_F/A-18_Hornet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_F/A-18_Hornet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Cmdr. John Leenhouts, USN',
  image_licence     = 'Public domain'
WHERE name = 'F/A-18 Hornet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F/A-18 Hornet';
