-- Antonov An-225 Mriya (Cossack)
--
-- Photo : Antonov Airlines Antonov An-225 Mriya UR-82060 Perth, 2016 (01).JPG
--   licence CC BY-SA 4.0 — Bahnfrend
--   https://commons.wikimedia.org/wiki/File:Antonov_Airlines_Antonov_An-225_Mriya_UR-82060_Perth,_2016_(01).JPG

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
    'Antonov An-225 Mriya',
    'Antonov An-225 Mriya',
    'Antonov An-225 Mriya (Cossack)',
    'Antonov An-225 Mriya (Cossack)',
    'Six réacteurs, 640 tonnes : l’avion le plus lourd jamais construit, détruit à Hostomel',
    'Six engines, 640 tonnes: the heaviest aircraft ever built, destroyed at Hostomel',
    '/assets/airplanes/an225-mriya.jpg',
    E'## Genèse\nPour son programme de navette **Bourane**, l''URSS doit transporter par air l''orbiteur et les éléments de la fusée **Energia**. Le **VM-T Atlant**, tiré du bombardier **Myasishchev M-4**, n''y suffit plus. En 1984, Antonov reçoit la commande d''un avion capable d''emporter 250 tonnes. Le bureau de Kiev, sous la direction de **Viktor Tolmatchev**, part de l''appareil qu''il vient de concevoir : l''**An-124 Ruslan**.\n\n## Conception\nLe fuselage est allongé à l''avant et à l''arrière, l''aile reçoit un nouveau caisson central qui porte deux réacteurs **D-18T** de plus — six au total. La dérive unique cède la place à un empennage bidérive, indispensable pour que les turbulences d''une charge portée sur le dos ne frappent pas la queue. La rampe arrière de l''An-124 disparaît pour gagner du poids. Commandes de vol électriques, 32 roues, une soute de 43 m de long : 640 tonnes au décollage après les modifications de 2000-2001.\n\n## Carrière opérationnelle\nPremier vol le 21 décembre 1988 ; en 1989, il présente Bourane sur son dos au Salon du Bourget. La fin de l''URSS le laisse sans emploi : stocké en 1994, il cède ses moteurs à des An-124. Remis en état, il reprend du service chez Antonov Airlines en janvier 2002. Il emporte 253,8 tonnes en 2001, la plus lourde charge unique jamais transportée par avion en 2009, et totalise quelque 240 records. Le 24 février 2022, l''aéroport d''Hostomel est l''un des premiers objectifs russes ; l''appareil, immobilisé pour un changement de moteur, brûle dans son hangar. Sa destruction est confirmée le 27 février.\n\n## Place dans l''histoire\nUn seul exemplaire. L''An-225 reste l''avion le plus lourd jamais construit et celui de la plus grande envergure ayant volé en service. La fiche de l''**An-124** rappelle sa fin. Un second fuselage, achevé aux deux tiers selon les estimations, est resté intact à Kiev ; l''Ukraine a annoncé vouloir le terminer, sans échéance ni financement assurés.',
    E'## Genesis\nFor its **Buran** shuttle programme the USSR needed to carry the orbiter and the components of the **Energia** rocket by air. The **VM-T Atlant**, derived from the **Myasishchev M-4** bomber, was no longer enough. In 1984 Antonov was ordered to build an aircraft able to lift 250 tonnes. The Kyiv bureau, led by **Viktor Tolmachev**, started from the aircraft it had just designed: the **An-124 Ruslan**.\n\n## Design\nThe fuselage was stretched fore and aft, and the wing received a new centre section carrying two more **D-18T** engines — six in all. The single fin gave way to a twin tail, essential so that the turbulence from a load carried on the back would not strike the empennage. The An-124''s rear ramp was deleted to save weight. Fly-by-wire controls, 32 wheels, a 43 m hold: 640 tonnes at take-off after the 2000-2001 modifications.\n\n## Operational career\nFirst flight on 21 December 1988; in 1989 it showed Buran on its back at the Paris Air Show. The end of the USSR left it without a job: stored in 1994, it gave up its engines to An-124s. Restored, it returned to service with Antonov Airlines in January 2002. It lifted 253.8 tonnes in 2001, the heaviest single item ever carried by air in 2009, and set some 240 records in all. On 24 February 2022 Hostomel airport was one of the first Russian objectives; the aircraft, grounded for an engine change, burned in its hangar. Its destruction was confirmed on 27 February.\n\n## Place in history\nA single example. The An-225 remains the heaviest aircraft ever built and the one with the largest wingspan to have flown in service. The **An-124** entry recalls its end. A second fuselage, about two-thirds complete by most estimates, survived intact in Kyiv; Ukraine has announced it wants to finish it, with neither a date nor funding secured.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1984-01-01',
    '1988-12-21',
    '1989-01-01',
    850.0,
    15400.0,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-225 Mriya'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-225 Mriya'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-225 Mriya'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-225 Mriya'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-225 Mriya'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 84.0,
  wingspan          = 88.4,
  height            = 18.1,
  wing_area         = 905.0,
  empty_weight      = 285000,
  mtow              = 640000,
  service_ceiling   = 11000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Progress D-18T',
  engine_count      = 6,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 229.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1985,
  production_end    = 1988,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **An-225** : exemplaire unique, immatriculé CCCP-82060 puis UR-82060\n- **Second fuselage** : construction suspendue à la fin de l''URSS, achevé aux deux tiers environ\n- **Charge dorsale** : jusqu''à 200 tonnes et 70 m de long, Bourane compris\n- **An-325** : projet à huit moteurs pour le lancement aérien d''un avion spatial, jamais réalisé\n- Dérivé de l''**An-124 Ruslan** : fuselage allongé, six réacteurs, empennage bidérive, sans rampe arrière',
  variants_en       = E'- **An-225** : sole example, registered CCCP-82060 then UR-82060\n- **Second fuselage** : construction suspended at the end of the USSR, about two-thirds complete\n- **Dorsal load** : up to 200 tonnes and 70 m long, Buran included\n- **An-325** : eight-engined project for air-launching a spaceplane, never built\n- Derived from the **An-124 Ruslan** : stretched fuselage, six engines, twin tail, no rear ramp',

  -- Strate 4 : qualitatif
  nickname          = 'Cossack',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-225_Mriya',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-225_Mriya',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bahnfrend',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Antonov An-225 Mriya';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-225 Mriya';
