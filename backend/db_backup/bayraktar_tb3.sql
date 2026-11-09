-- Baykar Bayraktar TB3
--
-- Photo : Baykar Bayraktar TB3 Teknofest 2025.jpg
--   licence CC0 — Carl9311
--   https://commons.wikimedia.org/wiki/File:Baykar_Bayraktar_TB3_Teknofest_2025.jpg

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
    'Bayraktar TB3',
    'Bayraktar TB3',
    'Baykar Bayraktar TB3',
    'Baykar Bayraktar TB3',
    'Le TB2 aux ailes repliables, conçu pour décoller et apponter sur le pont court du TCG Anadolu',
    'The TB2 with folding wings, designed to take off from and land on the short deck of the TCG Anadolu',
    '/assets/airplanes/bayraktar-tb3.jpg',
    E'## Genèse\nLe **TCG Anadolu**, navire d''assaut amphibie de la marine turque, devait embarquer des F-35B. L''exclusion de la Turquie du programme F-35, en juillet 2019, le laisse sans avion de combat. **Baykar** propose d''en faire un porte-drones et dévoile le 29 octobre 2020 le projet TB3 : une version navalisée de son **Bayraktar TB2**, capable d''opérer depuis un pont court sans catapulte ni brins d''arrêt.\n\n## Conception\nLa formule reste celle du TB2 — longue aile droite, moteur à pistons et hélice propulsive —, mais l''appareil est plus lourd, avec une masse maximale de 1 450 kg et une charge utile de 280 kg. Ses **ailes repliables** réduisent l''encombrement dans le hangar du navire, et sa cellule est renforcée pour les appontages. Six points d''emport acceptent les munitions légères de Roketsan, comme la **MAM-L**. Le moteur est un diesel turc **TEI PD170**. Une liaison satellite permet d''opérer au-delà de la portée radio du navire.\n\n## Carrière opérationnelle\nPremier vol le **27 octobre 2023**. Le **19 novembre 2024**, un TB3 décolle du TCG Anadolu et y apponte : Baykar présente l''événement comme le premier décollage et le premier appontage d''un drone de cette taille sur un pont court. Les premières livraisons aux forces turques sont annoncées pour 2025. En février 2025, l''Indonésie en commande soixante exemplaires, selon Baykar. Aucun emploi au combat n''est connu à la date de rédaction.\n\n## Place dans l''histoire\nLe TB3 transforme un navire privé de son avion en porte-drones, une solution qu''aucune grande marine n''avait encore adoptée à cette échelle. Il partage le pont de l''Anadolu avec le **Bayraktar Kızılelma**, que Baykar destine au même navire. Il prolonge la famille ouverte par le TB2, dont il reprend l''essentiel, et montre qu''un navire dépourvu de catapulte peut mettre en œuvre des drones armés de taille moyenne.',
    E'## Genesis\nThe **TCG Anadolu**, the Turkish navy''s amphibious assault ship, was meant to embark F-35Bs. Turkey''s exclusion from the F-35 programme in July 2019 left it without a combat aircraft. **Baykar** offered to turn it into a drone carrier and unveiled the TB3 project on 29 October 2020: a navalised version of its **Bayraktar TB2**, able to operate from a short deck without catapult or arrester wires.\n\n## Design\nThe layout remains that of the TB2 — long straight wing, piston engine and pusher propeller — but the aircraft is heavier, with a maximum weight of 1,450 kg and a payload of 280 kg. Its **folding wings** reduce the space it takes in the ship''s hangar, and its airframe is strengthened for deck landings. Six hardpoints accept light Roketsan munitions such as the **MAM-L**. The engine is a Turkish **TEI PD170** diesel. A satellite link allows operation beyond the ship''s radio range.\n\n## Operational career\nFirst flight on **27 October 2023**. On **19 November 2024** a TB3 took off from the TCG Anadolu and landed back on it: Baykar presented the event as the first take-off and deck landing of a drone of this size on a short deck. First deliveries to the Turkish forces were announced for 2025. In February 2025 Indonesia ordered sixty, according to Baykar. No combat use was known at the time of writing.\n\n## Place in history\nThe TB3 turns a ship deprived of its aircraft into a drone carrier, a solution no major navy had yet adopted on this scale. It shares the Anadolu''s deck with the **Bayraktar Kızılelma**, which Baykar intends for the same ship. It extends the family begun by the TB2, from which it takes most of its design, and shows that a ship without catapults can operate medium-sized armed drones.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2020-10-29',
    '2023-10-27',
    NULL,
    300.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BAY'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM armement WHERE name = 'MAM-L'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar TB3'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.35,
  wingspan          = 14.0,
  height            = 2.6,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1450,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'TEI PD170',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **TB3** : version navalisée du **Bayraktar TB2**, présentée le 29 octobre 2020\n- **Ailes repliables** et cellule renforcée pour les appontages\n- Premier vol le **27 octobre 2023**, premier décollage et appontage sur le **TCG Anadolu** le 19 novembre 2024\n- Six points d''emport pour munitions légères Roketsan\n- Soixante exemplaires commandés par l''**Indonésie** en février 2025, selon Baykar',
  variants_en       = E'- **TB3** : navalised version of the **Bayraktar TB2**, unveiled on 29 October 2020\n- **Folding wings** and an airframe strengthened for deck landings\n- First flight on **27 October 2023**, first take-off and deck landing on the **TCG Anadolu** on 19 November 2024\n- Six hardpoints for light Roketsan munitions\n- Sixty ordered by **Indonesia** in February 2025, according to Baykar',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Baykar_Bayraktar_TB3',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Baykar_Bayraktar_TB3',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Carl9311',
  image_licence     = 'CC0'
WHERE name = 'Bayraktar TB3';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bayraktar TB3';
