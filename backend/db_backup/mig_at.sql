-- Mikoyan MiG-AT
--
-- Photo : Mikoyan-Gurevich, 81, Mikoyan-Gurevich MiG-AT (36521881604).jpg
--   licence CC BY-SA 2.0 — Anna Zvereva from Tallinn, Estonia
--   https://commons.wikimedia.org/wiki/File:Mikoyan-Gurevich,_81,_Mikoyan-Gurevich_MiG-AT_(36521881604).jpg

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
    'Mikoyan MiG-AT',
    'Mikoyan MiG-AT',
    'Mikoyan MiG-AT',
    'Mikoyan MiG-AT',
    'L''avion-école franco-russe de Mikoyan, battu par le Yak-130 pour succéder aux L-29 et L-39',
    'Mikoyan''s Franco-Russian jet trainer, beaten by the Yak-130 to succeed the L-29 and L-39',
    '/assets/airplanes/mig-at.jpg',
    E'## Genèse\nÀ la fin de l''ère soviétique, l''armée de l''air cherche à remplacer ses avions-écoles **Aero L-29** et **L-39**. Le bureau **Mikoyan** affronte Soukhoï, Miassichtchev et **Yakovlev** ; en 1992, il ne reste que le MiG-AT et le **Yak-130**. La dissolution de l''URSS et l''effondrement des budgets de défense poussent Mikoyan à s''associer à des industriels français : **Snecma/Turbomeca** fournit les moteurs, **Sextant Avionique** l''avionique. C''est le premier programme d''avion mené en commun par la Russie et la France.\n\n## Conception\nPlus classique que son concurrent, le MiG-AT a une aile basse et droite, un réacteur de chaque côté du fuselage et un empennage horizontal à mi-hauteur de la dérive. Ses deux **Larzac 04R20** de 14,1 kN, conçus dans les années 1970 pour l''**Alpha Jet**, s''accompagnent d''écrans à cristaux liquides, d''un collimateur tête haute et de commandes de vol électriques qui lui permettent d''imiter le comportement des chasseurs de troisième et de quatrième génération. Le second prototype reçoit une avionique russe et des points d''emport pour l''armement.\n\n## Essais\nConstruit sur fonds propres par **MAPO**, le premier exemplaire, « 81 blanc », sort d''usine en mai 1995. Après un premier bond début mars 1996 à Joukovski, le vol officiel a lieu le 21 mars : **Roman Taskaïev** le pilote durant 45 minutes. Le second prototype rejoint les essais en octobre 1997. Mais le cahier des charges glisse vers un avion d''entraînement doté d''une vraie capacité de combat, et le 10 avril 2002, le Yak-130 est déclaré vainqueur. Les deux prototypes totalisent alors 750 vols. La certification militaire russe, obtenue en février 2004, ne débouche sur aucune commande, malgré des démonstrations devant l''Algérie, la Grèce, l''Inde et les Émirats arabes unis.\n\n## Place dans l''histoire\nLe MiG-AT reste le premier projet militaire mené entre la Russie et l''Occident à avoir pris l''air. Mikoyan contesta le choix du Yak-130, jugeant l''exigence de charge militaire trop lourde pour un avion-école. Les deux prototypes servirent ensuite de bancs d''essai aux moteurs russes **RD-1700** et **AL-55I**. En 2018, United Aircraft Corporation évoqua une relance ; en décembre 2023, elle annonça le **MiG-UTS**, monoréacteur présenté comme son héritier spirituel.',
    E'## Genesis\nAt the end of the Soviet era the air force sought to replace its **Aero L-29** and **L-39** jet trainers. The **Mikoyan** bureau competed against Sukhoi, Myasishchev and **Yakovlev**; by 1992 only the MiG-AT and the **Yak-130** remained. The dissolution of the Soviet Union and the fall in defence spending led Mikoyan to team up with French firms: **Snecma/Turbomeca** supplied the engines and **Sextant Avionique** the avionics. It was the first joint aircraft development programme between Russia and France.\n\n## Design\nMore conventional than its rival, the MiG-AT has a low-set straight wing, an engine on each side of the fuselage and a tailplane mounted midway up the fin. Its two **Larzac 04R20** engines of 14.1 kN, developed in the 1970s for the **Alpha Jet**, were paired with liquid crystal displays, a head-up display and fly-by-wire controls that allowed it to mimic the handling of third- and fourth-generation fighters. The second prototype received Russian avionics and hardpoints for weapons.\n\n## Testing\nBuilt with its own funds by **MAPO**, the first aircraft, ''81 White'', was rolled out in May 1995. After a short hop in early March 1996 at Zhukovsky, the official first flight took place on 21 March, with **Roman Taskayev** at the controls for 45 minutes. The second prototype joined the test programme in October 1997. But the requirement drifted towards a trainer with a real combat capability, and on 10 April 2002 the Yak-130 was declared the winner. By then the two prototypes had made 750 flights. Russian military certification, obtained in February 2004, led to no orders, despite demonstrations to Algeria, Greece, India and the United Arab Emirates.\n\n## Place in history\nThe MiG-AT remains the first military collaborative project between Russia and the West to fly. Mikoyan protested against the choice of the Yak-130, arguing that the weapons load requirement was too great for a trainer. Both prototypes later served as test beds for the Russian **RD-1700** and **AL-55I** engines. In 2018 United Aircraft Corporation raised the prospect of a revival; in December 2023 it announced the single-engine **MiG-UTS**, presented as its spiritual successor.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    NULL,
    '1996-03-21',
    NULL,
    1000,
    1200,
    (SELECT id FROM manufacturer WHERE code = 'MIG'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM tech WHERE name = 'Réacteur Larzac 04'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM armement WHERE name = 'GSh-23')),
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM armement WHERE name = 'S-8')),
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM armement WHERE name = 'R-73'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Mikoyan MiG-AT'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.01,
  wingspan          = 10.16,
  height            = 4.42,
  wing_area         = 17.67,
  empty_weight      = NULL,
  mtow              = 7800,
  service_ceiling   = 14000,
  climb_rate        = 81.7,
  g_limit_pos       = 8,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Snecma-Turbomeca Larzac 04-R20',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 14.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **MiG-AT** : biplace d''entraînement de base, deux prototypes (1996 et 1997)\n- **Second prototype** : avionique russe et points d''emport pour l''armement\n- **MiG-AC** : projet de monoplace de combat à fuselage raccourci\n- **MiG-ATC** : projet d''entraînement et de combat léger avec désignation d''objectifs sur casque',
  variants_en       = E'- **MiG-AT**: two-seat basic trainer, two prototypes (1996 and 1997)\n- **Second prototype**: Russian avionics and hardpoints for weapons\n- **MiG-AC**: proposed single-seat combat version with a shortened fuselage\n- **MiG-ATC**: proposed trainer and light combat version with helmet-mounted target designation',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Mikoyan-Gourevitch_MiG-AT',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Mikoyan_MiG-AT',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Anna Zvereva',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Mikoyan MiG-AT';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mikoyan MiG-AT';
