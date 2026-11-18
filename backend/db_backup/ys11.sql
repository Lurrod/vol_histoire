-- NAMC YS-11 (versions des forces d'autodéfense)
--
-- Photo : YS-11EB.jpg
--   licence CC BY-SA 4.0 — Leadsolo55555
--   https://commons.wikimedia.org/wiki/File:YS-11EB.jpg

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
    'NAMC YS-11',
    'NAMC YS-11',
    'NAMC YS-11 (versions des forces d''autodéfense)',
    'NAMC YS-11 (Self-Defense Force versions)',
    'Le seul avion de ligne japonais d''après-guerre, transport et avion d''écoute des forces d''autodéfense',
    'Japan''s only post-war airliner, a transport and electronic intelligence aircraft for the Self-Defense Forces',
    '/assets/airplanes/namc-ys11.jpg',
    E'## Genèse\nAu milieu des années 1950, le ministère japonais du Commerce international et de l''Industrie veut un court-courrier national pour remplacer les **Douglas DC-3** et relancer une industrie aéronautique démantelée par la défaite. Une association d''études naît en mai 1957, puis en 1959 le consortium **NAMC**, détenu par l''État et par Mitsubishi, Kawasaki, Fuji, Shin Meiwa et d''autres industriels. Parmi les ingénieurs figure **Jiro Horikoshi**, le concepteur du chasseur Zero. Le prototype du YS-11 vole le 30 août 1962 à Nagoya, et les premières livraisons ont lieu le 30 mars 1965.\n\n## Conception\nLe YS-11 est un monoplan à aile basse propulsé par deux turbopropulseurs britanniques **Rolls-Royce Dart**, conçu pour offrir les performances du **Vickers Viscount** quadrimoteur avec une capacité de soixante places. Ses premiers essais révèlent une tenue de route médiocre, des vibrations et un manque d''efficacité des gouvernes qui doivent être corrigés. Pour les forces d''autodéfense, NAMC en tire une version purement cargo, la YS-11A-400, que seuls les militaires japonais utiliseront, et la Force aérienne d''autodéfense en exploite une variante propulsée par des turbopropulseurs **IHI T64**, le « Super YS ».\n\n## Carrière opérationnelle\nLa **Force aérienne d''autodéfense** reçoit ses YS-11 au 402e escadron de transport tactique à partir de 1968, puis au 401e en 1969. Elle en fait aussi des avions spécialisés : trois YS-11P de transport de personnalités, trois YS-11FC de contrôle en vol des aides à la navigation, un YS-11NT d''entraînement à la navigation, deux YS-11EA de guerre électronique et quatre YS-11EB de renseignement électronique. La **Force maritime d''autodéfense** reçoit quatre cargos YS-11M et M-A, exploités par son 61e escadron de 1971 à 2014, et six YS-11T-A d''entraînement des équipages de patrouille maritime ; le dernier des 182 YS-11 lui est livré le 11 mai 1973.\n\n## Place dans l''histoire\nÉchec commercial pour un consortium écrasé de dettes, le YS-11 connaît chez les militaires japonais une longévité exceptionnelle : les transports de personnalités quittent la JASDF en 2017, les avions de contrôle en vol en 2021, mais trois YS-11 y volaient encore en juin 2024, dont les YS-11EB de renseignement électronique. La garde côtière japonaise, l''armée de l''air grecque et celle des Philippines en ont aussi exploité. Seul avion de ligne entièrement conçu et construit au Japon jusqu''au Mitsubishi SpaceJet, il a prouvé que le pays savait de nouveau bâtir un avion de transport.',
    E'## Genesis\nIn the mid-1950s Japan''s Ministry of International Trade and Industry wanted a domestic short-haul airliner to replace **Douglas DC-3s** and revive an aircraft industry dismantled by defeat. A design research association was set up in May 1957, followed in 1959 by the **NAMC** consortium, owned by the state and by Mitsubishi, Kawasaki, Fuji, Shin Meiwa and other manufacturers. Its engineers included **Jiro Horikoshi**, designer of the Zero fighter. The YS-11 prototype flew on 30 August 1962 at Nagoya, and the first deliveries took place on 30 March 1965.\n\n## Design\nThe YS-11 was a low-wing monoplane powered by two British **Rolls-Royce Dart** turboprops, designed to match the performance of the four-engined **Vickers Viscount** with a capacity of sixty seats. Early flight tests revealed poor handling, vibration and ineffective control surfaces that had to be cured. For the Self-Defense Forces NAMC produced a pure cargo version, the YS-11A-400, used only by the Japanese military, and the Air Self-Defense Force operated a variant powered by **IHI T64** turboprops, the ''Super YS''.\n\n## Operational career\nThe **Japan Air Self-Defense Force** received its YS-11s with the 402nd Tactical Airlift Squadron from 1968, then with the 401st in 1969. It also turned them into specialised aircraft: three YS-11P VIP transports, three YS-11FC navigation aid flight checkers, one YS-11NT navigation trainer, two YS-11EA electronic warfare aircraft and four YS-11EB electronic intelligence aircraft. The **Japan Maritime Self-Defense Force** received four YS-11M and M-A freighters, flown by Air Transport Squadron 61 from 1971 to 2014, and six YS-11T-A maritime patrol crew trainers; the last of the 182 YS-11s was delivered to it on 11 May 1973.\n\n## Place in history\nA commercial failure for a consortium crushed by debt, the YS-11 enjoyed exceptional longevity with the Japanese military: the VIP transports left the JASDF in 2017 and the flight checkers in 2021, but three YS-11s were still flying with it in June 2024, among them the YS-11EB electronic intelligence aircraft. The Japan Coast Guard, the Hellenic Air Force and the Philippine Air Force also operated it. The only airliner wholly designed and built in Japan until the Mitsubishi SpaceJet, it proved that the country could once again build a transport aircraft.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1957-05-01',
    '1962-08-30',
    '1968-01-01',
    NULL,
    2110,
    (SELECT id FROM manufacturer WHERE code = 'NIH'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'NAMC YS-11'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'NAMC YS-11'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'NAMC YS-11'), (SELECT id FROM missions WHERE name = 'Guerre électronique')),
((SELECT id FROM airplanes WHERE name = 'NAMC YS-11'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26.3,
  wingspan          = 32.0,
  height            = 8.98,
  wing_area         = 94.83,
  empty_weight      = 15396,
  mtow              = 24500,
  service_ceiling   = 6982,
  climb_rate        = 6.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Dart Mk.542-10K (3 060 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1974,
  units_built       = 23,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 4,
  variants          = E'- **YS-11P** : transport de personnalités de la JASDF, trois exemplaires (403e escadron, 1978-2017)\n- **YS-11FC / YS-11NT** : contrôle en vol des aides à la navigation (trois exemplaires) et entraînement à la navigation (un) pour la JASDF\n- **YS-11EA / YS-11EB** : guerre électronique (deux) et renseignement électronique (quatre) ; le « Super YS » YS-11E est propulsé par des turbopropulseurs IHI T64\n- **YS-11M / M-A** : cargos de la Force maritime d''autodéfense, quatre exemplaires (61e escadron, 1971-2014)\n- **YS-11T-A** : six appareils d''entraînement des équipages de patrouille maritime de la JMSDF\n- **YS-11A-400** : version purement cargo, réservée aux forces d''autodéfense',
  variants_en       = E'- **YS-11P**: JASDF VIP transport, three aircraft (403rd Squadron, 1978-2017)\n- **YS-11FC / YS-11NT**: navigation aid flight checker (three aircraft) and navigation trainer (one) for the JASDF\n- **YS-11EA / YS-11EB**: electronic warfare (two) and electronic intelligence (four); the ''Super YS'' YS-11E is powered by IHI T64 turboprops\n- **YS-11M / M-A**: Maritime Self-Defense Force freighters, four aircraft (Air Transport Squadron 61, 1971-2014)\n- **YS-11T-A**: six JMSDF maritime patrol crew trainers\n- **YS-11A-400**: pure cargo version, used only by the Self-Defense Forces',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/NAMC_YS-11',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/NAMC_YS-11',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Leadsolo55555',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'NAMC YS-11';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'NAMC YS-11';
