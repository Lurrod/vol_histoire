-- Iliouchine Il-78 (Midas)
--
-- Photo : Il-78 Midas.jpg
--   licence Public domain — Staff Sgt. Gerald Currington.
--   https://commons.wikimedia.org/wiki/File%3AIl-78_Midas.jpg

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
    'Iliouchine Il-78 Midas',
    'Ilyushin Il-78 Midas',
    'Iliouchine Il-78 (Midas)',
    'Ilyushin Il-78 (Midas)',
    'Ravitailleur soviétique à trois postes, dérivé de l’Il-76',
    'Three-station Soviet tanker derived from the Il-76',
    '/assets/airplanes/il78-midas.jpg',
    E'## Genèse\nL''aviation soviétique ravitaille jusque-là avec des **Miassichtchev M-4** convertis, appareils des années 1950 dont la flotte s''épuise. Il faut une cellule moderne et disponible : l''**Il-76**, produit en série depuis dix ans, s''impose. Iliouchine en tire un ravitailleur en logeant deux réservoirs cylindriques dans la soute et en installant trois postes de transfert.\n\n## Conception\nContrairement aux Américains, l''URSS n''a jamais adopté la perche rigide : le Midas emploie le **tuyau souple et le panier**, système plus lent mais plus simple, et surtout compatible avec l''ensemble des chasseurs soviétiques. Trois avions peuvent être ravitaillés simultanément. La version initiale conserve la rampe arrière et ses réservoirs amovibles, ce qui permet de revenir au transport en quelques heures — souplesse que l''Il-78M abandonnera au profit de la capacité.\n\n## Carrière opérationnelle\nIl accompagne les bombardiers stratégiques russes dans leurs patrouilles au long cours, soutient l''aviation russe au-dessus de la **Syrie** à partir de 2015, puis l''effort au-dessus de l''Ukraine. L''**Inde**, l''Algérie, la Chine et le Pakistan l''exploitent également ; l''appareil indien a été modifié avec des nacelles israéliennes, combinaison inhabituelle.\n\n## Place dans l''histoire\nCinquante-trois exemplaires seulement, contre huit cent trois **KC-135** : l''écart mesure une différence de doctrine autant que de moyens. L''aviation soviétique était pensée pour agir depuis ses frontières, non pour se projeter d''un continent à l''autre. La production a repris en Russie avec l''Il-78M-90A, signe d''une ambition plus lointaine.',
    E'## Genesis\nSoviet aviation had until then refuelled with converted **Myasishchev M-4s**, 1950s aircraft whose fleet was wearing out. A modern and available airframe was needed: the **Il-76**, in series production for ten years, was the obvious choice. Ilyushin turned it into a tanker by fitting two cylindrical tanks in the hold and installing three transfer stations.\n\n## Design\nUnlike the Americans, the USSR never adopted the flying boom: the Midas uses the **hose and drogue**, a slower but simpler system, and above all one compatible with every Soviet fighter. Three aircraft can be refuelled at once. The initial version keeps the rear ramp and its removable tanks, allowing reversion to transport within hours — flexibility the Il-78M gave up in favour of capacity.\n\n## Operational career\nIt accompanies Russian strategic bombers on long-range patrols, supported Russian aviation over **Syria** from 2015, and then the effort over Ukraine. **India**, Algeria, China and Pakistan also operate it; the Indian aircraft were modified with Israeli pods, an unusual combination.\n\n## Place in history\nOnly fifty-three built, against eight hundred and three **KC-135s**: the gap measures a difference of doctrine as much as of means. Soviet aviation was conceived to act from its own borders, not to project from one continent to another. Production has resumed in Russia with the Il-78M-90A, a sign of longer reach.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1980-01-01',
    '1983-06-26',
    '1987-01-01',
    850.0,
    7300.0,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-78 Midas'), (SELECT id FROM wars WHERE name = 'Invasion russe de l''Ukraine'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 46.59,
  wingspan          = 50.5,
  height            = 14.76,
  wing_area         = 300.0,
  empty_weight      = 98000,
  mtow              = 210000,
  service_ceiling   = 12000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 4000,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Aviadvigatel D-30KP-2',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 117.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1984,
  production_end    = NULL,
  units_built       = 53,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **Il-78** : version initiale, réservoirs amovibles permettant le retour au transport\n- **Il-78M** : réservoirs fixes, capacité accrue, rampe arrière supprimée\n- **Il-78MKI** : version indienne, nacelles israéliennes, six exemplaires\n- **Il-78M-90A** : version modernisée à moteurs PS-90, en production\n- **Trois postes de transfert** : deux sous voilure et un en bout de fuselage',
  variants_en       = E'- **Il-78** : initial version, with removable tanks allowing reversion to transport\n- **Il-78M** : fixed tanks, greater capacity, rear ramp deleted\n- **Il-78MKI** : Indian version with Israeli pods, six aircraft\n- **Il-78M-90A** : modernised version with PS-90 engines, in production\n- **Three transfer stations** : two under the wings and one at the tail',

  -- Strate 4 : qualitatif
  nickname          = 'Midas',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-78',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-78',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Gerald Currington.',
  image_licence     = 'Public domain'
WHERE name = 'Iliouchine Il-78 Midas';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-78 Midas';
