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
    'Blackburn Buccaneer',
    'Blackburn Buccaneer',
    'Blackburn (Hawker Siddeley) Buccaneer',
    'Blackburn (Hawker Siddeley) Buccaneer',
    'Bombardier embarqué britannique de 2e génération spécialisé dans l''attaque à basse altitude',
    'British 2nd-generation carrier-based bomber specialized in low-altitude attack',
    '/assets/airplanes/blackburn_buccaneer.jpg',
    'Le Blackburn Buccaneer est un avion d''attaque embarqué conçu pour la Royal Navy afin de mener des frappes antinavires à très basse altitude sous la couverture radar ennemie. Classé dans la 2e génération, il se distingue par son système de soufflage de couche limite sur les ailes et les gouvernes, lui conférant d''excellentes performances à basse vitesse indispensables aux opérations sur porte-avions. Propulsé par deux réacteurs Rolls-Royce Spey, il possède une soute à bombes rotative interne et peut emporter une charge offensive considérable. Après le retrait des porte-avions britanniques, le Buccaneer a été transféré à la RAF où il a servi comme bombardier tactique à pénétration basse altitude. Il s''est illustré pendant la guerre du Golfe en 1991 comme désignateur laser pour les Tornado, prouvant sa valeur jusqu''à sa retraite en 1994. L''Afrique du Sud l''a également employé au combat.',
    'The Blackburn Buccaneer is a carrier-based attack aircraft designed for the Royal Navy to carry out anti-ship strikes at very low altitude under enemy radar cover. Classified as 2nd generation, it is distinguished by its boundary layer blowing system on wings and control surfaces, giving it excellent low-speed performance essential for carrier operations. Powered by two Rolls-Royce Spey engines, it has an internal rotating bomb bay and can carry a considerable offensive load. After the withdrawal of British aircraft carriers, the Buccaneer was transferred to the RAF where it served as a low-altitude penetration tactical bomber. It distinguished itself during the Gulf War in 1991 as a laser designator for Tornados, proving its value until its retirement in 1994. South Africa also employed it in combat.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1955-01-01',
    '1958-04-30',
    '1962-07-17',
    1040.0,
    3700.0,
    (SELECT id FROM manufacturer WHERE code = 'BAE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce Spey')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Radar Blue Parrot')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'Martel AJ-168')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'Sea Eagle')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'WE.177')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'BL755')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = '1000 lb GP')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM armement WHERE name = 'GBU-12 Paveway II'));

-- Insertion des guerres
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Buccaneer'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- [auto:005] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  length = 19.33, wingspan = 13.41, height = 4.97, wing_area = 47.82,
  empty_weight = 13640, mtow = 28120, service_ceiling = 12200, climb_rate = 35.6,
  combat_radius = 966, crew = 2,
  engine_name = 'Rolls-Royce Spey Mk.101', engine_count = 2,
  engine_type = 'Turbofan', engine_type_en = 'Turbofan',
  thrust_dry = 49.0,
  production_start = 1960, production_end = 1977, units_built = 211,
  operators_count = 2,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Blackburn_Buccaneer',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Blackburn_Buccaneer'
WHERE name = 'Blackburn Buccaneer';

-- [auto:006] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  unit_cost_usd = 3000000, unit_cost_year = 1970,
  variants    = E'- **Buccaneer S.1** : version initiale Royal Navy (moteurs Gyron Junior)\n- **Buccaneer S.2** : remoteurisation Spey, export Afrique du Sud\n- **Buccaneer S.2B** : version RAF (transfert après retrait des porte-avions)'
WHERE name = 'Blackburn Buccaneer';

-- [auto:007] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  description = E'## Genèse\nAu début des années 1950, la Royal Navy s''inquiète des croiseurs soviétiques de la classe **Sverdlov**, capables de ravager le trafic marchand de l''Atlantique. Plutôt que de construire de nouveaux croiseurs, elle choisit un avion d''attaque embarqué : la spécification NA.39 paraît en juin 1952 et le projet B-103 de **Blackburn** l''emporte en juillet 1955. Le prototype vole le 30 avril 1958.\n\n## Conception\nL''avion est taillé pour foncer au ras des vagues, sous l''horizon des radars. Pour apponter malgré une aile compacte, il souffle de l''air prélevé sur les réacteurs sur la voilure et l''empennage, ce qui accroît fortement la portance à basse vitesse. Sa soute rotative pivote autour de l''axe du fuselage et largue l''armement sans la traînée de trappes classiques. Le S.1, sous-motorisé, cède la place au S.2 à réacteurs **Rolls-Royce Spey**, environ 40 % plus puissants.\n\n## Carrière opérationnelle\nMis en service en juillet 1962, le Buccaneer opère depuis les porte-avions *Victorious*, *Eagle*, *Ark Royal* et *Hermes*. Arme de la **guerre froide**, il est qualifié pour l''arme nucléaire en 1965. La **RAF** l''adopte dès octobre 1969 : à Laarbruch, en RFA, les 15 et 16 Squadrons tiennent la frappe nucléaire (WE.177) face au pacte de Varsovie, tandis qu''à Lossiemouth les 12 et 208 Squadrons assurent l''attaque antinavire, au **Sea Eagle** à partir de 1986.\n\nL''Afrique du Sud en achète seize. Pendant la **guerre de la frontière sud-africaine**, ceux du 24e escadron bombardent Cassinga puis y attaquent la colonne blindée cubaine, tirent des AS-30 sur les défenses angolaises en 1981 et, le 3 janvier 1988, abattent le pont sur le Cuito à la bombe planante Raptor.\n\nPour la **guerre du Golfe**, un premier groupe de six avions quitte Lossiemouth le 26 janvier 1991. Volant à deux avec quatre **Tornado**, les Buccaneer désignent les cibles au laser : 218 missions, 48 bombes guidées larguées par eux-mêmes et une vingtaine de ponts détruits.\n\n## Place dans l''histoire\nRetiré par l''Afrique du Sud en 1991 puis par la RAF le 31 mars 1994, le Buccaneer reste l''archétype de l''avion de pénétration à très basse altitude, qui survit en volant plus bas que les radars.',
  description_en = E'## Genesis\nIn the early 1950s the Royal Navy worried about the Soviet **Sverdlov**-class cruisers, which could wreak havoc on Atlantic merchant shipping. Rather than build new cruisers of its own, it opted for a specialised carrier strike aircraft: Naval Staff Requirement NA.39 was issued in June 1952, and **Blackburn**''s B-103 design won in July 1955. The prototype flew on 30 April 1958.\n\n## Design\nThe aircraft was built to race in just above the waves, below the radar horizon. To land on a carrier despite its compact wing, it blew engine bleed air over the wing and tailplane, greatly increasing lift at low speed. Its rotating bomb bay turned about the fuselage axis and released weapons without the drag of conventional doors. The underpowered S.1 gave way to the S.2 with **Rolls-Royce Spey** engines, offering about 40 per cent more thrust.\n\n## Operational career\nCommissioned in July 1962, the Buccaneer flew from the carriers *Victorious*, *Eagle*, *Ark Royal* and *Hermes*. A **Cold War** weapon, it was cleared for nuclear delivery in 1965. The **RAF** took it on from October 1969: at Laarbruch, West Germany, Nos. 15 and 16 Squadrons held the nuclear strike role (WE.177) against the Warsaw Pact, while Nos. 12 and 208 Squadrons at Lossiemouth flew maritime strike, with **Sea Eagle** from 1986.\n\nSouth Africa bought sixteen. In the **South African Border War**, 24 Squadron''s aircraft bombed Cassinga and then attacked the Cuban armoured column there, fired AS-30 missiles at Angolan air defences in 1981 and, on 3 January 1988, brought down the Cuito bridge with a Raptor glide bomb.\n\nFor the **Gulf War**, a first batch of six left Lossiemouth on 26 January 1991. Flying in pairs alongside four **Tornados**, the Buccaneers laser-designated their targets: 218 missions, 48 guided bombs dropped themselves and some twenty bridges destroyed.\n\n## Place in history\nRetired by South Africa in 1991 and by the RAF on 31 March 1994, the Buccaneer remains the archetype of the very low-level penetrator, an aircraft that survived by flying lower than the radars.'
WHERE name = 'Blackburn Buccaneer';

-- [auto:008] enrichment block — generated by sync-enrichment-to-backups.js
UPDATE airplanes SET
  variants_en = E'- **Buccaneer S.1** : initial Royal Navy variant (Gyron Junior engines)\n- **Buccaneer S.2** : Spey re-engining, South African export\n- **Buccaneer S.2B** : RAF variant (transferred after carrier retirement)'
WHERE name = 'Blackburn Buccaneer';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Blackburn Buccaneer';
