-- Breguet Br.1050 Alizé
--
-- Photo : AirExpo 2016 - Bréguet Alizé.jpg
--   licence CC BY-SA 4.0 — Clément Gruin
--   https://commons.wikimedia.org/wiki/File%3AAirExpo_2016_-_Br%C3%A9guet_Aliz%C3%A9.jpg

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
    'Breguet Alizé',
    'Breguet Alizé',
    'Breguet Br.1050 Alizé',
    'Breguet Br.1050 Alizé',
    'Chasseur de sous-marins embarqué, quarante ans sur les porte-avions français',
    'Carrier-borne submarine hunter, forty years aboard French carriers',
    '/assets/airplanes/alize.jpg',
    E'## Genèse\nLa France des années 1950 arme deux porte-avions, le *Clemenceau* et le *Foch*, et doit y embarquer un chasseur de sous-marins. Breguet part d''un projet abandonné, le **Br.960 Vultur** — un bombardier à hélice et réacteur — dont il conserve la cellule en supprimant le réacteur et en remplaçant l''hélice par un turbopropulseur **Dart** britannique.\n\n## Conception\nLe trait le plus visible est le **radar rétractable** logé sous le fuselage : sorti, il balaie la mer ; rentré, il ne coûte rien en traînée. Trois hommes travaillent à bord, dont deux tournés vers les écrans. L''appareil emporte torpilles, charges de profondeur et roquettes, et vole huit heures à basse vitesse — ce qu''exige la traque d''un sous-marin.\n\n## Carrière opérationnelle\nQuatre-vingt-neuf exemplaires. L''Aéronavale l''exploite de 1959 à **2000**, quarante et un ans, y compris pendant la guerre du Golfe où il assure la surveillance de surface. L''**Inde** en achète dix-sept et les engage lors des guerres de 1965 et 1971 ; un Alizé indien est abattu par un F-104 pakistanais en 1971.\n\n## Place dans l''histoire\nQuatre-vingt-neuf exemplaires et quarante et un ans de service. L''Alizé est le dernier appareil embarqué à hélice de la marine française, et le dernier avion militaire portant le nom de **Breguet**, maison fondée en 1911 et absorbée par Dassault en 1971. Son successeur, l''**Atlantique 2**, opère depuis la terre.',
    E'## Genesis\nFrance in the 1950s was arming two carriers, *Clemenceau* and *Foch*, and needed a submarine hunter aboard them. Breguet started from an abandoned project, the **Br.960 Vultur** — a mixed propeller-and-jet bomber — keeping its airframe, deleting the jet and replacing the propeller with a British **Dart** turboprop.\n\n## Design\nThe most visible feature is the **retractable radar** under the fuselage: extended it sweeps the sea; retracted it costs nothing in drag. Three men work aboard, two of them facing screens. The aircraft carries torpedoes, depth charges and rockets, and flies for eight hours at low speed — which is what hunting a submarine demands.\n\n## Operational career\nEighty-nine built. French naval aviation flew it from 1959 to **2000**, forty-one years, including through the Gulf War where it provided surface surveillance. **India** bought seventeen and used them in the wars of 1965 and 1971; an Indian Alizé was shot down by a Pakistani F-104 in 1971.\n\n## Place in history\nEighty-nine built and forty-one years of service. The Alizé is the last propeller-driven carrier aircraft of the French navy, and the last military aircraft to bear the name **Breguet**, a house founded in 1911 and absorbed by Dassault in 1971. Its successor, the **Atlantique 2**, operates from land.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1948-01-01',
    '1956-10-06',
    '1959-05-01',
    518.0,
    2500.0,
    (SELECT id FROM manufacturer WHERE code = 'BRG'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM armement WHERE name = 'Mk 46')),
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Alizé'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.86,
  wingspan          = 15.6,
  height            = 5.0,
  wing_area         = 36.0,
  empty_weight      = 5700,
  mtow              = 8200,
  service_ceiling   = 6250,
  climb_rate        = 6.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 650,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Dart RDa.21',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1962,
  units_built       = 89,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Br.1050 Alizé** : version unique, quatre-vingt-neuf exemplaires\n- Dérivé du **Br.960 Vultur**, bombardier embarqué à moteur mixte abandonné\n- **Radar rétractable** dans le ventre, sorti seulement pendant la recherche\n- Trois places : pilote, opérateur radar et navigateur, côte à côte et derrière\n- Vendu à l''**Inde**, qui l''a engagé au combat lors des guerres indo-pakistanaises',
  variants_en       = E'- **Br.1050 Alizé** : the only version, eighty-nine built\n- Derived from the **Br.960 Vultur**, an abandoned mixed-power carrier bomber\n- **Retractable radar** in the belly, extended only during the search\n- Three seats: pilot, radar operator and navigator, side by side and behind\n- Sold to **India**, which used it in combat in the Indo-Pakistani wars',

  -- Strate 4 : qualitatif
  nickname          = 'Alizé',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Breguet_Alizé',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Breguet_Alizé',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Clément Gruin',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Breguet Alizé';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Breguet Alizé';
