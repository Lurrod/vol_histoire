"""Strate 7 — assemble les valeurs extraites (specs7_parse.py), les corrections
de la revue manuelle et les règles de cohérence, puis écrit :

  specs7/final.json                       valeurs retenues, par fiche
  backend/db_backup/zz_specs_strate7.sql  UPDATE rejouables (source unique)

Règles :
  - distance de convoyage écartée si elle ne dépasse pas la distance
    franchissable déjà en base (plus courte : sources contradictoires ;
    égale : la base portait déjà la distance de convoyage) ;
  - supercroisière : TRUE / FALSE seulement si l'article l'affirme ;
  - soute interne : TRUE si l'article la décrit pour cet appareil, FALSE si
    l'article dit qu'il n'en a pas, ou pour un chasseur / intercepteur /
    multirôle / appui sans soute ; NULL sinon (doute, drones, transports) ;
  - radar : saisi à la main d'après le gabarit et le corps de l'article
    (radar principal de la version de la fiche ; ni radar météo, ni simple
    télémètre de viseur).

  python -I tools/lots/specs7_build.py
"""
import json
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')
RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
D = RACINE / 'specs7'
SQL = RACINE.parent / 'backend' / 'db_backup' / 'zz_specs_strate7.sql'

# ── Corrections de la revue ──────────────────────────────────────────────
# None = valeur extraite écartée.
MACH = {
    'Bell X-1': None,              # le gabarit donne le X-1A (Mach 2,44)
    'Boeing X-32': None,           # 1,2 contredit la vitesse en base
    'Guizhou JL-9': None,          # 0,89 au niveau de la mer, max non donné
    'Su-17': None,                 # Mach 1,13 au niveau de la mer seulement
    'Hawker Siddeley Harrier': None,  # Mach 1,3 en piqué
    'Hispano HA-1112 Buchón': None,   # « Mach 1.0 » : erreur de l'article
    'U-2 Dragon Lady': None,       # vitesse de croisière
}
EMPORT = {
    'A-4 Skyhawk': 5, 'Hawker Siddeley Harrier': 5, 'Su-7': 6, 'Bayraktar Kızılelma': 8,
    'F-35 Lightning II': 10, 'F-35 Lightning II Italien': 10, 'F-35I Adir': 10,
    'Shenyang J-35': 12, 'MiG-29': 7, 'MiG-29 Allemand': 7, 'IAR-93 Vultur': 5,
    'OV-10 Bronco': 7, 'TAI Kaan': 14, 'Su-34': 12, 'Chengdu J-7': 5,
    'English Electric Lightning': 4, 'Boeing X-45': 8, 'Cessna O-2 Skymaster': 4,
    'F-15E Strike Eagle': None, "F-15I Ra'am": None, 'AIDC T-5 Brave Eagle': None,
    'Blackburn Buccaneer': 4,      # la soute rotative n'est pas un point d'emport
}
CARBURANT = {
    'EC-130H Compass Call': None,  # « around 100000 liters » : invraisemblable
}
RADAR = {
    'A-3 Skywarrior': 'AN/ASB-1A', 'A-4 Skyhawk': 'AN/APG-53A / AN/APQ-145',
    'A-5 Vigilante': 'AN/ASB-12', 'A-6 Intruder': 'AN/APQ-92 / AN/APQ-148',
    'A-7 Corsair II': 'AN/APQ-126', 'Aero L-159 ALCA': 'FIAR Grifo-L',
    'AIDC F-CK-1 Ching-kuo': 'GD-53', 'AV-8B Harrier II': 'AN/APG-65',
    'Avro Canada CF-100 Canuck': 'AN/APG-33 / AN/APG-40', 'B-1 Lancer': 'AN/APQ-164',
    'B-2 Spirit': 'AN/APQ-181', 'B-29 Superfortress': 'AN/APQ-13', 'B-52 Stratofortress': 'AN/APQ-166',
    'Blackburn Buccaneer': 'Blue Parrot', 'BAE Sea Harrier': 'Ferranti Blue Fox / Blue Vixen',
    'Bayraktar Akıncı': 'Aselsan MURAD (AESA)', 'Bayraktar Kızılelma': 'Aselsan MURAD (AESA)',
    'Boeing E-7 Wedgetail': 'Northrop Grumman MESA', 'Boeing E-767': 'AN/APY-2',
    'Canadair CP-107 Argus': 'AN/APS-20', 'Chengdu FC-1/JF-17': 'KLJ-7 / KLJ-7A (AESA)',
    'Chengdu J-10': 'Type 1473', 'E-1 Tracer': 'AN/APS-82', 'E-2 Hawkeye': 'AN/APS-145 / AN/APY-9',
    'E-3 Sentry': 'AN/APY-1 / AN/APY-2', 'E-8 Joint STARS': 'AN/APY-7',
    'EA-18G Growler': 'AN/APG-79 (AESA)', 'EC-121 Warning Star': 'AN/APS-20 / AN/APS-45',
    'Embraer E-99': 'Erieye', 'English Electric Lightning': 'Ferranti AI.23', 'Étendard IV': 'Aïda',
    'Eurofighter Typhoon Allemand': 'Euroradar CAPTOR', 'Eurofighter Typhoon Anglais': 'Euroradar CAPTOR',
    'Eurofighter Typhoon Italien': 'Euroradar CAPTOR',
    'F-101 Voodoo': 'Hughes MG-13', 'F-102 Delta Dagger': 'Hughes MG-10',
    'F-104 Starfighter': 'Autonetics NASARR', 'F-104 Starfighter Allemand': 'Autonetics NASARR',
    'Mitsubishi F-104J': 'Autonetics NASARR', 'F-104S Starfighter Italien': 'NASARR R-21G',
    'F-105 Thunderchief': 'NASARR R-14A', 'F-106 Delta Dart': 'Hughes MA-1',
    'F-111 Aardvark': 'AN/APQ-113', 'F-14 Tomcat': 'AN/AWG-9 / AN/APG-71',
    'F-15 Eagle': 'AN/APG-63 / AN/APG-70', 'F-15E Strike Eagle': 'AN/APG-70 / AN/APG-82 (AESA)',
    'F-15EX Eagle II': 'AN/APG-82 (AESA)', "F-15I Ra'am": 'AN/APG-70',
    'F-16 Fighting Falcon': 'AN/APG-66 / AN/APG-68', 'F-16I Sufa': 'AN/APG-68',
    'F-20 Tigershark': 'AN/APG-67', 'F-22 Raptor': 'AN/APG-77 (AESA)',
    'F-35 Lightning II': 'AN/APG-81 (AESA)', 'F-35 Lightning II Italien': 'AN/APG-81 (AESA)',
    'F-35I Adir': 'AN/APG-81 (AESA)', 'F-4 Phantom II': 'AN/APQ-72 / AN/APQ-120',
    'F-4 Phantom II Allemand': 'AN/APQ-120', 'F-4E Kurnass': 'AN/APQ-120',
    'F-5EM Tiger II': 'FIAR Grifo-F', 'F-8 Crusader': 'AN/APQ-83 / AN/APQ-94',
    'F-8E (FN) Crusader': 'AN/APQ-104', 'F-86D Sabre': 'AN/APG-36',
    'F-89 Scorpion': 'AN/APG-33 / AN/APG-40', 'F-94 Starfire': 'AN/APG-33 / AN/APG-40',
    'F/A-18 Hornet': 'AN/APG-65 / AN/APG-73', 'F/A-18E Super Hornet': 'AN/APG-73 / AN/APG-79 (AESA)',
    'F3D Skyknight': 'AN/APQ-35', 'F3H Demon': 'AN/APG-51', 'F4D Skyray': 'AN/APQ-50',
    'F5D Skylancer': 'AN/APQ-64', 'F7U Cutlass': 'AN/APQ-36', 'Fairey Gannet': 'ASV Mk 19',
    'Gloster Javelin': 'AI.17 / AN/APQ-43', 'HAL Tejas Mk1': 'Elta EL/M-2032',
    'HAL Tejas Mk1A': 'Elta EL/M-2052 (AESA)', 'HAL Tejas Mk2': 'LRDE Uttam (AESA)',
    'Hawker Siddeley Nimrod': 'Searchwater', 'HU-16 Albatross': 'AN/APS-31',
    'IAI Kfir': 'Elta EL/M-2001B / EL/M-2032', 'Iliouchine Il-38': 'Berkut',
    'KAI KF-21 Boramae': 'APY-016K (AESA)', 'Kawasaki P-2J': 'AN/APS-80',
    'Lockheed YF-12': 'Hughes AN/ASG-18', 'Martin P4M Mercator': 'AN/APS-33',
    'Martin PBM Mariner': 'AN/APS-15', 'P5M Marlin': 'AN/APS-44 / AN/APS-80',
    'North American AJ Savage': 'AN/APS-31', 'MiG-21': 'RP-21 Sapfir', 'MiG-21 Allemand': 'RP-21 Sapfir',
    'MiG-23': 'Sapfir-23', 'MiG-23 Allemand': 'Sapfir-23', 'MiG-25': 'Smerch-A / RP-25 Sapfir-25',
    'MiG-29': 'Phazotron N019', 'MiG-29 Allemand': 'Phazotron N019', 'MiG-31': 'Zaslon (PESA)',
    'MiG-35': 'Phazotron Zhuk-M / Zhuk-A (AESA)', 'MiG 1.44': 'N014 (PESA)',
    'Mirage 2000': 'Thomson-CSF RDM / RDI / RDY', 'Mirage 2000H Vajra': 'Thomson-CSF RDM',
    'Mirage F1': 'Thomson-CSF Cyrano IV', 'Mirage III': 'Thomson-CSF Cyrano II',
    'Mitsubishi F-15J': 'AN/APG-63', 'Mitsubishi F-2': 'Mitsubishi J/APG-1 / J/APG-2 (AESA)',
    'MQ-1 Predator': 'AN/ZPQ-1 (SAR)', 'MQ-1C Gray Eagle': 'AN/ZPY-1 STARLite (SAR)',
    'MQ-20 Avenger': 'Lynx (SAR)', 'MQ-9 Reaper': 'AN/APY-8 Lynx II (SAR)',
    'P-2 Neptune': 'AN/APS-20', 'P-3 Orion': 'AN/APS-115 / AN/APS-137', 'P-8 Poseidon': 'AN/APY-10',
    'Rafale': 'Thales RBE2 / RBE2-AA (AESA)', 'Rafale EH': 'Thales RBE2 / RBE2-AA (AESA)',
    'S-2 Tracker': 'AN/APS-38', 'S-3 Viking': 'AN/APS-116 / AN/APS-137',
    'Saab 340 AEW&C': 'Ericsson Erieye', 'Saab GlobalEye': 'Saab Erieye ER',
    'Saab 37 Viggen': 'PS-37/A / PS-46/A', 'Saab JAS 39 Gripen': 'Ericsson PS-05/A',
    'Sea Vixen': 'GEC AI.18', 'Shenyang J-11': 'N001VE / Type 1493', 'Shenyang J-15': 'Type 1493',
    'Shenyang J-35': 'KLJ-7A (AESA)', 'Shenyang J-8': 'Type 1492 / KLJ-1',
    'ShinMaywa PS-1': 'AN/APS-80N', 'ShinMaywa US-1A': 'AN/APS-80N', 'Short Seamew': 'ASV Mk 19B',
    'Su-15': 'Taifun-M', 'Su-24': 'Orion-A', 'Su-27': 'N001', 'Su-30': 'N001 / N011M Bars',
    'Su-30MKI': 'N011M Bars (PESA)', 'Su-33': 'N001', 'Su-34': 'V004 (PESA)', 'Su-35': 'Irbis-E (PESA)',
    'Su-57': 'N036 Byelka (AESA)', 'Super Étendard': 'Agave / Anémone', 'Tu-128': 'Smerch',
    'Tu-142': 'Berkut / Korshun', 'Tu-160': 'Obzor-K', 'Tu-95': 'Obzor-MS',
    'Vought XF8U-3 Crusader III': 'AN/APQ-50', 'Yak-25': 'RP-6 Sokol',
}
SUPERCROISIERE = {n: True for n in (
    'Eurofighter Typhoon Allemand', 'Eurofighter Typhoon Anglais', 'Eurofighter Typhoon Italien',
    'F-22 Raptor', 'YF-22', 'YF-23 Black Widow II', 'Rafale', 'Rafale EH', 'BAC TSR-2', 'F-16XL',
    'F-106 Delta Dart')}
SUPERCROISIERE.update({n: False for n in ('F-35 Lightning II', 'F-35 Lightning II Italien', 'F-35I Adir')})

SOUTE_OUI = {
    'A-26 Invader', 'A-3 Skywarrior', 'A-5 Vigilante', 'AF Guardian', 'AIDC AT-3 Tzu Chung',
    'Avro Canada CF-105 Arrow', 'Avro Lincoln', 'Avro Shackleton', 'Avro Vulcan', 'B-1 Lancer',
    'B-2 Spirit', 'B-21 Raider', 'B-29 Superfortress', 'B-36 Peacemaker', 'B-45 Tornado',
    'B-47 Stratojet', 'B-50 Superfortress', 'B-52 Stratofortress', 'BAC TSR-2', 'Bayraktar Kızılelma',
    'Blackburn Buccaneer', 'Boeing X-45', 'Breguet Alizé', 'Breguet Atlantique', 'Canadair CP-107 Argus',
    'CASA C-101 Aviojet', 'Chengdu J-20', 'English Electric Canberra', 'F-101 Voodoo',
    'F-102 Delta Dagger', 'F-105 Thunderchief', 'F-106 Delta Dart', 'F-111 Aardvark',
    'F-117 Nighthawk', 'F-22 Raptor', 'F-35 Lightning II', 'F-35 Lightning II Italien', 'F-35I Adir',
    'Fairey Gannet', 'FFA P-16', 'General Atomics YFQ-42A Dark Merlin', 'Handley Page Victor',
    'Hawker Siddeley Nimrod', 'Hongdu GJ-11 Sharp Sword', 'Il-28', 'Iliouchine Il-38',
    'Kawasaki P-1', 'Martin B-57 Canberra', 'Martin P4M Mercator', 'Martin P6M SeaMaster',
    'Martin PBM Mariner', 'Martin XB-51', 'Myasishchev M-4', 'Myasishchev M-50', 'MQ-20 Avenger',
    'Nanchang Q-5', 'nEUROn', 'North American AJ Savage', 'P-2 Neptune', 'P-3 Orion', 'P-8 Poseidon',
    'P5M Marlin', 'S-2 Tracker', 'S-3 Viking', 'Shenyang J-35', 'Short Seamew',
    'Sukhoi S-70 Okhotnik', 'TAI Kaan', 'Textron AirLand Scorpion', 'Tu-16', 'Tu-160', 'Tu-22',
    'Tu-22M', 'Tu-95', 'Vautour II', 'Vickers Valiant', 'X-47B', 'XB-70 Valkyrie', 'Xian H-6',
    'XQ-58 Valkyrie', 'Yak-28', 'YF-22', 'YF-23 Black Widow II', 'Su-57',
}
SOUTE_NON = {'B-58 Hustler', 'Tu-128', 'OV-10 Bronco', 'A-1 Skyraider', 'KAI KF-21 Boramae'}
SOUTE_DOUTE = {  # ni oui ni non affichés
    'F-104 Starfighter', 'F-104 Starfighter Allemand', 'Mitsubishi F-104J', 'F-104S Starfighter Italien',
    'English Electric Lightning', 'F-86D Sabre', 'Avro Canada CF-100 Canuck', 'Yak-25',
    'North American F-107', 'HAL AMCA', 'Lockheed Martin X-35', 'MiG 1.44',
}
TYPES_SANS_SOUTE = {'Chasseur', 'Intercepteur', 'Multirôle', 'Appui aérien'}

COLONNES = ('mach_max', 'supercruise', 'ferry_range', 'internal_fuel', 'hardpoints',
            'internal_weapons_bay', 'radar_model')


def sql_val(v):
    if v is None:
        return 'NULL'
    if isinstance(v, bool):
        return 'TRUE' if v else 'FALSE'
    if isinstance(v, (int, float)):
        return repr(round(v, 2)) if isinstance(v, float) else str(v)
    return "'" + str(v).replace("'", "''") + "'"


def main():
    ext = {x['name']: x for x in json.loads((D / 'extrait.json').read_text(encoding='utf-8'))}
    cat = json.loads((D / 'catalogue.json').read_text(encoding='utf-8'))
    final = {}
    for a in cat:
        n = a['name']
        x = ext[n]
        exclue = any(s.startswith('exclue') for s in x['notes'])
        v = {c: None for c in COLONNES}
        if not exclue:
            src = x['valeurs']
            v['mach_max'] = MACH.get(n, src.get('mach_max')) if n in MACH else src.get('mach_max')
            v['ferry_range'] = src.get('ferry_range')
            if v['ferry_range'] and a['max_range'] and v['ferry_range'] <= a['max_range']:
                v['ferry_range'] = None
            v['internal_fuel'] = CARBURANT[n] if n in CARBURANT else src.get('internal_fuel')
            v['hardpoints'] = EMPORT[n] if n in EMPORT else src.get('hardpoints')
            v['radar_model'] = RADAR.get(n)
            v['supercruise'] = SUPERCROISIERE.get(n)
            if n in SOUTE_OUI:
                v['internal_weapons_bay'] = True
            elif n in SOUTE_NON:
                v['internal_weapons_bay'] = False
            elif n not in SOUTE_DOUTE and a['type_name'] in TYPES_SANS_SOUTE:
                v['internal_weapons_bay'] = False
        final[n] = v
    inconnus = (set(RADAR) | set(SOUTE_OUI) | set(SOUTE_NON) | set(SOUTE_DOUTE) | set(SUPERCROISIERE)
                | set(EMPORT) | set(MACH) | set(CARBURANT)) - set(final)
    if inconnus:
        raise SystemExit(f'noms inconnus : {sorted(inconnus)}')
    (D / 'final.json').write_text(json.dumps(final, ensure_ascii=False, indent=1), encoding='utf-8')

    lignes = [
        '-- zz_specs_strate7.sql — strate 7 de la fiche technique (source unique).',
        '--',
        '-- Mach max, supercroisière, distance de convoyage, carburant interne (kg),',
        '-- points d\'emport, soute interne et radar. Valeurs relevées dans la section',
        '-- « Specifications » de l\'article Wikipédia anglais de chaque fiche, puis',
        '-- revues (outillage : tools/lots/specs7_*.py ; revue dans .lots/specs7, hors git). Carburant donné',
        '-- en volume : converti à 0,8 kg/L (kérosène) ou 0,72 kg/L (essence avion).',
        '--',
        '-- Une ligne par fiche, les sept colonnes à chaque fois (NULL = non établi) :',
        '-- ce fichier fait foi, une modification faite ailleurs est écrasée au rejeu.',
        '-- Chargé APRÈS les fiches (préfixe zz), sur une installation neuve comme sur',
        '-- le chemin de migration. Rejouable : chaque UPDATE porte une garde IS',
        '-- DISTINCT FROM, un rejeu ne modifie aucune ligne (updated_at intact).',
        '-- Généré par tools/lots/specs7_build.py : corriger la revue, pas ce fichier.',
        '',
        'BEGIN;',
        '',
    ]
    compte = 0
    for n in sorted(final):
        v = final[n]
        # Toutes les colonnes, NULL compris : le fichier fait foi, une valeur
        # retirée à la revue est effacée au rejeu.
        cols = list(COLONNES)
        sets = ', '.join(f'{c} = {sql_val(v[c])}' for c in cols)
        garde = ' OR '.join(f'{c} IS DISTINCT FROM {sql_val(v[c])}' for c in cols)
        nom = n.replace("'", "''")
        lignes.append(f"UPDATE airplanes SET {sets}\n  WHERE name = '{nom}' AND ({garde});")
        compte += 1
    lignes += ['', 'COMMIT;', '']
    SQL.write_text('\n'.join(lignes), encoding='utf-8')
    print('fiches écrites :', compte, '— renseignées :', sum(1 for v in final.values() if any(x is not None for x in v.values())))
    for c in COLONNES:
        print(f'  {c:22}', sum(1 for v in final.values() if v[c] is not None))


if __name__ == '__main__':
    main()
