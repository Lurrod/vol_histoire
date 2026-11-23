-- Learjet C-21A (Learjet 35A)
--
-- Photo : Connecticut Air National Guard C-21 (Learjet 35) The Flying Yankees (8279214689).jpg
--   licence CC BY-SA 2.0 — Tomás Del Coro from Las Vegas, Nevada, USA
--   https://commons.wikimedia.org/wiki/File:Connecticut_Air_National_Guard_C-21_(Learjet_35)_The_Flying_Yankees_(8279214689).jpg

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
    'Learjet C-21',
    'Learjet C-21',
    'Learjet C-21A (Learjet 35A)',
    'Learjet C-21A (Learjet 35A)',
    'Learjet 35A acheté sur étagère par l''US Air Force pour ses liaisons rapides et ses évacuations sanitaires',
    'Off-the-shelf Learjet 35A bought by the US Air Force for fast liaison and medical evacuation',
    '/assets/airplanes/c21-learjet.jpg',
    E'## Genèse\nLe Learjet 35 naît d''un banc d''essai : un Learjet 25 dont l''un des réacteurs CJ610 est remplacé, en mai 1971, par le nouveau turbofan **Garrett TFE731**. Plus puissant et moins bruyant, ce moteur justifie un modèle à part entière, plus long de 33 cm, qui vole le 22 août 1973 et reçoit sa certification en juillet 1974. Parmi les plus rapides de sa catégorie, il séduit les chefs d''État du Brésil, du Chili, de Finlande, de Suisse ou d''Arabie saoudite. L''US Air Force l''achète à son tour tel quel : le Learjet 35A devient le **C-21A**.\n\n## Conception\nLe C-21A garde la formule du Learjet : deux TFE731-2 de 16 kN en nacelles sur l''arrière du fuselage, des volets à fente unique et les réservoirs de bout d''aile qui signent la silhouette de la marque. La cabine accueille huit passagers et 1,26 m³ de fret, et peut recevoir des civières pour l''évacuation sanitaire. Le Learjet 36, à réservoir de fuselage agrandi, gagne 800 km d''autonomie au prix d''une cabine plus courte ; le Japon en tire l''**U-36A**, équipé d''un simulateur d''autodirecteur de missile, d''un brouilleur et d''un système de remorquage de cibles.\n\n## Carrière opérationnelle\nLes C-21A sont livrés d''avril 1984 à octobre 1985, au moment où l''USAF réduit sa flotte de **T-39 Sabreliner**. La flotte compte 38 appareils d''active et 18 de l''Air National Guard ; le 1er avril 1997, ceux basés aux États-Unis passent sous l''Air Mobility Command, avec le 375th Airlift Wing de Scott pour chef de file. Ailleurs, l''armée de l''air finlandaise reçoit ses trois Learjet 35A à partir de 1982 et les emploie à la surveillance maritime, à la photographie aérienne, au remorquage de cibles et au transport, et l''Argentine engage ceux de l''**Escuadrón Fénix** aux Malouines en diversion et en reconnaissance : l''un d''eux est abattu le 7 juin 1982 par un missile Sea Dart du HMS Exeter, avec ses cinq hommes d''équipage.\n\n## Place dans l''histoire\nLe Learjet 35 est le plus vendu des Learjet : 738 exemplaires construits jusqu''en 1994, dont plus de 500 encore en service. Le C-21 illustre l''achat sur étagère d''un avion d''affaires pour les missions de soutien, une formule que l''USAF reprend aussitôt avec le **C-20** Gulfstream. En juin 2019, il reste 19 C-21A dans l''Air Force ; le Japon retire ses derniers U-36A le 10 mars 2025.',
    E'## Genesis\nThe Learjet 35 grew out of a testbed: a Learjet 25 in which one CJ610 turbojet was replaced, in May 1971, by the new **Garrett TFE731** turbofan. More powerful and quieter, the engine justified a model in its own right, 33 cm longer, which flew on 22 August 1973 and was certified in July 1974. Among the fastest in its class, it won over the leaders of Brazil, Chile, Finland, Switzerland and Saudi Arabia. The US Air Force bought it off the shelf in turn: the Learjet 35A became the **C-21A**.\n\n## Design\nThe C-21A keeps the Learjet formula: two 16 kN TFE731-2s in nacelles on the rear fuselage, single-slotted flaps and the wingtip tanks that define the brand''s silhouette. The cabin takes eight passengers and 1.26 m³ of cargo, and can carry litters for medical evacuation. The Learjet 36, with a larger fuselage tank, gains 800 km of range at the cost of a shorter cabin; Japan derived from it the **U-36A**, fitted with a missile seeker simulator, a jammer and a target-towing system.\n\n## Operational career\nThe C-21As were delivered from April 1984 to October 1985, as the USAF was shrinking its **T-39 Sabreliner** fleet. The fleet numbered 38 active-duty and 18 Air National Guard aircraft; on 1 April 1997 those based in the United States came under Air Mobility Command, with the 375th Airlift Wing at Scott as lead unit. Elsewhere, the Finnish Air Force took delivery of its three Learjet 35As from 1982 and used them for maritime surveillance, aerial photography, target towing and transport, and Argentina flew those of the **Escuadrón Fénix** over the Falklands on diversion and reconnaissance sorties: one was shot down on 7 June 1982 by a Sea Dart missile from HMS Exeter, killing its five crew.\n\n## Place in history\nThe Learjet 35 is the best-selling Learjet: 738 built up to 1994, more than 500 of them still flying. The C-21 shows the off-the-shelf purchase of a business jet for support missions, a formula the USAF repeated straight away with the **C-20** Gulfstream. In June 2019, 19 C-21As remained in the Air Force; Japan retired its last U-36As on 10 March 2025.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1971-05-01',
    '1973-08-22',
    '1984-04-01',
    872,
    4488,
    (SELECT id FROM manufacturer WHERE code = 'LJ'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Learjet C-21'), (SELECT id FROM tech WHERE name = 'Réacteur Honeywell TFE731'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Learjet C-21'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Learjet C-21'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Learjet C-21'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.83,
  wingspan          = 12.04,
  height            = 3.73,
  wing_area         = 23.53,
  empty_weight      = 4152,
  mtow              = 8165,
  service_ceiling   = 13700,
  climb_rate        = 23.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett TFE731-2-2B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 15.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1984,
  production_end    = 1985,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 15,
  variants          = E'- **Learjet 35 / 35A** : versions civiles, 64 Learjet 35 puis plus de 600 Learjet 35A à moteurs TFE731-2-2B, produits jusqu''en 1993\n- **Learjet 36 / 36A** : réservoir de fuselage agrandi, 800 km d''autonomie en plus, cabine raccourcie de 46 cm\n- **C-21A** : Learjet 35A de l''US Air Force pour huit passagers, livrés d''avril 1984 à octobre 1985, aptes à l''évacuation sanitaire\n- **U-36A** : Learjet 36A d''entraînement et de soutien de la marine japonaise (simulateur d''autodirecteur, brouilleur, remorquage de cibles), six construits\n- **C-35 / R-35A / VU-35A** : versions cargo, de reconnaissance et de transport de personnalités de la force aérienne brésilienne',
  variants_en       = E'- **Learjet 35 / 35A**: civil versions, 64 Learjet 35s then more than 600 Learjet 35As with TFE731-2-2B engines, built until 1993\n- **Learjet 36 / 36A**: larger fuselage tank, 800 km more range, cabin shortened by 46 cm\n- **C-21A**: US Air Force Learjet 35A for eight passengers, delivered from April 1984 to October 1985, capable of medical evacuation\n- **U-36A**: Japanese navy training and support Learjet 36A (seeker simulator, jammer, target towing), six built\n- **C-35 / R-35A / VU-35A**: Brazilian Air Force cargo, reconnaissance and VIP transport versions',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Learjet_35',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Learjet_35',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Tomás Del Coro',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Learjet C-21';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Learjet C-21';
