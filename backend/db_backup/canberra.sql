-- English Electric Canberra
--
-- Photo : English Electric Canberra bomber Downunder Shellharbour 2024.jpg
--   licence CC BY-SA 2.0 — Hugh Llewelyn from Keynsham, UK
--   https://commons.wikimedia.org/wiki/File%3AEnglish_Electric_Canberra_PR9_%2850113005286%29.jpg

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
    'English Electric Canberra',
    'English Electric Canberra',
    'English Electric Canberra',
    'English Electric Canberra',
    'Bombardier à réaction britannique, 57 ans de service opérationnel',
    'British jet bomber, 57 years of operational service',
    '/assets/airplanes/canberra.jpg',
    E'## Genèse\nLe cahier des charges de 1944 tient en une phrase : un bombardier volant **plus haut et plus vite que tout chasseur**, donc sans aucun armement défensif. English Electric, qui n''avait jamais conçu d''avion, confie le projet à W. E. W. Petter et livre le premier bombardier à réaction britannique.\n\n## Conception\nAile droite de très grande surface et deux Avon puissants : le Canberra grimpe à 15 000 mètres et y reste. La cellule est si saine qu''elle acceptera pendant cinquante ans des missions pour lesquelles elle n''a pas été dessinée — reconnaissance photographique, guerre électronique, essais en vol, recherche atmosphérique.\n\n## Carrière opérationnelle\nPendant l''**insurrection malaise**, huit Canberra britanniques opèrent de Butterworth à partir de mars 1955 (opération *Mileage*), relayés par des escadrons britannique, australien et néo-zélandais qui bombardent les camps marqués par des Auster. Lors de la **crise de Suez**, une centaine de Canberra de la RAF bombardent de nuit les aérodromes égyptiens depuis Malte et Chypre ; l''un d''eux, un PR.7, est abattu au-dessus de la Syrie le 6 novembre. Pendant la **guerre froide**, les quatre escadrons de Canberra de la RAF Germany emportent des bombes nucléaires américaines de 1960 à 1972 ; des Canberra de reconnaissance auraient survolé Kapustin Yar en 1953 et longé l''URSS en 1954 (*Project Robin*), et les PR.9 photographient l''Europe de l''Est depuis la frontière interallemande. Seuls bombardiers de l''ONU pendant la **crise congolaise**, les B(I)58 indiens, arrivés à Léopoldville en octobre 1961, frappent le 5 décembre la base katangaise de Kolwezi, puis Jadotville et le camp Massart ; le 18 décembre, douze Canberra indiens du No. 35 Squadron bombardent la piste de Dabolim lors de l''**annexion de Goa**. Quinze pays l''emploient, dont l''Australie au **Vietnam**, l''Inde contre le Pakistan en 1965 et 1971, et l''Argentine aux **Malouines** en 1982 — où des Canberra argentins affrontent des Sea Harrier britanniques, deux appareils issus de la même industrie. En Afrique australe, les Canberra rhodésiens bombardent les camps de la ZANLA au Mozambique et de la ZIPRA en Zambie pendant la **guerre du Bush rhodésien**, du raid de Chimoio en 1977 à Westlands Farm en 1978, et deux sont abattus par la DCA ; pendant la **guerre de la frontière sud-africaine**, les B(I).12 sud-africains ouvrent le raid de Cassinga, puis bombardent pendant *Protea* et *Askari*. Lors de la **guerre de Kargil**, le 21 mai, un PR.57 indien en reconnaissance photo est touché à un moteur par un missile portable et rentre sur l''autre à Srinagar. Les derniers PR.9 de la RAF volent au-dessus de l''**Afghanistan** jusqu''en 2006.\n\n## Place dans l''histoire\n**Cinquante-sept ans** de service opérationnel continu, un record pour un avion de combat britannique. C''est aussi le seul bombardier étranger jamais adopté par l''US Air Force, produit sous licence par Martin sous le nom de **B-57**.',
    E'## Genesis\nThe 1944 specification fits in one sentence: a bomber flying **higher and faster than any fighter**, and therefore carrying no defensive armament. English Electric, which had never designed an aircraft, handed the project to W. E. W. Petter and delivered Britain’s first jet bomber.\n\n## Design\nA large straight wing and two powerful Avons: the Canberra climbs to 15,000 metres and stays there. The airframe is so sound that for fifty years it accepted missions it was never drawn for — photographic reconnaissance, electronic warfare, flight testing, atmospheric research.\n\n## Operational career\nDuring the **Malayan Emergency**, eight British Canberras flew from Butterworth from March 1955 (Operation *Mileage*), followed by British, Australian and New Zealand squadrons bombing camps marked by Austers. In the **Suez Crisis**, around a hundred RAF Canberras bombed Egyptian airfields by night from Malta and Cyprus; one of them, a PR.7, was shot down over Syria on 6 November. During the **Cold War**, RAF Germany''s four Canberra squadrons carried US nuclear bombs from 1960 to 1972; reconnaissance Canberras reportedly overflew Kapustin Yar in 1953 and skirted the USSR in 1954 (*Project Robin*), and PR.9s photographed Eastern Europe from the inner German border. The UN''s only bombers in the **Congo Crisis**, India''s B(I)58s reached Léopoldville in October 1961 and on 5 December struck the Katangese base at Kolwezi, then Jadotville and Camp Massart; on 18 December twelve Indian Canberras of No. 35 Squadron bombed the Dabolim runway during the **annexation of Goa**. Fifteen countries flew it, including Australia over **Vietnam**, India against Pakistan in 1965 and 1971, and Argentina in the **Falklands** in 1982 — where Argentine Canberras faced British Sea Harriers, two aircraft from the same industry. In southern Africa, Rhodesian Canberras bombed ZANLA camps in Mozambique and ZIPRA camps in Zambia during the **Rhodesian Bush War**, from the Chimoio raid in 1977 to Westlands Farm in 1978, and two were shot down by ground fire; in the **South African Border War**, South African B(I).12s opened the Cassinga raid, then bombed during *Protea* and *Askari*. In the **Kargil War**, on 21 May, an Indian PR.57 on photo reconnaissance was hit in one engine by a shoulder-fired missile and returned to Srinagar on the other. The RAF’s last PR.9s flew over **Afghanistan** until 2006.\n\n## Place in history\n**Fifty-seven years** of continuous operational service, a record for a British combat aircraft. It is also the only foreign bomber ever adopted by the US Air Force, licence-built by Martin as the **B-57**.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-01-01',
    '1949-05-13',
    '1951-05-01',
    933.0,
    5440.0,
    (SELECT id FROM manufacturer WHERE code = 'EE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Avon'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM armement WHERE name = 'ADEN 30 mm')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM armement WHERE name = 'Bombe lisse 1000 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM missions WHERE name = 'Frappe stratégique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971')),
((SELECT id FROM airplanes WHERE name = 'English Electric Canberra'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.96,
  wingspan          = 19.51,
  height            = 4.78,
  wing_area         = 89.19,
  empty_weight      = 9820,
  mtow              = 24950,
  service_ceiling   = 15000,
  climb_rate        = 17,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1300,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Avon 109',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 33.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1963,
  units_built       = 1352,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **B.2 / B(I).8** : bombardiers, avec ou sans nez d''intrusion vitré\n- **PR.9** : reconnaissance à très haute altitude, retiré en 2006\n- **Martin B-57** : production américaine sous licence, seul bombardier étranger adopté par l''US Air Force\n- **Canberra indiens** : engagés en 1965, 1971 et jusqu''en 2007',
  variants_en       = E'- **B.2 / B(I).8** : bombers, with or without a glazed intruder nose\n- **PR.9** : very high altitude reconnaissance, retired in 2006\n- **Martin B-57** : American licence production, the only foreign bomber adopted by the US Air Force\n- **Indian Canberras** : committed in 1965, 1971 and until 2007',

  -- Strate 4 : qualitatif
  nickname          = 'Canberra',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/English_Electric_Canberra',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/English_Electric_Canberra',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Daniel Z97',
  image_licence     = 'CC BY 4.0'
WHERE name = 'English Electric Canberra';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'English Electric Canberra';
