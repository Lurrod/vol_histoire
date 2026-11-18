-- McDonnell Douglas YC-15
--
-- Photo : McDonnell Douglas YC-15 approaches Boeing NKC-135A tanker over Edwards Air Force Base, California (USA), on 14 April 1978 (176247046).jpg
--   licence Public domain — U.S. Air Force photo 342-C-KE-66621
--   https://commons.wikimedia.org/wiki/File:McDonnell_Douglas_YC-15_approaches_Boeing_NKC-135A_tanker_over_Edwards_Air_Force_Base,_California_(USA),_on_14_April_1978_(176247046).jpg

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
    'McDonnell Douglas YC-15',
    'McDonnell Douglas YC-15',
    'McDonnell Douglas YC-15',
    'McDonnell Douglas YC-15',
    'Quadriréacteur de transport à décollage court, perdant du programme AMST mais ancêtre direct du C-17',
    'Four-jet STOL transport that lost out with the AMST programme yet led directly to the C-17',
    '/assets/airplanes/yc15.jpg',
    E'## Genèse\nEn 1968, l''US Air Force engage une série d''études de prototypes d''où naîtront à la fois le programme de chasseur léger et l''**AMST**, destiné à remplacer le **C-130 Hercules** comme transport tactique à décollage court. L''appel d''offres de janvier 1972 demande d''opérer depuis 610 m de terrain sommairement préparé avec 12 tonnes de charge, dans un rayon de 740 km. Bell, Boeing, Fairchild, McDonnell Douglas et l''équipe Lockheed–North American Rockwell répondent ; le 10 novembre 1972, Boeing et McDonnell Douglas sont retenus pour deux prototypes chacun. Celui de McDonnell Douglas devient le **YC-15**.\n\n## Conception\nLe YC-15 associe une **aile supercritique**, issue des recherches de **Richard Whitcomb** à la NASA, et des **volets soufflés** par l''extérieur : des volets à double fente dévient vers le bas une partie du jet de quatre réacteurs **Pratt & Whitney JT8D-17**, le reste les traversant puis suivant leur courbure par effet Coandă. C''est le premier avion à réaction à employer ce procédé, rendu possible par les turbofans, au jet plus large et plus froid. Le nez et le poste de pilotage dérivent du DC-10, le train avant vient du DC-8, et bien d''autres pièces de l''A-10, du C-141, du C-5 ou du F-15. Le YC-15 est aussi le premier avion à offrir à ses pilotes un **affichage tête haute**, conçu pour les atterrissages courts.\n\n## Essais\nLe YC-15 vole le 26 août 1975, le second prototype en décembre ; leurs envergures diffèrent, 33,6 m et 40,4 m. En novembre 1976, ils rejoignent Edwards pour les essais comparatifs face au **YC-14**, avec chargements de chars et d''artillerie sur des pistes en terre. À 68 tonnes, il approche à 161 km/h sur une pente de 6° et vise un point de toucher à 90 m du seuil. Mais ses inverseurs de poussée, trop lents, l''empêchent de s''arrêter à coup sûr en 610 m par temps chaud et en altitude.\n\n## Place dans l''histoire\nLa priorité donnée au transport stratégique met fin à l''AMST en décembre 1979 ; le programme C-X retient alors un YC-15 agrandi et modernisé, qui devient le **C-17 Globemaster III**. L''exemplaire 72-1875, remis en vol par McDonnell Douglas le 11 avril 1997, sert au programme C-17 jusqu''à une grave panne moteur le 11 juillet 1998 ; il est exposé depuis 2008 au musée des essais en vol d''Edwards. L''autre est détruit sur place en 2012. Perdant d''une compétition sans vainqueur, le YC-15 n''en est pas moins l''ancêtre direct du C-17.',
    E'## Genesis\nIn 1968 the US Air Force began a series of prototype studies that would lead both to the Light Weight Fighter and to **AMST**, meant to replace the **C-130 Hercules** as its STOL tactical transport. The January 1972 request for proposals called for operations from a 610 m semi-prepared strip with a 12-tonne payload over a 740 km mission radius. Bell, Boeing, Fairchild, McDonnell Douglas and a Lockheed–North American Rockwell team responded; on 10 November 1972 Boeing and McDonnell Douglas were each selected to build two prototypes. McDonnell Douglas''s became the **YC-15**.\n\n## Design\nThe YC-15 combined a **supercritical wing**, the fruit of **Richard Whitcomb**''s NASA research, with **externally blown flaps**: double-slotted flaps deflected part of the exhaust of four **Pratt & Whitney JT8D-17** engines downwards, while the rest passed through and followed their curve through the Coandă effect. It was the first jet aircraft to use the system, made practical by turbofans and their larger, cooler exhaust. The nose and cockpit derived from the DC-10, the nose gear came from the DC-8, and many other parts from the A-10, C-141, C-5 and F-15. The YC-15 was also the first aircraft to offer its pilots a **head-up display**, designed for short-field landings.\n\n## Testing\nThe YC-15 flew on 26 August 1975, the second prototype in December; their wingspans differed, 33.6 m and 40.4 m. In November 1976 both moved to Edwards for head-to-head testing against the **YC-14**, lifting tanks and artillery from dirt strips. At 68 tonnes it flew short approaches at 161 km/h on a 6° glide slope, aiming to touch down 90 m from the threshold. But its slow-acting thrust reversers meant it could not consistently stop within 610 m in hot-and-high conditions.\n\n## Place in history\nThe priority given to strategic airlift ended AMST in December 1979; the C-X programme then selected an enlarged and upgraded YC-15, which became the **C-17 Globemaster III**. Airframe 72-1875, returned to flight by McDonnell Douglas on 11 April 1997, supported the C-17 programme until a major engine failure on 11 July 1998; since 2008 it has been on display at the Edwards flight test museum. The other was destroyed in place in 2012. The loser of a competition with no winner, the YC-15 is nonetheless the direct ancestor of the C-17.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1968-01-01',
    '1975-08-26',
    NULL,
    950,
    4800,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas YC-15'), (SELECT id FROM tech WHERE name = 'Volets soufflés par les réacteurs')),
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas YC-15'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas YC-15'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'McDonnell Douglas YC-15'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 37.9,
  wingspan          = 33.6,
  height            = 13.2,
  wing_area         = 160,
  empty_weight      = 47600,
  mtow              = 98285,
  service_ceiling   = 9100,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney JT8D-17',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 71.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **YC-15 72-1876** : prototype à aile de 33,6 m d''envergure ; un JT8D-209 « refanné » essayé dans sa nacelle n° 1 ; détruit sur place en 2012\n- **YC-15 72-1875** : prototype à aile de 40,4 m, puis aile à corde et envergure accrues ; un CFM56 essayé dans sa nacelle n° 1 ; exposé à Edwards\n- **YC-15 remis en vol (1997-1998)** : le 72-1875, réactivé par McDonnell Douglas comme démonstrateur au profit du programme C-17',
  variants_en       = E'- **YC-15 72-1876**: prototype with a 33.6 m wingspan; a refanned JT8D-209 tested in its No. 1 nacelle; destroyed in place in 2012\n- **YC-15 72-1875**: prototype with a 40.4 m wing, later a wing of increased chord and span; a CFM56 tested in its No. 1 nacelle; displayed at Edwards\n- **Re-flown YC-15 (1997-1998)**: 72-1875, reactivated by McDonnell Douglas as a demonstrator supporting the C-17 programme',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_YC-15',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_YC-15',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'McDonnell Douglas YC-15';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'McDonnell Douglas YC-15';
