-- zz_backfill_relations.sql
--
-- Relations entre appareils : prédécesseur / successeur / rival, et rattachement
-- aux conflits ajoutés dans db.sql.
--
-- Pourquoi un fichier séparé, et pourquoi ce nom : les fiches de db_backup/ sont
-- chargées dans l'ordre alphabétique. Une référence croisée posée depuis la fiche
-- d'un appareil ne peut donc résoudre que les appareils déjà insérés — un
-- successeur, par définition plus récent, est le plus souvent chargé APRÈS.
-- Le préfixe « zz » garantit que ce fichier passe en dernier, une fois les 434
-- fiches présentes. Il est de ce fait la source unique de vérité pour ces trois
-- colonnes : ne pas les réintroduire dans les fiches individuelles.
--
-- Rejouable sans effet de bord : les INSERT ignorent les doublons, et chaque
-- UPDATE porte une garde IS DISTINCT FROM sur les colonnes qu'il écrit. Sans
-- elle, le déclencheur de updated_at daterait du jour toutes les fiches à chaque
-- rejeu, et le lastmod du sitemap mentirait.
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
WHERE name = 'A-1 Skyraider'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-25')
WHERE name = 'A-10 Thunderbolt II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
       (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
       (SELECT id FROM airplanes WHERE name = 'Su-25'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'),
  rival_id       = NULL
WHERE name = 'A-26 Invader'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Martin B-57 Canberra'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-16')
WHERE name = 'A-3 Skywarrior'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'A-5 Vigilante'),
       (SELECT id FROM airplanes WHERE name = 'Tu-16'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'A-4 Skyhawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'A-7 Corsair II'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'A-5 Vigilante'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-3 Skywarrior'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'A-6 Intruder'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
       (SELECT id FROM airplanes WHERE name = 'Su-24'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-17')
WHERE name = 'A-7 Corsair II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-4 Skyhawk'),
       (SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'),
       (SELECT id FROM airplanes WHERE name = 'Su-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'AC-130 Spectre'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'AC-47 Spooky'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'),
  rival_id       = NULL
WHERE name = 'AC-47 Spooky'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'AC-130 Spectre'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Aero L-39NG Skyfox'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'AIDC AT-3 Tzu Chung'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'AIDC F-CK-1 Ching-kuo'),
       (SELECT id FROM airplanes WHERE name = 'BAE Hawk'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10')
WHERE name = 'AIDC F-CK-1 Ching-kuo'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle')
WHERE name = 'AIDC T-5 Brave Eagle'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'AIDC AT-3 Tzu Chung'),
       NULL,
       (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'Airbus C295'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = NULL
WHERE name = 'AMX A-1 Brésilien'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'),
       (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Fiat G.91'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'),
  rival_id       = NULL
WHERE name = 'AMX International AMX'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Fiat G.91'),
       (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II Italien'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver')
WHERE name = 'Antonov An-2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'DHC-2 Beaver'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Antonov An-225 Mriya'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'AV-8B Harrier II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
       (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
       (SELECT id FROM airplanes WHERE name = 'Yak-38'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-12')
WHERE name = 'Aeritalia G.222'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'),
       (SELECT id FROM airplanes WHERE name = 'Antonov An-12'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'Aermacchi MB-326'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'),
       (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'M-346 Master'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'Aermacchi MB-339'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'),
       (SELECT id FROM airplanes WHERE name = 'M-346 Master'),
       (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Aero L-159 ALCA'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra')
WHERE name = 'Aero L-29 Delfín'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'),
       (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Aero L-39NG Skyfox'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'Aero L-39 Albatros'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'),
       (SELECT id FROM airplanes WHERE name = 'Aero L-39NG Skyfox'),
       (SELECT id FROM airplanes WHERE name = 'BAE Hawk'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Vickers VC10'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus')
WHERE name = 'Airbus A330 MRTT'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Vickers VC10'), NULL,
       (SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Transall C-160'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Airbus A400M Atlas'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Transall C-160'), NULL,
       (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Alenia C-27J Spartan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Fiat G.91'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'Alpha Jet Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Fiat G.91'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Antonov An-12'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'),
       (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III')
WHERE name = 'Antonov An-124 Ruslan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Antonov An-22 Antei'),
       NULL,
       (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-5 Galaxy')
WHERE name = 'Antonov An-22 Antei'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'),
       (SELECT id FROM airplanes WHERE name = 'C-5 Galaxy'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Antonov An-32'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas')
WHERE name = 'Antonov An-26'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
       (SELECT id FROM airplanes WHERE name = 'Antonov An-32'),
       (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-26'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235')
WHERE name = 'Antonov An-32'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Antonov An-26'), NULL,
       (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'Antonov An-72'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'IAI Kfir')
WHERE name = 'Atlas Cheetah'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage III'),
       (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
       (SELECT id FROM airplanes WHERE name = 'IAI Kfir'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326')
WHERE name = 'Atlas Impala'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Atlas Cheetah'),
       (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Gloster Javelin')
WHERE name = 'Avro Canada CF-100 Canuck'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'),
       (SELECT id FROM airplanes WHERE name = 'Gloster Javelin'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart')
WHERE name = 'Avro Canada CF-105 Arrow'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'),
       NULL, (SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus')
WHERE name = 'Avro Shackleton'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Nimrod'),
       (SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Mirage IV')
WHERE name = 'Avro Vulcan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
       (SELECT id FROM airplanes WHERE name = 'Mirage IV'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-160')
WHERE name = 'B-1 Lancer'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Tu-160'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-21 Raider'),
  rival_id       = NULL
WHERE name = 'B-2 Spirit'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
       (SELECT id FROM airplanes WHERE name = 'B-21 Raider'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-2 Spirit'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'B-21 Raider'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'B-2 Spirit'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'),
  rival_id       = NULL
WHERE name = 'B-29 Superfortress'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4')
WHERE name = 'B-36 Peacemaker'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
       (SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-16')
WHERE name = 'B-47 Stratojet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'B-29 Superfortress'),
       (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'),
       (SELECT id FROM airplanes WHERE name = 'Tu-16'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'B-1 Lancer'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-95')
WHERE name = 'B-52 Stratofortress'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'),
       (SELECT id FROM airplanes WHERE name = 'B-1 Lancer'),
       (SELECT id FROM airplanes WHERE name = 'Tu-95'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
  rival_id       = NULL
WHERE name = 'B-58 Hustler'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-26 Invader'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-28')
WHERE name = 'B-66 Destroyer'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Yak-28'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = NULL
WHERE name = 'BAC TSR-2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'BAE Hawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'BAE Sea Harrier'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
       (SELECT id FROM airplanes WHERE name = 'F-35B Lightning II Anglais'),
       (SELECT id FROM airplanes WHERE name = 'Yak-38'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'Bayraktar Akıncı'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), NULL,
       (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat')
WHERE name = 'Bayraktar Kızılelma'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MQ-28 Ghost Bat'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'Bayraktar TB2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Bayraktar Akıncı'),
       (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Bayraktar TB3'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'X-3 Stiletto'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket')
WHERE name = 'Bell X-1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'X-3 Stiletto'),
       (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Short SC.1')
WHERE name = 'Bell X-14'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Short SC.1'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'V-22 Osprey'),
  rival_id       = NULL
WHERE name = 'Bell XV-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'V-22 Osprey'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'E-3 Sentry')
WHERE name = 'Beriev A-50'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'E-3 Sentry'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'P-2 Neptune')
WHERE name = 'Beriev Be-12 Chaïka'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'P-2 Neptune'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2')
WHERE name = 'Beriev Be-200'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'),
       NULL, (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = NULL
WHERE name = 'Blackburn Buccaneer'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'),
       (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'E-3 Sentry'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye')
WHERE name = 'Boeing E-7 Wedgetail'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-38 Talon'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'M-346 Master')
WHERE name = 'Boeing T-7 Red Hawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-38 Talon'), NULL,
       (SELECT id FROM airplanes WHERE name = 'M-346 Master'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II')
WHERE name = 'Boeing X-32'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-47B')
WHERE name = 'Boeing X-45'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'X-47B'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fairey Gannet')
WHERE name = 'Breguet Alizé'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'),
       (SELECT id FROM airplanes WHERE name = 'Fairey Gannet'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38')
WHERE name = 'Breguet Atlantique'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-38'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'GAF Nomad')
WHERE name = 'Britten-Norman Defender'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'GAF Nomad'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas')
WHERE name = 'C-119 Flying Boxcar'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'),
       (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou')
WHERE name = 'C-123 Provider'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'),
       (SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-12')
WHERE name = 'C-130 Hercules'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'),
       (SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'),
       (SELECT id FROM airplanes WHERE name = 'Antonov An-12'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76')
WHERE name = 'C-141 Starlifter'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'),
       (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan')
WHERE name = 'C-17 Globemaster III'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'C-141 Starlifter'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'V-22 Osprey'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'C-2 Greyhound'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'V-22 Osprey'),
       (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan')
WHERE name = 'C-5 Galaxy'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'Antonov An-124 Ruslan'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'CAC CA-27 Sabre'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'), NULL,
       (SELECT id FROM airplanes WHERE name = 'MiG-17'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'LTV XC-142')
WHERE name = 'Canadair CL-84 Dynavert'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'LTV XC-142'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'P-2 Neptune'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'P-3 Orion'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Avro Shackleton')
WHERE name = 'Canadair CP-107 Argus'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'),
       (SELECT id FROM airplanes WHERE name = 'P-3 Orion'),
       (SELECT id FROM airplanes WHERE name = 'Avro Shackleton'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'CASA C-101 Aviojet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Hispano HA-200 Saeta'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant')
WHERE name = 'CASA C-212 Aviocar'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'),
       (SELECT id FROM airplanes WHERE name = 'Dornier Do 28 Skyservant'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus C295'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan')
WHERE name = 'CASA/IPTN CN-235'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Airbus C295'),
       (SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet')
WHERE name = 'Canadair CT-114 Tutor'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'),
       (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Wing Loong II')
WHERE name = 'CASC CH-5 Rainbow'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Wing Loong II'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1')
WHERE name = 'Chengdu FC-1/JF-17'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), NULL,
       (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2')
WHERE name = 'Chengdu J-10'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), NULL,
       (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor')
WHERE name = 'Chengdu J-20'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Chengdu J-10'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21 Bison')
WHERE name = 'Chengdu J-7'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
       (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'X-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-3 Stiletto')
WHERE name = 'D-558-2 Skyrocket'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'X-15'),
       (SELECT id FROM airplanes WHERE name = 'X-3 Stiletto'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-2')
WHERE name = 'DHC-2 Beaver'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Antonov An-2'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-123 Provider')
WHERE name = 'DHC-4 Caribou'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'C-123 Provider'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus C295'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Antonov An-12')
WHERE name = 'DHC-5 Buffalo'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'DHC-4 Caribou'),
       (SELECT id FROM airplanes WHERE name = 'Airbus C295'),
       (SELECT id FROM airplanes WHERE name = 'Antonov An-12'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'),
  rival_id       = NULL
WHERE name = 'Dassault MD 315 Flamant'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar')
WHERE name = 'Dornier Do 28 Skyservant'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Dornier Do 31'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Yak-38'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fairey Gannet')
WHERE name = 'E-1 Tracer'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-1 Skyraider'),
       (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'),
       (SELECT id FROM airplanes WHERE name = 'Fairey Gannet'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'E-1 Tracer'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500')
WHERE name = 'E-2 Hawkeye'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'E-1 Tracer'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Shaanxi KJ-500'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev A-50')
WHERE name = 'E-3 Sentry'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'EC-121 Warning Star'),
       (SELECT id FROM airplanes WHERE name = 'Boeing E-7 Wedgetail'),
       (SELECT id FROM airplanes WHERE name = 'Beriev A-50'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'EA-18G Growler'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Su-24'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-6 Intruder'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = NULL
WHERE name = 'EA-6B Prowler'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-6 Intruder'),
       (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'E-3 Sentry'),
  rival_id       = NULL
WHERE name = 'EC-121 Warning Star'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'E-3 Sentry'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Elbit Hermes 900'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'IAI Heron')
WHERE name = 'Elbit Hermes 450'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Elbit Hermes 900'),
       (SELECT id FROM airplanes WHERE name = 'IAI Heron'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Valmet L-70 Vinka')
WHERE name = 'ENAER T-35 Pillán'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Valmet L-70 Vinka'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Mirage III V')
WHERE name = 'EWR VJ 101'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'VFW VAK 191B'),
       (SELECT id FROM airplanes WHERE name = 'Mirage III V'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-1 Predator')
WHERE name = 'Elbit Hermes 900'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Elbit Hermes 450'), NULL,
       (SELECT id FROM airplanes WHERE name = 'MQ-1 Predator'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye')
WHERE name = 'Embraer E-99'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'GAF Nomad')
WHERE name = 'Embraer EMB-110 Bandeirante'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'),
       (SELECT id FROM airplanes WHERE name = 'GAF Nomad'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'Embraer EMB-312 Tucano'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Embraer EMB-314 Super Tucano'),
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Embraer EMB-314 Super Tucano'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'),
       NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'Embraer EMB-326 Xavante'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'),
       (SELECT id FROM airplanes WHERE name = 'AMX A-1 Brésilien'),
       (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Embraer KC-390 Millennium'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Il-28')
WHERE name = 'English Electric Canberra'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
       (SELECT id FROM airplanes WHERE name = 'Il-28'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Gloster Javelin'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-15')
WHERE name = 'English Electric Lightning'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Gloster Javelin'),
       (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
       (SELECT id FROM airplanes WHERE name = 'Su-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'Eurofighter Typhoon Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Rafale'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Panavia Tornado'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'Eurofighter Typhoon Anglais'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Panavia Tornado'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Rafale'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'Eurofighter Typhoon Italien'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Rafale'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F-100 Super Sabre'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
       (SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'),
       (SELECT id FROM airplanes WHERE name = 'MiG-19'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F-101 Voodoo'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'MiG-19'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F-102 Delta Dagger'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'),
       (SELECT id FROM airplanes WHERE name = 'F-106 Delta Dart'),
       (SELECT id FROM airplanes WHERE name = 'MiG-19'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-104 Starfighter'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand')
WHERE name = 'F-104 Starfighter Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-104S Starfighter Italien'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-105 Thunderchief'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'),
       (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-15')
WHERE name = 'F-106 Delta Dart'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Su-15'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'F-111 Aardvark'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
       (SELECT id FROM airplanes WHERE name = 'Su-24'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
  rival_id       = NULL
WHERE name = 'F-117 Nighthawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-31')
WHERE name = 'F-14 Tomcat'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
       (SELECT id FROM airplanes WHERE name = 'MiG-31'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-25')
WHERE name = 'F-15 Eagle'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
       (SELECT id FROM airplanes WHERE name = 'MiG-25'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-34')
WHERE name = 'F-15E Strike Eagle'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'),
       (SELECT id FROM airplanes WHERE name = 'F-15EX Eagle II'),
       (SELECT id FROM airplanes WHERE name = 'Su-34'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-35')
WHERE name = 'F-15EX Eagle II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Su-35'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-15I Ra''am'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-29')
WHERE name = 'F-16 Fighting Falcon'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'),
       (SELECT id FROM airplanes WHERE name = 'MiG-29'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-16I Sufa'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4E Kurnass'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'F-16XL'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
       NULL, (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'F-20 Tigershark'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'),
       NULL,
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-57')
WHERE name = 'F-22 Raptor'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Su-57'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-20')
WHERE name = 'F-35 Lightning II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Chengdu J-20'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'AMX International AMX'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-57')
WHERE name = 'F-35 Lightning II Italien'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'AMX International AMX'),
       NULL, (SELECT id FROM airplanes WHERE name = 'Su-57'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-35B Lightning II Anglais'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-16I Sufa'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'F-35I Adir'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-16I Sufa'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F3H Demon'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-4 Phantom II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F3H Demon'),
       (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand')
WHERE name = 'F-4 Phantom II Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'),
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
       (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-4E Kurnass'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage IIICJ Shahak'),
       (SELECT id FROM airplanes WHERE name = 'F-15I Ra''am'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-4EJ Kai'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-104J'),
       (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-15J'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-5 Freedom Fighter'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = NULL
WHERE name = 'F-5EM Tiger II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F7U Cutlass'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'F-8 Crusader'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'MiG-17'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F-80 Shooting Star'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-94 Starfire'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-23')
WHERE name = 'F-82 Twin Mustang'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-94 Starfire'),
       (SELECT id FROM airplanes WHERE name = 'Yak-23'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F-84F Thunderstreak'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-105 Thunderchief'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'F-86 Sabre'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'),
       (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'),
       (SELECT id FROM airplanes WHERE name = 'MiG-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-94 Starfire'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-25')
WHERE name = 'F-89 Scorpion'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-94 Starfire'),
       (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'),
       (SELECT id FROM airplanes WHERE name = 'Yak-25'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-8 Crusader'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'F-8E (FN) Crusader'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-8 Crusader'),
       (SELECT id FROM airplanes WHERE name = 'Rafale'), (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-25')
WHERE name = 'F-94 Starfire'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
       (SELECT id FROM airplanes WHERE name = 'F-89 Scorpion'),
       (SELECT id FROM airplanes WHERE name = 'Yak-25'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-29')
WHERE name = 'F/A-18 Hornet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'F/A-18E Super Hornet'),
       (SELECT id FROM airplanes WHERE name = 'MiG-29'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-35')
WHERE name = 'F/A-18E Super Hornet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Su-35'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F9F Cougar'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-8 Crusader')
WHERE name = 'F11F Tiger'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F9F Cougar'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-8 Crusader'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F3H Demon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F9F Panther')
WHERE name = 'F2H Banshee'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'FH-1 Phantom'),
       (SELECT id FROM airplanes WHERE name = 'F3H Demon'),
       (SELECT id FROM airplanes WHERE name = 'F9F Panther'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F3D Skyknight'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F2H Banshee'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F4D Skyray')
WHERE name = 'F3H Demon'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F2H Banshee'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'),
       (SELECT id FROM airplanes WHERE name = 'F4D Skyray'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'F4D Skyray'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MiG-19'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Étendard IV'),
  rival_id       = NULL
WHERE name = 'F4U Corsair'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Étendard IV'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-8 Crusader'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'F7U Cutlass'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-8 Crusader'),
       (SELECT id FROM airplanes WHERE name = 'MiG-17'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F9F Panther'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury')
WHERE name = 'F8F Bearcat'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F9F Panther'),
       (SELECT id FROM airplanes WHERE name = 'Hawker Sea Fury'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F9F Panther'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F11F Tiger'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F9F Cougar'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F9F Panther'),
       (SELECT id FROM airplanes WHERE name = 'F11F Tiger'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F8F Bearcat'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F9F Cougar'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'F9F Panther'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F8F Bearcat'),
       (SELECT id FROM airplanes WHERE name = 'F9F Cougar'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fiat G.91')
WHERE name = 'FFA P-16'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
       (SELECT id FROM airplanes WHERE name = 'Fiat G.91'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F2H Banshee'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'de Havilland Vampire')
WHERE name = 'FH-1 Phantom'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F2H Banshee'),
       (SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'OV-10 Bronco')
WHERE name = 'FMA IA 58 Pucará'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'FMA IA 63 Pampa'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre')
WHERE name = 'Fairey Delta 2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Fairey Gannet'),
  rival_id       = NULL
WHERE name = 'Fairey Firefly'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Fairey Gannet'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Fairey Firefly'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'S-2 Tracker')
WHERE name = 'Fairey Gannet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Fairey Firefly'), NULL,
       (SELECT id FROM airplanes WHERE name = 'S-2 Tracker'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'AMX International AMX'),
  rival_id       = NULL
WHERE name = 'Fiat G.91'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'AMX International AMX'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar')
WHERE name = 'Fokker F27 Maritime'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jet Provost')
WHERE name = 'Fokker S.14 Machtrainer'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
       (SELECT id FROM airplanes WHERE name = 'Jet Provost'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Ajeet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'Folland Gnat'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'HAL Ajeet'),
       (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326')
WHERE name = 'Fouga CM.170 Magister'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'),
       (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-326'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'Fuji T-7'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Ryan Firebee')
WHERE name = 'GAF Jindivik'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Ryan Firebee'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235')
WHERE name = 'GAF Nomad'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'CASA/IPTN CN-235'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie')
WHERE name = 'General Atomics YFQ-42A Dark Merlin'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'English Electric Lightning'),
  rival_id       = NULL
WHERE name = 'Gloster Javelin'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'English Electric Lightning'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Gloster Meteor'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hongdu L-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros')
WHERE name = 'Guizhou JL-9'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
       (SELECT id FROM airplanes WHERE name = 'Hongdu L-15'),
       (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-20')
WHERE name = 'HAL AMCA'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Chengdu J-20'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Folland Gnat'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'HAL Ajeet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Folland Gnat'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Jaguar IS'),
  rival_id       = NULL
WHERE name = 'HAL HF-24 Marut'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Jaguar IS'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL Ajeet'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi')
WHERE name = 'HAL HJT-36 Sitara'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'HAL Ajeet'), NULL,
       (SELECT id FROM airplanes WHERE name = 'KAI KT-1 Woongbi'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'HAL Tejas Mk1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-21 Bison'),
       (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'),
       (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'HAL Tejas Mk1A'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'),
       (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk2'),
       (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-10')
WHERE name = 'HAL Tejas Mk2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1A'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Chengdu J-10'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F8F Bearcat')
WHERE name = 'Hawker Sea Fury'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
       (SELECT id FROM airplanes WHERE name = 'F8F Bearcat'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'HESA Saeqeh'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-5 Freedom Fighter'),
       NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'EA-6B Prowler')
WHERE name = 'HFB 320 Hansa Jet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'EA-6B Prowler'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-16')
WHERE name = 'Handley Page Victor'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Tu-16'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Gloster Meteor'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'Hawker Hunter'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Gloster Meteor'),
       (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
       (SELECT id FROM airplanes WHERE name = 'MiG-19'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Hawker P.1127 Kestrel'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Hawker Siddeley Harrier'),
       (SELECT id FROM airplanes WHERE name = 'Yak-38'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Hawker Sea Hawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Supermarine Attacker'),
       (SELECT id FROM airplanes WHERE name = 'Supermarine Scimitar'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Hawker Siddeley Harrier'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Hawker Hunter'),
       (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
       (SELECT id FROM airplanes WHERE name = 'Yak-38'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Avro Shackleton'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-142')
WHERE name = 'Hawker Siddeley Nimrod'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Avro Shackleton'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Tu-142'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Helwan HA-300'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'Hispano HA-200 Saeta'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'CASA C-101 Aviojet'),
       (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik')
WHERE name = 'Hongdu GJ-11 Sharp Sword'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'Sukhoi S-70 Okhotnik'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339')
WHERE name = 'Hongdu JL-8'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros')
WHERE name = 'Hongdu K-8 Karakorum'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-130')
WHERE name = 'Hongdu L-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Yak-130'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka')
WHERE name = 'HU-16 Albatross'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'IAe 33 Pulqui II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar')
WHERE name = 'IAI Arava'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'CASA C-212 Aviocar'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2')
WHERE name = 'IAI Harop'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'IAI Heron'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'IAI Nesher'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'IAI Lavi'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'IAI Kfir'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'IAI Nesher'),
       (SELECT id FROM airplanes WHERE name = 'IAI Lavi'), (SELECT id FROM airplanes WHERE name = 'MiG-23'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'IAI Kfir'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'IAI Lavi'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'IAI Kfir'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 5'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'IAI Kfir'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'IAI Nesher'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage 5'),
       (SELECT id FROM airplanes WHERE name = 'IAI Kfir'), (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb')
WHERE name = 'IAR-99 Șoim'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-28'),
  rival_id       = NULL
WHERE name = 'Il-28'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Yak-28'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet')
WHERE name = 'Iliouchine Il-114'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev A-50')
WHERE name = 'Iliouchine Il-20'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Beriev A-50'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Breguet Atlantique')
WHERE name = 'Iliouchine Il-38'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Breguet Atlantique'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III')
WHERE name = 'Iliouchine Il-76'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Antonov An-12'), NULL,
       (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker')
WHERE name = 'Iliouchine Il-78 Midas'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-17')
WHERE name = 'Jaguar'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Rafale'),
       (SELECT id FROM airplanes WHERE name = 'Su-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Jaguar IS'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'HAL HF-24 Marut'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'BAE Hawk'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet')
WHERE name = 'Jet Provost'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'BAE Hawk'),
       (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'KAI FA-50'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'),
       (SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'),
       (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen')
WHERE name = 'KAI KF-21 Boramae'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'KAI KT-1 Woongbi'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'KAI T-50 Golden Eagle'),
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'M-346 Master')
WHERE name = 'KAI T-50 Golden Eagle'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'M-346 Master'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Vickers VC10')
WHERE name = 'KC-10 Extender'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'),
       (SELECT id FROM airplanes WHERE name = 'KC-46 Pegasus'),
       (SELECT id FROM airplanes WHERE name = 'Vickers VC10'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KC-10 Extender'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76')
WHERE name = 'KC-135 Stratotanker'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'),
       (SELECT id FROM airplanes WHERE name = 'KC-10 Extender'),
       (SELECT id FROM airplanes WHERE name = 'Iliouchine Il-76'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'KC-10 Extender'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT')
WHERE name = 'KC-46 Pegasus'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'),
  rival_id       = NULL
WHERE name = 'KC-97 Stratofreighter'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'),
  rival_id       = NULL
WHERE name = 'Kawasaki C-1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Kawasaki C-2'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium')
WHERE name = 'Kawasaki C-2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Kawasaki C-1'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Embraer KC-390 Millennium'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'P-8 Poseidon')
WHERE name = 'Kawasaki P-1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'Kawasaki T-4'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'), NULL,
       (SELECT id FROM airplanes WHERE name = 'BAE Hawk'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'E-3 Sentry')
WHERE name = 'KJ-2000'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'E-3 Sentry'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Leduc 010'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Lockheed Martin X-59 QueSST'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Dornier Do 31')
WHERE name = 'LTV XC-142'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Dornier Do 31'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'La-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-2'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck')
WHERE name = 'Let L-410 Turbolet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Antonov An-2'), NULL,
       (SELECT id FROM airplanes WHERE name = 'PZL M28 Skytruck'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-25')
WHERE name = 'Lockheed A-12'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
       (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'),
       (SELECT id FROM airplanes WHERE name = 'MiG-25'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Ryan Firebee'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-143 Reys')
WHERE name = 'Lockheed D-21'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Ryan Firebee'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XFY Pogo')
WHERE name = 'Lockheed XFV'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'XFY Pogo'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'M-346 Master'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), NULL,
       (SELECT id FROM airplanes WHERE name = 'BAE Hawk'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'A-26 Invader'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Il-28')
WHERE name = 'Martin B-57 Canberra'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'A-26 Invader'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Il-28'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'IAI Heron')
WHERE name = 'MQ-1 Predator'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'),
       (SELECT id FROM airplanes WHERE name = 'IAI Heron'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'MQ-1C Gray Eagle'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'X-47B'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'MQ-25 Stingray'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'X-47B'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-57'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'YF-22')
WHERE name = 'MiG 1.44'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Su-57'),
       (SELECT id FROM airplanes WHERE name = 'YF-22'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-9'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-17'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'MiG-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-9'), (SELECT id FROM airplanes WHERE name = 'MiG-17'),
       (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-15'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-19'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-86 Sabre')
WHERE name = 'MiG-17'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-15'), (SELECT id FROM airplanes WHERE name = 'MiG-19'),
       (SELECT id FROM airplanes WHERE name = 'F-86 Sabre'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-17'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-21'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II')
WHERE name = 'MiG-19'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-17'), (SELECT id FROM airplanes WHERE name = 'MiG-21'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-19'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-23'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II')
WHERE name = 'MiG-21'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-19'), (SELECT id FROM airplanes WHERE name = 'MiG-23'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand')
WHERE name = 'MiG-21 Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'),
       (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7')
WHERE name = 'MiG-21 Bison'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'HAL Tejas Mk1'),
       (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-21'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-29'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II')
WHERE name = 'MiG-23'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-21'), (SELECT id FROM airplanes WHERE name = 'MiG-29'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand')
WHERE name = 'MiG-23 Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-21 Allemand'),
       (SELECT id FROM airplanes WHERE name = 'MiG-29 Allemand'),
       (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II Allemand'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-31'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird')
WHERE name = 'MiG-25'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MiG-31'),
       (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-23'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jaguar')
WHERE name = 'MiG-27'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-23'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Jaguar'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-23'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-35'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'MiG-29'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-23'), (SELECT id FROM airplanes WHERE name = 'MiG-35'),
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'MiG-29 Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-23 Allemand'),
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-25'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat')
WHERE name = 'MiG-31'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-25'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-29'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Rafale')
WHERE name = 'MiG-35'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-29'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Rafale'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-17')
WHERE name = 'MiG-9'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MiG-15'),
       (SELECT id FROM airplanes WHERE name = 'Yak-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'Mirage 2000'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage F1'),
       (SELECT id FROM airplanes WHERE name = 'Rafale'),
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'Mirage 2000H Vajra'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15 Eagle')
WHERE name = 'Mirage 4000'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
       (SELECT id FROM airplanes WHERE name = 'Rafale'),
       (SELECT id FROM airplanes WHERE name = 'F-15 Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mirage 5'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage III'), NULL,
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'Mirage F1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage III'),
       (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
       (SELECT id FROM airplanes WHERE name = 'MiG-23'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'Mirage G8'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
       (SELECT id FROM airplanes WHERE name = 'MiG-23'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Super Mystère B2'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mirage III'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Super Mystère B2'),
       (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'EWR VJ 101')
WHERE name = 'Mirage III V'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Mirage F1'),
       (SELECT id FROM airplanes WHERE name = 'EWR VJ 101'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'IAI Nesher'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mirage IIICJ Shahak'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'IAI Nesher'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Avro Vulcan')
WHERE name = 'Mirage IV'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Avro Vulcan'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'),
  rival_id       = NULL
WHERE name = 'Mitsubishi F-1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mitsubishi T-2'),
       (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-2'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Mitsubishi F-104J'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
       (SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Mitsubishi F-15J'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-4EJ Kai'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Mitsubishi F-2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'),
  rival_id       = NULL
WHERE name = 'Mitsubishi T-2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu J-20')
WHERE name = 'Mitsubishi X-2 Shinshin'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Chengdu J-20'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie')
WHERE name = 'MQ-28 Ghost Bat'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'XQ-58 Valkyrie'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'RQ-4 Global Hawk'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'MQ-4C Triton'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'RQ-4 Global Hawk'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet')
WHERE name = 'Myasishchev M-4'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Myasishchev M-50'),
       (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-58 Hustler')
WHERE name = 'Myasishchev M-50'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'), NULL,
       (SELECT id FROM airplanes WHERE name = 'B-58 Hustler'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady')
WHERE name = 'Myasishchev M-55'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Ouragan'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Super Mystère B2'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-17')
WHERE name = 'Mystère IV'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Ouragan'),
       (SELECT id FROM airplanes WHERE name = 'Super Mystère B2'),
       (SELECT id FROM airplanes WHERE name = 'MiG-17'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra')
WHERE name = 'Nanchang CJ-6'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Guizhou JL-9'),
       (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Nanchang Q-5'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SNCASO Trident')
WHERE name = 'Nord 1500 Griffon'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'SNCASO Trident'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Transall C-160'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar')
WHERE name = 'Nord Noratlas'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Transall C-160'),
       (SELECT id FROM airplanes WHERE name = 'C-119 Flying Boxcar'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Northrop Tacit Blue'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker')
WHERE name = 'Northrop YB-49'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'B-36 Peacemaker'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'OV-10 Bronco')
WHERE name = 'OV-1 Mohawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'OV-10 Bronco'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk')
WHERE name = 'OV-10 Bronco'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'OV-1 Mohawk'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mystère IV'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Ouragan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Mystère IV'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'P-3 Orion'),
  rival_id       = NULL
WHERE name = 'P-2 Neptune'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'P-3 Orion'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'P-2 Neptune'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Tu-142')
WHERE name = 'P-3 Orion'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'P-2 Neptune'),
       (SELECT id FROM airplanes WHERE name = 'P-8 Poseidon'),
       (SELECT id FROM airplanes WHERE name = 'Tu-142'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'P-3 Orion'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Kawasaki P-1')
WHERE name = 'P-8 Poseidon'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'P-3 Orion'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Kawasaki P-1'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'PAC Super Mushshak'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'T-6 Texan II')
WHERE name = 'Pilatus PC-21'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'), NULL,
       (SELECT id FROM airplanes WHERE name = 'T-6 Texan II'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet')
WHERE name = 'PZL M28 Skytruck'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Let L-410 Turbolet'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín')
WHERE name = 'PZL TS-11 Iskra'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Aero L-29 Delfín'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'PZL-130 Orlik'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'Panavia Tornado'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'),
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Anglais'),
       (SELECT id FROM airplanes WHERE name = 'Su-24'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'Panavia Tornado Allemand'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter Allemand'),
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'),
       (SELECT id FROM airplanes WHERE name = 'Su-24'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Su-24')
WHERE name = 'Panavia Tornado Italien'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'),
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Italien'),
       (SELECT id FROM airplanes WHERE name = 'Su-24'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL-130 Orlik')
WHERE name = 'Pilatus PC-7'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'),
       (SELECT id FROM airplanes WHERE name = 'PZL-130 Orlik'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano')
WHERE name = 'Pilatus PC-9'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Pilatus PC-21'),
       (SELECT id FROM airplanes WHERE name = 'Embraer EMB-312 Tucano'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev A-50')
WHERE name = 'RQ-4 Global Hawk'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Beriev A-50'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand')
WHERE name = 'Rafale'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mirage 2000'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand')
WHERE name = 'Rafale EH'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mirage 2000'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Eurofighter Typhoon Allemand'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Yak-38')
WHERE name = 'Rockwell XFV-12'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Yak-38'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Lockheed D-21'),
  rival_id       = NULL
WHERE name = 'Ryan Firebee'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Lockheed D-21'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'S-3 Viking'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Breguet Alizé')
WHERE name = 'S-2 Tracker'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'S-3 Viking'),
       (SELECT id FROM airplanes WHERE name = 'Breguet Alizé'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'S-2 Tracker'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'S-3 Viking'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'S-2 Tracker'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'de Havilland Vampire')
WHERE name = 'Saab 21R'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'),
       (SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Embraer E-99')
WHERE name = 'Saab 340 AEW&C'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Saab GlobalEye'),
       (SELECT id FROM airplanes WHERE name = 'Embraer E-99'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7')
WHERE name = 'SF.260'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Pilatus PC-7'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye')
WHERE name = 'Shaanxi KJ-500'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shaanxi Y-8'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Shaanxi Y-9'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Shaanxi Y-8'), NULL,
       (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Mirage III')
WHERE name = 'SNCASO Trident'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Mirage III'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Scottish Aviation Bulldog')
WHERE name = 'SOCATA TB-30 Epsilon'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'),
       (SELECT id FROM airplanes WHERE name = 'Scottish Aviation Bulldog'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-25')
WHERE name = 'SR-71 Blackbird'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'U-2 Dragon Lady'), NULL,
       (SELECT id FROM airplanes WHERE name = 'MiG-25'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand')
WHERE name = 'Saab 105'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Alpha Jet Allemand'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 21R'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Saab 29 Tunnan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Saab 21R'),
       (SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'),
  rival_id       = NULL
WHERE name = 'Saab 32 Lansen'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Saab 29 Tunnan'),
       (SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Saab 35 Draken'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Saab 32 Lansen'),
       (SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'),
       (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-23')
WHERE name = 'Saab 37 Viggen'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Saab 35 Draken'),
       (SELECT id FROM airplanes WHERE name = 'Saab JAS 39 Gripen'),
       (SELECT id FROM airplanes WHERE name = 'MiG-23'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye')
WHERE name = 'Saab GlobalEye'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Saab 340 AEW&C'), NULL,
       (SELECT id FROM airplanes WHERE name = 'E-2 Hawkeye'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'Saab JAS 39 Gripen'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Saab 37 Viggen'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-21')
WHERE name = 'Saunders-Roe SR.53'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MiG-21'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon')
WHERE name = 'Scottish Aviation Bulldog'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'SOCATA TB-30 Epsilon'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'de Havilland Venom'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'),
  rival_id       = NULL
WHERE name = 'Sea Vixen'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'de Havilland Venom'),
       (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shaanxi Y-9'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Shaanxi Y-8'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Antonov An-12'),
       (SELECT id FROM airplanes WHERE name = 'Shaanxi Y-9'),
       (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-8'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shenyang J-16'),
  rival_id       = NULL
WHERE name = 'Shenyang J-11'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Shenyang J-8'),
       (SELECT id FROM airplanes WHERE name = 'Shenyang J-16'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-33'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Shenyang J-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-33'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-11'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Shenyang J-16'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II')
WHERE name = 'Shenyang J-35'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'MiG-17'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'),
  rival_id       = NULL
WHERE name = 'Shenyang J-5'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'MiG-17'),
       (SELECT id FROM airplanes WHERE name = 'Shenyang J-6'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Shenyang J-5'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'),
  rival_id       = NULL
WHERE name = 'Shenyang J-6'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Shenyang J-5'),
       (SELECT id FROM airplanes WHERE name = 'Chengdu J-7'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Shenyang J-11'),
  rival_id       = NULL
WHERE name = 'Shenyang J-8'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Shenyang J-11'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka')
WHERE name = 'ShinMaywa US-1A'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-2'),
       (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka')
WHERE name = 'ShinMaywa US-2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'ShinMaywa US-1A'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Beriev Be-12 Chaïka'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Bell X-14')
WHERE name = 'Short SC.1'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'),
       (SELECT id FROM airplanes WHERE name = 'Bell X-14'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Jet Provost'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-6 Texan II'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'Shorts Tucano'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Jet Provost'),
       (SELECT id FROM airplanes WHERE name = 'T-6 Texan II'),
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra')
WHERE name = 'Soko G-2 Galeb'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL,
       (SELECT id FROM airplanes WHERE name = 'Soko G-4 Super Galeb'),
       (SELECT id FROM airplanes WHERE name = 'PZL TS-11 Iskra'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros')
WHERE name = 'Soko G-4 Super Galeb'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Aero L-39 Albatros'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'AMX International AMX')
WHERE name = 'Soko J-22 Orao'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'AMX International AMX'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-9'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger')
WHERE name = 'Su-11'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-9'), (SELECT id FROM airplanes WHERE name = 'Su-15'),
       (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-11'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-31'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'English Electric Lightning')
WHERE name = 'Su-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-11'), (SELECT id FROM airplanes WHERE name = 'MiG-31'),
       (SELECT id FROM airplanes WHERE name = 'English Electric Lightning'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-7'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-25'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jaguar')
WHERE name = 'Su-17'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-7'), (SELECT id FROM airplanes WHERE name = 'Su-25'),
       (SELECT id FROM airplanes WHERE name = 'Jaguar'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-34'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark')
WHERE name = 'Su-24'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Su-34'),
       (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II')
WHERE name = 'Su-25'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'A-10 Thunderbolt II'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-30'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-27'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Su-30'),
       (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-27'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-35'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-30'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM airplanes WHERE name = 'Su-35'),
       (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-30'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17')
WHERE name = 'Su-30MKI'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-30'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Chengdu FC-1/JF-17'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-27'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat')
WHERE name = 'Su-33'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-27'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-24'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-34'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-24'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-27'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-57'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle')
WHERE name = 'Su-35'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-27'), (SELECT id FROM airplanes WHERE name = 'Su-57'),
       (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Su-35'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor')
WHERE name = 'Su-57'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Su-35'), NULL,
       (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-17'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre')
WHERE name = 'Su-7'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Su-17'),
       (SELECT id FROM airplanes WHERE name = 'F-100 Super Sabre'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-11'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger')
WHERE name = 'Su-9'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Su-11'),
       (SELECT id FROM airplanes WHERE name = 'F-102 Delta Dagger'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hongdu GJ-11 Sharp Sword')
WHERE name = 'Sukhoi S-70 Okhotnik'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'Hongdu GJ-11 Sharp Sword'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie')
WHERE name = 'Sukhoi T-4'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Mystère IV'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage III'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-19')
WHERE name = 'Super Mystère B2'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Mystère IV'),
       (SELECT id FROM airplanes WHERE name = 'Mirage III'),
       (SELECT id FROM airplanes WHERE name = 'MiG-19'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Étendard IV'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Rafale'),
  rival_id       = NULL
WHERE name = 'Super Étendard'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Étendard IV'),
       (SELECT id FROM airplanes WHERE name = 'Rafale'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'Supermarine Attacker'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'),
  rival_id       = NULL
WHERE name = 'Supermarine Scimitar'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Hawker Sea Hawk'),
       (SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker Hunter')
WHERE name = 'Supermarine Swift'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Hawker Hunter'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-34 Mentor'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'T-28 Trojan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-34 Mentor'),
       (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'),
       (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-38 Talon'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister')
WHERE name = 'T-33 Shooting Star'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F-80 Shooting Star'),
       (SELECT id FROM airplanes WHERE name = 'T-38 Talon'),
       (SELECT id FROM airplanes WHERE name = 'Fouga CM.170 Magister'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'T-28 Trojan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'SF.260')
WHERE name = 'T-34 Mentor'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'T-28 Trojan'),
       (SELECT id FROM airplanes WHERE name = 'SF.260'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-28 Trojan'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Jet Provost')
WHERE name = 'T-37 Tweet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-28 Trojan'),
       (SELECT id FROM airplanes WHERE name = 'A-37 Dragonfly'),
       (SELECT id FROM airplanes WHERE name = 'Jet Provost'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Boeing T-7 Red Hawk'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Hawk')
WHERE name = 'T-38 Talon'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-33 Shooting Star'),
       (SELECT id FROM airplanes WHERE name = 'Boeing T-7 Red Hawk'),
       (SELECT id FROM airplanes WHERE name = 'BAE Hawk'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-37 Tweet'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'T-6 Texan II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-37 Tweet'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'IAI Heron'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2')
WHERE name = 'TAI Anka'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'IAI Heron'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Bayraktar TB2'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'T-38 Talon'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'M-346 Master')
WHERE name = 'TAI Hürjet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'T-38 Talon'), NULL,
       (SELECT id FROM airplanes WHERE name = 'M-346 Master'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'TAI Kaan'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9')
WHERE name = 'TAI Hürkuş'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'TAI Kaan'),
       (SELECT id FROM airplanes WHERE name = 'Pilatus PC-9'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae')
WHERE name = 'TAI Kaan'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'KAI KF-21 Boramae'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Nord Noratlas'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-130 Hercules')
WHERE name = 'Transall C-160'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Nord Noratlas'),
       (SELECT id FROM airplanes WHERE name = 'Airbus A400M Atlas'),
       (SELECT id FROM airplanes WHERE name = 'C-130 Hercules'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-31'),
  rival_id       = NULL
WHERE name = 'Tu-128'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MiG-31'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Lockheed D-21')
WHERE name = 'Tu-141 Strizh'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Tu-143 Reys'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Lockheed D-21'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-95'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'P-3 Orion')
WHERE name = 'Tu-142'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Tu-95'), NULL,
       (SELECT id FROM airplanes WHERE name = 'P-3 Orion'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Ryan Firebee')
WHERE name = 'Tu-143 Reys'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Tu-141 Strizh'),
       (SELECT id FROM airplanes WHERE name = 'Ryan Firebee'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-22M'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress')
WHERE name = 'Tu-16'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Tupolev Tu-4'),
       (SELECT id FROM airplanes WHERE name = 'Tu-22M'),
       (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-95'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-1 Lancer')
WHERE name = 'Tu-160'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Tu-95'), NULL,
       (SELECT id FROM airplanes WHERE name = 'B-1 Lancer'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-22M'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-58 Hustler')
WHERE name = 'Tu-22'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Tu-22M'),
       (SELECT id FROM airplanes WHERE name = 'B-58 Hustler'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-22'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-160'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark')
WHERE name = 'Tu-22M'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Tu-22'), (SELECT id FROM airplanes WHERE name = 'Tu-160'),
       (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-160'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress')
WHERE name = 'Tu-95'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Tu-160'),
       (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Tu-16'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet')
WHERE name = 'Tupolev Tu-4'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Tu-16'),
       (SELECT id FROM airplanes WHERE name = 'B-47 Stratojet'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'),
  rival_id       = NULL
WHERE name = 'U-2 Dragon Lady'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird'), NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'V-22 Osprey'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'C-2 Greyhound'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'EWR VJ 101'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel')
WHERE name = 'VFW VAK 191B'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'EWR VJ 101'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'ENAER T-35 Pillán')
WHERE name = 'Valmet L-70 Vinka'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'ENAER T-35 Pillán'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Mirage IV'),
  rival_id       = NULL
WHERE name = 'Vautour II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Mirage IV'), NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker')
WHERE name = 'Vickers VC10'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Airbus A330 MRTT'),
       (SELECT id FROM airplanes WHERE name = 'KC-135 Stratotanker'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Myasishchev M-4')
WHERE name = 'Vickers Valiant'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Myasishchev M-4'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper')
WHERE name = 'Wing Loong II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'MQ-9 Reaper'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'XFY Pogo')
WHERE name = 'X-13 Vertijet'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'XFY Pogo'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'X-15'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-31')
WHERE name = 'X-29'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'X-31'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket')
WHERE name = 'X-3 Stiletto'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'),
       (SELECT id FROM airplanes WHERE name = 'D-558-2 Skyrocket'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'X-29')
WHERE name = 'X-31'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
       (SELECT id FROM airplanes WHERE name = 'X-29'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'nEUROn')
WHERE name = 'X-47B'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MQ-25 Stingray'),
       (SELECT id FROM airplanes WHERE name = 'nEUROn'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'B-58 Hustler'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Sukhoi T-4')
WHERE name = 'XB-70 Valkyrie'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'B-58 Hustler'), NULL,
       (SELECT id FROM airplanes WHERE name = 'Sukhoi T-4'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Lockheed XFV')
WHERE name = 'XFY Pogo'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'Lockheed XFV'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'nEUROn')
WHERE name = 'XQ-58 Valkyrie'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'nEUROn'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Tu-16'),
  successor_id   = NULL,
  rival_id       = NULL
WHERE name = 'Xian H-6'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Tu-16'), NULL, NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III')
WHERE name = 'Xian Y-20 Kunpeng'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL,
       (SELECT id FROM airplanes WHERE name = 'C-17 Globemaster III'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'MiG-15'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-9')
WHERE name = 'Yak-17'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'MiG-15'),
       (SELECT id FROM airplanes WHERE name = 'MiG-9'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon')
WHERE name = 'YF-17 Cobra'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F/A-18 Hornet'),
       (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II')
WHERE name = 'YF-22'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'),
       (SELECT id FROM airplanes WHERE name = 'YF-23 Black Widow II'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'F-22 Raptor')
WHERE name = 'YF-23 Black Widow II'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'F-22 Raptor'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'M-346 Master')
WHERE name = 'Yak-130'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, NULL, (SELECT id FROM airplanes WHERE name = 'M-346 Master'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-38'),
  successor_id   = NULL,
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier')
WHERE name = 'Yak-141'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Yak-38'), NULL,
       (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-17'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-25'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'La-15')
WHERE name = 'Yak-23'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Yak-17'), (SELECT id FROM airplanes WHERE name = 'Yak-25'),
       (SELECT id FROM airplanes WHERE name = 'La-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-23'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-28'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Gloster Javelin')
WHERE name = 'Yak-25'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Yak-23'), (SELECT id FROM airplanes WHERE name = 'Yak-28'),
       (SELECT id FROM airplanes WHERE name = 'Gloster Javelin'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'Yak-25'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Su-24'),
  rival_id       = NULL
WHERE name = 'Yak-28'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'Yak-25'), (SELECT id FROM airplanes WHERE name = 'Su-24'),
       NULL);

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-38'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel')
WHERE name = 'Yak-36'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Yak-38'),
       (SELECT id FROM airplanes WHERE name = 'Hawker P.1127 Kestrel'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Yak-141'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier')
WHERE name = 'Yak-38'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'Yak-141'),
       (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier'));

UPDATE airplanes SET
  predecessor_id = NULL,
  successor_id   = (SELECT id FROM airplanes WHERE name = 'de Havilland Venom'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'de Havilland Vampire'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      (NULL, (SELECT id FROM airplanes WHERE name = 'de Havilland Venom'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Sea Vixen'),
  rival_id       = (SELECT id FROM airplanes WHERE name = 'MiG-15')
WHERE name = 'de Havilland Venom'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'de Havilland Vampire'),
       (SELECT id FROM airplanes WHERE name = 'Sea Vixen'),
       (SELECT id FROM airplanes WHERE name = 'MiG-15'));

UPDATE airplanes SET
  predecessor_id = (SELECT id FROM airplanes WHERE name = 'F4U Corsair'),
  successor_id   = (SELECT id FROM airplanes WHERE name = 'Super Étendard'),
  rival_id       = NULL
WHERE name = 'Étendard IV'
  AND (predecessor_id, successor_id, rival_id)
      IS DISTINCT FROM
      ((SELECT id FROM airplanes WHERE name = 'F4U Corsair'),
       (SELECT id FROM airplanes WHERE name = 'Super Étendard'), NULL);

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

-- Conflits ajoutés au référentiel (déclarés dans db.sql) : chaque appareil
-- n'y figure que si sa propre fiche en raconte l'engagement.

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre d''Indochine' AND a.name IN (
  'F8F Bearcat',
  'A-26 Invader',
  'C-119 Flying Boxcar',
  'F4U Corsair',
  'Dassault MD 315 Flamant'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Insurrection malaise' AND a.name IN (
  'de Havilland Venom',
  'CAC CA-27 Sabre',
  'English Electric Canberra',
  'de Havilland Vampire'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Crise de Suez' AND a.name IN (
  'Westland Wyvern',
  'Hawker Sea Hawk',
  'Vickers Valiant',
  'de Havilland Venom',
  'F-84F Thunderstreak',
  'F4U Corsair',
  'Nord Noratlas',
  'Mystère IV',
  'Ouragan',
  'English Electric Canberra',
  'MiG-15'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Crise congolaise' AND a.name IN (
  'Saab 29 Tunnan',
  'T-28 Trojan',
  'A-26 Invader',
  'DHC-4 Caribou',
  'Fouga CM.170 Magister',
  'English Electric Canberra'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre coloniale portugaise' AND a.name IN (
  'Fiat G.91',
  'Nord Noratlas'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Invasion de la baie des Cochons' AND a.name IN (
  'Hawker Sea Fury',
  'A-26 Invader',
  'T-33 Shooting Star'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Annexion de Goa' AND a.name IN (
  'English Electric Canberra',
  'Hawker Hunter'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Confrontation indonésio-malaisienne' AND a.name IN (
  'Gloster Javelin',
  'Sea Vixen',
  'Hawker Hunter'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Urgence d''Aden' AND a.name IN (
  'Hawker Hunter',
  'Avro Shackleton',
  'Sea Vixen'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Conflit armé colombien' AND a.name IN (
  'Embraer EMB-314 Super Tucano',
  'AC-47 Spooky',
  'OV-10 Bronco'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Bush rhodésien' AND a.name IN (
  'Hawker Hunter',
  'SF.260',
  'de Havilland Vampire',
  'English Electric Canberra'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre indo-pakistanaise de 1965' AND a.name IN (
  'Folland Gnat',
  'Hawker Hunter',
  'English Electric Canberra',
  'Martin B-57 Canberra',
  'Mystère IV',
  'Ouragan',
  'Breguet Alizé',
  'F-86 Sabre',
  'F-104 Starfighter',
  'de Havilland Vampire'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre de la frontière sud-africaine' AND a.name IN (
  'Atlas Impala',
  'Mirage F1',
  'MiG-23',
  'Blackburn Buccaneer',
  'English Electric Canberra',
  'C-130 Hercules',
  'Transall C-160'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre d''usure' AND a.name IN (
  'F-4E Kurnass',
  'Mirage IIICJ Shahak',
  'MiG-21',
  'A-4 Skyhawk',
  'Su-7'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Biafra' AND a.name IN (
  'Aero L-29 Delfín',
  'MiG-17',
  'Il-28'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Invasion turque de Chypre' AND a.name IN (
  'F-100 Super Sabre',
  'F-104 Starfighter',
  'Nord Noratlas'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Sahara occidental' AND a.name IN (
  'Hispano HA-200 Saeta',
  'Mirage F1',
  'F-5 Freedom Fighter'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre de l''Ogaden' AND a.name IN (
  'F-5 Freedom Fighter',
  'MiG-21'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Conflit tchado-libyen' AND a.name IN (
  'Jaguar',
  'Mirage F1',
  'Transall C-160',
  'Pilatus PC-7',
  'SF.260',
  'Tu-22'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre civile salvadorienne' AND a.name IN (
  'A-37 Dragonfly',
  'AC-47 Spooky'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre soviéto-afghane' AND a.name IN (
  'Su-17',
  'Su-24',
  'Su-25',
  'Tu-22M',
  'Tu-16',
  'Tu-22',
  'MiG-27',
  'Yak-28',
  'Yak-38',
  'Antonov An-12',
  'Antonov An-22 Antei',
  'Iliouchine Il-76',
  'MiG-23',
  'MiG-21',
  'Antonov An-26',
  'F-16 Fighting Falcon'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre civile du Sri Lanka' AND a.name IN (
  'SF.260',
  'IAI Kfir',
  'MiG-27',
  'Chengdu J-7',
  'FMA IA 58 Pucará'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Invasion de la Grenade' AND a.name IN (
  'C-141 Starlifter',
  'AC-130 Spectre',
  'A-7 Corsair II',
  'C-130 Hercules'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Conflit turco-kurde (PKK)' AND a.name IN (
  'TAI Anka',
  'Bayraktar Akıncı',
  'Bayraktar TB2'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Invasion du Panama' AND a.name IN (
  'F-117 Nighthawk',
  'C-141 Starlifter',
  'AC-130 Spectre',
  'C-130 Hercules'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Intervention en Somalie' AND a.name IN (
  'C-141 Starlifter',
  'Aeritalia G.222',
  'Transall C-160',
  'AC-130 Spectre'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerres de Tchétchénie' AND a.name IN (
  'Su-24',
  'Su-25',
  'Tu-22M'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Cenepa' AND a.name IN (
  'Mirage F1',
  'Su-17',
  'IAI Kfir',
  'A-37 Dragonfly'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre Érythrée-Éthiopie' AND a.name IN (
  'Aermacchi MB-339',
  'MiG-29',
  'Su-27',
  'MiG-23'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre de Kargil' AND a.name IN (
  'Mirage 2000H Vajra',
  'Jaguar IS',
  'MiG-27',
  'MiG-21',
  'English Electric Canberra'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Liban de 2006' AND a.name IN (
  'F-16I Sufa',
  'Elbit Hermes 450',
  'IAI Heron'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre russo-géorgienne' AND a.name IN (
  'Su-24',
  'Su-25',
  'Su-27',
  'Su-34',
  'Tu-22M'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Sahel' AND a.name IN (
  'Rafale',
  'Mirage 2000',
  'Breguet Atlantique',
  'MQ-9 Reaper',
  'IAI Heron',
  'Airbus A400M Atlas',
  'Airbus A330 MRTT',
  'Transall C-160',
  'TAI Hürkuş',
  'Bayraktar Akıncı'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Donbass' AND a.name IN (
  'Antonov An-26',
  'Iliouchine Il-76',
  'Su-25',
  'MiG-29',
  'Su-24'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre civile libyenne (2014-2020)' AND a.name IN (
  'Wing Loong II',
  'Bayraktar TB2',
  'TAI Anka',
  'MQ-9 Reaper'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre contre l''État islamique' AND a.name IN (
  'Boeing E-7 Wedgetail',
  'EA-18G Growler',
  'EA-6B Prowler',
  'Rafale',
  'Super Étendard',
  'Panavia Tornado Allemand',
  'Panavia Tornado Italien',
  'Eurofighter Typhoon Italien',
  'Aero L-159 ALCA',
  'Panavia Tornado',
  'Eurofighter Typhoon Anglais',
  'F-22 Raptor',
  'Breguet Atlantique',
  'Airbus A330 MRTT',
  'Mirage 2000',
  'B-1 Lancer',
  'F-16 Fighting Falcon',
  'F/A-18E Super Hornet',
  'MQ-9 Reaper'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre civile yéménite' AND a.name IN (
  'MQ-9 Reaper',
  'B-2 Spirit',
  'Eurofighter Typhoon Anglais',
  'F/A-18E Super Hornet',
  'F-16 Fighting Falcon'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Siège de Marawi' AND a.name IN (
  'KAI FA-50',
  'OV-10 Bronco'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Haut-Karabagh (2020)' AND a.name IN (
  'Bayraktar TB2',
  'IAI Harop',
  'Antonov An-2'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre Israël-Hamas' AND a.name IN (
  'Elbit Hermes 450',
  'F-16I Sufa',
  'F-15I Ra''am',
  'F-35I Adir'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Conflit indo-pakistanais de 2025' AND a.name IN (
  'Rafale EH',
  'Chengdu J-10'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre Iran-Israël' AND a.name IN (
  'F-35I Adir',
  'F-15I Ra''am',
  'F-16I Sufa',
  'B-2 Spirit'
)
ON CONFLICT DO NOTHING;

-- Conflits déjà présents : engagements racontés par les fiches mais jamais
-- rattachés.

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre d''Algérie' AND a.name IN (
  'Dassault MD 315 Flamant',
  'Nord Noratlas',
  'T-28 Trojan'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre Indo-Pakistanaise de 1971' AND a.name IN (
  'Breguet Alizé',
  'Mirage III',
  'MiG-21'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Kippour' AND a.name IN (
  'MiG-23',
  'C-141 Starlifter'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre Iran-Irak' AND a.name IN (
  'Tu-143 Reys',
  'Super Étendard'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre des Malouines' AND a.name IN (
  'Aermacchi MB-339',
  'IAI Nesher',
  'Mirage III'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Liban' AND a.name IN (
  'Mirage IIICJ Shahak',
  'Tu-143 Reys',
  'F-16 Fighting Falcon'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Golfe' AND a.name IN (
  'A-3 Skywarrior',
  'MiG-25',
  'MiG-21',
  'MiG-23',
  'Su-25'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre de Yougoslavie' AND a.name IN (
  'B-1 Lancer',
  'B-52 Stratofortress',
  'Mirage 2000',
  'Super Étendard',
  'Étendard IV',
  'S-3 Viking',
  'Vickers VC10',
  'MQ-1 Predator',
  'Soko G-2 Galeb',
  'C-17 Globemaster III',
  'Britten-Norman Defender'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre d''Afghanistan' AND a.name IN (
  'MQ-1 Predator',
  'F-14 Tomcat',
  'Super Étendard',
  'RQ-4 Global Hawk',
  'Britten-Norman Defender',
  'C-2 Greyhound'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre d''Irak' AND a.name IN (
  'F-14 Tomcat',
  'MQ-1 Predator',
  'RQ-4 Global Hawk',
  'Britten-Norman Defender',
  'C-2 Greyhound'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre civile syrienne' AND a.name IN (
  'A-10 Thunderbolt II',
  'B-52 Stratofortress',
  'F-15E Strike Eagle',
  'F-16 Fighting Falcon',
  'EA-18G Growler',
  'EA-6B Prowler',
  'Breguet Atlantique',
  'Panavia Tornado',
  'Iliouchine Il-20',
  'Antonov An-26'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Intervention en Libye' AND a.name IN (
  'AMX International AMX',
  'EA-18G Growler',
  'Saab JAS 39 Gripen',
  'B-1 Lancer',
  'RQ-4 Global Hawk',
  'MQ-1 Predator'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Conflit israélo-arabe' AND a.name IN (
  'Aero L-29 Delfín'
)
ON CONFLICT DO NOTHING;

-- Récits corrigés en v4.14.0 (audit CONT-001) : engagements désormais racontés
-- par la fiche elle-même. Mirage F1 : « en Libye (2011) et au Mali (2013) »
-- (opérations Harmattan et Serval) ; Su-17 : « au Liban (1982, aux mains de
-- l'aviation syrienne) ».

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Intervention en Libye' AND a.name IN (
  'Mirage F1'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Sahel' AND a.name IN (
  'Mirage F1'
)
ON CONFLICT DO NOTHING;

INSERT INTO airplane_wars (id_airplane, id_wars)
SELECT a.id, w.id FROM airplanes a, wars w
WHERE w.name = 'Guerre du Liban' AND a.name IN (
  'Su-17'
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
   SET description_en = 'First generation: Subsonic jet aircraft from the 1940s–1950s'
 WHERE generation = 1 AND description_en IS NULL;

COMMIT;
