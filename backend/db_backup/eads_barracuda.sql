-- EADS Barracuda
--
-- Photo : Barracuda av dr.jpg
--   licence CC BY-SA 3.0 — Jean-Patrick Donzey
--   https://commons.wikimedia.org/wiki/File:Barracuda_av_dr.jpg

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
    'EADS Barracuda',
    'EADS Barracuda',
    'EADS Barracuda',
    'EADS Barracuda',
    'Démonstrateur germano-espagnol de drone furtif, développé en secret, plus gros drone construit en Europe en 2006',
    'A secret German-Spanish stealthy drone demonstrator, Europe''s largest UAV when it appeared in 2006',
    '/assets/airplanes/eads-barracuda.jpg',
    E'## Genèse\nLe **Barracuda** naît d''une étude de drone destinée à faire entrer **EADS** sur le marché des drones de moyenne altitude et longue endurance, que le groupe juge dominé par les États-Unis et Israël. Son développement commence en 2003, dans le secret, avec le soutien principal de l''Allemagne et de l''Espagne ; il est financé surtout par Airbus et par le ministère fédéral allemand de la Défense et ses agences d''acquisition et d''essais. Le drone est révélé au salon aéronautique international ILA en 2006 : c''est alors le plus gros drone jamais construit en Europe. Il passe pour le concurrent du démonstrateur **nEUROn**, mené par la France, auquel l''Espagne participe pourtant aussi.\n\n## Conception\nLe Barracuda est un démonstrateur de formes furtives, même si ses concepteurs n''ont jamais mesuré sa signature. Sa cellule est entièrement en fibre de carbone, à l''exception du longeron d''aile métallique, conçu pour que les ailes se démontent facilement pour le transport. Hormis le train, il n''utilise aucune hydraulique, mais des vérins électriques, et un unique réacteur à double flux **Pratt & Whitney JT15D** le pousse jusqu''à Mach 0,85. Une longue soute accueille jusqu''à 300 kg de charges, surtout de reconnaissance : détecteur d''émissions, radar à synthèse d''ouverture, capteurs électro-optiques.\n\n## Essais\nLe premier vol a lieu le 2 avril 2006 à San Javier, près de Murcie : vingt minutes entièrement autonomes, suivies depuis le sol par sécurité. Le 23 septembre 2006, le prototype s''abîme dans la Mar Menor en approche finale, et le programme est suspendu jusqu''en 2008. Un second prototype, achevé en novembre 2008, vole avec succès à **Goose Bay**, au Canada, en juillet 2009, puis essaie en 2010 l''évitement de collision, le roulage automatique et la détection automatique de cibles. En 2012, aux frais d''EADS, il valide la navigation autonome en quatre dimensions et le vol coopératif avec un second drone.\n\n## Place dans l''histoire\nLe Barracuda devait surtout accumuler l''expérience nécessaire aux drones opérationnels de la génération suivante, notamment pour voler dans l''espace aérien partagé avec les avions civils. Retiré après six campagnes d''essais, il a légué ses technologies, selon Airbus, à l''**Eurodrone** et au système de combat aérien du futur (**SCAF**).',
    E'## Genesis\nThe **Barracuda** began as a UAV design study meant to take **EADS** into the market for medium-altitude long-endurance drones, which the group saw as dominated by the United States and Israel. Development started in secret in 2003, mainly backed by Germany and Spain, and was financed chiefly by Airbus and by the German Federal Ministry of Defence and its procurement and test agencies. The drone was unveiled at the 2006 ILA International Aerospace Exhibition: it was then the largest UAV ever built in Europe. It was seen as a competitor to the French-led **nEUROn** demonstrator, in which Spain also took part.\n\n## Design\nThe Barracuda was a stealth-shaped demonstrator, although its designers never measured its signature. Its airframe was made entirely of carbon fibre, apart from a metal wing spar designed so that the wings could easily be removed for transport. Apart from the landing gear it used no hydraulics, relying on electric actuators, and a single **Pratt & Whitney JT15D** turbofan pushed it to Mach 0.85. A long bay carried up to 300 kg of payload, mostly for reconnaissance: an emitter location system, a synthetic aperture radar and electro-optical sensors.\n\n## Testing\nThe first flight took place on 2 April 2006 at San Javier, near Murcia: twenty fully autonomous minutes, monitored from the ground for safety. On 23 September 2006 the prototype crashed into the Mar Menor on final approach, and the programme was put on hold until 2008. A second prototype, completed in November 2008, flew successfully at **Goose Bay**, Canada, in July 2009, then tested sense-and-avoid, automatic taxiing and automatic target detection in 2010. In 2012, at EADS''s own expense, it validated autonomous four-dimensional navigation and cooperative flight with a second drone.\n\n## Place in history\nThe Barracuda was above all meant to build the experience needed for the next generation of operational drones, notably to fly in airspace shared with civil aircraft. Retired after six test campaigns, it passed its technologies on, according to Airbus, to the **Eurodrone** and the Future Combat Air System (**FCAS**).',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '2003-01-01',
    '2006-04-02',
    NULL,
    1041,
    200,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 5),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'EADS Barracuda'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'EADS Barracuda'), (SELECT id FROM tech WHERE name = 'Matériaux composites')),
((SELECT id FROM airplanes WHERE name = 'EADS Barracuda'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'EADS Barracuda'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.25,
  wingspan          = 7.22,
  height            = NULL,
  wing_area         = NULL,
  empty_weight      = 2300,
  mtow              = 3250,
  service_ceiling   = 6100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney JT15D',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 14.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Premier prototype** : premier vol le 2 avril 2006 à San Javier, perdu dans la Mar Menor le 23 septembre 2006\n- **Second prototype** : achevé en novembre 2008, essais à Goose Bay en 2009, campagnes de 2010 et 2012',
  variants_en       = E'- **First prototype**: first flight on 2 April 2006 at San Javier, lost in the Mar Menor on 23 September 2006\n- **Second prototype**: completed in November 2008, Goose Bay trials in 2009, 2010 and 2012 campaigns',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/EADS_Barracuda',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/EADS_Barracuda',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jean-Patrick Donzey',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'EADS Barracuda';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'moderee' WHERE name = 'EADS Barracuda';
