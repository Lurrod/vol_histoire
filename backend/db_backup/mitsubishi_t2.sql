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
    'Mitsubishi T-2',
    'Mitsubishi T-2',
    'Mitsubishi T-2 (Japan Air Self-Defense Force)',
    'Mitsubishi T-2 (Japan Air Self-Defense Force)',
    'Premier avion d''entraînement supersonique biplace japonais d''après-guerre',
    'First Japanese post-war supersonic two-seat trainer',
    '/assets/airplanes/mitsubishi-t2.jpg',
    'Le Mitsubishi T-2 est le premier avion d''entraînement supersonique japonais d''après-guerre, dérivé conceptuel du SEPECAT Jaguar. Propulsé par deux réacteurs Ishikawajima-Harima TF40-IHI-801A (licence Rolls-Royce/Turbomeca Adour), il a formé la quasi-totalité des pilotes de chasse de la JASDF entre 1975 et 2006. 96 exemplaires produits. Son successeur est le Kawasaki T-4 (subsonique) pour l''entraînement avancé. A servi de base au chasseur F-1.',
    'The Mitsubishi T-2 is Japan''s first post-war supersonic trainer, a conceptual derivative of the SEPECAT Jaguar. Powered by two Ishikawajima-Harima TF40-IHI-801A engines (licence-built Rolls-Royce/Turbomeca Adour), it trained almost all JASDF fighter pilots between 1975 and 2006. 96 examples built. Its successor is the Kawasaki T-4 (subsonic) for advanced training. It served as the basis for the F-1 fighter.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1967-01-01',
    '1971-07-20',
    '1975-03-29',
    1700.0,
    2870.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Insertion des guerres

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 17.86, wingspan = 7.88, height = 4.39, wing_area = 21.17,
  empty_weight = 6307, mtow = 12800, service_ceiling = 15240, climb_rate = 175,
  combat_radius = 560, crew = 2, g_limit_pos = 7.33, g_limit_neg = -3.0,
  engine_name = 'Ishikawajima-Harima TF40-IHI-801A (licence Adour)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 22.8, thrust_wet = 32.5,
  production_start = 1971, production_end = 1988, units_built = 96,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mitsubishi_T-2',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_T-2'
WHERE name = 'Mitsubishi T-2';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 10000000, unit_cost_year = 1980,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **T-2A** : version d''entraînement avancé pilote\n- **T-2B** : version d''entraînement armement\n- **T-2CCV** : prototype de commande de vol électrique (1984), base technologique pour le Mitsubishi F-2\n- **Blue Impulse T-2** : patrouille acrobatique de la JASDF de 1982 à 1995',
  variants_en = E'- **T-2A** : pilot advanced trainer variant\n- **T-2B** : weapons training variant\n- **T-2CCV** : fly-by-wire prototype (1984), technological basis for the Mitsubishi F-2\n- **Blue Impulse T-2** : JASDF aerobatic team from 1982 to 1995'
WHERE name = 'Mitsubishi T-2';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nAu milieu des années 1960, la Force aérienne d''autodéfense japonaise (JASDF) constate que son entraîneur Fuji T-1 ne prépare pas au pilotage des F-104J et F-4EJ capables de Mach 2. Après avoir étudié le T-38 américain et le Jaguar franco-britannique, dont une production sous licence fut discutée sans aboutir, Tokyo choisit un avion national. En septembre 1967, le projet de **Mitsubishi**, mené par Kenji Ikeda, l''emporte ; Fuji en est le principal sous-traitant.\n\n## Conception\nLe T-2 ressemble beaucoup au **SEPECAT Jaguar** et en partage le moteur : deux **Rolls-Royce/Turbomeca Adour** construits sous licence par Ishikawajima-Harima sous le nom de TF40-IHI-801A. Le prototype XT-2 vole le 20 juillet 1971 et passe Mach 1 en palier le 19 novembre suivant, une première pour un avion de conception japonaise. Une version armée reçoit un canon JM61 de 20 mm et des Sidewinder. Le premier avion de série est livré en mars 1975.\n\n## Carrière opérationnelle\nLe 21e Hikōtai est créé à Matsushima le 1er octobre 1976, le 22e en avril 1978 ; ensemble, ils forment environ 1 450 pilotes de chasse en quelque 307 000 heures de vol. Le T-2 sert aussi d''avion d''agression et d''avion de transition vers le **F-1**, son dérivé monoplace d''appui. De 1982 à 1995, il équipe la patrouille **Blue Impulse** ; le 14 novembre 1982, l''un de ses avions s''écrase pendant le meeting de Hamamatsu, tuant son pilote. Le **T-2CCV**, tiré du troisième prototype et doté de plans canards, vole le 9 août 1983 et explore jusqu''en 1985 les commandes de vol électriques.\n\n## Place dans l''histoire\nQuatre-vingt-seize T-2 sont livrés jusqu''en 1988, prototypes compris. Le dernier vole le 2 mars 2006 à Gifu ; l''entraînement passe au Kawasaki T-4 et aux biplaces F-15DJ et F-2B. Premier supersonique japonais, le T-2 a donné au pays son chasseur d''appui et l''expérience d''une aviation de combat nationale.',
  description_en = E'## Genesis\nIn the mid-1960s the Japan Air Self-Defense Force (JASDF) found that its Fuji T-1 trainer could not prepare pilots for Mach 2 F-104Js and F-4EJs. Having looked at the American T-38 and the Anglo-French Jaguar, whose licence production was discussed but never agreed, Tokyo opted for a domestic design. In September 1967 **Mitsubishi**''s proposal, led by Kenji Ikeda, won, with Fuji as main subcontractor.\n\n## Design\nThe T-2 closely resembles the **SEPECAT Jaguar** and shares its engine: two **Rolls-Royce/Turbomeca Adour** licence-built by Ishikawajima-Harima as the TF40-IHI-801A. The XT-2 prototype first flew on 20 July 1971 and went supersonic in level flight on 19 November that year, a first for a Japanese-designed aircraft. An armed version received a 20 mm JM61 cannon and Sidewinders. The first production aircraft was delivered in March 1975.\n\n## Operational career\nThe 21st Hikōtai was formed at Matsushima on 1 October 1976 and the 22nd in April 1978; together they trained about 1,450 fighter pilots in some 307,000 flying hours. The T-2 also served as an aggressor and as the conversion trainer for the **F-1**, its single-seat support derivative. From 1982 to 1995 it equipped the **Blue Impulse** team; on 14 November 1982 one of its jets crashed at the Hamamatsu air show, killing the pilot. The **T-2CCV**, converted from the third prototype and fitted with canards, first flew on 9 August 1983 and explored fly-by-wire controls until 1985.\n\n## Place in history\nNinety-six T-2s were delivered up to 1988, prototypes included. The last one flew on 2 March 2006 at Gifu; training passed to the Kawasaki T-4 and to two-seat F-15DJs and F-2Bs. Japan''s first supersonic aircraft, the T-2 gave the country its support fighter and the experience of a national combat aviation.'
WHERE name = 'Mitsubishi T-2';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mitsubishi T-2';
