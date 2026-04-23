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
    'F-104S Starfighter Italien',
    'Italian F-104S Starfighter',
    'Aeritalia F-104S ASA-M Starfighter (Aeronautica Militare)',
    'Aeritalia F-104S ASA-M Starfighter (Aeronautica Militare)',
    'Intercepteur supersonique de 2e génération produit sous licence par Aeritalia',
    '2nd-generation supersonic interceptor license-built by Aeritalia',
    '/assets/airplanes/f104-italien.jpg',
    'Le F-104S est la version italienne la plus avancée du Starfighter, développée conjointement par Lockheed et Aeritalia pour l''Aeronautica Militare et Turkish Air Force. Produit entièrement sous licence à Turin par Aeritalia entre 1969 et 1979, il se distingue du F-104G allemand par son radar NASARR R21G/M1 doté d''une capacité tout-temps améliorée et surtout par son intégration du missile semi-actif AIM-7 Sparrow, une première pour le Starfighter. La cellule est renforcée pour accepter une MTOW portée à 14 060 kg et neuf points d''emport, et le réacteur General Electric J79-GE-19 offre une poussée supérieure. L''Italie a ensuite modernisé la flotte via les programmes ASA (Aggiornamento Sistema d''Arma, 1986) puis ASA-M (2000), prolongeant la carrière jusqu''au retrait final en mai 2004. Pendant 35 ans, le F-104S a assuré la police du ciel italien au sein des 6°, 9°, 36°, 37°, 51° et 53° Stormo et servi de monture pour la transition vers l''Eurofighter Typhoon. 246 exemplaires ont été construits, faisant de l''Italie le plus gros opérateur européen du Starfighter.',
    'The F-104S is the most advanced Italian variant of the Starfighter, jointly developed by Lockheed and Aeritalia for the Aeronautica Militare and Turkish Air Force. Fully license-built in Turin by Aeritalia between 1969 and 1979, it differs from the German F-104G through its NASARR R21G/M1 radar with improved all-weather capability and notably by its integration of the semi-active AIM-7 Sparrow missile — a Starfighter first. The airframe is reinforced to accept an MTOW raised to 14,060 kg and nine hardpoints, and the General Electric J79-GE-19 engine delivers higher thrust. Italy subsequently upgraded the fleet through the ASA (Aggiornamento Sistema d''Arma, 1986) and ASA-M (2000) programs, extending service life until final retirement in May 2004. For 35 years, the F-104S provided Italian air policing within the 6°, 9°, 36°, 37°, 51° and 53° Stormo and served as the bridging aircraft to the Eurofighter Typhoon. 246 airframes were built, making Italy the largest European Starfighter operator.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1965-06-01',
    '1968-12-22',
    '1969-12-01',
    2330.0,
    2920.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired',
    6760.0
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM tech WHERE name = 'Siège incliné')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-104S Starfighter Italien'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 16.69, wingspan = 6.63, height = 4.11, wing_area = 18.22,
  empty_weight = 6760, mtow = 14060, service_ceiling = 17680, climb_rate = 254,
  combat_radius = 1247, crew = 1, g_limit_pos = 7.33, g_limit_neg = -3.0,
  engine_name = 'General Electric J79-GE-19', engine_count = 1,
  engine_type = 'Turbojet avec postcombustion', engine_type_en = 'Afterburning turbojet',
  thrust_dry = 52.8, thrust_wet = 79.6,
  production_start = 1969, production_end = 1979, units_built = 246,
  operators_count = 2,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Aeritalia_F-104S_Starfighter',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Aeritalia_F-104S_Starfighter'
WHERE name = 'F-104S Starfighter Italien';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 6700000, unit_cost_year = 1975,
  manufacturer_page = 'https://www.leonardo.com/',
  variants    = E'- **F-104S** : version d''origine, Sparrow et NASARR R21G, 1969-1979\n- **F-104S ASA** : upgrade 1986, Aspide, nouveau radar FIAR Setter-M\n- **F-104S ASA-M** : upgrade 2000, avionique numérique, GPS, prolongement jusqu''à 2004',
  variants_en = E'- **F-104S** : original variant, Sparrow and NASARR R21G, 1969-1979\n- **F-104S ASA** : 1986 upgrade, Aspide missile, new FIAR Setter-M radar\n- **F-104S ASA-M** : 2000 upgrade, digital avionics, GPS, service life extended to 2004'
WHERE name = 'F-104S Starfighter Italien';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nEn 1960, l''Italie choisit le **F-104G** de Lockheed pour remplacer ses F-86K et G.91 sur les missions d''interception et de frappe. Aeritalia (alors Fiat Aviazione) obtient la licence de production à Turin-Caselle. Les besoins italiens poussent rapidement vers une version améliorée : **le F-104S**, co-développé avec Lockheed à partir de 1965, capable de tirer le missile radar semi-actif AIM-7 Sparrow.\n\n## Carrière opérationnelle\n246 exemplaires produits entre 1969 et 1979 (205 pour l''Italie, 40 pour la Turquie, 1 prototype). L''Italie équipe 7 stormi d''interception et de chasse-bombardement. Modernisations successives : **ASA** (1986, missile Aspide), **ASA-M** (2000, avionique numérique, GPS, capacité Sidewinder AIM-9L). Le F-104S assure la **police du ciel italien** pendant 35 ans sans jamais tirer un missile en colère.\n\n## Héritage\n**Plus gros opérateur européen** du Starfighter. Retrait final en **mai 2004** au profit de l''Eurofighter Typhoon et du F-16 ADF (en location transitoire 2003-2010). Les derniers Starfighter en service au monde. Un chapitre unique : Aeritalia démontre qu''un industriel européen peut dépasser le design d''origine de son licencieur américain.',
  description_en = E'## Genesis\nIn 1960, Italy selects the **F-104G** from Lockheed to replace its F-86K and G.91 on interception and strike missions. Aeritalia (then Fiat Aviazione) secures the production license in Turin-Caselle. Italian requirements quickly push towards an improved variant: **the F-104S**, co-developed with Lockheed from 1965, capable of firing the semi-active radar AIM-7 Sparrow missile.\n\n## Operational career\n246 airframes built between 1969 and 1979 (205 for Italy, 40 for Turkey, 1 prototype). Italy equips 7 stormi of interception and fighter-bomber duties. Successive upgrades: **ASA** (1986, Aspide missile), **ASA-M** (2000, digital avionics, GPS, AIM-9L Sidewinder capability). The F-104S handles **Italian air policing** for 35 years without ever firing a missile in anger.\n\n## Legacy\n**Largest European Starfighter operator**. Final retirement in **May 2004** in favour of the Eurofighter Typhoon and transitional F-16 ADF leases (2003-2010). The last Starfighters in service worldwide. A unique chapter: Aeritalia proves a European manufacturer can surpass its American licensor''s original design.'
WHERE name = 'F-104S Starfighter Italien';

-- [auto:011] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET youtube_showcase = 'https://www.youtube.com/watch?v=TJbWMSTOnlU'
WHERE name = 'F-104S Starfighter Italien';
