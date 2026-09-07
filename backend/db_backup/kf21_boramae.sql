-- Korea Aerospace Industries KF-21 Boramae
--
-- Photo : KF-21 Boramae First Production.jpg
--   licence KOGL Type 1 — 대한민국 국방부 - Ministry of National Defense of the Republic of Korea
--   https://commons.wikimedia.org/wiki/File%3AKF-21_Boramae_First_Production.jpg

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
    'KAI KF-21 Boramae',
    'KAI KF-21 Boramae',
    'Korea Aerospace Industries KF-21 Boramae',
    'Korea Aerospace Industries KF-21 Boramae',
    'Chasseur sud-coréen de 4,5e génération, premier vol en 2022',
    'South Korean 4.5-generation fighter, first flight in 2022',
    '/assets/airplanes/kf21-boramae.jpg',
    E'## Genèse\nLorsque les États-Unis refusent en 2015 de transférer quatre technologies clés — radar AESA, autoprotection, optronique, brouillage — associées à l''achat de F-35, la Corée du Sud décide de les développer seule. Le KF-21 naît de ce refus autant que d''un besoin opérationnel.\n\n## Conception\nLa silhouette évoque le F-22 : entrées d''air en losange, double dérive inclinée, formes anguleuses. Mais le Block I emporte ses armes **à l''extérieur** : la signature radar est réduite, sans atteindre la furtivité d''un appareil à soutes. Le radar AESA, la centrale optronique et la suite de guerre électronique sont de conception coréenne — l''objectif industriel du programme.\n\n## Carrière opérationnelle\nPremier vol le **19 juillet 2022**, six ans après le lancement du développement — un calendrier inhabituellement tenu pour un programme de cette ampleur. La production en série démarre en 2024 ; l''entrée en service dans la force aérienne coréenne est visée pour la fin de la décennie. L''**Indonésie**, partenaire à 20 %, a connu des difficultés de paiement renégociées en 2024.\n\n## Place dans l''histoire\nLe KF-21 fait de la Corée du Sud le huitième pays à concevoir un chasseur supersonique moderne. Son positionnement — plus capable qu''un Gripen, moins furtif qu''un F-35, produit à coût maîtrisé — vise précisément le marché que les programmes européens de sixième génération laisseront vacant pendant quinze ans.',
    E'## Genesis\nWhen the United States refused in 2015 to transfer four key technologies — AESA radar, self-protection, electro-optical targeting, jamming — alongside a F-35 purchase, South Korea decided to develop them alone. The KF-21 was born as much from that refusal as from an operational need.\n\n## Design\nThe silhouette recalls the F-22: diamond intakes, canted twin tails, angular surfaces. But Block I carries its weapons **externally**: radar signature is reduced without reaching the stealth of an aircraft with internal bays. The AESA radar, the electro-optical suite and the electronic warfare system are Korean-designed — the programme’s industrial objective.\n\n## Operational career\nFirst flight on **19 July 2022**, six years after development began — an unusually well-kept schedule for a programme of this scale. Series production started in 2024; entry into Korean air force service is targeted for the end of the decade. **Indonesia**, a 20% partner, ran into payment difficulties renegotiated in 2024.\n\n## Place in history\nThe KF-21 makes South Korea the eighth country to design a modern supersonic fighter. Its positioning — more capable than a Gripen, less stealthy than an F-35, built at controlled cost — targets precisely the market that European sixth-generation programmes will leave open for fifteen years.',
    (SELECT id FROM countries WHERE code = 'ROK'),
    '2015-01-01',
    '2022-07-19',
    NULL,
    2200.0,
    2900.0,
    (SELECT id FROM manufacturer WHERE code = 'KAI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'En développement',
    'In development'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM tech WHERE name = 'Radar AESA')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM tech WHERE name = 'Fusion de capteurs')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM armement WHERE name = 'Meteor')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM armement WHERE name = 'IRIS-T')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM armement WHERE name = 'GBU-31 JDAM'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.9,
  wingspan          = 11.2,
  height            = 4.7,
  wing_area         = 46.5,
  empty_weight      = 11800,
  mtow              = 25600,
  service_ceiling   = 16700,
  climb_rate        = NULL,
  g_limit_pos       = 9.0,
  g_limit_neg       = -3.0,
  combat_radius     = 1000,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F414-GE-400K',
  engine_count      = 2,
  engine_type       = 'Turbofan avec postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 62.3,
  thrust_wet        = 97.9,

  -- Strate 3 : production & service
  production_start  = 2024,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = 65000000,
  unit_cost_year    = 2021,
  operators_count   = 1,
  variants          = E'- **Block I** : capacité air-air, emport externe, en production depuis 2024\n- **Block II** : capacité air-sol complète, prévue à partir de 2028\n- **Block III** : soutes internes envisagées, non financées à ce jour\n- **Indonésie** : partenaire à 20 % du programme, sous la désignation **IF-X**\n\n*Programme en cours : plusieurs caractéristiques restent provisoires.*',
  variants_en       = E'- **Block I** : air-to-air capability, external carriage, in production since 2024\n- **Block II** : full air-to-ground capability, planned from 2028\n- **Block III** : internal bays under consideration, not funded to date\n- **Indonesia** : 20% programme partner, under the **IF-X** designation\n\n*Programme ongoing: several characteristics remain provisional.*',

  -- Strate 4 : qualitatif
  nickname          = 'Boramae',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/KAI_KF-21_Boramae',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/KAI_KF-21_Boramae',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '대한민국 국방부 - Ministry of National Defense of the Republic of Korea',
  image_licence     = 'KOGL Type 1'
WHERE name = 'KAI KF-21 Boramae';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'KAI KF-21 Boramae';
