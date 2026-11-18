-- Bartini-Beriev VVA-14
--
-- Photo : Beriev VVA-14 in 2010.jpg
--   licence CC BY-SA 3.0 — Alex Beltyukov
--   https://commons.wikimedia.org/wiki/File:Beriev_VVA-14_in_2010.jpg

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
    'Bartini-Beriev VVA-14',
    'Bartini-Beriev VVA-14',
    'Bartini-Beriev VVA-14',
    'Bartini-Beriev VVA-14',
    'Amphibie à effet de sol conçu pour chasser les sous-marins Polaris, qui ne reçut jamais ses réacteurs de sustentation',
    'A ground-effect amphibian designed to hunt Polaris submarines, which never received its lift engines',
    '/assets/airplanes/bartini-vva14.jpg',
    E'## Genèse\nAu début des années 1970, l''ingénieur **Robert Bartini** imagine un appareil capable de détruire les sous-marins lanceurs d''engins américains armés de missiles **Polaris**. Le **VVA-14**, pour « amphibie à décollage vertical », devait décoller de l''eau, franchir de longues distances à grande vitesse et en altitude, mais aussi voler efficacement juste au-dessus de la mer grâce à l''effet de sol. Avec le bureau d''études **Beriev**, Bartini prévoit trois étapes : le VVA-14M1, banc d''essai aérodynamique et technologique, le M2, doté de moteurs de sustentation et de commandes électriques, et le M3, entièrement armé et équipé du système de lutte anti-sous-marine **Burevestnik** et d''un détecteur d''anomalies magnétiques.\n\n## Conception\nLe VVA-14 porte deux grands flotteurs aux extrémités de la section centrale de son aile, sous laquelle l''air doit être comprimé pour décoller et voler en effet de sol. Il est propulsé en croisière par deux réacteurs à double flux **Soloviev D-30M** de 67 kN chacun. Pour la version à décollage vertical, une batterie de douze réacteurs de sustentation **RD-36-35PR** devait être logée dans l''appareil, et des moteurs de démarrage devaient souffler sous l''aile pour créer un coussin d''air. Le projet étant secret, l''avion est peint aux couleurs d''**Aeroflot**, avec une immatriculation civile.\n\n## Essais\nAprès des recherches menées notamment sur le petit prototype à effet de sol **Be-1**, le premier VVA-14 est achevé en 1972 et vole le 4 septembre depuis une piste classique. Des flotteurs gonflables sont installés en 1974, non sans difficultés, et les essais en vol de l''amphibie commencent le 11 juin 1975. Les flotteurs sont ensuite remplacés par des flotteurs rigides, le fuselage est allongé et les moteurs de démarrage sont ajoutés : c''est le **14M1P**. Mais les douze réacteurs de sustentation ne sont jamais livrés, si bien que le décollage vertical ne peut être essayé ; après la mort de Bartini, en 1974, le projet ralentit puis s''éteint, au terme de 107 vols et 103 heures de vol.\n\n## Place dans l''histoire\nLe VVA-14 a tenté de réunir en un seul appareil l''avion, l''hydravion et l''engin à effet de sol, sans dépasser le stade des essais. Le dernier exemplaire est envoyé en 1987 au musée central des forces aériennes de Monino, où des accidents survenus pendant le transport l''endommagent sans qu''il soit réparé. Il y repose démonté, toujours dans sa livrée d''Aeroflot.',
    E'## Genesis\nIn the early 1970s designer **Robert Bartini** conceived an aircraft able to destroy the US Navy''s **Polaris** missile submarines. The **VVA-14**, for ''vertical take-off amphibian'', was to take off from water, cover long distances at high speed and altitude, and also fly efficiently just above the sea using ground effect. With the **Beriev** design bureau, Bartini planned three phases: the VVA-14M1, an aerodynamics and technology testbed, the M2, with lift engines and fly-by-wire controls, and the M3, fully armed and fitted with the **Burevestnik** anti-submarine system and a magnetic anomaly detector.\n\n## Design\nThe VVA-14 carried two large pontoons at the ends of its centre wing section, beneath which air was to be compressed for take-off and ground-effect flight. Cruise power came from two **Soloviev D-30M** turbofans of 67 kN each. For the vertical take-off version, a battery of twelve **RD-36-35PR** lift engines was to be installed, and starting engines were to blast air under the wing to create a cushion. Because the project was secret, the aircraft wore **Aeroflot** colours and a civil registration.\n\n## Testing\nAfter research that included the small **Be-1** ground-effect prototype, the first VVA-14 was completed in 1972 and flew on 4 September from a conventional runway. Inflatable pontoons were fitted in 1974, causing many problems, and flight testing of the amphibian began on 11 June 1975. The pontoons were later replaced by rigid ones, the fuselage was lengthened and the starting engines were added, producing the **14M1P**. But the twelve lift engines were never delivered, so vertical take-off could not be tested; after Bartini''s death in 1974 the project slowed and petered out, after 107 flights and 103 flight hours.\n\n## Place in history\nThe VVA-14 tried to combine an aircraft, a flying boat and a ground-effect craft in one machine, without getting beyond the test stage. The last example was sent in 1987 to the Central Air Force Museum at Monino, where accidents during transport damaged it and it was never repaired. It still lies there dismantled, in its Aeroflot markings.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1972-09-04',
    NULL,
    760,
    2450,
    (SELECT id FROM manufacturer WHERE code = 'BER'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bartini-Beriev VVA-14'), (SELECT id FROM tech WHERE name = 'Vol en effet de sol')),
((SELECT id FROM airplanes WHERE name = 'Bartini-Beriev VVA-14'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bartini-Beriev VVA-14'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 25.97,
  wingspan          = 30,
  height            = 6.79,
  wing_area         = 217.79,
  empty_weight      = 23236,
  mtow              = 52000,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Soloviev D-30M',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 67.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **VVA-14M1** : banc d''essai aérodynamique et technologique, flotteurs rigides puis gonflables, premier vol le 4 septembre 1972\n- **14M1P** : flotteurs rigides, fuselage allongé, moteurs de démarrage soufflant sous l''aile\n- **VVA-14M2** : version à décollage vertical prévue, douze réacteurs RD-36-35PR et commandes électriques, jamais réalisée\n- **VVA-14M3** : version opérationnelle prévue, armée, système anti-sous-marin Burevestnik et détecteur Bor-1, jamais réalisée',
  variants_en       = E'- **VVA-14M1**: aerodynamics and technology testbed, rigid then inflatable pontoons, first flight on 4 September 1972\n- **14M1P**: rigid pontoons, lengthened fuselage, starting engines blowing under the wing\n- **VVA-14M2**: planned vertical take-off version, twelve RD-36-35PR engines and fly-by-wire, never built\n- **VVA-14M3**: planned operational version, armed, with the Burevestnik anti-submarine system and Bor-1 detector, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bartini_Beriev_VVA-14',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bartini_Beriev_VVA-14',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alex Beltyukov',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Bartini-Beriev VVA-14';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bartini-Beriev VVA-14';
