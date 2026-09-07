-- zz_backfill_relations.sql
--
-- Relations entre appareils : prédécesseur / successeur / rival, et rattachement
-- aux conflits ajoutés dans db.sql.
--
-- Pourquoi un fichier séparé, et pourquoi ce nom : les fiches de db_backup/ sont
-- chargées dans l'ordre alphabétique. Une référence croisée posée depuis la fiche
-- d'un appareil ne peut donc résoudre que les appareils déjà insérés — un
-- successeur, par définition plus récent, est le plus souvent chargé APRÈS.
-- Le préfixe « zz » garantit que ce fichier passe en dernier, une fois les 383
-- fiches présentes. Il est de ce fait la source unique de vérité pour ces trois
-- colonnes : ne pas les réintroduire dans les fiches individuelles.
--
-- Rejouable sans effet de bord : les UPDATE sont idempotents et les INSERT
-- ignorent les doublons.
--
-- Conventions :
--   predecessor / successor = appareil directement remplacé / remplaçant DANS LE
--     SERVICE DE L'OPÉRATEUR, restreint au catalogue. NULL = pas d'équivalent en
--     base (et non « inconnu »).
--   rival = design contemporain opposé ou concurrent direct.
--   L'asymétrie est normale : le Rafale remplace sept types, mais un seul peut
--   figurer dans son predecessor_id.

BEGIN;

-- ── Filiations et rivalités ────────────────────────────────────────────────

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
  rival_id       = NULL
WHERE name = 'A-1 Skyraider';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-25')
WHERE name = 'A-10 Thunderbolt II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-16')
WHERE name = 'A-3 Skywarrior';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'A-4 Skyhawk';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'A-5 Vigilante';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'A-6 Intruder';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-17')
WHERE name = 'A-7 Corsair II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'AIDC AT-3 Tzu Chung';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10')
WHERE name = 'AIDC F-CK-1 Ching-kuo';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle')
WHERE name = 'AIDC T-5 Brave Eagle';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = NULL
WHERE name = 'AMX A-1 Brésilien';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Fiat G.91'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'),
  rival_id       = NULL
WHERE name = 'AMX International AMX';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'AV-8B Harrier II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-12')
WHERE name = 'Aeritalia G.222';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'Aermacchi MB-326';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'M-346 Master'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'Aermacchi MB-339';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Aero L-159 ALCA';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra')
WHERE name = 'Aero L-29 Delfín';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'Aero L-39 Albatros';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Vickers VC10'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus')
WHERE name = 'Airbus A330 MRTT';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Transall C-160'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Airbus A400M Atlas';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Alenia C-27J Spartan';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Fiat G.91'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'Alpha Jet Allemand';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Antonov An-12';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III')
WHERE name = 'Antonov An-124 Ruslan';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-5 Galaxy')
WHERE name = 'Antonov An-22 Antei';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Antonov An-32'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas')
WHERE name = 'Antonov An-26';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-26'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235')
WHERE name = 'Antonov An-32';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'Antonov An-72';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'IAI Kfir')
WHERE name = 'Atlas Cheetah';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326')
WHERE name = 'Atlas Impala';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Gloster Javelin')
WHERE name = 'Avro Canada CF-100 Canuck';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart')
WHERE name = 'Avro Canada CF-105 Arrow';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'),
  rival_id       = NULL
WHERE name = 'Avro Shackleton';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Mirage IV')
WHERE name = 'Avro Vulcan';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-160')
WHERE name = 'B-1 Lancer';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-21 Raider'),
  rival_id       = NULL
WHERE name = 'B-2 Spirit';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-2 Spirit'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'B-21 Raider';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'),
  rival_id       = NULL
WHERE name = 'B-29 Superfortress';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4')
WHERE name = 'B-36 Peacemaker';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-16')
WHERE name = 'B-47 Stratojet';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-1 Lancer'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-95')
WHERE name = 'B-52 Stratofortress';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
  rival_id       = NULL
WHERE name = 'B-58 Hustler';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = NULL
WHERE name = 'BAC TSR-2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'BAE Hawk';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'BAE Sea Harrier';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'Bayraktar TB2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'X-3 Stiletto'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket')
WHERE name = 'Bell X-1';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Short SC.1')
WHERE name = 'Bell X-14';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'E-3 Sentry')
WHERE name = 'Beriev A-50';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'P-2 Neptune')
WHERE name = 'Beriev Be-12 Chaïka';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2')
WHERE name = 'Beriev Be-200';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = NULL
WHERE name = 'Blackburn Buccaneer';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II')
WHERE name = 'Boeing X-32';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fairey Gannet')
WHERE name = 'Breguet Alizé';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38')
WHERE name = 'Breguet Atlantique';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'GAF Nomad')
WHERE name = 'Britten-Norman Defender';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas')
WHERE name = 'C-119 Flying Boxcar';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-12')
WHERE name = 'C-130 Hercules';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76')
WHERE name = 'C-141 Starlifter';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan')
WHERE name = 'C-17 Globemaster III';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'C-2 Greyhound';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan')
WHERE name = 'C-5 Galaxy';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'CAC CA-27 Sabre';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'CASA C-101 Aviojet';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant')
WHERE name = 'CASA C-212 Aviocar';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'CASA/IPTN CN-235';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet')
WHERE name = 'Canadair CT-114 Tutor';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1')
WHERE name = 'Chengdu FC-1/JF-17';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2')
WHERE name = 'Chengdu J-10';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor')
WHERE name = 'Chengdu J-20';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21 Bison')
WHERE name = 'Chengdu J-7';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'X-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-3 Stiletto')
WHERE name = 'D-558-2 Skyrocket';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-12')
WHERE name = 'DHC-5 Buffalo';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'),
  rival_id       = NULL
WHERE name = 'Dassault MD 315 Flamant';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar')
WHERE name = 'Dornier Do 28 Skyservant';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Dornier Do 31';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev A-50')
WHERE name = 'E-3 Sentry';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'EA-18G Growler';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-6 Intruder'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = NULL
WHERE name = 'EA-6B Prowler';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'E-3 Sentry'),
  rival_id       = NULL
WHERE name = 'EC-121 Warning Star';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Valmet L-70 Vinka')
WHERE name = 'ENAER T-35 Pillán';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Mirage III V')
WHERE name = 'EWR VJ 101';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'IAI Heron'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-1 Predator')
WHERE name = 'Elbit Hermes 900';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye')
WHERE name = 'Embraer E-99';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'GAF Nomad')
WHERE name = 'Embraer EMB-110 Bandeirante';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'Embraer EMB-312 Tucano';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Embraer EMB-314 Super Tucano';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'Embraer EMB-326 Xavante';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Embraer KC-390 Millennium';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Il-28')
WHERE name = 'English Electric Canberra';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Gloster Javelin'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-15')
WHERE name = 'English Electric Lightning';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'Eurofighter Typhoon Allemand';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'Eurofighter Typhoon Anglais';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'Eurofighter Typhoon Italien';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F-100 Super Sabre';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F-101 Voodoo';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F-102 Delta Dagger';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-104 Starfighter';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand')
WHERE name = 'F-104 Starfighter Allemand';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-104S Starfighter Italien';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-105 Thunderchief';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-15')
WHERE name = 'F-106 Delta Dart';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'F-111 Aardvark';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
  rival_id       = NULL
WHERE name = 'F-117 Nighthawk';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-31')
WHERE name = 'F-14 Tomcat';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-25')
WHERE name = 'F-15 Eagle';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-34')
WHERE name = 'F-15E Strike Eagle';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-35')
WHERE name = 'F-15EX Eagle II';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-15I Ra''am';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-29')
WHERE name = 'F-16 Fighting Falcon';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-16I Sufa';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'F-16XL';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'F-20 Tigershark';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-57')
WHERE name = 'F-22 Raptor';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-20')
WHERE name = 'F-35 Lightning II';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AMX International AMX'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-57')
WHERE name = 'F-35 Lightning II Italien';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-35B Lightning II Anglais';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-16I Sufa'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-35I Adir';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-4 Phantom II';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand')
WHERE name = 'F-4 Phantom II Allemand';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-4E Kurnass';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-4EJ Kai';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-5 Freedom Fighter';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = NULL
WHERE name = 'F-5EM Tiger II';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F7U Cutlass'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'F-8 Crusader';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F-80 Shooting Star';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-94 Starfire'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-23')
WHERE name = 'F-82 Twin Mustang';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F-84F Thunderstreak';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'F-86 Sabre';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-94 Starfire'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-25')
WHERE name = 'F-89 Scorpion';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-8 Crusader'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-8E (FN) Crusader';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-25')
WHERE name = 'F-94 Starfire';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-29')
WHERE name = 'F/A-18 Hornet';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-35')
WHERE name = 'F/A-18E Super Hornet';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F9F Cougar'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-8 Crusader')
WHERE name = 'F11F Tiger';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F3D Skyknight';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F4D Skyray';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-8 Crusader'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'F7U Cutlass';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F9F Panther'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F11F Tiger'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F9F Cougar';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F9F Cougar'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F9F Panther';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fiat G.91')
WHERE name = 'FFA P-16';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'OV-10 Bronco')
WHERE name = 'FMA IA 58 Pucará';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'FMA IA 63 Pampa';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre')
WHERE name = 'Fairey Delta 2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Fairey Gannet'),
  rival_id       = NULL
WHERE name = 'Fairey Firefly';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Fairey Firefly'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Fairey Gannet';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AMX International AMX'),
  rival_id       = NULL
WHERE name = 'Fiat G.91';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar')
WHERE name = 'Fokker F27 Maritime';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jet Provost')
WHERE name = 'Fokker S.14 Machtrainer';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Ajeet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'Folland Gnat';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326')
WHERE name = 'Fouga CM.170 Magister';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'Fuji T-7';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Ryan Firebee')
WHERE name = 'GAF Jindivik';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235')
WHERE name = 'GAF Nomad';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'English Electric Lightning'),
  rival_id       = NULL
WHERE name = 'Gloster Javelin';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Gloster Meteor';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hongdu L-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros')
WHERE name = 'Guizhou JL-9';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-20')
WHERE name = 'HAL AMCA';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Folland Gnat'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'HAL Ajeet';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Jaguar IS'),
  rival_id       = NULL
WHERE name = 'HAL HF-24 Marut';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL Ajeet'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi')
WHERE name = 'HAL HJT-36 Sitara';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'HAL Tejas Mk1';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'HAL Tejas Mk1A';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10')
WHERE name = 'HAL Tejas Mk2';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'HESA Saeqeh';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'EA-6B Prowler')
WHERE name = 'HFB 320 Hansa Jet';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-16')
WHERE name = 'Handley Page Victor';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Gloster Meteor'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'Hawker Hunter';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Hawker P.1127 Kestrel';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Hawker Sea Hawk';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Hawker Siddeley Harrier';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Avro Shackleton'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-142')
WHERE name = 'Hawker Siddeley Nimrod';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Helwan HA-300';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'Hispano HA-200 Saeta';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'Hongdu JL-8';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros')
WHERE name = 'Hongdu K-8 Karakorum';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-130')
WHERE name = 'Hongdu L-15';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar')
WHERE name = 'IAI Arava';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2')
WHERE name = 'IAI Harop';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'IAI Heron';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'IAI Nesher'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'IAI Lavi'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'IAI Kfir';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'IAI Kfir'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'IAI Lavi';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 5'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'IAI Kfir'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'IAI Nesher';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb')
WHERE name = 'IAR-99 Șoim';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-28'),
  rival_id       = NULL
WHERE name = 'Il-28';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet')
WHERE name = 'Iliouchine Il-114';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev A-50')
WHERE name = 'Iliouchine Il-20';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Breguet Atlantique')
WHERE name = 'Iliouchine Il-38';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III')
WHERE name = 'Iliouchine Il-76';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker')
WHERE name = 'Iliouchine Il-78 Midas';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-17')
WHERE name = 'Jaguar';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Jaguar IS';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'BAE Hawk'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet')
WHERE name = 'Jet Provost';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'JF-17 Thunder')
WHERE name = 'KAI FA-50';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen')
WHERE name = 'KAI KF-21 Boramae';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'KAI KT-1 Woongbi';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'M-346 Master')
WHERE name = 'KAI T-50 Golden Eagle';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Vickers VC10')
WHERE name = 'KC-10 Extender';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KC-10 Extender'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76')
WHERE name = 'KC-135 Stratotanker';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KC-10 Extender'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT')
WHERE name = 'KC-46 Pegasus';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'),
  rival_id       = NULL
WHERE name = 'KC-97 Stratofreighter';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'),
  rival_id       = NULL
WHERE name = 'Kawasaki C-1';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium')
WHERE name = 'Kawasaki C-2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'P-8 Poseidon')
WHERE name = 'Kawasaki P-1';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'Kawasaki T-4';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Dornier Do 31')
WHERE name = 'LTV XC-142';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'La-15';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-2'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck')
WHERE name = 'Let L-410 Turbolet';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-25')
WHERE name = 'Lockheed A-12';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Ryan Firebee'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-143 Reys')
WHERE name = 'Lockheed D-21';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XFY Pogo')
WHERE name = 'Lockheed XFV';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'M-346 Master';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'IAI Heron')
WHERE name = 'MQ-1 Predator';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'X-47B'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'MQ-25 Stingray';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-57'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'YF-22')
WHERE name = 'MiG 1.44';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-9'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-17'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'MiG-15';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-15'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-19'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'MiG-17';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-17'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-21'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II')
WHERE name = 'MiG-19';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-19'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-23'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II')
WHERE name = 'MiG-21';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand')
WHERE name = 'MiG-21 Allemand';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7')
WHERE name = 'MiG-21 Bison';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-21'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-29'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II')
WHERE name = 'MiG-23';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand')
WHERE name = 'MiG-23 Allemand';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-31'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird')
WHERE name = 'MiG-25';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-23'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jaguar')
WHERE name = 'MiG-27';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-23'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-35'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'MiG-29';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'MiG-29 Allemand';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-25'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat')
WHERE name = 'MiG-31';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-29'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'MiG-35';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-15'),
  rival_id       = NULL
WHERE name = 'MiG-9';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'Mirage 2000';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'Mirage 2000H Vajra';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15 Eagle')
WHERE name = 'Mirage 4000';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mirage 5';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'Mirage F1';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'Mirage G8';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Super Mystère B2'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mirage III';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'EWR VJ 101')
WHERE name = 'Mirage III V';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'IAI Nesher'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mirage IIICJ Shahak';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Avro Vulcan')
WHERE name = 'Mirage IV';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'),
  rival_id       = NULL
WHERE name = 'Mitsubishi F-1';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mitsubishi F-104J';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Mitsubishi F-15J';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Mitsubishi F-2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'),
  rival_id       = NULL
WHERE name = 'Mitsubishi T-2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-20')
WHERE name = 'Mitsubishi X-2 Shinshin';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet')
WHERE name = 'Myasishchev M-4';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-58 Hustler')
WHERE name = 'Myasishchev M-50';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady')
WHERE name = 'Myasishchev M-55';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Ouragan'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Super Mystère B2'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'Mystère IV';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra')
WHERE name = 'Nanchang CJ-6';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Nanchang Q-5';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Transall C-160'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar')
WHERE name = 'Nord Noratlas';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'OV-10 Bronco')
WHERE name = 'OV-1 Mohawk';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk')
WHERE name = 'OV-10 Bronco';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mystère IV'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Ouragan';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'P-3 Orion'),
  rival_id       = NULL
WHERE name = 'P-2 Neptune';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'P-2 Neptune'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-142')
WHERE name = 'P-3 Orion';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'P-3 Orion'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Kawasaki P-1')
WHERE name = 'P-8 Poseidon';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'PAC Super Mushshak';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet')
WHERE name = 'PZL M28 Skytruck';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín')
WHERE name = 'PZL TS-11 Iskra';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'PZL-130 Orlik';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'Panavia Tornado';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'Panavia Tornado Allemand';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'Panavia Tornado Italien';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL-130 Orlik')
WHERE name = 'Pilatus PC-7';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano')
WHERE name = 'Pilatus PC-9';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev A-50')
WHERE name = 'RQ-4 Global Hawk';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand')
WHERE name = 'Rafale';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand')
WHERE name = 'Rafale EH';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Rockwell XFV-12';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Lockheed D-21'),
  rival_id       = NULL
WHERE name = 'Ryan Firebee';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'SF.260';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Scottish Aviation Bulldog')
WHERE name = 'SOCATA TB-30 Epsilon';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-25')
WHERE name = 'SR-71 Blackbird';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'Saab 105';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Saab 29 Tunnan';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'),
  rival_id       = NULL
WHERE name = 'Saab 32 Lansen';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Saab 35 Draken';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'Saab 37 Viggen';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye')
WHERE name = 'Saab GlobalEye';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'Saab JAS 39 Gripen';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Saunders-Roe SR.53';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon')
WHERE name = 'Scottish Aviation Bulldog';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'de Havilland Venom'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
  rival_id       = NULL
WHERE name = 'Sea Vixen';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Xian Y-20 Kunpeng'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Shaanxi Y-8';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-8'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shenyang J-16'),
  rival_id       = NULL
WHERE name = 'Shenyang J-11';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-33'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Shenyang J-15';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-11'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Shenyang J-16';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II')
WHERE name = 'Shenyang J-35';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-17'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
  rival_id       = NULL
WHERE name = 'Shenyang J-5';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-5'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  rival_id       = NULL
WHERE name = 'Shenyang J-6';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shenyang J-11'),
  rival_id       = NULL
WHERE name = 'Shenyang J-8';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka')
WHERE name = 'ShinMaywa US-1A';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka')
WHERE name = 'ShinMaywa US-2';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Bell X-14')
WHERE name = 'Short SC.1';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Jet Provost'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-6 Texan II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'Shorts Tucano';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra')
WHERE name = 'Soko G-2 Galeb';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros')
WHERE name = 'Soko G-4 Super Galeb';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'AMX International AMX')
WHERE name = 'Soko J-22 Orao';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-9'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger')
WHERE name = 'Su-11';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-11'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-31'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'English Electric Lightning')
WHERE name = 'Su-15';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-7'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-25'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jaguar')
WHERE name = 'Su-17';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-34'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark')
WHERE name = 'Su-24';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II')
WHERE name = 'Su-25';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-30'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-27';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-27'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-35'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-30';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-30'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'Su-30MKI';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-27'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat')
WHERE name = 'Su-33';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-24'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-34';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-27'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-57'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-35';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-35'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor')
WHERE name = 'Su-57';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-17'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre')
WHERE name = 'Su-7';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-11'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger')
WHERE name = 'Su-9';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie')
WHERE name = 'Sukhoi T-4';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mystère IV'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'Super Mystère B2';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Étendard IV'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = NULL
WHERE name = 'Super Étendard';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Supermarine Attacker';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'),
  rival_id       = NULL
WHERE name = 'Supermarine Scimitar';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter')
WHERE name = 'Supermarine Swift';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-34 Mentor'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'T-28 Trojan';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-38 Talon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'T-33 Shooting Star';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-28 Trojan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SF.260')
WHERE name = 'T-34 Mentor';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-28 Trojan'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jet Provost')
WHERE name = 'T-37 Tweet';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'T-38 Talon';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'T-6 Texan II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'TAI Kaan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'TAI Hürkuş';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae')
WHERE name = 'TAI Kaan';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Transall C-160';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-31'),
  rival_id       = NULL
WHERE name = 'Tu-128';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Lockheed D-21')
WHERE name = 'Tu-141 Strizh';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-95'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'P-3 Orion')
WHERE name = 'Tu-142';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Ryan Firebee')
WHERE name = 'Tu-143 Reys';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-22M'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress')
WHERE name = 'Tu-16';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-95'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-1 Lancer')
WHERE name = 'Tu-160';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-22M'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-58 Hustler')
WHERE name = 'Tu-22';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-22'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-160'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark')
WHERE name = 'Tu-22M';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-160'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress')
WHERE name = 'Tu-95';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-16'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet')
WHERE name = 'Tupolev Tu-4';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'),
  rival_id       = NULL
WHERE name = 'U-2 Dragon Lady';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'EWR VJ 101'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel')
WHERE name = 'VFW VAK 191B';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'ENAER T-35 Pillán')
WHERE name = 'Valmet L-70 Vinka';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage IV'),
  rival_id       = NULL
WHERE name = 'Vautour II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker')
WHERE name = 'Vickers VC10';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Myasishchev M-4')
WHERE name = 'Vickers Valiant';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'Wing Loong II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XFY Pogo')
WHERE name = 'X-13 Vertijet';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'X-15';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-31')
WHERE name = 'X-29';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket')
WHERE name = 'X-3 Stiletto';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-29')
WHERE name = 'X-31';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'nEUROn')
WHERE name = 'X-47B';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-58 Hustler'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Sukhoi T-4')
WHERE name = 'XB-70 Valkyrie';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Lockheed XFV')
WHERE name = 'XFY Pogo';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'nEUROn')
WHERE name = 'XQ-58 Valkyrie';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-16'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Xian H-6';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III')
WHERE name = 'Xian Y-20 Kunpeng';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'YF-17 Cobra';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II')
WHERE name = 'YF-22';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor')
WHERE name = 'YF-23 Black Widow II';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'M-346 Master')
WHERE name = 'Yak-130';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-38'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier')
WHERE name = 'Yak-141';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-25'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'La-15')
WHERE name = 'Yak-23';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-23'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-28'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Gloster Javelin')
WHERE name = 'Yak-25';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-25'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-24'),
  rival_id       = NULL
WHERE name = 'Yak-28';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-38'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel')
WHERE name = 'Yak-36';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-141'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier')
WHERE name = 'Yak-38';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'de Havilland Venom'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'de Havilland Vampire';

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Sea Vixen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'de Havilland Venom';

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Super Étendard'),
  rival_id       = NULL
WHERE name = 'Étendard IV';

-- ── Rattachement aux conflits ──────────────────────────────────────────────

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Intervention en Libye' AND a.name IN (
  'Rafale',
  'Mirage 2000',
  'Super Étendard',
  'Panavia Tornado',
  'Panavia Tornado Italien',
  'Eurofighter Typhoon Anglais',
  'Eurofighter Typhoon Italien',
  'F-16 Fighting Falcon',
  'B-2 Spirit'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Conflit indo-pakistanais de 2019' AND a.name IN (
  'Chengdu FC-1/JF-17',
  'MiG-21 Bison',
  'Su-30MKI',
  'Mirage 2000H Vajra',
  'F-16 Fighting Falcon'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Invasion russe de l''Ukraine' AND a.name IN (
  'Su-24',
  'Su-25',
  'Su-27',
  'Su-30',
  'Su-34',
  'Su-35',
  'Su-57',
  'MiG-29',
  'MiG-31',
  'Tu-22M',
  'Tu-95',
  'Tu-160'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre civile syrienne' AND a.name IN (
  'F-35B Lightning II Anglais'
)
ON CONFLICT DO NOTHING;

-- ── Frise chronologique : rattachement des événements à leur appareil ──────
--
-- `airplane_id` alimente une vignette illustrée sur la page Chronologie.
-- Ces événements citent nommément un appareil désormais présent au catalogue ;
-- ils étaient restés orphelins faute de fiche correspondante.

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE title_fr = 'Premier duel à réaction — F-86 contre MiG-15' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady')
WHERE title_fr = 'U-2 de Gary Powers abattu au-dessus de Sverdlovsk' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado')
WHERE title_fr = 'Panavia Tornado — l''Europe fait bloc' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'F-117 Nighthawk')
WHERE title_fr = 'Allied Force — 78 jours au-dessus de la Serbie' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE title_fr = 'Bagdad — un MQ-9 tue le général Soleimani' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2')
WHERE title_fr = 'Haut-Karabagh — les Bayraktar réécrivent la guerre' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE title_fr = 'Corée — la guerre redevient ciel' AND airplane_id IS NULL;

UPDATE timeline_events SET airplane_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady')
WHERE title_fr = 'Crise des missiles de Cuba — treize jours à l''altimètre' AND airplane_id IS NULL;

-- ── Traductions manquantes du référentiel ─────────────────────────────────
--
-- Posé ici et non dans db.sql : quatre constructeurs sont déclarés par les
-- fiches elles-mêmes, donc après db.sql. Pour eux le nom est un nom propre,
-- identique dans les deux langues ; les deux autres cas demandent une vraie
-- traduction et sont donc explicites.

UPDATE manufacturer SET name_en = name WHERE name_en IS NULL;

UPDATE missions
   SET name_en = 'Air Superiority',
       description_en = 'Control of airspace by eliminating enemy threats.'
 WHERE name = 'Supériorité aérienne' AND name_en IS NULL;

UPDATE generation
   SET description_en = 'First generation: subsonic jet aircraft of the 1940s and 1950s'
 WHERE generation = 1 AND description_en IS NULL;

COMMIT;
