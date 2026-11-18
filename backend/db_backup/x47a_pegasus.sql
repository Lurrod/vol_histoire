-- Northrop Grumman X-47A Pegasus
--
-- Photo : X-47A first flight (189-358H).jpg
--   licence Public domain — DARPA
--   https://commons.wikimedia.org/wiki/File:X-47A_first_flight_(189-358H).jpg

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
    'Northrop Grumman X-47A Pegasus',
    'Northrop Grumman X-47A Pegasus',
    'Northrop Grumman X-47A Pegasus',
    'Northrop Grumman X-47A Pegasus',
    'Pointe de flèche sans dérive financée par Northrop Grumman, premier jalon du drone de combat embarqué',
    'A finless arrowhead funded by Northrop Grumman, the first step towards a carrier-based combat drone',
    '/assets/airplanes/x47a-pegasus.jpg',
    E'## Genèse\nL''**US Navy** ne s''engage vraiment dans les drones de combat qu''au milieu de 2000, en confiant 2 millions de dollars chacun à Boeing et à **Northrop Grumman** pour quinze mois d''études. Un drone embarqué doit résister à l''air salin, supporter les manœuvres sur le pont, s''intégrer aux systèmes de commandement et fonctionner dans l''environnement électromagnétique d''un porte-avions ; la Navy veut aussi s''en servir en reconnaissance, pour pénétrer un espace aérien défendu et désigner les cibles. Au début de 2001, Northrop Grumman obtient le contrat d''un démonstrateur, le **X-47A Pegasus**, dont le développement initial est financé par l''entreprise, contrairement au **Boeing X-45**.\n\n## Conception\nLe Pegasus est une simple pointe de flèche sans aucune dérive : bord d''attaque en flèche de 55 degrés, bord de fuite à 35 degrés. Six gouvernes le pilotent, deux élevons et quatre petits volets encastrés sur l''extrados et l''intrados, en avant des extrémités d''aile. Le turboréacteur double flux Pratt & Whitney Canada JT15D-5C est monté sur le dos, derrière une entrée d''air en S qui masque la soufflante aux radars ; par économie, la tuyère reste un simple tube, sans réduction de signature radar ni infrarouge. La cellule en composites, en quatre grands éléments, est confiée à **Scaled Composites**, la société de **Burt Rutan** à Mojave, capable de la construire à bas coût.\n\n## Essais\nPrésenté le 30 juillet 2001, le X-47A vole pour la première fois le 23 février 2003 au centre d''essais de l''aéronavale de China Lake, en Californie. Le programme ne prévoit aucun largage d''armes, mais deux soutes, de part et d''autre du moteur, peuvent recevoir chacune une bombe factice de 225 kg pour simuler les charges réelles. Le Pegasus sert aussi à évaluer les techniques d''appontage, bien qu''il n''ait pas de crosse, ainsi que des points d''arrimage et des trappes compatibles avec la furtivité et le vent qui balaie un pont d''envol. Rattaché au programme **J-UCAS** de la DARPA, il s''arrête avec lui en février 2006, après la Quadrennial Defense Review.\n\n## Place dans l''histoire\nLe X-47A n''est qu''un banc d''essai bon marché, mais il ouvre la voie : la Navy retient ensuite le **X-47B** de Northrop Grumman pour son démonstrateur de drone de combat embarqué (UCAS-D). Celui-ci réussit en 2013 le premier catapultage, puis le premier appontage d''un drone sur porte-avions. Une version plus grande, le X-47C, proposée pour emporter 4 500 kg avec 52,4 m d''envergure, n''a pas dépassé le stade du projet.',
    E'## Genesis\nThe **US Navy** only committed to practical combat drones in mid-2000, when it gave Boeing and **Northrop Grumman** $2 million each for a fifteen-month concept study. A carrier-based drone had to cope with salt air, survive deck handling, integrate with command and control systems and operate in a carrier''s electromagnetic environment; the Navy also wanted to use it for reconnaissance, penetrating defended airspace to identify targets. In early 2001 Northrop Grumman won the contract for a demonstrator, the **X-47A Pegasus**, whose initial development was company-funded, unlike the **Boeing X-45**.\n\n## Design\nThe Pegasus was a simple arrowhead with no fin at all: 55 degrees of leading-edge sweep and 35 degrees at the trailing edge. Six control surfaces flew it, two elevons and four small inlaid flaps on the upper and lower wing ahead of the tips. The Pratt & Whitney Canada JT15D-5C turbofan sat on its back, behind a serpentine inlet that hid the fan from radar; to save money, the exhaust was a plain tailpipe with no radar or infrared signature reduction. The composite airframe, in four main assemblies, was built by **Burt Rutan**''s **Scaled Composites** at Mojave, which could do the job cheaply.\n\n## Testing\nRolled out on 30 July 2001, the X-47A first flew on 23 February 2003 at the Naval Air Warfare Center at China Lake, California. The programme involved no weapons delivery, but two bays either side of the engine could each take a 225 kg dummy bomb to simulate real flight loads. The Pegasus was also used to evaluate carrier landing techniques, though it had no tailhook, along with tie-down points and access panels compatible with stealth and with the wind sweeping a flight deck. Part of DARPA''s **J-UCAS** programme, it ended with it in February 2006, after the Quadrennial Defense Review.\n\n## Place in history\nThe X-47A was only a low-cost testbed, but it paved the way: the Navy then chose Northrop Grumman''s **X-47B** for its carrier-based combat drone demonstrator (UCAS-D). In 2013 the X-47B made the first catapult launch, then the first arrested landing of a drone on an aircraft carrier. A larger version, the X-47C, proposed with a 4,500 kg payload and a 52.4 m wingspan, never went beyond the proposal stage.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '2001-01-01',
    '2003-02-23',
    NULL,
    NULL,
    2800,
    (SELECT id FROM manufacturer WHERE code = 'NOR'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop Grumman X-47A Pegasus'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Northrop Grumman X-47A Pegasus'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Northrop Grumman X-47A Pegasus'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.5,
  wingspan          = 8.5,
  height            = 1.85,
  wing_area         = 35.98,
  empty_weight      = 1740,
  mtow              = 2678,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada JT15D-5C',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 14.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **X-47A Pegasus** : démonstrateur unique, présenté le 30 juillet 2001, premier vol le 23 février 2003\n- **Deux soutes internes**, chacune pour une bombe factice de 225 kg\n- **X-47B** : version navale retenue par l''US Navy pour le programme UCAS-D\n- **X-47C** : version agrandie proposée, 4 500 kg de charge et 52,4 m d''envergure',
  variants_en       = E'- **X-47A Pegasus**: single demonstrator, rolled out on 30 July 2001, first flight on 23 February 2003\n- **Two internal bays**, each for a 225 kg dummy bomb\n- **X-47B**: naval version chosen by the US Navy for the UCAS-D programme\n- **X-47C**: proposed enlarged version, 4,500 kg payload and 52.4 m wingspan',

  -- Strate 4 : qualitatif
  nickname          = 'Pegasus',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Northrop_Grumman_X-47A_Pegasus',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Northrop_Grumman_X-47A_Pegasus',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'DARPA',
  image_licence     = 'Public domain'
WHERE name = 'Northrop Grumman X-47A Pegasus';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'Northrop Grumman X-47A Pegasus';
