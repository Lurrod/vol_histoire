-- Saab 91 Safir
--
-- Photo : Saab 91B-2 Safir ‘333’ (LN-SAP) (42502967050).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Saab_91B-2_Safir_%E2%80%98333%E2%80%99_(LN-SAP)_(42502967050).jpg

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
    'Saab 91 Safir',
    'Saab 91 Safir',
    'Saab 91 Safir',
    'Saab 91 Safir',
    'Monomoteur d''école suédois tout métal, héritier du Bücker Bestmann, vendu à six forces aériennes',
    'All-metal Swedish basic trainer, heir to the Bücker Bestmann, sold to six air forces',
    '/assets/airplanes/saab-91-safir.jpg',
    E'## Genèse\nEn 1944, **Saab** anticipe la fin de la guerre et la chute des commandes militaires. L''entreprise lance trois projets civils numérotés à la suite : l''avion de ligne **Saab 90 Scandia**, l''avion léger **Saab 91 Safir** et une voiture, la **Saab 92**. Le Safir, « saphir » en suédois, est confié à **Anders J. Andersson**, ancien ingénieur de Bücker, qui reprend les idées de son **Bü 181 Bestmann** tout en bois. Retardé par les travaux militaires urgents et des grèves chez les fournisseurs, le prototype vole le 20 novembre 1945.\n\n## Conception\nLe Safir est un monoplan à aile basse construit en métal, seules ses gouvernes étant entoilées, avec un train tricycle rentrant et des doubles commandes. Le 91A, à trois places, reçoit un **de Havilland Gipsy Major** de 145 ch, jugé trop faible par les militaires : le **91B**, qui vole le 18 janvier 1949, passe à un Lycoming six cylindres de 190 ch. Le **91C** de 1953 range le carburant dans les ailes pour libérer une quatrième place, et le **91D** l''allège avec un Lycoming quatre cylindres à plat. Le premier prototype sert aussi de banc d''essai : équipé d''une aile en flèche réduite, il étudie à basse vitesse la voilure du chasseur **Saab 29 Tunnan**, puis celle du **Saab 32 Lansen**.\n\n## Carrière opérationnelle\nLes ventes démarrent lentement, face aux avions d''école militaires bradés après la guerre. Mais en 1951 la Suède commande 74 Safir pour remplacer ses Bestmann ; Saab étant occupé par les J 29, la production passe au néerlandais **De Schelde**, à Dordrecht, qui en assemble 120. Les forces aériennes de Suède, de Norvège, de Finlande, d''Autriche, de Tunisie et d''Éthiopie l''emploient comme avion d''école ; des compagnies comme Air France et Lufthansa en achètent aussi. En Suède, le **Bulldog** le remplace à l''école en 1971, mais il vole encore en liaison en 1994 ; l''Autriche le garde jusqu''en 1992.\n\n## Place dans l''histoire\nProduit jusqu''en 1966 à 323 exemplaires, le Safir est l''un des tout premiers avions d''école modernes de l''après-guerre, avec son train tricycle et sa cabine fermée. Il fait le lien entre la tradition Bücker et l''aviation légère métallique des années 1950. Sa carrière de banc d''essai rappelle aussi qu''un petit avion d''école a aidé Saab à mettre au point ses premiers chasseurs à réaction.',
    E'## Genesis\nIn 1944 **Saab** anticipated the end of the war and the fall in military orders. The company launched three civil projects numbered in sequence: the **Saab 90 Scandia** airliner, the **Saab 91 Safir** light aircraft and a car, the **Saab 92**. The Safir, Swedish for sapphire, was entrusted to **Anders J. Andersson**, a former Bücker engineer, who reused the ideas of his all-wooden **Bü 181 Bestmann**. Delayed by urgent military work and strikes at suppliers, the prototype flew on 20 November 1945.\n\n## Design\nThe Safir was a low-wing monoplane of metal construction, with only its control surfaces fabric-covered, a retractable tricycle undercarriage and dual controls. The three-seat 91A had a 145 hp **de Havilland Gipsy Major**, judged underpowered by military customers: the **91B**, which flew on 18 January 1949, switched to a 190 hp six-cylinder Lycoming. The 1953 **91C** moved the fuel into the wings to make room for a fourth seat, and the **91D** lightened it with a four-cylinder flat Lycoming. The first prototype also served as a testbed: fitted with a scaled-down swept wing, it studied at low speed the wing of the **Saab 29 Tunnan** fighter, then that of the **Saab 32 Lansen**.\n\n## Operational career\nSales started slowly, against the cheap ex-military trainers sold off after the war. But in 1951 Sweden ordered 74 Safirs to replace its Bestmanns; with Saab busy on the J 29, production moved to **De Schelde** of Dordrecht in the Netherlands, which assembled 120. The air forces of Sweden, Norway, Finland, Austria, Tunisia and Ethiopia used it as a trainer; airlines such as Air France and Lufthansa also bought it. In Sweden the **Bulldog** replaced it as a trainer in 1971, but it was still flying as a liaison aircraft in 1994; Austria kept it until 1992.\n\n## Place in history\nBuilt until 1966 to 323 aircraft, the Safir was one of the very first modern post-war trainers, with its tricycle undercarriage and enclosed cabin. It bridged the Bücker tradition and the all-metal light aviation of the 1950s. Its testbed career is also a reminder that a small trainer helped Saab develop its first jet fighters.',
    (SELECT id FROM countries WHERE code = 'SWE'),
    '1944-01-01',
    '1945-11-20',
    '1947-01-01',
    265,
    960,
    (SELECT id FROM manufacturer WHERE code = 'SAAB'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saab 91 Safir'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'Saab 91 Safir'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.8,
  wingspan          = 10.6,
  height            = 2.2,
  wing_area         = 13.6,
  empty_weight      = 580,
  mtow              = 1075,
  service_ceiling   = 4600,
  climb_rate        = 5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'de Havilland Gipsy Major 10 (145 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1966,
  units_built       = 323,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 7,
  variants          = E'- **91A** : version initiale à trois places, Gipsy Major 10 de 145 ch, 48 exemplaires (Tp 91 en Suède)\n- **91B** : Lycoming O-435 de 190 ch, 106 construits par De Schelde (Sk 50B en Suède)\n- **91B-2** : version pour la Norvège à hélice à pas variable, 25 exemplaires\n- **91C** : quatre places, réservoirs dans les ailes (Sk 50C en Suède)\n- **91D** : quatre places allégé, Lycoming O-360 de 180 ch, 99 exemplaires\n- **Saab 201 et 202** : premier prototype doté des ailes d''essai du Saab 29 puis du Saab 32',
  variants_en       = E'- **91A**: initial three-seat version, 145 hp Gipsy Major 10, 48 built (Tp 91 in Sweden)\n- **91B**: 190 hp Lycoming O-435, 106 built by De Schelde (Sk 50B in Sweden)\n- **91B-2**: version for Norway with constant-speed propeller, 25 built\n- **91C**: four seats, fuel tanks in the wings (Sk 50C in Sweden)\n- **91D**: lightened four-seater, 180 hp Lycoming O-360, 99 built\n- **Saab 201 and 202**: first prototype fitted with the test wings of the Saab 29 then the Saab 32',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saab_91_Safir',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saab_91_Safir',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Saab 91 Safir';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saab 91 Safir';
