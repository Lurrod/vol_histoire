-- Douglas X-3 Stiletto
--
-- Photo : Douglas X-3 NASA E-17348.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File%3ADouglas_X-3_NASA_E-17348.jpg

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
    'X-3 Stiletto',
    'X-3 Stiletto',
    'Douglas X-3 Stiletto',
    'Douglas X-3 Stiletto',
    'Conçu pour Mach 2, sous-motorisé au point de peiner à passer Mach 1',
    'Designed for Mach 2, so underpowered it barely passed Mach 1',
    '/assets/airplanes/x3-stiletto.jpg',
    E'## Genèse\nLe X-1 a franchi le mur du son en 1947 — mais largué d''un bombardier, et pour quelques secondes. La question suivante est différente : peut-on **décoller d''une piste** et **tenir** Mach 2 en croisière ? Douglas propose une réponse en forme de dard : vingt mètres de fuselage pour sept mètres d''envergure.\n\n## Conception\nL''aile est trapézoïdale, extraordinairement mince — 4,5 % d''épaisseur relative — et si petite que l''appareil décolle à plus de 400 km/h. Le programme repose entièrement sur le réacteur **Westinghouse J46**, qui n''arrive jamais. Douglas se rabat sur des **J34** de moitié moins puissants, sans redessiner la cellule. L''appareil garde donc la traînée d''un Mach 2 avec la poussée d''un Mach 1.\n\n## Carrière opérationnelle\nAucune. Cinquante et un vols entre 1952 et 1956, et une amère déception : le X-3 ne dépasse Mach 1 qu''en piqué, plafonnant à Mach 1,21. Le 27 octobre 1954, un tonneau brutal provoque un **couplage inertiel** qui manque de détruire l''appareil — accident que les ingénieurs analysent et qui donne naissance à toute une théorie du comportement des avions longs et fins.\n\n## Place dans l''histoire\nUn exemplaire, aucun record. Son échec est pourtant instructif : sa cellule inspire directement l''aile et le fuselage du **F-104 Starfighter**, et l''analyse de son couplage inertiel sauve des pilotes de F-100 et de F-102. Le X-3 a prouvé, à ses dépens, qu''une belle cellule sans moteur ne vaut rien.',
    E'## Genesis\nThe X-1 broke the sound barrier in 1947 — but air-launched from a bomber, and for seconds at a time. The next question was different: could an aircraft **take off from a runway** and **sustain** Mach 2 in cruise? Douglas answered with a dart: twenty metres of fuselage for seven metres of span.\n\n## Design\nThe wing is trapezoidal, extraordinarily thin — 4.5% thickness ratio — and so small that the aircraft lifts off above 400 km/h. The whole programme rested on the **Westinghouse J46** engine, which never arrived. Douglas fell back on **J34s** of half the power without redesigning the airframe. The aircraft therefore kept Mach 2 drag with Mach 1 thrust.\n\n## Operational career\nNone. Fifty-one flights between 1952 and 1956, and a bitter disappointment: the X-3 exceeded Mach 1 only in a dive, topping out at Mach 1.21. On 27 October 1954 a violent roll produced an **inertial coupling** that nearly destroyed the aircraft — an accident engineers analysed, and which gave rise to a whole theory of how long, slender aircraft behave.\n\n## Place in history\nOne built, no records. Its failure was instructive nonetheless: its airframe directly inspired the wing and fuselage of the **F-104 Starfighter**, and the analysis of its inertial coupling saved F-100 and F-102 pilots. The X-3 proved, at its own expense, that a fine airframe without an engine is worth nothing.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1949-06-01',
    '1952-10-20',
    NULL,
    1120.0,
    800.0,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'X-3 Stiletto'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'X-3 Stiletto'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.35,
  wingspan          = 6.91,
  height            = 3.8,
  wing_area         = 15.5,
  empty_weight      = 7300,
  mtow              = 10160,
  service_ceiling   = 11600,
  climb_rate        = 10.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 300,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J34-WE-17',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 15.6,
  thrust_wet        = 21.8,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1952,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-3** : un exemplaire, cinquante et un vols entre 1952 et 1956\n- Devait recevoir le réacteur **J46** : jamais prêt, remplacé par des J34 deux fois plus faibles\n- Ne franchit **Mach 1 qu''en piqué**, et atteint Mach 1,21 au mieux\n- Ses **couplages en roulis** violents en 1954 mènent à la théorie du couplage inertiel\n- Aile minuscule et fuselage effilé repris pour le **F-104 Starfighter**',
  variants_en       = E'- **X-3** : one aircraft, fifty-one flights between 1952 and 1956\n- Was to receive the **J46** engine: never ready, replaced by half-as-powerful J34s\n- Passed **Mach 1 only in a dive**, reaching Mach 1.21 at best\n- Its violent **roll coupling** in 1954 led to the theory of inertial coupling\n- Tiny wing and slender fuselage taken up for the **F-104 Starfighter**',

  -- Strate 4 : qualitatif
  nickname          = 'Stiletto',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_X-3_Stiletto',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_X-3_Stiletto',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'X-3 Stiletto';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'X-3 Stiletto';
