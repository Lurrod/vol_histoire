-- McDonnell Douglas X-36 Tailless Fighter Agility Research Aircraft
--
-- Photo : X-36 in Flight over Mojave Desert (EC97-44294-2).jpg
--   licence Public domain — NASA Armstrong Flight Research Center / NASA
--   https://commons.wikimedia.org/wiki/File:X-36_in_Flight_over_Mojave_Desert_(EC97-44294-2).jpg

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
    'McDonnell Douglas X-36',
    'McDonnell Douglas X-36',
    'McDonnell Douglas X-36 Tailless Fighter Agility Research Aircraft',
    'McDonnell Douglas X-36 Tailless Fighter Agility Research Aircraft',
    'Maquette volante d''un chasseur sans dérive, pilotée depuis le sol pour prouver qu''on peut se passer d''empennage',
    'Flying scale model of a tailless fighter, flown from the ground to prove that a fighter can do without a tail',
    '/assets/airplanes/mdd-x36.jpg',
    E'## Genèse\nUn chasseur sans empennage serait plus léger, offrirait moins de traînée et une signature radar plus faible, tout en gagnant en autonomie, en maniabilité et en capacité de survie. Reste à prouver qu''il peut voler correctement. Pour le vérifier à moindre coût, la **NASA** et **McDonnell Douglas** construisent le **X-36 Tailless Fighter Agility Research Aircraft**, une réduction à 28 % d''un chasseur possible, sans pilote à bord. La NASA en finance la moitié, pour un coût total estimé entre 17 et 21 millions de dollars selon les sources.\n\n## Conception\nLe X-36 n''a ni dérive ni empennage horizontal. Son pilotage repose sur un plan canard placé devant l''aile, des ailerons dédoublés et une tuyère orientable qui assure le contrôle en direction. L''appareil est instable à la fois en tangage et en lacet : seules des commandes de vol électriques numériques le rendent pilotable. Le pilote reste au sol, dans un cockpit virtuel, et voit ce que filme une caméra installée sous la verrière. Long de 5,55 m avec sa perche, l''avion pèse moins de 600 kg et vole grâce à un petit turboréacteur double flux **Williams F112**.\n\n## Essais\nLe premier vol a lieu le 17 mai 1997. Suivent 31 vols de recherche réussis : l''appareil se pilote très bien et le programme atteint ou dépasse tous ses objectifs. En cours d''essais, en août 1997, McDonnell Douglas fusionne avec **Boeing**, si bien que l''avion est parfois appelé Boeing X-36. Les deux exemplaires sont aujourd''hui conservés, l''un au musée national de l''US Air Force à Dayton, arrivé le même jour que le **Bird of Prey**, l''autre devant le musée des essais en vol d''Edwards.\n\n## Place dans l''histoire\nMalgré une maniabilité jugée idéale pour un avion de combat et des essais sans accroc, le X-36 n''a eu aucune descendance directe connue. Il a pourtant démontré, en vol réel, qu''un chasseur pouvait se passer de toute surface verticale si l''informatique de vol compense l''instabilité. Cette leçon rejoint celle du **Bird of Prey**, de la même maison, dont la formule sans dérive devient la norme des drones de combat furtifs, à commencer par le **Boeing X-45**.',
    E'## Genesis\nA tailless fighter would be lighter, with less drag and a smaller radar cross-section, while gaining range, manoeuvrability and survivability. It still had to be shown that it could fly properly. To find out cheaply, **NASA** and **McDonnell Douglas** built the **X-36 Tailless Fighter Agility Research Aircraft**, a 28% scale model of a possible fighter with no pilot on board. NASA paid half, for a total cost estimated at $17 to 21 million depending on the source.\n\n## Design\nThe X-36 had neither fin nor horizontal tail. Control relied on a canard ahead of the wing, split ailerons and a thrust-vectoring nozzle for directional control. The aircraft was unstable in both pitch and yaw: only a digital fly-by-wire system made it flyable. The pilot stayed on the ground, in a virtual cockpit, watching the picture from a video camera mounted in the canopy. At 5.55 m long including the pitot boom, the aircraft weighed under 600 kg and was powered by a small **Williams F112** turbofan.\n\n## Testing\nThe first flight took place on 17 May 1997. Thirty-one successful research flights followed: the aircraft handled very well and the programme met or exceeded all its goals. During testing, in August 1997, McDonnell Douglas merged with **Boeing**, so the aircraft is sometimes called the Boeing X-36. Both aircraft survive, one at the National Museum of the United States Air Force in Dayton, which arrived the same day as the **Bird of Prey**, the other outside the flight test museum at Edwards.\n\n## Place in history\nDespite manoeuvrability judged ideal for a fighter and a trouble-free test programme, the X-36 had no known direct successor. Yet it proved in real flight that a fighter could do without any vertical surface, provided the flight computers made up for the instability. That lesson matches the one taught by the **Bird of Prey**, from the same company, whose finless layout became the norm for stealthy combat drones, starting with the **Boeing X-45**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1997-05-17',
    NULL,
    450,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas X-36'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards')),
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas X-36'), (SELECT id FROM tech WHERE name = 'Moteur à poussée vectorielle')),
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas X-36'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas X-36'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 5.55,
  wingspan          = 3.18,
  height            = 0.95,
  wing_area         = NULL,
  empty_weight      = 494,
  mtow              = 576,
  service_ceiling   = 6200,
  climb_rate        = NULL,
  g_limit_pos       = 5.0,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Williams F112',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 3.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **X-36 n° 1** : conservé au musée national de l''US Air Force, à Dayton, depuis le 16 juillet 2003\n- **X-36 n° 2** : exposé devant le musée des essais en vol de la base d''Edwards\n- **Échelle 28 %** d''un chasseur sans empennage envisagé, piloté depuis un cockpit virtuel au sol\n- **31 vols de recherche** à partir du 17 mai 1997',
  variants_en       = E'- **X-36 No. 1**: preserved at the National Museum of the United States Air Force, Dayton, since 16 July 2003\n- **X-36 No. 2**: displayed outside the flight test museum at Edwards Air Force Base\n- **28% scale** model of a possible tailless fighter, flown from a ground-based virtual cockpit\n- **31 research flights** from 17 May 1997',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_X-36',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_X-36',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'McDonnell Douglas X-36';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'McDonnell Douglas X-36';
