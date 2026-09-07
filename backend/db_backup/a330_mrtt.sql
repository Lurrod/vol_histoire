-- Airbus A330 MRTT (Voyager / Phénix)
--
-- Photo : KC-30 A39-002 refuelling an USAF F-16 (cropped).jpg
--   licence Public domain — U.S. Air Force photo by Christian Turner
--   https://commons.wikimedia.org/wiki/File%3AKC-30_A39-002_refuelling_an_USAF_F-16_%28cropped%29.jpg

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
    'Airbus A330 MRTT',
    'Airbus A330 MRTT',
    'Airbus A330 MRTT (Voyager / Phénix)',
    'Airbus A330 MRTT (Voyager / Phénix)',
    'Ravitailleur européen devenu le standard hors des États-Unis',
    'European tanker that became the standard outside the United States',
    '/assets/airplanes/a330-mrtt.jpg',
    E'## Genèse\nLes ravitailleurs européens des années 2000 sont des avions de ligne convertis, tous différents et tous vieillissants : **VC10** britanniques, KC-135 français, Boeing 707 espagnols. Airbus propose une réponse unique bâtie sur l''A330, dont l''aile porte déjà, sans modification, cent onze tonnes de carburant — un gros-porteur civil transporte naturellement bien plus de kérosène qu''il n''en consomme.\n\n## Conception\nC''est là l''idée décisive : **aucun réservoir supplémentaire n''est nécessaire**. La soute reste donc entièrement disponible pour le fret ou trois cents passagers, et l''appareil est simultanément ravitailleur et transport — d''où *Multi Role Tanker Transport*. Il emporte selon les clients une perche rigide sous la queue, deux nacelles souples sous voilure, ou les deux. Les commandes de vol électriques de l''A330 sont conservées, y compris pour la perche, pilotée depuis le cockpit.\n\n## Carrière opérationnelle\nIl ravitaille au-dessus de la Libye en 2011, de l''Irak, de la Syrie et du Sahel, évacue des ressortissants de Kaboul en 2021 et sert d''avion sanitaire lourd — la France l''a employé pour transférer des patients en réanimation pendant la pandémie. Quinze pays l''exploitent, dont l''OTAN, qui en partage huit depuis les Pays-Bas.\n\n## Place dans l''histoire\nSoixante-dix-neuf exemplaires livrés. Il a remporté quasiment tous les appels d''offres hors des États-Unis, où le **KC-46** l''a battu en 2011 après une première victoire annulée sur recours. Son adoption a mis fin à la dépendance européenne aux ravitailleurs américains — l''un des manques les plus criants révélés par l''intervention en Libye.',
    E'## Genesis\nEurope''s tankers in the 2000s were converted airliners, all different and all ageing: British **VC10s**, French KC-135s, Spanish Boeing 707s. Airbus proposed a single answer built on the A330, whose wing already holds, without modification, a hundred and eleven tonnes of fuel — a civil widebody naturally carries far more kerosene than it burns.\n\n## Design\nThat is the decisive idea: **no additional tanks are needed**. The hold therefore stays entirely available for freight or three hundred passengers, and the aircraft is tanker and transport at once — hence *Multi Role Tanker Transport*. Depending on the customer it carries a boom under the tail, two hose pods under the wings, or both. The A330''s fly-by-wire controls are retained, including for the boom, which is flown from the cockpit.\n\n## Operational career\nIt refuelled over Libya in 2011, over Iraq, Syria and the Sahel, evacuated nationals from Kabul in 2021 and serves as a heavy medical aircraft — France used it to transfer intensive-care patients during the pandemic. Fifteen countries operate it, including NATO, which shares eight based in the Netherlands.\n\n## Place in history\nSeventy-nine delivered. It has won virtually every competition outside the United States, where the **KC-46** beat it in 2011 after an initial victory overturned on protest. Its adoption ended European dependence on American tankers — one of the starkest gaps exposed by the intervention in Libya.',
    (SELECT id FROM countries WHERE code = 'ESP'),
    '2004-01-01',
    '2007-06-15',
    '2011-06-01',
    880.0,
    14800.0,
    (SELECT id FROM manufacturer WHERE code = 'ADS'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM wars WHERE name = 'Intervention en Libye')),
((SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 58.8,
  wingspan          = 60.3,
  height            = 17.4,
  wing_area         = 361.6,
  empty_weight      = 125000,
  mtow              = 233000,
  service_ceiling   = 12600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 8000,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Trent 772B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 316.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2007,
  production_end    = NULL,
  units_built       = 79,
  unit_cost_usd     = 250000000,
  unit_cost_year    = 2020,
  operators_count   = 15,
  variants          = E'- **Voyager KC2 / KC3** : version britannique, louée à un consortium privé\n- **A330 Phénix** : version française, également transport de personnalités\n- **KC-30A** : version australienne, première à ravitailler par perche rigide\n- **MRTT+ / A330 NEO** : version à moteurs de nouvelle génération, en développement\n- Ravitaille **sans conversion** : le carburant est celui des réservoirs de voilure d''origine',
  variants_en       = E'- **Voyager KC2 / KC3** : British version, leased from a private consortium\n- **A330 Phénix** : French version, also used for VIP transport\n- **KC-30A** : Australian version, the first to refuel by flying boom\n- **MRTT+ / A330 NEO** : version with new-generation engines, in development\n- Refuels **without conversion**: the fuel is that of the original wing tanks',

  -- Strate 4 : qualitatif
  nickname          = 'Voyager',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Airbus_A330_MRTT',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Airbus_A330_MRTT',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force photo by Christian Turner',
  image_licence     = 'Public domain'
WHERE name = 'Airbus A330 MRTT';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Airbus A330 MRTT';
