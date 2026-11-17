-- Soko J-21 Jastreb
--
-- Photo : J-21 Jastreb Aerotehnički institut MF BG 2.jpg
--   licence CC BY-SA 4.0 — Srđan Popović
--   https://commons.wikimedia.org/wiki/File:J-21_Jastreb_Aerotehnički_institut_MF_BG_2.jpg

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
    'Soko J-21 Jastreb',
    'Soko J-21 Jastreb',
    'Soko J-21 Jastreb',
    'Soko J-21 Jastreb',
    'Avion d''attaque léger yougoslave dérivé du Galeb, engagé dans les guerres de l''ex-Yougoslavie',
    'Yugoslav light attack aircraft derived from the Galeb, flown in the wars of the former Yugoslavia',
    '/assets/airplanes/soko-j21-jastreb.jpg',
    E'## Genèse\nJusqu''en 1967, le chasseur-bombardier à réaction le plus répandu de l''aviation yougoslave est le **Republic F-84 Thunderjet**. Pour le remplacer, l''Institut technique aéronautique (ATI) et l''Institut technique militaire (VTI) de Belgrade partent d''un appareil national déjà au point : l''avion d''entraînement **Soko G-2 Galeb**. Ils en tirent une version monoplace d''attaque au sol, le **J-21 Jastreb** (« l''autour »), fabriqué par **SOKO** à Mostar. Le prototype vole le 19 juillet 1965.\n\n## Conception\nLe Jastreb reste un avion simple : structure classique en alliage d''aluminium, commandes manuelles, cockpit non pressurisé, siège éjectable Folland Type 1-B construit sous licence. Il est propulsé par un **Rolls-Royce Viper Mk 531** produit sous licence. Son aile épaisse limite les performances mais loge du carburant, et son train à large voie, monté sur pneus basse pression, lui permet d''opérer depuis des terrains sommaires. Renforcé par rapport au Galeb, il porte trois mitrailleuses **Browning AN/M3** de 12,7 mm dans le nez et jusqu''à 800 kg de charges sous huit points d''emport : bombes de 250 kg, lance-roquettes, réservoirs et roquettes de 127 mm.\n\n## Carrière opérationnelle\nLe J-21 entre en service le 31 décembre 1968 et 224 exemplaires sont construits jusqu''en 1977, y compris des versions de reconnaissance et un biplace d''entraînement. Il est exporté en Libye et en Zambie. Pendant la **guerre de Croatie**, deux Jastreb ouvrent les attaques aériennes yougoslaves le 9 juillet 1991 près d''Ilok ; d''autres sont abattus par la défense antiaérienne croate à Vukovar, au-dessus des îles dalmates et pendant l''opération Tempête en 1995. En Bosnie, six Jastreb serbes violant la zone d''exclusion aérienne sont interceptés par des **F-16** américains lors de l''opération Deny Flight : quatre sont revendiqués abattus. Au Zaïre, des Jastreb livrés à Mobutu et pilotés par des mercenaires serbes finissent abandonnés à Gbadolite.\n\n## Place dans l''histoire\nLe Jastreb montre comment une industrie de taille modeste peut, à partir d''un seul avion-école, décliner une famille complète d''entraînement, d''attaque et de reconnaissance. Il a donné à la Yougoslavie non alignée un avion d''appui national, robuste et rustique. Son destin est pourtant tragique : conçu pour défendre la fédération, il a surtout combattu pendant son éclatement, souvent sous des cocardes rivales.',
    E'## Genesis\nUntil 1967 the most widely used jet fighter-bomber of the Yugoslav Air Force was the **Republic F-84 Thunderjet**. To replace it, the Aeronautical Technical Institute (ATI) and the Military Technical Institute (VTI) in Belgrade started from a domestic aircraft already proven: the **Soko G-2 Galeb** trainer. They derived from it a single-seat ground-attack version, the **J-21 Jastreb** ("hawk"), built by **SOKO** in Mostar. The prototype flew on 19 July 1965.\n\n## Design\nThe Jastreb remained a simple aircraft: conventional aluminium-alloy structure, manual flying controls, unpressurised cockpit, licence-built Folland Type 1-B ejection seat. It was powered by a licence-built **Rolls-Royce Viper Mk 531**. Its thick wing limited performance but housed fuel, and its wide-track undercarriage with low-pressure tyres allowed it to operate from rough strips. Strengthened compared with the Galeb, it carried three 12.7 mm **Browning AN/M3** machine guns in the nose and up to 800 kg of stores on eight hardpoints: 250 kg bombs, rocket pods, tanks and 127 mm rockets.\n\n## Operational career\nThe J-21 entered service on 31 December 1968 and 224 were built up to 1977, including reconnaissance versions and a two-seat trainer. It was exported to Libya and Zambia. In the **Croatian War**, two Jastrebs opened the Yugoslav air attacks on 9 July 1991 near Ilok; others were shot down by Croatian air defences at Vukovar, over the Dalmatian islands and during Operation Storm in 1995. In Bosnia, six Serb Jastrebs violating the no-fly zone were intercepted by American **F-16**s during Operation Deny Flight: four were claimed shot down. In Zaire, Jastrebs delivered to Mobutu and flown by Serbian mercenaries ended up abandoned at Gbadolite.\n\n## Place in history\nThe Jastreb shows how a modest industry could derive, from a single trainer, a complete family of training, attack and reconnaissance aircraft. It gave non-aligned Yugoslavia a domestic, rugged and simple support aircraft. Its fate was nonetheless tragic: designed to defend the federation, it fought mostly during its break-up, often under rival roundels.',
    (SELECT id FROM countries WHERE code = 'YUG'),
    NULL,
    '1965-07-19',
    '1968-12-31',
    820,
    1520,
    (SELECT id FROM manufacturer WHERE code = 'SOKO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Soko J-21 Jastreb'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.88,
  wingspan          = 10.56,
  height            = 3.64,
  wing_area         = 19.43,
  empty_weight      = NULL,
  mtow              = 5100,
  service_ceiling   = 12000,
  climb_rate        = 21,
  g_limit_pos       = 8,
  g_limit_neg       = -4,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Viper Mk 531',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.32,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1977,
  units_built       = 224,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **J-21 Jastreb** : monoplace d''attaque au sol et de reconnaissance\n- **J-21E** : version d''exportation\n- **RJ-21** : monoplace de reconnaissance tactique\n- **RJ-21E** : version d''exportation du RJ-21\n- **NJ-21** : biplace d''entraînement avancé, d''entraînement au tir et d''attaque légère',
  variants_en       = E'- **J-21 Jastreb**: single-seat ground-attack and reconnaissance aircraft\n- **J-21E**: export version\n- **RJ-21**: single-seat tactical reconnaissance aircraft\n- **RJ-21E**: export version of the RJ-21\n- **NJ-21**: two-seat advanced trainer, weapons trainer and light attack aircraft',

  -- Strate 4 : qualitatif
  nickname          = 'Jastreb',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soko_J-21_Jastreb',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Soko_J-21_Jastreb',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Srđan Popović',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Soko J-21 Jastreb';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Soko J-21 Jastreb';
