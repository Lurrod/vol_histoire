-- Short SC.5 Belfast
--
-- Photo : Royal Air Force Short Belfast C.1 of No. 53 Squadron, RAF, at Cape Canaveral Air Force Station, Florida (USA), on 11 December 1973 (176247068).jpg
--   licence Public domain — U.S. Air Force photo 342-C-KE-68217
--   https://commons.wikimedia.org/wiki/File:Royal_Air_Force_Short_Belfast_C.1_of_No._53_Squadron,_RAF,_at_Cape_Canaveral_Air_Force_Station,_Florida_(USA),_on_11_December_1973_(176247068).jpg

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
    'Short Belfast',
    'Short Belfast',
    'Short SC.5 Belfast',
    'Short SC.5 Belfast',
    'Le plus gros avion de l''armée britannique, premier conçu pour l''atterrissage automatique, construit à dix exemplaires',
    'Britain''s largest military aircraft, the first designed for automatic landing, and built in just ten examples',
    '/assets/airplanes/short-belfast.jpg',
    E'## Genèse\nAu milieu des années 1950, Short Brothers étudie un cargo militaire lourd ; son président, **Sir Matthew Slattery**, impose de reprendre le plus possible d''éléments du **Bristol Britannia** pour réduire coûts et délais. En mars 1957, Short présente le PD.18 Britannic. La même année, la RAF formalise son besoin d''un gros porteur (Operational Requirement ASR.371) capable d''emporter artillerie, plus de 200 soldats, hélicoptères et missiles sur de longues distances. Le ministère retient le projet de Short en janvier 1959 et commande dix **Belfast C.1** le 21 décembre 1960. Le prototype vole le 5 janvier 1964 à Sydenham.\n\n## Conception\nLe Belfast garde du Britannia l''aile et l''empennage, avec un nouveau caisson central qui allonge l''envergure de 5 m, mais adopte quatre turbopropulseurs **Rolls-Royce Tyne** de 5 730 ch. Son fuselage pressurisé de 4,9 m de diamètre abrite une soute de 26 m, accessible par une rampe arrière : un char Chieftain, deux hélicoptères Wessex, trois automitrailleuses Saladin ou deux missiles **Polaris** y trouvent place. Surtout, il est le premier avion au monde conçu dès l''origine pour l''**atterrissage automatique** : le système Smiths, triplé en tangage et en roulis, réussit son premier atterrissage automatique après 120 heures d''essais seulement.\n\n## Carrière opérationnelle\nLe Belfast entre en service le 20 janvier 1966 au No. 53 Squadron, à Brize Norton, et, chose rare, chaque appareil reçoit un nom. Un excès de traînée bridait les premiers exemplaires : un nouveau carénage arrière fait gagner 64 km/h en croisière. Mais la création du Strike Command et la réorganisation du transport aérien condamnent la flotte, retirée à la fin de 1976. Revendus à HeavyLift, plusieurs appareils reprennent du service civil, et la RAF les affrète pendant la **guerre des Malouines**, puis pendant la **guerre du Golfe** pour transporter véhicules et hélicoptères trop gros pour ses Hercules.\n\n## Place dans l''histoire\nPlus gros avion jamais exploité par l''armée britannique à son entrée en service, le Belfast n''a été construit qu''à dix exemplaires, quand son seuil de rentabilité était fixé à trente. Ses versions civiles et la variante à réacteurs étudiée avec Lockheed, qui aurait reçu l''aile du **C-141 Starlifter**, sont restées sur le papier. Pionnier de l''atterrissage automatique, il a surtout souffert d''une commande trop courte pour durer. Le dernier exemplaire, *Enceladus*, est exposé au musée de la RAF à Cosford.',
    E'## Genesis\nIn the mid-1950s Short Brothers studied a heavy military freighter; its chairman, **Sir Matthew Slattery**, insisted on reusing as much of the **Bristol Britannia** as possible to cut cost and time. In March 1957 Shorts submitted the PD.18 Britannic. That year the RAF formalised its need for a heavy freighter (Operational Requirement ASR.371) able to carry artillery, more than 200 troops, helicopters and missiles over long ranges. The Ministry selected the Shorts design in January 1959 and ordered ten **Belfast C.1s** on 21 December 1960. The prototype flew from Sydenham on 5 January 1964.\n\n## Design\nThe Belfast kept the Britannia''s wing and tail, with a new centre section adding 5 m of span, but adopted four 5,730 shp **Rolls-Royce Tyne** turboprops. Its pressurised fuselage, 4.9 m in diameter, held a 26 m cargo deck reached through a rear ramp: a Chieftain tank, two Wessex helicopters, three Saladin armoured cars or two **Polaris** missiles fitted inside. Above all, it was the first aircraft in the world designed from the outset for **automatic landing**: the Smiths system, triplex in pitch and roll, made its first autoland after only 120 hours of test flying.\n\n## Operational career\nThe Belfast entered service with No. 53 Squadron at Brize Norton on 20 January 1966, and, unusually for service aircraft, each was given a name. A drag problem held back the first aircraft: a new rear fairing raised the cruising speed by 64 km/h. But the creation of Strike Command and a reorganisation of transport assets doomed the fleet, which was retired at the end of 1976. Sold to HeavyLift, several returned to civil service, and the RAF chartered them during the **Falklands War** and again in the **Gulf War** to carry vehicles and helicopters too large for its Hercules.\n\n## Place in history\nThe largest aircraft the British military had ever operated when it entered service, the Belfast was built in only ten examples, against a forecast break-even point of thirty. Its civil versions and the jet variant studied with Lockheed, which would have used the wing of the **C-141 Starlifter**, never left the drawing board. A pioneer of automatic landing, it suffered above all from an order too short to last. The last aircraft built, *Enceladus*, is displayed at the RAF Museum at Cosford.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1957-03-01',
    '1964-01-05',
    '1966-01-20',
    567,
    9800,
    (SELECT id FROM manufacturer WHERE code = 'SHO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Short Belfast'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Short Belfast'), (SELECT id FROM tech WHERE name = 'Système d''atterrissage automatique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Short Belfast'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Short Belfast'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'Short Belfast'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 41.58,
  wingspan          = 48.4,
  height            = 14.33,
  wing_area         = 229.1,
  empty_weight      = 57606,
  mtow              = 104326,
  service_ceiling   = 9100,
  climb_rate        = 5.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Tyne R.Ty.12 Mk.101 (5 730 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1964,
  production_end    = 1968,
  units_built       = 10,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **Belfast C.1 (SC.5/10)** : seule version construite, dix exemplaires pour le No. 53 Squadron de la RAF\n- **SC5/10A et SC5/31** : projets civils, cargo à rampe arrière ou nez basculant, jusqu''à 288 passagers sur deux ponts\n- **SC5/15 et SC5/21** : projets militaires tactiques, le second à décollage court par soufflage de la couche limite\n- **SC.5/40, SC.5/41 et SC.5/45** : projets à réacteurs associant le fuselage du Belfast à l''aile du C-141, avec Lockheed\n- **Belfast civils** : cinq ex-RAF remis en état pour HeavyLift à partir de 1980',
  variants_en       = E'- **Belfast C.1 (SC.5/10)**: the only version built, ten aircraft for No. 53 Squadron RAF\n- **SC5/10A and SC5/31**: civil projects, rear-ramp or swing-nose freighter, up to 288 passengers on two decks\n- **SC5/15 and SC5/21**: tactical military projects, the latter with boundary-layer-control STOL\n- **SC.5/40, SC.5/41 and SC.5/45**: jet projects pairing the Belfast fuselage with the C-141 wing, with Lockheed\n- **Civil Belfasts**: five ex-RAF aircraft reworked for HeavyLift from 1980',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Short_Belfast',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Short_Belfast',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Short Belfast';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Short Belfast';
