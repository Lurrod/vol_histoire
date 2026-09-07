-- Commonwealth Aircraft Corporation CA-27 Sabre
--
-- Photo : CAC CA-27 Sabre in flight.jpg
--   licence CC BY-SA 4.0 — Bahnfrend
--   https://commons.wikimedia.org/wiki/File%3ARAAF_CAC_Sabre_A94-914_%2B_A94-921_Darwin_Aviation_Museum%2C_2023_%2801%29.jpg

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
    'CAC CA-27 Sabre',
    'CAC CA-27 Sabre',
    'Commonwealth Aircraft Corporation CA-27 Sabre',
    'Commonwealth Aircraft Corporation CA-27 Sabre',
    'Le Sabre réétudié en Australie autour d’un moteur britannique',
    'The Sabre redesigned in Australia around a British engine',
    '/assets/airplanes/cac-sabre.jpg',
    E'## Genèse\nL''Australie veut des **F-86 Sabre** mais refuse d''en acheter tels quels : le réacteur américain General Electric J47 lui paraît en retrait du **Rolls-Royce Avon** britannique, plus puissant d''un tiers. Canberra décide donc de construire le Sabre sous licence en y substituant l''Avon. L''idée paraît simple ; elle ne l''est pas du tout.\n\n## Conception\nL''Avon est plus court et de bien plus gros diamètre que le J47. Il faut **élargir le fuselage de vingt-cinq pour cent**, agrandir l''entrée d''air, redessiner les cadres et refaire tout le cheminement des commandes. Au bout du compte, seuls quarante pour cent des pièces restent communes avec le F-86 américain : ce n''est plus une production sous licence mais un avion distinct. CAC en profite pour remplacer les six mitrailleuses de 12,7 mm par **deux canons ADEN de 30 mm**, bien plus destructeurs.\n\n## Carrière opérationnelle\nL''Avon Sabre est le meilleur de tous les Sabre construits — plus rapide, mieux armé, meilleur en montée que l''original. Il sert en **Malaisie** pendant l''insurrection communiste et en Thaïlande, sans jamais rencontrer d''adversaire aérien. L''Australie le retire en 1971 et cède ses derniers exemplaires à la Malaisie et à l''Indonésie.\n\n## Place dans l''histoire\nCent douze exemplaires. Sa valeur ne tient pas au nombre mais à ce qu''il représente : la démonstration qu''une industrie aéronautique de taille modeste peut reprendre un appareil étranger et l''améliorer réellement, plutôt que de le copier. C''est le dernier chasseur construit en Australie ; le pays achètera ensuite des Mirage III, puis des F/A-18.',
    E'## Genesis\nAustralia wanted **F-86 Sabres** but refused to buy them as they were: the American General Electric J47 engine looked inferior to the British **Rolls-Royce Avon**, a third more powerful. Canberra therefore decided to build the Sabre under licence with the Avon substituted. The idea sounded simple; it was nothing of the sort.\n\n## Design\nThe Avon is shorter and of far greater diameter than the J47. The fuselage had to be **widened by twenty-five per cent**, the intake enlarged, the frames redrawn and the entire control run rerouted. In the end only forty per cent of parts remained common with the American F-86: this was no longer licence production but a distinct aircraft. CAC took the opportunity to replace the six 12.7 mm machine guns with **two 30 mm ADEN cannon**, far more destructive.\n\n## Operational career\nThe Avon Sabre is the best of all the Sabres built — faster, better armed and a better climber than the original. It served in **Malaya** during the communist insurgency and in Thailand, without ever meeting an airborne opponent. Australia retired it in 1971 and passed its last aircraft to Malaysia and Indonesia.\n\n## Place in history\nOne hundred and twelve built. Its value lies not in the number but in what it represents: proof that a modest aircraft industry can take a foreign design and genuinely improve it, rather than copy it. It is the last fighter built in Australia; the country would go on to buy Mirage IIIs, then F/A-18s.',
    (SELECT id FROM countries WHERE code = 'AUS'),
    '1951-01-01',
    '1953-08-03',
    '1954-09-01',
    1126.0,
    1850.0,
    (SELECT id FROM manufacturer WHERE code = 'CWA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'CAC CA-27 Sabre'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.43,
  wingspan          = 11.3,
  height            = 4.47,
  wing_area         = 29.1,
  empty_weight      = 5443,
  mtow              = 9525,
  service_ceiling   = 15850,
  climb_rate        = 61.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 590,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon 26',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 33.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1961,
  units_built       = 112,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **CA-26** : prototype unique, premier vol en août 1953\n- **CA-27 Mk 30 / 31** : versions initiales de série\n- **CA-27 Mk 32** : version définitive, emport de missiles Sidewinder\n- Cédés à la **Malaisie** et à l''**Indonésie** après leur retrait australien\n- Fuselage **élargi de 25 %** par rapport au F-86 pour loger le réacteur Avon',
  variants_en       = E'- **CA-26** : sole prototype, first flight in August 1953\n- **CA-27 Mk 30 / 31** : initial production versions\n- **CA-27 Mk 32** : definitive version, carrying Sidewinder missiles\n- Passed to **Malaysia** and **Indonesia** after Australian retirement\n- Fuselage **25 % wider** than the F-86''s to house the Avon engine',

  -- Strate 4 : qualitatif
  nickname          = 'Avon Sabre',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/CAC_Sabre',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/CAC_Sabre',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Stephen Edmonds from Melbourne, Australia',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'CAC CA-27 Sabre';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'CAC CA-27 Sabre';
