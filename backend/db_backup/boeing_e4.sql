-- Boeing E-4 Nightwatch
--
-- Photo : Fuel on the go (7277493).jpg
--   licence Public domain — U.S. Air Force photo by Staff Sgt. Ashley Sokolov
--   https://commons.wikimedia.org/wiki/File:Fuel_on_the_go_(7277493).jpg

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
    'Boeing E-4',
    'Boeing E-4',
    'Boeing E-4 Nightwatch',
    'Boeing E-4 Nightwatch',
    'Un Boeing 747 durci contre l''atome pour diriger les États-Unis au cœur d''une guerre nucléaire',
    'A nuclear-hardened Boeing 747 built to run the United States through a nuclear war',
    '/assets/airplanes/boeing-e4.jpg',
    E'## Genèse\nAu début des années 1970, le poste de commandement aéroporté d''urgence des États-Unis, le **NEACP**, repose sur des **EC-135J** exigus. Deux cellules de **Boeing 747-200**, restées sans acheteur après une commande avortée, sont alors proposées à l''US Air Force. En février 1973, le programme 481B lui en attribue deux, désignées **E-4A**, auxquelles s''ajoute une troisième en juillet. Le premier E-4A vole le 13 juin 1973 ; une quatrième cellule, commandée en décembre 1973 avec un équipement plus avancé, devient le premier **E-4B**, livré le 21 décembre 1979.\n\n## Conception\nL''E-4B se reconnaît à la bosse profilée qui coiffe le pont supérieur et abrite son antenne satellite SHF. Tout l''avion est **durci contre l''impulsion électromagnétique** d''une explosion nucléaire : câblages et équipements blindés, instruments de vol restés analogiques, moins vulnérables. Sur trois ponts, il loge une salle de conférence, une suite pour l''autorité nationale de commandement, une salle de briefing et les consoles de transmission, dont une **antenne filaire traînante** de 8 km vers les sous-marins lanceurs d''engins. Avec jusqu''à 112 personnes à bord, record de l''US Air Force, et le ravitaillement en vol, il est conçu pour tenir l''air une semaine : seule l''huile de ses moteurs l''en empêcherait.\n\n## Carrière opérationnelle\nDéployé en 1974, le NEACP, prononcé « kneecap », doit permettre au président et au secrétaire à la Défense de conduire la guerre si le pays est frappé ; la presse le surnomme « avion de l''apocalypse ». D''abord basés à Andrews, près de Washington, les appareils rejoignent Offutt, dans le Nebraska ; un E-4B reste en alerte permanente, équipage à bord. La fin de la **guerre froide** déplace sa vocation : devenu **NAOC** en 1994, il transporte le secrétaire à la Défense à l''étranger et a servi la FEMA après l''ouragan Opal en 1995. Le 11 septembre 2001, un E-4B en exercice tourne au-dessus de Washington. **Donald Rumsfeld** voulait retirer la flotte ; **Robert Gates** annule la décision en 2007.\n\n## Place dans l''histoire\nL''E-4 incarne la continuité du gouvernement à l''âge nucléaire : un centre de commandement qu''on ne peut viser parce qu''il ne cesse de bouger. Malgré un coût de près de 160 000 dollars par heure de vol, il reste indispensable : quand le président voyage hors d''Amérique du Nord, un E-4B l''attend sur un aéroport voisin. Les quatre appareils, tous au standard E-4B depuis 1985, doivent céder la place au **Survivable Airborne Operations Center** de Sierra Nevada Corporation, bâti sur le **Boeing 747-8**. Son homologue russe est l''**Il-80**.',
    E'## Genesis\nIn the early 1970s the United States'' emergency airborne command post, **NEACP**, relied on cramped **EC-135J** aircraft with limited endurance. Two **Boeing 747-200** airframes, left over when an airline failed to complete its order, were offered to the US Air Force. In February 1973 the 481B programme awarded it two of them, designated **E-4A**, and a third was added in July. The first E-4A flew on 13 June 1973; a fourth airframe, ordered in December 1973 with more advanced equipment, became the first **E-4B**, delivered on 21 December 1979.\n\n## Design\nThe E-4B is recognisable by the streamlined hump behind the upper deck that houses its SHF satellite antenna. The whole aircraft is **hardened against the electromagnetic pulse** of a nuclear explosion: shielded wiring and equipment, and flight instruments deliberately kept analogue because they are less vulnerable than screens. Across three decks it houses a conference room, a suite for the National Command Authority, a briefing room and communications consoles, including an 8 km **trailing wire antenna** to reach ballistic missile submarines. With up to 112 people aboard, the largest crew in US Air Force history, and in-flight refuelling, it is designed to stay aloft for a week: only its engine oil would stop it.\n\n## Operational career\nDeployed in 1974, NEACP, pronounced "kneecap", was to let the president and the secretary of defense conduct a war if the country were struck; the press promptly dubbed it the "doomsday plane". First based at Andrews near Washington, the aircraft moved to the safer Offutt in Nebraska; one E-4B stays on permanent alert with its crew aboard. The end of the **Cold War** shifted its purpose: renamed **NAOC** in 1994, it carries the secretary of defense abroad and supported FEMA after Hurricane Opal in 1995. On 11 September 2001 an E-4B on exercise took off just before 9:44 am and circled over Washington. **Donald Rumsfeld** wanted to retire the fleet; **Robert Gates** reversed the decision in 2007.\n\n## Place in history\nThe E-4 embodies continuity of government in the nuclear age: a command centre that cannot be targeted because it never stops moving. Its cost, nearly $160,000 per flight hour, has never called its existence into question, and when the president travels outside North America an E-4B waits at a nearby airport. The four aircraft, all to E-4B standard since 1985, are due to give way to Sierra Nevada Corporation''s **Survivable Airborne Operations Center**, built on the **Boeing 747-8**. Its Russian counterpart is the **Il-80**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1973-02-01',
    '1973-06-13',
    '1974-12-01',
    969,
    11500,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM tech WHERE name = 'Antenne filaire traînante')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM tech WHERE name = 'Durcissement contre l''impulsion électromagnétique')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire')),
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing E-4'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 70.51,
  wingspan          = 59.64,
  height            = 19.33,
  wing_area         = 510,
  empty_weight      = 185973,
  mtow              = 377842,
  service_ceiling   = 13716,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 112,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F103 (CF6-50E2)',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 233.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1973,
  production_end    = 1979,
  units_built       = 4,
  unit_cost_usd     = 223200000,
  unit_cost_year    = 2024,
  operators_count   = 1,
  variants          = E'- **E-4A** : trois appareils livrés de 1973 à 1974, sans bosse dorsale, motorisés d''abord par des Pratt & Whitney JT9D puis par le GE F103\n- **E-4B** : quatrième cellule livrée le 21 décembre 1979, durcie contre l''impulsion électromagnétique, antenne satellite SHF sous la bosse dorsale\n- **Conversion générale** : les trois E-4A ramenés au standard E-4B en janvier 1985\n- **E-4C** : cinq Boeing 747-8I rachetés à Korean Air pour le futur Survivable Airborne Operations Center',
  variants_en       = E'- **E-4A**: three aircraft delivered from 1973 to 1974, without the dorsal hump, first powered by Pratt & Whitney JT9D engines, then by the GE F103\n- **E-4B**: fourth airframe delivered on 21 December 1979, hardened against electromagnetic pulse, SHF satellite antenna under the dorsal hump\n- **Fleet conversion**: the three E-4As brought up to E-4B standard by January 1985\n- **E-4C**: five Boeing 747-8Is bought from Korean Air for the future Survivable Airborne Operations Center',

  -- Strate 4 : qualitatif
  nickname          = 'Nightwatch',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_E-4',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_E-4',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Staff Sgt. Ashley Sokolov, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Boeing E-4';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing E-4';
