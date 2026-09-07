-- Lockheed C-130 Hercules
--
-- Photo : Lockheed C-130 Hercules.jpg
--   licence Public domain — <div class="fn value"> U.S. Air Force photo by Tech. Sgt. Howard Blair</div>
--   https://commons.wikimedia.org/wiki/File%3ALockheed_C-130_Hercules.jpg

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
    'C-130 Hercules',
    'C-130 Hercules',
    'Lockheed C-130 Hercules',
    'Lockheed C-130 Hercules',
    'Avion de transport le plus durablement produit de l’histoire',
    'The longest continuously produced military aircraft in history',
    '/assets/airplanes/c130-hercules.jpg',
    E'## Genèse\nLa Corée révèle en 1951 que les transports américains sont inadaptés : dérivés d''avions de ligne, ils exigent des pistes en dur et se chargent par des portes latérales trop étroites. L''US Air Force demande alors un appareil conçu **depuis la page blanche** pour la guerre : rampe arrière, plancher à hauteur de camion, terrains sommaires. Lockheed confie le projet à une équipe qui juge l''avion si peu prestigieux que Kelly Johnson, père du F-104, refuse de signer la proposition.\n\n## Conception\nTout découle de la soute : aile haute pour la dégager, quatre turbopropulseurs pour la puissance aux basses vitesses, train principal logé dans des carénages latéraux, et une **rampe arrière** qui s''ouvre en vol. Le plancher est à la hauteur exacte d''un plateau de camion. La cellule est surdimensionnée : c''est ce qui lui permettra d''absorber, soixante-dix ans durant, des versions toujours plus lourdes sans redessiner la structure.\n\n## Carrière opérationnelle\nIl n''existe pratiquement pas de conflit depuis 1956 où le C-130 n''a pas volé. Il ravitaille Khe Sanh sous le feu, évacue Saïgon, largue à Kolwezi, se pose sur la banquise, sert d''avion-école d''observation en Antarctique, transporte des présidents et des réfugiés. **Soixante-dix pays** l''exploitent. Un C-130 s''est posé et a redécollé d''un porte-avions en 1963, exercice jamais renouvelé.\n\n## Place dans l''histoire\nPlus de deux mille sept cents exemplaires et une **production continue depuis 1954** : aucun autre avion militaire n''a jamais été construit aussi longtemps sans interruption. Sa version canonnière, l''**AC-130**, est devenue un appareil de combat à part entière. Sa vraie postérité est ailleurs : l''aile haute, la rampe arrière et le plancher-camion sont devenus la grammaire de tout avion de transport militaire, du **Transall** à l''**A400M**.',
    E'## Genesis\nKorea revealed in 1951 that American transports were unsuited to the job: derived from airliners, they needed hard runways and loaded through side doors that were too narrow. The US Air Force asked for an aircraft designed **from a blank sheet** for war: a rear ramp, a truck-bed floor height, rough strips. Lockheed handed the project to a team, and Kelly Johnson, father of the F-104, thought the aircraft so unglamorous that he refused to sign the proposal.\n\n## Design\nEverything follows from the hold: a high wing to clear it, four turboprops for power at low speed, main gear stowed in side fairings, and a **rear ramp** that opens in flight. The floor sits at the exact height of a truck bed. The airframe is oversized, which is what let it absorb ever heavier versions for seventy years without redrawing the structure.\n\n## Operational career\nThere is scarcely a conflict since 1956 in which the C-130 has not flown. It resupplied Khe Sanh under fire, evacuated Saigon, dropped at Kolwezi, lands on sea ice, flies observation in Antarctica, carries presidents and refugees. **Seventy countries** operate it. A C-130 landed on and took off from an aircraft carrier in 1963, an exercise never repeated.\n\n## Place in history\nMore than two thousand seven hundred built and **continuous production since 1954**: no other military aircraft has ever been built for so long without interruption. Its gunship version, the **AC-130**, became a combat aircraft in its own right. Its real legacy lies elsewhere: the high wing, the rear ramp and the truck-height floor became the grammar of every military transport, from the **Transall** to the **A400M**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-02-02',
    '1954-08-23',
    '1956-12-09',
    592.0,
    3800.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'C-130 Hercules'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 29.79,
  wingspan          = 40.41,
  height            = 11.66,
  wing_area         = 162.1,
  empty_weight      = 34400,
  mtow              = 70300,
  service_ceiling   = 8600,
  climb_rate        = 9.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3800,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Allison T56-A-15',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = NULL,
  units_built       = 2700,
  unit_cost_usd     = 30100000,
  unit_cost_year    = 2020,
  operators_count   = 70,
  variants          = E'- **C-130E / H** : versions de transport tactique les plus répandues\n- **C-130J Super Hercules** : refonte à turbopropulseurs à six pales et cockpit numérique\n- **AC-130** : canonnière lourde, présente au catalogue comme appareil distinct\n- **KC-130** : version ravitailleuse du Corps des Marines, nacelles sous voilure\n- **LC-130** : version à skis, seule capable de se poser sur la calotte antarctique',
  variants_en       = E'- **C-130E / H** : the most widespread tactical transport versions\n- **C-130J Super Hercules** : redesign with six-blade propellers and a digital cockpit\n- **AC-130** : heavy gunship, present in the catalogue as a distinct aircraft\n- **KC-130** : Marine Corps tanker version with underwing pods\n- **LC-130** : ski-equipped version, the only one able to land on the Antarctic ice cap',

  -- Strate 4 : qualitatif
  nickname          = 'Herky Bird',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_C-130_Hercules',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_C-130_Hercules',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = '<div class="fn value"> U.S. Air Force photo by Tech. Sgt. Howard Blair</div>',
  image_licence     = 'Public domain'
WHERE name = 'C-130 Hercules';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-130 Hercules';
