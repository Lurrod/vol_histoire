-- Sagem (Safran) Patroller
--
-- Photo : Safran Electronics & Defense Patroller.jpg
--   licence CC BY-SA 4.0 — Guillaume Menard
--   https://commons.wikimedia.org/wiki/File:Safran_Electronics_%26_Defense_Patroller.jpg

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
    'Safran Patroller',
    'Safran Patroller',
    'Sagem (Safran) Patroller',
    'Sagem (Safran) Patroller',
    'Le motoplaneur devenu drone tactique de l''armée de Terre, choisi en 2016 et abandonné dix ans plus tard',
    'The motor glider turned French Army tactical drone, chosen in 2016 and abandoned ten years later',
    '/assets/airplanes/safran-patroller.jpg',
    E'## Genèse\nÀ la fin des années 2000, **Sagem**, futur **Safran Electronics & Defense**, veut un drone de surveillance sans repartir d''une feuille blanche. Plutôt que de dessiner une cellule, il associe une plate-forme existante et éprouvée à ses capteurs et à ses liaisons de données. Il s''adresse pour cela à **Stemme**, constructeur allemand de motoplaneurs, dont le **S15**, version d''observation du biplace S6, est déjà un avion optionnellement piloté, certifié selon les normes européennes. Le **Patroller** effectue son premier vol le 10 juin 2009 à Kemijärvi, en Finlande, et paraît au salon du Bourget la même année.\n\n## Conception\nLe Patroller garde la silhouette de son ancêtre : longue aile de planeur de 18 m, fuselage fin, train tricycle rétractable, moteur **Rotax 914F** entraînant une hélice. Il tient de 20 à 30 heures en l''air et emporte 250 kg de charge utile, dont 80 kg sous chaque aile : boule optronique **Euroflir 410**, équipements d''écoute électronique, radar, et à terme roquettes à guidage laser ou missile antichar **MMP**. Sa certification civile d''origine est son grand atout : en 2014, il démontre qu''il sait s''insérer dans la circulation aérienne, éviter seul un autre avion et effectuer l''approche d''un aéroport civil.\n\n## Carrière opérationnelle\nEn 2014, la direction générale de l''Armement cherche un successeur au **Sperwer**, autre drone de Sagem. Le **Watchkeeper** de Thales part favori, mais le Patroller l''emporte le 20 janvier 2016 : quatorze appareils pour l''**armée de Terre** et le 61e régiment d''artillerie, pour environ 300 millions d''euros avec douze ans de maintenance. Le 6 décembre 2019, un Patroller s''écrase près d''Istres lors d''un vol de réception, et les livraisons glissent. Les premiers vols de formation n''ont lieu qu''en 2024, et la commande, fixée à 28 appareils à l''origine, est ramenée à 14 en 2025.\n\n## Place dans l''histoire\nEn avril 2026, la France abandonne le programme : aux retards techniques s''ajoutent les leçons de la guerre en Ukraine, où l''usure rapide de ce type de drone le rend trop coûteux dans un conflit de haute intensité. Un seul appareil aura été livré au 61e régiment d''artillerie de Chaumont, et la Grèce, premier client à l''export en 2023, réexamine sa commande. Le Patroller reste l''exemple d''un pari raisonnable, adapter un avion certifié, rattrapé par une guerre qui a changé la valeur des drones tactiques.',
    E'## Genesis\nIn the late 2000s **Sagem**, later **Safran Electronics & Defense**, wanted a surveillance drone without starting from a blank sheet. Rather than design an airframe, it combined an existing, proven platform with its own sensors and data links. It turned to **Stemme**, a German maker of motor gliders, whose **S15**, an observation version of the two-seat S6, was already an optionally piloted aircraft certified to European standards. The **Patroller** made its first flight on 10 June 2009 at Kemijärvi, in Finland, and appeared at the Paris Air Show the same year.\n\n## Design\nThe Patroller keeps its ancestor''s lines: a long 18 m glider wing, a slim fuselage, retractable tricycle undercarriage and a **Rotax 914F** engine driving a propeller. It stays aloft for 20 to 30 hours and carries a 250 kg payload, including 80 kg under each wing: a **Euroflir 410** electro-optical ball, electronic intelligence equipment, radar and eventually laser-guided rockets or the **MMP** anti-tank missile. Its original civil certification is its great asset: in 2014 it showed that it could fit into air traffic, avoid another aircraft on its own and fly an approach to a civil airport.\n\n## Operational career\nIn 2014 the French defence procurement agency sought a successor to the **Sperwer**, another Sagem drone. Thales''s **Watchkeeper** started as favourite, but the Patroller won on 20 January 2016: fourteen aircraft for the **French Army** and the 61st Artillery Regiment, for about 300 million euros including twelve years of maintenance. On 6 December 2019 a Patroller crashed near Istres during an acceptance flight, and deliveries slipped. The first training flights only took place in 2024, and the order, originally set at 28 aircraft, was cut to 14 in 2025.\n\n## Place in history\nIn April 2026 France abandoned the programme: on top of technical delays came the lessons of the war in Ukraine, where the rapid attrition of this type of drone makes it too costly in a high-intensity conflict. Only one aircraft was delivered to the 61st Artillery Regiment at Chaumont, and Greece, the first export customer in 2023, is reconsidering its order. The Patroller remains an example of a reasonable bet, adapting a certified aircraft, overtaken by a war that changed the value of tactical drones.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    NULL,
    '2009-06-10',
    NULL,
    314,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SAF'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Safran Patroller'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Safran Patroller'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Safran Patroller'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.5,
  wingspan          = 18,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Rotax 914F',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Stemme S15** : motoplaneur d''observation optionnellement piloté, base de la cellule, essayé avec un pilote de sécurité à bord en 2010\n- **Patroller** : version sans pilote de Safran, système de drone tactique (SDT) de l''armée de Terre\n- **Patroller grec** : quatre drones non armés et trois stations sol commandés en juin 2023 pour remplacer le Sperwer',
  variants_en       = E'- **Stemme S15**: optionally piloted observation motor glider, basis of the airframe, tested with a safety pilot on board in 2010\n- **Patroller**: Safran''s unmanned version, the French Army''s tactical drone system (SDT)\n- **Greek Patroller**: four unarmed drones and three ground stations ordered in June 2023 to replace the Sperwer',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Safran_Patroller',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Safran_Patroller',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Guillaume Menard',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Safran Patroller';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Safran Patroller';
