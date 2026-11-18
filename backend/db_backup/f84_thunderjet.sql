-- Republic F-84 Thunderjet
--
-- Photo : 49th Fighter Squadron Republic F-84B-21-RE Thunderjet 46-548.jpg
--   licence Public domain — United States Air Force
--   https://commons.wikimedia.org/wiki/File:49th_Fighter_Squadron_Republic_F-84B-21-RE_Thunderjet_46-548.jpg

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
    'F-84 Thunderjet',
    'F-84 Thunderjet',
    'Republic F-84 Thunderjet',
    'Republic F-84 Thunderjet',
    'Chasseur-bombardier à aile droite de la guerre de Corée, premier chasseur ravitaillable en vol et porteur nucléaire',
    'Straight-wing Korean War fighter-bomber, the first fighter built for in-flight refuelling and nuclear strike',
    '/assets/airplanes/f84-thunderjet.jpg',
    E'## Genèse\nEn 1944, le chef des études de **Republic Aviation**, **Alexander Kartveli**, cherche un remplaçant à réaction au **P-47 Thunderbolt**. Plutôt que de modifier le P-47, son équipe dessine un avion neuf, au fuselage effilé, avec une entrée d''air dans le nez et un réacteur axial à l''arrière. Le 11 septembre 1944, l''armée de l''air américaine publie le programme d''un chasseur de jour à 970 km/h ; le 11 novembre, elle commande trois prototypes du **XP-84** sans mise en concurrence. Le premier vole le 28 février 1946 à Muroc, aux mains du major **Wallace Lien**.\n\n## Conception\nL''aile droite, épaisse et à profil laminaire, abrite l''essentiel du carburant, et des réservoirs de bout d''aile complètent l''autonomie. Faute de radar de recherche, l''avion est cantonné au vol de jour. Les débuts sont désastreux : ailes qui se tordent sous les réservoirs, revêtement qui se plisse, pièces introuvables. En mai 1948, toute la flotte de F-84B est clouée au sol, et une revue conclut que les F-84B et C ne peuvent remplir aucune de leurs missions. Le **F-84D** renforcé sauve le programme, mais l''avion n''atteint sa maturité qu''avec le **F-84G** de 1951 : moteur J35-A-29, pilote automatique, réceptacle de ravitaillement en vol et capacité d''emport d''une **bombe atomique Mark 7**.\n\n## Carrière opérationnelle\nEn **Corée**, le 27th Fighter Escort Group effectue ses premières missions le 7 décembre 1950, d''abord en escorte des B-29. Surclassé par le **MiG-15** à aile en flèche, le Thunderjet se reconvertit dans l''attaque au sol, où il excelle : 86 408 missions, 55 586 tonnes de bombes et 60 % des objectifs terrestres détruits selon l''USAF, au prix de 335 appareils perdus. Il est aussi le premier chasseur de l''USAF à se ravitailler en vol au combat. Le **Strategic Air Command** l''emploie de 1948 à 1957 ; en août 1953, dix-sept F-84G relient sans escale les États-Unis au Royaume-Uni. Livré à treize forces aériennes étrangères, surtout au titre de l''aide militaire, il combat encore pour le **Portugal en Angola** à partir de 1961.\n\n## Place dans l''histoire\nNé dans la douleur, au point de faire vaciller son constructeur, le Thunderjet devient le chasseur-bombardier de référence de l''OTAN naissante : 4 450 exemplaires, dont 3 025 F-84G, majoritairement livrés aux alliés. Il ouvre la voie au ravitaillement en vol des chasseurs et à l''arme nucléaire tactique sur monoplace. Il donne ensuite naissance au **F-84F Thunderstreak** à aile en flèche, qui lui succède. Ses pilotes, éprouvés par ses interminables décollages, l''avaient surnommé le *Lead Sled*, le « traîneau de plomb ».',
    E'## Genesis\nIn 1944 **Republic Aviation**''s chief designer, **Alexander Kartveli**, set out to find a jet replacement for the **P-47 Thunderbolt**. Fitting a jet engine into the P-47''s bulky fuselage proved impossible, so his team drew a new aircraft with a slim fuselage, a nose intake and an axial-flow engine in the rear. On 11 September 1944 the US Army Air Forces issued a requirement for a 970 km/h day fighter; on 11 November they ordered three **XP-84** prototypes without a competition. The first flew on 28 February 1946 at Muroc, flown by Major **Wallace Lien**.\n\n## Design\nThe thick, laminar-flow straight wing held most of the fuel, with wingtip tanks extending the range. Lacking a search radar, the aircraft was confined to daylight operations. Its early career was disastrous: wings twisting under the tip tanks, wrinkling fuselage skin, chronic parts shortages. In May 1948 the entire F-84B fleet was grounded, and a review concluded that neither the F-84B nor the F-84C could perform any part of its mission. The strengthened **F-84D** saved the programme, but the design only matured with the 1951 **F-84G**: J35-A-29 engine, autopilot, an in-flight refuelling receptacle and the ability to carry a **Mark 7 atomic bomb**.\n\n## Operational career\nOver **Korea** the 27th Fighter Escort Group flew its first missions on 7 December 1950, initially escorting B-29s. Outclassed by the swept-wing **MiG-15**, the Thunderjet switched to ground attack, where it excelled: 86,408 missions, 55,586 tons of bombs and, by USAF reckoning, 60 per cent of all ground targets destroyed, at a cost of 335 aircraft. It was also the first USAF fighter to refuel in flight in combat. **Strategic Air Command** flew it from 1948 to 1957; in August 1953 seventeen F-84Gs flew non-stop from the United States to the United Kingdom. Supplied to thirteen foreign air forces, mostly under military aid, it was still fighting for **Portugal in Angola** from 1961.\n\n## Place in history\nBorn in such difficulty that it nearly sank its maker, the Thunderjet became the reference fighter-bomber of the young NATO alliance: 4,450 were built, 3,025 of them F-84Gs, most delivered to allies. It pioneered in-flight refuelling for fighters and tactical nuclear weapons on a single-seater. Its straight-wing layout then gave rise to the swept-wing **F-84F Thunderstreak**, which succeeded it. Its pilots, worn down by its endless take-off runs, nicknamed it the *Lead Sled*.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-09-11',
    '1946-02-28',
    '1947-12-01',
    1001,
    3200,
    (SELECT id FROM manufacturer WHERE code = 'REP'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM armement WHERE name = 'HVAR 70 mm')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM missions WHERE name = 'Escorte')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM wars WHERE name = 'Guerre de Corée')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-84 Thunderjet'), (SELECT id FROM wars WHERE name = 'Guerre coloniale portugaise'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.61,
  wingspan          = 11.1,
  height            = 3.84,
  wing_area         = 24.2,
  empty_weight      = 5033,
  mtow              = 10671,
  service_ceiling   = 12300,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1600,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J35-A-29',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 24.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1946,
  production_end    = 1953,
  units_built       = 4450,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 14,
  variants          = E'- **XP-84 / YP-84A** : prototypes et appareils d''évaluation, 15 YP-84A\n- **F-84B / F-84C** : premières séries, 226 et 191 exemplaires, longtemps jugées inaptes au service\n- **F-84D** : structure renforcée, réacteur J35-A-17, 154 exemplaires\n- **F-84E** : fuselage allongé, radar de tir AN/APG-30, 843 exemplaires\n- **F-84G** : version définitive, ravitaillable en vol et porteuse de la bombe Mark 7, 3 025 exemplaires',
  variants_en       = E'- **XP-84 / YP-84A**: prototypes and service-test aircraft, 15 YP-84As\n- **F-84B / F-84C**: first production batches, 226 and 191 built, long judged unfit for service\n- **F-84D**: strengthened structure, J35-A-17 engine, 154 built\n- **F-84E**: stretched fuselage, AN/APG-30 fire-control radar, 843 built\n- **F-84G**: definitive version, refuellable in flight and able to carry the Mark 7 bomb, 3,025 built',

  -- Strate 4 : qualitatif
  nickname          = 'Lead Sled',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Republic_F-84_Thunderjet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Republic_F-84_Thunderjet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'F-84 Thunderjet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-84 Thunderjet';
