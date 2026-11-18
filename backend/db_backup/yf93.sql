-- North American YF-93A
--
-- Photo : North American F-93 in flight.jpg
--   licence Public domain — auteur non indiqué
--   https://commons.wikimedia.org/wiki/File:North_American_F-93_in_flight.jpg

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
    'North American YF-93',
    'North American YF-93',
    'North American YF-93A',
    'North American YF-93A',
    'Sabre agrandi en chasseur de pénétration à long rayon d''action, battu par le XF-88 dans un concours sans lendemain',
    'A Sabre enlarged into a long-range penetration fighter, beaten by the XF-88 in a competition that led nowhere',
    '/assets/airplanes/yf93.jpg',
    E'## Genèse\nEn 1947, **North American Aviation** lance l''étude **NA-157** : un vrai chasseur de pénétration tiré de son **F-86A Sabre**, capable d''escorter les bombardiers à grande distance. Pour loger plus de carburant, l''avion grossit jusqu''à emporter 7 420 l, réservoirs largables compris, soit une distance franchissable théorique de plus de 3 700 km, le double du F-86A. D''abord désigné F-86C, il doit affronter le **McDonnell XF-88 Voodoo** et le **Lockheed XF-90**. En décembre 1947, l''Air Force commande deux prototypes et, devant l''ampleur des changements, les rebaptise **YF-93A** ; six mois plus tard suit une commande de 118 F-93A.\n\n## Conception\nL''avion pèse 4 830 kg de plus que le Sabre : il lui faut un train principal à roues jumelées, une aile plus grande et un réacteur plus puissant, le **Pratt & Whitney J48** de 38,9 kN avec postcombustion. Le nez, où le F-86A avait son entrée d''air, accueille désormais un radar de recherche SCR-720 et six canons de 20 mm. Les ingénieurs dessinent donc des **entrées d''air NACA** affleurantes sur les flancs du fuselage. Les deux prototypes en sont équipés ; le premier, 48-317, reçoit plus tard des entrées classiques.\n\n## Essais\nEn 1949, la commande de série est brutalement annulée : les essais du **B-47 Stratojet**, réputé assez rapide pour se passer d''escorte, ont bouleversé les priorités. Les prototypes sortent tout juste de chaîne quand l''Air Force reprend le projet à son compte. Le YF-93A vole le 24 janvier 1950, puis affronte en vol les deux autres chasseurs de pénétration, le XF-88 et le XF-90 : le Voodoo est déclaré vainqueur, mais aucun des trois ne sera commandé. En vol, les entrées NACA se révèlent gênantes aux grands angles d''attaque, où elles privent le réacteur d''air.\n\n## Place dans l''histoire\nLes deux YF-93A passent ensuite au centre Ames du **NACA** pour de nouveaux essais, puis servent d''avions d''accompagnement jusqu''en 1956. Dépassés par des appareils plus performants, ils sont alors déclarés excédentaires et ferraillés. Né d''un Sabre agrandi, le YF-93 témoigne d''un moment où l''Air Force a cru que ses bombardiers à réaction pourraient se passer d''escorte.',
    E'## Genesis\nIn 1947 **North American Aviation** began the **NA-157** study: a true penetration fighter derived from its **F-86A Sabre**, able to escort bombers over long distances. To hold more fuel the aircraft grew until it carried 7,420 litres, drop tanks included, giving a theoretical range of over 3,700 km, twice that of the F-86A. First designated F-86C, it was to compete with the **McDonnell XF-88 Voodoo** and the **Lockheed XF-90**. In December 1947 the Air Force ordered two prototypes and, given the extent of the changes, redesignated them **YF-93A**; six months later came an order for 118 F-93As.\n\n## Design\nThe aircraft weighed 4,830 kg more than the Sabre: it needed dual-wheel main gear, a larger wing and a more powerful engine, the **Pratt & Whitney J48** giving 38.9 kN with afterburner. The nose, where the F-86A had its intake, now housed an SCR-720 search radar and six 20 mm cannon. The engineers therefore designed flush **NACA inlets** on the fuselage sides. Both prototypes were built with them; the first, 48-317, was later fitted with conventional intakes.\n\n## Testing\nIn 1949 the production order was abruptly cancelled: testing of the **B-47 Stratojet**, reputedly fast enough not to need an escort, had overturned priorities. The prototypes were just coming off the line when the Air Force took over the project. The YF-93A flew on 24 January 1950, then took part in a fly-off against the other two penetration fighters, the XF-88 and XF-90: the Voodoo was declared the winner, but none of the three was ordered. In flight the NACA inlets proved troublesome at high angles of attack, starving the engine of air.\n\n## Place in history\nBoth YF-93As then went to the **NACA** Ames facility for further testing, and served as chase aircraft until 1956. Overtaken by higher-performance aircraft, they were declared surplus and scrapped. Born of an enlarged Sabre, the YF-93 bears witness to a moment when the Air Force believed its jet bombers could do without escorts.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1950-01-24',
    NULL,
    1139,
    3166,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'North American YF-93'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'North American YF-93'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'North American YF-93'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'North American YF-93'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.44,
  wingspan          = 11.81,
  height            = 4.78,
  wing_area         = 28.4,
  empty_weight      = 6366,
  mtow              = 12027,
  service_ceiling   = 14265,
  climb_rate        = 60.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J48-P-6',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 26.7,
  thrust_wet        = 38.9,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **NA-157 / F-86C** : étude du constructeur et première désignation militaire, version agrandie et remotorisée du F-86A\n- **YF-93A 48-317** : premier prototype, construit avec des entrées d''air NACA puis doté d''entrées classiques\n- **YF-93A 48-318** : second prototype, entrées d''air NACA\n- **F-93A** : version de série, 118 avions commandés en 1948, commande annulée en 1949',
  variants_en       = E'- **NA-157 / F-86C**: company study and first military designation, an enlarged and re-engined F-86A\n- **YF-93A 48-317**: first prototype, built with NACA inlets and later fitted with conventional intakes\n- **YF-93A 48-318**: second prototype, NACA inlets\n- **F-93A**: production version, 118 ordered in 1948, order cancelled in 1949',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_YF-93',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_YF-93',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'North American YF-93';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'North American YF-93';
