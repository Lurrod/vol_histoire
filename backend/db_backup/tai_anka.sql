-- TAI Anka
--
-- Photo : ANKA TUSAS.jpg
--   licence CC BY-SA 4.0 — Mustafa Karabaş (TUSAŞ)
--   https://commons.wikimedia.org/wiki/File:ANKA_TUSAS.jpg

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
    'TAI Anka',
    'TAI Anka',
    'TAI Anka (Anka-S)',
    'TAI Anka (Anka-S)',
    'Le drone MALE de l’industriel d’État turc, pour ne plus dépendre des Heron israéliens',
    'The Turkish state manufacturer’s MALE drone, built to end reliance on Israeli Herons',
    '/assets/airplanes/tai-anka.jpg',
    E'## Genèse\nAu milieu des années 2000, l''aviation turque dépend de drones importés : des **IAI Heron** israéliens, livrés en retard et dont l''emploi reste soumis au bon vouloir du fournisseur. En décembre 2004, l''agence d''armement turque confie à **TAI** (Turkish Aerospace Industries) le développement d''un drone de moyenne altitude et longue endurance (MALE) national. L''Anka — le phénix de la mythologie turque — vole pour la première fois le **30 décembre 2010**.\n\n## Conception\nUne architecture classique de drone MALE : fuselage en matériaux composites, longue aile droite de 17,5 mètres et moteur à pistons propulsif. La version de série **Anka-S** ajoute une **liaison satellite**, qui affranchit l''appareil de la portée radio, et deux points d''emport sous voilure pour des munitions légères de Roketsan comme la **MAM-L**. La masse maximale est de 1,7 tonne et l''endurance annoncée atteint une trentaine d''heures. Les premiers moteurs, importés, sont remplacés par le diesel turc **TEI PD170**.\n\n## Carrière opérationnelle\nL''Anka-S entre en service dans l''aviation turque en 2017. Il est engagé contre le PKK en Turquie et en Irak, puis dans les opérations turques en **Syrie** : Rameau d''olivier (2018), Source de paix (2019) et Bouclier du printemps (2020), au cours de laquelle plusieurs exemplaires sont abattus par la défense antiaérienne syrienne. D''autres sont perdus en Libye en 2020. Le 5 octobre 2023, un drone turc identifié par la presse comme un Anka est abattu par un F-16 américain au-dessus de la province syrienne d''Hassaké. À l''export, il équipe la Tunisie et le Kazakhstan, qui a signé un accord de production locale ; l''Indonésie et la Malaisie en ont commandé.\n\n## Place dans l''histoire\nL''Anka est le premier drone MALE conçu et produit en Turquie. Il a été éclipsé médiatiquement par le **Bayraktar TB2** de Baykar, plus léger et moins cher, mais c''est lui qui a fondé la filière d''État turque, prolongée par l''Aksungur bimoteur et l''Anka-3 à aile volante. Avec le TB2, il a fait de la Turquie l''un des rares pays capables de concevoir, produire et exporter toute une gamme de drones armés.',
    E'## Genesis\nIn the mid-2000s the Turkish air force depended on imported drones: Israeli **IAI Herons**, delivered late and whose use remained subject to the supplier''s goodwill. In December 2004 Turkey''s defence procurement agency awarded **TAI** (Turkish Aerospace Industries) the development of a national medium-altitude long-endurance (MALE) drone. The Anka — the phoenix of Turkish mythology — first flew on **30 December 2010**.\n\n## Design\nA classic MALE drone layout: composite fuselage, a long 17.5-metre straight wing and a pusher piston engine. The production **Anka-S** adds a **satellite link**, freeing the aircraft from radio range, and two underwing hardpoints for light Roketsan munitions such as the **MAM-L**. Maximum weight is 1.7 tonnes and the announced endurance reaches around thirty hours. The first engines, imported, were replaced by the Turkish **TEI PD170** diesel.\n\n## Operational career\nThe Anka-S entered Turkish air force service in 2017. It was used against the PKK in Turkey and Iraq, then in Turkey''s operations in **Syria**: Olive Branch (2018), Peace Spring (2019) and Spring Shield (2020), during which several were shot down by Syrian air defences. Others were lost in Libya in 2020. On 5 October 2023 a Turkish drone identified by the press as an Anka was shot down by an American F-16 over Syria''s Hasakah province. For export it equips Tunisia and Kazakhstan, which signed a local production agreement; Indonesia and Malaysia have ordered it.\n\n## Place in history\nThe Anka is the first MALE drone designed and built in Turkey. It was overshadowed in the media by Baykar''s lighter and cheaper **Bayraktar TB2**, but it founded the Turkish state industry, continued by the twin-engined Aksungur and the flying-wing Anka-3. Together with the TB2 it made Turkey one of the few countries able to design, build and export a whole range of armed drones.',
    (SELECT id FROM countries WHERE code = 'TUR'),
    '2004-12-24',
    '2010-12-30',
    '2017-03-01',
    217.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'TAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Drone de combat'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM armement WHERE name = 'MAM-L'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'TAI Anka'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.6,
  wingspan          = 17.5,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = NULL,
  mtow              = 1700,
  service_ceiling   = 9150,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'TEI PD170',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Anka-A** : version initiale de surveillance, sans armement\n- **Anka-B** : ajoute un **radar à synthèse d''ouverture**\n- **Anka-S** : version de série à **liaison satellite**, armée de munitions Roketsan\n- **Anka-I** : version de renseignement électronique\n- Moteur diesel turc **TEI PD170** en remplacement du moteur importé d''origine',
  variants_en       = E'- **Anka-A** : initial unarmed surveillance version\n- **Anka-B** : adds a **synthetic aperture radar**\n- **Anka-S** : production version with a **satellite link**, armed with Roketsan munitions\n- **Anka-I** : electronic intelligence version\n- Turkish **TEI PD170** diesel engine replacing the original imported engine',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/TAI_Anka',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/TAI_Anka',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mustafa Karabaş (TUSAŞ)',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'TAI Anka';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'TAI Anka';
