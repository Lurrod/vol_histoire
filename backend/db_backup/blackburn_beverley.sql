-- Blackburn B-101 Beverley
--
-- Photo : XH124 Blackburn B-101 Beverley C1 RAF Hendon Museum (55241598596).jpg
--   licence CC BY-SA 4.0 — Colin Cooke Photo
--   https://commons.wikimedia.org/wiki/File:XH124_Blackburn_B-101_Beverley_C1_RAF_Hendon_Museum_(55241598596).jpg

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
    'Blackburn Beverley',
    'Blackburn Beverley',
    'Blackburn B-101 Beverley',
    'Blackburn B-101 Beverley',
    'Le gros porteur à train fixe de la RAF, taillé pour les pistes en terre d''Aden et du Kenya',
    'The RAF''s fixed-undercarriage heavy lifter, built for the dirt strips of Aden and Kenya',
    '/assets/airplanes/blackburn-beverley.jpg',
    E'## Genèse\nLe Beverley naît chez General Aircraft, dont l''ingénieur en chef **F. F. Crocombe** réfléchit dès 1939 à un avion conçu pour les charges encombrantes. L''expérience du planeur **Hamilcar** nourrit une étude achevée en 1945, puis le ministère de l''Air publie la spécification C.3/46 : un transport tactique capable de larguer parachutistes et charges lourdes et d''évacuer des blessés. Le projet, baptisé GAL.60 Universal Freighter, passe à Blackburn lors de la fusion des deux sociétés. Le prototype vole le 20 juin 1950 depuis Brough : c''est alors le deuxième plus grand avion terrestre britannique, après le Bristol Brabazon.\n\n## Conception\nMonoplan à aile haute et train fixe, le Beverley privilégie la simplicité : ni pressurisation, ni circuit pneumatique. Sa soute de 11 m et de 170 m³ accueille 94 soldats, auxquels s''ajoutent 36 places dans la poutre de queue, d''où les parachutistes sautent par une trappe. Neuf véhicules de type Jeep ou un bulldozer y entrent par des portes arrière à coquille. Quatre moteurs en étoile **Bristol Centaurus** de 2 850 ch entraînent des hélices à pas réversible : l''avion se pose court et recule par ses propres moyens. De gros pneus basse pression lui ouvrent les pistes sommaires.\n\n## Carrière opérationnelle\nLe premier Beverley C.1 rejoint le No. 47 Squadron à Abingdon le 12 mars 1956 ; il est alors le plus gros avion de la RAF. Six escadrons du Transport Command l''utilisent, en Allemagne, au Kenya contre la révolte des Mau Mau, à Bahreïn, à Singapour ou pour des secours au Sud-Vietnam. Basé à Khormaksar, le No. 84 Squadron transporte et largue du ravitaillement aux forces britanniques et saoudiennes pendant l''**urgence d''Aden**, puis apporte un soutien logistique décisif pendant la révolte de Brunei en 1962. « Comme sorti de l''arche de Noé, mais un superbe largueur de ravitaillement », résume l''Air Chief Marshal **Sir Robert Freer**.\n\n## Place dans l''histoire\nSeul avion de transport terrestre construit par Blackburn, spécialiste des avions embarqués, le Beverley n''a jamais trouvé de client civil, malgré un projet de transbordeur de voitures pour Silver City Airways. Les 49 exemplaires construits jusqu''en 1958 ont pourtant montré ce que valait un gros porteur tactique capable de se poser sur des terrains sommaires. Les derniers quittent le service en août 1967, quand le No. 84 Squadron les échange contre le plus petit **Hawker Siddeley Andover**.',
    E'## Genesis\nThe Beverley was born at General Aircraft, whose chief designer **F. F. Crocombe** had been working from 1939 on an aircraft built for bulky loads. Experience with the **Hamilcar** glider fed a design study completed in 1945, after which the Air Ministry issued Specification C.3/46: a tactical transport able to air-drop paratroops and heavy loads and to evacuate casualties. The project, named the GAL.60 Universal Freighter, passed to Blackburn when the two companies merged. The prototype flew from Brough on 20 June 1950: at the time it was Britain''s second largest landplane, after the Bristol Brabazon.\n\n## Design\nA high-wing monoplane with fixed undercarriage, the Beverley put simplicity first: no pressurisation and no pneumatics. Its 11 m, 170 m³ hold took 94 troops, with another 36 seats in the tailboom, from which paratroopers jumped through a floor hatch. Nine Jeep-type vehicles or a bulldozer entered through rear clamshell doors. Four **Bristol Centaurus** radial engines of 2,850 hp drove reversible-pitch propellers, so the aircraft could land short and back up under its own power. Large low-pressure tyres opened up rough strips to it.\n\n## Operational career\nThe first Beverley C.1 joined No. 47 Squadron at Abingdon on 12 March 1956; it was then the largest aircraft in the RAF. Six Transport Command squadrons flew it, to Germany, to Kenya against the Mau Mau rebellion, to Bahrain, to Singapore and on relief flights to South Vietnam. Based at Khormaksar, No. 84 Squadron airlifted and air-dropped supplies to British and Saudi forces during the **Aden Emergency**, then provided crucial logistical support during the 1962 Brunei revolt. "Like something out of the Ark, but it was a superb supply dropper," said Air Chief Marshal **Sir Robert Freer**.\n\n## Place in history\nThe only land-based transport built by Blackburn, a specialist in naval aircraft, the Beverley never found a civil customer, despite a car-ferry project for Silver City Airways. The 49 aircraft built up to 1958 nonetheless showed the worth of a heavy tactical transport able to land on rough fields. The last left service in August 1967, when No. 84 Squadron exchanged them for the smaller **Hawker Siddeley Andover**.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1945-01-01',
    '1950-06-20',
    '1956-03-12',
    383,
    6370,
    (SELECT id FROM manufacturer WHERE code = 'BLK'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Beverley'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Beverley'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Beverley'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Blackburn Beverley'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Blackburn Beverley'), (SELECT id FROM wars WHERE name = 'Urgence d''Aden'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 30.3,
  wingspan          = 49.38,
  height            = 11.81,
  wing_area         = 270.9,
  empty_weight      = 35938,
  mtow              = 61235,
  service_ceiling   = 4900,
  climb_rate        = 3.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Bristol Centaurus 173 (2 850 ch)',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1958,
  units_built       = 49,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **GAL.60 Universal Freighter Mk.1** : premier prototype de General Aircraft, à moteurs Bristol Hercules\n- **GAL.65 Universal Freighter Mk.2 (B-100)** : second prototype à moteurs Centaurus et portes arrière à coquille, premier vol le 14 juin 1953\n- **Beverley C.1 (B-101)** : transport tactique de série pour la RAF, 47 exemplaires\n- **B-107 / B-107A** : projets de 1956 et 1959 à fuselage rond et turbopropulseurs Tyne, restés sur la planche',
  variants_en       = E'- **GAL.60 Universal Freighter Mk.1**: first General Aircraft prototype, with Bristol Hercules engines\n- **GAL.65 Universal Freighter Mk.2 (B-100)**: second prototype with Centaurus engines and rear clamshell doors, first flown on 14 June 1953\n- **Beverley C.1 (B-101)**: production tactical transport for the RAF, 47 built\n- **B-107 / B-107A**: 1956 and 1959 projects with a rounded fuselage and Tyne turboprops, never built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Blackburn_Beverley',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Blackburn_Beverley',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Colin Cooke Photo',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Blackburn Beverley';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Blackburn Beverley';
