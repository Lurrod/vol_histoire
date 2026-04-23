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
    'Aermacchi MB-339',
    'Aermacchi MB-339',
    'Aermacchi MB-339A/CD (Aeronautica Militare)',
    'Aermacchi MB-339A/CD (Italian Air Force)',
    'Avion d''entraînement avancé biplace et de voltige aérienne des Frecce Tricolori',
    'Advanced two-seat trainer and aerobatic aircraft of the Frecce Tricolori',
    '/assets/airplanes/aermacchi-mb-339.jpg',
    'L''Aermacchi MB-339 est un avion d''entraînement avancé à réaction et d''attaque légère biplace en tandem développé par Aermacchi (devenu Leonardo) à partir de 1975. Successeur direct du MB-326 dont il reprend la voilure et une partie du fuselage, il se distingue par un nez redessiné pour améliorer la visibilité avant et un cockpit arrière surélevé type "step-up" offrant une vue dégagée à l''instructeur. Propulsé par un unique réacteur Rolls-Royce Viper 632-43 (variantes A et AM) ou 680-43 (variantes CD et FD), il atteint 898 km/h et dispose de six points d''emport pour des missions d''appui-feu. L''Aeronautica Militare l''a adopté en 1979 pour former ses pilotes de chasse au sein du 61° Stormo de Lecce-Galatina, après la phase initiale sur SF-260 et avant le passage sur Eurofighter ou F-35. Le MB-339PAN, dérivé spécifique livré à la **Pattuglia Acrobatica Nazionale** (Frecce Tricolori), équipe cette patrouille de voltige mondialement réputée depuis 1982. 230 exemplaires ont été produits entre 1976 et 2017 pour l''Italie, l''Argentine, le Pérou, la Malaisie, le Nigeria, les Émirats arabes unis, le Ghana, l''Érythrée et la Nouvelle-Zélande. Son successeur, le Leonardo M-345, a commencé à le remplacer au 61° Stormo en 2022.',
    'The Aermacchi MB-339 is an advanced jet trainer and light attack tandem two-seater developed by Aermacchi (now Leonardo) from 1975. A direct successor of the MB-326 from which it retains the wing and part of the fuselage, it stands out thanks to a redesigned nose for improved forward visibility and a raised "step-up" rear cockpit giving the instructor a clear view. Powered by a single Rolls-Royce Viper 632-43 (A and AM variants) or 680-43 (CD and FD variants) turbojet, it reaches 898 km/h and has six hardpoints for light attack missions. The Aeronautica Militare adopted it in 1979 to train its fighter pilots within the 61° Stormo at Lecce-Galatina, after initial training on SF-260 and before transition to Eurofighter or F-35. The MB-339PAN, a dedicated variant delivered to the **Pattuglia Acrobatica Nazionale** (Frecce Tricolori), has equipped this world-renowned aerobatic team since 1982. 230 airframes were produced between 1976 and 2017 for Italy, Argentina, Peru, Malaysia, Nigeria, the United Arab Emirates, Ghana, Eritrea and New Zealand. Its successor, the Leonardo M-345, began replacing it at 61° Stormo in 2022.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1975-03-01',
    '1976-08-12',
    '1979-08-01',
    898.0,
    1760.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Actif',
    'Active',
    3125.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM armement WHERE name = 'Mk 83'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Aermacchi MB-339'), (SELECT id FROM missions WHERE name = 'Reconnaissance armée'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 10.97, wingspan = 11.22, height = 3.99, wing_area = 19.30,
  empty_weight = 3125, mtow = 6350, service_ceiling = 14630, climb_rate = 33,
  combat_radius = 370, crew = 2, g_limit_pos = 8.0, g_limit_neg = -4.0,
  engine_name = 'Rolls-Royce Viper 632-43', engine_count = 1,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 17.8, thrust_wet = NULL,
  production_start = 1976, production_end = 2017, units_built = 230,
  operators_count = 9,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Aermacchi_MB-339',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Aermacchi_MB-339'
WHERE name = 'Aermacchi MB-339';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 12000000, unit_cost_year = 2000,
  manufacturer_page = 'https://www.leonardo.com/',
  variants    = E'- **MB-339A** : version initiale, Viper 632, entraînement avancé\n- **MB-339PAN** : variante Frecce Tricolori (générateur de fumée, réservoir supplémentaire)\n- **MB-339CD** : avionique numérique, Viper 680, cockpit tout écran, 30 pour l''Italie\n- **MB-339CM / FD** : export Malaisie, Nouvelle-Zélande',
  variants_en = E'- **MB-339A** : initial variant, Viper 632, advanced training\n- **MB-339PAN** : Frecce Tricolori variant (smoke generator, extra tank)\n- **MB-339CD** : digital avionics, Viper 680, glass cockpit, 30 for Italy\n- **MB-339CM / FD** : export Malaysia, New Zealand'
WHERE name = 'Aermacchi MB-339';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nAermacchi lance le développement du MB-339 en **1975** comme évolution du MB-326 pour remplacer les T-33 et G.91T de l''Aeronautica Militare. Premier vol le **12 août 1976**. Mise en service au 61° Stormo de Lecce-Galatina en **1979**.\n\n## Carrière opérationnelle\n**230 exemplaires produits** en 40 ans. Cœur de la formation des pilotes de chasse italiens pendant 45 ans. Engagé en combat réel par l''Argentine lors de la **Guerre des Malouines 1982** (attaque du HMS Argonaut, destruction du RFA Sir Galahad) et par l''Érythrée lors de la guerre contre l''Éthiopie. Les **Frecce Tricolori** (Pattuglia Acrobatica Nazionale) volent sur MB-339PAN depuis **1982** et reste la plus ancienne patrouille acrobatique à 10 avions encore en activité.\n\n## Héritage\nRemplacé progressivement depuis **2022** par le **Leonardo M-345** (successeur moderne du MB-339) au 61° Stormo. Les Frecce Tricolori prévoient la transition vers M-345 pour 2025-2027. Un monument culturel italien au même titre que la Ferrari ou l''Alfa Romeo — indissociable de l''image du tricolore italien au dessus du monde entier.',
  description_en = E'## Genesis\nAermacchi launches the MB-339 in **1975** as an evolution of the MB-326 to replace the Aeronautica Militare''s T-33s and G.91Ts. First flight on **12 August 1976**. Service entry at 61° Stormo Lecce-Galatina in **1979**.\n\n## Operational career\n**230 airframes built** over 40 years. Core of Italian fighter pilot training for 45 years. Engaged in real combat by Argentina during the **Falklands War 1982** (HMS Argonaut attack, RFA Sir Galahad destruction) and by Eritrea during the war against Ethiopia. The **Frecce Tricolori** (Pattuglia Acrobatica Nazionale) have flown MB-339PAN since **1982** and remain the oldest 10-aircraft aerobatic team still active.\n\n## Legacy\nProgressively replaced since **2022** by the **Leonardo M-345** (modern MB-339 successor) at 61° Stormo. The Frecce Tricolori plan their transition to M-345 for 2025-2027. An Italian cultural monument on par with Ferrari or Alfa Romeo — inseparable from the image of the Italian tricolour over the whole world.'
WHERE name = 'Aermacchi MB-339';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=KvFYYvB5PPQ'
WHERE name = 'Aermacchi MB-339';
