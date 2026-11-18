-- Bristol Type 170 Freighter
--
-- Photo : Bristol freighter RNZAF 1963.jpg
--   licence CC BY-SA 4.0 — Don Christie
--   https://commons.wikimedia.org/wiki/File:Bristol_freighter_RNZAF_1963.jpg

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
    'Bristol Freighter',
    'Bristol Freighter',
    'Bristol Type 170 Freighter',
    'Bristol Type 170 Freighter',
    'Le cargo à portes de nez conçu pour emporter un camion de l''armée, de Silver City à la RNZAF',
    'The nose-loading freighter designed to carry an army truck, from Silver City to the RNZAF',
    '/assets/airplanes/bristol-freighter.jpg',
    E'## Genèse\nLe Type 170 naît comme un projet d''attente : **Bristol** veut occuper ses bureaux d''études pendant le développement du géant **Brabazon**. L''Air Ministry y voit un transport robuste capable d''utiliser des pistes sommaires et commande deux prototypes, à condition que l''avion puisse emporter un camion de 3 tonnes de l''armée britannique ; il en tire la spécification 22/44, révisée en C.9/45. Destiné à la logistique du théâtre d''Asie du Sud-Est, il arrive trop tard pour la guerre : le prototype G-AGPV, piloté par **Cyril Uwins**, vole à Filton le 2 décembre 1945.\n\n## Conception\nC''est un bimoteur métallique à aile haute, au fuselage de section carrée libre de toute obstruction. Pour charger un camion, la trappe de nez prévue à l''origine cède la place à deux grandes portes en coquille ; le poste de pilotage, perché au-dessus de la soute, laisse entrer les véhicules par une rampe. Le train fixe, plus léger qu''un train escamotable sur des étapes courtes, réduit les coûts de fabrication et d''entretien. Les deux moteurs en étoile **Bristol Hercules** de 2 000 ch se déposent si facilement qu''un changement complet prend 90 minutes.\n\n## Carrière opérationnelle\nSi le Freighter doit sa célébrité aux compagnies, notamment aux bacs aériens de Silver City Airways qui franchissent la Manche avec voitures et passagers à partir de 1948, il sert aussi dans les forces aériennes d''Argentine, l''un des premiers clients avec quinze appareils, d''Australie, de Birmanie, du Canada, du Pakistan et de Nouvelle-Zélande. La **Royal New Zealand Air Force** reçoit douze Mk 31M : ils ravitaillent l''armée néo-zélandaise en Malaisie, desservent les représentations britanniques des Maldives au Népal et assurent, pendant la **guerre du Vietnam**, une navette militaire très fiable au profit des alliés en Thaïlande. En **Indochine**, au moins un Freighter de la compagnie Aigle Azur est réquisitionné pour ravitailler Diên Biên Phu.\n\n## Place dans l''histoire\nLes Freighter néo-zélandais quittent le service militaire dans les années 1970, remplacés par des **Hawker Siddeley Andover**. Au total, 214 exemplaires sortent d''usine jusqu''en 1958, dont soixante-huit seront détruits ou jugés irréparables après un accident. Rustique, économique, chargé par le nez, le Type 170 a montré qu''un avion simple, pensé d''abord pour le fret, pouvait servir aussi bien une ligne commerciale qu''une force aérienne opérant loin de ses bases.',
    E'## Genesis\nThe Type 170 began as a stopgap project: **Bristol** wanted to keep its design office busy while the giant **Brabazon** was under development. The Air Ministry saw in it a rugged transport able to use rough strips and ordered two prototypes, on condition that the aircraft could carry a British Army 3-ton truck; it issued Specification 22/44, later revised as C.9/45. Intended for logistics in the South-East Asian theatre, it came too late for the war: the prototype G-AGPV, flown by **Cyril Uwins**, took off from Filton on 2 December 1945.\n\n## Design\nIt was an all-metal, twin-engined high-wing monoplane with a square-section fuselage free of internal obstructions. To load a truck, the originally planned nose trapdoor gave way to a pair of large clamshell doors; the flight deck, perched above the hold, let vehicles drive in up a ramp. The fixed undercarriage, lighter than a retractable one on short stages, cut production and maintenance costs. The two 2,000 hp **Bristol Hercules** radial engines were so easy to remove that a complete change took 90 minutes.\n\n## Operational career\nWhile the Freighter owes its fame to the airlines, notably Silver City Airways'' air ferries carrying cars and passengers across the Channel from 1948, it also served with the air forces of Argentina, one of the first customers with fifteen aircraft, Australia, Burma, Canada, Pakistan and New Zealand. The **Royal New Zealand Air Force** received twelve Mk 31Ms: they supplied the New Zealand Army in Malaya, served British High Commissions from the Maldives to Nepal and, during the **Vietnam War**, ran a highly reliable military shuttle for allies in Thailand. In **Indochina**, at least one Freighter of the airline Aigle Azur was impressed to fly supplies into Dien Bien Phu.\n\n## Place in history\nThe New Zealand Freighters left military service in the 1970s, replaced by **Hawker Siddeley Andovers**. In all, 214 were built up to 1958, sixty-eight of which would be destroyed or damaged beyond repair in accidents. Rugged, economical and nose-loading, the Type 170 showed that a simple aircraft designed first for freight could serve an airline route as well as an air force operating far from its bases.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-01-01',
    '1945-12-02',
    '1946-01-01',
    362,
    1320,
    (SELECT id FROM manufacturer WHERE code = 'BRI'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol Freighter'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol Freighter'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Bristol Freighter'), (SELECT id FROM wars WHERE name = 'Guerre d''Indochine')),
((SELECT id FROM airplanes WHERE name = 'Bristol Freighter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 20.83,
  wingspan          = 32.92,
  height            = 6.6,
  wing_area         = 138.1,
  empty_weight      = 12206,
  mtow              = 19958,
  service_ceiling   = 7000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Hercules 734 (2 000 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1958,
  units_built       = 214,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **Mk I Freighter / Mk II Wayfarer** : premières séries, à portes de nez ou en version passagers au nez fermé\n- **Mk 21** : moteurs plus puissants ; la Royal Australian Air Force en exploite un (A81-1)\n- **Mk 31 / Mk 31M** : version principale ; le 31M militaire équipe notamment la RNZAF (douze exemplaires) et l''aviation royale canadienne\n- **Mk 32 Superfreighter** : fuselage allongé pour trois voitures et vingt passagers, lancé en 1953',
  variants_en       = E'- **Mk I Freighter / Mk II Wayfarer**: first series, with nose doors or as a passenger version with a fixed nose\n- **Mk 21**: more powerful engines; the Royal Australian Air Force operated one (A81-1)\n- **Mk 31 / Mk 31M**: main version; the military 31M served notably with the RNZAF (twelve aircraft) and the Royal Canadian Air Force\n- **Mk 32 Superfreighter**: lengthened fuselage for three cars and twenty passengers, introduced in 1953',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bristol_Freighter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bristol_Freighter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Don Christie',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Bristol Freighter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bristol Freighter';
