-- Antonov An-70
--
-- Photo : Antonov An-70 in 2008.jpg
--   licence CC BY-SA 3.0 — Oleg V. Belyakov
--   https://commons.wikimedia.org/wiki/File:Antonov_An-70_in_2008.jpg

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
    'Antonov An-70',
    'Antonov An-70',
    'Antonov An-70',
    'Antonov An-70',
    'Le premier avion propulsé uniquement par des propfans, victime de la rupture entre Kiev et Moscou',
    'The first aircraft powered solely by propfans, a casualty of the rift between Kyiv and Moscow',
    '/assets/airplanes/an70.jpg',
    E'## Genèse\nDès le milieu des années 1970, le bureau Antonov réfléchit au successeur de l''**An-12**. En 1987, le ministère soviétique de la Défense précise le besoin : chargement rapide, terrains courts et non préparés, 300 soldats, exploitation économique. Le contrat est signé en mai 1989 et la construction du premier prototype commence à Kiev en 1991. L''effondrement de l''URSS bouscule le programme, repris en juin 1993 par la Russie et l''Ukraine, la première devant en financer 80 %. Le prototype vole enfin le 16 décembre 1994 depuis Sviatochyn : c''est le premier avion propulsé uniquement par des propfans.\n\n## Conception\nQuatre moteurs **Progress D-27** de 13 880 ch entraînent chacun deux hélices contrarotatives en cimeterre, de huit et six pales, dont le souffle balaie une aile supercritique à volets à double fente. Selon l''évaluation de DASA, ces propfans sont 10 % plus efficaces que des turbopropulseurs classiques. L''An-70 croise à 750 km/h, décolle de 600 m de terre battue avec 25 t et peut emporter un char T-80U de 47 t. Un quart de la cellule est en matériaux composites et les prototypes disposent de commandes de vol électriques.\n\n## Essais\nLe premier prototype est détruit le 10 février 1995, lors de son quatrième vol, après une collision avec l''An-72 qui l''accompagnait ; les sept membres d''équipage périssent. Le second, tiré de la cellule d''essais statiques, vole le 24 avril 1997, puis se pose sur le ventre à Omsk le 27 janvier 2001. Entre-temps, l''Allemagne l''étudie pour le programme européen Future Large Aircraft, finalement attribué à l''**Airbus A400M**. La Russie se retire en 2006, revient en 2009, puis quitte le projet en 2012. Les essais d''État s''achèvent en avril 2014 et l''An-70 entre officiellement en service dans l''armée de l''air ukrainienne en janvier 2015.\n\n## Place dans l''histoire\nL''An-70 n''a pas dépassé le stade des deux prototypes, malgré plus de 5 milliards de dollars investis et des centaines de commandes annoncées par Moscou et Kiev. La rupture entre les deux pays à partir de 2014 a privé de partenaire un programme fondé sur leur coopération, et la Russie l''a écarté de ses achats en 2015. En 2024, des images satellites montrent un An-70 garé à Dęblin, en Pologne, à l''abri de la guerre. Sa formule survit dans les projets An-77 et An-188.',
    E'## Genesis\nAs early as the mid-1970s the Antonov bureau was considering a successor to the **An-12**. In 1987 the Soviet Ministry of Defence set out the requirement: quick loading, short and unprepared airfields, 300 troops and economical operation. The contract was signed in May 1989 and construction of the first prototype began in Kyiv in 1991. The collapse of the Soviet Union upset the programme, which Russia and Ukraine took up jointly in June 1993, with Russia expected to provide 80 per cent of the funding. The prototype finally flew from Sviatoshyn on 16 December 1994: the first aircraft powered solely by propfans.\n\n## Design\nFour 13,880 hp **Progress D-27** engines each drive two contra-rotating scimitar propellers, of eight and six blades, whose slipstream washes a supercritical wing with double-slotted flaps. According to the DASA evaluation, these propfans were 10 per cent more efficient than conventional turboprops. The An-70 cruises at 750 km/h, can lift off a 600 m dirt strip with 25 tonnes and can carry a 47-tonne T-80U tank. A quarter of the airframe is made of composites, and the prototypes had fly-by-wire controls.\n\n## Testing\nThe first prototype was destroyed on 10 February 1995, on its fourth flight, after colliding with the An-72 chase aircraft; all seven crew were killed. The second, converted from the static test airframe, flew on 24 April 1997, then belly-landed at Omsk on 27 January 2001. Meanwhile Germany studied it for the European Future Large Aircraft programme, eventually awarded to the **Airbus A400M**. Russia withdrew in 2006, returned in 2009 and left the project in 2012. State trials ended in April 2014, and the An-70 officially entered service with the Ukrainian Air Force in January 2015.\n\n## Place in history\nThe An-70 never went beyond two prototypes, despite more than $5 billion invested and hundreds of orders announced by Moscow and Kyiv. The rift between the two countries from 2014 deprived a programme built on their cooperation of its partner, and Russia ruled it out of state procurement in 2015. In 2024 satellite imagery showed an An-70 parked at Dęblin in Poland, away from the war. Its formula lives on in the An-77 and An-188 projects.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1987-01-01',
    '1994-12-16',
    '2015-01-01',
    780,
    8000,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-70'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-70'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'Antonov An-70'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-70'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 40.73,
  wingspan          = 44.06,
  height            = 16.38,
  wing_area         = NULL,
  empty_weight      = 66230,
  mtow              = 145000,
  service_ceiling   = 12000,
  climb_rate        = 24.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Progress D-27 (13 880 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur à hélices contrarotatives',
  engine_type_en    = 'Contra-rotating turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1991,
  production_end    = 2015,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **An-70** : version militaire, deux prototypes, le second modernisé en 2010-2012 avec un équipage réduit à quatre\n- **An-70T** : version civile de l''An-70 de base\n- **An-7X** : version « occidentalisée » proposée pour le programme européen Future Large Aircraft\n- **An-77** : version modernisée proposée en 2017 aux États-Unis, puis avec Turkish Aerospace\n- **An-188** : projet lancé en 2015 à quatre réacteurs, concurrent direct de l''A400M',
  variants_en       = E'- **An-70**: military version, two prototypes, the second upgraded in 2010-2012 with the crew reduced to four\n- **An-70T**: civil version of the basic An-70\n- **An-7X**: "westernised" version offered for the European Future Large Aircraft programme\n- **An-77**: modernised version proposed in 2017 to the United States, then with Turkish Aerospace\n- **An-188**: four-jet project launched in 2015 as a direct competitor to the A400M',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-70',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-70',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Oleg V. Belyakov',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Antonov An-70';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-70';
