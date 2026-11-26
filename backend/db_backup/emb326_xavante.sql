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
    'Embraer EMB-326 Xavante',
    'Embraer EMB-326 Xavante',
    'Embraer EMB-326GB Xavante (Força Aérea Brasileira)',
    'Embraer EMB-326GB Xavante (Brazilian Air Force)',
    'Version brésilienne sous licence de l''Aermacchi MB-326 italien',
    'Licence-built Brazilian version of the Italian Aermacchi MB-326',
    '/assets/airplanes/emb-326-xavante.jpg',
    'L''EMB-326 Xavante est la version brésilienne de l''Aermacchi MB-326 construite sous licence par Embraer entre 1971 et 1982 (182 appareils livrés à la Força Aérea Brasileira, Togo et Paraguay). Ce biplace d''entraînement et d''attaque légère a constitué le pilier de la formation de chasse brésilienne pendant plus de 30 ans, avant sa retraite en 2010. Il a permis à Embraer de maîtriser la production industrielle d''avions militaires jet, ouvrant la voie aux programmes AMX, Tucano et ultérieurs. Le nom Xavante fait référence à une tribu amérindienne du Mato Grosso.',
    'The EMB-326 Xavante is the Brazilian version of the Aermacchi MB-326 built under licence by Embraer between 1971 and 1982 (182 aircraft delivered to the Brazilian Air Force, Togo and Paraguay). This two-seat trainer and light attack aircraft was the pillar of Brazilian fighter training for over 30 years, before its retirement in 2010. It enabled Embraer to master the industrial production of military jet aircraft, paving the way for the AMX, Tucano and later programmes. The Xavante name refers to an Amerindian tribe from Mato Grosso.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    '1969-01-01',
    '1971-08-01',
    '1971-09-01',
    867.0,
    1850.0,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Viper')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM armement WHERE name = 'Mk 82')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM armement WHERE name = 'SNEB 68 mm'));

-- Insertion des guerres

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Embraer EMB-326 Xavante'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 10.63, wingspan = 10.85, height = 3.72, wing_area = 19.35,
  empty_weight = 2685, mtow = 5897, service_ceiling = 14325, climb_rate = 30,
  combat_radius = 370, crew = 2, g_limit_pos = 8.0, g_limit_neg = -4.0,
  engine_name = 'Rolls-Royce Viper Mk 20 Mk2 (licence Alfa Romeo/Piaggio)', engine_count = 1,
  engine_type = 'Turbojet', engine_type_en = 'Turbojet',
  thrust_dry = 11.1, thrust_wet = NULL,
  production_start = 1971, production_end = 1982, units_built = 182,
  operators_count = 3,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Aermacchi_MB-326',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Embraer_EMB-326_Xavante'
WHERE name = 'Embraer EMB-326 Xavante';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 1800000, unit_cost_year = 1975,
  manufacturer_page = 'https://www.embraer.com/',
  variants    = E'- **EMB-326GB Xavante** : version brésilienne sous licence Aermacchi MB-326GB (182 appareils)\n- Force Aérienne Brésilienne (FAB) : désignation **AT-26**, ~166 appareils livrés\n- Export : 9 Togo + 8 Paraguay\n- Servi de modèle industriel à Embraer pour les programmes Tucano et AMX',
  variants_en = E'- **EMB-326GB Xavante** : Brazilian Aermacchi MB-326GB licence version (182 aircraft)\n- Brazilian Air Force (FAB): **AT-26** designation, ~166 aircraft delivered\n- Export: 9 Togo + 8 Paraguay\n- Served as Embraer''s industrial model for the Tucano and AMX programmes'
WHERE name = 'Embraer EMB-326 Xavante';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nÀ la fin des années 1960, la **Força Aérea Brasileira** (FAB) cherche un avion-école à réaction capable aussi d''attaque légère, et le gouvernement veut donner du travail à **Embraer**, entreprise publique fondée en 1969. Le choix se porte sur l''**Aermacchi MB-326** italien, à construire sous licence. Le contrat de licence entre en vigueur en 1970 et, le 29 mai, le ministère de l''Aéronautique commande 112 exemplaires. L''avion prend le nom de **Xavante**, un peuple amérindien du Mato Grosso, et la désignation militaire **AT-26**.\n\n## Conception\nLe Xavante reprend le MB-326GB : un biplace en tandem à aile droite, mû par un unique turboréacteur **Rolls-Royce Viper**, simple et docile, qui forme les pilotes et emporte sous ses ailes roquettes et bombes légères. Pour Embraer, c''est le troisième modèle mis en production et le premier avion à réaction fabriqué au Brésil. Le 7 septembre 1971, jour de la fête de l''indépendance, le premier exemplaire de **São José dos Campos** est présenté au public ; les trois premiers sont remis à la FAB le lendemain.\n\n## Carrière opérationnelle\nEmbraer construit 182 Xavante entre 1971 et 1982 ou 1983 selon les sources : 167 pour la FAB d''après le constructeur (166 selon *Flight International*), neuf pour le Paraguay et six pour le Togo. Pendant près de quatre décennies, l''AT-26 forme les pilotes de chasse brésiliens et arme des escadrons d''attaque légère ; certains deviennent des avions de reconnaissance RT-26. Après la guerre des Malouines, onze appareils de la FAB sont cédés à l''aéronavale argentine pour combler ses pertes.\n\nÀ partir de 1998, l''**AMX** et le **Super Tucano** reprennent peu à peu ses missions, et en 2005 la FAB achète des Impala sud-africains d''occasion pour combler le manque d''avions-écoles. Le dernier escadron, le 1er/4e GAv « Pacau », passé de Natal à Manaus en novembre 2010, rend ses avions début décembre : la FAB retire officiellement la flotte le 2 décembre 2010, après près de 39 ans de service. Trois exemplaires restent encore quelques années au centre d''essais en vol.\n\n## Place dans l''histoire\nLe Xavante n''est pas une conception brésilienne, mais il a appris à Embraer à produire en série un avion militaire à réaction, de l''outillage à la relation avec l''armée de l''air. Cette école prépare l''**AMX**, mené avec l''Italie, et la famille **Tucano**.',
  description_en = E'## Genesis\nIn the late 1960s the **Força Aérea Brasileira** (FAB) needed a jet trainer that could also fly light attack, and the government wanted work for **Embraer**, a state company founded in 1969. The choice fell on the Italian **Aermacchi MB-326**, to be built under licence. The licence came into force in 1970 and on 29 May the Air Ministry ordered 112 aircraft. The type was named **Xavante**, after an Amerindian people of Mato Grosso, and designated **AT-26**.\n\n## Design\nThe Xavante was the MB-326GB: a tandem two-seater with a straight wing and a single **Rolls-Royce Viper** turbojet, simple and forgiving, able to train pilots and carry rockets and light bombs under its wings. For Embraer it was the third model put into production and the first jet built in Brazil. On 7 September 1971, Independence Day, the first aircraft from **São José dos Campos** was shown to the public; the first three were handed to the FAB the next day.\n\n## Operational career\nEmbraer built 182 Xavantes between 1971 and 1982 or 1983, depending on the source: 167 for the FAB according to the manufacturer (166 according to *Flight International*), nine for Paraguay and six for Togo. For almost four decades the AT-26 trained Brazil''s fighter pilots and equipped light attack squadrons; some became RT-26 reconnaissance aircraft. After the Falklands War, eleven FAB aircraft were transferred to the Argentine naval air arm to make good its losses.\n\nFrom 1998 the **AMX** and the **Super Tucano** gradually took over its missions, and in 2005 the FAB bought second-hand South African Impalas to cover a shortage of jet trainers. The last squadron, 1st/4th GAv "Pacau", which had moved from Natal to Manaus in November 2010, gave up its aircraft in early December: the FAB formally retired the fleet on 2 December 2010, after nearly 39 years of service. Three aircraft stayed on for a few years with the flight test centre.\n\n## Place in history\nThe Xavante was not a Brazilian design, but it taught Embraer how to mass-produce a military jet, from tooling to working with the air force. That apprenticeship led to the **AMX**, developed with Italy, and to the **Tucano** family.'
WHERE name = 'Embraer EMB-326 Xavante';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Embraer EMB-326 Xavante';
