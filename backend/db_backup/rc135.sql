-- Boeing RC-135 Rivet Joint
--
-- Photo : Flickr - DVIDSHUB - Operation Enduring Freedom Rivet Joint air refueling (Image 1 of 12).jpg
--   licence CC BY 2.0 — DVIDSHUB
--   https://commons.wikimedia.org/wiki/File:Flickr_-_DVIDSHUB_-_Operation_Enduring_Freedom_Rivet_Joint_air_refueling_(Image_1_of_12).jpg

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
    'Boeing RC-135',
    'Boeing RC-135',
    'Boeing RC-135 Rivet Joint',
    'Boeing RC-135 Rivet Joint',
    'La famille d''espions électroniques qui écoute le monde depuis 1961, du rideau de fer au Golfe',
    'The family of electronic spies that has listened to the world since 1961, from the Iron Curtain to the Gulf',
    '/assets/airplanes/rc135.jpg',
    E'## Genèse\nEn 1961, l''Union soviétique annonce l''essai d''une bombe de 100 mégatonnes en Nouvelle-Zemble. Un ravitailleur **KC-135A** modifié part en recueillir les signatures : le succès de la mission convainc l''US Air Force de dériver du **C-135** une famille d''avions de renseignement. Le **RC-135S** commence ses missions dès 1961 ; le **RC-135A** de cartographie photographique est commandé en 1962 pour remplacer le **RB-50**, et dix **RC-135B** suivent pour succéder au **RB-47H** dans l''écoute électronique.\n\n## Conception\nLes RC-135B sont les derniers construits neufs : livrés à Martin à partir de 1965, ils en ressortent en 1967 en **RC-135C**, reconnaissables aux gros carénages de « joues » qui abritent leur système de localisation des émetteurs. Toutes les versions suivantes naîtront de cellules existantes, d''où un foisonnement de désignations et de noms de programme : **Rivet Joint** pour le renseignement d''origine électromagnétique, **Combat Sent** pour l''analyse technique des radars adverses, **Cobra Ball** pour l''observation des missiles balistiques, une aile peinte en noir contre l''éblouissement des caméras. En 2005, la flotte reçoit des réacteurs CFM56 et un poste de pilotage à écrans.\n\n## Carrière opérationnelle\nPendant toute la **guerre froide**, les RC-135 longent les frontières de l''URSS et de ses alliés, de l''Alaska à la Grande-Bretagne. Ils écoutent le golfe du Tonkin et le Laos pendant la **guerre du Vietnam**, puis accompagnent la Grenade, le Panama, les Balkans, **Desert Storm**, l''Afghanistan et l''Irak : la flotte a participé à tous les conflits américains de son époque. Le 9 août 2010, le Rivet Joint fête vingt ans de présence ininterrompue au Moyen-Orient et plus de 8 000 missions de combat. La Royal Air Force, qui remplace ses **Nimrod R1** par trois RC-135W, les engage dès juillet 2014 contre l''**État islamique** en Irak.\n\n## Place dans l''histoire\nTrente-deux cellules seulement, mais une présence continue depuis plus de soixante ans : le RC-135 est l''oreille permanente de la puissance aérienne américaine. Sa force tient moins à l''avion qu''à son équipage, jusqu''à 27 spécialistes, guerre électronique, linguistes et techniciens, et à sa capacité à diffuser ce qu''il entend presque en temps réel. La flotte américaine est basée à Offutt, dans le Nebraska, et les RC-135W britanniques doivent servir jusqu''en 2045.',
    E'## Genesis\nIn 1961 the Soviet Union announced the test of a 100-megaton bomb on Novaya Zemlya. A modified **KC-135A** tanker set out to collect its signatures: the mission''s success convinced the US Air Force to derive a family of intelligence aircraft from the **C-135**. The **RC-135S** began its missions in 1961; the **RC-135A** photo-mapping version was ordered in 1962 to replace the **RB-50**, and ten **RC-135B** followed to succeed the **RB-47H** in electronic eavesdropping.\n\n## Design\nThe RC-135Bs were the last built new: delivered to Martin from 1965, they emerged in 1967 as **RC-135C**, recognisable by the large "cheek" fairings housing their emitter location system. Every later version was converted from existing airframes, hence a profusion of designations and programme names: **Rivet Joint** for signals intelligence, **Combat Sent** for technical analysis of enemy radars, **Cobra Ball** for observing ballistic missiles, with one wing painted black against glare in the cameras. In 2005 the fleet received CFM56 engines and a glass cockpit.\n\n## Operational career\nThroughout the **Cold War**, RC-135s flew along the borders of the USSR and its allies, from Alaska to Britain. They listened over the Gulf of Tonkin and Laos during the **Vietnam War**, then supported Grenada, Panama, the Balkans, **Desert Storm**, Afghanistan and Iraq: the fleet took part in every American conflict of its time. On 9 August 2010 Rivet Joint marked twenty years of unbroken presence in the Middle East and over 8,000 combat missions. The Royal Air Force, replacing its **Nimrod R1** with three RC-135Ws, committed them from July 2014 against **Islamic State** in Iraq.\n\n## Place in history\nOnly thirty-two airframes, but a continuous presence for more than sixty years: the RC-135 is the permanent ear of American air power. Its strength lies less in the aircraft than in its crew, up to 27 specialists, electronic warfare officers, linguists and technicians, and in its ability to pass on what it hears in near-real time. The American fleet is based at Offutt in Nebraska, and the British RC-135Ws are expected to serve until 2045.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    NULL,
    '1961-01-01',
    933,
    5552,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Invasion de la Grenade')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Invasion du Panama')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Boeing RC-135'), (SELECT id FROM wars WHERE name = 'Guerre contre l''État islamique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 41.53,
  wingspan          = 39.88,
  height            = 12.7,
  wing_area         = 226,
  empty_weight      = 56245,
  mtow              = 146284,
  service_ceiling   = 15240,
  climb_rate        = 24.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 31,

  -- Strate 2 : motorisation
  engine_name       = 'CFM International F108-CF-201',
  engine_count      = 4,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 97.9,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 32,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **RC-135A** : quatre avions de cartographie photographique commandés en 1962, plus tard reconvertis en ravitailleurs\n- **RC-135B / C Big Team** : dix appareils, les derniers construits neufs, équipés à partir de 1965 et reconnaissables à leurs « joues »\n- **RC-135S Cobra Ball** : observation des missiles balistiques en phase de propulsion et de rentrée, aile droite peinte en noir\n- **RC-135U Combat Sent** : renseignement technique sur les radars adverses\n- **RC-135V/W Rivet Joint** : avion standard d''écoute électromagnétique de l''USAF ; trois RC-135W « Airseeker » pour la Royal Air Force',
  variants_en       = E'- **RC-135A**: four photo-mapping aircraft ordered in 1962, later converted to tankers\n- **RC-135B / C Big Team**: ten aircraft, the last built new, equipped from 1965 and recognisable by their "cheeks"\n- **RC-135S Cobra Ball**: observation of ballistic missiles during boost and re-entry, right wing painted black\n- **RC-135U Combat Sent**: technical intelligence on enemy radars\n- **RC-135V/W Rivet Joint**: the USAF''s standard signals intelligence aircraft; three RC-135W "Airseeker" for the Royal Air Force',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_RC-135',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_RC-135',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'DVIDSHUB',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Boeing RC-135';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Boeing RC-135';
