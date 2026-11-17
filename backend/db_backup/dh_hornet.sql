-- de Havilland DH.103 Hornet
--
-- Photo : 15 Dehavilland D.H. 103 Hornet RR Merlin 130-131, PX225 (15837361312).jpg
--   licence Public domain — San Diego Air & Space Museum Archives
--   https://commons.wikimedia.org/wiki/File:15_Dehavilland_D.H._103_Hornet_RR_Merlin_130-131,_PX225_(15837361312).jpg

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
    'de Havilland Hornet',
    'de Havilland Hornet',
    'de Havilland DH.103 Hornet',
    'de Havilland DH.103 Hornet',
    'Petit frère monoplace du Mosquito, chasseur à pistons de la RAF en Malaisie et Sea Hornet embarqué',
    'The Mosquito''s single-seat little brother, an RAF piston fighter in Malaya and the carrier-borne Sea Hornet',
    '/assets/airplanes/dh-hornet.jpg',
    E'## Genèse\nÀ l''automne 1941, **de Havilland**, dont le Mosquito est en pleine production, dispose de capacités d''étude libres. Après un projet de bombardier rapide abandonné, l''équipe de **R. E. Bishop** se tourne en novembre 1942 vers un chasseur à long rayon d''action, le D.H.103 : une sorte de petit Mosquito monoplace, taillé pour affronter les chasseurs japonais au-dessus du Pacifique. Le ministère en fait un programme officiel en juin 1943 avec la spécification F.12/43, et le projet prend le nom de **Hornet**. Dès l''origine, son adaptation aux porte-avions est prévue.\n\n## Conception\nLe prototype vole le 28 juillet 1944, piloté par **Geoffrey de Havilland Jr.**, treize mois seulement après le feu vert officiel, et atteint 780 km/h en palier. Le fuselage reprend la construction du Mosquito, du balsa entre deux contreplaqués, mais l''aile mince à profil laminaire associe structure en bois et revêtement inférieur en alliage, collés à la nouvelle colle **Redux**. Deux **Rolls-Royce Merlin** 130 et 131 aux hélices tournant en sens inverse annulent l''effet de couple et rendent l''avion docile. Pour la **Sea Hornet**, ailes repliables, crosse d''appontage et jambes oléopneumatiques sont ajoutées ; la version NF.21 reçoit un radar et un second poste pour l''opérateur.\n\n## Carrière opérationnelle\nArrivé trop tard pour la guerre, le Hornet entre en service en 1946 au 64e escadron de la RAF. En 1951, plusieurs escadrons rejoignent l''Extrême-Orient pour l''**insurrection malaise** : armés de roquettes ou de bombes de 454 kg, ils peuvent tourner deux heures au-dessus d''une cible difficile à identifier, souvent aux côtés des bombardiers Avro Lincoln. Le 45e escadron, à Singapour, totalise 4 500 sorties en cinq ans. Côté marine, la Sea Hornet équipe le 801 Naval Air Squadron à partir du 1er juin 1947, puis le 809e, seule unité de première ligne sur NF.21, jusqu''à son passage au **Sea Venom** en 1954.\n\n## Place dans l''histoire\nLa dernière sortie opérationnelle du Hornet a lieu le 21 mai 1955 et tous sont retirés vers le milieu de 1956 ; aucun exemplaire complet ne subsiste. Construit à 383 exemplaires, il offrait selon l''historien P. J. Birtles des performances supérieures à celles de tout autre avion à hélice. Le pilote d''essai **Eric Brown**, qui mena ses essais d''appontage, ne plaçait aucun avion au-dessus de la Sea Hornet pour l''harmonie des commandes et la confiance qu''elle inspirait. Avec elle s''achève l''ère des chasseurs de nuit à pistons de la Fleet Air Arm.',
    E'## Genesis\nIn the autumn of 1941 **de Havilland**, whose Mosquito was in full production, had spare design capacity. After an abandoned fast-bomber project, **R. E. Bishop**''s team turned in November 1942 to a long-range fighter, the D.H.103: a kind of small single-seat Mosquito, built to take on Japanese fighters over the Pacific. The Ministry made it an official programme in June 1943 with Specification F.12/43, and the project was named **Hornet**. Adaptation for carrier use was planned from the outset.\n\n## Design\nThe prototype flew on 28 July 1944, piloted by **Geoffrey de Havilland Jr.**, only thirteen months after official sanction, and reached 780 km/h in level flight. The fuselage repeated the Mosquito''s construction, balsa between two plywood skins, but the thin laminar-flow wing combined a wooden structure with alloy lower skins bonded with the new **Redux** adhesive. Two **Rolls-Royce Merlin** 130 and 131 engines with propellers turning in opposite directions cancelled torque effects and made the aircraft docile. The **Sea Hornet** added folding wings, an arrester hook and hydraulic oleo legs; the NF.21 version received radar and a second cockpit for its operator.\n\n## Operational career\nToo late for the war, the Hornet entered service in 1946 with No. 64 Squadron RAF. In 1951 several squadrons moved to the Far East for the **Malayan Emergency**: armed with rockets or 454 kg bombs, they could loiter for two hours over targets that were hard to identify, often alongside Avro Lincoln bombers. No. 45 Squadron, in Singapore, flew 4,500 sorties in five years. At sea, the Sea Hornet equipped 801 Naval Air Squadron from 1 June 1947, then 809 Squadron, the only front-line NF.21 unit, until it converted to the **Sea Venom** in 1954.\n\n## Place in history\nThe last operational Hornet sortie was flown on 21 May 1955 and all had been withdrawn by mid-1956; no complete example survives. Built in 383 examples, it had, according to historian P. J. Birtles, a higher performance than any other propeller-driven aircraft. Test pilot **Eric Brown**, who led its deck-landing trials, ranked the Sea Hornet second to none for harmony of control and the confidence it inspired. With it ended the era of the Fleet Air Arm''s piston-engined night fighters.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1942-11-01',
    '1944-07-28',
    '1946-01-01',
    764,
    2380,
    (SELECT id FROM manufacturer WHERE code = 'DH'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM tech WHERE name = 'Système navalisé'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM armement WHERE name = '1000 lb GP'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'de Havilland Hornet'), (SELECT id FROM wars WHERE name = 'Insurrection malaise'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.82,
  wingspan          = 13.72,
  height            = 4.32,
  wing_area         = 33.5,
  empty_weight      = 5122,
  mtow              = 8278,
  service_ceiling   = 12600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Merlin 130 / 131 (2 070 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1950,
  units_built       = 383,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **Hornet F.1** : première version de chasse de la RAF, 60 exemplaires\n- **Hornet PR.2** : reconnaissance photographique à long rayon d''action, cinq exemplaires jamais mis en service\n- **Hornet F.3** : chasseur à aile renforcée pour roquettes et bombes, carburant interne accru, 132 exemplaires\n- **Hornet FR.4** : chasseur-reconnaissance dérivé du F.3, 12 exemplaires engagés en Malaisie et à Hong Kong\n- **Sea Hornet F.20** : version embarquée à ailes repliables et crosse d''appontage, 79 exemplaires\n- **Sea Hornet NF.21** : chasseur de nuit embarqué biplace à radar ASH, 72 exemplaires, et PR.22 de reconnaissance, 23 exemplaires',
  variants_en       = E'- **Hornet F.1**: first RAF fighter version, 60 built\n- **Hornet PR.2**: long-range photo-reconnaissance version, five built, never in service\n- **Hornet F.3**: fighter with a wing stressed for rockets and bombs and more internal fuel, 132 built\n- **Hornet FR.4**: fighter-reconnaissance version derived from the F.3, 12 aircraft used in Malaya and Hong Kong\n- **Sea Hornet F.20**: carrier version with folding wings and arrester hook, 79 built\n- **Sea Hornet NF.21**: two-seat carrier night fighter with ASH radar, 72 built, plus the PR.22 reconnaissance version, 23 built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/De_Havilland_Hornet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/De_Havilland_Hornet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'San Diego Air & Space Museum Archives',
  image_licence     = 'Public domain'
WHERE name = 'de Havilland Hornet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'de Havilland Hornet';
