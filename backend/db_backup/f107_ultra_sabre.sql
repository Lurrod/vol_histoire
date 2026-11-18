-- North American F-107A
--
-- Photo : F-107A in flight.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File:F-107A_in_flight.jpg

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
    'North American F-107',
    'North American F-107',
    'North American F-107A',
    'North American F-107A',
    'Dérivé du F-100 à l''entrée d''air dorsale, battu par le F-105 pour le contrat de chasseur-bombardier de l''US Air Force',
    'F-100 derivative with a dorsal air intake, beaten by the F-105 for the US Air Force fighter-bomber contract',
    '/assets/airplanes/f107.jpg',
    E'## Genèse\nEn juin 1953, **North American Aviation** lance sur ses fonds propres l''étude de versions avancées du **F-100 Super Sabre** : un intercepteur (NAA 211) et un chasseur-bombardier (NAA 212, dit F-100B). C''est le second qui retient l''attention, avec une soute semi-encastrée sous le fuselage et des points d''emport sous les ailes. En août 1954, l''US Air Force signe un contrat pour trois prototypes et six cellules de présérie. Les modifications sont si profondes que l''avion devient **F-107A** avant même son premier vol ; officieusement, on l''appelle « Super Super Sabre » ou « Ultra Sabre ».\n\n## Conception\nSon trait le plus frappant est l''**entrée d''air dorsale**, placée juste derrière le cockpit, car l''Air Force exige l''emport d''une arme nucléaire semi-encastrée sous le ventre, ce qui interdit la prise d''air sous le nez d''abord envisagée. Cette entrée à section variable, le **VAID**, dose automatiquement l''air fourni au réacteur **Pratt & Whitney J75** ; c''est une forme précoce de rampe à géométrie variable, que North American reprendra sur l''**A-5 Vigilante** et le **XB-70 Valkyrie**. Elle masque presque toute la vue vers l''arrière, défaut jugé acceptable quand on croit le combat aérien réduit à des tirs de missiles hors de vue. La dérive est monobloc, le roulis supersonique est obtenu par des spoilers, et le siège éjectable traverse directement la verrière.\n\n## Essais\nLe premier F-107A décolle le 10 septembre 1956 aux mains du chef pilote d''essai **Bob Baker** et atteint Mach 1,03 dès ce vol ; Mach 2 est atteint le 3 novembre. Le deuxième prototype, en l''air le 28 novembre, sert aux essais d''armement, bombes classiques et atomiques comprises ; le troisième suit le 10 décembre. Le Tactical Air Command organise alors une compétition en vol contre le **Republic F-105**, conçu pour la même mission et autour du même moteur. La décision est serrée, mais le Thunderchief l''emporte et la commande de présérie du F-107 est annulée.\n\n## Place dans l''histoire\nFin 1957, le premier et le troisième prototype sont prêtés au **NACA** pour la recherche en vol à grande vitesse ; le deuxième rejoint dès le 25 novembre 1957 le musée de l''US Air Force à Wright-Patterson. En septembre 1959, **Scott Crossfield** endommage l''un des avions du NACA lors d''un décollage interrompu : jamais réparé, il finit sur un terrain d''entraînement des pompiers. Le F-107 n''a jamais servi en escadrille, mais son entrée d''air réglable a nourri les grands projets supersoniques de North American qui l''ont suivi. Deux exemplaires subsistent, à Dayton et au Pima Air & Space Museum.',
    E'## Genesis\nIn June 1953 **North American Aviation** began a company-funded study of advanced versions of the **F-100 Super Sabre**: an interceptor (NAA 211) and a fighter-bomber (NAA 212, the F-100B). The second drew the attention, with a semi-recessed weapons bay under the fuselage and underwing hardpoints. In August 1954 the US Air Force signed a contract for three prototypes and six pre-production airframes. The changes ran so deep that the aircraft became the **F-107A** before its first flight; informally it was called the ''Super Super Sabre'' or ''Ultra Sabre''.\n\n## Design\nIts most striking feature is the **dorsal air intake**, set just behind the cockpit. It was no whim: the Air Force required a nuclear weapon carried semi-recessed under the belly, which ruled out the chin intake first considered. This variable-area inlet, the **VAID**, automatically metered the air fed to the **Pratt & Whitney J75**; it was an early form of variable-geometry intake ramp, which North American reused on the **A-5 Vigilante** and the **XB-70 Valkyrie**. It blocked almost all rearward view, a flaw deemed acceptable at a time when air combat was expected to be an exchange of missiles beyond visual range. The fin was all-moving, roll at supersonic speed came from spoilers, and the ejection seat was designed to blast straight through the canopy.\n\n## Testing\nThe first F-107A flew on 10 September 1956 with chief test pilot **Bob Baker** at the controls, reaching Mach 1.03 on that flight; Mach 2 followed on 3 November. The second prototype, airborne on 28 November, was used for weapons testing, conventional and atomic bombs included; the third followed on 10 December. Tactical Air Command then held a fly-off against the **Republic F-105**, designed for the same mission around the same engine. The decision was close, but the Thunderchief won and the F-107 pre-production order was cancelled.\n\n## Place in history\nIn late 1957 the first and third prototypes were leased to **NACA** for high-speed flight research; the second was flown on 25 November 1957 to the US Air Force museum at Wright-Patterson. In September 1959 **Scott Crossfield** damaged one of the NACA aircraft in an aborted take-off: never repaired, it ended up on a fire-fighting training ground. The F-107 never served with a squadron, but its adjustable intake fed the great supersonic projects North American built after it. Two survive, at Dayton and at the Pima Air & Space Museum.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1953-06-01',
    '1956-09-10',
    NULL,
    2084,
    3885,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'North American F-107'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'North American F-107'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'North American F-107'), (SELECT id FROM armement WHERE name = 'M39'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'North American F-107'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'North American F-107'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 18.85,
  wingspan          = 11.15,
  height            = 5.89,
  wing_area         = 35,
  empty_weight      = 10295,
  mtow              = 18841,
  service_ceiling   = 16220,
  climb_rate        = 203,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney YJ75-P-9',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = NULL,
  thrust_wet        = 109,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **NA-212 / F-100B** : désignation constructeur et première désignation militaire du projet, abandonnée avant le premier vol\n- **F-107A** : neuf cellules commandées (trois prototypes et six de présérie), trois construites\n- **F-107 biplace** : version à deux places sous une verrière unique, fuselage avant allongé, proposée par North American, jamais construite\n- **FJ-5** : version navalisée à réacteur General Electric J79 proposée à l''US Navy en juillet 1955, non retenue',
  variants_en       = E'- **NA-212 / F-100B**: company designation and first military designation of the project, dropped before the first flight\n- **F-107A**: nine airframes ordered (three prototypes and six pre-production), three built\n- **Two-seat F-107**: version with both crew under a single canopy, proposed by North American, never built\n- **FJ-5**: navalised version powered by a General Electric J79, proposed to the US Navy in July 1955, not taken up',

  -- Strate 4 : qualitatif
  nickname          = 'Ultra Sabre',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_YF-107_Ultra_Sabre',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_F-107',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'North American F-107';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'North American F-107';
