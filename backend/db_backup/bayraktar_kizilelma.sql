-- Baykar Bayraktar Kızılelma
--
-- Photo : Bayraktar Kızılelma on the deck of TCG Anadolu (L-400) - 1.jpg
--   licence CC BY-SA 4.0 — Ata Barış
--   https://commons.wikimedia.org/wiki/File:Bayraktar_K%C4%B1z%C4%B1lelma_on_the_deck_of_TCG_Anadolu_(L-400)_-_1.jpg

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
    'Bayraktar Kızılelma',
    'Bayraktar Kızılelma',
    'Baykar Bayraktar Kızılelma',
    'Baykar Bayraktar Kızılelma',
    'Le chasseur sans pilote d’un industriel privé, né de l’exclusion turque du F-35',
    'A private firm’s pilotless fighter, born of Turkey’s exclusion from the F-35',
    '/assets/airplanes/bayraktar-kizilelma.jpg',
    E'## Genèse\n**Baykar**, l''entreprise familiale qui a fait fortune avec le **Bayraktar TB2**, lance dès 2013 des études sur un drone à réaction. Le projet prend une autre dimension en juillet 2019, quand la Turquie est exclue du programme **F-35** après l''achat de systèmes antiaériens russes S-400 : l''aviation turque perd son futur chasseur, la marine l''avion qu''elle comptait embarquer sur le porte-aéronefs **TCG Anadolu**. Baykar propose un « chasseur sans pilote », le Kızılelma — la « pomme rouge », image de l''horizon à conquérir dans la tradition turque.\n\n## Conception\nUne cellule de quatorze mètres et demi, deux dérives inclinées et une **soute interne** : la forme cherche à réduire la signature radar, sans prétendre à la furtivité d''un appareil de cinquième génération. Les prototypes volent avec un turbofan ukrainien **Ivtchenko-Progress AI-25TLT** de 16,9 kN, dépourvu de postcombustion ; une motorisation plus puissante est prévue pour les versions suivantes. La masse maximale annoncée atteint 8,5 tonnes, dont 1,5 tonne de charge utile. L''appareil vole en haut subsonique et doit pouvoir décoller d''un pont court.\n\n## Carrière opérationnelle\nPremier vol le **14 décembre 2022** à Çorlu. Cinq prototypes suivent, puis les premiers exemplaires de série. Fin novembre 2025, Baykar annonce un tir de missile air-air **Gökdoğan** au-delà de la portée visuelle contre une cible aérienne, présenté comme une première pour un appareil sans équipage ; en décembre, deux Kızılelma volent en formation sous contrôle autonome. Les premières livraisons à l''aviation turque étaient annoncées pour 2026. Aucun emploi au combat n''est connu.\n\n## Place dans l''histoire\nLe Kızılelma illustre un basculement : un industriel privé d''une puissance moyenne propose un avion de combat sans pilote avant les grands avionneurs occidentaux. Ses performances réelles restent celles qu''annonce son constructeur. Il rejoint au catalogue les autres ailiers sans pilote de sa génération — le **MQ-28 Ghost Bat** australien, le **XQ-58 Valkyrie** américain — et prolonge la lignée turque ouverte par le TB2 et l''Akıncı.',
    E'## Genesis\n**Baykar**, the family firm that made its fortune with the **Bayraktar TB2**, began studies on a jet-powered drone in 2013. The project took on another dimension in July 2019, when Turkey was removed from the **F-35** programme after buying Russian S-400 air defence systems: the Turkish air force lost its future fighter, and the navy the aircraft it meant to embark on the **TCG Anadolu**. Baykar offered a "pilotless fighter", the Kızılelma — the "red apple", the image of the horizon to be conquered in Turkish tradition.\n\n## Design\nA fourteen-and-a-half-metre airframe, two canted fins and an **internal bay**: the shape aims to reduce the radar signature without claiming the stealth of a fifth-generation aircraft. The prototypes fly on a Ukrainian **Ivchenko-Progress AI-25TLT** turbofan of 16.9 kN, without afterburner; more powerful engines are planned for later versions. The announced maximum weight is 8.5 tonnes, including 1.5 tonnes of payload. The aircraft flies at high subsonic speed and is meant to take off from a short deck.\n\n## Operational career\nFirst flight on **14 December 2022** at Çorlu. Five prototypes followed, then the first production aircraft. At the end of November 2025 Baykar announced a beyond-visual-range firing of a **Gökdoğan** air-to-air missile against an aerial target, presented as a first for an uncrewed aircraft; in December two Kızılelmas flew in formation under autonomous control. First deliveries to the Turkish air force were announced for 2026. No combat use is known.\n\n## Place in history\nThe Kızılelma marks a shift: a private manufacturer from a middle power offering a pilotless combat aircraft ahead of the major Western airframers. Its real performance remains what its maker announces. In this catalogue it joins the other uncrewed wingmen of its generation — Australia''s **MQ-28 Ghost Bat** and America''s **XQ-58 Valkyrie** — and extends the Turkish line opened by the TB2 and the Akıncı.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2013-01-01',
    '2022-12-14',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BAY'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM armement WHERE name = 'Gökdoğan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Bayraktar Kızılelma'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.5,
  wingspan          = 10.0,
  height            = 3.5,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 8500,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Ivtchenko-Progress AI-25TLT',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 16.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **PT-1 à PT-5** : cinq prototypes, premier vol le **14 décembre 2022**\n- **Kızılelma A** : version subsonique initiale, turbofan **AI-25TLT** sans postcombustion\n- Versions ultérieures annoncées avec une motorisation plus puissante\n- Conçu pour opérer depuis le porte-aéronefs **TCG Anadolu**\n\n*Programme en cours : les performances publiées sont celles qu''annonce le constructeur.*',
  variants_en       = E'- **PT-1 to PT-5** : five prototypes, first flight on **14 December 2022**\n- **Kızılelma A** : initial subsonic version, **AI-25TLT** turbofan without afterburner\n- Later versions announced with a more powerful engine\n- Designed to operate from the **TCG Anadolu** aircraft-carrying ship\n\n*Programme in progress: published performance figures are those announced by the manufacturer.*',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bayraktar_K%C4%B1z%C4%B1lelma',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ata Barış',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Bayraktar Kızılelma';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'Bayraktar Kızılelma';
