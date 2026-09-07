-- Supermarine Swift
--
-- Photo : Supermarine Swift FR.5 ‘WK277 N’ (50317153116).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3ASupermarine_Swift_FR.5_%E2%80%98WK277_N%E2%80%99_%2850317153116%29.jpg

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
    'Supermarine Swift',
    'Supermarine Swift',
    'Supermarine Swift',
    'Supermarine Swift',
    'Premier chasseur à aile en flèche de la RAF, et son plus retentissant échec',
    'The RAF’s first swept-wing fighter, and its most resounding failure',
    '/assets/airplanes/swift.jpg',
    E'## Genèse\nLa Corée révèle en 1950 que la RAF n''a aucun chasseur à aile en flèche, quand les MiG-15 en ont déjà. Londres réagit par une politique dite de **super-priorité** : commander en série, avant tout essai, deux appareils concurrents pour être certain d''en avoir un. Le Swift de Supermarine et le **Hawker Hunter** entrent ainsi en production sans avoir été mis au point.\n\n## Conception\nSupermarine dérive le Swift de son Attacker à aile droite en lui greffant une flèche — la même démarche que Republic avec le F-84F, et avec les mêmes ennuis. L''aile est trop épaisse, les gouvernes perdent leur efficacité à l''approche de Mach 1, et le canon **s''enraye systématiquement** dès qu''on tire en altitude. La postcombustion, elle, s''éteint en virage serré.\n\n## Carrière opérationnelle\nMis en service en février 1954, le Swift est interdit de vol au-dessus de sept mille six cents mètres, puis interdit de tir au canon, puis retiré du service de chasse en **mars 1955** — treize mois de carrière. Le Hunter, lui, servira trente ans. Seule la version de reconnaissance à basse altitude FR.5 se révèle bonne et sert honorablement en Allemagne jusqu''en 1961.\n\n## Place dans l''histoire\nCent quatre-vingt-dix-sept exemplaires pour treize mois de service opérationnel : le Swift est l''exemple canonique de ce que produit une commande de série passée avant les essais. Il a détruit la réputation de **Supermarine**, la firme du Spitfire, qui ne concevra plus qu''un seul avion de combat — le Scimitar — avant de disparaître dans BAC.',
    E'## Genesis\nKorea revealed in 1950 that the RAF had no swept-wing fighter, while the MiG-15s already did. London responded with a policy known as **super-priority**: order into production, before any testing, two competing aircraft so as to be sure of having one. Supermarine''s Swift and the **Hawker Hunter** thus entered production before they had been developed.\n\n## Design\nSupermarine derived the Swift from its straight-winged Attacker by grafting on sweep — the same approach Republic took with the F-84F, and with the same troubles. The wing is too thick, the controls lose effectiveness approaching Mach 1, and the cannon **jammed every time** it was fired at altitude. The afterburner, for its part, blew out in a hard turn.\n\n## Operational career\nEntering service in February 1954, the Swift was barred from flying above seven thousand six hundred metres, then barred from firing its guns, then withdrawn from fighter service in **March 1955** — thirteen months of career. The Hunter would serve thirty years. Only the low-level FR.5 reconnaissance version proved good, serving creditably in Germany until 1961.\n\n## Place in history\nOne hundred and ninety-seven built for thirteen months of operational service: the Swift is the textbook example of what a production order placed before testing produces. It destroyed the reputation of **Supermarine**, the firm behind the Spitfire, which would design only one more combat aircraft — the Scimitar — before disappearing into BAC.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1946-01-01',
    '1951-08-01',
    '1954-02-01',
    1102.0,
    1175.0,
    (SELECT id FROM manufacturer WHERE code = 'SUP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Supermarine Swift'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.65,
  wingspan          = 9.85,
  height            = 3.81,
  wing_area         = 29.73,
  empty_weight      = 6094,
  mtow              = 9707,
  service_ceiling   = 13720,
  climb_rate        = 61.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon RA.7',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 33.4,
  thrust_wet        = 42.3,

  -- Strate 3 : production & service
  production_start  = 1953,
  production_end    = 1957,
  units_built       = 197,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Swift F.1 / F.2** : chasseurs, interdits de vol au-dessus de 7 600 m puis retirés en un an\n- **Swift F.4** : bat le **record du monde de vitesse** en Libye le 26 septembre 1953\n- **Swift FR.5** : reconnaissance tactique à basse altitude, la seule version réussie\n- **Swift F.7** : banc d''essai du missile Fireflash, jamais opérationnel\n- Dernier avion de combat portant le nom **Supermarine**, créateur du Spitfire',
  variants_en       = E'- **Swift F.1 / F.2** : fighters, barred from flight above 7,600 m then withdrawn within a year\n- **Swift F.4** : took the **world air speed record** in Libya on 26 September 1953\n- **Swift FR.5** : low-level tactical reconnaissance, the only successful version\n- **Swift F.7** : testbed for the Fireflash missile, never operational\n- The last combat aircraft to bear the **Supermarine** name, creator of the Spitfire',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Supermarine_Swift',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Supermarine_Swift',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Supermarine Swift';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Supermarine Swift';
