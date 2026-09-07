-- de Havilland Sea Vixen
--
-- Photo : Duxford Air Festival 2017 - sv3 (34932299646).jpg
--   licence CC BY 2.0 — wallycacsabre
--   https://commons.wikimedia.org/wiki/File%3ADuxford_Air_Festival_2017_-_sv3_%2834932299646%29.jpg

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
    'Sea Vixen',
    'Sea Vixen',
    'de Havilland Sea Vixen',
    'de Havilland Sea Vixen',
    'Chasseur embarqué britannique à double poutre et armement tout-missile',
    'British twin-boom carrier fighter with all-missile armament',
    '/assets/airplanes/sea-vixen.jpg',
    E'## Genèse\nIssu du DH.110, concurrent malheureux du Javelin pour la Royal Air Force, le Sea Vixen trouve sa vocation dans la **Fleet Air Arm**. C''est le premier chasseur britannique conçu sans canon, armé uniquement de missiles et de roquettes — un choix radical pour l''époque.\n\n## Conception\nArchitecture à double poutre héritée du Vampire, et cockpit **asymétrique** : le pilote est décalé à gauche sous une verrière classique, tandis que l''opérateur radar est enterré dans le fuselage à droite, sans vue extérieure, derrière une trappe qu''on surnommait *the coal hole*. Une disposition critiquée mais imposée par l''encombrement du radar.\n\n## Carrière opérationnelle\nIl assure la couverture aérienne des porte-avions britanniques pendant une décennie : Tanganyika, Aden, la confrontation indonésienne au-dessus de Bornéo, et la surveillance de la Rhodésie. Sa carrière est marquée par un taux d''attrition élevé, courant chez les appareils embarqués de cette génération.\n\n## Place dans l''histoire\nRetiré en 1972, remplacé par le Phantom FG.1 puis, après le retrait des grands porte-avions britanniques, par le **Sea Harrier**. Le Sea Vixen ferme l''ère des chasseurs embarqués lourds de la Royal Navy — la marine britannique n''en remettra en ligne qu''avec le F-35B, quarante-cinq ans plus tard.',
    E'## Genesis\nDerived from the DH.110, the unsuccessful rival of the Javelin for the Royal Air Force, the Sea Vixen found its calling with the **Fleet Air Arm**. It was the first British fighter designed without a gun, armed only with missiles and rockets — a radical choice for the time.\n\n## Design\nA twin-boom layout inherited from the Vampire, and an **asymmetric** cockpit: the pilot sits offset to the left under a conventional canopy while the radar operator is buried in the fuselage to the right, with no outside view, behind a hatch nicknamed *the coal hole*. A much-criticised arrangement, but one imposed by the size of the radar.\n\n## Operational career\nIt provided air cover for British carriers for a decade: Tanganyika, Aden, the Indonesian confrontation over Borneo, and the surveillance of Rhodesia. Its career was marked by a high attrition rate, common among carrier aircraft of that generation.\n\n## Place in history\nRetired in 1972, replaced by the Phantom FG.1 and then, after the big British carriers were withdrawn, by the **Sea Harrier**. The Sea Vixen closed the era of heavy Royal Navy carrier fighters — the British fleet would not field another until the F-35B, forty-five years later.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1946-01-01',
    '1951-09-26',
    '1959-07-02',
    1110.0,
    1270.0,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon')),
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM armement WHERE name = 'Firestreak')),
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM armement WHERE name = 'Red Top')),
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Sea Vixen'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.94,
  wingspan          = 15.54,
  height            = 3.28,
  wing_area         = 60.2,
  empty_weight      = 12680,
  mtow              = 18860,
  service_ceiling   = 14600,
  climb_rate        = 46,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 950,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon 208',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 50.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1966,
  units_built       = 145,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **FAW.1** : première version embarquée\n- **FAW.2** : poutres allongées, carburant supplémentaire, missiles Red Top\n- **D.3** : cellules converties en drones-cibles téléguidés',
  variants_en       = E'- **FAW.1** : first carrier version\n- **FAW.2** : extended booms, extra fuel, Red Top missiles\n- **D.3** : airframes converted into radio-controlled target drones',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Sea_Vixen',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Sea_Vixen',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'wallycacsabre',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Sea Vixen';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Sea Vixen';
