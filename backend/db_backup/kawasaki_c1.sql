-- Kawasaki C-1
--
-- Photo : Kawasaki C-1 on ground 10.jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File%3AKawasaki_C-1_on_ground_10.jpg

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
    'Kawasaki C-1',
    'Kawasaki C-1',
    'Kawasaki C-1',
    'Kawasaki C-1',
    'Transport dont la Constitution japonaise a bridé le rayon d’action',
    'Transport whose range was capped by the Japanese Constitution',
    '/assets/airplanes/kawasaki-c1.jpg',
    E'## Genèse\nLe Japon remplace en 1966 ses C-46 américains hérités de l''occupation. Le programme est confié à Kawasaki, et il porte une contrainte que l''ingénierie ne connaît nulle part ailleurs : l''**article 9 de la Constitution**, qui interdit toute capacité offensive. Un transport capable d''atteindre le continent asiatique serait politiquement inacceptable. Le rayon d''action est donc **bridé à dessein**.\n\n## Conception\nAile en flèche montée haut, deux réacteurs en nacelles, rampe arrière, train logé dans des carénages latéraux : la formule est classique et bien exécutée. La soute accepte un obusier ou quarante-cinq parachutistes. Le compromis se lit dans les réservoirs, dimensionnés pour mille trois cents kilomètres — de quoi relier n''importe quel point de l''archipel, et rien au-delà.\n\n## Carrière opérationnelle\nIl assure pendant cinquante ans la logistique intérieure japonaise, les secours après séismes et typhons, et l''entraînement au parachutage. Sa limite se révèle dès que Tokyo veut participer aux opérations de l''ONU : le C-1 ne peut simplement pas s''y rendre. La version EC-1 de guerre électronique reste, elle, en service au-delà du retrait des transports.\n\n## Place dans l''histoire\nTrente et un exemplaires seulement. Il est sans doute le seul avion du catalogue dont la principale caractéristique technique résulte d''un **texte de loi** plutôt que d''un choix d''ingénieur. Son successeur, le **Kawasaki C-2**, conçu quand l''interprétation constitutionnelle avait évolué, vole cinq fois plus loin.',
    E'## Genesis\nIn 1966 Japan set out to replace the American C-46s inherited from the occupation. The programme went to Kawasaki, and it carried a constraint engineering knows nowhere else: **Article 9 of the Constitution**, which bars any offensive capability. A transport able to reach the Asian mainland would have been politically unacceptable. The range was therefore **capped on purpose**.\n\n## Design\nA high swept wing, two podded engines, a rear ramp, and gear stowed in side fairings: the layout is conventional and well executed. The hold takes a howitzer or forty-five paratroops. The compromise shows in the tanks, sized for thirteen hundred kilometres — enough to reach any point of the archipelago, and nothing beyond.\n\n## Operational career\nFor fifty years it handled Japan''s domestic logistics, relief after earthquakes and typhoons, and parachute training. Its limit became apparent as soon as Tokyo wanted to take part in UN operations: the C-1 simply could not get there. The EC-1 electronic warfare version, for its part, remains in service beyond the transports'' withdrawal.\n\n## Place in history\nOnly thirty-one built. It is probably the only aircraft in the catalogue whose principal technical characteristic follows from **a piece of law** rather than an engineer''s choice. Its successor, the **Kawasaki C-2**, designed once the constitutional interpretation had shifted, flies five times as far.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1966-01-01',
    '1970-11-12',
    '1974-12-01',
    806.0,
    1300.0,
    (SELECT id FROM manufacturer WHERE code = 'KHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.0,
  wingspan          = 30.6,
  height            = 9.99,
  wing_area         = 120.5,
  empty_weight      = 23320,
  mtow              = 45000,
  service_ceiling   = 11580,
  climb_rate        = 17.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 650,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Mitsubishi JT8D-M-9',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 64.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1970,
  production_end    = 1981,
  units_built       = 31,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **C-1** : version de transport tactique standard\n- **C-1 Kai / EC-1** : version de guerre électronique, nez allongé caractéristique\n- **Asuka** : banc d''essai à souffle sur les volets, décollage court, exemplaire unique\n- Rayon d''action **volontairement limité** à 1 300 km pour raisons constitutionnelles\n- Remplacé par le **Kawasaki C-2**, dont l''allonge dépasse 7 000 km',
  variants_en       = E'- **C-1** : the standard tactical transport version\n- **C-1 Kai / EC-1** : electronic warfare version with a distinctive lengthened nose\n- **Asuka** : upper-surface blown flap testbed for short take-off, one aircraft only\n- Range **deliberately limited** to 1,300 km for constitutional reasons\n- Replaced by the **Kawasaki C-2**, whose reach exceeds 7,000 km',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Kawasaki_C-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Kawasaki_C-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner from Lincoln, UK',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Kawasaki C-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Kawasaki C-1';
