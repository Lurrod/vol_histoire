-- Aero Vodochody L-159 ALCA
--
-- Photo : Aero L-159 (6063) in flight (1).jpg
--   licence CC BY-SA 2.0 — Milan Nykodym from Kutna Hora, Czech Republic
--   https://commons.wikimedia.org/wiki/File%3AAero_L-159_%286063%29_in_flight_%281%29.jpg

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
    'Aero L-159 ALCA',
    'Aero L-159 ALCA',
    'Aero Vodochody L-159 ALCA',
    'Aero Vodochody L-159 ALCA',
    'Dérivé de combat de l’Albatros, seul avion d’attaque tchèque',
    'Combat derivative of the Albatros, the only Czech attack aircraft',
    '/assets/airplanes/l159-alca.jpg',
    E'## Genèse\nAprès la dissolution de la Tchécoslovaquie et la fin du marché captif du Pacte de Varsovie, Aero Vodochody perd d''un coup ses débouchés. La survie passe par la montée en gamme : transformer l''**L-39 Albatros**, entraîneur simple, en un appareil d''attaque compatible OTAN.\n\n## Conception\nLa cellule de l''Albatros est renforcée et remotorisée avec un F124 occidental, presque le double de poussée. S''y ajoutent un **radar Grifo-L**, sept points d''emport, une avionique aux normes OTAN et un cockpit compatible jumelles de vision nocturne. Le résultat n''est plus un entraîneur armé mais un appareil d''attaque léger à part entière.\n\n## Carrière opérationnelle\nSoixante-douze exemplaires, dont la moitié restera longtemps stockée faute de budget tchèque. L''**Irak** en achète quinze en 2015 et les engage contre l''État islamique. Une trentaine d''autres sont vendus à des sociétés privées américaines qui les exploitent comme **plastrons d''entraînement** pour l''US Air Force — cas rare d''appareils de combat ex-Pacte de Varsovie sous contrat américain.\n\n## Place dans l''histoire\nL''ALCA est la trace industrielle de la reconversion d''une aéronautique du bloc de l''Est vers les standards occidentaux. La République tchèque, elle, a fini par louer des **Gripen** suédois pour sa défense aérienne, faute de pouvoir tirer de son propre appareil un chasseur complet.',
    E'## Genesis\nAfter Czechoslovakia dissolved and the Warsaw Pact’s captive market vanished, Aero Vodochody lost its outlets overnight. Survival meant moving upmarket: turning the **L-39 Albatros**, a simple trainer, into a NATO-compatible attack aircraft.\n\n## Design\nThe Albatros airframe was strengthened and re-engined with a Western F124 of nearly double the thrust. Added to it were a **Grifo-L radar**, seven hardpoints, NATO-standard avionics and a cockpit compatible with night vision goggles. The result is no longer an armed trainer but a light attack aircraft in its own right.\n\n## Operational career\nSeventy-two built, half of which sat in storage for years for want of Czech budget. **Iraq** bought fifteen in 2015 and used them against the Islamic State. Around thirty more were sold to American private companies operating them as **aggressor aircraft** for the US Air Force — a rare case of ex-Warsaw Pact combat aircraft under American contract.\n\n## Place in history\nThe ALCA is the industrial trace of an Eastern bloc aviation sector converting to Western standards. The Czech Republic itself ended up leasing Swedish **Gripens** for air defence, unable to draw a full fighter from its own aircraft.',
    (SELECT id FROM countries WHERE code = 'CSK'),
    '1992-01-01',
    '1997-08-02',
    '2000-04-01',
    936.0,
    2530.0,
    (SELECT id FROM manufacturer WHERE code = 'AERO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM tech WHERE name = 'Radar multi-mode')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM armement WHERE name = 'AGM-65 Maverick')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM armement WHERE name = 'Hydra 70'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aero L-159 ALCA'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.72,
  wingspan          = 9.54,
  height            = 4.77,
  wing_area         = 18.8,
  empty_weight      = 4160,
  mtow              = 8000,
  service_ceiling   = 13200,
  climb_rate        = 45,
  g_limit_pos       = 8.0,
  g_limit_neg       = -4.0,
  combat_radius     = 570,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Honeywell/ITEC F124-GA-100',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 28.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1997,
  production_end    = 2003,
  units_built       = 72,
  unit_cost_usd     = 12000000,
  unit_cost_year    = 2000,
  operators_count   = 4,
  variants          = E'- **L-159A** : monoplace d''attaque légère à radar Grifo-L\n- **L-159T1 / T2** : biplaces d''entraînement et de conversion\n- **L-159E** : version d''exportation, exploitée par la société privée **Draken International** comme plastron d''entraînement\n- Vendus à l''**Irak** en 2015 pour la lutte contre l''État islamique',
  variants_en       = E'- **L-159A** : single-seat light attack version with Grifo-L radar\n- **L-159T1 / T2** : two-seat trainer and conversion versions\n- **L-159E** : export version, operated by the private company **Draken International** as an aggressor\n- Sold to **Iraq** in 2015 for the campaign against the Islamic State',

  -- Strate 4 : qualitatif
  nickname          = 'ALCA',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aero_L-159_Alca',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aero_L-159_Alca',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Milan Nykodym from Kutna Hora, Czech Republic',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Aero L-159 ALCA';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aero L-159 ALCA';
