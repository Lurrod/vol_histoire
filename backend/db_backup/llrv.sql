-- Bell Lunar Landing Research Vehicle (LLRV)
--
-- Photo : Lunar Landing Research Vehicle No. 1 in 1964 (ECN-535).jpg
--   licence Public domain — NASA/Dryden Flight Research Center
--   https://commons.wikimedia.org/wiki/File:Lunar_Landing_Research_Vehicle_No._1_in_1964_(ECN-535).jpg

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
    'Bell LLRV',
    'Bell LLRV',
    'Bell Lunar Landing Research Vehicle (LLRV)',
    'Bell Lunar Landing Research Vehicle (LLRV)',
    'Le « sommier volant » de la NASA sur lequel les astronautes d''Apollo ont appris à se poser sur la Lune',
    'NASA''s ''Flying Bedstead'', on which the Apollo astronauts learned to land on the Moon',
    '/assets/airplanes/bell-llrv.jpg',
    E'## Genèse\nQuand la planification d''**Apollo** s''engage, la NASA cherche un simulateur capable de reproduire la descente vers la Lune : la phase finale de chaque alunissage sera pilotée à la main par le commandant. Après des réunions avec **Bell Aerosystems**, société de Buffalo rompue au décollage vertical, elle lui confie en décembre 1961 un contrat d''étude de 50 000 dollars. Le 1er février 1963 suit un contrat de 3,6 millions de dollars pour deux véhicules destinés au **Flight Research Center** d''Edwards.\n\n## Conception\nLe LLRV n''est qu''un treillis de poutres en alliage d''aluminium, sans carénage, d''où son surnom de « sommier volant » (**Flying Bedstead**). Un turboréacteur double flux **General Electric CF700-2V** de 19 kN, monté verticalement sur cardan, le hisse à l''altitude d''essai puis ne porte plus que les cinq sixièmes de son poids : l''engin se comporte alors comme sous la gravité lunaire. Deux fusées au peroxyde d''hydrogène règlent la descente et les déplacements, seize petits propulseurs le tangage, le lacet et le roulis. En « Lunar Sim Mode », le réacteur reste pointé vers le sol quelle que soit l''assiette, et une électronique nourrie par un radar Doppler corrige jusqu''aux rafales. Le pilote dispose d''un siège éjectable **Weber**, l''un des premiers « zéro-zéro ».\n\n## Essais\nLe 30 octobre 1964, **Joe Walker** effectue les trois premiers vols du LLRV-1, rejoint ensuite par **Don Mallick** et par **Jack Kleuver**, pilote d''essai d''hélicoptères de l''US Army. Les postes reçoivent la poignée trois axes et la manette des gaz du module lunaire, puis un habitacle en polystyrène qui imite sa visibilité réduite. Quand les vols cessent à Edwards, le 30 novembre 1966, les deux engins ont volé 204 fois sans accident grave. Transférés à Ellington, près de Houston, ils accueillent **Neil Armstrong** le 27 mars 1967. Le 6 mai 1968, à une soixantaine de mètres du sol, Armstrong doit s''éjecter : à court de carburant pour ses propulseurs d''attitude, pris dans un vent fort, le LLRV-1 est détruit.\n\n## Place dans l''histoire\nLe succès des LLRV conduit à commander à Bell, en mars 1967, trois **Lunar Landing Training Vehicles** (LLTV), d''où sortiront tous les pilotes de module lunaire posés sur la Lune. Deux sont perdus, en 1968 et en 1971, mais le siège éjectable sauve chaque fois le pilote. Armstrong, qui y avait volé plus de trente fois, dira qu''**Eagle** se pilotait presque comme lui ; **Gene Cernan** fait le dernier vol le 13 novembre 1972, avant **Apollo 17**. Le LLRV-2 est exposé au musée des essais en vol d''Edwards, le LLTV-3 au centre spatial Johnson.',
    E'## Genesis\nAs **Apollo** planning got under way, NASA looked for a simulator that could reproduce the descent to the Moon: the final phase of every landing would be flown by hand by the commander. After meetings with **Bell Aerosystems** of Buffalo, experienced in vertical take-off, it awarded Bell a $50,000 study contract in December 1961. On 1 February 1963 a $3.6 million contract followed for two vehicles for the **Flight Research Center** at Edwards.\n\n## Design\nThe LLRV was nothing more than an unfaired aluminium alloy truss, hence its nickname, the **Flying Bedstead**. A 19 kN **General Electric CF700-2V** turbofan, mounted vertically in a gimbal, lifted it to test altitude and was then throttled back to carry five-sixths of its weight, so that the vehicle behaved as it would under lunar gravity. Two hydrogen peroxide rockets controlled the rate of descent and horizontal movement, sixteen small thrusters pitch, yaw and roll. In ''Lunar Sim Mode'' the engine stayed pointed at the ground whatever the attitude, while electronics fed by a Doppler radar corrected even for gusts. The pilot sat on a **Weber** ejection seat, one of the first zero-zero designs.\n\n## Testing\nOn 30 October 1964 **Joe Walker** made the first three flights of LLRV-1, later joined by **Don Mallick** and by **Jack Kleuver**, the US Army''s senior helicopter test pilot. The cockpits were given the Lunar Module''s three-axis hand controller and throttle, then a Styrofoam enclosure mimicking its restricted view. When flying ended at Edwards on 30 November 1966, the two vehicles had made 204 flights without a serious accident. Moved to Ellington near Houston, they received **Neil Armstrong** on 27 March 1967. On 6 May 1968, some 60 m above the ground, Armstrong had to eject: out of fuel for its attitude thrusters and caught in high winds, LLRV-1 was destroyed.\n\n## Place in history\nThe success of the LLRVs led to an order with Bell, in March 1967, for three **Lunar Landing Training Vehicles** (LLTV), on which every Lunar Module pilot who landed on the Moon trained. Two were lost, in 1968 and 1971, but each time the ejection seat saved the pilot. Armstrong, who had flown it more than thirty times, said that **Eagle** flew very much like it; **Gene Cernan** made the last flight on 13 November 1972, ahead of **Apollo 17**. LLRV-2 is displayed at the flight test museum at Edwards, LLTV-3 at the Johnson Space Center.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1961-12-01',
    '1964-10-30',
    NULL,
    65,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell LLRV'), (SELECT id FROM tech WHERE name = 'Moteur-fusée'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell LLRV'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 6.85,
  wingspan          = NULL,
  height            = 3.05,
  wing_area         = NULL,
  empty_weight      = 1139,
  mtow              = 1780,
  service_ceiling   = 1829,
  climb_rate        = 18.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF700-2V',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 18.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **LLRV-1** : premier exemplaire, 198 vols à Edwards, détruit le 6 mai 1968 après l''éjection de Neil Armstrong\n- **LLRV-2 (NASA 951)** : livré en pièces et assemblé à Edwards, six vols à Edwards ; exposé au musée des essais en vol de la base\n- **LLTV** : version d''entraînement améliorée, trois exemplaires commandés en mars 1967 pour 5,9 millions de dollars\n- **LLTV-1 et LLTV-2** : détruits en décembre 1968 et janvier 1971, pilotes éjectés sains et saufs\n- **LLTV-3 (NASA 952)** : dernier vol par Gene Cernan le 13 novembre 1972 ; exposé au centre spatial Johnson',
  variants_en       = E'- **LLRV-1**: first vehicle, 198 flights at Edwards, destroyed on 6 May 1968 after Neil Armstrong''s ejection\n- **LLRV-2 (NASA 951)**: delivered in parts and assembled at Edwards, six flights there; displayed at the base''s flight test museum\n- **LLTV**: improved training version, three ordered in March 1967 for $5.9 million\n- **LLTV-1 and LLTV-2**: destroyed in December 1968 and January 1971, both pilots ejecting safely\n- **LLTV-3 (NASA 952)**: last flown by Gene Cernan on 13 November 1972; displayed at the Johnson Space Center',

  -- Strate 4 : qualitatif
  nickname          = 'Flying Bedstead',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lunar_Landing_Research_Vehicle',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lunar_Landing_Research_Vehicle',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA Dryden Flight Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Bell LLRV';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell LLRV';
