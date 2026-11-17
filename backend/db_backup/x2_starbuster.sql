-- Bell X-2 Starbuster
--
-- Photo : Bell X-2 Number 1 (674) Landing with Skids Deployed.jpg
--   licence Public domain — NASA
--   https://commons.wikimedia.org/wiki/File:Bell_X-2_Number_1_(674)_Landing_with_Skids_Deployed.jpg

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
    'Bell X-2',
    'Bell X-2',
    'Bell X-2 Starbuster',
    'Bell X-2 Starbuster',
    'Avion-fusée d''acier et de K-Monel, premier à dépasser Mach 3, au prix de la vie de son pilote',
    'A steel and K-Monel rocket plane, the first to pass Mach 3, at the cost of its pilot''s life',
    '/assets/airplanes/bell-x2.jpg',
    E'## Genèse\nEn 1945, **Bell Aircraft**, les United States Army Air Forces et le **NACA** lancent ensemble l''étude d''un avion-fusée chargé d''aller plus vite et plus haut que le **Bell X-1** et le **D-558-2 Skyrocket**. L''objectif est la plage de Mach 2 à Mach 3, et surtout ce que l''on appelle alors le « mur de la chaleur » : l''échauffement de la cellule par le frottement de l''air. Le développement s''étire sur des années, car presque tout est à inventer, de l''aérodynamique aux matériaux capables de garder leur résistance à haute température.\n\n## Conception\nLe X-2 est un avion-fusée à aile en flèche, construit en acier inoxydable et en **K-Monel**, un alliage de cuivre et de nickel. Il reçoit un **Curtiss-Wright XLR25** à deux chambres, alimenté en alcool et en oxygène liquide, dont la poussée se règle en continu de 11 à 67 kN : une première sur un avion américain, héritée d''un moteur de décollage assisté conçu par **Robert Goddard** pour la Navy. Le programme est aussi pionnier de la simulation numérique du vol. Largué d''un bombardier B-50 modifié, l''avion se pose sur des patins.\n\n## Essais\nLe premier vol plané a lieu à Edwards le 27 juin 1952. Le 12 mai 1953, le second exemplaire explose en vol captif sous son avion porteur, tuant le pilote de Bell **Jean « Skip » Ziegler** et un membre d''équipage du B-50. **Frank « Pete » Everest** réalise le premier vol propulsé le 18 novembre 1955 et atteint Mach 2,87 en juillet 1956. Le 7 septembre 1956, **Iven Kincheloe** devient le premier pilote à dépasser 30 500 m, à 38 466 m. Vingt jours plus tard, **Mel Apt** atteint Mach 3,2, soit 3 370 km/h, mais il vire au-delà de Mach 3 : l''avion part en couplage inertiel, et Apt meurt dans la capsule éjectable.\n\n## Place dans l''histoire\nLe X-2 a ouvert la voie au-delà de Mach 3 et a livré de précieuses données sur l''échauffement cinétique et le vol à très haute altitude. Mais son accident met fin au programme avant que le NACA ne puisse entreprendre ses propres recherches, et révèle l''insuffisance de la capsule de sauvetage. Les réponses attendues sur le vol hypersonique sont reportées de trois ans, jusqu''à l''arrivée du **X-15**.',
    E'## Genesis\nIn 1945 **Bell Aircraft**, the United States Army Air Forces and the **NACA** jointly launched a rocket aircraft meant to go faster and higher than the **Bell X-1** and the **D-558-2 Skyrocket**. The target was the Mach 2 to Mach 3 range and, above all, what was then called the thermal thicket: the heating of the airframe by air friction. Development dragged on for years, because almost everything had to be invented, from the aerodynamics to materials able to keep their strength at high temperature.\n\n## Design\nThe X-2 was a swept-wing rocket aircraft built of stainless steel and **K-Monel**, a copper-nickel alloy. It was powered by a two-chamber **Curtiss-Wright XLR25** burning alcohol and liquid oxygen, continuously throttleable from 11 to 67 kN: a first on an American aircraft, derived from a JATO engine designed by **Robert Goddard** for the Navy. The programme also pioneered digital flight simulation. Air-launched from a modified B-50 bomber, the aircraft landed on skids.\n\n## Testing\nThe first glide flight took place at Edwards on 27 June 1952. On 12 May 1953 the second aircraft exploded during a captive flight under its carrier, killing Bell pilot **Jean Skip Ziegler** and a B-50 crew member. **Frank Pete Everest** made the first powered flight on 18 November 1955 and reached Mach 2.87 in July 1956. On 7 September 1956 **Iven Kincheloe** became the first pilot to climb above 30,500 m, peaking at 38,466 m. Twenty days later **Mel Apt** reached Mach 3.2, or 3,370 km/h, but turned while still above Mach 3: the aircraft fell into inertia coupling, and Apt was killed in the escape capsule.\n\n## Place in history\nThe X-2 opened the way beyond Mach 3 and delivered valuable data on aerodynamic heating and very high altitude flight. But its loss ended the programme before the NACA could begin its own research, and exposed the inadequacy of the escape capsule. The answers expected on hypersonic flight were postponed for three years, until the arrival of the **X-15**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-01-01',
    '1952-06-27',
    NULL,
    3370,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-2'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'Bell X-2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Bell X-2'), (SELECT id FROM tech WHERE name = 'Conception en acier inoxydable')),
((SELECT id FROM airplanes WHERE name = 'Bell X-2'), (SELECT id FROM tech WHERE name = 'Matériaux résistants à la chaleur'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-2'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.53,
  wingspan          = 9.83,
  height            = 3.61,
  wing_area         = 24.2,
  empty_weight      = 5613,
  mtow              = 11299,
  service_ceiling   = 38466,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Curtiss-Wright XLR25',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 66.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **46-674** : premier exemplaire, sept vols planés et dix vols propulsés, détruit le 27 septembre 1956\n- **46-675** : second exemplaire, trois vols planés, détruit en vol captif le 12 mai 1953, épave tombée dans le lac Ontario\n- **Curtiss-Wright XLR25** : moteur-fusée à deux chambres, poussée réglable en continu de 11 à 67 kN\n- **Capsule de sauvetage** détachable, freinée par un simple petit parachute, jugée très insuffisante après l''accident d''Apt',
  variants_en       = E'- **46-674**: first aircraft, seven glide flights and ten powered flights, destroyed on 27 September 1956\n- **46-675**: second aircraft, three glide flights, destroyed in a captive flight on 12 May 1953, its wreckage falling into Lake Ontario\n- **Curtiss-Wright XLR25**: two-chamber rocket engine, continuously throttleable from 11 to 67 kN\n- **Detachable escape capsule**, slowed only by a small drogue parachute, judged woefully inadequate after Apt''s accident',

  -- Strate 4 : qualitatif
  nickname          = 'Starbuster',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bell_X-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell_X-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'Bell X-2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell X-2';
