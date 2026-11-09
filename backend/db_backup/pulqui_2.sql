-- FMA IAe 33 Pulqui II
--
-- Photo : IA-X-33 FMA Pulqui II (8164224820).jpg
--   licence CC BY-SA 3.0 — Aeroprints.com
--   https://commons.wikimedia.org/wiki/File:IA-X-33_FMA_Pulqui_II_(8164224820).jpg

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
    'IAe 33 Pulqui II',
    'IAe 33 Pulqui II',
    'FMA IAe 33 Pulqui II',
    'FMA IAe 33 Pulqui II',
    'Kurt Tank à Córdoba : le chasseur à aile en flèche que l’Argentine n’a jamais produit',
    'Kurt Tank in Córdoba: the swept-wing fighter Argentina never put into production',
    '/assets/airplanes/pulqui-2.jpg',
    E'## Genèse\nAprès 1945, l''Argentine de **Juan Perón** veut une industrie aéronautique capable de concevoir ses propres chasseurs. Elle recrute des ingénieurs européens, dont le plus célèbre est **Kurt Tank**, père du Focke-Wulf Fw 190, installé à l''Institut aérotechnique de **Córdoba** sous un nom d''emprunt. Le pays a déjà fait voler en 1947 le Pulqui I, premier avion à réaction conçu en Amérique latine, mais son aile droite le rend dépassé avant même d''exister. Tank reprend alors les idées de son dernier projet de guerre, le **Ta 183**.\n\n## Conception\nUne aile haute en flèche de 40°, un empennage en T, une entrée d''air frontale et un réacteur **Rolls-Royce Nene II** de 22 kN — le moteur dont la copie soviétique propulse au même moment le MiG-15, issu lui aussi des études allemandes. Les deux appareils se ressemblent pour cette raison. Le Pulqui II prévoit quatre canons de 20 mm, mais l''aile haute lui donne un comportement délicat au décrochage, que les essais peineront à corriger.\n\n## Carrière opérationnelle\nAucune. Premier vol le **27 juin 1950**, aux mains du capitaine Edmundo Weiss. Cinq cellules sont construites, dont une pour les essais statiques ; deux prototypes sont perdus en accident, et l''un d''eux coûte la vie au pilote d''essai Otto Behrens. Le renversement de Perón en septembre 1955 prive le programme de son protecteur : Tank part pour l''Inde. Un dernier prototype vole en 1959, mais l''Argentine achète en 1960 des **F-86 Sabre** américains, disponibles et bon marché. Le programme s''arrête.\n\n## Place dans l''histoire\nEn 1950, très peu de pays avaient fait voler un chasseur à réaction à aile en flèche de leur propre conception ; l''Argentine était du nombre. Le Pulqui II montre pourtant la limite d''une industrie bâtie autour de quelques ingénieurs étrangers et d''un régime : leur départ suffit à l''éteindre. Kurt Tank appliquera à Bangalore ce qu''il a appris à Córdoba, sur le **HAL HF-24 Marut**. Le cinquième prototype est conservé au musée national de l''aéronautique de Morón.',
    E'## Genesis\nAfter 1945 **Juan Perón**’s Argentina wanted an aircraft industry able to design its own fighters. It recruited European engineers, the best known being **Kurt Tank**, father of the Focke-Wulf Fw 190, settled under an assumed name at the Aerotechnical Institute in **Córdoba**. The country had already flown the Pulqui I in 1947, the first jet aircraft designed in Latin America, but its straight wing made it obsolete before it existed. Tank turned to the ideas of his last wartime project, the **Ta 183**.\n\n## Design\nA high wing swept at 40°, a T-tail, a nose intake and a **Rolls-Royce Nene II** of 22 kN — the engine whose Soviet copy was at the same moment powering the MiG-15, itself born of German studies. The two aircraft look alike for that reason. The Pulqui II was to carry four 20 mm cannon, but the high wing gave it tricky stall behaviour, which testing struggled to correct.\n\n## Operational career\nNone. First flight on **27 June 1950**, flown by Captain Edmundo Weiss. Five airframes were built, one of them for static testing; two prototypes were lost in accidents, one of which killed test pilot Otto Behrens. Perón’s overthrow in September 1955 deprived the programme of its patron: Tank left for India. A last prototype flew in 1959, but in 1960 Argentina bought American **F-86 Sabres**, available and cheap. The programme ended.\n\n## Place in history\nIn 1950 very few countries had flown a swept-wing jet fighter of their own design; Argentina was one of them. Yet the Pulqui II shows the limit of an industry built around a handful of foreign engineers and one regime: their departure was enough to extinguish it. Kurt Tank would apply in Bangalore what he had learned in Córdoba, on the **HAL HF-24 Marut**. The fifth prototype is preserved at the national aeronautical museum at Morón.',
    (SELECT id FROM countries WHERE code = 'ARG'),
    '1948-01-01',
    '1950-06-27',
    NULL,
    1080.0,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'FMA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'IAe 33 Pulqui II'), (SELECT id FROM tech WHERE name = 'Aile en flèche'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'IAe 33 Pulqui II'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'IAe 33 Pulqui II'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.68,
  wingspan          = 10.6,
  height            = 3.5,
  wing_area         = 25.1,
  empty_weight      = 3736,
  mtow              = 6793,
  service_ceiling   = 15000,
  climb_rate        = 25.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Nene II',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Prototype 01** : cellule d''essais statiques, jamais envolée\n- **Prototypes 02 à 04** : prototypes de vol, premier vol le 27 juin 1950 ; deux perdus en accident\n- **Pulqui IIe (05)** : dernier prototype, premier vol en septembre 1959, conservé à Morón\n- **IAe 27 Pulqui I** : prédécesseur à aile droite (1947), premier jet conçu en Amérique latine',
  variants_en       = E'- **Prototype 01** : static test airframe, never flown\n- **Prototypes 02 to 04** : flying prototypes, first flight on 27 June 1950; two lost in accidents\n- **Pulqui IIe (05)** : last prototype, first flight in September 1959, preserved at Morón\n- **IAe 27 Pulqui I** : straight-wing predecessor (1947), the first jet designed in Latin America',

  -- Strate 4 : qualitatif
  nickname          = 'Pulqui',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/FMA_IAe_33_Pulqui_II',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aeroprints.com',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'IAe 33 Pulqui II';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'IAe 33 Pulqui II';
