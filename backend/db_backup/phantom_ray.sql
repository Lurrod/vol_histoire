-- Boeing Phantom Ray
--
-- Photo : Phantom Ray above DFRC.jpg
--   licence Public domain — NASA/Carla Thomas
--   https://commons.wikimedia.org/wiki/File:Phantom_Ray_above_DFRC.jpg

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
    'Boeing Phantom Ray',
    'Boeing Phantom Ray',
    'Boeing Phantom Ray',
    'Boeing Phantom Ray',
    'Aile volante furtive de la taille d''un chasseur, ressuscitée sur fonds propres à partir du X-45C',
    'A fighter-sized stealthy flying wing, revived with Boeing''s own money from the X-45C',
    '/assets/airplanes/phantom-ray.jpg',
    E'## Genèse\nLe Phantom Ray naît chez **Boeing** sous le nom de code **Project Reblue** : imaginé au milieu de 2007, il est lancé officiellement en juin 2008 et reste un secret, connu d''une poignée de dirigeants et d''ingénieurs, jusqu''en mai 2009. Développé par les **Phantom Works**, il reprend le prototype **X-45C** que Boeing avait conçu pour le programme **J-UCAS** mené par la DARPA, l''US Air Force et l''US Navy. À la différence de ses prédécesseurs, il ne répond à aucun programme militaire ni à aucune compétition, même si Boeing envisage d''en faire son candidat au programme **UCLASS** de drone embarqué de l''US Navy. Il est financé entièrement sur les fonds propres du constructeur.\n\n## Conception\nC''est un drone de combat furtif autonome, une aile volante de la taille d''un chasseur classique : 11 m de long pour 15,2 m d''envergure et plus de 16 t au décollage. Un réacteur General Electric F404-GE-102D le propulse, et Boeing annonce une croisière à Mach 0,93. Ses concepteurs lui prêtent une charge utile de 2 040 kg. Il est prévu pour des missions de renseignement, de surveillance et de reconnaissance, de suppression des défenses aériennes, de recherche et destruction, d''attaque électronique, de traque des cibles (« hunter-killer ») et de ravitaillement en vol automatique.\n\n## Essais\nPrésenté le 10 mai 2010 à Saint-Louis, dans le Missouri, le Phantom Ray y effectue en novembre des essais de roulage à basse vitesse. Le programme prévoit dix vols d''essai en six mois. Son premier vol, prévu en décembre 2010 depuis le centre Dryden de la NASA, est repoussé ; l''appareil est transporté jusqu''à Edwards sur le dos du **Boeing 747** porte-navette de la NASA et décolle enfin le 27 avril 2011. Il monte à environ 2 300 m, atteint 330 km/h et vole 17 minutes.\n\n## Place dans l''histoire\nBoeing voyait dans le Phantom Ray le premier d''une série de nouveaux prototypes. Il prolonge surtout une filière, celle du **Bird of Prey** et du **X-45** : la furtivité sans dérive mise au service d''un drone de combat de la taille d''un chasseur. Sans client désigné, il illustre le pari d''un industriel qui garde vivantes une équipe et une technologie en attendant le programme qui les emploiera, face au **X-47B** de Northrop Grumman.',
    E'## Genesis\nThe Phantom Ray was born inside **Boeing** under the code name **Project Reblue**: conceived in mid-2007, it officially began in June 2008 and remained a secret, known to a handful of executives and engineers, until May 2009. Developed by the **Phantom Works**, it was based on the **X-45C** prototype Boeing had designed for the **J-UCAS** programme run by DARPA, the US Air Force and the US Navy. Unlike its predecessors, it was not aimed at any military programme or competition, although Boeing considered entering it for the US Navy''s **UCLASS** carrier-based drone programme. It was funded entirely with the company''s own money.\n\n## Design\nIt is an autonomous stealthy combat drone, a flying wing about the size of a conventional fighter: 11 m long with a 15.2 m wingspan and over 16 t at take-off. A General Electric F404-GE-102D powers it, and Boeing quoted a cruise speed of Mach 0.93. Its developers credit it with a 2,040 kg payload. It was meant for intelligence, surveillance and reconnaissance, suppression of enemy air defences, seek-and-destroy, electronic attack, hunter-killer and autonomous aerial refuelling missions.\n\n## Testing\nUnveiled on 10 May 2010 in St. Louis, Missouri, the Phantom Ray made low-speed taxi tests there in November. The programme called for ten test flights over six months. Its first flight, planned for December 2010 from NASA''s Dryden centre, was postponed; the aircraft was carried to Edwards on the back of NASA''s **Boeing 747** Shuttle Carrier Aircraft and finally took off on 27 April 2011. It climbed to about 2,300 m, reached 330 km/h and flew for 17 minutes.\n\n## Place in history\nBoeing saw the Phantom Ray as the first of a series of new prototypes. Above all it extends a lineage, that of the **Bird of Prey** and the **X-45**: finless stealth applied to a fighter-sized combat drone. With no named customer, it shows a manufacturer keeping a team and a technology alive while waiting for the programme that would use them, facing Northrop Grumman''s **X-47B**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2008-06-01',
    '2011-04-27',
    NULL,
    NULL,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Phantom Ray'), (SELECT id FROM tech WHERE name = 'Aile volante')),
((SELECT id FROM airplanes WHERE name = 'Boeing Phantom Ray'), (SELECT id FROM tech WHERE name = 'Conception furtive'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing Phantom Ray'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.97,
  wingspan          = 15.24,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 16556,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-102D',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **X-45C** : prototype agrandi conçu pour le programme J-UCAS, base du Phantom Ray\n- **Project Reblue** : nom de code interne, programme lancé en juin 2008\n- **Démonstrateur unique** : présenté le 10 mai 2010 à Saint-Louis, premier vol le 27 avril 2011\n- **Charge utile annoncée** de 2 040 kg, croisière à Mach 0,93',
  variants_en       = E'- **X-45C**: enlarged prototype designed for the J-UCAS programme, basis of the Phantom Ray\n- **Project Reblue**: internal code name, programme launched in June 2008\n- **Single demonstrator**: unveiled on 10 May 2010 in St. Louis, first flight on 27 April 2011\n- **Stated payload** of 2,040 kg, cruise at Mach 0.93',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_Phantom_Ray',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_Phantom_Ray',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Carla Thomas, NASA',
  image_licence     = 'Public domain'
WHERE name = 'Boeing Phantom Ray';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'elevee' WHERE name = 'Boeing Phantom Ray';
