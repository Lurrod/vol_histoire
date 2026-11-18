-- Morane-Saulnier MS.733 Alcyon
--
-- Photo : Alcyon formation - La-Ferté-Alais. 9th June 2019 (49831061516).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Alcyon_formation_-_La-Fert%C3%A9-Alais._9th_June_2019_(49831061516).jpg

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
    'Morane-Saulnier MS.733 Alcyon',
    'Morane-Saulnier MS.733 Alcyon',
    'Morane-Saulnier MS.733 Alcyon',
    'Morane-Saulnier MS.733 Alcyon',
    'L''avion d''école français de l''après-guerre, armé de roquettes pour la contre-guérilla en Algérie',
    'The post-war French trainer, armed with rockets for counter-insurgency in Algeria',
    '/assets/airplanes/ms733-alcyon.jpg',
    E'## Genèse\nAu lendemain de la guerre, l''industrie aéronautique française se reconstruit, et l''État lance en 1949 un programme d''avion d''entraînement de début et de transition pour l''armée de l''air et l''aéronautique navale. **Morane-Saulnier** y répond avec le **MS.730**, monoplan entièrement métallique à aile basse et train fixe, qui vole le 11 août 1949 avec un moteur Mathis de 180 ch. Ses performances sont jugées insuffisantes. Le constructeur essaie alors un Argus allemand de 240 ch récupéré de la guerre (MS.731), puis un train escamotable (MS.732), avant d''aboutir au **MS.733 Alcyon**, qui vole le 16 avril 1951.\n\n## Conception\nL''Alcyon reçoit un moteur **Potez 6D** à six cylindres inversés de 240 ch et un train principal qui se rétracte vers l''extrémité de l''aile. L''élève et l''instructeur sont assis côte à côte, et une place arrière accueille un passager. Pour l''époque, l''avion est très bien équipé pour le vol aux instruments : deux VOR-ILS, un radiocompas, deux radios VHF, un radioaltimètre et un gyroscope directionnel. Apte à la voltige de base, il coûte bien moins cher à exploiter que les bimoteurs alors employés pour apprendre la navigation.\n\n## Carrière opérationnelle\nAprès cinq exemplaires de présérie, 200 appareils de série sont livrés : 145 à l''armée de l''air, surtout à l''**École de l''air** de Salon-de-Provence, 40 à la Marine, aux escadrilles 51S et 52S, et 15 au Cambodge. Soixante-dix avions de l''armée de l''air reçoivent des mitrailleuses pour l''instruction au tir ; certains deviennent des **MS.733A** de contre-guérilla, engagés pendant la **guerre d''Algérie** avec deux mitrailleuses MAC de 7,5 mm, des roquettes T10 et des bombes de 50 kg. Le climat chaud bride leurs performances, et le **T-28 Fennec** les remplace dans ce rôle.\n\n## Place dans l''histoire\nSouvent employé pour remplacer les vieux biplans **Stampe SV.4**, l''Alcyon a été l''un des avions d''école de l''aviation militaire française reconstruite après la guerre. Le centre de formation aéronautique de Saint-Yan et Air France l''utilisent ensuite pour former et perfectionner leurs pilotes de ligne au vol aux instruments. Une cinquantaine d''exemplaires subsistent, dont plusieurs volent encore en France, entretenus par des associations.',
    E'## Genesis\nAfter the war the French aircraft industry was rebuilding, and in 1949 the state launched a programme for a primary and transition trainer for the air force and naval aviation. **Morane-Saulnier** responded with the **MS.730**, an all-metal low-wing monoplane with fixed landing gear, which flew on 11 August 1949 with a 180 hp Mathis engine. Its performance was judged inadequate. The company then tried a 240 hp German war-surplus Argus engine (MS.731), then a retractable undercarriage (MS.732), before arriving at the **MS.733 Alcyon**, which flew on 16 April 1951.\n\n## Design\nThe Alcyon received a 240 hp six-cylinder inverted **Potez 6D** engine and main gear that retracted towards the wingtips. Pupil and instructor sat side by side, with a rear seat for a passenger. For its day the aircraft was very well equipped for instrument flying: two VOR-ILS sets, an ADF, two VHF radios, a radar altimeter and a directional gyro. Capable of basic aerobatics, it was far cheaper to operate than the twin-engined types then used for navigation training.\n\n## Operational career\nAfter five pre-production aircraft, 200 production machines were delivered: 145 to the air force, mainly to the **École de l''air** at Salon-de-Provence, 40 to the Navy, with escadrilles 51S and 52S, and 15 to Cambodia. Seventy air force aircraft were fitted with machine guns for gunnery training; some became **MS.733A** counter-insurgency aircraft, used during the **Algerian War** with two 7.5 mm MAC machine guns, T10 rockets and 50 kg bombs. The hot climate limited their performance, and the **T-28 Fennec** replaced them in that role.\n\n## Place in history\nOften used to replace the old **Stampe SV.4** biplanes, the Alcyon was one of the trainers of the French military aviation rebuilt after the war. The Saint-Yan flight training centre and Air France later used it to train airline pilots and refresh their instrument flying. Around fifty survive, several of them still flying in France, maintained by enthusiast associations.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1949-01-01',
    '1949-08-11',
    NULL,
    260,
    920,
    (SELECT id FROM manufacturer WHERE code = 'MS'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.733 Alcyon'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.733 Alcyon'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.733 Alcyon'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Morane-Saulnier MS.733 Alcyon'), (SELECT id FROM wars WHERE name = 'Guerre d''Algérie'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.32,
  wingspan          = 11.28,
  height            = 2.42,
  wing_area         = 21.9,
  empty_weight      = 1260,
  mtow              = 1670,
  service_ceiling   = 4800,
  climb_rate        = 5.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Potez 6D-30 (240 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 208,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **MS.730** : premier prototype à train fixe et moteur Mathis de 180 ch, premier vol le 11 août 1949\n- **MS.731** : le même prototype remotorisé avec un Argus As 10 de 240 ch\n- **MS.732** : deux prototypes de 1951 à train escamotable\n- **MS.733 Alcyon** : version de série à moteur Potez 6D, cinq de présérie et 200 de série\n- **MS.733A** : avions d''instruction au tir modifiés pour la contre-guérilla en Algérie, avec mitrailleuses, roquettes et bombes\n- **MS.735** : version à moteur Potez 6D 30 suralimenté de 305 ch',
  variants_en       = E'- **MS.730**: first prototype with fixed gear and a 180 hp Mathis engine, first flown on 11 August 1949\n- **MS.731**: the same prototype re-engined with a 240 hp Argus As 10\n- **MS.732**: two 1951 prototypes with retractable undercarriage\n- **MS.733 Alcyon**: production version with Potez 6D engine, five pre-production and 200 production aircraft\n- **MS.733A**: gunnery trainers modified for counter-insurgency in Algeria, with machine guns, rockets and bombs\n- **MS.735**: version with a 305 hp supercharged Potez 6D 30 engine',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Morane-Saulnier_MS.733_Alcyon',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Morane-Saulnier_Alcyon',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Morane-Saulnier MS.733 Alcyon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Morane-Saulnier MS.733 Alcyon';
