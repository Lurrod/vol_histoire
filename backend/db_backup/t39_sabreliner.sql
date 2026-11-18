-- North American T-39 Sabreliner
--
-- Photo : 330-CFD-DN-SC-04-10893 (22471810566).jpg
--   licence Public domain — National Museum of the U.S. Navy
--   https://commons.wikimedia.org/wiki/File:330-CFD-DN-SC-04-10893_(22471810566).jpg

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
    'North American T-39 Sabreliner',
    'North American T-39 Sabreliner',
    'North American T-39 Sabreliner',
    'North American T-39 Sabreliner',
    'Biréacteur de liaison et d''école né de l''aile du F-86, seul avion d''affaires autorisé à la voltige',
    'Liaison and training twinjet born of the F-86''s wing, the only business jet cleared for aerobatics',
    '/assets/airplanes/t39-sabreliner.jpg',
    E'## Genèse\nEn août 1956, l''US Air Force publie deux spécifications pour de petits avions à réaction de soutien : l''**UTX**, biréacteur d''entraînement et de liaison, et l''UCX, plus gros. **North American** conçoit sur ses fonds propres un fuselage pressurisé auquel il greffe une aile, un empennage et des commandes dérivés de son chasseur **F-86 Sabre**, d''où le nom de Sabreliner. Le prototype NA-265 vole le 16 septembre 1958 et l''USAF passe sa première commande de série en janvier 1959 ; face à lui, Lockheed avait proposé une version biréacteur du **JetStar**.\n\n## Conception\nConstruit aux normes militaires de résistance, le Sabreliner est robuste et relativement lourd : revêtement d''aile usiné et boulonné, becs de bord d''attaque mus par la seule aérodynamique, seuil de porte surélevé pour ralentir l''entrée d''eau en cas d''amerrissage. Il reste le seul avion d''affaires autorisé à la voltige. Le T-39A de série reçoit deux turboréacteurs Pratt & Whitney J60 de 13,3 kN. La Navy en fait une salle de classe volante : ses T-39D embarquent le radar **AN/APQ-94** du F-8 Crusader ou l''APQ-126 de l''A-7 pour former navigateurs d''interception et bombardiers-navigateurs.\n\n## Carrière opérationnelle\nL''USAF reçoit 143 T-39A et 6 T-39B ; avec ceux de la Navy et du Marine Corps, 200 T-39 sont construits sur plus de 800 Sabreliner. Au Vietnam, à partir de la fin de 1965, ils remplacent les B-57 pour acheminer vers Saigon le fret urgent, dont les films des missions de reconnaissance. Le 28 janvier 1964, un T-39 égaré au-dessus de l''Allemagne de l''Est est abattu par un MiG-19 soviétique ; ses trois occupants sont tués. Les T-39 de l''USAF fondent dans les années 1980, de 135 en 1983 à 22 en 1985, au moment où arrivent les **C-21** Learjet ; les derniers partent en 2002. La Navy les garde pour former ses officiers navigants.\n\n## Place dans l''histoire\nPremier jet d''affaires d''un constructeur de chasseurs, le Sabreliner montre qu''un avion militaire de soutien peut devenir un produit civil : les trois quarts de la production partent vers des clients privés. Exporté en petit nombre vers l''Argentine, la Bolivie, l''Équateur, le Mexique et la Suède, il connaît aussi des carrières inattendues : un ancien T-39A racheté en 1992 a servi à **Oussama ben Laden** au Soudan. Sa solidité en fait encore un avion d''entraînement au rétablissement depuis des positions inusuelles.',
    E'## Genesis\nIn August 1956 the US Air Force issued two specifications for small jet support aircraft: **UTX**, a twin-jet trainer and liaison aircraft, and the larger UCX. **North American** designed, with its own money, a pressurised fuselage onto which it grafted a wing, tail and controls derived from its **F-86 Sabre** fighter, hence the name Sabreliner. The NA-265 prototype flew on 16 September 1958 and the USAF placed its first production order in January 1959; Lockheed had offered a twin-engined **JetStar** against it.\n\n## Design\nBuilt to military strength standards, the Sabreliner is rugged and relatively heavy: a milled, bolted wing skin, leading-edge slats moved by aerodynamic forces alone, and a raised doorsill to slow water ingress after a ditching. It remains the only business jet cleared for aerobatics. The production T-39A received two 13.3 kN Pratt & Whitney J60 turbojets. The Navy turned it into a flying classroom: its T-39Ds carried the F-8 Crusader''s **AN/APQ-94** radar or the A-7''s APQ-126 to train radar intercept officers and bombardier/navigators.\n\n## Operational career\nThe USAF received 143 T-39As and 6 T-39Bs; with those of the Navy and Marine Corps, 200 T-39s were built out of more than 800 Sabreliners. In Vietnam, from late 1965, they replaced B-57s to carry urgent cargo to Saigon, including film from reconnaissance missions. On 28 January 1964 a T-39 that had strayed over East Germany was shot down by a Soviet MiG-19, killing its three occupants. The USAF''s T-39 fleet shrank in the 1980s, from 135 in 1983 to 22 in 1985, as the **C-21** Learjets arrived; the last left in 2002. The Navy kept them to train its naval flight officers.\n\n## Place in history\nThe first business jet from a fighter manufacturer, the Sabreliner showed that a military support aircraft could become a civil product: three quarters of production went to private customers. Exported in small numbers to Argentina, Bolivia, Ecuador, Mexico and Sweden, it also had unexpected careers: a former T-39A bought in 1992 was used by **Osama bin Laden** in Sudan. Its strength still makes it a mount for upset-recovery training.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1956-08-01',
    '1958-09-16',
    '1962-01-01',
    885,
    4020,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'North American T-39 Sabreliner'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'North American T-39 Sabreliner'), (SELECT id FROM tech WHERE name = 'Radar AN/APQ-94'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'North American T-39 Sabreliner'), (SELECT id FROM missions WHERE name = 'Entraînement au combat')),
((SELECT id FROM airplanes WHERE name = 'North American T-39 Sabreliner'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'North American T-39 Sabreliner'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.41,
  wingspan          = 13.56,
  height            = 4.88,
  wing_area         = 31.79,
  empty_weight      = 4199,
  mtow              = 8056,
  service_ceiling   = 12200,
  climb_rate        = NULL,
  g_limit_pos       = 3.0,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J60-P-3',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.3,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1959,
  production_end    = NULL,
  units_built       = 200,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 6,
  variants          = E'- **T-39A** : entraînement au pilotage et liaison pour l''USAF, deux J60, 143 construits ; certains deviennent CT-39A de transport\n- **T-39B** : école radar de l''USAF dotée de l''avionique du F-105D, six construits\n- **T-39D** : école radar de la Navy (ex-T3J-1) avec radar AN/APQ-94 ou AN/APQ-126, 42 livrés à partir de 1963\n- **CT-39E / CT-39G** : transports de la Navy, le second sur le fuselage allongé du Sabreliner 60 avec inverseurs de poussée\n- **T-39F** : T-39A convertis pour former les équipages Wild Weasel du F-105G\n- **T-39G / T-39N** : écoles de la Navy pour la formation des officiers navigants',
  variants_en       = E'- **T-39A**: USAF pilot proficiency trainer and utility transport, two J60s, 143 built; some became CT-39A transports\n- **T-39B**: USAF radar trainer with F-105D avionics, six built\n- **T-39D**: Navy radar trainer (ex-T3J-1) with AN/APQ-94 or AN/APQ-126 radar, 42 delivered from 1963\n- **CT-39E / CT-39G**: Navy transports, the latter on the stretched Sabreliner 60 fuselage with thrust reversers\n- **T-39F**: T-39As converted to train F-105G Wild Weasel crews\n- **T-39G / T-39N**: Navy trainers for naval flight officer training',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_Sabreliner',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_Sabreliner',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy (National Museum of the U.S. Navy)',
  image_licence     = 'Public domain'
WHERE name = 'North American T-39 Sabreliner';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'North American T-39 Sabreliner';
