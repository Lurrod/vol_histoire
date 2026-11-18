-- AeroVironment RQ-11 Raven
--
-- Photo : Hoplites conduct Raven standardization flight evaluations at DPTA (6804889).jpg
--   licence Public domain — Staff Sgt. Jennifer Reynolds, U.S. Army
--   https://commons.wikimedia.org/wiki/File:Hoplites_conduct_Raven_standardization_flight_evaluations_at_DPTA_(6804889).jpg

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
    'AeroVironment RQ-11 Raven',
    'AeroVironment RQ-11 Raven',
    'AeroVironment RQ-11 Raven',
    'AeroVironment RQ-11 Raven',
    'Lancé à la main comme un planeur de modéliste, le drone le plus répandu au monde a donné des yeux à l''infanterie',
    'Thrown by hand like a model glider, the world''s most widely used drone gave infantry companies their own eyes in the sky',
    '/assets/airplanes/rq11-raven.jpg',
    E'## Genèse\nLes grands drones de reconnaissance servent les états-majors ; le fantassin, lui, veut savoir ce qui se cache derrière la colline suivante. **AeroVironment** répond par une version réduite de son drone **FQM-151 Pointer**, présenté en 1999, qui prend sa forme actuelle en 2002 sous le nom de **Raven**. Le premier vol a lieu en octobre 2001 et l''appareil entre en service en mai 2003. Vainqueur en 2005 du programme de petit drone de l''US Army, le **RQ-11B** passe en production à pleine cadence en 2006, adopté aussitôt par les Marines et l''US Air Force.\n\n## Conception\nLe Raven ressemble à un grand modèle réduit de vol libre : 1,37 m d''envergure, 0,91 m de long et 1,9 kg. Un soldat le lance à bout de bras ; un moteur électrique à hélice propulsive l''emmène à 32 à 81 km/h, entre 100 et 500 m au-dessus du sol, pour 60 à 90 minutes de vol dans un rayon d''une dizaine de kilomètres. Il se pilote depuis une station au sol ou suit seul un itinéraire GPS ; une seule touche le ramène à son point de départ. Pour se poser, il rejoint un point choisi et descend selon une pente de 45 degrés. Il emporte une caméra couleur de jour ou une caméra infrarouge de nuit.\n\n## Carrière opérationnelle\nL''US Army le déploie au niveau de la compagnie. Les forces britanniques l''emploient en **Irak**, les Danois dans la province d''Helmand en **Afghanistan**, comme le montre le documentaire **Armadillo** en 2010. Début 2012, plus de 19 000 cellules ont été livrées, ce qui en fait le système de drone le plus répandu au monde. Les Pays-Bas achètent 72 systèmes, le Pakistan 85 en 2011. En Ukraine, ses utilisateurs reprochent à sa liaison analogique d''être brouillée et piratée par les séparatistes du **Donbass** soutenus par la Russie. En 2015, une caméra sur nacelle orientable à 360 degrés remplace la caméra fixe, qui obligeait à manœuvrer l''avion pour observer.\n\n## Place dans l''histoire\nLe Raven a fait du drone un équipement individuel, porté dans le sac, plutôt qu''un moyen rare réservé aux échelons supérieurs. Plus de trente pays l''ont adopté, de la Belgique à l''Ouzbékistan. En 2012, une version solaire gagne 60 % d''endurance grâce à des cellules intégrées à l''aile. En janvier 2023, les Marines le retirent au profit d''un drone à décollage vertical, plus simple à lancer et à récupérer, capable de rester en vol stationnaire.',
    E'## Genesis\nLarge reconnaissance drones serve headquarters; the infantryman wants to know what lies behind the next hill. **AeroVironment** answered with a scaled-down version of its **FQM-151 Pointer** drone, introduced in 1999, which took its current form in 2002 under the name **Raven**. It first flew in October 2001 and entered service in May 2003. Winner of the US Army''s small drone programme in 2005, the **RQ-11B** went into full-rate production in 2006 and was soon adopted by the Marines and the US Air Force.\n\n## Design\nThe Raven looks like a large free-flight model aircraft: a 1.37 m span, 0.91 m long and 1.9 kg. A soldier throws it into the air; an electric motor driving a pusher propeller carries it at 32 to 81 km/h, 100 to 500 m above the ground, for 60 to 90 minutes within a radius of about ten kilometres. It can be flown from a ground station or follow a GPS route on its own; a single button brings it back to its launch point. To land, it flies to a chosen point and descends along a 45-degree slope. It carries a colour daylight camera or an infrared night camera.\n\n## Operational career\nThe US Army fields it at company level. British forces used it in **Iraq**, and the Danes in Helmand province, **Afghanistan**, as shown in the 2010 documentary **Armadillo**. By early 2012 more than 19,000 airframes had been delivered, making it the most widely adopted drone system in the world. The Netherlands bought 72 systems, Pakistan 85 in 2011. In Ukraine, its operators complained that its analogue link was jammed and hacked by the Russian-backed separatists of the **Donbas**. In 2015 a camera on a 360-degree gimbal replaced the fixed camera, which had forced the operator to manoeuvre the aircraft to observe.\n\n## Place in history\nThe Raven turned the drone into a piece of individual kit, carried in a backpack, rather than a scarce asset reserved for higher echelons. More than thirty countries adopted it, from Belgium to Uzbekistan. In 2012 a solar version gained 60% more endurance thanks to cells built into the wing. In January 2023 the Marines retired it in favour of a vertical take-off drone, easier to launch and recover, able to hover and stare.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '2001-10-01',
    '2003-05-01',
    81,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'AV'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-11 Raven'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-11 Raven'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-11 Raven'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-11 Raven'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'AeroVironment RQ-11 Raven'), (SELECT id FROM wars WHERE name = 'Guerre du Donbass'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 0.91,
  wingspan          = 1.37,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1.9,
  service_ceiling   = 4200,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 10,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Aveox 27/26/7-AV',
  engine_count      = 1,
  engine_type       = 'Moteur électrique',
  engine_type_en    = 'Electric motor',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2004,
  production_end    = NULL,
  units_built       = 19000,
  unit_cost_usd     = 25000,
  unit_cost_year    = 2008,
  operators_count   = 33,
  variants          = E'- **RQ-11A Raven A** : première version, qui n''est plus produite\n- **RQ-11B Raven B** : vainqueur du programme SUAV de l''US Army en 2005, version principale, plus tard dotée d''une liaison de données numérique\n- **CU-173 Raven B** : version des Forces armées canadiennes\n- **Solar Raven** : cellules solaires souples intégrées à l''aile en 2012, endurance accrue de 60 %',
  variants_en       = E'- **RQ-11A Raven A**: first version, no longer in production\n- **RQ-11B Raven B**: winner of the US Army SUAV programme in 2005, the main version, later given a digital data link\n- **CU-173 Raven B**: version for the Canadian Armed Forces\n- **Solar Raven**: flexible solar cells built into the wing in 2012, endurance increased by 60%',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/RQ-11_Raven',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/AeroVironment_RQ-11_Raven',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Jennifer Reynolds, U.S. Army',
  image_licence     = 'Public domain'
WHERE name = 'AeroVironment RQ-11 Raven';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AeroVironment RQ-11 Raven';
