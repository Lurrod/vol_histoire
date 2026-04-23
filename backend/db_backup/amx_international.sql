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
    status_en,
    weight
) VALUES (
    'AMX International AMX',
    'AMX International AMX',
    'AMX International AMX (Aeronautica Militare)',
    'AMX International AMX (Italian Air Force)',
    'Avion d''appui tactique léger italo-brésilien de 4e génération',
    '4th-generation light tactical support aircraft jointly developed by Italy and Brazil',
    '/assets/airplanes/amx-International-amx.jpg',
    'L''AMX est un avion d''attaque tactique subsonique monoréacteur développé conjointement par Aeritalia, Aermacchi (tous deux devenus Leonardo) et Embraer à partir de 1977 pour remplacer les G.91 et F-104G italiens et les AT-26 brésiliens sur les missions d''appui-feu et de reconnaissance tactique. Le programme baptisé "AMX" (Aeritalia-Macchi-Experimental) voit la création du consortium AMX International en 1980, avec une répartition industrielle de 54 % pour l''Italie et 46 % pour le Brésil, chaque pays assemblant ses propres cellules. Propulsé par un unique Rolls-Royce Spey Mk.807 construit sous licence en Italie par FiatAvio, l''AMX offre une cellule simple, robuste, bas coût d''exploitation et un système de navigation/attaque numérique avancé pour son époque (radar FIAR Pointer, nav-attaque INS + GPS, pod Litening). Il emporte deux canons M61 Vulcan 20 mm dans la version italienne (un seul DEFA 554 30 mm dans la version brésilienne) et jusqu''à 3 800 kg d''armement air-sol sur cinq points d''emport. L''Aeronautica Militare a reçu 110 monoplaces AMX et 26 biplaces AMX-T affectés aux 32° Stormo (Amendola), 51° Stormo (Istrana) et 2° Stormo (Rivolto). Engagé en Guerre du Kosovo 1999 (première opération de l''AMX), en Guerre civile libyenne 2011 et en Afghanistan 2009-2014 (mission ISAF), il est progressivement retiré depuis 2019 au profit du F-35A.',
    'The AMX is a subsonic single-engine tactical attack aircraft jointly developed by Aeritalia, Aermacchi (both now Leonardo) and Embraer from 1977 to replace Italian G.91 and F-104G aircraft and Brazilian AT-26s on close air support and tactical reconnaissance missions. The programme, dubbed "AMX" (Aeritalia-Macchi-Experimental), led to the creation of the AMX International consortium in 1980, with industrial shares split 54% for Italy and 46% for Brazil, each country assembling its own airframes. Powered by a single Rolls-Royce Spey Mk.807 license-built in Italy by FiatAvio, the AMX delivers a simple, robust, low-operating-cost airframe and an advanced-for-its-era digital navigation/attack suite (FIAR Pointer radar, INS + GPS nav-attack, Litening pod). It carries two 20 mm M61 Vulcan cannons in the Italian variant (a single 30 mm DEFA 554 in the Brazilian one) and up to 3,800 kg of air-to-ground armament on five hardpoints. The Aeronautica Militare received 110 single-seat AMX and 26 AMX-T two-seaters assigned to 32° Stormo (Amendola), 51° Stormo (Istrana) and 2° Stormo (Rivolto). Engaged in Kosovo War 1999 (first AMX operation), Libyan Civil War 2011 and Afghanistan 2009-2014 (ISAF mission), it has been progressively retired since 2019 in favour of the F-35A.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1977-04-01',
    '1984-05-15',
    '1989-05-01',
    914.0,
    2800.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired',
    6700.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM tech WHERE name = 'Pod désignateur laser')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM tech WHERE name = 'Système de contrôle de vol numérique'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM armement WHERE name = 'GBU-16 Paveway II')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM armement WHERE name = 'Mk 83'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée')),
((SELECT id FROM airplanes WHERE name = 'AMX International AMX'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 13.23, wingspan = 8.87, height = 4.55, wing_area = 21.00,
  empty_weight = 6700, mtow = 13000, service_ceiling = 13000, climb_rate = 52,
  combat_radius = 550, crew = 1, g_limit_pos = 8.0, g_limit_neg = -3.0,
  engine_name = 'Rolls-Royce Spey Mk.807', engine_count = 1,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 49.1, thrust_wet = NULL,
  production_start = 1988, production_end = 1999, units_built = 200,
  operators_count = 2,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/AMX_International_AMX',
  wikipedia_en = 'https://en.wikipedia.org/wiki/AMX_International_AMX'
WHERE name = 'AMX International AMX';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 20000000, unit_cost_year = 1990,
  manufacturer_page = 'https://www.leonardo.com/',
  variants    = E'- **AMX A-11 Ghibli** (Italie) : monoplace d''attaque, 2 canons M61 Vulcan\n- **AMX A-1** (Brésil) : variante brésilienne, 1 canon DEFA 554\n- **AMX-T / A-1B** : biplace d''entraînement opérationnel, 26 exemplaires AMI\n- **AMX ACOL** : upgrade avionique complet 2005-2010 (GPS, IFF Mode 5, Link-16, glass cockpit)',
  variants_en = E'- **AMX A-11 Ghibli** (Italy) : single-seat strike, 2 M61 Vulcan cannons\n- **AMX A-1** (Brazil) : Brazilian variant, 1 DEFA 554 cannon\n- **AMX-T / A-1B** : two-seat operational trainer, 26 airframes for AMI\n- **AMX ACOL** : full avionics upgrade 2005-2010 (GPS, IFF Mode 5, Link-16, glass cockpit)'
WHERE name = 'AMX International AMX';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nEn 1977, l''Italie et le Brésil lancent conjointement le programme **AMX** (Aeritalia-Macchi-Experimental) pour un **chasseur-bombardier léger à bas coût**. Consortium AMX International créé en **1980** : Aeritalia 46 %, Aermacchi 24 %, Embraer 30 %. Premier vol en **1984** à Turin (le prototype brésilien s''écrase au 5e vol, tuant son pilote). Mise en service italien au 51° Stormo en **1989**.\n\n## Carrière opérationnelle\n**200 exemplaires produits** (136 IT, 56 BR). Premier combat italien : **Kosovo 1999** (opération Allied Force, frappes GBU-12, première mise en œuvre opérationnelle de la chasse italienne depuis 1945). **Afghanistan 2009-2014** (ISAF, détachement AMX-ACOL à Mazar-e-Sharif et Herat, plus de 3 000 heures de vol, capteurs Reccelite). **Libye 2011** (Unified Protector). Retiré progressivement depuis **2019** de l''Aeronautica Militare.\n\n## Héritage\n**Premier avion de combat conjointement développé** entre l''Europe et l''Amérique du Sud — un modèle de coopération industrielle Sud-Sud. Remplacé par le **F-35A** en Italie, et par le **Gripen F-39** au Brésil. Retrait total italien attendu fin 2025. Un succès industriel modeste mais opérationnellement solide, qui aura formé une génération d''équipages à l''attaque précise par tous temps.',
  description_en = E'## Genesis\nIn 1977, Italy and Brazil jointly launch the **AMX** programme (Aeritalia-Macchi-Experimental) for a **low-cost light fighter-bomber**. AMX International consortium created in **1980**: Aeritalia 46%, Aermacchi 24%, Embraer 30%. First flight in **1984** at Turin (the Brazilian prototype crashed on its 5th flight, killing its pilot). Italian service entry at 51° Stormo in **1989**.\n\n## Operational career\n**200 airframes built** (136 IT, 56 BR). First Italian combat: **Kosovo 1999** (Operation Allied Force, GBU-12 strikes, first operational employment of the Italian fighter fleet since 1945). **Afghanistan 2009-2014** (ISAF, AMX-ACOL detachment at Mazar-e-Sharif and Herat, over 3,000 flight hours, Reccelite sensors). **Libya 2011** (Unified Protector). Progressively retired since **2019** from the Aeronautica Militare.\n\n## Legacy\n**First combat aircraft jointly developed** between Europe and South America — a model of South-South industrial cooperation. Replaced by the **F-35A** in Italy, and by the **Gripen F-39** in Brazil. Full Italian retirement expected by end of 2025. A modest industrial success but operationally solid, having trained a generation of crews in precise all-weather strike.'
WHERE name = 'AMX International AMX';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=qJ1eD1b6ygE'
WHERE name = 'AMX International AMX';
