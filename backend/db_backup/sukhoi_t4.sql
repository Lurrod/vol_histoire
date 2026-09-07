-- Soukhoï T-4 (Sotka)
--
-- Photo : Sukhoi T-4 (Monino museum).JPG
--   licence CC BY 2.5 — Sergey Dukachev
--   https://commons.wikimedia.org/wiki/File%3ASukhoi_T-4_%28Monino_museum%29.JPG

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
    'Sukhoi T-4',
    'Sukhoi T-4',
    'Soukhoï T-4 (Sotka)',
    'Sukhoi T-4 (Sotka)',
    'Réponse soviétique au XB-70, en titane soudé, arrêtée après dix vols',
    'Soviet answer to the XB-70, in welded titanium, stopped after ten flights',
    '/assets/airplanes/sukhoi-t4.jpg',
    E'## Genèse\nLe XB-70 américain effraie Moscou. En 1961, l''URSS lance un programme symétrique : un bombardier de Mach 3 capable de traquer les porte-avions américains à trois mille kilomètres des côtes. Trois bureaux concourent ; **Soukhoï l''emporte** contre Tupolev et Yakovlev, ce qui est en soi une surprise, la firme n''ayant jamais construit de gros porteur.\n\n## Conception\nLa vitesse impose le matériau : à Mach 3, l''aluminium flue. La cellule est donc en **titane et acier inoxydable soudés**, ce qui oblige l''industrie soviétique à inventer de toutes pièces la soudure du titane sous atmosphère neutre, des outils de coupe et des rivets adaptés. Six cents brevets en sortiront. Le nez bascule comme celui du Concorde ; en croisière, l''équipage vole sans aucune vision extérieure, au périscope et aux instruments.\n\n## Carrière opérationnelle\nAucune. L''unique exemplaire vole dix fois entre 1972 et 1974, atteint Mach 1,36 seulement — les essais à pleine vitesse n''auront jamais lieu. Le programme est arrêté officiellement pour libérer l''usine de Tushino au profit du **MiG-23**, en réalité parce que le Tu-160 à géométrie variable paraît plus utile et que les missiles balistiques ont, là aussi, changé la donne.\n\n## Place dans l''histoire\nUn seul exemplaire, mais six cents brevets et une maîtrise du titane qui servira directement au **MiG-25** et au Tu-160. Comme le **XB-70**, il illustre une génération entière d''ingénieurs lancés à la poursuite d''une invulnérabilité par la vitesse que le missile sol-air venait déjà de rendre illusoire.',
    E'## Genesis\nThe American XB-70 frightened Moscow. In 1961 the USSR launched a symmetrical programme: a Mach 3 bomber able to hunt American carriers three thousand kilometres offshore. Three bureaux competed; **Sukhoi won** against Tupolev and Yakovlev, itself a surprise since the firm had never built a large aircraft.\n\n## Design\nSpeed dictated the material: at Mach 3 aluminium creeps. The airframe is therefore in **welded titanium and stainless steel**, which forced Soviet industry to invent from scratch titanium welding under inert atmosphere, suitable cutting tools and rivets. Six hundred patents came out of it. The nose droops like Concorde''s; in cruise the crew flies with no outside view at all, on a periscope and instruments.\n\n## Operational career\nNone. The single aircraft flew ten times between 1972 and 1974 and reached only Mach 1.36 — full-speed trials never took place. The programme was officially stopped to free the Tushino factory for the **MiG-23**, in reality because the swing-wing Tu-160 looked more useful and because ballistic missiles had, here too, changed everything.\n\n## Place in history\nA single aircraft, but six hundred patents and a command of titanium that fed directly into the **MiG-25** and the Tu-160. Like the **XB-70**, it illustrates a whole generation of engineers chasing an invulnerability through speed that the surface-to-air missile had already made illusory.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1961-01-01',
    '1972-08-22',
    NULL,
    3200.0,
    7000.0,
    (SELECT id FROM manufacturer WHERE code = 'SUK'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 44.5,
  wingspan          = 22.0,
  height            = 11.2,
  wing_area         = 295.7,
  empty_weight      = 55600,
  mtow              = 135000,
  service_ceiling   = 25000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Kolesov RD36-41',
  engine_count      = 4,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 98.0,
  thrust_wet        = 157.0,

  -- Strate 3 : production & service
  production_start  = 1971,
  production_end    = 1974,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **T-4 (101)** : unique exemplaire achevé, dix vols entre 1972 et 1974\n- **T-4 (102) et (103)** : deux cellules en cours d''assemblage à l''arrêt du programme\n- **T-4MS** : projet de version à géométrie variable, écarté au profit du Tu-160\n- Nez **basculant** à la manière du Concorde, la verrière étant aveugle en croisière\n- L''exemplaire survivant est exposé au musée de Monino, près de Moscou',
  variants_en       = E'- **T-4 (101)** : the only aircraft completed, ten flights between 1972 and 1974\n- **T-4 (102) and (103)** : two airframes under assembly when the programme stopped\n- **T-4MS** : proposed swing-wing version, dropped in favour of the Tu-160\n- **Drooping nose** in the manner of Concorde, the canopy being blind in cruise\n- The surviving aircraft is displayed at the Monino museum, near Moscow',

  -- Strate 4 : qualitatif
  nickname          = 'Sotka',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Soukhoï_T-4',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Sukhoi_T-4',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Sergey Dukachev',
  image_licence     = 'CC BY 2.5'
WHERE name = 'Sukhoi T-4';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Sukhoi T-4';
