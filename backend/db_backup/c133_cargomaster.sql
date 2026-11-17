-- Douglas C-133 Cargomaster
--
-- Photo : The last flying C-133A Cargomaster.jpg
--   licence Public domain — Kristen Rohrer, U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:The_last_flying_C-133A_Cargomaster.jpg

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
    'Douglas C-133 Cargomaster',
    'Douglas C-133 Cargomaster',
    'Douglas C-133 Cargomaster',
    'Douglas C-133 Cargomaster',
    'Le seul transport stratégique à turbopropulseurs de l''US Air Force, porteur des missiles balistiques',
    'The US Air Force''s only turboprop strategic airlifter, carrier of its ballistic missiles',
    '/assets/airplanes/c133-cargomaster.jpg',
    E'## Genèse\nAu milieu des années 1950, l''US Air Force cherche un transport stratégique capable d''emporter ce que le **C-124 Globemaster II** ne peut pas charger : son plancher perché à 4 m du sol et sa puissance limitée excluent bien des cargaisons. Douglas répond au programme SS402L avec un appareil très différent du C-74 et du C-124. Le dessin est figé dès 1955 et la production lancée directement, sans prototype : le premier **C-133A** vole le 23 avril 1956 et rejoint le Military Air Transport Service en août 1957. Deux C-133 battent des records de vitesse transatlantiques pour avions de transport dès leurs premiers vols vers l''Europe.\n\n## Conception\nL''aile est haute, le train d''atterrissage logé dans des carénages latéraux, et des portes arrière et latérales ouvrent sur une soute de 27 m de long et 3,7 m de haut, pressurisée, chauffée et ventilée. Quatre turbopropulseurs **Pratt & Whitney T34** de 7 500 ch à injection d''eau en font le seul transport stratégique à turbopropulseurs produit en série pour l''US Air Force. Sur le **C-133B**, les portes arrière s''ouvrent en pétales, ce qui facilite le chargement des missiles balistiques intercontinentaux.\n\n## Carrière opérationnelle\nPendant des années, le Cargomaster est le seul avion de l''US Air Force capable de transporter des charges très volumineuses ou très lourdes. Il achemine plusieurs centaines de missiles **Atlas**, **Titan** et **Minuteman** vers leurs bases, livre à Cap Canaveral les lanceurs des programmes Mercury, Gemini et Apollo, puis rapatrie les capsules Apollo après leur amerrissage. Les cinquante appareils se révèlent précieux pendant la **guerre du Vietnam**. En décembre 1958, un C-133A hisse 53 480 kg à 3 000 m, seul record homologué par la FAI. Mais neuf avions s''écrasent et un dixième brûle au sol : les équipages le surnomment « widowmaker », le faiseur de veuves.\n\n## Place dans l''histoire\nDe fortes vibrations corrodent les cellules : prévues pour 10 000 heures puis prolongées à 19 000, elles sont usées au début des années 1970. L''US Air Force retire tous ses C-133 en 1971, à l''arrivée du **C-5 Galaxy**, et la plupart sont découpés à Davis-Monthan dans les mois qui suivent. Un exemplaire vole encore en Alaska jusqu''au milieu des années 2000 avant de rejoindre, en août 2008, le musée de Travis. Construit à cinquante exemplaires, le Cargomaster a porté la logistique des missiles balistiques et des premiers vols spatiaux américains.',
    E'## Genesis\nIn the mid-1950s the US Air Force wanted a strategic transport able to carry what the **C-124 Globemaster II** could not: its cargo deck 4 m off the ground and its limited power ruled out many loads. Douglas answered the SS402L programme with an aircraft very different from the C-74 and C-124. The design was frozen by 1955 and production launched directly, with no prototype: the first **C-133A** flew on 23 April 1956 and joined the Military Air Transport Service in August 1957. Two C-133s set transatlantic speed records for transport aircraft on their first flights to Europe.\n\n## Design\nThe wing was mounted high, the landing gear housed in side blisters, and rear and side doors opened onto a hold 27 m long and 3.7 m high, pressurised, heated and ventilated. Four 7,500 hp **Pratt & Whitney T34** turboprops with water injection made it the US Air Force''s only production turboprop strategic airlifter. On the **C-133B** the rear doors opened sideways like petals, making it much easier to load intercontinental ballistic missiles.\n\n## Operational career\nFor years the Cargomaster was the only US Air Force aircraft able to haul very large or very heavy cargo. It flew several hundred **Atlas**, **Titan** and **Minuteman** missiles to and from their bases, delivered launch boosters for the Mercury, Gemini and Apollo programmes to Cape Canaveral, and airlifted the Apollo capsules home after splashdown. The fifty aircraft proved invaluable during the **Vietnam War**. In December 1958 a C-133A lifted 53,480 kg to 3,000 m, its only officially sanctioned FAI record. Yet nine aircraft crashed and a tenth burned on the ground: crews called it the "widowmaker".\n\n## Place in history\nSevere vibration corroded the airframes: designed for 10,000 hours and extended to 19,000, they were worn out by the early 1970s. The US Air Force withdrew every C-133 in 1971 as the **C-5 Galaxy** arrived, and most were cut up at Davis-Monthan within months. One aircraft kept flying in Alaska until the mid-2000s before joining the Travis museum in August 2008. Built in just fifty examples, the Cargomaster carried the logistics of America''s ballistic missiles and of its first spaceflights.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1956-04-23',
    '1957-08-01',
    578,
    6590,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-133 Cargomaster'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-133 Cargomaster'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Douglas C-133 Cargomaster'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'Douglas C-133 Cargomaster'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 47.01,
  wingspan          = 54.78,
  height            = 14.7,
  wing_area         = 248.3,
  empty_weight      = 54550,
  mtow              = 129727,
  service_ceiling   = 9130,
  climb_rate        = 6.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney T34-P-9W (7 500 ch)',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1956,
  production_end    = 1961,
  units_built       = 50,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **C-133A** : première version, produite directement en série sans prototype, 35 exemplaires\n- **C-133B** : portes arrière en pétales pour le chargement des missiles balistiques, 15 exemplaires\n- **Cellules d''essai** : un C-133A et un C-133B conservés chez Douglas à Long Beach, sans numéro de série\n- **N199AB** : C-133A exploité après sa réforme comme cargo gouvernemental en Alaska, jusqu''à son dernier vol en 2008',
  variants_en       = E'- **C-133A**: first version, put straight into production without a prototype, 35 built\n- **C-133B**: petal-type rear doors for loading ballistic missiles, 15 built\n- **Test articles**: one C-133A and one C-133B kept by Douglas at Long Beach, without serial numbers\n- **N199AB**: C-133A flown after retirement as a government freighter in Alaska, until its last flight in 2008',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_C-133_Cargomaster',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_C-133_Cargomaster',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Kristen Rohrer, U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'Douglas C-133 Cargomaster';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Douglas C-133 Cargomaster';
