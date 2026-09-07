-- ShinMaywa US-2
--
-- Photo : A ShinMaywa US-2 flying boat at Shimousa naval air station.jpg
--   licence CC0 — Eeldrorq
--   https://commons.wikimedia.org/wiki/File%3AA_ShinMaywa_US-2_flying_boat_at_Shimousa_naval_air_station.jpg

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
    'ShinMaywa US-2',
    'ShinMaywa US-2',
    'ShinMaywa US-2',
    'ShinMaywa US-2',
    'Le dernier grand hydravion de sauvetage encore produit',
    'The last large rescue flying boat still in production',
    '/assets/airplanes/us2.jpg',
    E'## Genèse\nLe **US-1A** fait son travail mais souffre d''un défaut : sa cabine n''est pas pressurisée, ce qui l''oblige à voler bas, donc lentement et dans la turbulence. Pour un appareil de sauvetage, les heures perdues coûtent des vies. En 1996, ShinMaywa entreprend d''en refaire une version moderne autour de cette seule exigence.\n\n## Conception\nCabine pressurisée, quatre turbopropulseurs **AE 2100** de quatre mille six cents chevaux chacun, et des **commandes de vol électriques** — une première mondiale sur un hydravion, choisie pour gérer automatiquement le soufflage de couche limite dont dépend l''amerrissage lent. La coque et les performances nautiques, elles, sont héritées telles quelles du US-1A.\n\n## Carrière opérationnelle\nSept exemplaires depuis 2007, tous japonais. Ils assurent le sauvetage en mer sur tout le Pacifique occidental, et ravitaillent occasionnellement les îles isolées de l''archipel d''Ogasawara. Un US-2 s''est abîmé en mer en 2015 lors d''un exercice ; l''équipage a été récupéré.\n\n## Place dans l''histoire\nSept exemplaires, cent dix millions de dollars pièce. Le US-2 est aujourd''hui **le seul grand hydravion militaire encore produit dans le monde occidental** — la Chine construit l''AG600. Sa vente à l''Inde, discutée depuis 2013, achoppe précisément sur ce prix : le sauvetage en mer est un luxe que peu de marines s''offrent.',
    E'## Genesis\nThe **US-1A** did its job but had one flaw: its cabin is not pressurised, forcing it to fly low, therefore slowly and in turbulence. For a rescue aircraft, hours lost cost lives. In 1996 ShinMaywa set about building a modern version around that single requirement.\n\n## Design\nA pressurised cabin, four **AE 2100** turboprops of four thousand six hundred horsepower each, and **fly-by-wire** controls — a world first on a flying boat, chosen to manage automatically the boundary-layer blowing on which slow alighting depends. The hull and the seagoing performance are inherited unchanged from the US-1A.\n\n## Operational career\nSeven aircraft since 2007, all Japanese. They cover sea rescue across the western Pacific and occasionally resupply the isolated Ogasawara islands. One US-2 was lost at sea during an exercise in 2015; the crew was recovered.\n\n## Place in history\nSeven built, a hundred and ten million dollars each. The US-2 is today **the only large military flying boat still in production in the Western world** — China builds the AG600. Its sale to India, discussed since 2013, stalls on precisely that price: sea rescue is a luxury few navies afford.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1996-01-01',
    '2003-12-18',
    '2007-03-01',
    560.0,
    4700.0,
    (SELECT id FROM manufacturer WHERE code = 'SHM'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 33.3,
  wingspan          = 33.2,
  height            = 9.8,
  wing_area         = 135.8,
  empty_weight      = 25630,
  mtow              = 47700,
  service_ceiling   = 7195,
  climb_rate        = 8.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2200,
  crew              = 11,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce AE 2100J',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2003,
  production_end    = NULL,
  units_built       = 7,
  unit_cost_usd     = 110000000,
  unit_cost_year    = 2015,
  operators_count   = 1,
  variants          = E'- **US-2** : version unique, sept exemplaires livrés à la marine japonaise\n- Cabine **pressurisée**, ce que le US-1A n''avait pas : vol à sept mille mètres\n- Commandes de vol **électriques**, une première sur un hydravion\n- Conserve le **soufflage de couche limite** du US-1A et sa mer de trois mètres\n- Négocié avec l''**Inde** depuis 2013 : première exportation d''armement japonais en projet',
  variants_en       = E'- **US-2** : the only version, seven delivered to the Japanese navy\n- **Pressurised** cabin, which the US-1A lacked: cruise at seven thousand metres\n- **Fly-by-wire** controls, a first on a flying boat\n- Retains the US-1A''s **boundary-layer blowing** and its three-metre sea state\n- Under negotiation with **India** since 2013: a prospective first Japanese arms export',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/ShinMaywa_US-2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/ShinMaywa_US-2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Eeldrorq',
  image_licence     = 'CC0'
WHERE name = 'ShinMaywa US-2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'ShinMaywa US-2';
