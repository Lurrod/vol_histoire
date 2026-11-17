-- Antonov An-8 (Camp)
--
-- Photo : Antonov An-8 ’10 green’ (24696676257).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Antonov_An-8_%E2%80%9910_green%E2%80%99_(24696676257).jpg

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
    'Antonov An-8',
    'Antonov An-8',
    'Antonov An-8 (Camp)',
    'Antonov An-8 (Camp)',
    'Le premier cargo d''assaut à rampe arrière d''Antonov, des pistes soviétiques aux charters africains',
    'Antonov''s rear-loading assault transport, from Soviet airfields to African charter work',
    '/assets/airplanes/an8.jpg',
    E'## Genèse\nEn décembre 1951, le bureau d''études OKB-153 lance l''étude d''un transport d''assaut bimoteur, le DT-5/8, doté d''une large porte arrière pour que les véhicules y entrent par leurs propres moyens. Le 11 décembre 1953, le Conseil des ministres soviétique ordonne au bureau Antonov d''en tirer un bi-turbopropulseur. Le prototype, baptisé Izdeliye P, vole le 11 février 1956 depuis l''aérodrome de Sviatochyn, à Kiev, et paraît en public au défilé de Touchino le 18 août suivant.\n\n## Conception\nAile haute, fuselage de section rectangulaire, train principal logé dans des carénages latéraux et arrière relevé pour dégager le chargement : l''An-8 emporte 60 soldats, des canons d''assaut ASU-57 ou des blindés BTR-40 et BTR-152. Les essais d''État révèlent pourtant de graves défauts : vrille dangereuse, oscillations sur les trois axes, moteurs **TV-2** instables en altitude et difficiles à démarrer. Antonov agrandit les empennages, ajoute des plans anti-vrille, supprime les becs de bord d''attaque et adopte des turbopropulseurs **Ivchenko AI-20D**, qui allègent l''avion de trois tonnes. Une tourelle de queue armée d''un canon de 23 mm, un radôme sous le menton et un nez vitré de navigateur complètent l''ensemble.\n\n## Carrière opérationnelle\nConstruit à Tachkent de 1957 à 1961 à 151 exemplaires pour remplacer le **Lisounov Li-2**, version soviétique du DC-3, l''An-8 sert surtout dans l''armée de l''air soviétique. En 1968, deux appareils déposent les forces spéciales chargées de s''emparer de l''aéroport de Plzeň lors de l''invasion de la Tchécoslovaquie. D''autres sont convertis en avions de renseignement électronique, et l''un d''eux prélève des échantillons d''air après l''essai nucléaire chinois de 1966. Utilisé en première ligne jusque dans les années 1970, il passe ensuite en grand nombre à l''Aeroflot comme cargo.\n\n## Place dans l''histoire\nAprès une série d''accidents au début des années 1990, l''An-8 est retiré en Russie, mais plusieurs exemplaires volent encore au Moyen-Orient et en Afrique, au Liberia, en RD Congo et en Angola, jusque vers 2010, souvent pour des compagnies liées au trafiquant d''armes **Viktor Bout** — alors qu''Antonov a retiré son certificat de navigabilité en 2004. Le bureau Antonov en a ensuite tiré l''**An-10**, et son aile haute, son train en carénages et sa rampe arrière restent la signature de ses cargos.',
    E'## Genesis\nIn December 1951 the OKB-153 design bureau began work on a twin-engined assault transport, the DT-5/8, with a large rear door so that vehicles could drive straight in. On 11 December 1953 the Soviet Council of Ministers ordered the Antonov bureau to build a twin-turboprop aircraft derived from it. The prototype, known as Izdeliye P, flew on 11 February 1956 from Sviatoshyn airfield in Kyiv and made its public debut at the Tushino air display on 18 August that year.\n\n## Design\nWith a high wing, a rectangular-section fuselage, main gear in side pods and an upswept rear fuselage to clear the loading area, the An-8 carried 60 troops, ASU-57 assault guns or BTR-40 and BTR-152 armoured personnel carriers. State acceptance trials nonetheless revealed serious faults: dangerous spin behaviour, oscillations in all three axes, and **TV-2** engines that were unstable at altitude and hard to start. Antonov enlarged the tail surfaces, added anti-spin strakes, deleted the leading-edge slats and switched to **Ivchenko AI-20D** turboprops, which cut three tonnes from the empty weight. A tail turret with a 23 mm cannon, a chin radome and a glazed navigator''s nose completed the aircraft.\n\n## Operational career\nBuilt at Tashkent from 1957 to 1961, 151 An-8s were produced to replace the **Lisunov Li-2**, the Soviet-built DC-3, and most served with the Soviet Air Forces. In 1968 two of them landed the special forces sent to seize Plzeň airport during the invasion of Czechoslovakia. Others were converted for electronic reconnaissance, and one sampled the air after the Chinese nuclear test of 1966. Used on frontline duties into the 1970s, many were then transferred to Aeroflot as freighters.\n\n## Place in history\nAfter a series of accidents in the early 1990s the An-8 was withdrawn in Russia, but several kept flying in the Middle East and Africa, in Liberia, the DR Congo and Angola, until around 2010, often for airlines linked to the arms dealer **Viktor Bout**, even though Antonov had withdrawn its airworthiness certificate in 2004. The Antonov bureau went on to develop it into the **An-10**, and its high wing, podded gear and rear ramp remain the signature of the bureau''s freighters.',
    (SELECT id FROM countries WHERE code = 'UKR'),
    '1951-12-01',
    '1956-02-11',
    '1958-01-01',
    610,
    2780,
    (SELECT id FROM manufacturer WHERE code = 'ANT'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-8'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-8'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Antonov An-8'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 26,
  wingspan          = 30,
  height            = 9.7,
  wing_area         = 117.2,
  empty_weight      = 21250,
  mtow              = 40000,
  service_ceiling   = 9600,
  climb_rate        = 7.12,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 6,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-20D (5 180 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1961,
  units_built       = 151,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Izdeliye P** : premier prototype, à moteurs Kuznetsov TV-2\n- **An-8** : version de série militaire, tourelle de queue de 23 mm, 48 hommes en configuration troupes\n- **An-8T** : transporteur de carburants, y compris de comburants pour fusées\n- **An-8RU** : un appareil doté en 1964 de fusées d''appoint au décollage, abandonné après l''écrasement du prototype\n- **Izdeliye N** : projet d''avion de ligne pressurisé de 57 places, non retenu par l''Aeroflot',
  variants_en       = E'- **Izdeliye P**: first prototype, with Kuznetsov TV-2 engines\n- **An-8**: military production version, 23 mm tail turret, 48 men in troop configuration\n- **An-8T**: fuel carrier, including rocket oxidisers\n- **An-8RU**: one aircraft fitted in 1964 with rocket boosters for take-off, abandoned after the prototype crashed\n- **Izdeliye N**: projected 57-seat pressurised airliner, not adopted by Aeroflot',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Antonov_An-8',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Antonov_An-8',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Antonov An-8';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Antonov An-8';
