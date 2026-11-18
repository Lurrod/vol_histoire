-- Radioplane SD-1 Observer / MQM-57 Falconer
--
-- Photo : Northrop Shelduck D.1 ‘XT581’ (39520049754).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Northrop_Shelduck_D.1_%E2%80%98XT581%E2%80%99_(39520049754).jpg

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
    'Radioplane MQM-57 Falconer',
    'Radioplane MQM-57 Falconer',
    'Radioplane SD-1 Observer / MQM-57 Falconer',
    'Radioplane SD-1 Observer / MQM-57 Falconer',
    'Un drone-cible reconverti en éclaireur photographe : l''un des premiers drones de reconnaissance du champ de bataille',
    'A target drone turned photographic scout: one of the first battlefield reconnaissance drones',
    '/assets/airplanes/mqm57-falconer.jpg',
    E'## Genèse\nAprès la Seconde Guerre mondiale, la **Radioplane Company** prolonge le succès de son drone-cible **OQ-2** par une famille de cibles à moteur à pistons, connue plus tard sous le nom de **Basic Training Target** (BTT) : l''**OQ-19** de l''US Army, le **KD2R Quail** de l''US Navy, puis le **Shelduck**. En 1952, **Northrop** rachète Radioplane, qui devient sa division de Ventura. De cette même cellule naît une variante d''un genre nouveau, conçue non pour être abattue mais pour observer le champ de bataille : le **RP-71**, appelé **SD-1 Observer**, puis plus tard **MQM-57 Falconer**. Il vole pour la première fois en 1955.\n\n## Conception\nLe Falconer ressemble beaucoup au Shelduck, avec un fuselage un peu plus long et plus trapu. La différence est à l''intérieur : un pilote automatique, secondé par une radiocommande de secours, lui permet de suivre un itinéraire, et il emporte des appareils photographiques ainsi que des fusées éclairantes pour la reconnaissance de nuit. Le matériel se charge par une bosse placée sur le dos, entre les ailes. Comme ses cousins cibles, c''est un petit monoplan à moteur à pistons, sans équipage. Son défaut tient en un chiffre : à peine plus d''une demi-heure d''autonomie, ce qui limite fortement son intérêt.\n\n## Carrière opérationnelle\nMalgré cette endurance réduite, environ 1 500 Falconer sont construits. L''appareil sert dans plusieurs armées à travers le monde et reste en service jusque dans les années 1970. L''armée britannique l''emploie sous la désignation SD-1 : l''exemplaire **XT581**, offert par l''Army en 1978 et restauré dans les années 1990, est exposé à l''Imperial War Museum de Duxford, et un MQM-57 figure au musée national de l''US Air Force à Dayton. La famille dont il est issu connaît, elle, une longévité exceptionnelle : les cibles BTT restent en service jusqu''à la fin du XXᵉ siècle.\n\n## Place dans l''histoire\nLe Falconer appartient à la génération qui a compris qu''un avion sans pilote pouvait faire autre chose que servir de cible : regarder à la place d''un homme, sans risquer sa vie. Son autonomie dérisoire montre le chemin qui restait à parcourir jusqu''aux drones à liaison vidéo. Avec plus de 76 000 exemplaires de tous modèles, la famille BTT dont il est issu reste l''aéronef le plus construit de l''histoire, utilisé par au moins dix-huit pays.',
    E'## Genesis\nAfter the Second World War the **Radioplane Company** followed up the success of its **OQ-2** target drone with a family of piston-engined targets, later known as the **Basic Training Target** (BTT): the US Army''s **OQ-19**, the US Navy''s **KD2R Quail**, then the **Shelduck**. In 1952 **Northrop** bought Radioplane, which became its Ventura division. From the same airframe came a variant of a new kind, designed not to be shot down but to watch the battlefield: the **RP-71**, called the **SD-1 Observer**, and later the **MQM-57 Falconer**. It first flew in 1955.\n\n## Design\nThe Falconer looked very much like the Shelduck, with a slightly longer and stockier fuselage. The difference lay inside: an autopilot, backed up by radio control, let it follow a route, and it carried cameras as well as illumination flares for night reconnaissance. Equipment was loaded through a hump on the back, between the wings. Like its target cousins, it was a small unmanned piston-engined monoplane. Its weakness can be summed up in one figure: an endurance of little more than half an hour, which severely limited its usefulness.\n\n## Operational career\nDespite this short endurance, about 1,500 Falconers were built. The type served with several armed forces around the world and remained in service into the 1970s. The British Army used it under the designation SD-1: airframe **XT581**, given by the Army in 1978 and restored in the 1990s, is displayed at the Imperial War Museum Duxford, and an MQM-57 is on show at the National Museum of the United States Air Force in Dayton. The family it came from enjoyed exceptional longevity: the BTT targets remained in service until the end of the twentieth century.\n\n## Place in history\nThe Falconer belongs to the generation that understood that an aircraft without a pilot could do more than serve as a target: it could look in place of a man, without risking his life. Its derisory endurance shows how far there was still to go before drones with a video link. With more than 76,000 built across all models, the BTT family it came from remains the most produced aircraft in history, used by at least eighteen countries.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1955-01-01',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Radioplane MQM-57 Falconer'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = NULL,
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1500,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **OQ-19 / KD2R Quail** : drones-cibles de la famille BTT dont il dérive, à la fin des années 1940\n- **RP-71 / SD-1 Observer** : désignation d''origine de la version de reconnaissance, premier vol en 1955\n- **MQM-57 Falconer** : désignation ultérieure, environ 1 500 construits, en service jusque dans les années 1970\n- **MQM-36 Shelduck** : cousin cible de l''US Navy, à lentilles de Luneburg en bout d''aile',
  variants_en       = E'- **OQ-19 / KD2R Quail**: target drones of the BTT family it was derived from, in the late 1940s\n- **RP-71 / SD-1 Observer**: original designation of the reconnaissance version, first flight in 1955\n- **MQM-57 Falconer**: later designation, about 1,500 built, in service into the 1970s\n- **MQM-36 Shelduck**: US Navy target cousin, with Luneburg lenses in the wingtips',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Radioplane_BTT',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Radioplane MQM-57 Falconer';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Radioplane MQM-57 Falconer';
