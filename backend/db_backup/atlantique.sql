-- Breguet Br.1150 Atlantic / Atlantique 2
--
-- Photo : An air to air right front view of a French navy Breguet 1150 Atlantic aircraft - DPLA - 3c6cb7ecbf3b5c51735cb02d70620fbc.jpeg
--   licence CC BY-SA 2.0 — bertknot from scarborough, australia
--   https://commons.wikimedia.org/wiki/File%3ABreguet_Br.1150_Atlantic_%2813%29_%2832149310998%29.jpg

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
    'Breguet Atlantique',
    'Breguet Atlantic',
    'Breguet Br.1150 Atlantic / Atlantique 2',
    'Breguet Br.1150 Atlantic / Atlantique 2',
    'Patrouilleur maritime né d’un programme OTAN, toujours en service soixante ans après',
    'Maritime patroller born of a NATO programme, still in service sixty years on',
    '/assets/airplanes/atlantique.jpg',
    E'## Genèse\nL''OTAN lance en 1958 un appel d''offres pour un patrouilleur maritime commun destiné à remplacer les Neptune américains dans les marines européennes. Vingt-cinq projets concourent ; celui de Breguet l''emporte en 1959. Le programme est confié à un **consortium européen** — français, allemand, néerlandais, belge et italien — l''une des toutes premières coopérations industrielles de l''aéronautique européenne, bien avant Airbus.\n\n## Conception\nLa cellule est faite d''un **double fuselage** en huit couché : la partie supérieure, pressurisée, abrite l''équipage de douze hommes et ses consoles ; la partie inférieure, non pressurisée, forme la soute à armement et à bouées acoustiques. Deux turbopropulseurs Tyne, réputés économiques, autorisent dix-huit heures de vol. Un détecteur d''anomalies magnétiques allonge la queue, et un radar en dôme ventral balaie la mer.\n\n## Carrière opérationnelle\nTraque anti-sous-marine dans l''Atlantique et la Méditerranée pendant la guerre froide, surveillance des approches du porte-avions français, lutte contre la piraterie et le narcotrafic. L''ATL2 a surtout connu une seconde vie inattendue : équipé de bombes guidées et de sa caméra, il a mené des frappes et du renseignement **au-dessus de l''Afghanistan, du Mali, de l''Irak et de la Syrie** — un patrouilleur maritime employé au-dessus du désert.\n\n## Place dans l''histoire\nCent quinze exemplaires et soixante ans de service, avec une modernisation qui le portera jusqu''en 2035. Il aura été à la fois un précurseur de la coopération industrielle européenne et l''un des appareils les plus polyvalents de l''aéronavale française, capable de passer de la chasse au sous-marin au tir de bombe guidée sur un objectif terrestre.',
    E'## Genesis\nIn 1958 NATO issued a tender for a common maritime patroller to replace the American Neptunes in European navies. Twenty-five designs competed; Breguet''s won in 1959. The programme was entrusted to a **European consortium** — French, German, Dutch, Belgian and Italian — one of the very first industrial collaborations in European aviation, long before Airbus.\n\n## Design\nThe airframe is a **double fuselage** shaped like a lying figure of eight: the upper, pressurised part houses the twelve-man crew and its consoles; the lower, unpressurised part forms the weapons and sonobuoy bay. Two Tyne turboprops, noted for economy, allow eighteen hours aloft. A magnetic anomaly detector extends the tail, and a radar in a ventral dome sweeps the sea.\n\n## Operational career\nAnti-submarine hunting in the Atlantic and Mediterranean through the Cold War, screening the French carrier''s approaches, anti-piracy and counter-narcotics patrol. The ATL2 above all had an unexpected second life: fitted with guided bombs and its camera, it carried out strikes and intelligence gathering **over Afghanistan, Mali, Iraq and Syria** — a maritime patroller employed over desert.\n\n## Place in history\nOne hundred and fifteen built and sixty years of service, with an upgrade that will carry it to 2035. It was at once a forerunner of European industrial cooperation and one of the most versatile aircraft in French naval aviation, able to move from hunting a submarine to dropping a guided bomb on a target ashore.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1958-01-01',
    '1961-10-21',
    '1965-12-10',
    648.0,
    9075.0,
    (SELECT id FROM manufacturer WHERE code = 'BRG'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM armement WHERE name = 'AM39 Exocet')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM armement WHERE name = 'Mk 46')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM armement WHERE name = 'Bombe lisse 250 kg')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 31.75,
  wingspan          = 37.42,
  height            = 10.89,
  wing_area         = 120.34,
  empty_weight      = 25700,
  mtow              = 46200,
  service_ceiling   = 9145,
  climb_rate        = 12.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3300,
  crew              = 12,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Tyne RTy.20 Mk 21',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1965,
  production_end    = 1998,
  units_built       = 115,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **Br.1150 Atlantic** : première génération, quatre-vingt-sept exemplaires\n- **Atlantique 2 (ATL2)** : refonte française à électronique nouvelle, vingt-huit exemplaires\n- **Atlantique 2 Standard 6** : modernisation en cours, service prolongé jusqu''en 2035\n- **Atlantic ATL3** : proposition d''export à moteurs Allison, restée sans commande\n- Employé par la **France**, l''**Allemagne**, l''**Italie**, les **Pays-Bas** et le **Pakistan**',
  variants_en       = E'- **Br.1150 Atlantic** : the first generation, eighty-seven built\n- **Atlantique 2 (ATL2)** : French rebuild with new electronics, twenty-eight built\n- **Atlantique 2 Standard 6** : upgrade under way, extending service to 2035\n- **Atlantic ATL3** : export proposal with Allison engines, never ordered\n- Operated by **France**, **Germany**, **Italy**, the **Netherlands** and **Pakistan**',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Breguet_Br_1150_Atlantic',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Breguet_Atlantique',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Department of Defense',
  image_licence     = 'Public domain'
WHERE name = 'Breguet Atlantique';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Breguet Atlantique';
