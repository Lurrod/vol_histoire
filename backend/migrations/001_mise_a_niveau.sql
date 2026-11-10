-- 001_mise_a_niveau.sql — migration unique
--
-- Destinée aux bases DÉJÀ installées. Une installation à neuf n'en a pas
-- besoin : db_backup/db.sql et les fiches contiennent déjà le résultat.
--
-- Elle regroupe tout ce qui doit passer AVANT l'import des fiches ajoutées :
--   1. schéma      : retrait de `weight`, ajout de `image_credit` / `image_licence`
--   2. référentiel : pays, conflits, armements, technologies, types, constructeurs
--   3. furtivité   : `stealth_level` sur l'ensemble du catalogue
--   4. crédits     : auteur et licence des photos
--   5. réparation : liaisons perdues des sept fiches historiquement en échec
--   6. audit       : fuseaux, vocabulaire des statuts, conflit orphelin
--   7. contraintes : garde-fous CHECK sur `airplanes`
--
-- Ordre d'exécution complet :
--
--   psql -f backend/migrations/001_mise_a_niveau.sql
--   puis les fiches ajoutées :  psql -f backend/db_backup/<fiche>.sql
--   puis, en dernier :          psql -f backend/db_backup/zz_backfill_relations.sql
--
-- zz_backfill_relations.sql passe après parce qu'il résout les filiations et
-- exige que tous les appareils soient présents. Les UPDATE de ce fichier qui
-- ne trouvent pas leur cible sont sans effet : il peut être joué avant ou
-- après l'import.
--
-- Entièrement rejouable : chaque étape est gardée. Tout UPDATE de `airplanes`
-- porte une garde IS DISTINCT FROM sur les colonnes qu'il écrit : seules les
-- lignes réellement modifiées sont touchées, sinon le déclencheur de updated_at
-- daterait du jour toutes les fiches à chaque rejeu (lastmod du sitemap faussé).
-- Une nouvelle instruction doit suivre la même règle.

BEGIN;

-- ═══ 1. Schéma ═══════════════════════════════════════════════════════════

-- `weight` doublonnait `empty_weight` sans sémantique définie : sur les 107
-- fiches d'origine, 65 portaient la même valeur et les 42 autres ne s'en
-- écartaient que par l'arrondi. On récupère les valeurs orphelines avant de
-- supprimer la colonne.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'airplanes' AND column_name = 'weight') THEN
    UPDATE airplanes SET empty_weight = weight
     WHERE empty_weight IS NULL AND weight IS NOT NULL;
    ALTER TABLE airplanes DROP COLUMN weight;
  END IF;
END $$;

-- Attribution des photos : les licences Creative Commons imposent de citer
-- l'auteur. La légende sous l'image n'est affichée que si l'un des deux
-- champs est renseigné.
ALTER TABLE airplanes ADD COLUMN IF NOT EXISTS image_credit  VARCHAR(255);
ALTER TABLE airplanes ADD COLUMN IF NOT EXISTS image_licence VARCHAR(100);

-- ═══ 2. Référentiel ══════════════════════════════════════════════════════
--
-- Toute donnée partagée par plusieurs fiches se déclare ici : les fiches
-- sont chargées par ordre alphabétique, une déclaration locale n'étant donc
-- visible que des fiches chargées après elle.

-- Pays requis par les conflits ajoutés
-- Pays : tout le référentiel, gardé par NOT EXISTS (rejouable et exhaustif)
INSERT INTO countries (name, name_en, code)
SELECT 'États-Unis', 'United States', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'USA');
INSERT INTO countries (name, name_en, code)
SELECT 'Russie', 'Russia', 'RUS'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'RUS');
INSERT INTO countries (name, name_en, code)
SELECT 'Chine', 'China', 'CHN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'CHN');
INSERT INTO countries (name, name_en, code)
SELECT 'France', 'France', 'FRA'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'FRA');
INSERT INTO countries (name, name_en, code)
SELECT 'Royaume-Uni', 'United Kingdom', 'GBR'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'GBR');
INSERT INTO countries (name, name_en, code)
SELECT 'Allemagne', 'Germany', 'DEU'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'DEU');
INSERT INTO countries (name, name_en, code)
SELECT 'Italie', 'Italy', 'ITA'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ITA');
INSERT INTO countries (name, name_en, code)
SELECT 'Suède', 'Sweden', 'SWE'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'SWE');
INSERT INTO countries (name, name_en, code)
SELECT 'Inde', 'India', 'IND'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'IND');
INSERT INTO countries (name, name_en, code)
SELECT 'Japon', 'Japan', 'JPN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'JPN');
INSERT INTO countries (name, name_en, code)
SELECT 'Brésil', 'Brazil', 'BRA'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'BRA');
INSERT INTO countries (name, name_en, code)
SELECT 'Israël', 'Israel', 'ISR'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ISR');
INSERT INTO countries (name, name_en, code)
SELECT 'Vietnam', 'Vietnam', 'VNM'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'VNM');
INSERT INTO countries (name, name_en, code)
SELECT 'Afghanistan', 'Afghanistan', 'AFG'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'AFG');
INSERT INTO countries (name, name_en, code)
SELECT 'Irak', 'Iraq', 'IRQ'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'IRQ');
INSERT INTO countries (name, name_en, code)
SELECT 'Yougoslavie', 'Yugoslavia', 'YUG'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'YUG');
INSERT INTO countries (name, name_en, code)
SELECT 'Corée', 'Korea', 'KOR'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'KOR');
INSERT INTO countries (name, name_en, code)
SELECT 'Îles Malouines', 'Falkland Islands', 'FLK'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'FLK');
INSERT INTO countries (name, name_en, code)
SELECT 'Liban', 'Lebanon', 'LBN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'LBN');
INSERT INTO countries (name, name_en, code)
SELECT 'Algérie', 'Algeria', 'DZA'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'DZA');
INSERT INTO countries (name, name_en, code)
SELECT 'Syrie', 'Syria', 'SYR'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'SYR');
INSERT INTO countries (name, name_en, code)
SELECT 'Iran', 'Iran', 'IRN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'IRN');
INSERT INTO countries (name, name_en, code)
SELECT 'Libye', 'Libya', 'LBY'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'LBY');
INSERT INTO countries (name, name_en, code)
SELECT 'Ukraine', 'Ukraine', 'UKR'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'UKR');
INSERT INTO countries (name, name_en, code)
SELECT 'Corée du Sud', 'South Korea', 'ROK'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ROK');
INSERT INTO countries (name, name_en, code)
SELECT 'Turquie', 'Turkey', 'TUR'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'TUR');
INSERT INTO countries (name, name_en, code)
SELECT 'Tchécoslovaquie', 'Czechoslovakia', 'CSK'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'CSK');
INSERT INTO countries (name, name_en, code)
SELECT 'Taïwan', 'Taiwan', 'TWN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'TWN');
INSERT INTO countries (name, name_en, code)
SELECT 'Pologne', 'Poland', 'POL'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'POL');
INSERT INTO countries (name, name_en, code)
SELECT 'Espagne', 'Spain', 'ESP'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ESP');
INSERT INTO countries (name, name_en, code)
SELECT 'Afrique du Sud', 'South Africa', 'ZAF'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ZAF');
INSERT INTO countries (name, name_en, code)
SELECT 'Argentine', 'Argentina', 'ARG'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ARG');
INSERT INTO countries (name, name_en, code)
SELECT 'Suisse', 'Switzerland', 'CHE'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'CHE');
INSERT INTO countries (name, name_en, code)
SELECT 'Pays-Bas', 'Netherlands', 'NLD'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'NLD');
INSERT INTO countries (name, name_en, code)
SELECT 'Finlande', 'Finland', 'FIN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'FIN');
INSERT INTO countries (name, name_en, code)
SELECT 'Chili', 'Chile', 'CHL'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'CHL');
INSERT INTO countries (name, name_en, code)
SELECT 'Pakistan', 'Pakistan', 'PAK'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'PAK');
INSERT INTO countries (name, name_en, code)
SELECT 'Indonésie', 'Indonesia', 'IDN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'IDN');
INSERT INTO countries (name, name_en, code)
SELECT 'Canada', 'Canada', 'CAN'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'CAN');
INSERT INTO countries (name, name_en, code)
SELECT 'Roumanie', 'Romania', 'ROU'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'ROU');
INSERT INTO countries (name, name_en, code)
SELECT 'Australie', 'Australia', 'AUS'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'AUS');
INSERT INTO countries (name, name_en, code)
SELECT 'Égypte', 'Egypt', 'EGY'
WHERE NOT EXISTS (SELECT 1 FROM countries WHERE code = 'EGY');

-- Conflits absents du jeu initial
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Intervention en Libye', 'Libyan Intervention', '2011-03-19', '2011-10-31', (SELECT id FROM countries WHERE code = 'LBY'), 'Campagne aérienne d''une coalition OTAN contre les forces de Mouammar Kadhafi, sous mandat de la résolution 1973 du Conseil de sécurité.', 'NATO-led air campaign against Muammar Gaddafi''s forces, mandated by UN Security Council Resolution 1973.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Intervention en Libye');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Conflit indo-pakistanais de 2019', 'India-Pakistan Standoff of 2019', '2019-02-26', '2019-03-01', (SELECT id FROM countries WHERE code = 'IND'), 'Affrontement aérien entre l''Inde et le Pakistan après la frappe de Balakot, incluant le premier combat aérien entre puissances nucléaires.', 'Air confrontation between India and Pakistan following the Balakot strike, including the first air combat between nuclear powers.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Conflit indo-pakistanais de 2019');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Invasion russe de l''Ukraine', 'Russian Invasion of Ukraine', '2022-02-24', NULL, (SELECT id FROM countries WHERE code = 'UKR'), 'Conflit de haute intensité opposant la Russie à l''Ukraine, marqué par une guerre aérienne contestée et un usage massif de missiles de croisière et de drones.', 'High-intensity conflict between Russia and Ukraine, marked by contested air warfare and massive use of cruise missiles and drones.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Invasion russe de l''Ukraine');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre d''Indochine', 'First Indochina War', '1946-12-19', '1954-07-21', (SELECT id FROM countries WHERE code = 'VNM'), 'Guerre de décolonisation entre la France et le Viêt Minh. L''aviation française, équipée surtout de matériel américain, y assure appui au sol et ravitaillement de camps isolés jusqu''à Diên Biên Phu.', 'Decolonisation war between France and the Viet Minh. French air power, largely American-supplied, provided ground support and supplied isolated garrisons up to Dien Bien Phu.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre d''Indochine');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Insurrection malaise', 'Malayan Emergency', '1948-06-16', '1960-07-31', NULL, 'Guérilla communiste en Malaisie britannique, combattue par le Commonwealth. Les opérations aériennes (opération Firedog) frappent les camps dans la jungle.', 'Communist guerrilla war in British Malaya, fought by the Commonwealth. Air operations (Operation Firedog) struck jungle camps.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Insurrection malaise');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Crise de Suez', 'Suez Crisis', '1956-10-29', '1956-11-07', (SELECT id FROM countries WHERE code = 'EGY'), 'Intervention franco-britannique (opération Mousquetaire) et offensive israélienne dans le Sinaï contre l''Égypte après la nationalisation du canal. Les aérodromes égyptiens sont neutralisés en quelques jours depuis Chypre, Malte et les porte-avions.', 'Anglo-French intervention (Operation Musketeer) and Israeli offensive in the Sinai against Egypt after the canal''s nationalisation. Egyptian airfields were neutralised within days from Cyprus, Malta and carriers.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Crise de Suez');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Crise congolaise', 'Congo Crisis', '1960-07-05', '1965-11-25', NULL, 'Guerre civile et sécession du Katanga après l''indépendance du Congo belge, avec intervention des Nations unies puis de mercenaires appuyés par la CIA. Premier engagement aérien de combat d''une force de l''ONU.', 'Civil war and Katangan secession after Belgian Congo''s independence, with UN intervention and later CIA-backed mercenaries. First combat air operation by a United Nations force.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Crise congolaise');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre coloniale portugaise', 'Portuguese Colonial War', '1961-02-04', '1974-04-25', NULL, 'Guerres menées par le Portugal contre les mouvements indépendantistes d''Angola, de Guinée et du Mozambique, jusqu''à la révolution des Œillets. L''appui aérien et le transport de troupes y sont permanents.', 'Wars fought by Portugal against independence movements in Angola, Guinea and Mozambique until the Carnation Revolution. Air support and troop transport were constant.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre coloniale portugaise');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Invasion de la baie des Cochons', 'Bay of Pigs Invasion', '1961-04-17', '1961-04-20', NULL, 'Débarquement d''exilés cubains soutenus par la CIA, repoussé en trois jours par les forces de Fidel Castro. L''aviation cubaine, réduite à quelques appareils, coule deux navires et abat plusieurs B-26 de l''invasion.', 'CIA-backed landing by Cuban exiles, defeated within three days by Fidel Castro''s forces. Cuba''s handful of aircraft sank two ships and shot down several of the invaders'' B-26s.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Invasion de la baie des Cochons');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Annexion de Goa', 'Annexation of Goa', '1961-12-18', '1961-12-19', (SELECT id FROM countries WHERE code = 'IND'), 'Opération Vijay : l''Inde s''empare en deux jours des possessions portugaises de Goa, Daman et Diu. L''aviation indienne neutralise l''aérodrome de Dabolim et les transmissions.', 'Operation Vijay: India seized Portugal''s enclaves of Goa, Daman and Diu in two days. The Indian Air Force neutralised Dabolim airfield and communications.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Annexion de Goa');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Confrontation indonésio-malaisienne', 'Indonesia–Malaysia Confrontation', '1963-01-20', '1966-08-11', (SELECT id FROM countries WHERE code = 'IDN'), 'Conflit de basse intensité opposant l''Indonésie de Soekarno à la Malaisie et au Commonwealth, surtout à Bornéo. L''aviation britannique y assure défense aérienne et appui.', 'Low-intensity conflict between Sukarno''s Indonesia and Malaysia and the Commonwealth, mainly on Borneo. British air power provided air defence and support.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Confrontation indonésio-malaisienne');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Urgence d''Aden', 'Aden Emergency', '1963-12-10', '1967-11-30', NULL, 'Insurrection nationaliste contre la présence britannique à Aden et dans le protectorat, jusqu''au retrait de 1967. La campagne du Radfan (1964) mobilise chasseurs et bombardiers de la RAF.', 'Nationalist insurgency against British rule in Aden and its protectorate until the 1967 withdrawal. The 1964 Radfan campaign drew in RAF fighters and bombers.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Urgence d''Aden');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Conflit armé colombien', 'Colombian conflict', '1964-05-27', NULL, NULL, 'Guerre entre l''État colombien et les guérillas FARC et ELN, puis les groupes paramilitaires et narcotrafiquants. L''aviation colombienne y emploie canonnières et avions d''attaque légers.', 'War between the Colombian state and the FARC and ELN guerrillas, then paramilitary and drug-trafficking groups. Colombia''s air force used gunships and light attack aircraft.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Conflit armé colombien');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Bush rhodésien', 'Rhodesian Bush War', '1964-07-04', '1979-12-12', NULL, 'Guerre entre le gouvernement blanc de Rhodésie et les guérillas nationalistes ZANLA et ZIPRA. L''aviation rhodésienne frappe jusqu''aux camps du Mozambique et de Zambie.', 'War between Rhodesia''s white-minority government and the ZANLA and ZIPRA nationalist guerrillas. The Rhodesian air force struck camps as far as Mozambique and Zambia.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Bush rhodésien');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre indo-pakistanaise de 1965', 'Indo-Pakistani War of 1965', '1965-08-05', '1965-09-23', (SELECT id FROM countries WHERE code = 'PAK'), 'Deuxième guerre entre l''Inde et le Pakistan, née au Cachemire. Les deux aviations s''affrontent pendant trois semaines, notamment dans le duel Gnat contre Sabre.', 'Second war between India and Pakistan, born in Kashmir. Both air forces fought for three weeks, notably in the Gnat-versus-Sabre duel.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre indo-pakistanaise de 1965');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre de la frontière sud-africaine', 'South African Border War', '1966-08-26', '1990-03-21', (SELECT id FROM countries WHERE code = 'ZAF'), 'Guerre menée par l''Afrique du Sud en Namibie et en Angola contre la SWAPO, l''armée angolaise et le corps expéditionnaire cubain. Elle culmine avec la bataille de Cuito Cuanavale (1987-1988).', 'War waged by South Africa in Namibia and Angola against SWAPO, the Angolan army and the Cuban expeditionary force. It peaked at the battle of Cuito Cuanavale (1987-88).'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre de la frontière sud-africaine');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre d''usure', 'War of Attrition', '1967-07-01', '1970-08-07', (SELECT id FROM countries WHERE code = 'EGY'), 'Affrontement entre Israël et l''Égypte, soutenue par l''URSS, le long du canal de Suez après la guerre des Six Jours. Raids profonds israéliens et combats aériens, dont l''embuscade Rimon 20 contre des MiG-21 pilotés par des Soviétiques.', 'Conflict between Israel and Soviet-backed Egypt along the Suez Canal after the Six-Day War. Deep Israeli raids and air battles, including the Rimon 20 ambush of Soviet-flown MiG-21s.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre d''usure');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Biafra', 'Nigerian Civil War', '1967-07-06', '1970-01-15', NULL, 'Guerre de sécession de la province nigériane du Biafra. L''aviation fédérale, équipée de matériel soviétique, bombarde les villes et le pont aérien humanitaire.', 'Secession war of Nigeria''s Biafra region. The Federal air force, equipped with Soviet aircraft, bombed towns and the humanitarian airlift.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Biafra');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Invasion turque de Chypre', 'Turkish invasion of Cyprus', '1974-07-20', '1974-08-18', (SELECT id FROM countries WHERE code = 'TUR'), 'Débarquement turc à Chypre après le coup d''État soutenu par la junte grecque. L''aviation turque appuie les troupes ; la Grèce tente de renforcer l''île par un pont aérien nocturne.', 'Turkish landing on Cyprus after the coup backed by the Greek junta. Turkish air power supported the troops; Greece attempted a night airlift to reinforce the island.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Invasion turque de Chypre');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Sahara occidental', 'Western Sahara War', '1975-10-30', '1991-09-06', NULL, 'Guerre opposant le Front Polisario au Maroc (et à la Mauritanie jusqu''en 1979) pour le contrôle de l''ancien Sahara espagnol. Les missiles sol-air du Polisario infligent des pertes à l''aviation marocaine.', 'War between the Polisario Front and Morocco (and Mauritania until 1979) over former Spanish Sahara. Polisario surface-to-air missiles inflicted losses on Moroccan aviation.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Sahara occidental');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre de l''Ogaden', 'Ogaden War', '1977-07-13', '1978-03-15', NULL, 'Invasion somalienne de l''Ogaden éthiopien, repoussée avec l''aide soviétique et cubaine. Les F-5E éthiopiens y obtiennent la supériorité aérienne face aux MiG somaliens.', 'Somali invasion of Ethiopia''s Ogaden, repelled with Soviet and Cuban help. Ethiopian F-5Es won air superiority over Somali MiGs.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre de l''Ogaden');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Conflit tchado-libyen', 'Chadian–Libyan War', NULL, '1987-09-11', NULL, 'Guerre entre la Libye de Kadhafi et le Tchad, appuyé par la France (opérations Tacaud, Manta puis Épervier). Elle s''achève par la « guerre des Toyota » et la défaite libyenne à Ouadi Doum.', 'War between Gaddafi''s Libya and Chad, backed by France (Operations Tacaud, Manta and Épervier). It ended with the ''Toyota War'' and the Libyan defeat at Ouadi Doum.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Conflit tchado-libyen');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre civile salvadorienne', 'Salvadoran Civil War', '1979-10-15', '1992-01-16', NULL, 'Guerre entre le gouvernement salvadorien, soutenu par les États-Unis, et la guérilla du FMLN, close par les accords de Chapultepec. L''aviation salvadorienne y emploie avions d''attaque légers et canonnières.', 'War between the US-backed Salvadoran government and the FMLN guerrillas, ended by the Chapultepec accords. The Salvadoran air force used light attack aircraft and gunships.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre civile salvadorienne');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre soviéto-afghane', 'Soviet–Afghan War', '1979-12-24', '1989-02-15', (SELECT id FROM countries WHERE code = 'AFG'), 'Intervention de l''URSS en Afghanistan contre les moudjahidines, jusqu''au retrait des troupes soviétiques. Guerre d''appui, de bombardement et de pont aérien, transformée par l''arrivée des Stinger en 1986.', 'Soviet intervention in Afghanistan against the mujahideen, until Soviet troops withdrew. An air war of support, bombing and airlift, transformed by the arrival of Stingers in 1986.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre soviéto-afghane');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre civile du Sri Lanka', 'Sri Lankan Civil War', '1983-07-23', '2009-05-18', NULL, 'Guerre entre l''État sri-lankais et les Tigres de libération de l''Îlam tamoul (LTTE), jusqu''à leur écrasement en 2009. L''aviation sri-lankaise y passe d''avions légers à des chasseurs-bombardiers.', 'War between the Sri Lankan state and the Liberation Tigers of Tamil Eelam (LTTE), until their defeat in 2009. The Sri Lankan air force moved from light aircraft to fighter-bombers.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre civile du Sri Lanka');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Invasion de la Grenade', 'Invasion of Grenada', '1983-10-25', '1983-12-15', NULL, 'Opération Urgent Fury : les États-Unis renversent le régime militaire de la Grenade. Parachutage des Rangers à Point Salines et appui aérien embarqué.', 'Operation Urgent Fury: the United States overthrew Grenada''s military regime. Rangers parachuted onto Point Salines with carrier air support.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Invasion de la Grenade');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Conflit turco-kurde (PKK)', 'Kurdish–Turkish conflict (PKK)', '1984-08-15', '2025-05-12', (SELECT id FROM countries WHERE code = 'TUR'), 'Insurrection du PKK contre l''État turc, étendue au nord de l''Irak et de la Syrie, jusqu''à l''annonce de la dissolution du mouvement. La Turquie y a développé sa doctrine de drones armés.', 'PKK insurgency against the Turkish state, extended into northern Iraq and Syria, until the movement announced its dissolution. Turkey built its armed-drone doctrine there.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Conflit turco-kurde (PKK)');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Invasion du Panama', 'United States invasion of Panama', '1989-12-20', '1990-01-31', NULL, 'Opération Just Cause : les États-Unis renversent le général Noriega. Premier emploi au combat de l''avion furtif F-117 et assauts aéroportés simultanés.', 'Operation Just Cause: the United States overthrew General Noriega. First combat use of the F-117 stealth aircraft and simultaneous airborne assaults.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Invasion du Panama');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Intervention en Somalie', 'UN intervention in Somalia', '1992-12-09', '1995-03-03', NULL, 'Interventions internationales (UNITAF puis ONUSOM II) dans la guerre civile somalienne, marquées par les combats de Mogadiscio en 1993. L''appui aérien et le pont aérien y sont constants.', 'International interventions (UNITAF then UNOSOM II) in the Somali civil war, marked by the 1993 fighting in Mogadishu. Air support and airlift were constant.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Intervention en Somalie');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerres de Tchétchénie', 'Chechen Wars', '1994-12-11', '2009-04-16', NULL, 'Deux guerres russes contre les indépendantistes tchétchènes (1994-1996 et 1999-2009), marquées par le bombardement de Grozny.', 'Two Russian wars against Chechen separatists (1994-96 and 1999-2009), marked by the bombing of Grozny.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerres de Tchétchénie');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Cenepa', 'Cenepa War', '1995-01-26', '1995-02-28', NULL, 'Bref conflit frontalier entre l''Équateur et le Pérou dans la haute vallée du Cenepa. Le 10 février 1995, la chasse équatorienne abat trois appareils péruviens.', 'Short border war between Ecuador and Peru in the upper Cenepa valley. On 10 February 1995 Ecuadorian fighters shot down three Peruvian aircraft.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Cenepa');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre Érythrée-Éthiopie', 'Eritrean–Ethiopian War', '1998-05-06', '2000-06-18', NULL, 'Guerre frontalière entre l''Érythrée et l''Éthiopie, l''une des plus meurtrières de la fin du siècle. Premiers combats entre Su-27 et MiG-29, pilotés pour partie par des mercenaires.', 'Border war between Eritrea and Ethiopia, among the deadliest of the late century. First combat between Su-27s and MiG-29s, partly flown by foreign pilots.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre Érythrée-Éthiopie');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre de Kargil', 'Kargil War', '1999-05-03', '1999-07-26', (SELECT id FROM countries WHERE code = 'IND'), 'Conflit de haute montagne au Cachemire après l''infiltration de troupes pakistanaises au-delà de la ligne de contrôle. L''aviation indienne y frappe des positions à plus de 5 000 mètres (opération Safed Sagar).', 'High-altitude conflict in Kashmir after Pakistani troops crossed the Line of Control. The Indian Air Force struck positions above 5,000 metres (Operation Safed Sagar).'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre de Kargil');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Liban de 2006', '2006 Lebanon War', '2006-07-12', '2006-08-14', (SELECT id FROM countries WHERE code = 'LBN'), 'Guerre de 34 jours entre Israël et le Hezbollah, déclenchée par un enlèvement de soldats. Campagne aérienne israélienne massive sur le Liban.', '34-day war between Israel and Hezbollah, triggered by the abduction of soldiers. Massive Israeli air campaign over Lebanon.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Liban de 2006');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre russo-géorgienne', 'Russo-Georgian War', '2008-08-07', '2008-08-12', NULL, 'Guerre de cinq jours entre la Russie et la Géorgie autour de l''Ossétie du Sud. L''aviation russe y perd plusieurs appareils face à la défense antiaérienne géorgienne.', 'Five-day war between Russia and Georgia over South Ossetia. Russian aviation lost several aircraft to Georgian air defences.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre russo-géorgienne');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Sahel', 'Sahel War', '2012-01-16', NULL, NULL, 'Insurrection jihadiste au Mali puis au Niger et au Burkina Faso, avec les opérations françaises Serval (2013) et Barkhane (2014-2022). Guerre de drones, de frappes et de projection sur de très longues distances.', 'Jihadist insurgency in Mali, then Niger and Burkina Faso, with French Operations Serval (2013) and Barkhane (2014-22). A war of drones, strikes and very long-range projection.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Sahel');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Donbass', 'War in Donbas', '2014-04-06', '2022-02-23', (SELECT id FROM countries WHERE code = 'UKR'), 'Guerre dans l''est de l''Ukraine entre l''armée ukrainienne et les séparatistes soutenus par la Russie, jusqu''à l''invasion de 2022. L''aviation ukrainienne y subit de lourdes pertes en 2014 avant de se retirer du ciel du front.', 'War in eastern Ukraine between the Ukrainian army and Russian-backed separatists, until the 2022 invasion. Ukrainian aviation suffered heavy losses in 2014 before withdrawing from the front.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Donbass');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre civile libyenne (2014-2020)', 'Second Libyan Civil War', '2014-05-16', '2020-10-23', (SELECT id FROM countries WHERE code = 'LBY'), 'Guerre entre les forces du maréchal Haftar et les gouvernements de Tripoli, soutenus de part et d''autre par des puissances étrangères. Premier affrontement entre flottes de drones armés chinois et turcs.', 'War between Marshal Haftar''s forces and the Tripoli governments, each backed by foreign powers. First clash between fleets of Chinese and Turkish armed drones.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre civile libyenne (2014-2020)');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre contre l''État islamique', 'War against the Islamic State', '2014-08-08', NULL, (SELECT id FROM countries WHERE code = 'IRQ'), 'Campagne aérienne de la coalition internationale (Inherent Resolve, Chammal, Shader, Okra) contre l''État islamique en Irak et en Syrie, jusqu''à la chute du califat territorial en 2019. Les frappes en Syrie recoupent la guerre civile syrienne.', 'Air campaign by the international coalition (Inherent Resolve, Chammal, Shader, Okra) against the Islamic State in Iraq and Syria, until the territorial caliphate fell in 2019. Strikes in Syria overlap the Syrian civil war.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre contre l''État islamique');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre civile yéménite', 'Yemeni Civil War', '2014-09-16', NULL, NULL, 'Guerre entre les Houthis et le gouvernement yéménite, élargie en 2015 à l''intervention de la coalition saoudienne, puis aux frappes américaines et britanniques contre les Houthis à partir de 2024.', 'War between the Houthis and Yemen''s government, widened in 2015 by the Saudi-led coalition and from 2024 by US and British strikes on the Houthis.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre civile yéménite');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Siège de Marawi', 'Siege of Marawi', '2017-05-23', '2017-10-23', NULL, 'Bataille de cinq mois entre l''armée philippine et des groupes affiliés à l''État islamique dans la ville de Marawi, sur Mindanao. Premier emploi au combat de l''avion d''armes léger FA-50.', 'Five-month battle between the Philippine army and Islamic State-affiliated groups in the city of Marawi, Mindanao. First combat use of the FA-50 light combat aircraft.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Siège de Marawi');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre du Haut-Karabagh (2020)', 'Second Nagorno-Karabakh War', '2020-09-27', '2020-11-10', NULL, 'Guerre de 44 jours remportée par l''Azerbaïdjan contre les forces arméniennes du Haut-Karabagh. Le premier conflit décidé en grande partie par les drones et les munitions rôdeuses.', '44-day war won by Azerbaijan against Armenian forces in Nagorno-Karabakh. The first conflict decided largely by drones and loitering munitions.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre du Haut-Karabagh (2020)');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre Israël-Hamas', 'Israel–Hamas war', '2023-10-07', NULL, NULL, 'Guerre ouverte par l''attaque du Hamas du 7 octobre 2023 et la campagne militaire israélienne sur la bande de Gaza, la plus longue de l''histoire d''Israël.', 'War opened by Hamas''s attack of 7 October 2023 and Israel''s military campaign over the Gaza Strip, the longest in Israel''s history.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre Israël-Hamas');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Conflit indo-pakistanais de 2025', '2025 India–Pakistan conflict', '2025-05-07', '2025-05-10', (SELECT id FROM countries WHERE code = 'PAK'), 'Affrontement de quatre jours ouvert par les frappes indiennes de l''opération Sindoor, après l''attentat de Pahalgam. Le plus grand combat aérien entre les deux pays depuis 1971, à longue distance de missiles.', 'Four-day clash opened by India''s Operation Sindoor strikes after the Pahalgam attack. The largest air battle between the two countries since 1971, fought at long missile range.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Conflit indo-pakistanais de 2025');
INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en)
SELECT 'Guerre Iran-Israël', 'Iran–Israel war', '2025-06-13', '2025-06-24', (SELECT id FROM countries WHERE code = 'IRN'), 'Guerre de douze jours ouverte par la campagne aérienne israélienne contre les sites nucléaires et militaires iraniens (opération Rising Lion), avec frappes américaines sur Fordo le 22 juin.', 'Twelve-day war opened by Israel''s air campaign against Iranian nuclear and military sites (Operation Rising Lion), with US strikes on Fordow on 22 June.'
WHERE NOT EXISTS (SELECT 1 FROM wars WHERE name = 'Guerre Iran-Israël');

-- Types d'appareils : tout le référentiel. `airplanes.type` est nullable,
-- donc un type absent fait entrer la fiche en base sans type, en silence.
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Chasseur', 'Fighter', 'Avion de combat conçu pour la supériorité aérienne', 'Combat aircraft designed for air superiority'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Chasseur');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Bombardier', 'Bomber', 'Avion militaire destiné à attaquer des cibles au sol', 'Military aircraft designed to attack ground targets'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Bombardier');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Reconnaissance', 'Reconnaissance', 'Avion utilisé pour la surveillance et la collecte d’informations', 'Aircraft used for surveillance and intelligence gathering'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Reconnaissance');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Intercepteur', 'Interceptor', 'Avion rapide conçu pour intercepter et neutraliser les menaces aériennes', 'Fast aircraft designed to intercept and neutralize airborne threats'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Intercepteur');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Multirôle', 'Multirole', 'Avion capable d’effectuer plusieurs types de missions', 'Aircraft capable of performing multiple mission types'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Multirôle');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Appui aérien', 'Close Air Support', 'Avion conçu pour soutenir les troupes au sol avec des frappes ciblées', 'Aircraft designed to support ground troops with precision strikes'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Appui aérien');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Entraîneur', 'Trainer', 'Avion d''entraînement conçu pour la formation des pilotes militaires', 'Aircraft designed for the training of military pilots'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Entraîneur');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Guerre électronique', 'Electronic Warfare', 'Avion dédié au brouillage et à la neutralisation des systèmes électroniques adverses', 'Aircraft dedicated to jamming and neutralising enemy electronic systems'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Guerre électronique');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Drone de combat', 'Combat Drone', 'Aéronef de combat sans équipage embarqué, piloté à distance ou autonome', 'Combat aircraft without an onboard crew, remotely piloted or autonomous'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Drone de combat');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Transport', 'Transport', 'Aéronef dédié au transport de troupes, de fret ou de matériel lourd', 'Aircraft dedicated to carrying troops, freight or heavy equipment'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Transport');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Ravitailleur', 'Tanker', 'Aéronef dédié au ravitaillement en vol, prolongeant l’allonge des autres appareils', 'Aircraft dedicated to aerial refuelling, extending the reach of other aircraft'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Ravitailleur');
INSERT INTO type (name, name_en, description, description_en)
SELECT 'Recherche', 'Research', 'Aéronef expérimental dédié à l''étude d''un concept, sans vocation opérationnelle', 'Experimental aircraft dedicated to studying a concept, with no operational role'
WHERE NOT EXISTS (SELECT 1 FROM type WHERE name = 'Recherche');

-- Missions : tout le référentiel. `airplane_missions` est NOT NULL, donc
-- une mission absente fait échouer l'INSERT et perdre la fin du fichier.
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Supériorité aérienne', NULL, 'Contrôle de l’espace aérien par l’élimination des menaces ennemies.', NULL
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Supériorité aérienne');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Interception', 'Interception', 'Engagement rapide d’avions ennemis pour protéger l’espace aérien.', 'Rapid engagement of enemy aircraft to protect airspace.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Interception');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Frappe stratégique', 'Strategic Strike', 'Attaques de précision sur des cibles stratégiques à longue portée.', 'Precision attacks on long-range strategic targets.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Frappe stratégique');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Frappe tactique', 'Tactical Strike', 'Attaques ciblées sur des objectifs militaires au sol pour soutenir les opérations immédiates.', 'Targeted attacks on ground military objectives to support immediate operations.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Frappe tactique');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Appui aérien rapproché', 'Close Air Support', 'Soutien direct aux troupes au sol avec des frappes précises.', 'Direct support to ground troops with precision strikes.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Appui aérien rapproché');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Reconnaissance armée', 'Armed Reconnaissance', 'Surveillance avec capacité d’engagement en cas de menace détectée.', 'Surveillance with engagement capability if threats are detected.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Reconnaissance armée');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Reconnaissance stratégique', 'Strategic Reconnaissance', 'Collecte d’informations sur des zones ou cibles éloignées sans engagement.', 'Intelligence gathering on distant zones or targets without engagement.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Reconnaissance stratégique');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Guerre électronique', 'Electronic Warfare', 'Perturbation des systèmes ennemis via brouillage ou attaques électroniques.', 'Disruption of enemy systems via jamming or electronic attacks.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Guerre électronique');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Patrouille aérienne de combat', 'Combat Air Patrol', 'Surveillance prolongée et défense proactive de l’espace aérien.', 'Prolonged surveillance and proactive airspace defense.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Patrouille aérienne de combat');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Attaque antinavire', 'Anti-ship Attack', 'Engagement de navires ennemis avec des missiles ou des bombes spécialisées.', 'Engagement of enemy ships with specialized missiles or bombs.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Attaque antinavire');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Suppression des défenses aériennes ennemies', 'Suppression of Enemy Air Defenses', 'Destruction ou neutralisation des systèmes antiaériens ennemis.', 'Destruction or neutralization of enemy anti-aircraft systems.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Suppression des défenses aériennes ennemies');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Largage de secours', 'Supply Drop', 'Livraison de matériel ou de provisions dans des zones difficiles d’accès.', 'Delivery of equipment or supplies to hard-to-reach areas.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Largage de secours');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Escorte', 'Escort', 'Protection d’autres aéronefs (bombardiers, transports) contre les menaces aériennes.', 'Protection of other aircraft (bombers, transports) against air threats.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Escorte');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Entraînement au combat', 'Combat Training', 'Simulation de missions pour préparer les pilotes au combat réel.', 'Mission simulation to prepare pilots for real combat.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Entraînement au combat');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Dissuasion nucléaire', 'Nuclear Deterrence', 'Transport et éventuel largage d’armes nucléaires pour des missions stratégiques.', 'Carriage and potential release of nuclear weapons for strategic missions.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Dissuasion nucléaire');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Transport logistique', 'Logistic Transport', 'Acheminement de troupes, de fret et de matériel entre bases ou vers un théâtre d’opérations.', 'Movement of troops, freight and equipment between bases or into a theatre of operations.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Transport logistique');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Ravitaillement en vol', 'Aerial Refuelling', 'Transfert de carburant en vol vers d’autres aéronefs, prolongeant leur autonomie et leur temps sur zone.', 'In-flight fuel transfer to other aircraft, extending their range and time on station.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Ravitaillement en vol');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Largage de troupes', 'Paratroop Drop', 'Mise à terre de parachutistes et de charges par largage, y compris à très basse altitude.', 'Delivery of paratroops and loads by air drop, including at very low level.'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Largage de troupes');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Essais en vol', 'Flight testing', 'Évaluation en vol d''un appareil ou d''une technologie', 'In-flight evaluation of an aircraft or a technology'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Essais en vol');
INSERT INTO missions (name, name_en, description, description_en)
SELECT 'Reconnaissance tactique', 'Tactical reconnaissance', 'Observation du champ de bataille au profit des forces engagées', 'Battlefield observation in support of engaged forces'
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE name = 'Reconnaissance tactique');

-- Constructeurs partagés par plusieurs fiches
-- Constructeurs : tout le référentiel. Une fiche qui référence un constructeur
-- absent entre en base avec id_manufacturer = NULL, sans erreur — d'où l'exhaustivité.
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Lockheed Martin', 'Lockheed Martin', (SELECT id FROM countries WHERE code = 'USA'), 'LM'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'LM');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Boeing', 'Boeing', (SELECT id FROM countries WHERE code = 'USA'), 'BOE'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BOE');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Sukhoi', 'Sukhoi', (SELECT id FROM countries WHERE code = 'RUS'), 'SUK'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SUK');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Mikoyan (MiG)', 'Mikoyan (MiG)', (SELECT id FROM countries WHERE code = 'RUS'), 'MIG'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'MIG');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Tupolev', 'Tupolev', (SELECT id FROM countries WHERE code = 'RUS'), 'TUP'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'TUP');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Chengdu Aerospace Corporation', 'Chengdu Aerospace Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'CAC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CAC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Shenyang Aircraft Corporation', 'Shenyang Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'SAC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SAC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Dassault Aviation', 'Dassault Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'DAS'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'DAS');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'BAE Systems', 'BAE Systems', (SELECT id FROM countries WHERE code = 'GBR'), 'BAE'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BAE');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Airbus Defence and Space', 'Airbus Defence and Space', (SELECT id FROM countries WHERE code = 'DEU'), 'ADS'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ADS');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Leonardo S.p.A.', 'Leonardo S.p.A.', (SELECT id FROM countries WHERE code = 'ITA'), 'LEO'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'LEO');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Saab AB', 'Saab AB', (SELECT id FROM countries WHERE code = 'SWE'), 'SAAB'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SAAB');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'HAL (Hindustan Aeronautics Limited)', 'HAL (Hindustan Aeronautics Limited)', (SELECT id FROM countries WHERE code = 'IND'), 'HAL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HAL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Mitsubishi Heavy Industries', 'Mitsubishi Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'MHI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'MHI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Embraer', 'Embraer', (SELECT id FROM countries WHERE code = 'BRA'), 'EMB'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'EMB');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'IAI (Israel Aerospace Industries)', 'IAI (Israel Aerospace Industries)', (SELECT id FROM countries WHERE code = 'ISR'), 'IAI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'IAI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Convair', 'Convair', (SELECT id FROM countries WHERE code = 'USA'), 'CVR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CVR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Grumman', 'Grumman', (SELECT id FROM countries WHERE code = 'USA'), 'GRU'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'GRU');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'English Electric', 'English Electric', (SELECT id FROM countries WHERE code = 'GBR'), 'EE'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'EE');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Vought', 'Vought', (SELECT id FROM countries WHERE code = 'USA'), 'VOU'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'VOU');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Korea Aerospace Industries', 'Korea Aerospace Industries', (SELECT id FROM countries WHERE code = 'ROK'), 'KAI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'KAI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Aero Vodochody', 'Aero Vodochody', (SELECT id FROM countries WHERE code = 'CSK'), 'AERO'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'AERO');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'AIDC (Aerospace Industrial Development Corporation)', 'AIDC (Aerospace Industrial Development Corporation)', (SELECT id FROM countries WHERE code = 'TWN'), 'AIDC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'AIDC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'British Aircraft Corporation', 'British Aircraft Corporation', (SELECT id FROM countries WHERE code = 'GBR'), 'BAC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BAC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Baykar', 'Baykar', (SELECT id FROM countries WHERE code = 'TUR'), 'BAY'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BAY');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'CASA (Construcciones Aeronáuticas SA)', 'CASA (Construcciones Aeronáuticas SA)', (SELECT id FROM countries WHERE code = 'ESP'), 'CASA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CASA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'de Havilland', 'de Havilland', (SELECT id FROM countries WHERE code = 'GBR'), 'DH'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'DH');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Douglas Aircraft Company', 'Douglas Aircraft Company', (SELECT id FROM countries WHERE code = 'USA'), 'DOU'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'DOU');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Fiat Aviazione', 'Fiat Aviazione', (SELECT id FROM countries WHERE code = 'ITA'), 'FIAT'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FIAT');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'General Atomics', 'General Atomics', (SELECT id FROM countries WHERE code = 'USA'), 'GA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'GA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Gloster Aircraft Company', 'Gloster Aircraft Company', (SELECT id FROM countries WHERE code = 'GBR'), 'GLO'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'GLO');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'HESA (Iran Aircraft Manufacturing Industrial Company)', 'HESA (Iran Aircraft Manufacturing Industrial Company)', (SELECT id FROM countries WHERE code = 'IRN'), 'HESA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HESA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Hongdu Aviation Industry', 'Hongdu Aviation Industry', (SELECT id FROM countries WHERE code = 'CHN'), 'HONG'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HONG');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Handley Page', 'Handley Page', (SELECT id FROM countries WHERE code = 'GBR'), 'HP'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HP');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Hawker Siddeley', 'Hawker Siddeley', (SELECT id FROM countries WHERE code = 'GBR'), 'HS'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HS');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Iliouchine', 'Ilyushin', (SELECT id FROM countries WHERE code = 'RUS'), 'ILY'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ILY');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Kawasaki Heavy Industries', 'Kawasaki Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'KHI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'KHI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Ling-Temco-Vought', 'Ling-Temco-Vought', (SELECT id FROM countries WHERE code = 'USA'), 'LTV'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'LTV');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'McDonnell Douglas', 'McDonnell Douglas', (SELECT id FROM countries WHERE code = 'USA'), 'MDD'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'MDD');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'North American Aviation', 'North American Aviation', (SELECT id FROM countries WHERE code = 'USA'), 'NAA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'NAA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Nanchang Aircraft Corporation', 'Nanchang Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'NAMC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'NAMC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Northrop', 'Northrop', (SELECT id FROM countries WHERE code = 'USA'), 'NOR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'NOR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'PZL-Mielec', 'PZL-Mielec', (SELECT id FROM countries WHERE code = 'POL'), 'PZL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'PZL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Republic Aviation', 'Republic Aviation', (SELECT id FROM countries WHERE code = 'USA'), 'REP'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'REP');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Soko', 'Soko', (SELECT id FROM countries WHERE code = 'YUG'), 'SOKO'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SOKO');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Sud Aviation', 'Sud Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'SUD'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SUD');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Supermarine', 'Supermarine', (SELECT id FROM countries WHERE code = 'GBR'), 'SUP'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SUP');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Xian Aircraft Corporation', 'Xian Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'XAC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'XAC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Yakovlev', 'Yakovlev', (SELECT id FROM countries WHERE code = 'RUS'), 'YAK'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'YAK');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Vickers-Armstrongs', 'Vickers-Armstrongs', (SELECT id FROM countries WHERE code = 'GBR'), 'VIC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'VIC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Folland Aircraft', 'Folland Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'FOL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FOL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Fouga', 'Fouga', (SELECT id FROM countries WHERE code = 'FRA'), 'FOU'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FOU');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Myasishchev', 'Myasishchev', (SELECT id FROM countries WHERE code = 'RUS'), 'MYA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'MYA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'North American Rockwell', 'North American Rockwell', (SELECT id FROM countries WHERE code = 'USA'), 'ROC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ROC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Cessna', 'Cessna', (SELECT id FROM countries WHERE code = 'USA'), 'CES'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CES');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Atlas Aircraft Corporation', 'Atlas Aircraft Corporation', (SELECT id FROM countries WHERE code = 'ZAF'), 'ATL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ATL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'FMA (Fábrica Militar de Aviones)', 'FMA (Fábrica Militar de Aviones)', (SELECT id FROM countries WHERE code = 'ARG'), 'FMA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FMA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Pilatus Aircraft', 'Pilatus Aircraft', (SELECT id FROM countries WHERE code = 'CHE'), 'PIL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'PIL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'TAI (Turkish Aerospace Industries)', 'TAI (Turkish Aerospace Industries)', (SELECT id FROM countries WHERE code = 'TUR'), 'TAI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'TAI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Beriev', 'Beriev', (SELECT id FROM countries WHERE code = 'RUS'), 'BER'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BER');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Breguet Aviation', 'Breguet Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'BRG'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BRG');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Avro Canada', 'Avro Canada', (SELECT id FROM countries WHERE code = 'CAN'), 'AVC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'AVC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Fairey Aviation', 'Fairey Aviation', (SELECT id FROM countries WHERE code = 'GBR'), 'FAI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FAI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'IAR (Industria Aeronautică Română)', 'IAR (Industria Aeronautică Română)', (SELECT id FROM countries WHERE code = 'ROU'), 'IAR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'IAR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Avro (A.V. Roe)', 'Avro (A.V. Roe)', (SELECT id FROM countries WHERE code = 'GBR'), 'AVR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'AVR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'CAC (Commonwealth Aircraft Corporation)', 'CAC (Commonwealth Aircraft Corporation)', (SELECT id FROM countries WHERE code = 'AUS'), 'CWA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CWA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Helwan Aircraft Factory', 'Helwan Aircraft Factory', (SELECT id FROM countries WHERE code = 'EGY'), 'HEL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HEL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Antonov', 'Antonov', (SELECT id FROM countries WHERE code = 'UKR'), 'ANT'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ANT');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Transall', 'Transall', (SELECT id FROM countries WHERE code = 'FRA'), 'TRA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'TRA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'de Havilland Canada', 'de Havilland Canada', (SELECT id FROM countries WHERE code = 'CAN'), 'DHC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'DHC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Fairchild Aircraft', 'Fairchild Aircraft', (SELECT id FROM countries WHERE code = 'USA'), 'FRC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FRC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Westland Aircraft', 'Westland Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'WES'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'WES');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Nord Aviation', 'Nord Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'NRD'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'NRD');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Lavochkine', 'Lavochkin', (SELECT id FROM countries WHERE code = 'RUS'), 'LAV'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'LAV');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Saunders-Roe', 'Saunders-Roe', (SELECT id FROM countries WHERE code = 'GBR'), 'SRO'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SRO');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'FFA (Flug- und Fahrzeugwerke Altenrhein)', 'FFA (Flug- und Fahrzeugwerke Altenrhein)', (SELECT id FROM countries WHERE code = 'CHE'), 'FFA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FFA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Hispano Aviación', 'Hispano Aviación', (SELECT id FROM countries WHERE code = 'ESP'), 'HSP'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HSP');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Dornier', 'Dornier', (SELECT id FROM countries WHERE code = 'DEU'), 'DOR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'DOR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'EWR (Entwicklungsring Süd)', 'EWR (Entwicklungsring Süd)', (SELECT id FROM countries WHERE code = 'DEU'), 'EWR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'EWR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'VFW (Vereinigte Flugtechnische Werke)', 'VFW (Vereinigte Flugtechnische Werke)', (SELECT id FROM countries WHERE code = 'DEU'), 'VFW'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'VFW');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Ryan Aeronautical', 'Ryan Aeronautical', (SELECT id FROM countries WHERE code = 'USA'), 'RYA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'RYA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Bell Aircraft', 'Bell Aircraft', (SELECT id FROM countries WHERE code = 'USA'), 'BEL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BEL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Short Brothers', 'Short Brothers', (SELECT id FROM countries WHERE code = 'GBR'), 'SHO'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SHO');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Hawker Aircraft', 'Hawker Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'HAW'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HAW');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'General Dynamics', 'General Dynamics', (SELECT id FROM countries WHERE code = 'USA'), 'GD'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'GD');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Fokker', 'Fokker', (SELECT id FROM countries WHERE code = 'NLD'), 'FOK'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FOK');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Valmet', 'Valmet', (SELECT id FROM countries WHERE code = 'FIN'), 'VAL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'VAL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'ENAER (Empresa Nacional de Aeronáutica de Chile)', 'ENAER (Empresa Nacional de Aeronáutica de Chile)', (SELECT id FROM countries WHERE code = 'CHL'), 'ENA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ENA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'SIAI-Marchetti', 'SIAI-Marchetti', (SELECT id FROM countries WHERE code = 'ITA'), 'SIAI'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SIAI');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Hunting Aircraft', 'Hunting Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'HUN'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HUN');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Beechcraft', 'Beechcraft', (SELECT id FROM countries WHERE code = 'USA'), 'BEE'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BEE');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'PZL Warszawa-Okęcie', 'PZL Warszawa-Okęcie', (SELECT id FROM countries WHERE code = 'POL'), 'PZLW'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'PZLW');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Kratos Defense', 'Kratos Defense', (SELECT id FROM countries WHERE code = 'USA'), 'KRA'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'KRA');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Elbit Systems', 'Elbit Systems', (SELECT id FROM countries WHERE code = 'ISR'), 'ELB'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'ELB');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'ShinMaywa', 'ShinMaywa', (SELECT id FROM countries WHERE code = 'JPN'), 'SHM'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SHM');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Fuji Heavy Industries', 'Fuji Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'FUJ'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'FUJ');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Shaanxi Aircraft Corporation', 'Shaanxi Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'SHX'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SHX');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Guizhou Aircraft Industry', 'Guizhou Aircraft Industry', (SELECT id FROM countries WHERE code = 'CHN'), 'GAIC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'GAIC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'IPTN (Industri Pesawat Terbang Nusantara)', 'IPTN (Industri Pesawat Terbang Nusantara)', (SELECT id FROM countries WHERE code = 'IDN'), 'IPTN'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'IPTN');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Canadair', 'Canadair', (SELECT id FROM countries WHERE code = 'CAN'), 'CDR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CDR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'GAF (Government Aircraft Factories)', 'GAF (Government Aircraft Factories)', (SELECT id FROM countries WHERE code = 'AUS'), 'GAF'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'GAF');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Aeritalia', 'Aeritalia', (SELECT id FROM countries WHERE code = 'ITA'), 'AIT'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'AIT');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Let Kunovice', 'Let Kunovice', (SELECT id FROM countries WHERE code = 'CSK'), 'LET'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'LET');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'HFB (Hamburger Flugzeugbau)', 'HFB (Hamburger Flugzeugbau)', (SELECT id FROM countries WHERE code = 'DEU'), 'HFB'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'HFB');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'PAC (Pakistan Aeronautical Complex)', 'PAC (Pakistan Aeronautical Complex)', (SELECT id FROM countries WHERE code = 'PAK'), 'PAC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'PAC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'SOCATA', 'SOCATA', (SELECT id FROM countries WHERE code = 'FRA'), 'SOC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SOC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Scottish Aviation', 'Scottish Aviation', (SELECT id FROM countries WHERE code = 'GBR'), 'SAL'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'SAL');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Britten-Norman', 'Britten-Norman', (SELECT id FROM countries WHERE code = 'GBR'), 'BN'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'BN');

-- Armements référencés par les fiches mais absents du jeu initial. Leur
-- absence faisait échouer silencieusement des INSERT airplane_armement.
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'DEFA 552', NULL, 'Canon de 30 mm, 125 coups par canon', '30 mm cannon, 125 rounds per gun'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'DEFA 552');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'DEFA 553', NULL, 'Canon de 30 mm, 135-150 coups par canon', '30 mm cannon, 135-150 rounds per gun'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'DEFA 553');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'DEFA 554', NULL, 'Canon de 30 mm amélioré, 125 coups par canon', 'Improved 30 mm cannon, 125 rounds per gun'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'DEFA 554');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GIAT 30M791', NULL, 'Canon de 30 mm, 125 coups', '30 mm cannon, 125 rounds'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GIAT 30M791');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Colt Mk 12', NULL, 'Canon de 20 mm, 125 coups par canon', '20 mm cannon, 125 rounds per gun'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Colt Mk 12');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'M61 Vulcan', NULL, 'Canon rotatif 20 mm, 6000 coups/min', '20 mm rotary cannon, 6000 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'M61 Vulcan');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GAU-8 Avenger', NULL, 'Canon rotatif 30 mm, 3900 coups/min', '30 mm rotary cannon, 3900 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GAU-8 Avenger');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GSh-23', NULL, 'Canon double de 23 mm, 3400 coups/min', '23 mm twin cannon, 3400 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GSh-23');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GSh-30-1', NULL, 'Canon de 30 mm, 1500 coups/min', '30 mm cannon, 1500 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GSh-30-1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GSh-30-2', NULL, 'Canon double de 30 mm, 3000 coups/min', '30 mm twin cannon, 3000 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GSh-30-2');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'NR-30', NULL, 'Canon de 30 mm, 850 coups/min', '30 mm cannon, 850 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'NR-30');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GSh-6-23', NULL, 'Canon rotatif 23 mm, 6000 coups/min', '23 mm rotary cannon, 6000 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GSh-6-23');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ADEN 30 mm', NULL, 'Canon de 30 mm, 1300 coups/min', '30 mm cannon, 1300 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ADEN 30 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GAU-12 Equalizer', NULL, 'Canon rotatif 25 mm, 3600 coups/min', '25 mm rotary cannon, 3600 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GAU-12 Equalizer');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Mauser BK-27', NULL, 'Canon de 27 mm, 1700 coups/min', '27 mm cannon, 1700 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Mauser BK-27');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'JM61A1', NULL, 'Variante japonaise du M61 Vulcan', 'Japanese variant of the M61 Vulcan'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'JM61A1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'M39', NULL, 'Canon de 20 mm', '20 mm cannon'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'M39');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Matra R530', NULL, 'Missile moyenne portée, guidage radar semi-actif ou infrarouge', 'Medium-range missile, semi-active radar or infrared guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Matra R530');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Matra R550 Magic', NULL, 'Missile courte portée, guidage infrarouge', 'Short-range missile, infrared guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Matra R550 Magic');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Matra Super 530F', NULL, 'Missile moyenne portée, guidage radar semi-actif', 'Medium-range missile, semi-active radar guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Matra Super 530F');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Matra Super 530D', NULL, 'Missile moyenne portée, guidage radar semi-actif', 'Medium-range missile, semi-active radar guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Matra Super 530D');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'MICA IR', NULL, 'Missile air-air à guidage infrarouge, portée 80 km', 'Infrared-guided air-to-air missile, 80 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'MICA IR');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'MICA EM', NULL, 'Missile air-air à guidage radar actif, portée 80 km', 'Active radar-guided air-to-air missile, 80 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'MICA EM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Meteor', NULL, 'Missile air-air longue portée, guidage radar actif, 100-150 km', 'Long-range air-to-air missile, active radar guidance, 100-150 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Meteor');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AIM-9 Sidewinder', NULL, 'Missile air-air courte portée, guidage infrarouge, 18 km', 'Short-range air-to-air missile, infrared guidance, 18 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AIM-9 Sidewinder');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AIM-7 Sparrow', NULL, 'Missile moyenne portée, guidage radar semi-actif, 70 km', 'Medium-range missile, semi-active radar guidance, 70 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AIM-7 Sparrow');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AIM-54 Phoenix', NULL, 'Missile longue portée, guidage radar actif, 190 km', 'Long-range missile, active radar guidance, 190 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AIM-54 Phoenix');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AIM-120 AMRAAM', NULL, 'Missile moyenne/longue portée, guidage radar actif, 120 km', 'Medium/long-range missile, active radar guidance, 120 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AIM-120 AMRAAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-3S', NULL, 'Missile courte portée, guidage infrarouge, 8 km', 'Short-range missile, infrared guidance, 8 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-3S');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-13M', NULL, 'Missile courte portée, guidage infrarouge, 15 km', 'Short-range missile, infrared guidance, 15 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-13M');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-23R', NULL, 'Missile moyenne portée, guidage radar semi-actif, 35 km', 'Medium-range missile, semi-active radar guidance, 35 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-23R');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-23T', NULL, 'Missile moyenne portée, guidage infrarouge, 35 km', 'Medium-range missile, infrared guidance, 35 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-23T');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-24R', NULL, 'Missile moyenne portée, guidage radar semi-actif, 50 km', 'Medium-range missile, semi-active radar guidance, 50 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-24R');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-24T', NULL, 'Missile moyenne portée, guidage infrarouge, 50 km', 'Medium-range missile, infrared guidance, 50 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-24T');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-27R', NULL, 'Missile moyenne portée, guidage radar semi-actif, 80 km', 'Medium-range missile, semi-active radar guidance, 80 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-27R');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-27T', NULL, 'Missile moyenne portée, guidage infrarouge, 70 km', 'Medium-range missile, infrared guidance, 70 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-27T');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-33', NULL, 'Missile longue portée, guidage radar semi-actif, 120 km', 'Long-range missile, semi-active radar guidance, 120 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-33');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-37', NULL, 'Missile très longue portée, guidage radar actif, 300 km', 'Very long-range missile, active radar guidance, 300 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-37');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-40R', NULL, 'Missile longue portée, guidage radar semi-actif, 80 km', 'Long-range missile, semi-active radar guidance, 80 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-40R');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-40T', NULL, 'Missile longue portée, guidage infrarouge, 80 km', 'Long-range missile, infrared guidance, 80 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-40T');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-60', NULL, 'Missile courte portée, guidage infrarouge, 8 km', 'Short-range missile, infrared guidance, 8 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-60');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-73', NULL, 'Missile courte portée, guidage infrarouge, 30 km', 'Short-range missile, infrared guidance, 30 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-73');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-77', NULL, 'Missile moyenne/longue portée, guidage radar actif, 110 km', 'Medium/long-range missile, active radar guidance, 110 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-77');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Firestreak', NULL, 'Missile courte portée, guidage infrarouge, 15 km', 'Short-range missile, infrared guidance, 15 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Firestreak');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Red Top', NULL, 'Missile courte portée, guidage infrarouge, 12 km', 'Short-range missile, infrared guidance, 12 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Red Top');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Skyflash', NULL, 'Missile moyenne portée, guidage radar semi-actif, 45 km', 'Medium-range missile, semi-active radar guidance, 45 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Skyflash');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ASRAAM', NULL, 'Missile courte portée, guidage infrarouge, 50 km', 'Short-range missile, infrared guidance, 50 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ASRAAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Python 3', NULL, 'Missile courte portée, guidage infrarouge, 15 km', 'Short-range missile, infrared guidance, 15 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Python 3');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Python 4', NULL, 'Missile courte portée, guidage infrarouge, 20 km', 'Short-range missile, infrared guidance, 20 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Python 4');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Python 5', NULL, 'Missile courte portée, guidage infrarouge, 20 km, haute manœuvrabilité', 'Short-range missile, infrared guidance, 20 km, high maneuverability'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Python 5');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Derby', NULL, 'Missile moyenne portée, guidage radar actif, 50 km', 'Medium-range missile, active radar guidance, 50 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Derby');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AAM-3', NULL, 'Missile courte portée, guidage infrarouge', 'Short-range missile, infrared guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AAM-3');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AAM-4', NULL, 'Missile moyenne/longue portée, guidage radar actif', 'Medium/long-range missile, active radar guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AAM-4');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AAM-5', NULL, 'Missile courte portée, guidage infrarouge', 'Short-range missile, infrared guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AAM-5');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'IRIS-T', NULL, 'Missile courte portée, guidage infrarouge, 25 km', 'Short-range missile, infrared guidance, 25 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'IRIS-T');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'PL-2', NULL, 'Missile air-air courte portée, guidage infrarouge, 8 km', 'Short-range air-to-air missile, infrared guidance, 8 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'PL-2');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'PL-5', NULL, 'Missile air-air courte portée, guidage infrarouge, 16-20 km', 'Short-range air-to-air missile, infrared guidance, 16-20 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'PL-5');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'PL-8', NULL, 'Missile air-air courte portée, guidage infrarouge, 20 km', 'Short-range air-to-air missile, infrared guidance, 20 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'PL-8');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'PL-12', NULL, 'Missile air-air moyenne/longue portée, guidage radar actif, 70-100 km', 'Medium/long-range air-to-air missile, active radar guidance, 70-100 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'PL-12');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AS-30', NULL, 'Missile air-sol, guidage radio', 'Air-to-surface missile, radio guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AS-30');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AS-30L', NULL, 'Missile air-sol, guidage laser, portée 11 km', 'Air-to-surface missile, laser guidance, 11 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AS-30L');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AS-37 Martel', NULL, 'Missile air-sol anti-radar ou guidage TV, portée 60 km', 'Anti-radar or TV-guided air-to-surface missile, 60 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AS-37 Martel');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Apache', NULL, 'Missile de croisière anti-piste, portée 140 km', 'Anti-runway cruise missile, 140 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Apache');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'SCALP EG', NULL, 'Missile de croisière, portée 500 km', 'Cruise missile, 500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'SCALP EG');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-65 Maverick', NULL, 'Missile air-sol à guidage optique/TV, portée 27 km', 'Optical/TV-guided air-to-surface missile, 27 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-65 Maverick');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AASM Hammer', NULL, 'Bombe guidée avec kit de propulsion, portée 70 km', 'Guided bomb with propulsion kit, 70 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AASM Hammer');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AS-20', NULL, 'Missile air-sol, guidage radio, portée 7 km', 'Air-to-surface missile, radio guidance, 7 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AS-20');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-12 Bullpup', NULL, 'Missile air-sol, guidage radio, 10 km', 'Air-to-surface missile, radio guidance, 10 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-12 Bullpup');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-45 Shrike', NULL, 'Missile anti-radar, portée 40 km', 'Anti-radar missile, 40 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-45 Shrike');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-78 Standard ARM', NULL, 'Missile anti-radar, portée 90 km', 'Anti-radar missile, 90 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-78 Standard ARM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-84 Harpoon', NULL, 'Missile antinavire, portée 124 km', 'Anti-ship missile, 124 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-84 Harpoon');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-86 ALCM', NULL, 'Missile de croisière à lancement aérien, portée 2400 km', 'Air-launched cruise missile, 2400 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-86 ALCM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-88 HARM', NULL, 'Missile anti-radar, portée 150 km', 'Anti-radar missile, 150 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-88 HARM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-114 Hellfire', NULL, 'Missile air-sol, guidage laser, 8 km', 'Air-to-surface missile, laser guidance, 8 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-114 Hellfire');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-130', NULL, 'Missile air-sol guidé, portée 64 km', 'Guided air-to-surface missile, 64 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-130');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-154 JSOW', NULL, 'Arme stand-off, guidage GPS/INS, 130 km', 'Stand-off weapon, GPS/INS guidance, 130 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-154 JSOW');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-158 JASSM', NULL, 'Missile de croisière furtif, portée 370-1000 km', 'Stealth cruise missile, 370-1000 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-158 JASSM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-23', NULL, 'Missile air-sol, guidage radio, 10 km', 'Air-to-surface missile, radio guidance, 10 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-23');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-25ML', NULL, 'Missile air-sol, guidage laser, 20 km', 'Air-to-surface missile, laser guidance, 20 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-25ML');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-29L', NULL, 'Missile air-sol, guidage laser, 30 km', 'Air-to-surface missile, laser guidance, 30 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-29L');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-29T', NULL, 'Missile air-sol, guidage TV, 30 km', 'Air-to-surface missile, TV guidance, 30 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-29T');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-31P', NULL, 'Missile anti-radar, portée 110 km', 'Anti-radar missile, 110 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-31P');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-31A', NULL, 'Missile antinavire, portée 110 km', 'Anti-ship missile, 110 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-31A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-35', NULL, 'Missile antinavire, portée 130 km', 'Anti-ship missile, 130 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-35');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-58', NULL, 'Missile anti-radar, portée 120 km', 'Anti-radar missile, 120 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-58');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-59', NULL, 'Missile air-sol, guidage TV, 115 km', 'Air-to-surface missile, TV guidance, 115 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-59');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-66', NULL, 'Missile air-sol, guidage radio, 10 km', 'Air-to-surface missile, radio guidance, 10 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-66');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'S-25L', NULL, 'Roquette guidée laser, 340 mm', '340 mm laser-guided rocket'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'S-25L');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Martel AJ-168', NULL, 'Missile air-sol, guidage TV, 60 km', 'Air-to-surface missile, TV guidance, 60 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Martel AJ-168');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Martel AS-37', NULL, 'Missile anti-radar, portée 60 km', 'Anti-radar missile, 60 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Martel AS-37');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Brimstone', NULL, 'Missile air-sol, guidage radar/laser, 60 km', 'Air-to-surface missile, radar/laser guidance, 60 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Brimstone');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Storm Shadow', NULL, 'Missile de croisière, portée 560 km', 'Cruise missile, 560 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Storm Shadow');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'MAR-1', NULL, 'Missile anti-radar, portée 60 km', 'Anti-radar missile, 60 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'MAR-1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Popeye', NULL, 'Missile air-sol, guidage TV, portée 78 km', 'Air-to-surface missile, TV guidance, 78 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Popeye');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Spice', NULL, 'Bombe guidée avec kit de propulsion, portée 60-100 km', 'Guided bomb with propulsion kit, 60-100 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Spice');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AM39 Exocet', NULL, 'Missile antinavire, portée 70 km', 'Anti-ship missile, 70 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AM39 Exocet');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Sea Eagle', NULL, 'Missile antinavire, portée 110 km', 'Anti-ship missile, 110 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Sea Eagle');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Sea Skua', NULL, 'Missile antinavire léger, portée 25 km', 'Light anti-ship missile, 25 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Sea Skua');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Gabriel', NULL, 'Missile antinavire, portée 36 km', 'Anti-ship missile, 36 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Gabriel');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ASM-1', NULL, 'Missile antinavire, guidage radar actif, portée 50 km', 'Anti-ship missile, active radar guidance, 50 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ASM-1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ASM-2', NULL, 'Missile antinavire, guidage radar actif, portée 100 km', 'Anti-ship missile, active radar guidance, 100 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ASM-2');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Marte Mk2A', NULL, 'Missile antinavire, portée 30 km', 'Anti-ship missile, 30 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Marte Mk2A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-32', NULL, 'Missile antinavire supersonique, portée 600-1000 km', 'Supersonic anti-ship missile, 600-1000 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-32');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-35U', NULL, 'Missile antinavire subsonique, portée 260 km', 'Subsonic anti-ship missile, 260 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-35U');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-20', NULL, 'Missile de croisière nucléaire, portée 600 km', 'Nuclear cruise missile, 600 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-20');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-22', NULL, 'Missile antinavire supersonique, portée 600 km', 'Supersonic anti-ship missile, 600 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-22');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-55', NULL, 'Missile de croisière subsonique, portée 2500 km', 'Subsonic cruise missile, 2500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-55');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-65', NULL, 'Missile de croisière conventionnel, portée 500 km', 'Conventional cruise missile, 500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-65');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-101', NULL, 'Missile de croisière furtif conventionnel, portée 4500-5500 km', 'Conventional stealth cruise missile, 4500-5500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-101');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-102', NULL, 'Missile de croisière furtif nucléaire, portée 4500-5500 km', 'Nuclear stealth cruise missile, 4500-5500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-102');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-555', NULL, 'Missile de croisière conventionnel, portée 2500 km', 'Conventional cruise missile, 2500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-555');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AN-11', NULL, 'Bombe nucléaire à chute libre', 'Free-fall nuclear bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AN-11');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AN-22', NULL, 'Bombe nucléaire à chute libre', 'Free-fall nuclear bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AN-22');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AGM-69 SRAM', NULL, 'Missile nucléaire à courte portée, portée 170 km', 'Short-range nuclear missile, 170 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AGM-69 SRAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ASMP', NULL, 'Missile nucléaire, portée 300 km', 'Nuclear missile, 300 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ASMP');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ASMP-A', NULL, 'Missile nucléaire amélioré, portée 500 km', 'Improved nuclear missile, 500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ASMP-A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'B28', NULL, 'Bombe nucléaire à chute libre, 1.45 Mt', 'Free-fall nuclear bomb, 1.45 Mt'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'B28');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'B43', NULL, 'Bombe nucléaire à chute libre, 1 Mt', 'Free-fall nuclear bomb, 1 Mt'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'B43');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'B61', NULL, 'Bombe nucléaire tactique, rendement variable', 'Tactical nuclear bomb, variable yield'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'B61');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'B83', NULL, 'Bombe nucléaire stratégique, 1.2 Mt', 'Strategic nuclear bomb, 1.2 Mt'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'B83');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'WE.177', NULL, 'Bombe nucléaire à chute libre, 10-400 kt', 'Free-fall nuclear bomb, 10-400 kt'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'WE.177');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'RN-28', NULL, 'Bombe nucléaire tactique à chute libre', 'Tactical free-fall nuclear bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'RN-28');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'TN-1000', NULL, 'Bombe nucléaire à chute libre, 1 Mt', 'Free-fall nuclear bomb, 1 Mt'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'TN-1000');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'RN-40', NULL, 'Bombe nucléaire à chute libre', 'Free-fall nuclear bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'RN-40');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Kh-47M2 Kinzhal', NULL, 'Missile balistique hypersonique, portée 2000 km', 'Hypersonic ballistic missile, 2000 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Kh-47M2 Kinzhal');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Bombe lisse 250 kg', NULL, 'Bombe conventionnelle non guidée, 250 kg', 'Unguided conventional bomb, 250 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Bombe lisse 250 kg');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Bombe lisse 400 kg', NULL, 'Bombe conventionnelle non guidée, 400 kg', 'Unguided conventional bomb, 400 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Bombe lisse 400 kg');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Bombe lisse 500 kg', NULL, 'Bombe conventionnelle non guidée, 500 kg', 'Unguided conventional bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Bombe lisse 500 kg');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Bombe lisse 1000 kg', NULL, 'Bombe conventionnelle non guidée, 1000 kg', 'Unguided conventional bomb, 1000 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Bombe lisse 1000 kg');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-12 Paveway II', NULL, 'Bombe guidée laser, 224 kg', 'Laser-guided bomb, 224 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-12 Paveway II');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-24 Paveway III', NULL, 'Bombe guidée laser, portée accrue', 'Laser-guided bomb, extended range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-24 Paveway III');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'BL755', NULL, 'Bombe à sous-munitions', 'Cluster bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'BL755');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'JDAM', NULL, 'Kit de guidage GPS pour bombes, portée 24 km', 'GPS guidance kit for bombs, 24 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'JDAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Mk 82', NULL, 'Bombe lisse 227 kg', '227 kg unguided bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Mk 82');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Mk 83', NULL, 'Bombe lisse 454 kg', '454 kg unguided bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Mk 83');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Mk 84', NULL, 'Bombe lisse 907 kg', '907 kg unguided bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Mk 84');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-10 Paveway II', NULL, 'Bombe guidée laser, 907 kg', 'Laser-guided bomb, 907 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-10 Paveway II');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-16 Paveway II', NULL, 'Bombe guidée laser, 454 kg', 'Laser-guided bomb, 454 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-16 Paveway II');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-27 Paveway III', NULL, 'Bombe guidée laser furtive, 907 kg', 'Stealth laser-guided bomb, 907 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-27 Paveway III');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-31 JDAM', NULL, 'Bombe guidée GPS, 907 kg', 'GPS-guided bomb, 907 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-31 JDAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-32 JDAM', NULL, 'Bombe guidée GPS, 454 kg', 'GPS-guided bomb, 454 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-32 JDAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-38 JDAM', NULL, 'Bombe guidée GPS, 227 kg', 'GPS-guided bomb, 227 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-38 JDAM');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-39 SDB', NULL, 'Petite bombe guidée, 113 kg', 'Small guided bomb, 113 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-39 SDB');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'CBU-87', NULL, 'Bombe à sous-munitions, 430 kg', 'Cluster bomb, 430 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'CBU-87');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'CBU-97', NULL, 'Bombe à sous-munitions avec capteurs, 430 kg', 'Sensor-fuzed cluster bomb, 430 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'CBU-97');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FAB-250', NULL, 'Bombe lisse 250 kg', 'Unguided bomb, 250 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FAB-250');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FAB-500', NULL, 'Bombe lisse 500 kg', 'Unguided bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FAB-500');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FAB-1000', NULL, 'Bombe lisse 1000 kg', 'Unguided bomb, 1000 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FAB-1000');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FAB-1500', NULL, 'Bombe lisse 1500 kg', 'Unguided bomb, 1500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FAB-1500');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'KAB-500L', NULL, 'Bombe guidée laser, 500 kg', 'Laser-guided bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'KAB-500L');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'KAB-1500L', NULL, 'Bombe guidée laser, 1500 kg', 'Laser-guided bomb, 1500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'KAB-1500L');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'BetAB-500', NULL, 'Bombe anti-bunker, 500 kg', 'Anti-bunker bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'BetAB-500');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ODAB-500', NULL, 'Bombe thermobarique, 500 kg', 'Thermobaric bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ODAB-500');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'LT-2', NULL, 'Bombe guidée laser, 500 kg', 'Laser-guided bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'LT-2');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'LS-6', NULL, 'Bombe guidée par GPS/glide, 500 kg', 'GPS/glide-guided bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'LS-6');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-250', NULL, 'Bombe guidée chinoise, 250 kg', 'Chinese guided bomb, 250 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-250');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Type 200A', NULL, 'Bombe anti-piste, 500 kg', 'Anti-runway bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Type 200A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Paveway IV', NULL, 'Bombe guidée laser/GPS, 227 kg', 'Laser/GPS-guided bomb, 227 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Paveway IV');
INSERT INTO armement (name, name_en, description, description_en)
SELECT '1000 lb GP', NULL, 'Bombe lisse 454 kg', '454 kg unguided bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = '1000 lb GP');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'M/71 120 kg', NULL, 'Bombe lisse 120 kg', '120 kg unguided bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'M/71 120 kg');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'M/71 500 kg', NULL, 'Bombe lisse 500 kg', '500 kg unguided bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'M/71 500 kg');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'GBU-49', NULL, 'Bombe guidée laser/GPS, 227 kg', 'Laser/GPS-guided bomb, 227 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'GBU-49');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'OFAB-250', NULL, 'Bombe lisse 250 kg', 'Unguided bomb, 250 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'OFAB-250');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'OFAB-500', NULL, 'Bombe lisse 500 kg', 'Unguided bomb, 500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'OFAB-500');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FAB-3000', NULL, 'Bombe lisse conventionnelle, 3000 kg', 'Conventional unguided bomb, 3000 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FAB-3000');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FAB-5000', NULL, 'Bombe lisse conventionnelle, 5000 kg', 'Conventional unguided bomb, 5000 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FAB-5000');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'BAP 100', NULL, 'Bombe anti-piste', 'Anti-runway bomb'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'BAP 100');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'KAB-1500Kr', NULL, 'Bombe guidée TV, 1500 kg', 'TV-guided bomb, 1500 kg'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'KAB-1500Kr');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'SNEB 68 mm', NULL, 'Roquettes non guidées, pod de 68 mm', 'Unguided rockets, 68 mm pod'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'SNEB 68 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Zuni 127 mm', NULL, 'Roquettes non guidées, pod de 127 mm', 'Unguided rockets, 127 mm pod'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Zuni 127 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Hydra 70', NULL, 'Roquettes non guidées, 70 mm', 'Unguided rockets, 70 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Hydra 70');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'S-5', NULL, 'Roquettes non guidées, 57 mm', 'Unguided rockets, 57 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'S-5');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'S-8', NULL, 'Roquettes non guidées, 80 mm', 'Unguided rockets, 80 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'S-8');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'S-13', NULL, 'Roquettes non guidées, 122 mm', 'Unguided rockets, 122 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'S-13');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'S-24', NULL, 'Roquettes non guidées, 240 mm', 'Unguided rockets, 240 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'S-24');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'S-25', NULL, 'Roquettes non guidées, 340 mm', 'Unguided rockets, 340 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'S-25');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'CRV7', NULL, 'Roquettes non guidées, 70 mm', 'Unguided rockets, 70 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'CRV7');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Bofors 135 mm', NULL, 'Roquettes non guidées, 135 mm', 'Unguided rockets, 135 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Bofors 135 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Type 90-1', NULL, 'Roquettes non guidées, 90 mm', 'Unguided rockets, 90 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Type 90-1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'HF-16', NULL, 'Roquettes non guidées, 57 mm', 'Unguided rockets, 57 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'HF-16');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'HVAR 70 mm', NULL, 'Roquettes non guidées, 70 mm', 'Unguided rockets, 70 mm'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'HVAR 70 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'APR-3', NULL, 'Torpille légère anti-sous-marine, guidage acoustique', 'Lightweight anti-submarine torpedo, acoustic guidance'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'APR-3');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'RGB-75', NULL, 'Bouée acoustique pour détection sous-marine', 'Acoustic sonobuoy for underwater detection'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'RGB-75');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Shafrir 2', NULL, 'Missile air-air courte portée israélien, guidage infrarouge, 5 km', 'Israeli short-range air-to-air missile, infrared guidance, 5 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Shafrir 2');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Rampage', NULL, 'Missile air-sol supersonique stand-off israélien, portée 150 km', 'Israeli supersonic stand-off air-to-surface missile, 150 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Rampage');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Delilah', NULL, 'Missile de croisière israélien air-sol/antinavire, portée 250 km', 'Israeli air-to-surface/anti-ship cruise missile, 250 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Delilah');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Rb 04E', NULL, 'Missile antinavire suédois subsonique, portée 32 km', 'Swedish subsonic anti-ship missile, 32 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Rb 04E');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Rb 05A', NULL, 'Missile air-sol suédois, guidage radio, portée 9 km', 'Swedish air-to-surface missile, radio guidance, 9 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Rb 05A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Rb 15F', NULL, 'Missile antinavire suédois turbo, portée 200 km', 'Swedish turbojet anti-ship missile, 200 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Rb 15F');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Astra Mk1', NULL, 'Missile air-air BVR indien à guidage radar actif, portée 110 km', 'Indian BVR air-to-air missile with active radar guidance, 110 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Astra Mk1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'BrahMos-A', NULL, 'Missile de croisière supersonique indo-russe air-sol/antinavire, portée 450 km', 'Indo-Russian supersonic air-to-surface/anti-ship cruise missile, 450 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'BrahMos-A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'ASM-3', NULL, 'Missile antinavire supersonique japonais, portée 200 km', 'Japanese supersonic anti-ship missile, 200 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'ASM-3');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Popeye Turbo', NULL, 'Missile de croisière israélien à longue portée, 1500 km', 'Israeli long-range cruise missile, 1500 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Popeye Turbo');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'NR-23', NULL, 'Canon de 23 mm, 850 coups/min', '23 mm cannon, 850 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'NR-23');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'PL-10', NULL, 'Missile air-air courte portée, guidage infrarouge à imagerie, 20 km', 'Short-range air-to-air missile, imaging infrared guidance, 20 km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'PL-10');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'PL-15', NULL, 'Missile air-air longue portée, guidage radar actif, 200+ km', 'Long-range air-to-air missile, active radar guidance, 200+ km'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'PL-15');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'YJ-83', NULL, 'Missile antinavire subsonique, guidage radar actif, portée 180 km', 'Subsonic anti-ship missile, active radar guidance, 180 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'YJ-83');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'YJ-91', NULL, 'Missile anti-radar/antinavire, portée 120 km', 'Anti-radiation / anti-ship missile, 120 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'YJ-91');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'KD-88', NULL, 'Missile air-sol de précision, guidage TV/IR, portée 180 km', 'Precision air-to-surface missile, TV/IR guidance, 180 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'KD-88');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'C-802A', NULL, 'Missile antinavire subsonique, guidage radar actif, portée 180 km', 'Subsonic anti-ship missile, active radar guidance, 180 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'C-802A');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'CJ-10', NULL, 'Missile de croisière à lancement aérien, portée 1500-2000 km', 'Air-launched cruise missile, 1500-2000 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'CJ-10');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'CJ-20', NULL, 'Missile de croisière furtif à lancement aérien, portée 2000+ km', 'Stealthy air-launched cruise missile, 2000+ km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'CJ-20');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AIM-4 Falcon', NULL, 'Missile air-air à guidage infrarouge ou radar semi-actif, portée 11 km', 'Infrared or semi-active radar guided air-to-air missile, 11 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AIM-4 Falcon');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AIR-2 Genie', NULL, 'Roquette air-air à charge nucléaire de 1,5 kt, non guidée', 'Unguided air-to-air rocket with a 1.5 kt nuclear warhead'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AIR-2 Genie');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Hispano-Suiza HS.404', NULL, 'Canon de 20 mm à alimentation par bande, 600 coups/min', '20 mm belt-fed cannon, 600 rounds/min'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Hispano-Suiza HS.404');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'M3 Browning 12,7 mm', NULL, 'Mitrailleuse lourde américaine de 12,7 mm, 1 200 coups/min, armement standard des premiers jets', 'American 12.7 mm heavy machine gun, 1,200 rounds/min, standard armament of the first jets'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'M3 Browning 12,7 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Mk 46', NULL, 'Torpille légère anti-sous-marine américaine, portée 11 km, immersion 365 m', 'American lightweight anti-submarine torpedo, 11 km range, 365 m depth'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Mk 46');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Sting Ray', NULL, 'Torpille légère anti-sous-marine britannique à guidage actif/passif', 'British lightweight anti-submarine torpedo with active/passive homing'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Sting Ray');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'FFAR Mighty Mouse', NULL, 'Roquette air-air non guidée de 70 mm, tirée en salve depuis un panier ventral', 'Unguided 70 mm air-to-air rocket, salvo-fired from a belly tray'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'FFAR Mighty Mouse');

-- Technologies référencées mais jamais déclarées
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile delta', 'Delta wing', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses', 'Aerodynamic configuration without horizontal tail for high speeds'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile delta');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile en flèche', 'Swept wing', 'Configuration aérodynamique pour les hautes vitesses', 'Aerodynamic configuration for high speeds'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile en flèche');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile à géométrie variable', 'Variable-geometry wing', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses', 'Wing with movable panels to optimize performance at different speeds'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile à géométrie variable');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile canard delta', 'Delta canard wing', 'Configuration aérodynamique combinant canards et aile delta', 'Aerodynamic configuration combining canards and delta wing'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile canard delta');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile à forte flèche', 'Highly swept wing', 'Conception aérodynamique pour une grande maniabilité', 'Aerodynamic design for high maneuverability'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile à forte flèche');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile droite à faible allongement', 'Low aspect ratio straight wing', 'Configuration aérodynamique pour les hautes vitesses', 'Aerodynamic configuration for high speeds'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile droite à faible allongement');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile en flèche légère', 'Light swept wing', 'Conception légère pour une grande maniabilité', 'Lightweight design for high maneuverability'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile en flèche légère');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile à incidence variable', 'Variable-incidence wing', 'Dispositif mécanique modifiant l''angle de l''aile en vol', 'Mechanical device modifying the wing angle in flight'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile à incidence variable');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile delta-canard', 'Delta-canard wing', 'Configuration aérodynamique combinant canards et aile delta', 'Aerodynamic configuration combining canards and delta wing'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile delta-canard');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile en flèche avec canards', 'Swept wing with canards', 'Configuration aérodynamique combinant canards et aile en flèche pour une grande maniabilité', 'Aerodynamic configuration combining canards and swept wing for high maneuverability'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile en flèche avec canards');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Configuration aérodynamique en double delta', 'Double-delta aerodynamic configuration', 'Combinaison de deux ailes delta pour une grande maniabilité et des performances à haute vitesse', 'Combination of two delta wings for high maneuverability and high-speed performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Configuration aérodynamique en double delta');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur à postcombustion', 'Afterburning jet engine', 'Moteur SNECMA Atar permettant des performances supersoniques', 'SNECMA Atar engine enabling supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur à postcombustion');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Tumansky R-25', 'Tumansky R-25 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Tumansky R-25');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur General Electric J79', 'General Electric J79 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur General Electric J79');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteurs à poussée vectorielle', 'Thrust-vectoring engines', 'Moteurs permettant une grande maniabilité', 'Engines providing high maneuverability'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteurs à poussée vectorielle');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteurs à turbofan', 'Turbofan engines', 'Moteurs modernes pour améliorer l''efficacité et la portée', 'Modern engines to improve efficiency and range'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteurs à turbofan');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteur à poussée vectorielle', 'Thrust-vectoring engine', 'Moteur Rolls-Royce Pegasus permettant le décollage et l''atterrissage vertical (VTOL)', 'Rolls-Royce Pegasus engine enabling vertical take-off and landing (VTOL)'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteur à poussée vectorielle');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Klimov VK-1', 'Klimov VK-1 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Klimov VK-1');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Tumansky R-9', 'Tumansky R-9 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Tumansky R-9');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur WP-7', 'WP-7 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur WP-7');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur WP-13', 'WP-13 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur WP-13');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur AL-31FN', 'AL-31FN engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur AL-31FN');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur WS-10', 'WS-10 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur WS-10');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur RD-93', 'RD-93 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur RD-93');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Rolls-Royce Avon', 'Rolls-Royce Avon engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Rolls-Royce Avon');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Volvo RM8', 'Volvo RM8 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Volvo RM8');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Volvo RM12', 'Volvo RM12 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Volvo RM12');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Rolls-Royce Orpheus', 'Rolls-Royce Orpheus engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Rolls-Royce Orpheus');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur General Electric F404', 'General Electric F404 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur General Electric F404');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Rolls-Royce/Turbomeca Adour', 'Rolls-Royce/Turbomeca Adour engine', 'Moteur à double flux pour des performances subsoniques', 'Bypass engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Kuznetsov NK-12', 'Kuznetsov NK-12 engine', 'Moteur à turbopropulseur pour une grande autonomie', 'Turboprop engine for long range'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Kuznetsov NK-12');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Ishikawajima-Harima F3-IHI-30', 'Ishikawajima-Harima F3-IHI-30 engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Ishikawajima-Harima F3-IHI-30');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Larzac 04', 'Larzac 04 engine', 'Moteur à double flux pour des performances subsoniques', 'Bypass engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Larzac 04');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Rolls-Royce Viper', 'Rolls-Royce Viper engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Rolls-Royce Viper');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Rolls-Royce Spey', 'Rolls-Royce Spey engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Rolls-Royce Spey');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur Honeywell TFE731', 'Honeywell TFE731 engine', 'Moteur à turbofan pour des performances subsoniques', 'Turbofan engine for subsonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur Honeywell TFE731');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteurs Tumansky R-15', 'Tumansky R-15 engines', 'Moteurs à postcombustion pour des vitesses supérieures à Mach 3', 'Afterburning engines for speeds above Mach 3'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteurs Tumansky R-15');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteurs D-30F6', 'D-30F6 engines', 'Moteurs à postcombustion pour des performances supersoniques', 'Afterburning engines for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteurs D-30F6');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteurs Tumansky R-11', 'Tumansky R-11 engines', 'Moteurs à postcombustion pour des performances supersoniques', 'Afterburning engines for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteurs Tumansky R-11');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteurs à turbopropulseurs', 'Turboprop engines', 'Moteurs à hélices contrarotatives pour une grande autonomie', 'Contra-rotating propeller engines for long range'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteurs à turbopropulseurs');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur AL-31F', 'AL-31F engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur AL-31F');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Réacteur WP-6', 'WP-6 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Réacteur WP-6');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Cyrano', 'Cyrano radar', 'Radar monopulse Cyrano I/II pour interception et tir air-air', 'Cyrano I/II monopulse radar for interception and air-to-air firing'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Cyrano');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Cyrano IV', 'Cyrano IV radar', 'Radar multimode amélioré avec capacité de cartographie terrain', 'Improved multi-mode radar with terrain mapping capability'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Cyrano IV');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RDM/RDI', 'RDM/RDI radar', 'Radar Doppler multi-mode pour détection air-air/air-sol', 'Multi-mode Doppler radar for air-to-air/air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RDM/RDI');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RBE2 AESA', 'RBE2 AESA radar', 'Premier radar à antenne active européenne en service', 'First European active-array radar in service'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RBE2 AESA');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/APQ-120', 'AN/APQ-120 radar', 'Radar de tir et de navigation multifonction', 'Multifunction fire-control and navigation radar'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/APQ-120');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/ASG-14', 'AN/ASG-14 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/ASG-14');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/APG-63', 'AN/APG-63 radar', 'Radar Doppler à impulsions pour détection longue portée', 'Pulse-Doppler radar for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/APG-63');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/APG-68', 'AN/APG-68 radar', 'Radar Doppler multi-mode pour détection air-air/air-sol', 'Multi-mode Doppler radar for air-to-air/air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/APG-68');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/APG-77', 'AN/APG-77 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/APG-77');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/APG-81', 'AN/APG-81 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/APG-81');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RP-21', 'RP-21 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RP-21');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RP-23', 'RP-23 radar', 'Radar de tir et de navigation multifonction', 'Multifunction fire-control and navigation radar'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RP-23');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RP-25', 'RP-25 radar', 'Radar à longue portée pour interception à haute altitude', 'Long-range radar for high-altitude interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RP-25');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar N019', 'N019 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar N019');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Zaslon', 'Zaslon radar', 'Radar à balayage électronique passif (PESA) pour détection longue portée', 'Passive electronically scanned array (PESA) for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Zaslon');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RP-15', 'RP-15 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RP-15');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Klen', 'Klen radar', 'Radar de tir et de navigation pour attaque au sol', 'Fire-control and navigation radar for ground attack'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Klen');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Puma', 'Puma radar', 'Radar de suivi de terrain pour vol à basse altitude', 'Terrain-following radar for low-altitude flight'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Puma');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar N001', 'N001 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar N001');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar N011M Bars', 'N011M Bars radar', 'Radar à balayage électronique passif (PESA) pour détection longue portée', 'Passive electronically scanned array (PESA) for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar N011M Bars');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar V004', 'V004 radar', 'Radar à balayage électronique passif (PESA) pour détection air-air/air-sol', 'Passive electronically scanned array (PESA) for air-to-air/air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar V004');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Irbis-E', 'Irbis-E radar', 'Radar à balayage électronique passif (PESA) pour détection longue portée', 'Passive electronically scanned array (PESA) for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Irbis-E');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar N036', 'N036 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar N036');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar PN-AD', 'PN-AD radar', 'Radar de navigation et d''attaque pour missions de bombardement', 'Navigation and attack radar for bombing missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar PN-AD');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Obzor-K', 'Obzor-K radar', 'Radar de navigation et d''attaque pour missions de bombardement', 'Navigation and attack radar for bombing missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Obzor-K');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar RP-9', 'RP-9 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar RP-9');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Type 226', 'Type 226 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Type 226');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Type 1471', 'Type 1471 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Type 1471');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Type 1473', 'Type 1473 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Type 1473');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AESA', 'AESA radar', 'Radar à antenne active pour détection longue portée', 'Active-array radar for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AESA');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar KLJ-7', 'KLJ-7 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar KLJ-7');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AI.23', 'AI.23 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AI.23');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Blue Fox', 'Blue Fox radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Blue Fox');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar CAPTOR', 'CAPTOR radar', 'Radar à balayage électronique mécanique pour détection air-air et air-sol', 'Mechanically scanned array radar for air-to-air and air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar CAPTOR');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Blue Parrot', 'Blue Parrot radar', 'Radar de suivi de terrain pour missions de bombardement', 'Terrain-following radar for bombing missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Blue Parrot');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar H2S', 'H2S radar', 'Radar de navigation et de bombardement pour missions stratégiques', 'Navigation and bombing radar for strategic missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar H2S');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar R21G/M1', 'R21G/M1 radar', 'Radar de tir et de navigation amélioré pour interception', 'Improved fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar R21G/M1');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar PS-02/A', 'PS-02/A radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar PS-02/A');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar PS-37/A', 'PS-37/A radar', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol', 'Terrain-following and navigation radar for air-to-air and air-to-ground missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar PS-37/A');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar PS-05/A', 'PS-05/A radar', 'Radar à balayage électronique mécanique pour détection air-air et air-sol', 'Mechanically scanned array radar for air-to-air and air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar PS-05/A');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar EL/M-2032', 'EL/M-2032 radar', 'Radar Doppler multi-mode pour détection air-air/air-sol', 'Multi-mode Doppler radar for air-to-air/air-to-ground detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar EL/M-2032');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar J/APG-1', 'J/APG-1 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar J/APG-1');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/AWG-9', 'AN/AWG-9 radar', 'Radar à longue portée pour missiles AIM-54 Phoenix', 'Long-range radar for AIM-54 Phoenix missiles'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/AWG-9');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar de suivi de terrain', 'Terrain-following radar', 'Radar permettant un vol à basse altitude en suivant le relief', 'Radar enabling low-altitude flight by following terrain contours'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar de suivi de terrain');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar multi-mode', 'Multi-mode radar', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol', 'Terrain-following and navigation radar for air-to-air and air-to-ground missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar multi-mode');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar Type 242', 'Type 242 radar', 'Radar de navigation et d''attaque pour missions de bombardement', 'Navigation and attack radar for bombing missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar Type 242');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de navigation inertielle', 'Inertial navigation system', 'Système de navigation autonome sans GPS', 'Autonomous navigation system without GPS'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de navigation inertielle');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de navigation semi-automatique', 'Semi-automatic navigation system', 'Intégration précoce d''un système de navigation inertielle', 'Early integration of inertial navigation system'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de navigation semi-automatique');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de navigation et d''attaque intégré', 'Integrated navigation and attack system', 'Système combinant navigation inertielle et radar', 'System combining inertial navigation and radar'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de navigation et d''attaque intégré');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de navigation attaque à basse altitude', 'Low-altitude navigation and attack system', 'Couplage radar altimètre/ordinateur de navigation', 'Coupling of radar altimeter and navigation computer'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de navigation attaque à basse altitude');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Commande de vol électrique (fly-by-wire)', 'Fly-by-wire flight control', 'Système numérique de contrôle de stabilité', 'Digital stability control system'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de contrôle de vol numérique', 'Digital flight control system', 'Système de contrôle de vol assisté par ordinateur', 'Computer-assisted flight control system'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de contrôle de vol numérique');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de contrôle de réacteur', 'Engine control system', 'Système de contrôle numérique pour la gestion de la poussée vectorielle', 'Digital control system for thrust vectoring management'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de contrôle de réacteur');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système SPECTRA', 'SPECTRA system', 'Suite complète de guerre électronique et contre-mesures', 'Comprehensive electronic warfare and countermeasures suite'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système SPECTRA');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de contre-mesures électroniques', 'Electronic countermeasures system', 'Système intégré de brouillage et de leurres', 'Integrated jamming and decoy system'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de contre-mesures électroniques');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Conception furtive', 'Stealth design', 'Forme et matériaux réduisant la signature radar', 'Shape and materials reducing radar signature'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Conception furtive');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Fusion de capteurs', 'Sensor fusion', 'Intégration des données radar, IR et ROEM', 'Integration of radar, IR and ELINT data'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Fusion de capteurs');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de fusion de capteurs', 'Sensor fusion system', 'Intégration des données radar, IR et ROEM', 'Integration of radar, IR and ELINT data'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de fusion de capteurs');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de gestion de mission avancé', 'Advanced mission management system', 'Système intégré de navigation, d''attaque et de contre-mesures', 'Integrated navigation, attack and countermeasures system'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de gestion de mission avancé');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de caméra intégré', 'Integrated camera system', 'Caméra gunshot pour enregistrement des combats', 'Gunshot camera for combat recording'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de caméra intégré');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Liaison de données tactique', 'Tactical data link', 'Système d''échange d''informations avec la flotte', 'Information exchange system with the fleet'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Liaison de données tactique');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Canon M39', 'M39 cannon', 'Canon de 20 mm à haute cadence de tir', '20 mm high rate-of-fire cannon'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Canon M39');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Canon GAU-8 Avenger', 'GAU-8 Avenger cannon', 'Canon rotatif de 30 mm à haute cadence de tir', '30 mm rotary cannon with high rate of fire'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Canon GAU-8 Avenger');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Canon GSh-30-2', 'GSh-30-2 cannon', 'Canon double de 30 mm à haute cadence de tir', '30 mm twin cannon with high rate of fire'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Canon GSh-30-2');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Canon NR-23', 'NR-23 cannon', 'Canon de 23 mm à haute cadence de tir', '23 mm high rate-of-fire cannon'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Canon NR-23');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Matériaux composites', 'Composite materials', 'Utilisation de carbone et kevlar dans la structure', 'Use of carbon and Kevlar in the structure'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Matériaux composites');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Blindage en titane', 'Titanium armor', 'Blindage lourd pour protéger le pilote et les systèmes vitaux', 'Heavy armor to protect pilot and vital systems'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Blindage en titane');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Conception en acier inoxydable', 'Stainless steel design', 'Structure en acier pour résister aux hautes vitesses et températures', 'Steel structure to withstand high speeds and temperatures'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Conception en acier inoxydable');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Matériaux résistants à la chaleur', 'Heat-resistant materials', 'Utilisation de titane et de matériaux composites résistants à la chaleur', 'Use of titanium and heat-resistant composite materials'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Matériaux résistants à la chaleur');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système navalisé', 'Navalized system', 'Renforcement structurel et corrosion contrôlée pour porte-avions', 'Structural reinforcement and corrosion control for carriers'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système navalisé');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Soute à armement pressurisée', 'Pressurized weapons bay', 'Soute spéciale pour armes nucléaires stratégiques', 'Special bay for strategic nuclear weapons'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Soute à armement pressurisée');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Perche de ravitaillement en vol', 'Fixed aerial refueling probe', 'Système de ravitaillement en vol fixe', 'Fixed in-flight refueling system'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Perche de ravitaillement en vol');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de ravitaillement en vol automatique', 'Automatic aerial refueling system', 'Perche de ravitaillement avec automate de connexion', 'Refueling probe with automatic connection control'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de ravitaillement en vol automatique');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Siège incliné', 'Reclined seat', 'Siège incliné pour réduire les effets de la gravité sur le pilote', 'Reclined seat to reduce the effects of gravity on the pilot'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Siège incliné');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Pod désignateur laser', 'Laser designator pod', 'Capacité d''illumination laser pour bombes guidées', 'Laser illumination capability for guided bombs'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Pod désignateur laser');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Poste de pilotage côte à côte', 'Side-by-side cockpit', 'Configuration côte à côte pour les missions longues durées', 'Side-by-side configuration for long-duration missions'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Poste de pilotage côte à côte');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Configuration bi-moteurs superposés', 'Stacked twin-engine configuration', 'Moteurs empilés verticalement pour réduire la traînée', 'Engines stacked vertically to reduce drag'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Configuration bi-moteurs superposés');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de décollage et d''atterrissage sur porte-avions', 'Carrier take-off and landing system', 'Renforcement structurel et corrosion contrôlée pour porte-avions', 'Structural reinforcement and corrosion control for carriers'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de décollage et d''atterrissage sur porte-avions');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Conception aérodynamique pour haute altitude', 'High-altitude aerodynamic design', 'Forme optimisée pour le vol à haute altitude et haute vitesse', 'Optimized shape for high-altitude and high-speed flight'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Conception aérodynamique pour haute altitude');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile en flèche inversée', 'Forward-swept wing', 'Voilure dont les extrémités sont en avant de l''emplanture, gain de manoeuvrabilité au prix d''une divergence aéroélastique', 'Wing whose tips lie ahead of the root, improving manoeuvrability at the cost of aeroelastic divergence'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile en flèche inversée');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteur-fusée', 'Rocket engine', 'Propulsion emportant son comburant, autorisant le vol au-delà de l''atmosphère respirable', 'Propulsion carrying its own oxidiser, allowing flight beyond the breathable atmosphere'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteur-fusée');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Radar AN/APQ-94', 'AN/APQ-94 radar', 'Radar de conduite de tir monopulse pour l''interception tout temps', 'Monopulse fire-control radar for all-weather interception'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Radar AN/APQ-94');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Système de ravitaillement en vol', 'Aerial refuelling system', 'Perche ou réceptacle permettant l''extension du rayon d''action en vol', 'Probe or receptacle extending combat radius in flight'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Système de ravitaillement en vol');
-- Lots 25-28, et entrées jusque-là déclarées par des fiches
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'Martin (Glenn L. Martin Company)', 'Martin (Glenn L. Martin Company)', (SELECT id FROM countries WHERE code = 'USA'), 'MAR'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'MAR');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'CASC (China Aerospace Science and Technology Corporation)', 'CASC (China Aerospace Science and Technology Corporation)', (SELECT id FROM countries WHERE code = 'CHN'), 'CASC'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'CASC');
INSERT INTO manufacturer (name, name_en, country_id, code)
SELECT 'René Leduc', 'René Leduc', (SELECT id FROM countries WHERE code = 'FRA'), 'LED'
WHERE NOT EXISTS (SELECT 1 FROM manufacturer WHERE code = 'LED');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Canon M102 105 mm', NULL, 'Obusier de 105 mm tirant en dérive depuis le flanc gauche de l''appareil', 'Side-firing 105 mm howitzer mounted on the left side of the aircraft'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Canon M102 105 mm');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'MAM-L', NULL, 'Munition guidée laser de 22 kg conçue pour les drones tactiques légers', 'Laser-guided 22 kg munition designed for light tactical drones'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'MAM-L');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'TC-1 Tien Chien I', NULL, 'Missile air-air courte portée à guidage infrarouge, portée 8 km', 'Short-range infrared-guided air-to-air missile, 8 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'TC-1 Tien Chien I');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'TC-2 Tien Chien II', NULL, 'Missile air-air moyenne portée à guidage radar actif, portée 60 km', 'Medium-range active radar-guided air-to-air missile, 60 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'TC-2 Tien Chien II');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'RS-2US', NULL, 'Missile air-air à guidage radar par faisceau directeur, portée 6 km', 'Beam-riding radar-guided air-to-air missile, 6 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'RS-2US');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'R-4', NULL, 'Missile air-air lourd, versions à guidage radar semi-actif et infrarouge, portée 25 km', 'Heavy air-to-air missile in semi-active radar and infrared versions, 25 km range'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'R-4');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'NS-23', NULL, 'Canon soviétique de 23 mm Noudelman-Souranov, mis au point en 1944, armement des premiers chasseurs à réaction Yakovlev', 'Soviet Nudelman-Suranov 23 mm cannon, developed in 1944, fitted to the first Yakovlev jet fighters'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'NS-23');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'Gökdoğan', NULL, 'Missile air-air turc à guidage radar actif, au-delà de la portée visuelle (TÜBİTAK SAGE)', 'Turkish beyond-visual-range air-to-air missile, active radar guidance (TÜBİTAK SAGE)'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'Gökdoğan');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'AR-1', NULL, 'Missile air-sol léger chinois à guidage laser semi-actif, conçu pour les drones', 'Light Chinese semi-active laser-guided air-to-surface missile designed for drones'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'AR-1');
INSERT INTO armement (name, name_en, description, description_en)
SELECT 'M134 Minigun', 'M134 Minigun', 'Mitrailleuse rotative à six canons de 7,62 mm entraînée électriquement, jusqu''à 6 000 coups/min (désignation USAF : GAU-2/A)', 'Electrically driven six-barrel 7.62 mm rotary machine gun, up to 6,000 rounds/min (USAF designation: GAU-2/A)'
WHERE NOT EXISTS (SELECT 1 FROM armement WHERE name = 'M134 Minigun');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Moteur à pistons en étoile', 'Radial piston engine', 'Motorisation à cylindres disposés en étoile, longue endurance à basse altitude', 'Engine with radially arranged cylinders, long endurance at low altitude'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Moteur à pistons en étoile');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Rotors basculants', 'Tiltrotors', 'Rotors montés en bout d''aile dans des nacelles qui pivotent de la verticale à l''horizontale : décollage vertical comme un hélicoptère, croisière comme un avion à hélices', 'Wingtip rotors in nacelles that pivot from vertical to horizontal: vertical take-off like a helicopter, cruise like a propeller aircraft'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Rotors basculants');
INSERT INTO tech (name, name_en, description, description_en)
SELECT 'Aile volante', 'Flying wing', 'Voilure sans fuselage ni empennage horizontal, qui porte à elle seule l''équipage, les moteurs et la charge', 'Wing with no fuselage or horizontal tail, carrying crew, engines and payload on its own'
WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile volante');

-- ═══ 3. Niveau de furtivité ══════════════════════════════════════════════
--
-- Le champ n'était renseigné que sur 7 appareils : la tuile « Niveau de
-- furtivité » restait invisible sur la quasi-totalité du catalogue.
-- 'aucune' est une valeur explicite — aucune mesure de réduction de signature
-- radar — et non un « inconnu » déguisé.

UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-1 Skyraider' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-10 Thunderbolt II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-26 Invader' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-3 Skywarrior' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-37 Dragonfly' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-4 Skyhawk' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-5 Vigilante' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-6 Intruder' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'A-7 Corsair II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AC-130 Spectre' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AIDC AT-3 Tzu Chung' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AIDC F-CK-1 Ching-kuo' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AIDC T-5 Brave Eagle' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AMX A-1 Brésilien' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AMX International AMX' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AV-8B Harrier II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aeritalia G.222' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aermacchi MB-326' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aermacchi MB-339' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aero L-159 ALCA' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aero L-29 Delfín' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aero L-39 Albatros' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Airbus A330 MRTT' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Airbus A400M Atlas' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Alenia C-27J Spartan' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Alpha Jet Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-12' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-124 Ruslan' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-22 Antei' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-26' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-32' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-72' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Atlas Cheetah' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Atlas Impala' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Avro Canada CF-100 Canuck' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Avro Canada CF-105 Arrow' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Avro Shackleton' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Avro Vulcan' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'B-1 Lancer' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'tres_elevee'  WHERE name = 'B-2 Spirit' AND stealth_level IS DISTINCT FROM 'tres_elevee';
UPDATE airplanes SET stealth_level = 'tres_elevee'  WHERE name = 'B-21 Raider' AND stealth_level IS DISTINCT FROM 'tres_elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'B-29 Superfortress' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'B-36 Peacemaker' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'B-47 Stratojet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'B-52 Stratofortress' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'B-58 Hustler' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'BAC TSR-2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'BAE Hawk' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'BAE Sea Harrier' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Bayraktar TB2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Bell X-1' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Bell X-14' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Beriev A-50' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Beriev Be-12 Chaïka' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Beriev Be-200' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Blackburn Buccaneer' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'Boeing X-32' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Breguet Alizé' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Breguet Atlantique' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Britten-Norman Defender' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-119 Flying Boxcar' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-130 Hercules' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-141 Starlifter' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-17 Globemaster III' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-2 Greyhound' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-5 Galaxy' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'CAC CA-27 Sabre' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'CASA C-101 Aviojet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'CASA C-212 Aviocar' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'CASA/IPTN CN-235' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Canadair CT-114 Tutor' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Chengdu FC-1/JF-17' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Chengdu J-10' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'Chengdu J-20' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Chengdu J-7' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'D-558-2 Skyrocket' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'DHC-4 Caribou' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'DHC-5 Buffalo' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Dassault MD 315 Flamant' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Dornier Do 28 Skyservant' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Dornier Do 31' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'E-2 Hawkeye' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'E-3 Sentry' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'EA-18G Growler' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'EA-6B Prowler' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'EC-121 Warning Star' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'ENAER T-35 Pillán' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'EWR VJ 101' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Elbit Hermes 900' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Embraer E-99' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Embraer EMB-110 Bandeirante' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Embraer EMB-312 Tucano' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Embraer EMB-314 Super Tucano' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Embraer EMB-326 Xavante' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Embraer KC-390 Millennium' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'English Electric Canberra' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'English Electric Lightning' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Eurofighter Typhoon Allemand' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Eurofighter Typhoon Anglais' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Eurofighter Typhoon Italien' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-100 Super Sabre' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-101 Voodoo' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-102 Delta Dagger' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-104 Starfighter' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-104 Starfighter Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-104S Starfighter Italien' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-105 Thunderchief' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-106 Delta Dart' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-111 Aardvark' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'tres_elevee'  WHERE name = 'F-117 Nighthawk' AND stealth_level IS DISTINCT FROM 'tres_elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-14 Tomcat' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-15 Eagle' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-15E Strike Eagle' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-15EX Eagle II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-15I Ra''am' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-16 Fighting Falcon' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-16I Sufa' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-16XL' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-20 Tigershark' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'tres_elevee'  WHERE name = 'F-22 Raptor' AND stealth_level IS DISTINCT FROM 'tres_elevee';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'F-35 Lightning II' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'F-35 Lightning II Italien' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'F-35B Lightning II Anglais' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'F-35I Adir' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-4 Phantom II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-4 Phantom II Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-4E Kurnass' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-4EJ Kai' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-5 Freedom Fighter' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-5EM Tiger II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-8 Crusader' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-80 Shooting Star' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-82 Twin Mustang' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-84F Thunderstreak' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-86 Sabre' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-89 Scorpion' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-8E (FN) Crusader' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F-94 Starfire' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F/A-18 Hornet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'F/A-18E Super Hornet' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F11F Tiger' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F2Y Sea Dart' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F3D Skyknight' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F4D Skyray' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F7U Cutlass' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F9F Cougar' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F9F Panther' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'FFA P-16' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'FMA IA 58 Pucará' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'FMA IA 63 Pampa' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fairey Delta 2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fairey Firefly' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fairey Gannet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fiat G.91' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fokker F27 Maritime' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fokker S.14 Machtrainer' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Folland Gnat' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fouga CM.170 Magister' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Fuji T-7' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'GAF Jindivik' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'GAF Nomad' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Gloster Javelin' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Gloster Meteor' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Guizhou JL-9' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'HAL AMCA' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'HAL Ajeet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'HAL HF-24 Marut' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'HAL HJT-36 Sitara' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'HAL Tejas Mk1' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'HAL Tejas Mk1A' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'HAL Tejas Mk2' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'HESA Saeqeh' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'HFB 320 Hansa Jet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Handley Page Victor' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hawker Hunter' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hawker P.1127 Kestrel' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hawker Sea Hawk' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hawker Siddeley Harrier' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hawker Siddeley Nimrod' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Helwan HA-300' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hispano HA-200 Saeta' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hongdu JL-8' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hongdu K-8 Karakorum' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hongdu L-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAI Arava' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'IAI Harop' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAI Heron' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAI Kfir' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAI Lavi' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAI Nesher' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAR-99 Șoim' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Il-28' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Iliouchine Il-114' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Iliouchine Il-20' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Iliouchine Il-38' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Iliouchine Il-76' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Iliouchine Il-78 Midas' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Jaguar' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Jaguar IS' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Jet Provost' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KAI FA-50' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'KAI KF-21 Boramae' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KAI KT-1 Woongbi' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KAI T-50 Golden Eagle' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KC-10 Extender' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KC-135 Stratotanker' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KC-46 Pegasus' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KC-97 Stratofreighter' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Kawasaki C-1' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Kawasaki C-2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Kawasaki P-1' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Kawasaki T-4' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'LTV XC-142' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'La-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Let L-410 Turbolet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'Lockheed A-12' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Lockheed D-21' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Lockheed XFV' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'M-346 Master' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MQ-1 Predator' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'MQ-25 Stingray' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MQ-9 Reaper' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'MiG 1.44' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-17' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-19' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-21' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-21 Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-21 Bison' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-23' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-23 Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-25' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-27' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-29' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-29 Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-31' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'MiG-35' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MiG-9' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage 2000' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage 2000H Vajra' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage 4000' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage 5' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage F1' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage G8' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage III' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage III V' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage IIICJ Shahak' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mirage IV' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mitsubishi F-1' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mitsubishi F-104J' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mitsubishi F-15J' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mitsubishi F-2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mitsubishi T-2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'Mitsubishi X-2 Shinshin' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Myasishchev M-4' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Myasishchev M-50' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Myasishchev M-55' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Mystère IV' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Nanchang CJ-6' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Nanchang Q-5' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Nord Noratlas' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'OV-1 Mohawk' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'OV-10 Bronco' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Ouragan' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'P-2 Neptune' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'P-3 Orion' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'P-8 Poseidon' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'PAC Super Mushshak' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'PZL M28 Skytruck' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'PZL TS-11 Iskra' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'PZL-130 Orlik' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Panavia Tornado' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Panavia Tornado Allemand' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Panavia Tornado Italien' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Pilatus PC-7' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Pilatus PC-9' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'RQ-4 Global Hawk' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Rafale' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Rafale EH' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Rockwell XFV-12' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Ryan Firebee' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'S-3 Viking' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'SF.260' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'SOCATA TB-30 Epsilon' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'SR-71 Blackbird' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 105' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 29 Tunnan' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 32 Lansen' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 35 Draken' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 37 Viggen' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab GlobalEye' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Saab JAS 39 Gripen' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saunders-Roe SR.53' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Scottish Aviation Bulldog' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Sea Vixen' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shaanxi Y-8' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shenyang J-11' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shenyang J-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Shenyang J-16' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'Shenyang J-35' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shenyang J-5' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shenyang J-6' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shenyang J-8' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'ShinMaywa US-1A' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'ShinMaywa US-2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Short SC.1' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shorts Tucano' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Soko G-2 Galeb' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Soko G-4 Super Galeb' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Soko J-22 Orao' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-11' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-17' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-24' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-25' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-27' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-30' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-30MKI' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-33' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Su-34' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'Su-35' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'Su-57' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-7' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Su-9' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Sukhoi T-4' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Super Mystère B2' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Super Étendard' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Supermarine Attacker' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Supermarine Scimitar' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Supermarine Swift' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'T-28 Trojan' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'T-33 Shooting Star' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'T-34 Mentor' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'T-37 Tweet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'T-38 Talon' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'T-6 Texan II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'TAI Hürkuş' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'TAI Kaan' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Transall C-160' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-128' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-141 Strizh' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-142' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-143 Reys' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-16' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-160' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-22' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-22M' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tu-95' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Tupolev Tu-4' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'U-2 Dragon Lady' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'VFW VAK 191B' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Valmet L-70 Vinka' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Vautour II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Vickers VC10' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Vickers Valiant' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Westland Wyvern' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Wing Loong II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'X-13 Vertijet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'X-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'X-29' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'X-3 Stiletto' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'X-31' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'X-47B' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'XB-70 Valkyrie' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'XFY Pogo' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'XQ-58 Valkyrie' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Xian H-6' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Xian Y-20 Kunpeng' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'YF-17 Cobra' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'YF-22' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'tres_elevee'  WHERE name = 'YF-23 Black Widow II' AND stealth_level IS DISTINCT FROM 'tres_elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-130' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-141' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-23' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-25' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-28' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-36' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-38' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'de Havilland Vampire' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'de Havilland Venom' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'nEUROn' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Étendard IV' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Pilatus PC-21' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Boeing T-7 Red Hawk' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Airbus C295' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Antonov An-225 Mriya' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Bayraktar Akıncı' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Yak-17' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'B-66 Destroyer' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Martin B-57 Canberra' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'S-2 Tracker' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shaanxi KJ-500' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'V-22 Osprey' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Bell XV-15' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'moderee'      WHERE name = 'Bayraktar Kızılelma' AND stealth_level IS DISTINCT FROM 'moderee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'TAI Anka' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'MQ-28 Ghost Bat' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'Sukhoi S-70 Okhotnik' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'Hongdu GJ-11 Sharp Sword' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'CASC CH-5 Rainbow' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'elevee'       WHERE name = 'Boeing X-45' AND stealth_level IS DISTINCT FROM 'elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MQ-4C Triton' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'TAI Hürjet' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Aero L-39NG Skyfox' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Boeing E-7 Wedgetail' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'reduite'      WHERE name = 'General Atomics YFQ-42A Dark Merlin' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Elbit Hermes 450' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'MQ-1C Gray Eagle' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Bayraktar TB3' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 21R' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'IAe 33 Pulqui II' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'FH-1 Phantom' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F2H Banshee' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F3H Demon' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Northrop YB-49' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Leduc 010' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Nord 1500 Griffon' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'SNCASO Trident' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F4U Corsair' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Hawker Sea Fury' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'F8F Bearcat' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'AC-47 Spooky' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Canadair CP-107 Argus' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'HU-16 Albatross' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'E-1 Tracer' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'KJ-2000' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Saab 340 AEW&C' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Shaanxi Y-9' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'C-123 Provider' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'DHC-2 Beaver' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Canadair CL-84 Dynavert' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET stealth_level = 'tres_elevee'  WHERE name = 'Northrop Tacit Blue' AND stealth_level IS DISTINCT FROM 'tres_elevee';
UPDATE airplanes SET stealth_level = 'aucune'       WHERE name = 'Lockheed Martin X-59 QueSST' AND stealth_level IS DISTINCT FROM 'aucune';

-- ═══ 4. Crédits photo ════════════════════════════════════════════════════
--
-- Renseignés pour les fiches dont la source est documentée. Les fiches
-- antérieures, d'origine non tracée, restent à NULL : aucune légende ne
-- s'affiche alors, plutôt qu'un crédit inventé.

UPDATE airplanes SET image_credit = 'Clemens Vasters from Viersen, Germany', image_licence = 'CC BY 2.0' WHERE name = 'A-1 Skyraider' AND (image_credit, image_licence) IS DISTINCT FROM ('Clemens Vasters from Viersen, Germany', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'A-26 Invader' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'A-3 Skywarrior' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'TSGT KEN HAMMOND', image_licence = 'Public domain' WHERE name = 'A-37 Dragonfly' AND (image_credit, image_licence) IS DISTINCT FROM ('TSGT KEN HAMMOND', 'Public domain');
UPDATE airplanes SET image_credit = 'Lt.JG Nelson, U.S. Navy', image_licence = 'Public domain' WHERE name = 'A-4 Skyhawk' AND (image_credit, image_licence) IS DISTINCT FROM ('Lt.JG Nelson, U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA Dryden Flight Research Center', image_licence = 'Public domain' WHERE name = 'A-5 Vigilante' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA Dryden Flight Research Center', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'A-6 Intruder' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Robert L. Lawson, U.S. Navy', image_licence = 'Public domain' WHERE name = 'A-7 Corsair II' AND (image_credit, image_licence) IS DISTINCT FROM ('Robert L. Lawson, U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'MSgt Christopher Boitz', image_licence = 'Public domain' WHERE name = 'AC-130 Spectre' AND (image_credit, image_licence) IS DISTINCT FROM ('MSgt Christopher Boitz', 'Public domain');
UPDATE airplanes SET image_credit = '玄史生', image_licence = 'CC BY-SA 4.0' WHERE name = 'AIDC AT-3 Tzu Chung' AND (image_credit, image_licence) IS DISTINCT FROM ('玄史生', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'RudolphChen', image_licence = 'CC BY-SA 4.0' WHERE name = 'AIDC F-CK-1 Ching-kuo' AND (image_credit, image_licence) IS DISTINCT FROM ('RudolphChen', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = '廢柴老闆', image_licence = 'CC0' WHERE name = 'AIDC T-5 Brave Eagle' AND (image_credit, image_licence) IS DISTINCT FROM ('廢柴老闆', 'CC0');
UPDATE airplanes SET image_credit = 'Sgt. David Ornelas Baeza', image_licence = 'Public domain' WHERE name = 'AV-8B Harrier II' AND (image_credit, image_licence) IS DISTINCT FROM ('Sgt. David Ornelas Baeza', 'Public domain');
UPDATE airplanes SET image_credit = 'Adrian Pingstone ( Arpingstone )', image_licence = 'Public domain' WHERE name = 'Aeritalia G.222' AND (image_credit, image_licence) IS DISTINCT FROM ('Adrian Pingstone ( Arpingstone )', 'Public domain');
UPDATE airplanes SET image_credit = 'Peter Ellis', image_licence = 'CC BY-SA 4.0' WHERE name = 'Aermacchi MB-326' AND (image_credit, image_licence) IS DISTINCT FROM ('Peter Ellis', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Milan Nykodym from Kutna Hora, Czech Republic', image_licence = 'CC BY-SA 2.0' WHERE name = 'Aero L-159 ALCA' AND (image_credit, image_licence) IS DISTINCT FROM ('Milan Nykodym from Kutna Hora, Czech Republic', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Oren Rozen', image_licence = 'CC BY-SA 3.0' WHERE name = 'Aero L-29 Delfín' AND (image_credit, image_licence) IS DISTINCT FROM ('Oren Rozen', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'U.S. Navy photo', image_licence = 'Public domain' WHERE name = 'Aero L-39 Albatros' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy photo', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force photo by Christian Turner', image_licence = 'Public domain' WHERE name = 'Airbus A330 MRTT' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force photo by Christian Turner', 'Public domain');
UPDATE airplanes SET image_credit = 'Peng Chen', image_licence = 'CC BY-SA 4.0' WHERE name = 'Airbus A400M Atlas' AND (image_credit, image_licence) IS DISTINCT FROM ('Peng Chen', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Steve Lynes', image_licence = 'CC BY 2.0' WHERE name = 'Alenia C-27J Spartan' AND (image_credit, image_licence) IS DISTINCT FROM ('Steve Lynes', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Antonov An-12' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Md Shaifuzzaman Ayon', image_licence = 'CC BY-SA 4.0' WHERE name = 'Antonov An-124 Ruslan' AND (image_credit, image_licence) IS DISTINCT FROM ('Md Shaifuzzaman Ayon', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson', image_licence = 'CC BY-SA 2.0' WHERE name = 'Antonov An-2' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Navigator-avia', image_licence = 'CC BY-SA 3.0' WHERE name = 'Antonov An-22 Antei' AND (image_credit, image_licence) IS DISTINCT FROM ('Navigator-avia', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Oleg V. Belyakov - AirTeamImages', image_licence = 'CC BY-SA 3.0' WHERE name = 'Antonov An-26' AND (image_credit, image_licence) IS DISTINCT FROM ('Oleg V. Belyakov - AirTeamImages', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Dmitry Karpezo', image_licence = 'CC BY-SA 3.0' WHERE name = 'Antonov An-32' AND (image_credit, image_licence) IS DISTINCT FROM ('Dmitry Karpezo', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Aeroprints.com', image_licence = 'CC BY-SA 3.0' WHERE name = 'Antonov An-72' AND (image_credit, image_licence) IS DISTINCT FROM ('Aeroprints.com', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Bob Adams from George, South Africa', image_licence = 'CC BY-SA 2.0' WHERE name = 'Atlas Cheetah' AND (image_credit, image_licence) IS DISTINCT FROM ('Bob Adams from George, South Africa', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Atlas Impala' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Canoe1967', image_licence = 'CC BY 3.0' WHERE name = 'Avro Canada CF-100 Canuck' AND (image_credit, image_licence) IS DISTINCT FROM ('Canoe1967', 'CC BY 3.0');
UPDATE airplanes SET image_credit = 'Unknown photographer, copyright originally held by the Government of Canada', image_licence = 'Public domain' WHERE name = 'Avro Canada CF-105 Arrow' AND (image_credit, image_licence) IS DISTINCT FROM ('Unknown photographer, copyright originally held by the Government of Canada', 'Public domain');
UPDATE airplanes SET image_credit = 'RAF', image_licence = 'Public domain' WHERE name = 'Avro Shackleton' AND (image_credit, image_licence) IS DISTINCT FROM ('RAF', 'Public domain');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'B-21 Raider' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'B-29 Superfortress' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'B-36 Peacemaker' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'US Air Force photo', image_licence = 'Public domain' WHERE name = 'B-47 Stratojet' AND (image_credit, image_licence) IS DISTINCT FROM ('US Air Force photo', 'Public domain');
UPDATE airplanes SET image_credit = 'United States Air Force', image_licence = 'Public domain' WHERE name = 'B-58 Hustler' AND (image_credit, image_licence) IS DISTINCT FROM ('United States Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'BAC TSR-2' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Tim Felce (Airwolfhound)', image_licence = 'CC BY-SA 2.0' WHERE name = 'BAE Hawk' AND (image_credit, image_licence) IS DISTINCT FROM ('Tim Felce (Airwolfhound)', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Bayhaluk', image_licence = 'CC BY-SA 4.0' WHERE name = 'Bayraktar TB2' AND (image_credit, image_licence) IS DISTINCT FROM ('Bayhaluk', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = NULL, image_licence = 'Public domain' WHERE name = 'Bell X-1' AND (image_credit, image_licence) IS DISTINCT FROM (NULL, 'Public domain');
UPDATE airplanes SET image_credit = 'NASA Ames Research Center / Art Melliar', image_licence = 'Public domain' WHERE name = 'Bell X-14' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA Ames Research Center / Art Melliar', 'Public domain');
UPDATE airplanes SET image_credit = 'Ludvig14', image_licence = 'CC BY-SA 4.0' WHERE name = 'Beriev A-50' AND (image_credit, image_licence) IS DISTINCT FROM ('Ludvig14', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'U.S. Navy photo by Mass Communication Specialist 2nd Class John Herman', image_licence = 'Public domain' WHERE name = 'Beriev Be-12 Chaïka' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy photo by Mass Communication Specialist 2nd Class John Herman', 'Public domain');
UPDATE airplanes SET image_credit = 'New York-air', image_licence = 'CC BY-SA 4.0' WHERE name = 'Beriev Be-200' AND (image_credit, image_licence) IS DISTINCT FROM ('New York-air', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'Boeing X-32' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'Clément Gruin', image_licence = 'CC BY-SA 4.0' WHERE name = 'Breguet Alizé' AND (image_credit, image_licence) IS DISTINCT FROM ('Clément Gruin', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'U.S. Department of Defense', image_licence = 'Public domain' WHERE name = 'Breguet Atlantique' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Department of Defense', 'Public domain');
UPDATE airplanes SET image_credit = 'Jerry Gunner', image_licence = 'CC BY-SA 4.0' WHERE name = 'Britten-Norman Defender' AND (image_credit, image_licence) IS DISTINCT FROM ('Jerry Gunner', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'United States Air Force', image_licence = 'Public domain' WHERE name = 'C-119 Flying Boxcar' AND (image_credit, image_licence) IS DISTINCT FROM ('United States Air Force', 'Public domain');
UPDATE airplanes SET image_credit = '<div class="fn value"> U.S. Air Force photo by Tech. Sgt. Howard Blair</div>', image_licence = 'Public domain' WHERE name = 'C-130 Hercules' AND (image_credit, image_licence) IS DISTINCT FROM ('<div class="fn value"> U.S. Air Force photo by Tech. Sgt. Howard Blair</div>', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Department of Defense', image_licence = 'Public domain' WHERE name = 'C-141 Starlifter' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Department of Defense', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'C-17 Globemaster III' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'LCdr. John R. Leenhouts, U.S. Navy', image_licence = 'Public domain' WHERE name = 'C-2 Greyhound' AND (image_credit, image_licence) IS DISTINCT FROM ('LCdr. John R. Leenhouts, U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Roland Balik', image_licence = 'Public domain' WHERE name = 'C-5 Galaxy' AND (image_credit, image_licence) IS DISTINCT FROM ('Roland Balik', 'Public domain');
UPDATE airplanes SET image_credit = 'Stephen Edmonds from Melbourne, Australia', image_licence = 'CC BY-SA 2.0' WHERE name = 'CAC CA-27 Sabre' AND (image_credit, image_licence) IS DISTINCT FROM ('Stephen Edmonds from Melbourne, Australia', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Photo by Senior Airman Renee Nicole Finona / 48th Fighter Wing', image_licence = 'Public domain' WHERE name = 'CASA C-101 Aviojet' AND (image_credit, image_licence) IS DISTINCT FROM ('Photo by Senior Airman Renee Nicole Finona / 48th Fighter Wing', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'CASA C-212 Aviocar' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'William Murphy from Dublin, Ireland', image_licence = 'CC BY-SA 2.0' WHERE name = 'CASA/IPTN CN-235' AND (image_credit, image_licence) IS DISTINCT FROM ('William Murphy from Dublin, Ireland', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Airman Jacob B. Wrightsman', image_licence = 'Public domain' WHERE name = 'Canadair CT-114 Tutor' AND (image_credit, image_licence) IS DISTINCT FROM ('Airman Jacob B. Wrightsman', 'Public domain');
UPDATE airplanes SET image_credit = 'NACA', image_licence = 'Public domain' WHERE name = 'D-558-2 Skyrocket' AND (image_credit, image_licence) IS DISTINCT FROM ('NACA', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Weston, Spalding, Lincs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'DHC-4 Caribou' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Weston, Spalding, Lincs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Nik Deblauwe', image_licence = 'CC BY-SA 2.0' WHERE name = 'DHC-5 Buffalo' AND (image_credit, image_licence) IS DISTINCT FROM ('Nik Deblauwe', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Lionel Allorge', image_licence = 'CC BY-SA 3.0' WHERE name = 'Dassault MD 315 Flamant' AND (image_credit, image_licence) IS DISTINCT FROM ('Lionel Allorge', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Thomas Vogt from Paderborn, Deutschland', image_licence = 'CC BY 2.0' WHERE name = 'Dornier Do 28 Skyservant' AND (image_credit, image_licence) IS DISTINCT FROM ('Thomas Vogt from Paderborn, Deutschland', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Clemens Vasters from Viersen, Germany, Germany', image_licence = 'CC BY 2.0' WHERE name = 'Dornier Do 31' AND (image_credit, image_licence) IS DISTINCT FROM ('Clemens Vasters from Viersen, Germany, Germany', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'US Navy', image_licence = 'Public domain' WHERE name = 'E-2 Hawkeye' AND (image_credit, image_licence) IS DISTINCT FROM ('US Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Ronnie Macdonald from Chelmsford and Largs, United Kingdom', image_licence = 'CC BY 2.0' WHERE name = 'E-3 Sentry' AND (image_credit, image_licence) IS DISTINCT FROM ('Ronnie Macdonald from Chelmsford and Largs, United Kingdom', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Noah Wulf', image_licence = 'CC BY-SA 4.0' WHERE name = 'EA-18G Growler' AND (image_credit, image_licence) IS DISTINCT FROM ('Noah Wulf', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Cpl. Neysa Huertas Quinones', image_licence = 'Public domain' WHERE name = 'EA-6B Prowler' AND (image_credit, image_licence) IS DISTINCT FROM ('Cpl. Neysa Huertas Quinones', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Weston, Spalding, Lincs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'EC-121 Warning Star' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Weston, Spalding, Lincs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Dick Gilbert', image_licence = 'CC BY 2.0' WHERE name = 'ENAER T-35 Pillán' AND (image_credit, image_licence) IS DISTINCT FROM ('Dick Gilbert', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Jmcc150 at English Wikipedia', image_licence = 'Public domain' WHERE name = 'EWR VJ 101' AND (image_credit, image_licence) IS DISTINCT FROM ('Jmcc150 at English Wikipedia', 'Public domain');
UPDATE airplanes SET image_credit = 'Tangopaso', image_licence = 'CC BY-SA 3.0' WHERE name = 'Elbit Hermes 900' AND (image_credit, image_licence) IS DISTINCT FROM ('Tangopaso', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Andre Gustavo Stumpf Filho from Brasil', image_licence = 'CC BY 2.0' WHERE name = 'Embraer E-99' AND (image_credit, image_licence) IS DISTINCT FROM ('Andre Gustavo Stumpf Filho from Brasil', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Sebastián Laguna', image_licence = 'CC BY 2.0' WHERE name = 'Embraer EMB-110 Bandeirante' AND (image_credit, image_licence) IS DISTINCT FROM ('Sebastián Laguna', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Matti Blume', image_licence = 'CC BY-SA 4.0' WHERE name = 'Embraer KC-390 Millennium' AND (image_credit, image_licence) IS DISTINCT FROM ('Matti Blume', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Daniel Z97', image_licence = 'CC BY 4.0' WHERE name = 'English Electric Canberra' AND (image_credit, image_licence) IS DISTINCT FROM ('Daniel Z97', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Michaela Pereckas', image_licence = 'CC BY 2.0' WHERE name = 'F-100 Super Sabre' AND (image_credit, image_licence) IS DISTINCT FROM ('Michaela Pereckas', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'F-101 Voodoo' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'United States Air Force Photo', image_licence = 'Public domain' WHERE name = 'F-102 Delta Dagger' AND (image_credit, image_licence) IS DISTINCT FROM ('United States Air Force Photo', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson', image_licence = 'CC BY-SA 2.0' WHERE name = 'F-104 Starfighter' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'F-105 Thunderchief' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'Staff Sgt. John K. McDowell', image_licence = 'Public domain' WHERE name = 'F-106 Delta Dart' AND (image_credit, image_licence) IS DISTINCT FROM ('Staff Sgt. John K. McDowell', 'Public domain');
UPDATE airplanes SET image_credit = 'Staff Sgt. Aaron Allmon II', image_licence = 'Public domain' WHERE name = 'F-117 Nighthawk' AND (image_credit, image_licence) IS DISTINCT FROM ('Staff Sgt. Aaron Allmon II', 'Public domain');
UPDATE airplanes SET image_credit = 'Airman 1st Class Matthew Seefeldt', image_licence = 'Public domain' WHERE name = 'F-15 Eagle' AND (image_credit, image_licence) IS DISTINCT FROM ('Airman 1st Class Matthew Seefeldt', 'Public domain');
UPDATE airplanes SET image_credit = 'Ethan Wagner', image_licence = 'Public domain' WHERE name = 'F-15EX Eagle II' AND (image_credit, image_licence) IS DISTINCT FROM ('Ethan Wagner', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA/Carla Thomas', image_licence = 'Public domain' WHERE name = 'F-16XL' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA/Carla Thomas', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'F-20 Tigershark' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Glenn Research Center (NASA/DFRC)', image_licence = 'Public domain' WHERE name = 'F-8 Crusader' AND (image_credit, image_licence) IS DISTINCT FROM ('Glenn Research Center (NASA/DFRC)', 'Public domain');
UPDATE airplanes SET image_credit = 'Eric Salard', image_licence = 'CC BY-SA 2.0' WHERE name = 'F-80 Shooting Star' AND (image_credit, image_licence) IS DISTINCT FROM ('Eric Salard', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = NULL, image_licence = 'Public domain' WHERE name = 'F-82 Twin Mustang' AND (image_credit, image_licence) IS DISTINCT FROM (NULL, 'Public domain');
UPDATE airplanes SET image_credit = 'Clemens Vasters from Viersen, Germany, Germany', image_licence = 'CC BY 2.0' WHERE name = 'F-84F Thunderstreak' AND (image_credit, image_licence) IS DISTINCT FROM ('Clemens Vasters from Viersen, Germany, Germany', 'CC BY 2.0');
UPDATE airplanes SET image_credit = '205weeman17', image_licence = 'CC BY-SA 3.0' WHERE name = 'F-86 Sabre' AND (image_credit, image_licence) IS DISTINCT FROM ('205weeman17', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'F-89 Scorpion' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'F-94 Starfire' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'Cmdr. John Leenhouts, USN', image_licence = 'Public domain' WHERE name = 'F/A-18 Hornet' AND (image_credit, image_licence) IS DISTINCT FROM ('Cmdr. John Leenhouts, USN', 'Public domain');
UPDATE airplanes SET image_credit = 'Petty Officer 1st Class David Mercil, U.S. Navy', image_licence = 'Public domain' WHERE name = 'F/A-18E Super Hornet' AND (image_credit, image_licence) IS DISTINCT FROM ('Petty Officer 1st Class David Mercil, U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F11F Tiger' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F2Y Sea Dart' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F3D Skyknight' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F4D Skyray' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F7U Cutlass' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F9F Cougar' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'F9F Panther' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'Comet Photo AG', image_licence = 'CC BY-SA 4.0' WHERE name = 'FFA P-16' AND (image_credit, image_licence) IS DISTINCT FROM ('Comet Photo AG', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Clemens Vasters from Viersen, Germany, Germany', image_licence = 'CC BY 2.0' WHERE name = 'FMA IA 58 Pucará' AND (image_credit, image_licence) IS DISTINCT FROM ('Clemens Vasters from Viersen, Germany, Germany', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'JO2 Pete Hatzakos', image_licence = 'Public domain' WHERE name = 'FMA IA 63 Pampa' AND (image_credit, image_licence) IS DISTINCT FROM ('JO2 Pete Hatzakos', 'Public domain');
UPDATE airplanes SET image_credit = 'Hugh Llewelyn from Keynsham, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Fairey Delta 2' AND (image_credit, image_licence) IS DISTINCT FROM ('Hugh Llewelyn from Keynsham, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Ken Mist from Brampton, Canada', image_licence = 'CC BY-SA 2.0' WHERE name = 'Fairey Firefly' AND (image_credit, image_licence) IS DISTINCT FROM ('Ken Mist from Brampton, Canada', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'thinboyfatter', image_licence = 'CC BY 2.0' WHERE name = 'Fairey Gannet' AND (image_credit, image_licence) IS DISTINCT FROM ('thinboyfatter', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Master Sgt. H.D. Robinson, U.S. Air Force photo 342-C-KE-62474', image_licence = 'Public domain' WHERE name = 'Fiat G.91' AND (image_credit, image_licence) IS DISTINCT FROM ('Master Sgt. H.D. Robinson, U.S. Air Force photo 342-C-KE-62474', 'Public domain');
UPDATE airplanes SET image_credit = 'Aero Icarus from Zürich, Switzerland', image_licence = 'CC BY-SA 2.0' WHERE name = 'Fokker F27 Maritime' AND (image_credit, image_licence) IS DISTINCT FROM ('Aero Icarus from Zürich, Switzerland', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'André Gerwing', image_licence = 'CC BY-SA 4.0' WHERE name = 'Fokker S.14 Machtrainer' AND (image_credit, image_licence) IS DISTINCT FROM ('André Gerwing', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Michael Gaylard from Horsham, UK', image_licence = 'CC BY 2.0' WHERE name = 'Folland Gnat' AND (image_credit, image_licence) IS DISTINCT FROM ('Michael Gaylard from Horsham, UK', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Ad Meskens You are free to use this picture for any purpose as long as you credit its author, Ad Meskens . Exa', image_licence = 'CC BY-SA 4.0' WHERE name = 'Fouga CM.170 Magister' AND (image_credit, image_licence) IS DISTINCT FROM ('Ad Meskens You are free to use this picture for any purpose as long as you credit its author, Ad Meskens . Exa', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Jerry Gunner from Lincoln, UK', image_licence = 'CC BY 2.0' WHERE name = 'Fuji T-7' AND (image_credit, image_licence) IS DISTINCT FROM ('Jerry Gunner from Lincoln, UK', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Jonathan Rabbitt', image_licence = 'CC BY 3.0' WHERE name = 'GAF Jindivik' AND (image_credit, image_licence) IS DISTINCT FROM ('Jonathan Rabbitt', 'CC BY 3.0');
UPDATE airplanes SET image_credit = 'Z3144228', image_licence = 'CC BY-SA 4.0' WHERE name = 'GAF Nomad' AND (image_credit, image_licence) IS DISTINCT FROM ('Z3144228', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'tormentor4555', image_licence = 'PDM-owner' WHERE name = 'Gloster Javelin' AND (image_credit, image_licence) IS DISTINCT FROM ('tormentor4555', 'PDM-owner');
UPDATE airplanes SET image_credit = 'Clemens Vasters from Viersen, Germany, Germany', image_licence = 'CC BY 2.0' WHERE name = 'Gloster Meteor' AND (image_credit, image_licence) IS DISTINCT FROM ('Clemens Vasters from Viersen, Germany, Germany', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'N509FZ', image_licence = 'CC BY-SA 4.0' WHERE name = 'Guizhou JL-9' AND (image_credit, image_licence) IS DISTINCT FROM ('N509FZ', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Aeroprints.com', image_licence = 'CC BY-SA 3.0' WHERE name = 'HAL HJT-36 Sitara' AND (image_credit, image_licence) IS DISTINCT FROM ('Aeroprints.com', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Shahram Sharifi', image_licence = 'CC BY-SA 4.0' WHERE name = 'HESA Saeqeh' AND (image_credit, image_licence) IS DISTINCT FROM ('Shahram Sharifi', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'JoachimKohler-HB', image_licence = 'CC BY-SA 4.0' WHERE name = 'HFB 320 Hansa Jet' AND (image_credit, image_licence) IS DISTINCT FROM ('JoachimKohler-HB', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Photo by LT. COL. PAUL BACKS', image_licence = 'Public domain' WHERE name = 'Handley Page Victor' AND (image_credit, image_licence) IS DISTINCT FROM ('Photo by LT. COL. PAUL BACKS', 'Public domain');
UPDATE airplanes SET image_credit = 'Tim Felce (Airwolfhound)', image_licence = 'CC BY-SA 2.0' WHERE name = 'Hawker Hunter' AND (image_credit, image_licence) IS DISTINCT FROM ('Tim Felce (Airwolfhound)', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'Hawker P.1127 Kestrel' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'Smudge 9000 from North Kent Coast, England', image_licence = 'CC BY 2.0' WHERE name = 'Hawker Sea Hawk' AND (image_credit, image_licence) IS DISTINCT FROM ('Smudge 9000 from North Kent Coast, England', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Colin Cooke Photo', image_licence = 'CC BY-SA 4.0' WHERE name = 'Hawker Siddeley Nimrod' AND (image_credit, image_licence) IS DISTINCT FROM ('Colin Cooke Photo', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'High Contrast', image_licence = 'CC BY 3.0 de' WHERE name = 'Helwan HA-300' AND (image_credit, image_licence) IS DISTINCT FROM ('High Contrast', 'CC BY 3.0 de');
UPDATE airplanes SET image_credit = 'Bene Riobó', image_licence = 'CC BY-SA 4.0' WHERE name = 'Hispano HA-200 Saeta' AND (image_credit, image_licence) IS DISTINCT FROM ('Bene Riobó', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Kurush Pawar from Dubai, United Arab Emirates', image_licence = 'CC BY-SA 2.0' WHERE name = 'Hongdu K-8 Karakorum' AND (image_credit, image_licence) IS DISTINCT FROM ('Kurush Pawar from Dubai, United Arab Emirates', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Z3144228', image_licence = 'CC0' WHERE name = 'Hongdu L-15' AND (image_credit, image_licence) IS DISTINCT FROM ('Z3144228', 'CC0');
UPDATE airplanes SET image_credit = 'Photographer: Mosbatho', image_licence = 'CC BY 4.0' WHERE name = 'IAI Arava' AND (image_credit, image_licence) IS DISTINCT FROM ('Photographer: Mosbatho', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Matti Blume', image_licence = 'CC BY-SA 4.0' WHERE name = 'IAI Harop' AND (image_credit, image_licence) IS DISTINCT FROM ('Matti Blume', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'SSGT REYNALDO RAMON', image_licence = 'Public domain' WHERE name = 'IAI Heron' AND (image_credit, image_licence) IS DISTINCT FROM ('SSGT REYNALDO RAMON', 'Public domain');
UPDATE airplanes SET image_credit = 'Cătălin Cocîrlă', image_licence = 'CC BY-SA 4.0' WHERE name = 'IAR-99 Șoim' AND (image_credit, image_licence) IS DISTINCT FROM ('Cătălin Cocîrlă', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Il-28' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Artem Katranzhi', image_licence = 'CC BY-SA 2.0' WHERE name = 'Iliouchine Il-114' AND (image_credit, image_licence) IS DISTINCT FROM ('Artem Katranzhi', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Iliouchine Il-20' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Photographer''s Name: Lt. David M. Kennedy, USN', image_licence = 'Public domain' WHERE name = 'Iliouchine Il-38' AND (image_credit, image_licence) IS DISTINCT FROM ('Photographer''s Name: Lt. David M. Kennedy, USN', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Iliouchine Il-76' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Staff Sgt. Gerald Currington.', image_licence = 'Public domain' WHERE name = 'Iliouchine Il-78 Midas' AND (image_credit, image_licence) IS DISTINCT FROM ('Staff Sgt. Gerald Currington.', 'Public domain');
UPDATE airplanes SET image_credit = 'Hugh Llewelyn from Keynsham, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Jet Provost' AND (image_credit, image_licence) IS DISTINCT FROM ('Hugh Llewelyn from Keynsham, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Staff Sgt. Anthony Small', image_licence = 'Public domain' WHERE name = 'KAI FA-50' AND (image_credit, image_licence) IS DISTINCT FROM ('Staff Sgt. Anthony Small', 'Public domain');
UPDATE airplanes SET image_credit = '대한민국 국방부 - Ministry of National Defense of the Republic of Korea', image_licence = 'KOGL Type 1' WHERE name = 'KAI KF-21 Boramae' AND (image_credit, image_licence) IS DISTINCT FROM ('대한민국 국방부 - Ministry of National Defense of the Republic of Korea', 'KOGL Type 1');
UPDATE airplanes SET image_credit = 'Doo Ho Kim', image_licence = 'CC BY-SA 2.0' WHERE name = 'KAI KT-1 Woongbi' AND (image_credit, image_licence) IS DISTINCT FROM ('Doo Ho Kim', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Senior Airman Mitchell Corley', image_licence = 'Public domain' WHERE name = 'KAI T-50 Golden Eagle' AND (image_credit, image_licence) IS DISTINCT FROM ('Senior Airman Mitchell Corley', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force photo by Staff Sgt. Jerry Morrison', image_licence = 'Public domain' WHERE name = 'KC-10 Extender' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force photo by Staff Sgt. Jerry Morrison', 'Public domain');
UPDATE airplanes SET image_credit = 'Ronnie Macdonald from Chelmsford and Largs, United Kingdom', image_licence = 'CC BY 2.0' WHERE name = 'KC-135 Stratotanker' AND (image_credit, image_licence) IS DISTINCT FROM ('Ronnie Macdonald from Chelmsford and Largs, United Kingdom', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'USAF Christopher Okula', image_licence = 'Public domain' WHERE name = 'KC-46 Pegasus' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF Christopher Okula', 'Public domain');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'KC-97 Stratofreighter' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'Jerry Gunner from Lincoln, UK', image_licence = 'CC BY 2.0' WHERE name = 'Kawasaki C-1' AND (image_credit, image_licence) IS DISTINCT FROM ('Jerry Gunner from Lincoln, UK', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Hunini', image_licence = 'CC BY-SA 4.0' WHERE name = 'Kawasaki C-2' AND (image_credit, image_licence) IS DISTINCT FROM ('Hunini', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = '海上自衛隊', image_licence = 'CC BY 4.0' WHERE name = 'Kawasaki P-1' AND (image_credit, image_licence) IS DISTINCT FROM ('海上自衛隊', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Jerry Gunner from Lincoln, UK', image_licence = 'CC BY 2.0' WHERE name = 'Kawasaki T-4' AND (image_credit, image_licence) IS DISTINCT FROM ('Jerry Gunner from Lincoln, UK', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'LTV XC-142' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'La-15' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Raf24~commonswiki', image_licence = 'CC BY-SA 4.0' WHERE name = 'Let L-410 Turbolet' AND (image_credit, image_licence) IS DISTINCT FROM ('Raf24~commonswiki', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'U.S.Air Force', image_licence = 'Public domain' WHERE name = 'Lockheed A-12' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S.Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'Lockheed D-21' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = 'ZLEA', image_licence = 'CC BY-SA 4.0' WHERE name = 'Lockheed XFV' AND (image_credit, image_licence) IS DISTINCT FROM ('ZLEA', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Myself ( Adrian Pingstone ).', image_licence = 'Public domain' WHERE name = 'M-346 Master' AND (image_credit, image_licence) IS DISTINCT FROM ('Myself ( Adrian Pingstone ).', 'Public domain');
UPDATE airplanes SET image_credit = 'Petty Officer 3rd Class Jeffrey S. Viano, U.S. Navy', image_licence = 'Public domain' WHERE name = 'MQ-1 Predator' AND (image_credit, image_licence) IS DISTINCT FROM ('Petty Officer 3rd Class Jeffrey S. Viano, U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'United States Navy photo courtesy of Boeing', image_licence = 'Public domain' WHERE name = 'MQ-25 Stingray' AND (image_credit, image_licence) IS DISTINCT FROM ('United States Navy photo courtesy of Boeing', 'Public domain');
UPDATE airplanes SET image_credit = 'Lt. Col. Leslie Pratt', image_licence = 'Public domain' WHERE name = 'MQ-9 Reaper' AND (image_credit, image_licence) IS DISTINCT FROM ('Lt. Col. Leslie Pratt', 'Public domain');
UPDATE airplanes SET image_credit = 'Hornet Driver', image_licence = 'CC BY-SA 4.0' WHERE name = 'MiG 1.44' AND (image_credit, image_licence) IS DISTINCT FROM ('Hornet Driver', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alf van Beem', image_licence = 'CC0' WHERE name = 'MiG-15' AND (image_credit, image_licence) IS DISTINCT FROM ('Alf van Beem', 'CC0');
UPDATE airplanes SET image_credit = 'Balon Greyjoy', image_licence = 'CC0' WHERE name = 'MiG-17' AND (image_credit, image_licence) IS DISTINCT FROM ('Balon Greyjoy', 'CC0');
UPDATE airplanes SET image_credit = 'U.S. Air Force photo', image_licence = 'Public domain' WHERE name = 'MiG-19' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force photo', 'Public domain');
UPDATE airplanes SET image_credit = 'Ronnie Macdonald from Chelmsford and Largs, United Kingdom', image_licence = 'CC BY 2.0' WHERE name = 'MiG-27' AND (image_credit, image_licence) IS DISTINCT FROM ('Ronnie Macdonald from Chelmsford and Largs, United Kingdom', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Doomych', image_licence = 'Public domain' WHERE name = 'MiG-35' AND (image_credit, image_licence) IS DISTINCT FROM ('Doomych', 'Public domain');
UPDATE airplanes SET image_credit = 'Mike1979 Russia', image_licence = 'CC BY-SA 3.0' WHERE name = 'MiG-9' AND (image_credit, image_licence) IS DISTINCT FROM ('Mike1979 Russia', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Acroterion', image_licence = 'CC BY-SA 4.0' WHERE name = 'Mirage 4000' AND (image_credit, image_licence) IS DISTINCT FROM ('Acroterion', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Anidaat', image_licence = 'CC BY-SA 4.0' WHERE name = 'Mirage 5' AND (image_credit, image_licence) IS DISTINCT FROM ('Anidaat', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Mirage G8' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Duch.seb', image_licence = 'CC BY-SA 3.0' WHERE name = 'Mirage III V' AND (image_credit, image_licence) IS DISTINCT FROM ('Duch.seb', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'SSGT Terry Smith', image_licence = 'Public domain' WHERE name = 'Mitsubishi F-104J' AND (image_credit, image_licence) IS DISTINCT FROM ('SSGT Terry Smith', 'Public domain');
UPDATE airplanes SET image_credit = 'Mike1979 Russia', image_licence = 'CC BY-SA 3.0' WHERE name = 'Myasishchev M-4' AND (image_credit, image_licence) IS DISTINCT FROM ('Mike1979 Russia', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Myasishchev M-50' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Oleg V. Belyakov - AirTeamImages', image_licence = 'CC BY-SA 3.0' WHERE name = 'Myasishchev M-55' AND (image_credit, image_licence) IS DISTINCT FROM ('Oleg V. Belyakov - AirTeamImages', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Jean-Christophe BENOIST', image_licence = 'CC BY-SA 3.0' WHERE name = 'Mystère IV' AND (image_credit, image_licence) IS DISTINCT FROM ('Jean-Christophe BENOIST', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = '颐园居', image_licence = 'CC BY-SA 4.0' WHERE name = 'Nanchang CJ-6' AND (image_credit, image_licence) IS DISTINCT FROM ('颐园居', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Thomas Vogt from Paderborn, Deutschland', image_licence = 'CC BY 2.0' WHERE name = 'Nord Noratlas' AND (image_credit, image_licence) IS DISTINCT FROM ('Thomas Vogt from Paderborn, Deutschland', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Christopher M. Reed', image_licence = 'CC BY 4.0' WHERE name = 'OV-1 Mohawk' AND (image_credit, image_licence) IS DISTINCT FROM ('Christopher M. Reed', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'OV-10 Bronco' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'Groumfy69', image_licence = 'Public domain' WHERE name = 'Ouragan' AND (image_credit, image_licence) IS DISTINCT FROM ('Groumfy69', 'Public domain');
UPDATE airplanes SET image_credit = 'USN', image_licence = 'Public domain' WHERE name = 'P-2 Neptune' AND (image_credit, image_licence) IS DISTINCT FROM ('USN', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy photo by Petty Officer 2nd Class Alec Kramer', image_licence = 'Public domain' WHERE name = 'P-3 Orion' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy photo by Petty Officer 2nd Class Alec Kramer', 'Public domain');
UPDATE airplanes SET image_credit = 'Balon Greyjoy', image_licence = 'CC0' WHERE name = 'P-8 Poseidon' AND (image_credit, image_licence) IS DISTINCT FROM ('Balon Greyjoy', 'CC0');
UPDATE airplanes SET image_credit = 'Mztourist', image_licence = 'CC BY-SA 4.0' WHERE name = 'PAC Super Mushshak' AND (image_credit, image_licence) IS DISTINCT FROM ('Mztourist', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'PZL M28 Skytruck' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Leafnode , original by Lukas skywalker', image_licence = 'CC BY-SA 4.0' WHERE name = 'PZL TS-11 Iskra' AND (image_credit, image_licence) IS DISTINCT FROM ('Leafnode , original by Lukas skywalker', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson', image_licence = 'CC BY-SA 2.0' WHERE name = 'PZL-130 Orlik' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'GerardvdSchaaf', image_licence = 'CC BY 4.0' WHERE name = 'Pilatus PC-7' AND (image_credit, image_licence) IS DISTINCT FROM ('GerardvdSchaaf', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Matti Blume', image_licence = 'CC BY-SA 4.0' WHERE name = 'Pilatus PC-9' AND (image_credit, image_licence) IS DISTINCT FROM ('Matti Blume', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Tangopaso', image_licence = 'CC BY-SA 3.0' WHERE name = 'RQ-4 Global Hawk' AND (image_credit, image_licence) IS DISTINCT FROM ('Tangopaso', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'North American Aviation', image_licence = 'Public domain' WHERE name = 'Rockwell XFV-12' AND (image_credit, image_licence) IS DISTINCT FROM ('North American Aviation', 'Public domain');
UPDATE airplanes SET image_credit = 'SSGT DANIEL PEREZ', image_licence = 'Public domain' WHERE name = 'Ryan Firebee' AND (image_credit, image_licence) IS DISTINCT FROM ('SSGT DANIEL PEREZ', 'Public domain');
UPDATE airplanes SET image_credit = 'US Navy', image_licence = 'Public domain' WHERE name = 'S-3 Viking' AND (image_credit, image_licence) IS DISTINCT FROM ('US Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Philippine Air Force', image_licence = 'Public domain' WHERE name = 'SF.260' AND (image_credit, image_licence) IS DISTINCT FROM ('Philippine Air Force', 'Public domain');
UPDATE airplanes SET image_credit = '123-photos', image_licence = 'CC BY-SA 4.0' WHERE name = 'SOCATA TB-30 Epsilon' AND (image_credit, image_licence) IS DISTINCT FROM ('123-photos', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Matt Morgan', image_licence = 'CC BY-SA 2.0' WHERE name = 'Saab 105' AND (image_credit, image_licence) IS DISTINCT FROM ('Matt Morgan', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'TunaFish Spotting', image_licence = 'CC BY-SA 4.0' WHERE name = 'Saab 29 Tunnan' AND (image_credit, image_licence) IS DISTINCT FROM ('TunaFish Spotting', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Ronnie Macdonald from Chelmsford, United Kingdom', image_licence = 'CC BY 2.0' WHERE name = 'Saab 32 Lansen' AND (image_credit, image_licence) IS DISTINCT FROM ('Ronnie Macdonald from Chelmsford, United Kingdom', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Airwolfhound from Hertfordshire, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Saab GlobalEye' AND (image_credit, image_licence) IS DISTINCT FROM ('Airwolfhound from Hertfordshire, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Hugh Llewelyn from Keynsham, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Saunders-Roe SR.53' AND (image_credit, image_licence) IS DISTINCT FROM ('Hugh Llewelyn from Keynsham, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Adrian Pingstone', image_licence = 'Public domain' WHERE name = 'Scottish Aviation Bulldog' AND (image_credit, image_licence) IS DISTINCT FROM ('Adrian Pingstone', 'Public domain');
UPDATE airplanes SET image_credit = 'wallycacsabre', image_licence = 'CC BY 2.0' WHERE name = 'Sea Vixen' AND (image_credit, image_licence) IS DISTINCT FROM ('wallycacsabre', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Alert5', image_licence = 'CC BY-SA 4.0' WHERE name = 'Shaanxi Y-8' AND (image_credit, image_licence) IS DISTINCT FROM ('Alert5', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'TurnOnTheNight', image_licence = 'CC BY-SA 4.0' WHERE name = 'Shenyang J-35' AND (image_credit, image_licence) IS DISTINCT FROM ('TurnOnTheNight', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'ShinMaywa US-1A' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Eeldrorq', image_licence = 'CC0' WHERE name = 'ShinMaywa US-2' AND (image_credit, image_licence) IS DISTINCT FROM ('Eeldrorq', 'CC0');
UPDATE airplanes SET image_credit = 'wilford peloquin', image_licence = 'CC BY 2.0' WHERE name = 'Short SC.1' AND (image_credit, image_licence) IS DISTINCT FROM ('wilford peloquin', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Adrian Pingstone', image_licence = 'Public domain' WHERE name = 'Shorts Tucano' AND (image_credit, image_licence) IS DISTINCT FROM ('Adrian Pingstone', 'Public domain');
UPDATE airplanes SET image_credit = 'Bidgee', image_licence = 'CC BY-SA 3.0 au' WHERE name = 'Soko G-2 Galeb' AND (image_credit, image_licence) IS DISTINCT FROM ('Bidgee', 'CC BY-SA 3.0 au');
UPDATE airplanes SET image_credit = 'Rob Schleiffert from Holland', image_licence = 'CC BY-SA 2.0' WHERE name = 'Soko G-4 Super Galeb' AND (image_credit, image_licence) IS DISTINCT FROM ('Rob Schleiffert from Holland', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Srđan Popović', image_licence = 'CC BY-SA 4.0' WHERE name = 'Soko J-22 Orao' AND (image_credit, image_licence) IS DISTINCT FROM ('Srđan Popović', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Su-11' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'И. Руденко', image_licence = 'CC BY 4.0' WHERE name = 'Su-33' AND (image_credit, image_licence) IS DISTINCT FROM ('И. Руденко', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Su-7' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Alf van Beem', image_licence = 'Public domain' WHERE name = 'Su-9' AND (image_credit, image_licence) IS DISTINCT FROM ('Alf van Beem', 'Public domain');
UPDATE airplanes SET image_credit = 'Sergey Dukachev', image_licence = 'CC BY 2.5' WHERE name = 'Sukhoi T-4' AND (image_credit, image_licence) IS DISTINCT FROM ('Sergey Dukachev', 'CC BY 2.5');
UPDATE airplanes SET image_credit = 'Alf van Beem', image_licence = 'CC0' WHERE name = 'Super Mystère B2' AND (image_credit, image_licence) IS DISTINCT FROM ('Alf van Beem', 'CC0');
UPDATE airplanes SET image_credit = 'Alan Wilson', image_licence = 'CC BY-SA 2.0' WHERE name = 'Supermarine Attacker' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'TSRL', image_licence = 'CC BY-SA 3.0' WHERE name = 'Supermarine Scimitar' AND (image_credit, image_licence) IS DISTINCT FROM ('TSRL', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Supermarine Swift' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Pseudopanax at English Wikipedia', image_licence = 'Public domain' WHERE name = 'T-28 Trojan' AND (image_credit, image_licence) IS DISTINCT FROM ('Pseudopanax at English Wikipedia', 'Public domain');
UPDATE airplanes SET image_credit = 'Alejandro Pena Edited by: FOX 52 and Bammesk', image_licence = 'Public domain' WHERE name = 'T-33 Shooting Star' AND (image_credit, image_licence) IS DISTINCT FROM ('Alejandro Pena Edited by: FOX 52 and Bammesk', 'Public domain');
UPDATE airplanes SET image_credit = 'DON S. MONTGOMERY, USN (RET.)', image_licence = 'Public domain' WHERE name = 'T-34 Mentor' AND (image_credit, image_licence) IS DISTINCT FROM ('DON S. MONTGOMERY, USN (RET.)', 'Public domain');
UPDATE airplanes SET image_credit = 'Mike LaChance from Crowley, Tx, USA', image_licence = 'CC BY 2.0' WHERE name = 'T-37 Tweet' AND (image_credit, image_licence) IS DISTINCT FROM ('Mike LaChance from Crowley, Tx, USA', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Airman 1st Class Harrison Sullivan', image_licence = 'Public domain' WHERE name = 'T-38 Talon' AND (image_credit, image_licence) IS DISTINCT FROM ('Airman 1st Class Harrison Sullivan', 'Public domain');
UPDATE airplanes SET image_credit = 'United States Air Force', image_licence = 'Public domain' WHERE name = 'T-6 Texan II' AND (image_credit, image_licence) IS DISTINCT FROM ('United States Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Ibex73', image_licence = 'CC BY-SA 4.0' WHERE name = 'TAI Hürkuş' AND (image_credit, image_licence) IS DISTINCT FROM ('Ibex73', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Dimir', image_licence = 'CC BY-SA 4.0' WHERE name = 'TAI Kaan' AND (image_credit, image_licence) IS DISTINCT FROM ('Dimir', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'bomberpilot', image_licence = 'CC BY-SA 2.0' WHERE name = 'Transall C-160' AND (image_credit, image_licence) IS DISTINCT FROM ('bomberpilot', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Mike1979 Russia', image_licence = 'CC BY-SA 3.0' WHERE name = 'Tu-128' AND (image_credit, image_licence) IS DISTINCT FROM ('Mike1979 Russia', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'VargaA', image_licence = 'CC BY-SA 4.0' WHERE name = 'Tu-141 Strizh' AND (image_credit, image_licence) IS DISTINCT FROM ('VargaA', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = NULL, image_licence = 'Public domain' WHERE name = 'Tu-142' AND (image_credit, image_licence) IS DISTINCT FROM (NULL, 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Tu-143 Reys' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'Tu-16' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Зимин Василий', image_licence = 'Public domain' WHERE name = 'Tu-22' AND (image_credit, image_licence) IS DISTINCT FROM ('Зимин Василий', 'Public domain');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Tupolev Tu-4' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'United States Department of the Air Force', image_licence = 'Public domain' WHERE name = 'U-2 Dragon Lady' AND (image_credit, image_licence) IS DISTINCT FROM ('United States Department of the Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'André Gerwing', image_licence = 'CC BY-SA 4.0' WHERE name = 'VFW VAK 191B' AND (image_credit, image_licence) IS DISTINCT FROM ('André Gerwing', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'VynedJ', image_licence = 'CC BY 4.0' WHERE name = 'Valmet L-70 Vinka' AND (image_credit, image_licence) IS DISTINCT FROM ('VynedJ', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Jerry Gunner from Lincoln, UK', image_licence = 'CC BY 2.0' WHERE name = 'Vautour II' AND (image_credit, image_licence) IS DISTINCT FROM ('Jerry Gunner from Lincoln, UK', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Hugh Llewelyn from Keynsham, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Vickers VC10' AND (image_credit, image_licence) IS DISTINCT FROM ('Hugh Llewelyn from Keynsham, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Umeyou', image_licence = 'CC BY-SA 3.0' WHERE name = 'Vickers Valiant' AND (image_credit, image_licence) IS DISTINCT FROM ('Umeyou', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'kitmasterbloke', image_licence = 'CC BY 2.0' WHERE name = 'Westland Wyvern' AND (image_credit, image_licence) IS DISTINCT FROM ('kitmasterbloke', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Mztourist', image_licence = 'CC BY-SA 4.0' WHERE name = 'Wing Loong II' AND (image_credit, image_licence) IS DISTINCT FROM ('Mztourist', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'San Diego Air & Space Museum', image_licence = 'Public domain' WHERE name = 'X-13 Vertijet' AND (image_credit, image_licence) IS DISTINCT FROM ('San Diego Air & Space Museum', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'X-15' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA / DFRC / Larry Sammons', image_licence = 'Public domain' WHERE name = 'X-29' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA / DFRC / Larry Sammons', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'X-3 Stiletto' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'Jim Ross, NASA Dryden Flight Research Center (NASA-DFRC)', image_licence = 'Public domain' WHERE name = 'X-31' AND (image_credit, image_licence) IS DISTINCT FROM ('Jim Ross, NASA Dryden Flight Research Center (NASA-DFRC)', 'Public domain');
UPDATE airplanes SET image_credit = 'DARPA', image_licence = 'Public domain' WHERE name = 'X-47B' AND (image_credit, image_licence) IS DISTINCT FROM ('DARPA', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'XB-70 Valkyrie' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'USN', image_licence = 'Public domain' WHERE name = 'XFY Pogo' AND (image_credit, image_licence) IS DISTINCT FROM ('USN', 'Public domain');
UPDATE airplanes SET image_credit = '88 Air Base Wing Public Affairs', image_licence = 'Public domain' WHERE name = 'XQ-58 Valkyrie' AND (image_credit, image_licence) IS DISTINCT FROM ('88 Air Base Wing Public Affairs', 'Public domain');
UPDATE airplanes SET image_credit = 'N509FZ', image_licence = 'CC BY-SA 4.0' WHERE name = 'Xian Y-20 Kunpeng' AND (image_credit, image_licence) IS DISTINCT FROM ('N509FZ', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'USAF', image_licence = 'Public domain' WHERE name = 'YF-17 Cobra' AND (image_credit, image_licence) IS DISTINCT FROM ('USAF', 'Public domain');
UPDATE airplanes SET image_credit = NULL, image_licence = 'Public domain' WHERE name = 'YF-22' AND (image_credit, image_licence) IS DISTINCT FROM (NULL, 'Public domain');
UPDATE airplanes SET image_credit = 'Logan Rickert', image_licence = 'CC BY 4.0' WHERE name = 'YF-23 Black Widow II' AND (image_credit, image_licence) IS DISTINCT FROM ('Logan Rickert', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Ministry of Defence', image_licence = 'CC BY 4.0' WHERE name = 'Yak-130' AND (image_credit, image_licence) IS DISTINCT FROM ('Ministry of Defence', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'Mike1979 Russia', image_licence = 'CC BY-SA 4.0' WHERE name = 'Yak-141' AND (image_credit, image_licence) IS DISTINCT FROM ('Mike1979 Russia', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Yak-23' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Alan Wilson', image_licence = 'CC BY-SA 2.0' WHERE name = 'Yak-25' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'Yak-28' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Maarten', image_licence = 'CC BY 2.0' WHERE name = 'Yak-36' AND (image_credit, image_licence) IS DISTINCT FROM ('Maarten', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'US Navy Service Depicted: Other Service', image_licence = 'Public domain' WHERE name = 'Yak-38' AND (image_credit, image_licence) IS DISTINCT FROM ('US Navy Service Depicted: Other Service', 'Public domain');
UPDATE airplanes SET image_credit = 'Pseudopanax', image_licence = 'Public domain' WHERE name = 'de Havilland Vampire' AND (image_credit, image_licence) IS DISTINCT FROM ('Pseudopanax', 'Public domain');
UPDATE airplanes SET image_credit = 'Tony Hisgett from Birmingham, UK', image_licence = 'CC BY 2.0' WHERE name = 'de Havilland Venom' AND (image_credit, image_licence) IS DISTINCT FROM ('Tony Hisgett from Birmingham, UK', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Tangopaso', image_licence = 'CC BY-SA 3.0' WHERE name = 'nEUROn' AND (image_credit, image_licence) IS DISTINCT FROM ('Tangopaso', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'David Álvarez López from Gijón, España', image_licence = 'CC BY 2.0' WHERE name = 'Pilatus PC-21' AND (image_credit, image_licence) IS DISTINCT FROM ('David Álvarez López from Gijón, España', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'Boeing T-7 Red Hawk' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Colin Cooke Photo', image_licence = 'CC BY-SA 2.0' WHERE name = 'Airbus C295' AND (image_credit, image_licence) IS DISTINCT FROM ('Colin Cooke Photo', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Bahnfrend', image_licence = 'CC BY-SA 4.0' WHERE name = 'Antonov An-225 Mriya' AND (image_credit, image_licence) IS DISTINCT FROM ('Bahnfrend', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'CeeGee', image_licence = 'CC BY-SA 4.0' WHERE name = 'Bayraktar Akıncı' AND (image_credit, image_licence) IS DISTINCT FROM ('CeeGee', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'Yak-17' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'B-66 Destroyer' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'Martin B-57 Canberra' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'S-2 Tracker' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = '颐园居', image_licence = 'CC BY-SA 4.0' WHERE name = 'Shaanxi KJ-500' AND (image_credit, image_licence) IS DISTINCT FROM ('颐园居', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Cpl. Melissa Wenger, U.S. Marine Corps', image_licence = 'Public domain' WHERE name = 'V-22 Osprey' AND (image_credit, image_licence) IS DISTINCT FROM ('Cpl. Melissa Wenger, U.S. Marine Corps', 'Public domain');
UPDATE airplanes SET image_credit = 'NASA', image_licence = 'Public domain' WHERE name = 'Bell XV-15' AND (image_credit, image_licence) IS DISTINCT FROM ('NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'Ata Barış', image_licence = 'CC BY-SA 4.0' WHERE name = 'Bayraktar Kızılelma' AND (image_credit, image_licence) IS DISTINCT FROM ('Ata Barış', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Mustafa Karabaş (TUSAŞ)', image_licence = 'CC BY-SA 4.0' WHERE name = 'TAI Anka' AND (image_credit, image_licence) IS DISTINCT FROM ('Mustafa Karabaş (TUSAŞ)', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Senior Airman Adrien Tran, U.S. Air Force', image_licence = 'Public domain' WHERE name = 'MQ-28 Ghost Bat' AND (image_credit, image_licence) IS DISTINCT FROM ('Senior Airman Adrien Tran, U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Ministère de la Défense de la Fédération de Russie (mil.ru)', image_licence = 'CC BY 4.0' WHERE name = 'Sukhoi S-70 Okhotnik' AND (image_credit, image_licence) IS DISTINCT FROM ('Ministère de la Défense de la Fédération de Russie (mil.ru)', 'CC BY 4.0');
UPDATE airplanes SET image_credit = '颐园居', image_licence = 'CC BY-SA 4.0' WHERE name = 'Hongdu GJ-11 Sharp Sword' AND (image_credit, image_licence) IS DISTINCT FROM ('颐园居', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Infinty 0', image_licence = 'CC BY-SA 4.0' WHERE name = 'CASC CH-5 Rainbow' AND (image_credit, image_licence) IS DISTINCT FROM ('Infinty 0', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Jim Ross, NASA', image_licence = 'Public domain' WHERE name = 'Boeing X-45' AND (image_credit, image_licence) IS DISTINCT FROM ('Jim Ross, NASA', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'MQ-4C Triton' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'tolgaozbekcom', image_licence = 'CC BY 3.0' WHERE name = 'TAI Hürjet' AND (image_credit, image_licence) IS DISTINCT FROM ('tolgaozbekcom', 'CC BY 3.0');
UPDATE airplanes SET image_credit = 'Admiralis-generalis-Aladeen', image_licence = 'CC BY-SA 4.0' WHERE name = 'Aero L-39NG Skyfox' AND (image_credit, image_licence) IS DISTINCT FROM ('Admiralis-generalis-Aladeen', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Lawrence Crespo, U.S. Air Force', image_licence = 'Public domain' WHERE name = 'Boeing E-7 Wedgetail' AND (image_credit, image_licence) IS DISTINCT FROM ('Lawrence Crespo, U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'General Atomics YFQ-42A Dark Merlin' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Nehemia Gershuni-Aylho', image_licence = 'CC BY-SA 3.0' WHERE name = 'Elbit Hermes 450' AND (image_credit, image_licence) IS DISTINCT FROM ('Nehemia Gershuni-Aylho', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'John Higgins', image_licence = 'Public domain' WHERE name = 'MQ-1C Gray Eagle' AND (image_credit, image_licence) IS DISTINCT FROM ('John Higgins', 'Public domain');
UPDATE airplanes SET image_credit = 'Carl9311', image_licence = 'CC0' WHERE name = 'Bayraktar TB3' AND (image_credit, image_licence) IS DISTINCT FROM ('Carl9311', 'CC0');
UPDATE airplanes SET image_credit = 'André Gerwing', image_licence = 'CC BY-SA 4.0' WHERE name = 'Saab 21R' AND (image_credit, image_licence) IS DISTINCT FROM ('André Gerwing', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Aeroprints.com', image_licence = 'CC BY-SA 3.0' WHERE name = 'IAe 33 Pulqui II' AND (image_credit, image_licence) IS DISTINCT FROM ('Aeroprints.com', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'FH-1 Phantom' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'F2H Banshee' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Joe Sewell', image_licence = 'Public domain' WHERE name = 'F3H Demon' AND (image_credit, image_licence) IS DISTINCT FROM ('Joe Sewell', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'Northrop YB-49' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = NULL, image_licence = 'Public domain' WHERE name = 'Leduc 010' AND (image_credit, image_licence) IS DISTINCT FROM (NULL, 'Public domain');
UPDATE airplanes SET image_credit = 'Clemens Vasters from Viersen, Germany, Germany', image_licence = 'CC BY 2.0' WHERE name = 'Nord 1500 Griffon' AND (image_credit, image_licence) IS DISTINCT FROM ('Clemens Vasters from Viersen, Germany, Germany', 'CC BY 2.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'SNCASO Trident' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Noah Wulf', image_licence = 'CC BY-SA 3.0' WHERE name = 'F4U Corsair' AND (image_credit, image_licence) IS DISTINCT FROM ('Noah Wulf', 'CC BY-SA 3.0');
UPDATE airplanes SET image_credit = 'Alan Wilson', image_licence = 'CC BY-SA 2.0' WHERE name = 'Hawker Sea Fury' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'Alan Wilson from Stilton, Peterborough, Cambs, UK', image_licence = 'CC BY-SA 2.0' WHERE name = 'F8F Bearcat' AND (image_credit, image_licence) IS DISTINCT FROM ('Alan Wilson from Stilton, Peterborough, Cambs, UK', 'CC BY-SA 2.0');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'AC-47 Spooky' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Taylormcalear', image_licence = 'CC BY-SA 4.0' WHERE name = 'Canadair CP-107 Argus' AND (image_credit, image_licence) IS DISTINCT FROM ('Taylormcalear', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'HU-16 Albatross' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Navy', image_licence = 'Public domain' WHERE name = 'E-1 Tracer' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Navy', 'Public domain');
UPDATE airplanes SET image_credit = 'Danny Yu', image_licence = 'CC BY-SA 4.0' WHERE name = 'KJ-2000' AND (image_credit, image_licence) IS DISTINCT FROM ('Danny Yu', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Bene Riobó', image_licence = 'CC BY-SA 4.0' WHERE name = 'Saab 340 AEW&C' AND (image_credit, image_licence) IS DISTINCT FROM ('Bene Riobó', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'Alert5', image_licence = 'CC BY-SA 4.0' WHERE name = 'Shaanxi Y-9' AND (image_credit, image_licence) IS DISTINCT FROM ('Alert5', 'CC BY-SA 4.0');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'C-123 Provider' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Dave_S.', image_licence = 'CC BY 4.0' WHERE name = 'DHC-2 Beaver' AND (image_credit, image_licence) IS DISTINCT FROM ('Dave_S.', 'CC BY 4.0');
UPDATE airplanes SET image_credit = 'San Diego Air & Space Museum Archives', image_licence = 'Public domain' WHERE name = 'Canadair CL-84 Dynavert' AND (image_credit, image_licence) IS DISTINCT FROM ('San Diego Air & Space Museum Archives', 'Public domain');
UPDATE airplanes SET image_credit = 'U.S. Air Force', image_licence = 'Public domain' WHERE name = 'Northrop Tacit Blue' AND (image_credit, image_licence) IS DISTINCT FROM ('U.S. Air Force', 'Public domain');
UPDATE airplanes SET image_credit = 'Jim Ross, NASA', image_licence = 'Public domain' WHERE name = 'Lockheed Martin X-59 QueSST' AND (image_credit, image_licence) IS DISTINCT FROM ('Jim Ross, NASA', 'Public domain');

-- ═══ 5. Réparation des liaisons perdues ════════════════════════════
--
-- Sept fiches référençaient un armement ou une technologie déclaré par une
-- fiche chargée après elles. Les tables de liaison étant NOT NULL, l'INSERT
-- échouait et la suite du fichier était perdue : ces appareils sont en base
-- sans leurs armements, missions ni conflits. `db.sql` corrige le cas à
-- neuf ; une base déjà installée garde le trou, que ce bloc comble.

INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Aile en flèche légère'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Réacteur à postcombustion'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Système de navigation inertielle'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'M39'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'AIM-9 Sidewinder'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Mk 82'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Hydra 70'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Guerre du Vietnam'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Guerre Iran-Irak'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Supériorité aérienne'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Interception'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Frappe tactique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-5 Freedom Fighter' AND r.name = 'Appui aérien rapproché'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Aile à incidence variable'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Système navalisé'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Réacteur à postcombustion'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Système de caméra intégré'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Radar AN/APQ-94'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Colt Mk 12'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Matra R530'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Matra R550 Magic'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Zuni 127 mm'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Guerre du Liban'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Guerre de Yougoslavie'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Supériorité aérienne'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Interception'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Patrouille aérienne de combat'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'F-8E (FN) Crusader' AND r.name = 'Escorte'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Xian H-6' AND r.name = 'Aile en flèche'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Xian H-6' AND r.name = 'Moteurs à turbofan'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Xian H-6' AND r.name = 'Système de navigation et d''attaque intégré'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Xian H-6' AND r.name = 'Système de contre-mesures électroniques'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Xian H-6' AND r.name = 'Radar AESA'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Xian H-6' AND r.name = 'CJ-10'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Xian H-6' AND r.name = 'CJ-20'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Xian H-6' AND r.name = 'YJ-83'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Xian H-6' AND r.name = 'KD-88'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Xian H-6' AND r.name = 'FAB-500'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Xian H-6' AND r.name = 'Frappe stratégique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Xian H-6' AND r.name = 'Dissuasion nucléaire'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Xian H-6' AND r.name = 'Attaque antinavire'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Xian H-6' AND r.name = 'Frappe tactique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Xian H-6' AND r.name = 'Reconnaissance stratégique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Aile à forte flèche'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Commande de vol électrique (fly-by-wire)'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Réacteur WS-10'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Radar AESA'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Perche de ravitaillement en vol'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Système de fusion de capteurs'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'GSh-30-1'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'PL-10'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'PL-12'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'PL-15'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'YJ-91'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'KD-88'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-16' AND r.name = 'LS-6'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Supériorité aérienne'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Interception'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Frappe tactique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Suppression des défenses aériennes ennemies'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Attaque antinavire'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Guerre électronique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-16' AND r.name = 'Patrouille aérienne de combat'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Aile en flèche'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Réacteur Klimov VK-1'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Système de navigation semi-automatique'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-5' AND r.name = 'NR-23'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Shenyang J-5' AND r.name = 'FAB-250'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Guerre du Vietnam'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Supériorité aérienne'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Interception'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Shenyang J-5' AND r.name = 'Frappe tactique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Aile en flèche'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Réacteur WP-6'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Système de navigation semi-automatique'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'NR-23'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'FAB-250'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'FAB-500'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Type 90-1'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'HF-16'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'PL-2'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Guerre Indo-Pakistanaise de 1971'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Appui aérien rapproché'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Frappe tactique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Reconnaissance armée'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Nanchang Q-5' AND r.name = 'Dissuasion nucléaire'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Su-30' AND r.name = 'Aile à forte flèche'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Su-30' AND r.name = 'Radar N011M Bars'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Su-30' AND r.name = 'Système de ravitaillement en vol'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Su-30' AND r.name = 'Système de contrôle de vol numérique'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_tech (id_airplane, id_tech)
SELECT a.id, r.id FROM airplanes a, tech r
WHERE a.name = 'Su-30' AND r.name = 'Système de fusion de capteurs'
  AND NOT EXISTS (SELECT 1 FROM airplane_tech x WHERE x.id_airplane = a.id AND x.id_tech = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Su-30' AND r.name = 'GSh-30-1'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Su-30' AND r.name = 'R-27R'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Su-30' AND r.name = 'R-73'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Su-30' AND r.name = 'R-77'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_armement (id_airplane, id_armement)
SELECT a.id, r.id FROM airplanes a, armement r
WHERE a.name = 'Su-30' AND r.name = 'Kh-29L'
  AND NOT EXISTS (SELECT 1 FROM airplane_armement x WHERE x.id_airplane = a.id AND x.id_armement = r.id);
INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, r.id FROM airplanes a, wars r
WHERE a.name = 'Su-30' AND r.name = 'Guerre civile syrienne'
  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Su-30' AND r.name = 'Supériorité aérienne'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Su-30' AND r.name = 'Interception'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Su-30' AND r.name = 'Frappe tactique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Su-30' AND r.name = 'Patrouille aérienne de combat'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);
INSERT INTO airplane_missions (id_airplane, id_mission)
SELECT a.id, r.id FROM airplanes a, missions r
WHERE a.name = 'Su-30' AND r.name = 'Reconnaissance stratégique'
  AND NOT EXISTS (SELECT 1 FROM airplane_missions x WHERE x.id_airplane = a.id AND x.id_mission = r.id);

-- Les blocs d'enrichissement de ces fiches suivaient l'INSERT en échec : ils
-- ont été perdus eux aussi. Ces sept appareils sont donc en base sans leurs
-- dimensions, moteurs, coûts ni récits. On les rejoue tels quels — ces UPDATE
-- posent des valeurs absolues repérées par nom, ils sont donc rejouables.

UPDATE airplanes SET
  length = 14.38, wingspan = 8.13, height = 4.08, wing_area = 17.28,
  empty_weight = 4410, mtow = 11187, service_ceiling = 15800, climb_rate = 175,
  combat_radius = 1405, crew = 1, g_limit_pos = 7.33,
  engine_name = 'General Electric J85-GE-21B', engine_count = 2,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 15.57, thrust_wet = 22.2,
  production_start = 1962, production_end = 1987, units_built = 2246,
  operators_count = 30,
  nickname = 'Tiger II',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Northrop_F-5',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Northrop_F-5'
WHERE name = 'F-5 Freedom Fighter'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, climb_rate, combat_radius,
       crew, g_limit_pos, engine_name, engine_count, engine_type, engine_type_en, thrust_dry, thrust_wet,
       production_start, production_end, units_built, operators_count, nickname, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (14.38, 8.13, 4.08, 17.28, 4410, 11187, 15800, 175, 1405, 1, 7.33, 'General Electric J85-GE-21B', 2,
       'Turboréacteur avec postcombustion', 'Afterburning turbojet', 15.57, 22.2, 1962, 1987, 2246, 30,
       'Tiger II', 'https://fr.wikipedia.org/wiki/Northrop_F-5',
       'https://en.wikipedia.org/wiki/Northrop_F-5');
UPDATE airplanes SET
  unit_cost_usd = 2100000, unit_cost_year = 1975,
  variants    = E'- **F-5A/B** : Freedom Fighter initial\n- **F-5E/F Tiger II** : version modernisée, radar AN/APQ-159\n- **F-5G / F-20 Tigershark** : prototype avorté (un seul moteur F404)',
  variants_en = E'- **F-5A/B** : initial Freedom Fighter\n- **F-5E/F Tiger II** : modernised variant, AN/APQ-159 radar\n- **F-5G / F-20 Tigershark** : aborted single-F404 prototype'
WHERE name = 'F-5 Freedom Fighter'
  AND (unit_cost_usd, unit_cost_year, variants, variants_en)
      IS DISTINCT FROM
      (2100000, 1975,
       E'- **F-5A/B** : Freedom Fighter initial\n- **F-5E/F Tiger II** : version modernisée, radar AN/APQ-159\n- **F-5G / F-20 Tigershark** : prototype avorté (un seul moteur F404)',
       E'- **F-5A/B** : initial Freedom Fighter\n- **F-5E/F Tiger II** : modernised variant, AN/APQ-159 radar\n- **F-5G / F-20 Tigershark** : aborted single-F404 prototype');
UPDATE airplanes SET
  description = E'## Genèse\nConçu dans les années 1950 pour offrir aux alliés des États-Unis un chasseur supersonique simple, léger et économique. Le F-5 est l''avion de l''« allié » par excellence durant la guerre froide.\n\n## Carrière opérationnelle\nExporté dans plus de 30 pays : Iran, Corée du Sud, Vietnam du Sud, Jordanie, Arabie saoudite, Brésil, Norvège. Souvent premier appareil supersonique des forces aériennes émergentes. Engagé au Vietnam et lors des conflits du Moyen-Orient.\n\n## Héritage\nEncore en service dans plusieurs pays (Brésil, Chili, Corée du Sud, Mexique, Suisse) grâce à sa simplicité et ses coûts de maintenance modestes. Base du projet **F-20 Tigershark** avorté.',
  description_en = E'## Genesis\nDesigned in the 1950s to give US allies a simple, light and affordable supersonic fighter. The F-5 is the quintessential Cold War "ally" aircraft.\n\n## Operational career\nExported to more than 30 countries: Iran, South Korea, South Vietnam, Jordan, Saudi Arabia, Brazil, Norway. Often the first supersonic aircraft of emerging air forces. Used in Vietnam and Middle East conflicts.\n\n## Legacy\nStill in service in several countries (Brazil, Chile, South Korea, Mexico, Switzerland) thanks to its simplicity and low maintenance costs. Basis for the aborted **F-20 Tigershark** project.'
WHERE name = 'F-5 Freedom Fighter'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nConçu dans les années 1950 pour offrir aux alliés des États-Unis un chasseur supersonique simple, léger et économique. Le F-5 est l''avion de l''« allié » par excellence durant la guerre froide.\n\n## Carrière opérationnelle\nExporté dans plus de 30 pays : Iran, Corée du Sud, Vietnam du Sud, Jordanie, Arabie saoudite, Brésil, Norvège. Souvent premier appareil supersonique des forces aériennes émergentes. Engagé au Vietnam et lors des conflits du Moyen-Orient.\n\n## Héritage\nEncore en service dans plusieurs pays (Brésil, Chili, Corée du Sud, Mexique, Suisse) grâce à sa simplicité et ses coûts de maintenance modestes. Base du projet **F-20 Tigershark** avorté.',
       E'## Genesis\nDesigned in the 1950s to give US allies a simple, light and affordable supersonic fighter. The F-5 is the quintessential Cold War "ally" aircraft.\n\n## Operational career\nExported to more than 30 countries: Iran, South Korea, South Vietnam, Jordan, Saudi Arabia, Brazil, Norway. Often the first supersonic aircraft of emerging air forces. Used in Vietnam and Middle East conflicts.\n\n## Legacy\nStill in service in several countries (Brazil, Chile, South Korea, Mexico, Switzerland) thanks to its simplicity and low maintenance costs. Basis for the aborted **F-20 Tigershark** project.');
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=_OC8gae2H7g'
WHERE name = 'F-5 Freedom Fighter'
  AND youtube_showcase IS DISTINCT FROM 'https://www.youtube.com/watch?v=_OC8gae2H7g';
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-5 Freedom Fighter' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET
  length = 16.6, wingspan = 10.7, height = 4.8, wing_area = 32.5,
  empty_weight = 9038, mtow = 15500, service_ceiling = 17700, climb_rate = 160,
  combat_radius = 660, crew = 1, g_limit_pos = 6.4,
  engine_name = 'Pratt & Whitney J57-P-20A', engine_count = 1,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 47.6, thrust_wet = 80.1,
  production_start = 1954, production_end = 1964, units_built = 1261,
  nickname = 'Crusader',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Vought_F-8_Crusader',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Vought_F-8_Crusader'
WHERE name = 'F-8E (FN) Crusader'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, climb_rate, combat_radius,
       crew, g_limit_pos, engine_name, engine_count, engine_type, engine_type_en, thrust_dry, thrust_wet,
       production_start, production_end, units_built, nickname, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (16.6, 10.7, 4.8, 32.5, 9038, 15500, 17700, 160, 660, 1, 6.4, 'Pratt & Whitney J57-P-20A', 1,
       'Turboréacteur avec postcombustion', 'Afterburning turbojet', 47.6, 80.1, 1954, 1964, 1261,
       'Crusader', 'https://fr.wikipedia.org/wiki/Vought_F-8_Crusader',
       'https://en.wikipedia.org/wiki/Vought_F-8_Crusader');
UPDATE airplanes SET
  unit_cost_usd = 1500000, unit_cost_year = 1960,
  operators_count = 1,
  variants    = E'- **F-8A/C/D/E** : versions US Navy\n- **F-8E (FN)** : version française pour la Marine nationale (35 exemplaires, porte-avions Clemenceau/Foch)\n- **RF-8A** : reconnaissance (impliqué dans la crise de Cuba)',
  variants_en = E'- **F-8A/C/D/E** : US Navy versions\n- **F-8E (FN)** : French Navy variant (35 built, Clemenceau/Foch carriers)\n- **RF-8A** : reconnaissance (Cuban Missile Crisis)'
WHERE name = 'F-8E (FN) Crusader'
  AND (unit_cost_usd, unit_cost_year, operators_count, variants, variants_en)
      IS DISTINCT FROM
      (1500000, 1960, 1,
       E'- **F-8A/C/D/E** : versions US Navy\n- **F-8E (FN)** : version française pour la Marine nationale (35 exemplaires, porte-avions Clemenceau/Foch)\n- **RF-8A** : reconnaissance (impliqué dans la crise de Cuba)',
       E'- **F-8A/C/D/E** : US Navy versions\n- **F-8E (FN)** : French Navy variant (35 built, Clemenceau/Foch carriers)\n- **RF-8A** : reconnaissance (Cuban Missile Crisis)');
UPDATE airplanes SET
  description = E'## Genèse\nIntercepteur embarqué US Navy des années 1950, réputé pour sa vitesse (Mach 1.8) mais aussi pour sa difficulté de pilotage à basse vitesse lors des appontages. Dernier chasseur à usage du canon comme arme principale.\n\n## Carrière opérationnelle\nRôle majeur au Vietnam (surnom : « *MiG Master* » pour ses 19 victoires contre les MiG-17 et MiG-21). La **Marine nationale française** reçoit 42 F-8E (FN) en 1964-1965, opérant depuis les porte-avions Clemenceau et Foch pendant 35 ans.\n\n## Héritage\nRetraité par la US Navy en 1976, mais prolongé par la Marine française jusqu''en 1999. Dernier chasseur français à catapultage classique avant l''ère Rafale M.',
  description_en = E'## Genesis\n1950s US Navy carrier interceptor, famous for its speed (Mach 1.8) but also for its tricky low-speed handling during carrier landings. The last fighter to rely on the gun as its primary weapon.\n\n## Operational career\nMajor role in Vietnam (nicknamed "*MiG Master*" for its 19 victories against MiG-17s and MiG-21s). The **French Navy** received 42 F-8E (FN) in 1964-1965, operating from the Clemenceau and Foch carriers for 35 years.\n\n## Legacy\nRetired by the US Navy in 1976, but extended by the French Navy until 1999. The last French fighter using conventional catapult launch before the Rafale M era.'
WHERE name = 'F-8E (FN) Crusader'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nIntercepteur embarqué US Navy des années 1950, réputé pour sa vitesse (Mach 1.8) mais aussi pour sa difficulté de pilotage à basse vitesse lors des appontages. Dernier chasseur à usage du canon comme arme principale.\n\n## Carrière opérationnelle\nRôle majeur au Vietnam (surnom : « *MiG Master* » pour ses 19 victoires contre les MiG-17 et MiG-21). La **Marine nationale française** reçoit 42 F-8E (FN) en 1964-1965, opérant depuis les porte-avions Clemenceau et Foch pendant 35 ans.\n\n## Héritage\nRetraité par la US Navy en 1976, mais prolongé par la Marine française jusqu''en 1999. Dernier chasseur français à catapultage classique avant l''ère Rafale M.',
       E'## Genesis\n1950s US Navy carrier interceptor, famous for its speed (Mach 1.8) but also for its tricky low-speed handling during carrier landings. The last fighter to rely on the gun as its primary weapon.\n\n## Operational career\nMajor role in Vietnam (nicknamed "*MiG Master*" for its 19 victories against MiG-17s and MiG-21s). The **French Navy** received 42 F-8E (FN) in 1964-1965, operating from the Clemenceau and Foch carriers for 35 years.\n\n## Legacy\nRetired by the US Navy in 1976, but extended by the French Navy until 1999. The last French fighter using conventional catapult launch before the Rafale M era.');
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-8E (FN) Crusader' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET
  length = 34.8, wingspan = 33.0, height = 9.85, wing_area = 167.55,
  empty_weight = 37200, mtow = 79000, service_ceiling = 13100, climb_rate = 19,
  combat_radius = 1800, crew = 4,
  engine_name = 'Xian WP-8', engine_count = 2,
  engine_type = 'Turboréacteur', engine_type_en = 'Turbojet',
  thrust_dry = 93.2,
  production_start = 1959, production_end = NULL, units_built = 230,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Xian_H-6',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Xian_H-6'
WHERE name = 'Xian H-6'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, climb_rate, combat_radius,
       crew, engine_name, engine_count, engine_type, engine_type_en, thrust_dry, production_start,
       production_end, units_built, operators_count, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (34.8, 33.0, 9.85, 167.55, 37200, 79000, 13100, 19, 1800, 4, 'Xian WP-8', 2, 'Turboréacteur',
       'Turbojet', 93.2, 1959, NULL, 230, 1, 'https://fr.wikipedia.org/wiki/Xian_H-6',
       'https://en.wikipedia.org/wiki/Xian_H-6');
UPDATE airplanes SET
  unit_cost_usd = 35000000, unit_cost_year = 2010,
  variants    = E'- **H-6A/B/C/D/E** : variantes initiales (bombes nucléaires, missiles antinavires)\n- **H-6H/M** : porteurs de missiles de croisière KD-63\n- **H-6K** : modernisation profonde (turbofans D-30, YJ-12/KD-20)\n- **H-6N** : version porte-missile aéroporté longue portée\n- **HY-6** : ravitailleur',
  variants_en = E'- **H-6A/B/C/D/E** : early variants (nuclear, anti-ship)\n- **H-6H/M** : KD-63 cruise missile carriers\n- **H-6K** : deep upgrade (D-30 turbofans, YJ-12/KD-20)\n- **H-6N** : long-range aeroballistic missile carrier\n- **HY-6** : tanker'
WHERE name = 'Xian H-6'
  AND (unit_cost_usd, unit_cost_year, variants, variants_en)
      IS DISTINCT FROM
      (35000000, 2010,
       E'- **H-6A/B/C/D/E** : variantes initiales (bombes nucléaires, missiles antinavires)\n- **H-6H/M** : porteurs de missiles de croisière KD-63\n- **H-6K** : modernisation profonde (turbofans D-30, YJ-12/KD-20)\n- **H-6N** : version porte-missile aéroporté longue portée\n- **HY-6** : ravitailleur',
       E'- **H-6A/B/C/D/E** : early variants (nuclear, anti-ship)\n- **H-6H/M** : KD-63 cruise missile carriers\n- **H-6K** : deep upgrade (D-30 turbofans, YJ-12/KD-20)\n- **H-6N** : long-range aeroballistic missile carrier\n- **HY-6** : tanker');
UPDATE airplanes SET
  description = E'## Genèse\nCopie chinoise sous licence du **Tu-16 Badger soviétique**, produite à partir de 1959. Seul bombardier stratégique chinois historique, modernisé en continu depuis 60 ans.\n\n## Carrière opérationnelle\nPilier de la dissuasion nucléaire chinoise pendant la guerre froide. Variantes modernisées **H-6K** (moteurs D-30, avionique numérique, missiles de croisière YJ-12/KD-20) et **H-6N** (porte-missile aéroballistique longue portée). Patrouilles régulières autour de Taïwan.\n\n## Héritage\nPlus de **230 exemplaires** construits. Seul bombardier stratégique chinois actuel. Successeur **H-20** furtif attendu pour 2026-2030 (équivalent du B-2 Spirit).',
  description_en = E'## Genesis\nChinese licence-built copy of the Soviet **Tu-16 Badger**, produced from 1959. China''s only historical strategic bomber, continuously upgraded for 60 years.\n\n## Operational career\nPillar of Chinese nuclear deterrence during the Cold War. Upgraded **H-6K** (D-30 engines, digital avionics, YJ-12/KD-20 cruise missiles) and **H-6N** (long-range air-launched ballistic missile carrier) variants. Regular patrols around Taiwan.\n\n## Legacy\nMore than **230 built**. China''s only current strategic bomber. Stealth successor **H-20** expected for 2026-2030 (equivalent to the B-2 Spirit).'
WHERE name = 'Xian H-6'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nCopie chinoise sous licence du **Tu-16 Badger soviétique**, produite à partir de 1959. Seul bombardier stratégique chinois historique, modernisé en continu depuis 60 ans.\n\n## Carrière opérationnelle\nPilier de la dissuasion nucléaire chinoise pendant la guerre froide. Variantes modernisées **H-6K** (moteurs D-30, avionique numérique, missiles de croisière YJ-12/KD-20) et **H-6N** (porte-missile aéroballistique longue portée). Patrouilles régulières autour de Taïwan.\n\n## Héritage\nPlus de **230 exemplaires** construits. Seul bombardier stratégique chinois actuel. Successeur **H-20** furtif attendu pour 2026-2030 (équivalent du B-2 Spirit).',
       E'## Genesis\nChinese licence-built copy of the Soviet **Tu-16 Badger**, produced from 1959. China''s only historical strategic bomber, continuously upgraded for 60 years.\n\n## Operational career\nPillar of Chinese nuclear deterrence during the Cold War. Upgraded **H-6K** (D-30 engines, digital avionics, YJ-12/KD-20 cruise missiles) and **H-6N** (long-range air-launched ballistic missile carrier) variants. Regular patrols around Taiwan.\n\n## Legacy\nMore than **230 built**. China''s only current strategic bomber. Stealth successor **H-20** expected for 2026-2030 (equivalent to the B-2 Spirit).');
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Xian H-6' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET
  length = 22.0, wingspan = 14.7, height = 6.4, wing_area = 62.0,
  empty_weight = 17700, mtow = 35000, service_ceiling = 17500,
  combat_radius = 1500, crew = 2,
  engine_name = 'WS-10B', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 74.5, thrust_wet = 140.0,
  production_start = 2011, production_end = NULL, units_built = 300,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Shenyang_J-16',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Shenyang_J-16'
WHERE name = 'Shenyang J-16'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, combat_radius, crew,
       engine_name, engine_count, engine_type, engine_type_en, thrust_dry, thrust_wet, production_start,
       production_end, units_built, operators_count, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (22.0, 14.7, 6.4, 62.0, 17700, 35000, 17500, 1500, 2, 'WS-10B', 2, 'Turbofan avec postcombustion',
       'Afterburning turbofan', 74.5, 140.0, 2011, NULL, 300, 1,
       'https://fr.wikipedia.org/wiki/Shenyang_J-16', 'https://en.wikipedia.org/wiki/Shenyang_J-16');
UPDATE airplanes SET
  unit_cost_usd = 60000000, unit_cost_year = 2020,
  variants    = E'- **J-16** : chasseur multi-rôle biplace\n- **J-16D** : guerre électronique (analogue au EA-18G Growler)',
  variants_en = E'- **J-16** : two-seat multi-role fighter\n- **J-16D** : electronic warfare (EA-18G Growler analogue)'
WHERE name = 'Shenyang J-16'
  AND (unit_cost_usd, unit_cost_year, variants, variants_en)
      IS DISTINCT FROM
      (60000000, 2020,
       E'- **J-16** : chasseur multi-rôle biplace\n- **J-16D** : guerre électronique (analogue au EA-18G Growler)',
       E'- **J-16** : two-seat multi-role fighter\n- **J-16D** : electronic warfare (EA-18G Growler analogue)');
UPDATE airplanes SET
  description = E'## Genèse\nÉquivalent chinois du **F-15E Strike Eagle** et du Su-30. Biplace multi-rôle lourd développé à partir du J-11B à la fin des années 2000. Premier vol en 2011.\n\n## Carrière opérationnelle\nPilier de l''aviation tactique chinoise moderne. Version J-16D de guerre électronique analogue à l''EA-18G Growler américain. Intégré dans les exercices de projection de puissance vers Taïwan et en mer de Chine méridionale.\n\n## Héritage\nPlus de **300 exemplaires** produits. Représente l''aboutissement de la famille Flanker chinoise, avant l''arrivée progressive des J-20 et J-35 furtifs.',
  description_en = E'## Genesis\nChinese equivalent of the **F-15E Strike Eagle** and the Su-30. Heavy two-seat multi-role aircraft developed from the J-11B in the late 2000s. First flew in 2011.\n\n## Operational career\nBackbone of modern Chinese tactical aviation. J-16D electronic-warfare variant analogous to the US EA-18G Growler. Integrated in power-projection exercises toward Taiwan and in the South China Sea.\n\n## Legacy\nMore than **300 built**. Represents the culmination of the Chinese Flanker family, before the progressive arrival of the stealth J-20 and J-35.'
WHERE name = 'Shenyang J-16'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nÉquivalent chinois du **F-15E Strike Eagle** et du Su-30. Biplace multi-rôle lourd développé à partir du J-11B à la fin des années 2000. Premier vol en 2011.\n\n## Carrière opérationnelle\nPilier de l''aviation tactique chinoise moderne. Version J-16D de guerre électronique analogue à l''EA-18G Growler américain. Intégré dans les exercices de projection de puissance vers Taïwan et en mer de Chine méridionale.\n\n## Héritage\nPlus de **300 exemplaires** produits. Représente l''aboutissement de la famille Flanker chinoise, avant l''arrivée progressive des J-20 et J-35 furtifs.',
       E'## Genesis\nChinese equivalent of the **F-15E Strike Eagle** and the Su-30. Heavy two-seat multi-role aircraft developed from the J-11B in the late 2000s. First flew in 2011.\n\n## Operational career\nBackbone of modern Chinese tactical aviation. J-16D electronic-warfare variant analogous to the US EA-18G Growler. Integrated in power-projection exercises toward Taiwan and in the South China Sea.\n\n## Legacy\nMore than **300 built**. Represents the culmination of the Chinese Flanker family, before the progressive arrival of the stealth J-20 and J-35.');
UPDATE airplanes SET stealth_level = 'reduite' WHERE name = 'Shenyang J-16' AND stealth_level IS DISTINCT FROM 'reduite';
UPDATE airplanes SET
  length = 11.36, wingspan = 10.08, height = 3.8, wing_area = 22.6,
  empty_weight = 3939, mtow = 6055, service_ceiling = 14700, climb_rate = 35,
  combat_radius = 560, crew = 1,
  engine_name = 'WP-5D', engine_count = 1,
  engine_type = 'Turboréacteur', engine_type_en = 'Turbojet',
  thrust_dry = 26.48,
  production_start = 1956, production_end = 1959, units_built = 767,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Shenyang_J-5',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Shenyang_J-5'
WHERE name = 'Shenyang J-5'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, climb_rate, combat_radius,
       crew, engine_name, engine_count, engine_type, engine_type_en, thrust_dry, production_start,
       production_end, units_built, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (11.36, 10.08, 3.8, 22.6, 3939, 6055, 14700, 35, 560, 1, 'WP-5D', 1, 'Turboréacteur', 'Turbojet',
       26.48, 1956, 1959, 767, 'https://fr.wikipedia.org/wiki/Shenyang_J-5',
       'https://en.wikipedia.org/wiki/Shenyang_J-5');
UPDATE airplanes SET
  unit_cost_usd = 200000, unit_cost_year = 1958,
  operators_count = 15
WHERE name = 'Shenyang J-5'
  AND (unit_cost_usd, unit_cost_year, operators_count)
      IS DISTINCT FROM
      (200000, 1958, 15);
UPDATE airplanes SET
  description = E'## Genèse\nCopie chinoise sous licence du **MiG-17F soviétique** produite à partir de 1956. Premier chasseur à réaction produit en Chine, base de l''industrie aéronautique militaire chinoise.\n\n## Carrière opérationnelle\nEngagé dans les affrontements **Chine-Taïwan** des années 1950-60 (crise du détroit de Formose). Exporté en Corée du Nord, Vietnam, Albanie, Égypte, Pakistan. Premiers combats aériens de l''aviation chinoise.\n\n## Héritage\nRetiré depuis les années 1990. Pierre fondatrice de l''industrie aéronautique militaire chinoise, qui aboutira 70 ans plus tard au J-20 furtif.',
  description_en = E'## Genesis\nChinese licence-built copy of the Soviet **MiG-17F**, produced from 1956. First jet fighter produced in China, foundation stone of the Chinese military aviation industry.\n\n## Operational career\nUsed in the **China-Taiwan** clashes of the 1950s-60s (Taiwan Strait crises). Exported to North Korea, Vietnam, Albania, Egypt, Pakistan. First air combats of Chinese aviation.\n\n## Legacy\nRetired since the 1990s. Foundation stone of the Chinese military aviation industry, which would lead 70 years later to the stealth J-20.'
WHERE name = 'Shenyang J-5'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nCopie chinoise sous licence du **MiG-17F soviétique** produite à partir de 1956. Premier chasseur à réaction produit en Chine, base de l''industrie aéronautique militaire chinoise.\n\n## Carrière opérationnelle\nEngagé dans les affrontements **Chine-Taïwan** des années 1950-60 (crise du détroit de Formose). Exporté en Corée du Nord, Vietnam, Albanie, Égypte, Pakistan. Premiers combats aériens de l''aviation chinoise.\n\n## Héritage\nRetiré depuis les années 1990. Pierre fondatrice de l''industrie aéronautique militaire chinoise, qui aboutira 70 ans plus tard au J-20 furtif.',
       E'## Genesis\nChinese licence-built copy of the Soviet **MiG-17F**, produced from 1956. First jet fighter produced in China, foundation stone of the Chinese military aviation industry.\n\n## Operational career\nUsed in the **China-Taiwan** clashes of the 1950s-60s (Taiwan Strait crises). Exported to North Korea, Vietnam, Albania, Egypt, Pakistan. First air combats of Chinese aviation.\n\n## Legacy\nRetired since the 1990s. Foundation stone of the Chinese military aviation industry, which would lead 70 years later to the stealth J-20.');
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Shenyang J-5' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET
  length = 15.65, wingspan = 9.68, height = 4.51, wing_area = 27.95,
  empty_weight = 6375, mtow = 11830, service_ceiling = 15900, climb_rate = 180,
  combat_radius = 600, crew = 1,
  engine_name = 'WP-6A', engine_count = 2,
  engine_type = 'Turboréacteur avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 25.5, thrust_wet = 36.78,
  production_start = 1970, production_end = 2012, units_built = 1300,
  operators_count = 7,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Nanchang_Q-5',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Nanchang_Q-5'
WHERE name = 'Nanchang Q-5'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, climb_rate, combat_radius,
       crew, engine_name, engine_count, engine_type, engine_type_en, thrust_dry, thrust_wet,
       production_start, production_end, units_built, operators_count, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (15.65, 9.68, 4.51, 27.95, 6375, 11830, 15900, 180, 600, 1, 'WP-6A', 2,
       'Turboréacteur avec postcombustion', 'Afterburning turbojet', 25.5, 36.78, 1970, 2012, 1300, 7,
       'https://fr.wikipedia.org/wiki/Nanchang_Q-5', 'https://en.wikipedia.org/wiki/Nanchang_Q-5');
UPDATE airplanes SET
  unit_cost_usd = 2000000, unit_cost_year = 1975
WHERE name = 'Nanchang Q-5'
  AND (unit_cost_usd, unit_cost_year)
      IS DISTINCT FROM
      (2000000, 1975);
UPDATE airplanes SET
  description = E'## Genèse\nDérivé d''attaque au sol du J-6 (MiG-19 chinois) développé dans les années 1960. Fuselage allongé, prise d''air latérale pour loger un radar bombardement, soute à bombes interne pour emport nucléaire tactique.\n\n## Carrière opérationnelle\nChasseur-bombardier principal de la PLA Air Force pendant 40 ans. Exporté en **7 pays** dont Pakistan, Bangladesh, Corée du Nord, Myanmar. Engagé dans les tensions avec l''Inde et les conflits birmans.\n\n## Héritage\nPlus de **1 300 exemplaires** produits. Retiré de Chine en 2017. Pakistan dernier opérateur actif. Témoin de la montée en puissance de l''industrie aéronautique chinoise.',
  description_en = E'## Genesis\nGround-attack derivative of the J-6 (Chinese MiG-19) developed in the 1960s. Lengthened fuselage, side air intakes to accommodate a bombing radar, internal weapons bay for tactical nuclear delivery.\n\n## Operational career\nMain fighter-bomber of the PLA Air Force for 40 years. Exported to **7 countries** including Pakistan, Bangladesh, North Korea, Myanmar. Used in tensions with India and Burmese conflicts.\n\n## Legacy\nMore than **1,300 built**. Retired from China in 2017. Pakistan last active operator. A witness to the rise of the Chinese aeronautical industry.'
WHERE name = 'Nanchang Q-5'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nDérivé d''attaque au sol du J-6 (MiG-19 chinois) développé dans les années 1960. Fuselage allongé, prise d''air latérale pour loger un radar bombardement, soute à bombes interne pour emport nucléaire tactique.\n\n## Carrière opérationnelle\nChasseur-bombardier principal de la PLA Air Force pendant 40 ans. Exporté en **7 pays** dont Pakistan, Bangladesh, Corée du Nord, Myanmar. Engagé dans les tensions avec l''Inde et les conflits birmans.\n\n## Héritage\nPlus de **1 300 exemplaires** produits. Retiré de Chine en 2017. Pakistan dernier opérateur actif. Témoin de la montée en puissance de l''industrie aéronautique chinoise.',
       E'## Genesis\nGround-attack derivative of the J-6 (Chinese MiG-19) developed in the 1960s. Lengthened fuselage, side air intakes to accommodate a bombing radar, internal weapons bay for tactical nuclear delivery.\n\n## Operational career\nMain fighter-bomber of the PLA Air Force for 40 years. Exported to **7 countries** including Pakistan, Bangladesh, North Korea, Myanmar. Used in tensions with India and Burmese conflicts.\n\n## Legacy\nMore than **1,300 built**. Retired from China in 2017. Pakistan last active operator. A witness to the rise of the Chinese aeronautical industry.');
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Nanchang Q-5' AND stealth_level IS DISTINCT FROM 'aucune';
UPDATE airplanes SET
  length = 21.94, wingspan = 14.70, height = 6.36, wing_area = 62.0,
  empty_weight = 18400, mtow = 38800, service_ceiling = 17300, climb_rate = 230,
  combat_radius = 1500, crew = 2, g_limit_pos = 9.0,
  engine_name = 'Saturn AL-31FP', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion et poussée vectorielle', engine_type_en = 'Thrust-vectoring afterburning turbofan',
  thrust_dry = 74.5, thrust_wet = 122.6,
  production_start = 1994, production_end = NULL, units_built = 630,
  operators_count = 10,
  nickname = 'Flanker-C',
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Soukho%C3%AF_Su-30',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Sukhoi_Su-30'
WHERE name = 'Su-30'
  AND (length, wingspan, height, wing_area, empty_weight, mtow, service_ceiling, climb_rate, combat_radius,
       crew, g_limit_pos, engine_name, engine_count, engine_type, engine_type_en, thrust_dry, thrust_wet,
       production_start, production_end, units_built, operators_count, nickname, wikipedia_fr, wikipedia_en)
      IS DISTINCT FROM
      (21.94, 14.70, 6.36, 62.0, 18400, 38800, 17300, 230, 1500, 2, 9.0, 'Saturn AL-31FP', 2,
       'Turbofan avec postcombustion et poussée vectorielle', 'Thrust-vectoring afterburning turbofan',
       74.5, 122.6, 1994, NULL, 630, 10, 'Flanker-C', 'https://fr.wikipedia.org/wiki/Soukho%C3%AF_Su-30',
       'https://en.wikipedia.org/wiki/Sukhoi_Su-30');
UPDATE airplanes SET
  unit_cost_usd = 50000000, unit_cost_year = 2018,
  variants    = E'- **Su-30MK** : version export initiale\n- **Su-30MKK** : export Chine\n- **Su-30MKI** : export Inde (canards, AL-31FP vectoriel)\n- **Su-30SM** : version russe moderne\n- **Su-30MKM/MKA/MKV** : Malaisie, Algérie, Venezuela',
  variants_en = E'- **Su-30MK** : initial export\n- **Su-30MKK** : Chinese export\n- **Su-30MKI** : Indian export (canards, thrust-vectoring AL-31FP)\n- **Su-30SM** : modern Russian version\n- **Su-30MKM/MKA/MKV** : Malaysia, Algeria, Venezuela'
WHERE name = 'Su-30'
  AND (unit_cost_usd, unit_cost_year, variants, variants_en)
      IS DISTINCT FROM
      (50000000, 2018,
       E'- **Su-30MK** : version export initiale\n- **Su-30MKK** : export Chine\n- **Su-30MKI** : export Inde (canards, AL-31FP vectoriel)\n- **Su-30SM** : version russe moderne\n- **Su-30MKM/MKA/MKV** : Malaisie, Algérie, Venezuela',
       E'- **Su-30MK** : initial export\n- **Su-30MKK** : Chinese export\n- **Su-30MKI** : Indian export (canards, thrust-vectoring AL-31FP)\n- **Su-30SM** : modern Russian version\n- **Su-30MKM/MKA/MKV** : Malaysia, Algeria, Venezuela');
UPDATE airplanes SET
  description = E'## Genèse\nÉvolution biplace multi-rôle du Su-27 développée dans les années 1990-2000. Plusieurs variantes d''export nommées selon le client : **MKK** (Chine), **MKI** (Inde, avec canards et poussée vectorielle), **MKM** (Malaisie), **SM** (Russie).\n\n## Carrière opérationnelle\nChasseur principal de l''Indian Air Force (272 ex. MKI), de la Chine, du Vietnam, d''Algérie, Venezuela, Ouganda. Engagé en Syrie (Russie), en Ukraine (Russie, 2022+). Grand succès à l''export russe des années 2000.\n\n## Héritage\nProduit à **600+ exemplaires**. L''équivalent fonctionnel russe du F-15E américain. Son succès a financé la base industrielle russe d''aviation de combat pendant la décennie de crise post-soviétique.',
  description_en = E'## Genesis\nTwo-seat multi-role evolution of the Su-27 developed in the 1990s-2000s. Several export variants named after the customer: **MKK** (China), **MKI** (India, with canards and thrust vectoring), **MKM** (Malaysia), **SM** (Russia).\n\n## Operational career\nMain fighter of the Indian Air Force (272 MKI), China, Vietnam, Algeria, Venezuela, Uganda. Used in Syria (Russia), in Ukraine (Russia, 2022+). Major Russian export success in the 2000s.\n\n## Legacy\nProduced to **600+ airframes**. The Russian functional counterpart of the US F-15E. Its success funded the Russian combat-aviation industrial base through the post-Soviet crisis decade.'
WHERE name = 'Su-30'
  AND (description, description_en)
      IS DISTINCT FROM
      (E'## Genèse\nÉvolution biplace multi-rôle du Su-27 développée dans les années 1990-2000. Plusieurs variantes d''export nommées selon le client : **MKK** (Chine), **MKI** (Inde, avec canards et poussée vectorielle), **MKM** (Malaisie), **SM** (Russie).\n\n## Carrière opérationnelle\nChasseur principal de l''Indian Air Force (272 ex. MKI), de la Chine, du Vietnam, d''Algérie, Venezuela, Ouganda. Engagé en Syrie (Russie), en Ukraine (Russie, 2022+). Grand succès à l''export russe des années 2000.\n\n## Héritage\nProduit à **600+ exemplaires**. L''équivalent fonctionnel russe du F-15E américain. Son succès a financé la base industrielle russe d''aviation de combat pendant la décennie de crise post-soviétique.',
       E'## Genesis\nTwo-seat multi-role evolution of the Su-27 developed in the 1990s-2000s. Several export variants named after the customer: **MKK** (China), **MKI** (India, with canards and thrust vectoring), **MKM** (Malaysia), **SM** (Russia).\n\n## Operational career\nMain fighter of the Indian Air Force (272 MKI), China, Vietnam, Algeria, Venezuela, Uganda. Used in Syria (Russia), in Ukraine (Russia, 2022+). Major Russian export success in the 2000s.\n\n## Legacy\nProduced to **600+ airframes**. The Russian functional counterpart of the US F-15E. Its success funded the Russian combat-aviation industrial base through the post-Soviet crisis decade.');
-- Le bloc d'origine posait manufacturer_page puis la remettait à NULL : seule
-- la valeur finale est rejouée, sinon chaque rejeu modifierait deux fois la ligne.
UPDATE airplanes SET manufacturer_page = NULL WHERE name = 'Su-30' AND manufacturer_page IS DISTINCT FROM NULL;
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=gNx6DV8EcF8'
WHERE name = 'Su-30'
  AND youtube_showcase IS DISTINCT FROM 'https://www.youtube.com/watch?v=gNx6DV8EcF8';
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Su-30' AND stealth_level IS DISTINCT FROM 'aucune';

-- Une clé étrangère nulle n'interrompt pas un INSERT : une fiche qui référence
-- un constructeur absent au moment du chargement entre en base avec
-- id_manufacturer = NULL, en silence — et une attribution erronée y reste
-- tout aussi discrètement (le F-8E (FN) Crusader était donné à Lockheed
-- Martin au lieu de Vought). On réaffirme donc le constructeur de chaque
-- fiche d'après sa source. Sans écart, ces instructions ne touchent rien.

UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'A-10 Thunderbolt II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'Lockheed A-12'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'A-1 Skyraider'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'A-26 Invader'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ADS' AND a.name = 'Airbus A330 MRTT'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CES' AND a.name = 'A-37 Dragonfly'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'A-3 Skywarrior'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ADS' AND a.name = 'Airbus A400M Atlas'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'A-4 Skyhawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BER' AND a.name = 'Beriev A-50'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'A-5 Vigilante'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'A-6 Intruder'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LTV' AND a.name = 'A-7 Corsair II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'AC-130 Spectre'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'Aermacchi MB-339'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AIDC' AND a.name = 'AIDC AT-3 Tzu Chung'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BRG' AND a.name = 'Breguet Alizé'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ADS' AND a.name = 'Alpha Jet Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'AMX A-1 Brésilien'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'AMX International AMX'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-12'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-124 Ruslan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-22 Antei'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-26'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-32'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-72'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BRG' AND a.name = 'Breguet Atlantique'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ATL' AND a.name = 'Atlas Cheetah'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ATL' AND a.name = 'Atlas Impala'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'AV-8B Harrier II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AVR' AND a.name = 'Avro Shackleton'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AVR' AND a.name = 'Avro Vulcan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'B-1 Lancer'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'B-21 Raider'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'B-29 Superfortress'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'B-2 Spirit'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CVR' AND a.name = 'B-36 Peacemaker'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'B-47 Stratojet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'B-52 Stratofortress'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CVR' AND a.name = 'B-58 Hustler'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAC' AND a.name = 'BAC TSR-2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAE' AND a.name = 'BAE Hawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'Embraer EMB-110 Bandeirante'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAY' AND a.name = 'Bayraktar TB2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BER' AND a.name = 'Beriev Be-12 Chaïka'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BER' AND a.name = 'Beriev Be-200'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BEL' AND a.name = 'Bell X-1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAE' AND a.name = 'Blackburn Buccaneer'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BN' AND a.name = 'Britten-Norman Defender'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AIDC' AND a.name = 'AIDC T-5 Brave Eagle'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CASA' AND a.name = 'CASA C-101 Aviojet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FRC' AND a.name = 'C-119 Flying Boxcar'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'C-130 Hercules'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'C-141 Starlifter'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'C-17 Globemaster III'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CASA' AND a.name = 'CASA C-212 Aviocar'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'Alenia C-27J Spartan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'C-2 Greyhound'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'C-5 Galaxy'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CWA' AND a.name = 'CAC CA-27 Sabre'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EE' AND a.name = 'English Electric Canberra'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AVC' AND a.name = 'Avro Canada CF-100 Canuck'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AVC' AND a.name = 'Avro Canada CF-105 Arrow'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAMC' AND a.name = 'Nanchang CJ-6'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IPTN' AND a.name = 'CASA/IPTN CN-235'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CDR' AND a.name = 'Canadair CT-114 Tutor'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'Lockheed D-21'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'D-558-2 Skyrocket'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DH' AND a.name = 'de Havilland Venom'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DHC' AND a.name = 'DHC-4 Caribou'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DHC' AND a.name = 'DHC-5 Buffalo'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOR' AND a.name = 'Dornier Do 28 Skyservant'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOR' AND a.name = 'Dornier Do 31'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'E-2 Hawkeye'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'E-3 Sentry'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'Embraer E-99'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'EA-18G Growler'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'EA-6B Prowler'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'EC-121 Warning Star'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'Embraer EMB-312 Tucano'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'Embraer EMB-314 Super Tucano'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'Embraer EMB-326 Xavante'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ENA' AND a.name = 'ENAER T-35 Pillán'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EE' AND a.name = 'English Electric Lightning'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Étendard IV'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ADS' AND a.name = 'Eurofighter Typhoon Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAE' AND a.name = 'Eurofighter Typhoon Anglais'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'Eurofighter Typhoon Italien'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'F-100 Super Sabre'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'F-101 Voodoo'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CVR' AND a.name = 'F-102 Delta Dagger'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-104 Starfighter Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'F-104S Starfighter Italien'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-104 Starfighter'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'Mitsubishi F-104J'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'REP' AND a.name = 'F-105 Thunderchief'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CVR' AND a.name = 'F-106 Delta Dart'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-111 Aardvark'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-117 Nighthawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'F11F Tiger'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-14 Tomcat'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'F-15 Eagle'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F-15E Strike Eagle'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F-15EX Eagle II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F-15I Ra''am'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'Mitsubishi F-15J'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-16 Fighting Falcon'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-16I Sufa'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GD' AND a.name = 'F-16XL'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'F-20 Tigershark'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-22 Raptor'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FOK' AND a.name = 'Fokker F27 Maritime'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CVR' AND a.name = 'F2Y Sea Dart'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-35 Lightning II Italien'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-35 Lightning II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-35B Lightning II Anglais'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-35I Adir'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'F3D Skyknight'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F-4 Phantom II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F-4 Phantom II Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'F4D Skyray'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F-4E Kurnass'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'F-4EJ Kai'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-5 Freedom Fighter'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'F-5EM Tiger II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VOU' AND a.name = 'F7U Cutlass'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-80 Shooting Star'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'F-82 Twin Mustang'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'REP' AND a.name = 'F-84F Thunderstreak'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'F-86 Sabre'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'F-89 Scorpion'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VOU' AND a.name = 'F-8 Crusader'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VOU' AND a.name = 'F-8E (FN) Crusader'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'F-94 Starfire'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'F9F Cougar'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'F9F Panther'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'F/A-18 Hornet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'F/A-18E Super Hornet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KAI' AND a.name = 'KAI FA-50'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FAI' AND a.name = 'Fairey Delta 2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FAI' AND a.name = 'Fairey Firefly'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FAI' AND a.name = 'Fairey Gannet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AIDC' AND a.name = 'AIDC F-CK-1 Ching-kuo'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FFA' AND a.name = 'FFA P-16'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FIAT' AND a.name = 'Fiat G.91'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'RYA' AND a.name = 'Ryan Firebee'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FOK' AND a.name = 'Fokker S.14 Machtrainer'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FOL' AND a.name = 'Folland Gnat'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FOU' AND a.name = 'Fouga CM.170 Magister'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FUJ' AND a.name = 'Fuji T-7'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AIT' AND a.name = 'Aeritalia G.222'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SOKO' AND a.name = 'Soko G-2 Galeb'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GAF' AND a.name = 'GAF Nomad'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GLO' AND a.name = 'Gloster Javelin'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GLO' AND a.name = 'Gloster Meteor'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'XAC' AND a.name = 'Xian H-6'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HSP' AND a.name = 'Hispano HA-200 Saeta'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL Ajeet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL AMCA'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL Tejas Mk1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL Tejas Mk1A'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL Tejas Mk2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HFB' AND a.name = 'HFB 320 Hansa Jet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HS' AND a.name = 'Hawker Hunter'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HS' AND a.name = 'Hawker Siddeley Harrier'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HEL' AND a.name = 'Helwan HA-300'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ELB' AND a.name = 'Elbit Hermes 900'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL HF-24 Marut'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'HAL HJT-36 Sitara'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HP' AND a.name = 'Handley Page Victor'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FMA' AND a.name = 'FMA IA 58 Pucará'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FMA' AND a.name = 'FMA IA 63 Pampa'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAI' AND a.name = 'IAI Arava'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAI' AND a.name = 'IAI Harop'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAI' AND a.name = 'IAI Heron'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAI' AND a.name = 'IAI Kfir'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAI' AND a.name = 'IAI Lavi'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAI' AND a.name = 'IAI Nesher'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'IAR' AND a.name = 'IAR-99 Șoim'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ILY' AND a.name = 'Iliouchine Il-114'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ILY' AND a.name = 'Iliouchine Il-20'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ILY' AND a.name = 'Iliouchine Il-38'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ILY' AND a.name = 'Iliouchine Il-76'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ILY' AND a.name = 'Iliouchine Il-78 Midas'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ILY' AND a.name = 'Il-28'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CAC' AND a.name = 'Chengdu J-10'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-11'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-16'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CAC' AND a.name = 'Chengdu J-20'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SOKO' AND a.name = 'Soko J-22 Orao'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-35'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-5'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-6'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CAC' AND a.name = 'Chengdu J-7'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAC' AND a.name = 'Shenyang J-8'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Jaguar'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAL' AND a.name = 'Jaguar IS'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HUN' AND a.name = 'Jet Provost'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CAC' AND a.name = 'Chengdu FC-1/JF-17'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GAF' AND a.name = 'GAF Jindivik'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HONG' AND a.name = 'Hongdu JL-8'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GAIC' AND a.name = 'Guizhou JL-9'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HONG' AND a.name = 'Hongdu K-8 Karakorum'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KHI' AND a.name = 'Kawasaki C-1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KHI' AND a.name = 'Kawasaki C-2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KHI' AND a.name = 'Kawasaki P-1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KHI' AND a.name = 'Kawasaki T-4'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'KC-10 Extender'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'KC-135 Stratotanker'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EMB' AND a.name = 'Embraer KC-390 Millennium'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'KC-46 Pegasus'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'KC-97 Stratofreighter'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KAI' AND a.name = 'KAI KF-21 Boramae'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KAI' AND a.name = 'KAI KT-1 Woongbi'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AERO' AND a.name = 'Aero L-159 ALCA'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HONG' AND a.name = 'Hongdu L-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AERO' AND a.name = 'Aero L-29 Delfín'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AERO' AND a.name = 'Aero L-39 Albatros'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LET' AND a.name = 'Let L-410 Turbolet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LAV' AND a.name = 'La-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PZL' AND a.name = 'PZL M28 Skytruck'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'M-346 Master'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MYA' AND a.name = 'Myasishchev M-4'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MYA' AND a.name = 'Myasishchev M-50'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MYA' AND a.name = 'Myasishchev M-55'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'Aermacchi MB-326'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Dassault MD 315 Flamant'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG 1.44'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-21 Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-21 Bison'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-23 Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-29 Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-17'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-19'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-21'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-23'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-25'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-27'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-29'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-31'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-35'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MIG' AND a.name = 'MiG-9'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage 4000'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage 2000'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage 2000H Vajra'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage III'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage IIICJ Shahak'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage III V'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage IV'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage 5'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage F1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mirage G8'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'Mitsubishi F-1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'Mitsubishi F-2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'Mitsubishi T-2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GA' AND a.name = 'MQ-1 Predator'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'MQ-25 Stingray'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GA' AND a.name = 'MQ-9 Reaper'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Mystère IV'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'nEUROn'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HS' AND a.name = 'Hawker Siddeley Nimrod'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NRD' AND a.name = 'Nord Noratlas'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Ouragan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ROC' AND a.name = 'OV-10 Bronco'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'OV-1 Mohawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HS' AND a.name = 'Hawker P.1127 Kestrel'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'P-2 Neptune'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'P-3 Orion'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'P-8 Poseidon'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PIL' AND a.name = 'Pilatus PC-7'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PIL' AND a.name = 'Pilatus PC-9'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PZLW' AND a.name = 'PZL-130 Orlik'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAMC' AND a.name = 'Nanchang Q-5'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Rafale'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Rafale EH'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'RQ-4 Global Hawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'S-3 Viking'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAL' AND a.name = 'Scottish Aviation Bulldog'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 105'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 29 Tunnan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 32 Lansen'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 35 Draken'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 37 Viggen'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab GlobalEye'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab JAS 39 Gripen'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HESA' AND a.name = 'HESA Saeqeh'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHO' AND a.name = 'Short SC.1'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUP' AND a.name = 'Supermarine Scimitar'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAE' AND a.name = 'BAE Sea Harrier'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HS' AND a.name = 'Hawker Sea Hawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DH' AND a.name = 'Sea Vixen'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SIAI' AND a.name = 'SF.260'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHO' AND a.name = 'Shorts Tucano'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SRO' AND a.name = 'Saunders-Roe SR.53'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'SR-71 Blackbird'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-11'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-30MKI'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-17'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-24'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-25'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-27'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-30'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-33'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-34'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-35'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-57'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-7'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Su-9'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Sukhoi T-4'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Super Étendard'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SOKO' AND a.name = 'Soko G-4 Super Galeb'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PAC' AND a.name = 'PAC Super Mushshak'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DAS' AND a.name = 'Super Mystère B2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUP' AND a.name = 'Supermarine Attacker'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUP' AND a.name = 'Supermarine Swift'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'T-28 Trojan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'T-33 Shooting Star'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BEE' AND a.name = 'T-34 Mentor'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CES' AND a.name = 'T-37 Tweet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'T-38 Talon'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KAI' AND a.name = 'KAI T-50 Golden Eagle'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BEE' AND a.name = 'T-6 Texan II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TAI' AND a.name = 'TAI Hürkuş'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TAI' AND a.name = 'TAI Kaan'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SOC' AND a.name = 'SOCATA TB-30 Epsilon'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAE' AND a.name = 'Panavia Tornado'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ADS' AND a.name = 'Panavia Tornado Allemand'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LEO' AND a.name = 'Panavia Tornado Italien'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TRA' AND a.name = 'Transall C-160'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PZL' AND a.name = 'PZL TS-11 Iskra'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-141 Strizh'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-143 Reys'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-128'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-142'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-16'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-160'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-22M'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-22'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tupolev Tu-4'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TUP' AND a.name = 'Tu-95'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'U-2 Dragon Lady'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHM' AND a.name = 'ShinMaywa US-1A'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHM' AND a.name = 'ShinMaywa US-2'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VFW' AND a.name = 'VFW VAK 191B'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VAL' AND a.name = 'Valmet L-70 Vinka'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DH' AND a.name = 'de Havilland Vampire'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUD' AND a.name = 'Vautour II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VIC' AND a.name = 'Vickers VC10'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VIC' AND a.name = 'Vickers Valiant'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'EWR' AND a.name = 'EWR VJ 101'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'WES' AND a.name = 'Westland Wyvern'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CAC' AND a.name = 'Wing Loong II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'RYA' AND a.name = 'X-13 Vertijet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BEL' AND a.name = 'Bell X-14'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'X-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'X-29'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MHI' AND a.name = 'Mitsubishi X-2 Shinshin'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ROC' AND a.name = 'X-31'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'Boeing X-32'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'X-3 Stiletto'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'X-47B'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NAA' AND a.name = 'XB-70 Valkyrie'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LTV' AND a.name = 'LTV XC-142'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ROC' AND a.name = 'Rockwell XFV-12'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'Lockheed XFV'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CVR' AND a.name = 'XFY Pogo'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'KRA' AND a.name = 'XQ-58 Valkyrie'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'XAC' AND a.name = 'Xian Y-20 Kunpeng'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHX' AND a.name = 'Shaanxi Y-8'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-141'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-23'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-36'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-38'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-130'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-25'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-28'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'YF-17 Cobra'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'YF-22'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'YF-23 Black Widow II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'PIL' AND a.name = 'Pilatus PC-21'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'Boeing T-7 Red Hawk'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CASA' AND a.name = 'Airbus C295'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ANT' AND a.name = 'Antonov An-225 Mriya'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAY' AND a.name = 'Bayraktar Akıncı'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'YAK' AND a.name = 'Yak-17'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'B-66 Destroyer'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MAR' AND a.name = 'Martin B-57 Canberra'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'S-2 Tracker'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHX' AND a.name = 'Shaanxi KJ-500'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BEL' AND a.name = 'V-22 Osprey'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BEL' AND a.name = 'Bell XV-15'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAY' AND a.name = 'Bayraktar Kızılelma'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TAI' AND a.name = 'TAI Anka'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'MQ-28 Ghost Bat'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUK' AND a.name = 'Sukhoi S-70 Okhotnik'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HONG' AND a.name = 'Hongdu GJ-11 Sharp Sword'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CASC' AND a.name = 'CASC CH-5 Rainbow'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'Boeing X-45'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'MQ-4C Triton'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'TAI' AND a.name = 'TAI Hürjet'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'AERO' AND a.name = 'Aero L-39NG Skyfox'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BOE' AND a.name = 'Boeing E-7 Wedgetail'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GA' AND a.name = 'General Atomics YFQ-42A Dark Merlin'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'ELB' AND a.name = 'Elbit Hermes 450'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GA' AND a.name = 'MQ-1C Gray Eagle'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'BAY' AND a.name = 'Bayraktar TB3'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 21R'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FMA' AND a.name = 'IAe 33 Pulqui II'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'FH-1 Phantom'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'F2H Banshee'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'MDD' AND a.name = 'F3H Demon'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'Northrop YB-49'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LED' AND a.name = 'Leduc 010'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NRD' AND a.name = 'Nord 1500 Griffon'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SUD' AND a.name = 'SNCASO Trident'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'VOU' AND a.name = 'F4U Corsair'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'HAW' AND a.name = 'Hawker Sea Fury'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'F8F Bearcat'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DOU' AND a.name = 'AC-47 Spooky'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CDR' AND a.name = 'Canadair CP-107 Argus'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'HU-16 Albatross'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'GRU' AND a.name = 'E-1 Tracer'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'XAC' AND a.name = 'KJ-2000'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SAAB' AND a.name = 'Saab 340 AEW&C'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'SHX' AND a.name = 'Shaanxi Y-9'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'FRC' AND a.name = 'C-123 Provider'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'DHC' AND a.name = 'DHC-2 Beaver'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'CDR' AND a.name = 'Canadair CL-84 Dynavert'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'NOR' AND a.name = 'Northrop Tacit Blue'
   AND a.id_manufacturer IS DISTINCT FROM m.id;
UPDATE airplanes a SET id_manufacturer = m.id FROM manufacturer m
 WHERE m.code = 'LM' AND a.name = 'Lockheed Martin X-59 QueSST'
   AND a.id_manufacturer IS DISTINCT FROM m.id;

-- Le canon M39 du F-5 avait été rangé par erreur parmi les technologies ;
-- il est désormais déclaré comme armement. On retire la ligne obsolète.
DELETE FROM airplane_tech t USING tech r, airplanes a
 WHERE t.id_tech = r.id AND t.id_airplane = a.id
   AND r.name = 'Canon M39' AND a.name = 'F-5 Freedom Fighter';

-- ═══ 6. Corrections issues de l'audit base ═══════════════════
--
-- Ces corrections portent sur des données et un schéma déjà installés :
-- une base en production ne les recevrait pas par l'import des fiches.

-- Colonnes temporelles : `TIMESTAMP` ne porte pas de fuseau, si bien qu'une
-- expiration de jeton se décale quand le serveur change de zone. Une seule
-- colonne (`users.locked_until`) était déjà en TIMESTAMPTZ : on uniformise.
-- La conversion interprète les valeurs existantes dans le fuseau du serveur,
-- ce qui est correct puisqu'elles ont été écrites par NOW() sous ce même fuseau.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'users' AND column_name = 'created_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE users ALTER COLUMN created_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'users' AND column_name = 'updated_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE users ALTER COLUMN updated_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'refresh_tokens' AND column_name = 'expires_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE refresh_tokens ALTER COLUMN expires_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'refresh_tokens' AND column_name = 'created_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE refresh_tokens ALTER COLUMN created_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'email_tokens' AND column_name = 'expires_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE email_tokens ALTER COLUMN expires_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'email_tokens' AND column_name = 'used_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE email_tokens ALTER COLUMN used_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'email_tokens' AND column_name = 'created_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE email_tokens ALTER COLUMN created_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'favorites' AND column_name = 'created_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE favorites ALTER COLUMN created_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'airplanes' AND column_name = 'created_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE airplanes ALTER COLUMN created_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'airplanes' AND column_name = 'updated_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE airplanes ALTER COLUMN updated_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'timeline_events' AND column_name = 'created_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE timeline_events ALTER COLUMN created_at TYPE TIMESTAMPTZ;
  END IF;
END $$;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'timeline_events' AND column_name = 'updated_at'
               AND data_type = 'timestamp without time zone') THEN
    ALTER TABLE timeline_events ALTER COLUMN updated_at TYPE TIMESTAMPTZ;
  END IF;
END $$;

-- Statuts : le catalogue employait « Actif » et « En service » pour le même
-- état, et 33 fiches n'avaient pas de traduction. Un libellé par état.
UPDATE airplanes SET status = 'En service' WHERE status = 'Actif' AND status IS DISTINCT FROM 'En service';
UPDATE airplanes SET status_en = 'In service' WHERE status = 'En service' AND status_en IS DISTINCT FROM 'In service';
UPDATE airplanes SET status_en = 'Retired' WHERE status = 'Retiré' AND status_en IS DISTINCT FROM 'Retired';
UPDATE airplanes SET status_en = 'Cancelled' WHERE status = 'Annulé' AND status_en IS DISTINCT FROM 'Cancelled';
UPDATE airplanes SET status_en = 'In development' WHERE status = 'En développement' AND status_en IS DISTINCT FROM 'In development';

-- Production des trois fiches d'opérateur est-allemand, jusqu'ici vides.
UPDATE airplanes SET production_start = 1959, production_end = 1985
 WHERE name = 'MiG-21 Allemand' AND production_start IS NULL
   AND (production_start, production_end)
      IS DISTINCT FROM
      (1959, 1985);
UPDATE airplanes SET production_start = 1969, production_end = 1985
 WHERE name = 'MiG-23 Allemand' AND production_start IS NULL
   AND (production_start, production_end)
      IS DISTINCT FROM
      (1969, 1985);
UPDATE airplanes SET production_start = 1982, production_end = 1991
 WHERE name = 'MiG-29 Allemand' AND production_start IS NULL
   AND (production_start, production_end)
      IS DISTINCT FROM
      (1982, 1991);

-- « Guerre d'Indochine » : retirée en v4.5.3 faute d'appareil rattachable, elle
-- revient en v4.13.0 avec le F8F Bearcat, le Flamant, le C-119… (section 2).

-- Écarts de référentiel constatés en production (v4.12.0). Une base installée
-- avant db.sql avait reçu ces huit armements par les fiches, sans traduction ;
-- la section 2, gardée par NOT EXISTS, ne complète pas une ligne existante.
UPDATE armement SET description_en = 'Short-range air-to-air missile, imaging infrared guidance, 20 km'
 WHERE name = 'PL-10' AND description_en IS NULL;
UPDATE armement SET description_en = 'Long-range air-to-air missile, active radar guidance, 200+ km'
 WHERE name = 'PL-15' AND description_en IS NULL;
UPDATE armement SET description_en = 'Subsonic anti-ship missile, active radar guidance, 180 km range'
 WHERE name = 'YJ-83' AND description_en IS NULL;
UPDATE armement SET description_en = 'Anti-radiation / anti-ship missile, 120 km range'
 WHERE name = 'YJ-91' AND description_en IS NULL;
UPDATE armement SET description_en = 'Precision air-to-surface missile, TV/IR guidance, 180 km range'
 WHERE name = 'KD-88' AND description_en IS NULL;
UPDATE armement SET description_en = 'Subsonic anti-ship missile, active radar guidance, 180 km range'
 WHERE name = 'C-802A' AND description_en IS NULL;
UPDATE armement SET description_en = 'Air-launched cruise missile, 1500-2000 km range'
 WHERE name = 'CJ-10' AND description_en IS NULL;
UPDATE armement SET description_en = 'Stealthy air-launched cruise missile, 2000+ km range'
 WHERE name = 'CJ-20' AND description_en IS NULL;

-- « Canon NR-23 » : doublon de l'armement NR-23, présent seulement sur les bases
-- anciennes et rattaché au Q-5, qui porte déjà NR-23. (L'entrée homonyme de la
-- table tech est distincte et n'est pas touchée.)
DELETE FROM airplane_armement l USING armement x
 WHERE l.id_armement = x.id AND x.name = 'Canon NR-23'
   AND EXISTS (SELECT 1 FROM airplane_armement k JOIN armement n ON n.id = k.id_armement
                WHERE k.id_airplane = l.id_airplane AND n.name = 'NR-23');
DELETE FROM armement x WHERE x.name = 'Canon NR-23'
   AND NOT EXISTS (SELECT 1 FROM airplane_armement l WHERE l.id_armement = x.id);

-- Génération 1 : libellé anglais aligné sur celui des générations 2 à 5.
UPDATE generation SET description_en = 'First generation: Subsonic jet aircraft from the 1940s–1950s'
 WHERE generation = 1 AND description_en IS DISTINCT FROM 'First generation: Subsonic jet aircraft from the 1940s–1950s';

-- Rattachements de conflits erronés : appareils soviétiques rangés sous la guerre
-- d'Afghanistan de 2001 (ils relèvent de la guerre soviéto-afghane, ajoutée en
-- section 2), appareils entrés en service après 1991 rangés sous la guerre froide,
-- et trois rattachements que le récit des fiches ne justifie pas (J-5 en Corée,
-- J-7 au Vietnam, Heron au Liban en 1982).
DELETE FROM airplane_wars l USING airplanes a, wars w
 WHERE l.id_airplane = a.id AND l.id_wars = w.id
   AND ((w.name = 'Guerre d''Afghanistan' AND a.name IN ('Antonov An-12', 'Antonov An-22 Antei', 'MiG-27', 'Su-17', 'Su-24', 'Su-25', 'Tu-16', 'Tu-22', 'Tu-22M', 'Yak-28', 'Yak-38', 'Iliouchine Il-76', 'Il-28', 'Iliouchine Il-38'))
     OR (w.name = 'Guerre de Corée' AND a.name IN ('Shenyang J-5'))
     OR (w.name = 'Guerre du Liban' AND a.name IN ('IAI Heron'))
     OR (w.name = 'Guerre du Vietnam' AND a.name IN ('Chengdu J-7'))
     OR (w.name = 'Guerre froide' AND a.name IN ('MQ-1 Predator', 'HAL Tejas Mk1', 'HAL Tejas Mk1A', 'Su-30MKI', 'MiG-21 Bison', 'Mitsubishi F-2', 'F-5EM Tiger II', 'Eurofighter Typhoon Allemand', 'Eurofighter Typhoon Italien')));

-- Audit du 2026-11-10 (CONT-001) : rattachements que l'histoire dément.
-- Étendard IV ↔ guerre d'Algérie (mise en service en juin 1962, après le
-- cessez-le-feu) ; Super Étendard ↔ guerre du Golfe (aucun engagé en 1990-1991,
-- les cinq appareils loués à l'Irak rendus en 1985) et ↔ guerre du Liban de 1982
-- (les frappes françaises datent de 1983). L'Étendard IV rejoint la guerre de
-- Yougoslavie par zz_backfill_relations.sql (IVP au-dessus de la Bosnie et du Kosovo).
DELETE FROM airplane_wars l USING airplanes a, wars w
 WHERE l.id_airplane = a.id AND l.id_wars = w.id
   AND ((w.name = 'Guerre d''Algérie' AND a.name = 'Étendard IV')
     OR (w.name IN ('Guerre du Golfe', 'Guerre du Liban') AND a.name = 'Super Étendard'));

-- Récits corrigés (CONT-001, CONT-002). Chaque remplacement ne porte que sur la
-- phrase fautive : sans effet si elle a déjà été corrigée, donc rejouable.
UPDATE airplanes SET description = replace(description,
    'Engagé par la France au Tchad, en Irak (2003).',
    'Engagé par la France au Tchad, pendant la guerre du Golfe (opération Daguet, 1991), en Afghanistan (à partir de 2007), en Libye (2011) et au Mali (2013).'),
  description_en = replace(description_en,
    'Engaged by France in Chad, Iraq (2003).',
    'Engaged by France in Chad, in the Gulf War (Operation Daguet, 1991), in Afghanistan (from 2007), in Libya (2011) and in Mali (2013).')
 WHERE name = 'Mirage F1'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(description,
    'Engagé par la France au Tchad, en Irak (2003).',
    'Engagé par la France au Tchad, pendant la guerre du Golfe (opération Daguet, 1991), en Afghanistan (à partir de 2007), en Libye (2011) et au Mali (2013).'),
       replace(description_en,
    'Engaged by France in Chad, Iraq (2003).',
    'Engaged by France in Chad, in the Gulf War (Operation Daguet, 1991), in Afghanistan (from 2007), in Libya (2011) and in Mali (2013).'));
UPDATE airplanes SET description = replace(description,
    'Engagé en Libye (2011), Syrie, Irak. ',
    'La Luftwaffe ne l''a pas engagé au combat : l''Allemagne s''est abstenue sur l''intervention en Libye (2011), et sa participation à la coalition contre l''État islamique reposait sur des Tornado de reconnaissance et des avions ravitailleurs. '),
  description_en = replace(description_en,
    'Engaged in Libya (2011), Syria, Iraq. ',
    'The Luftwaffe has not used it in combat: Germany abstained on the 2011 Libya intervention, and its contribution to the coalition against the Islamic State relied on Tornado reconnaissance aircraft and tankers. ')
 WHERE name = 'Eurofighter Typhoon Allemand'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(description,
    'Engagé en Libye (2011), Syrie, Irak. ',
    'La Luftwaffe ne l''a pas engagé au combat : l''Allemagne s''est abstenue sur l''intervention en Libye (2011), et sa participation à la coalition contre l''État islamique reposait sur des Tornado de reconnaissance et des avions ravitailleurs. '),
       replace(description_en,
    'Engaged in Libya (2011), Syria, Iraq. ',
    'The Luftwaffe has not used it in combat: Germany abstained on the 2011 Libya intervention, and its contribution to the coalition against the Islamic State relied on Tornado reconnaissance aircraft and tankers. '));
UPDATE airplanes SET description = replace(replace(description,
    'Engagé lors de la **guerre du Golfe** (1991) pour l''appui aux frégates françaises.',
    'Les Étendard IVP de reconnaissance photographique opèrent au-dessus du **Liban** (1983-1984), de la **Bosnie-Herzégovine** (à partir de 1993) et du **Kosovo** (1999).'),
    'Retiré en 1991, remplacé par le Super Étendard.',
    'Les IVM sont retirés en 1991, remplacés par le Super Étendard ; les IVP volent jusqu''en 2000.'),
  description_en = replace(replace(description_en,
    'Engaged in the **Gulf War** (1991) supporting French frigates.',
    'The IVP photo-reconnaissance version flew over **Lebanon** (1983-1984), **Bosnia-Herzegovina** (from 1993) and **Kosovo** (1999).'),
    'Retired in 1991, replaced by the Super Étendard.',
    'The IVM was retired in 1991, replaced by the Super Étendard; the IVP flew until 2000.')
 WHERE name = 'Étendard IV'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(replace(description,
    'Engagé lors de la **guerre du Golfe** (1991) pour l''appui aux frégates françaises.',
    'Les Étendard IVP de reconnaissance photographique opèrent au-dessus du **Liban** (1983-1984), de la **Bosnie-Herzégovine** (à partir de 1993) et du **Kosovo** (1999).'),
    'Retiré en 1991, remplacé par le Super Étendard.',
    'Les IVM sont retirés en 1991, remplacés par le Super Étendard ; les IVP volent jusqu''en 2000.'),
       replace(replace(description_en,
    'Engaged in the **Gulf War** (1991) supporting French frigates.',
    'The IVP photo-reconnaissance version flew over **Lebanon** (1983-1984), **Bosnia-Herzegovina** (from 1993) and **Kosovo** (1999).'),
    'Retired in 1991, replaced by the Super Étendard.',
    'The IVM was retired in 1991, replaced by the Super Étendard; the IVP flew until 2000.'));
UPDATE airplanes SET description = replace(description,
    'y compris pendant la guerre du Golfe où il assure la surveillance de surface.',
    'y compris au début de la crise du Golfe : en 1990, quatre Alizé embarqués sur le *Clemenceau* pour l''opération Salamandre assurent la surveillance maritime.'),
  description_en = replace(description_en,
    'including through the Gulf War where it provided surface surveillance.',
    'including at the start of the Gulf crisis: in 1990, four Alizés embarked on *Clemenceau* for Operation Salamandre provided maritime surveillance.')
 WHERE name = 'Breguet Alizé'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(description,
    'y compris pendant la guerre du Golfe où il assure la surveillance de surface.',
    'y compris au début de la crise du Golfe : en 1990, quatre Alizé embarqués sur le *Clemenceau* pour l''opération Salamandre assurent la surveillance maritime.'),
       replace(description_en,
    'including through the Gulf War where it provided surface surveillance.',
    'including at the start of the Gulf crisis: in 1990, four Alizés embarked on *Clemenceau* for Operation Salamandre provided maritime surveillance.'));
UPDATE airplanes SET description = replace(description,
    'Engagé en Syrie et en Ukraine.',
    'Engagé en Ukraine depuis 2022. En Syrie, sa présence se limite à deux MiG-31K déployés en juin 2021 sur la base de Hmeimim pour un exercice en Méditerranée orientale.'),
  description_en = replace(description_en,
    'Used in Syria and Ukraine.',
    'Used in combat over Ukraine since 2022. In Syria, its presence was limited to two MiG-31Ks deployed to Hmeimim in June 2021 for an exercise in the eastern Mediterranean.')
 WHERE name = 'MiG-31'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(description,
    'Engagé en Syrie et en Ukraine.',
    'Engagé en Ukraine depuis 2022. En Syrie, sa présence se limite à deux MiG-31K déployés en juin 2021 sur la base de Hmeimim pour un exercice en Méditerranée orientale.'),
       replace(description_en,
    'Used in Syria and Ukraine.',
    'Used in combat over Ukraine since 2022. In Syria, its presence was limited to two MiG-31Ks deployed to Hmeimim in June 2021 for an exercise in the eastern Mediterranean.'));
UPDATE airplanes SET description = replace(replace(description,
    'en Iran-Irak, en Érythrée-Éthiopie, au Soudan, au Yémen.',
    'dans la guerre Iran-Irak, au Liban (1982, aux mains de l''aviation syrienne), au Pérou (guerre du Cenepa, 1995), au Yémen et dans la guerre civile syrienne.'),
    'toujours en service en Syrie, Libye, Vietnam, Pérou, Angola.',
    'toujours en service en Angola, en Iran, en Libye, au Vietnam et au Yémen.'),
  description_en = replace(replace(description_en,
    'Iran-Iraq, Eritrea-Ethiopia, Sudan, Yemen.',
    'the Iran-Iraq War, Lebanon (1982, flown by the Syrian air force), Peru (Cenepa War, 1995), Yemen and the Syrian civil war.'),
    'still in service in Syria, Libya, Vietnam, Peru, Angola.',
    'still in service in Angola, Iran, Libya, Vietnam and Yemen.')
 WHERE name = 'Su-17'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(replace(description,
    'en Iran-Irak, en Érythrée-Éthiopie, au Soudan, au Yémen.',
    'dans la guerre Iran-Irak, au Liban (1982, aux mains de l''aviation syrienne), au Pérou (guerre du Cenepa, 1995), au Yémen et dans la guerre civile syrienne.'),
    'toujours en service en Syrie, Libye, Vietnam, Pérou, Angola.',
    'toujours en service en Angola, en Iran, en Libye, au Vietnam et au Yémen.'),
       replace(replace(description_en,
    'Iran-Iraq, Eritrea-Ethiopia, Sudan, Yemen.',
    'the Iran-Iraq War, Lebanon (1982, flown by the Syrian air force), Peru (Cenepa War, 1995), Yemen and the Syrian civil war.'),
    'still in service in Syria, Libya, Vietnam, Peru, Angola.',
    'still in service in Angola, Iran, Libya, Vietnam and Yemen.'));
UPDATE airplanes SET description = replace(replace(description,
    'Engagements français : Kosovo, Afghanistan, Libye, Mali, Irak (opération Chammal 2015).',
    'L''Irak en loue cinq de 1983 à 1985 pour attaquer les pétroliers pendant la guerre Iran-Irak. Engagements français : Liban (1983), Kosovo (1999), Afghanistan (2001-2011), Libye (2011), Irak (opération Chammal, 2015).'),
    'Dernier chasseur français mono-réacteur en service.',
    'Dernier avion de combat monoréacteur de l''aéronautique navale française.'),
  description_en = replace(replace(description_en,
    'French engagements: Kosovo, Afghanistan, Libya, Mali, Iraq (Operation Chammal 2015).',
    'Iraq leased five from 1983 to 1985 to strike tankers during the Iran-Iraq War. French engagements: Lebanon (1983), Kosovo (1999), Afghanistan (2001-2011), Libya (2011), Iraq (Operation Chammal, 2015).'),
    'The last single-engined French fighter in service.',
    'The last single-engined combat aircraft of French naval aviation.')
 WHERE name = 'Super Étendard'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(replace(description,
    'Engagements français : Kosovo, Afghanistan, Libye, Mali, Irak (opération Chammal 2015).',
    'L''Irak en loue cinq de 1983 à 1985 pour attaquer les pétroliers pendant la guerre Iran-Irak. Engagements français : Liban (1983), Kosovo (1999), Afghanistan (2001-2011), Libye (2011), Irak (opération Chammal, 2015).'),
    'Dernier chasseur français mono-réacteur en service.',
    'Dernier avion de combat monoréacteur de l''aéronautique navale française.'),
       replace(replace(description_en,
    'French engagements: Kosovo, Afghanistan, Libya, Mali, Iraq (Operation Chammal 2015).',
    'Iraq leased five from 1983 to 1985 to strike tankers during the Iran-Iraq War. French engagements: Lebanon (1983), Kosovo (1999), Afghanistan (2001-2011), Libya (2011), Iraq (Operation Chammal, 2015).'),
    'The last single-engined French fighter in service.',
    'The last single-engined combat aircraft of French naval aviation.'));
UPDATE airplanes SET description = replace(description,
    'Aucun autre appareil de guet aérien avancé n''a jamais été conçu pour opérer depuis un porte-avions. Le Hawkeye est resté sans concurrent pendant soixante ans, et le E-2D',
    'Successeur de l''E-1 Tracer, le Hawkeye est resté, pendant plus de quarante ans après le retrait du Gannet AEW.3 britannique en 1978, le seul avion de guet aérien embarqué à voilure fixe en service, et le E-2D'),
  description_en = replace(description_en,
    'No other airborne early warning aircraft has ever been designed to operate from a carrier. The Hawkeye stood without a competitor for sixty years, and the E-2D',
    'Successor to the E-1 Tracer, the Hawkeye remained, for more than forty years after the British Gannet AEW.3 was retired in 1978, the only fixed-wing carrier-borne airborne early warning aircraft in service, and the E-2D')
 WHERE name = 'E-2 Hawkeye'
   AND (description, description_en)
      IS DISTINCT FROM
      (replace(description,
    'Aucun autre appareil de guet aérien avancé n''a jamais été conçu pour opérer depuis un porte-avions. Le Hawkeye est resté sans concurrent pendant soixante ans, et le E-2D',
    'Successeur de l''E-1 Tracer, le Hawkeye est resté, pendant plus de quarante ans après le retrait du Gannet AEW.3 britannique en 1978, le seul avion de guet aérien embarqué à voilure fixe en service, et le E-2D'),
       replace(description_en,
    'No other airborne early warning aircraft has ever been designed to operate from a carrier. The Hawkeye stood without a competitor for sixty years, and the E-2D',
    'Successor to the E-1 Tracer, the Hawkeye remained, for more than forty years after the British Gannet AEW.3 was retired in 1978, the only fixed-wing carrier-borne airborne early warning aircraft in service, and the E-2D'));
UPDATE airplanes SET variants = replace(variants,
    'six prototypes, premier vol stationnaire en octobre 1960',
    'six prototypes, premier vol stationnaire captif le 21 octobre 1960, libre le 19 novembre 1960'),
  variants_en = replace(variants_en,
    'six prototypes, first hover in October 1960',
    'six prototypes, first tethered hover on 21 October 1960, first free hover on 19 November 1960')
 WHERE name = 'Hawker P.1127 Kestrel'
   AND (variants, variants_en)
      IS DISTINCT FROM
      (replace(variants,
    'six prototypes, premier vol stationnaire en octobre 1960',
    'six prototypes, premier vol stationnaire captif le 21 octobre 1960, libre le 19 novembre 1960'),
       replace(variants_en,
    'six prototypes, first hover in October 1960',
    'six prototypes, first tethered hover on 21 October 1960, first free hover on 19 November 1960'));

-- Photo du MiG-29 (LEGAL-002) : l'ancienne portait « © 2007 Katsuhiko
-- TOKUNAGA/DACT, All Rights Reserved ». Même nom de fichier, nouvelle photo libre.
UPDATE airplanes SET image_credit = 'Tim Felce (Airwolfhound)', image_licence = 'CC BY-SA 2.0'
 WHERE name = 'MiG-29' AND image_credit IS DISTINCT FROM 'Tim Felce (Airwolfhound)';
-- Tornado : photo du ministère britannique de la Défense (« Crown Copyright »),
-- sous Open Government Licence v1.0, qui impose d'en citer la source.
UPDATE airplanes SET image_credit = 'Cpl Mike Jones, Ministry of Defence', image_licence = 'OGL v1.0'
 WHERE name = 'Panavia Tornado' AND image_credit IS DISTINCT FROM 'Cpl Mike Jones, Ministry of Defence';
-- F-35I Adir : l'ancienne image, de provenance non documentée, est remplacée par
-- la version sans cadre de la même prise de vue, publiée par l'armée de l'air
-- israélienne sur Commons (CC BY 4.0). Même nom de fichier.
UPDATE airplanes SET image_credit = 'Major Ofer, Israeli Air Force', image_licence = 'CC BY 4.0'
 WHERE name = 'F-35I Adir'
   AND (image_credit, image_licence) IS DISTINCT FROM ('Major Ofer, Israeli Air Force', 'CC BY 4.0');
-- F-5EM Tiger II : l'ancienne portait « (C)2011 Johnson Barros/FAB » incrusté.
-- Nouvelle photo libre du ministère brésilien de la Défense, même nom de fichier.
UPDATE airplanes SET image_credit = 'Ministério da Defesa (Brasil)', image_licence = 'CC BY 2.0'
 WHERE name = 'F-5EM Tiger II'
   AND (image_credit, image_licence) IS DISTINCT FROM ('Ministério da Defesa (Brasil)', 'CC BY 2.0');
-- Tu-160 : photo conservée. C'est un cliché de Vadim Savitsky publié par le
-- ministère russe de la Défense (mil.ru) sous CC BY 4.0 : il ne manquait que le crédit.
UPDATE airplanes SET image_credit = 'Vadim Savitsky, Ministry of Defence of the Russian Federation', image_licence = 'CC BY 4.0'
 WHERE name = 'Tu-160'
   AND (image_credit, image_licence) IS DISTINCT FROM ('Vadim Savitsky, Ministry of Defence of the Russian Federation', 'CC BY 4.0');

-- ═══ 7. Contraintes de cohérence ═════════════════════════════════════════
--
-- Jusqu'ici la seule contrainte de la table portait sur `stealth_level` :
-- rien n'empêchait un MTOW inférieur à la masse à vide, un premier vol
-- antérieur à la conception, ou un facteur de charge négatif positif.
-- Le bloc de contrôle interrompt la transaction sans rien modifier si la
-- base contient des valeurs hors plage.

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM airplanes WHERE
       (mtow IS NOT NULL AND empty_weight IS NOT NULL AND mtow < empty_weight)
    OR (empty_weight IS NOT NULL AND empty_weight <= 0) OR (mtow IS NOT NULL AND mtow <= 0)
    OR (date_first_fly   IS NOT NULL AND date_concept   IS NOT NULL AND date_first_fly   < date_concept)
    OR (date_operationel IS NOT NULL AND date_first_fly IS NOT NULL AND date_operationel < date_first_fly)
    OR (production_end IS NOT NULL AND production_start IS NOT NULL AND production_end < production_start)
    OR (length IS NOT NULL AND length <= 0) OR (wingspan  IS NOT NULL AND wingspan  <= 0)
    OR (height IS NOT NULL AND height <= 0) OR (wing_area IS NOT NULL AND wing_area <= 0)
    OR (max_speed       IS NOT NULL AND max_speed       <= 0)
    OR (max_range       IS NOT NULL AND max_range       <= 0)
    OR (service_ceiling IS NOT NULL AND service_ceiling <= 0)
    OR (climb_rate      IS NOT NULL AND climb_rate      <= 0)
    OR (combat_radius   IS NOT NULL AND combat_radius   <= 0)
    OR (combat_radius IS NOT NULL AND max_range IS NOT NULL AND combat_radius > max_range)
    OR (g_limit_pos IS NOT NULL AND g_limit_pos <= 0) OR (g_limit_neg IS NOT NULL AND g_limit_neg >= 0)
    OR (crew IS NOT NULL AND crew NOT BETWEEN 1 AND 35)
    OR (engine_count IS NOT NULL AND engine_count NOT BETWEEN 1 AND 10)
    OR (thrust_dry IS NOT NULL AND thrust_dry <= 0) OR (thrust_wet IS NOT NULL AND thrust_wet <= 0)
    OR (thrust_wet IS NOT NULL AND thrust_dry IS NOT NULL AND thrust_wet < thrust_dry)
    OR (units_built IS NOT NULL AND units_built < 0)
    OR (unit_cost_year IS NOT NULL AND unit_cost_year NOT BETWEEN 1940 AND 2100)
    OR id IN (predecessor_id, successor_id, rival_id);
  IF n > 0 THEN
    RAISE EXCEPTION '% ligne(s) violent les contraintes — corriger avant de poser les CHECK', n;
  END IF;
END $$;

-- Rejouable : on retire d'abord une éventuelle version antérieure.
ALTER TABLE airplanes
  DROP CONSTRAINT IF EXISTS chk_airplanes_masses,
  DROP CONSTRAINT IF EXISTS chk_airplanes_masses_pos,
  DROP CONSTRAINT IF EXISTS chk_airplanes_chrono,
  DROP CONSTRAINT IF EXISTS chk_airplanes_production,
  DROP CONSTRAINT IF EXISTS chk_airplanes_dimensions,
  DROP CONSTRAINT IF EXISTS chk_airplanes_perfs,
  DROP CONSTRAINT IF EXISTS chk_airplanes_rayon,
  DROP CONSTRAINT IF EXISTS chk_airplanes_facteur_g,
  DROP CONSTRAINT IF EXISTS chk_airplanes_equipage,
  DROP CONSTRAINT IF EXISTS chk_airplanes_moteurs,
  DROP CONSTRAINT IF EXISTS chk_airplanes_poussee,
  DROP CONSTRAINT IF EXISTS chk_airplanes_qte_prod,
  DROP CONSTRAINT IF EXISTS chk_airplanes_annee_cout,
  DROP CONSTRAINT IF EXISTS chk_airplanes_auto_ref;

ALTER TABLE airplanes
  ADD CONSTRAINT chk_airplanes_masses      CHECK (mtow IS NULL OR empty_weight IS NULL OR mtow >= empty_weight),
  ADD CONSTRAINT chk_airplanes_masses_pos  CHECK ((empty_weight IS NULL OR empty_weight > 0) AND (mtow IS NULL OR mtow > 0)),
  ADD CONSTRAINT chk_airplanes_chrono      CHECK (
        (date_first_fly   IS NULL OR date_concept   IS NULL OR date_first_fly   >= date_concept)
    AND (date_operationel IS NULL OR date_first_fly IS NULL OR date_operationel >= date_first_fly)),
  ADD CONSTRAINT chk_airplanes_production  CHECK (production_end IS NULL OR production_start IS NULL OR production_end >= production_start),
  ADD CONSTRAINT chk_airplanes_dimensions  CHECK (
        (length IS NULL OR length > 0) AND (wingspan  IS NULL OR wingspan  > 0)
    AND (height IS NULL OR height > 0) AND (wing_area IS NULL OR wing_area > 0)),
  ADD CONSTRAINT chk_airplanes_perfs       CHECK (
        (max_speed       IS NULL OR max_speed       > 0) AND (max_range  IS NULL OR max_range  > 0)
    AND (service_ceiling IS NULL OR service_ceiling > 0) AND (climb_rate IS NULL OR climb_rate > 0)
    AND (combat_radius   IS NULL OR combat_radius   > 0)),
  ADD CONSTRAINT chk_airplanes_rayon       CHECK (combat_radius IS NULL OR max_range IS NULL OR combat_radius <= max_range),
  ADD CONSTRAINT chk_airplanes_facteur_g   CHECK ((g_limit_pos IS NULL OR g_limit_pos > 0) AND (g_limit_neg IS NULL OR g_limit_neg < 0)),
  ADD CONSTRAINT chk_airplanes_equipage    CHECK (crew IS NULL OR crew BETWEEN 1 AND 35),
  ADD CONSTRAINT chk_airplanes_moteurs     CHECK (engine_count IS NULL OR engine_count BETWEEN 1 AND 10),
  ADD CONSTRAINT chk_airplanes_poussee     CHECK (
        (thrust_dry IS NULL OR thrust_dry > 0) AND (thrust_wet IS NULL OR thrust_wet > 0)
    AND (thrust_wet IS NULL OR thrust_dry IS NULL OR thrust_wet >= thrust_dry)),
  ADD CONSTRAINT chk_airplanes_qte_prod    CHECK (units_built IS NULL OR units_built >= 0),
  ADD CONSTRAINT chk_airplanes_annee_cout  CHECK (unit_cost_year IS NULL OR unit_cost_year BETWEEN 1940 AND 2100),
  ADD CONSTRAINT chk_airplanes_auto_ref    CHECK (
        (predecessor_id IS NULL OR predecessor_id <> id)
    AND (successor_id   IS NULL OR successor_id   <> id)
    AND (rival_id       IS NULL OR rival_id       <> id));

COMMIT;
