-- Dassault Super Mirage 4000
--
-- Photo : Mirage 4000 at Paris Air Show 1981-2.jpg
--   licence CC BY-SA 4.0 — Acroterion
--   https://commons.wikimedia.org/wiki/File%3AMirage_4000_at_Paris_Air_Show_1981-2.jpg

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
    'Mirage 4000',
    'Mirage 4000',
    'Dassault Super Mirage 4000',
    'Dassault Super Mirage 4000',
    'Financé sur fonds propres par Dassault, et jamais vendu',
    'Funded by Dassault out of its own pocket, and never sold',
    '/assets/airplanes/mirage4000.jpg',
    E'## Genèse\nAu milieu des années 1970, Dassault développe le **Mirage 2000** pour l''armée de l''air française. Marcel Dassault estime pourtant qu''il manque une gamme au-dessus, pour les clients riches du Golfe qui veulent un rayon d''action et un emport de F-15. L''État français ne finance pas : la firme décide de **payer elle-même** un chasseur bimoteur de trente-deux tonnes.\n\n## Conception\nLe 4000 est un Mirage 2000 doublé : même aile delta, même philosophie de commandes électriques, mais deux **M53** au lieu d''un, une voilure de soixante-treize mètres carrés et, nouveauté chez Dassault, des **canards mobiles** en avant de l''aile qui améliorent la maniabilité et le décollage. Le rayon d''action dépasse mille huit cents kilomètres, le double d''un Mirage 2000.\n\n## Carrière opérationnelle\nAucune. Un exemplaire, trois cent trente-six vols entre 1979 et 1988. L''appareil est offert à l''**Arabie saoudite**, qui préfère le F-15, puis à l''**Irak**, qui manque d''argent après huit ans de guerre contre l''Iran. Sans commande, Dassault ne peut assumer seul l''industrialisation.\n\n## Place dans l''histoire\nUn exemplaire, conservé au musée du Bourget. Le pari privé a échoué mais n''a pas été perdu : les canards, l''architecture bimoteur et les commandes de vol du 4000 se retrouvent, quinze ans plus tard, dans le **Rafale** — qui est, à peu de choses près, le Mirage 4000 que l''État a fini par financer.',
    E'## Genesis\nIn the mid-1970s Dassault was developing the **Mirage 2000** for the French air force. Marcel Dassault nevertheless judged that a class above was missing, for the wealthy Gulf customers who wanted F-15 range and payload. The French state would not fund it: the firm decided to **pay for itself** a thirty-two-tonne twin-engined fighter.\n\n## Design\nThe 4000 is a doubled Mirage 2000: the same delta wing, the same fly-by-wire philosophy, but two **M53s** instead of one, seventy-three square metres of wing and, new for Dassault, **moving canards** ahead of the wing that improve handling and take-off. Range exceeds eighteen hundred kilometres, twice a Mirage 2000''s.\n\n## Operational career\nNone. One aircraft, three hundred and thirty-six flights between 1979 and 1988. It was offered to **Saudi Arabia**, which preferred the F-15, then to **Iraq**, out of money after eight years of war with Iran. With no order, Dassault could not carry industrialisation alone.\n\n## Place in history\nOne built, preserved at the Le Bourget museum. The private gamble failed but was not wasted: the canards, the twin-engined architecture and the flight controls of the 4000 reappear fifteen years later in the **Rafale** — which is, near enough, the Mirage 4000 the state finally paid for.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1976-01-01',
    '1979-03-09',
    NULL,
    2445.0,
    3800.0,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Multirôle'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM tech WHERE name = 'Aile delta-canard')),
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM tech WHERE name = 'Radar RDM/RDI'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM armement WHERE name = 'DEFA 554')),
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM armement WHERE name = 'Matra Super 530F')),
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM armement WHERE name = 'Matra R550 Magic'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mirage 4000'), (SELECT id FROM missions WHERE name = 'Interception'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.7,
  wingspan          = 12.0,
  height            = 5.8,
  wing_area         = 73.0,
  empty_weight      = 13000,
  mtow              = 32000,
  service_ceiling   = 20000,
  climb_rate        = 300.0,
  g_limit_pos       = 9.0,
  g_limit_neg       = NULL,
  combat_radius     = 1850,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'SNECMA M53-2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 54.9,
  thrust_wet        = 83.4,

  -- Strate 3 : production & service
  production_start  = 1977,
  production_end    = 1979,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Mirage 4000-01** : un seul exemplaire, trois cent trente-six vols de 1979 à 1988\n- Deux fois la masse d''un **Mirage 2000**, dont il reprend l''aile delta et les commandes\n- **Canards** mobiles en avant de l''aile, une première chez Dassault\n- Financé **intégralement** par Dassault, sans un franc de l''État français\n- Proposé à l''Arabie saoudite puis à l''Irak, refusé par les deux ; l''appareil est au Bourget',
  variants_en       = E'- **Mirage 4000-01** : a single aircraft, three hundred and thirty-six flights, 1979–1988\n- Twice the weight of a **Mirage 2000**, whose delta wing and controls it reuses\n- Moving **canards** ahead of the wing, a first for Dassault\n- Funded **entirely** by Dassault, without a franc from the French state\n- Offered to Saudi Arabia then Iraq, refused by both; the aircraft is at Le Bourget',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_4000',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Mirage_4000',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Acroterion',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Mirage 4000';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mirage 4000';
