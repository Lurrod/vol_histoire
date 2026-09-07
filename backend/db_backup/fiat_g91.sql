-- Fiat G.91
--
-- Photo : German Fiat G.91R-3 of LeKG 43 at Kleine Brogel Air Base, Belgium, in July 1970 (176246984).jpg
--   licence Public domain — Master Sgt. H.D. Robinson, U.S. Air Force photo 342-C-KE-62474
--   https://commons.wikimedia.org/wiki/File%3AGerman_Fiat_G.91R-3_of_LeKG_43_at_Kleine_Brogel_Air_Base%2C_Belgium%2C_in_July_1970_%28176246984%29.jpg

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
    'Fiat G.91',
    'Fiat G.91',
    'Fiat G.91',
    'Fiat G.91',
    'Chasseur léger de l’OTAN, seul vainqueur d’un concours européen commun',
    'NATO light fighter, sole winner of a joint European competition',
    '/assets/airplanes/fiat-g91.jpg',
    E'## Genèse\nEn 1953, l''OTAN lance son premier — et dernier — concours d''armement réellement commun : un **chasseur léger d''appui** capable d''opérer depuis des terrains sommaires, bon marché, et adopté par toute l''Alliance. Neuf projets concourent, dont le Breguet Taon français et le Dassault Étendard VI. Le Fiat G.91 l''emporte en 1957.\n\n## Conception\nSilhouette de F-86 Sabre réduite d''un tiers, aile à 37° de flèche, réacteur Orpheus unique et léger. Le train est conçu pour l''herbe et les pistes sommaires ; l''entretien est réduit au strict minimum. Dix mètres de long pour trois tonnes à vide : c''est l''un des avions de combat à réaction les plus petits jamais produits en série.\n\n## Carrière opérationnelle\nL''unanimité promise ne viendra pas : la France et le Royaume-Uni refusent d''acheter italien. Seules l''**Italie**, l''**Allemagne** — qui en construit plus de 300 sous licence — le **Portugal** et la **Grèce** l''adopteront. Le Portugal l''engage intensivement dans ses guerres coloniales en Angola, en Guinée et au Mozambique.\n\n## Place dans l''histoire\nL''échec politique du programme a durablement marqué la coopération européenne en armement : plus aucun concours commun de cette nature n''a été tenté. Le G.91 reste pourtant en service jusqu''en 1995 au Portugal, remplacé en Italie par l''**AMX** et en Allemagne par l''**Alpha Jet**.',
    E'## Genesis\nIn 1953 NATO launched its first — and last — genuinely joint armament competition: a **light support fighter** able to operate from rough strips, cheap, and adopted across the Alliance. Nine designs competed, including the French Breguet Taon and Dassault Étendard VI. The Fiat G.91 won in 1957.\n\n## Design\nThe silhouette of an F-86 Sabre reduced by a third, a 37° swept wing, and a single light Orpheus engine. The landing gear was designed for grass and rough strips; maintenance was cut to a minimum. Ten metres long for three tonnes empty: one of the smallest jet combat aircraft ever series-built.\n\n## Operational career\nThe promised unanimity never came: France and Britain refused to buy Italian. Only **Italy**, **Germany** — which licence-built more than 300 — **Portugal** and **Greece** adopted it. Portugal used it intensively in its colonial wars in Angola, Guinea and Mozambique.\n\n## Place in history\nThe programme’s political failure left a lasting mark on European armament cooperation: no joint competition of that kind has been attempted since. The G.91 nevertheless served until 1995 in Portugal, replaced in Italy by the **AMX** and in Germany by the **Alpha Jet**.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1953-01-01',
    '1956-08-09',
    '1958-08-01',
    1075.0,
    1150.0,
    (SELECT id FROM manufacturer WHERE code = 'FIAT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.3,
  wingspan          = 8.56,
  height            = 4.0,
  wing_area         = 16.4,
  empty_weight      = 3100,
  mtow              = 5500,
  service_ceiling   = 13100,
  climb_rate        = 30,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 320,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Siddeley Orpheus 803',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1977,
  units_built       = 756,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **G.91R** : version de reconnaissance armée, trois caméras dans le nez\n- **G.91T** : biplace d''entraînement\n- **G.91Y** : version bimoteur, puissance et emport doublés\n- Construit sous licence en **Allemagne** par Dornier, Messerschmitt et Heinkel',
  variants_en       = E'- **G.91R** : armed reconnaissance version with three nose cameras\n- **G.91T** : two-seat trainer\n- **G.91Y** : twin-engine version with double the power and payload\n- Licence-built in **Germany** by Dornier, Messerschmitt and Heinkel',

  -- Strate 4 : qualitatif
  nickname          = 'Gina',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fiat_G.91',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fiat_G.91',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Master Sgt. H.D. Robinson, U.S. Air Force photo 342-C-KE-62474',
  image_licence     = 'Public domain'
WHERE name = 'Fiat G.91';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fiat G.91';
