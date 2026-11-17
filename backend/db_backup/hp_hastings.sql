-- Handley Page HP.67 Hastings
--
-- Photo : -1956-08-15 Handley Page Hastings (TG582), Christmas Island.JPG
--   licence Public domain — Stavros1
--   https://commons.wikimedia.org/wiki/File:-1956-08-15_Handley_Page_Hastings_(TG582),_Christmas_Island.JPG

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
    'Handley Page Hastings',
    'Handley Page Hastings',
    'Handley Page HP.67 Hastings',
    'Handley Page HP.67 Hastings',
    'Le quadrimoteur jeté dans le pont aérien de Berlin avant même d''être tout à fait au point',
    'The four-engined transport rushed into the Berlin Airlift before it was fully sorted',
    '/assets/airplanes/hp-hastings.jpg',
    E'## Genèse\nPendant la Seconde Guerre mondiale, le ministère britannique de l''Air publie la spécification C.3/44 : un transport quadrimoteur à long rayon d''action pour succéder à l''**Avro York**, dérivé du bombardier Lancaster. Handley Page répond avec le H.P.67, qui reprend l''aile dessinée pour le HP.66, un développement abandonné du Halifax. La priorité va d''abord à la version civile, l''**Hermes**, mais son prototype s''écrase lors de son premier vol, le 2 décembre 1945 ; l''entreprise se concentre alors sur le modèle militaire. Le premier Hastings vole à Wittering le 7 mai 1946.\n\n## Conception\nMonoplan entièrement métallique à aile basse, le Hastings associe un fuselage circulaire pressurisable à quatre moteurs en étoile **Bristol Hercules** à chemises louvoyantes, montés en blocs interchangeables. Sa soute d''environ 85 m³ accueille 50 soldats équipés, 30 parachutistes ou 32 civières, et des points d''ancrage sous le fuselage permettent d''y suspendre une plateforme pour les charges trop grosses, comme une Jeep. Les essais révèlent une instabilité latérale et un décrochage sans préavis : on monte en urgence un empennage horizontal en dièdre de 15° et un avertisseur, avant que le C2 n''adopte un plan fixe plus grand, placé plus bas.\n\n## Carrière opérationnelle\nLe Hastings entre en service en septembre 1948, à marche forcée, pour le **pont aérien de Berlin** : le No. 47 Squadron effectue sa première rotation le 11 novembre 1948, et c''est un Hastings qui boucle la dernière sortie, le 6 octobre 1949. Les 32 appareils engagés livrent 49 900 t, surtout du charbon, au prix de deux avions perdus. Transport standard à long rayon d''action du Transport Command, il largue des parachutistes sur l''aérodrome d''El Gamil pendant la **crise de Suez** en 1956, puis ravitaille par air les troupes opposées aux forces indonésiennes pendant la **confrontation indonésio-malaisienne**. Quatre exemplaires servent la Royal New Zealand Air Force, dont les équipages, lassés des pannes de chemises, le disaient « meilleur trimoteur du monde ».\n\n## Place dans l''histoire\nPlus grand avion de transport jamais conçu pour la RAF à son entrée en service, le Hastings y est construit à 147 exemplaires, plus quatre pour la Nouvelle-Zélande. Remplacé au Transport Command en 1968 par le **C-130 Hercules** et l''Argosy, il vole encore en version météo jusqu''en 1964, puis en version T5 d''entraînement radar des équipages de bombardiers V jusqu''au 30 juin 1977, après une ultime mission de reconnaissance pendant la guerre de la morue. Il aura servi la RAF pendant près de trente ans.',
    E'## Genesis\nDuring the Second World War the British Air Ministry issued Specification C.3/44: a long-range four-engined transport to succeed the **Avro York**, a derivative of the Lancaster bomber. Handley Page answered with the H.P.67, which used the wing designed for the HP.66, an abandoned development of the Halifax. Priority first went to the civil version, the **Hermes**, but its prototype crashed on its first flight on 2 December 1945, and the company concentrated on the military model. The first Hastings flew from Wittering on 7 May 1946.\n\n## Design\nAn all-metal low-wing monoplane, the Hastings combined a circular fuselage suitable for pressurisation with four **Bristol Hercules** sleeve-valve radial engines in interchangeable power-eggs. Its hold of some 85 m³ took 50 equipped troops, 30 paratroopers or 32 stretchers, and strong points under the fuselage allowed a carrier platform to be slung for loads too big for the cabin, such as a Jeep. Flight tests revealed lateral instability and poor stall warning: a tailplane with 15° of dihedral and an artificial stall warning were fitted as an urgent fix, before the C2 adopted a larger tailplane mounted lower on the fuselage.\n\n## Operational career\nThe Hastings was rushed into service in September 1948 for the **Berlin Airlift**: No. 47 Squadron flew its first sortie on 11 November 1948, and a Hastings flew the airlift''s final sortie on 6 October 1949. The 32 aircraft involved delivered 49,900 tonnes, mostly coal, for the loss of two aircraft. The standard long-range transport of Transport Command, it dropped paratroopers on El Gamil airfield during the **Suez Crisis** in 1956, then dropped supplies to troops opposing Indonesian forces during the **Indonesia-Malaysia confrontation**. Four served with the Royal New Zealand Air Force, whose crews, weary of sleeve-valve trouble, joked that it was the best three-engined aircraft in the world.\n\n## Place in history\nThe largest transport ever designed for the RAF when it entered service, the Hastings was built in 147 examples for the service, plus four for New Zealand. Replaced in Transport Command in 1968 by the **C-130 Hercules** and the Argosy, it flew on as a weather reconnaissance aircraft until 1964 and as the T5 radar trainer for V-bomber crews until 30 June 1977, after a final reconnaissance task during the Cod War. It served the RAF for almost thirty years.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-01-01',
    '1946-05-07',
    '1948-09-01',
    560,
    6840,
    (SELECT id FROM manufacturer WHERE code = 'HP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM wars WHERE name = 'Crise de Suez')),
((SELECT id FROM airplanes WHERE name = 'Handley Page Hastings'), (SELECT id FROM wars WHERE name = 'Confrontation indonésio-malaisienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 24.89,
  wingspan          = 34.44,
  height            = 6.86,
  wing_area         = 130.8,
  empty_weight      = 21987,
  mtow              = 36287,
  service_ceiling   = 8100,
  climb_rate        = 5.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Hercules 106 (1 675 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1947,
  production_end    = 1952,
  units_built       = 151,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **Hastings C1** : première version de série à moteurs Hercules 101, plus tard reconstruite au standard C1A ou convertie en T5\n- **Hastings Met.1** : version de reconnaissance météorologique du Coastal Command, en service jusqu''en 1964\n- **Hastings C2** : empennage agrandi et abaissé, carburant accru, moteurs Hercules 106, 43 exemplaires\n- **Hastings C3** : version néo-zélandaise à moteurs Hercules 737, quatre exemplaires\n- **Hastings C4** : transport de personnalités à autonomie accrue, quatre exemplaires\n- **Hastings T5** : huit C1 dotés d''un radôme ventral pour former les équipages des bombardiers V',
  variants_en       = E'- **Hastings C1**: first production version with Hercules 101 engines, later rebuilt to C1A standard or converted to T5\n- **Hastings Met.1**: weather reconnaissance version for Coastal Command, in service until 1964\n- **Hastings C2**: larger, lower-set tailplane, more fuel, Hercules 106 engines, 43 built\n- **Hastings C3**: New Zealand version with Hercules 737 engines, four built\n- **Hastings C4**: longer-range VIP transport, four built\n- **Hastings T5**: eight C1s fitted with a ventral radome to train V-bomber crews',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Handley_Page_Hastings',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Handley_Page_Hastings',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Stavros1',
  image_licence     = 'Public domain'
WHERE name = 'Handley Page Hastings';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Handley Page Hastings';
