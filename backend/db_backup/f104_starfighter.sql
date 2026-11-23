-- Lockheed F-104 Starfighter
--
-- Photo : Lockheed F-104G Starfighter D-8114 (9179542542).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File%3ALockheed_F-104G_Starfighter_D-8114_%289179542542%29.jpg

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
    'F-104 Starfighter',
    'F-104 Starfighter',
    'Lockheed F-104 Starfighter',
    'Lockheed F-104 Starfighter',
    'Intercepteur à aile minuscule, « le missile habité »',
    'Interceptor with a tiny wing, “the missile with a man in it”',
    '/assets/airplanes/f104-starfighter.jpg',
    E'## Genèse\nEn 1951, **Clarence « Kelly » Johnson** interroge des pilotes de chasse rentrant de Corée. Leur demande est unanime : un avion plus petit, plus simple, plus rapide, qui monte plus vite. Le Starfighter est la réponse littérale à cette demande — et la démonstration de ses limites.\n\n## Conception\nL''aile fait **6,68 mètres d''envergure** et 4 % d''épaisseur relative : ses bords d''attaque sont si coupants qu''on les protège au sol par des housses. Le fuselage est un tube autour du J79. Le résultat monte à 15 000 mètres en moins de deux minutes et bat les records d''altitude et de vitesse en 1958, mais vire mal, décroche sans prévenir et pardonne peu.\n\n## Carrière opérationnelle\nL''US Air Force s''en débarrasse vite, non sans l''avoir engagé dans la **guerre du Vietnam** : de 1965 à 1967, les F-104C de la 479e escadre y protègent les F-105 et les EC-121 en 5 206 sorties, sans une victoire aérienne, et en perdent 14, dont celui de Philip Smith, abattu par un J-6 chinois le 20 septembre 1965 après s''être égaré au-dessus de la Chine. Pendant la **guerre froide**, le 83rd FIS de l''USAF tient l''alerte à Taïwan en septembre-octobre 1958 face à la Chine et, pendant la crise de Berlin, une soixantaine de F-104A de la Garde nationale rejoignent Ramstein fin 1961 ; quinze aviations de l''OTAN et alliées l''alignent ensuite. Mais c''est l''**Europe** qui en fait un avion de masse : la version F-104G, renforcée pour la pénétration nucléaire à basse altitude — l''exact opposé de sa vocation — est produite à plus de 1 100 exemplaires par un consortium germano-italo-néerlando-belge. Pendant la **guerre indo-pakistanaise de 1965**, l''unique escadron de F-104 pakistanais intercepte de jour comme de nuit et reconnaît ; il abat le Mystère de Devaiah au-dessus de Sargodha et un Canberra, et se voit crédité du Gnat posé à Pasrur. Pendant la **guerre indo-pakistanaise de 1971**, ses F-104, renforcés par des appareils jordaniens, attaquent le radar d''Amritsar et Uttarlai et abattent un Canberra et un Alizé, mais perdent leur chef et un appareil jordanien face aux MiG-21. Lors de l''**invasion turque de Chypre**, les F-104G turcs assurent attaque et reconnaissance ; le 21 juillet, seize d''entre eux, avec des F-100D, bombardent par erreur trois destroyers turcs pris pour un convoi grec et coulent le *Kocatepe*. La Luftwaffe en perdra **292 sur 916**, avec 116 pilotes tués.\n\n## Place dans l''histoire\nLe Starfighter porte deux héritages lourds : la controverse allemande sur l''inadéquation d''un intercepteur de haute altitude à la frappe basse, et le **scandale Lockheed** de 1976, l''affaire de corruption la plus retentissante de l''industrie aéronautique d''après-guerre.',
    E'## Genesis\nIn 1951 **Clarence “Kelly” Johnson** interviewed fighter pilots returning from Korea. Their request was unanimous: a smaller, simpler, faster aircraft that climbed better. The Starfighter is the literal answer to that request — and the demonstration of its limits.\n\n## Design\nThe wing spans **6.68 metres** at 4% thickness: its leading edges are so sharp they are covered on the ground. The fuselage is a tube around the J79. The result climbs to 15,000 metres in under two minutes and took the altitude and speed records in 1958, but turns poorly, stalls without warning and forgives little.\n\n## Operational career\nThe US Air Force shed it quickly, though not before committing it to the **Vietnam War**: from 1965 to 1967 the 479th TFW''s F-104Cs protected F-105s and EC-121s over 5,206 sorties without an aerial victory, losing 14, including Philip Smith''s, shot down by a Chinese J-6 on 20 September 1965 after straying over China. During the **Cold War**, the USAF''s 83rd FIS stood alert on Taiwan in September-October 1958 facing China, and during the Berlin crisis some sixty Air National Guard F-104As reached Ramstein in late 1961; fifteen NATO and allied air forces went on to fly it. But it was **Europe** that made it a mass aircraft: the F-104G, strengthened for low-level nuclear penetration — the exact opposite of its design purpose — was built in more than 1,100 examples by a German-Italian-Dutch-Belgian consortium. In the **Indo-Pakistani War of 1965**, Pakistan''s sole F-104 squadron flew day and night interception and reconnaissance; it shot down Devaiah''s Mystère over Sargodha and a Canberra, and was credited with the Gnat that landed at Pasrur. In the **Indo-Pakistani War of 1971**, its F-104s, reinforced by Jordanian aircraft, attacked the Amritsar radar and Uttarlai and shot down a Canberra and an Alizé, but lost their commander and a Jordanian aircraft to MiG-21s. During the **Turkish invasion of Cyprus**, Turkish F-104Gs flew strike and reconnaissance missions; on 21 July sixteen of them, alongside F-100Ds, mistakenly bombed three Turkish destroyers taken for a Greek convoy, sinking *Kocatepe*. The Luftwaffe lost **292 out of 916**, with 116 pilots killed.\n\n## Place in history\nThe Starfighter carries two heavy legacies: the German controversy over fitting a high-altitude interceptor to the low-level strike role, and the **Lockheed bribery scandal** of 1976, the most damaging corruption affair in post-war aviation.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1951-01-01',
    '1954-03-04',
    '1958-02-20',
    2137.0,
    2620.0,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM tech WHERE name = 'Réacteur General Electric J79')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM armement WHERE name = 'M61 Vulcan')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM missions WHERE name = 'Frappe tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'F-104 Starfighter'), (SELECT id FROM wars WHERE name = 'Guerre Indo-Pakistanaise de 1971'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.69,
  wingspan          = 6.68,
  height            = 4.11,
  wing_area         = 18.22,
  empty_weight      = 6350,
  mtow              = 13170,
  service_ceiling   = 15000,
  climb_rate        = 244,
  g_limit_pos       = 7.33,
  g_limit_neg       = -3.0,
  combat_radius     = 670,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J79-GE-11A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 46.7,
  thrust_wet        = 70.3,

  -- Strate 3 : production & service
  production_start  = 1954,
  production_end    = 1979,
  units_built       = 2578,
  unit_cost_usd     = 1700000,
  unit_cost_year    = 1960,
  operators_count   = 15,
  variants          = E'- **F-104A / C** : intercepteur et chasseur-bombardier de l''US Air Force\n- **F-104G** : version multirôle renforcée, produite en Europe sous licence\n- **F-104S** : version italienne à missiles Sparrow, la plus tardive\n- **F-104J** : version japonaise d''interception, construite par Mitsubishi',
  variants_en       = E'- **F-104A / C** : US Air Force interceptor and fighter-bomber\n- **F-104G** : strengthened multirole version, licence-built in Europe\n- **F-104S** : Italian Sparrow-armed version, the last built\n- **F-104J** : Japanese interceptor version, built by Mitsubishi',

  -- Strate 4 : qualitatif
  nickname          = 'Missile with a man in it',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_F-104_Starfighter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'F-104 Starfighter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F-104 Starfighter';
