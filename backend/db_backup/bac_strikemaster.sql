-- BAC 167 Strikemaster
--
-- Photo : BAC Strikemaster 82A ‘425’ (G-SOAF) (35435886251).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:BAC_Strikemaster_82A_%E2%80%98425%E2%80%99_(G-SOAF)_(35435886251).jpg

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
    'BAC Strikemaster',
    'BAC Strikemaster',
    'BAC 167 Strikemaster',
    'BAC 167 Strikemaster',
    'Le Jet Provost armé pour l''exportation, engagé au combat à Oman, au Yémen et en Équateur',
    'The Jet Provost armed for export, flown in combat in Oman, Yemen and Ecuador',
    '/assets/airplanes/bac-strikemaster.jpg',
    E'## Genèse\nDans les années 1950, le **Jet Provost** de Hunting est devenu le premier avion-école à réaction adopté par une force aérienne pour la formation initiale. À l''exportation pourtant, il perd plusieurs compétitions, faute d''une puissance de feu suffisante. La **British Aircraft Corporation**, qui a repris Hunting Percival, en tire dans les années 1960 un dérivé d''attaque légère et de contre-insurrection, le **BAC 167**. L''Arabie saoudite le commande dès mai 1966 : 25 exemplaires inscrits dans un contrat de défense aérienne plus vaste.\n\n## Conception\nLe Strikemaster est pour l''essentiel un **Jet Provost T.5** armé. Son réacteur **Viper** est porté à 14 kN, sa voilure renforcée pour supporter les charges, et des réservoirs de bout d''aile complètent un circuit carburant revu. Quatre points d''emport sous les ailes acceptent jusqu''à 1 400 kg de bombes, de paniers de roquettes **SNEB** de 68 mm, de nacelles de mitrailleuses ou de napalm, et deux mitrailleuses FN de 7,62 mm sont logées sous les entrées d''air. Ses sièges éjectables fonctionnent à basse altitude et il opère depuis des terrains sommaires. Le premier prototype vole à Warton le 26 octobre 1967.\n\n## Carrière opérationnelle\nLa Royal Saudi Air Force reçoit ses premiers exemplaires le 26 août 1968. Oman, livré à l''été 1969, l''engage contre la **rébellion du Dhofar** dès octobre : en juillet 1972, à la **bataille de Mirbat**, quatre Strikemaster appuient une garnison assaillie par quelque 300 insurgés. Trois avions sont perdus dans ce conflit, dont un peut-être par un missile SA-7. Le Strikemaster combat aussi pour le Yémen, et l''Équateur l''engage en 1995 dans la **guerre du Cenepa**, en attaque contre les positions péruviennes. Au Kenya, il vole aux côtés des **Hawker Hunter**.\n\n## Place dans l''histoire\nCent quarante-six exemplaires sortent des chaînes de Warton puis de Hurn jusqu''en 1983, tous pour l''exportation. La plupart des clients cherchaient d''abord un avion d''entraînement avancé, mais le Strikemaster a montré qu''un biplace école bien armé pouvait tenir lieu d''avion de combat abordable. La fatigue des ailes, découverte en Nouvelle-Zélande, a conduit la plupart des utilisateurs à restreindre son emploi ; quelques exemplaires volent encore dans les années 2020, malgré la pénurie de pièces.',
    E'## Genesis\nIn the 1950s Hunting''s **Jet Provost** had become the first jet trainer adopted by an air force for ab initio training. On the export market, however, it lost several competitions for lack of firepower. The **British Aircraft Corporation**, which had taken over Hunting Percival, derived a light attack and counter-insurgency version from it in the 1960s: the **BAC 167**. Saudi Arabia ordered it as early as May 1966, 25 aircraft forming part of a wider air defence contract.\n\n## Design\nThe Strikemaster is essentially an armed **Jet Provost T.5**. Its **Viper** engine was uprated to 14 kN, its wing strengthened to carry stores, and wingtip tanks completed a revised fuel system. Four underwing hardpoints accepted up to 1,400 kg of bombs, **SNEB** 68 mm rocket pods, machine gun pods or napalm, while two 7.62 mm FN machine guns sat beneath the air intakes. Its ejection seats worked at low altitude and it could operate from rough strips. The first prototype flew at Warton on 26 October 1967.\n\n## Operational career\nThe Royal Saudi Air Force received its first examples on 26 August 1968. Oman, whose aircraft arrived in the summer of 1969, sent them against the **Dhofar Rebellion** from that October: in July 1972, at the **Battle of Mirbat**, four Strikemasters supported a garrison attacked by some 300 insurgents. Three aircraft were lost in that conflict, one possibly to an SA-7 missile. The Strikemaster also fought for Yemen, and Ecuador used it in 1995 in the **Cenepa War**, attacking Peruvian positions. In Kenya it flew alongside **Hawker Hunters**.\n\n## Place in history\nA total of 146 left the Warton and later Hurn lines until 1983, all for export. Most customers were first looking for an advanced trainer, but the Strikemaster showed that a well-armed two-seat trainer could serve as an affordable combat aircraft. Wing fatigue, discovered in New Zealand, led most users to restrict its use; a few examples still fly in the 2020s despite a shortage of spare parts.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    NULL,
    '1967-10-26',
    '1968-08-26',
    774,
    2224,
    (SELECT id FROM manufacturer WHERE code = 'BAC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC Strikemaster'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper')),
((SELECT id FROM airplanes WHERE name = 'BAC Strikemaster'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC Strikemaster'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC Strikemaster'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'BAC Strikemaster'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'BAC Strikemaster'), (SELECT id FROM wars WHERE name = 'Guerre du Cenepa'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.27,
  wingspan          = 11.23,
  height            = 3.34,
  wing_area         = 19.85,
  empty_weight      = 2810,
  mtow              = 5216,
  service_ceiling   = 12190,
  climb_rate        = 26.7,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 233,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper Mk.535',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 14.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1967,
  production_end    = 1983,
  units_built       = 146,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 11,
  variants          = E'- **Mk 80 / 80A** : Arabie saoudite, 25 puis 22 exemplaires, en école et en attaque légère\n- **Mk 82 / 82A** : Oman, 12 puis 13 exemplaires, engagés pendant la rébellion du Dhofar\n- **Mk 81, 83, 84 et 87** : Yémen du Sud (4), Koweït (12), Singapour (16) et Kenya (6)\n- **Mk 88** : Nouvelle-Zélande, 16 exemplaires ; c''est sur cette flotte qu''est découverte la fatigue des ailes\n- **Mk 89 / 89A** : Équateur, 22 puis 6 exemplaires, engagés dans la guerre du Cenepa\n- **Mk 90** : Soudan, dernière série, produite jusqu''en 1983',
  variants_en       = E'- **Mk 80 / 80A**: Saudi Arabia, 25 then 22 aircraft, for training and light attack\n- **Mk 82 / 82A**: Oman, 12 then 13 aircraft, used during the Dhofar Rebellion\n- **Mk 81, 83, 84 and 87**: South Yemen (4), Kuwait (12), Singapore (16) and Kenya (6)\n- **Mk 88**: New Zealand, 16 aircraft; wing fatigue was discovered on this fleet\n- **Mk 89 / 89A**: Ecuador, 22 then 6 aircraft, used in the Cenepa War\n- **Mk 90**: Sudan, the last batch, built until 1983',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/BAC_Strikemaster',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/BAC_Strikemaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'BAC Strikemaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'BAC Strikemaster';
