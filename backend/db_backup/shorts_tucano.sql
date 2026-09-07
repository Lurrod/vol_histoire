-- Short Tucano T.1
--
-- Photo : Short tucano t1 zf210 flying arp.jpg
--   licence Public domain — Adrian Pingstone
--   https://commons.wikimedia.org/wiki/File%3AShort_tucano_t1_zf210_flying_arp.jpg

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
    'Shorts Tucano',
    'Shorts Tucano',
    'Short Tucano T.1',
    'Short Tucano T.1',
    'Un Embraer brésilien reconstruit à Belfast pour la RAF',
    'A Brazilian Embraer rebuilt in Belfast for the RAF',
    '/assets/airplanes/shorts-tucano.jpg',
    E'## Genèse\nLa RAF forme depuis 1955 sur **Jet Provost**, et cherche en 1984 un remplaçant à turbopropulseur — même raisonnement économique que partout ailleurs. La compétition oppose le **Pilatus PC-9** suisse et l''**Embraer Tucano** brésilien. Le Tucano l''emporte, à une condition politique : être construit au Royaume-Uni, à Belfast, par Short Brothers.\n\n## Conception\nShort ne se contente pas d''assembler. Le turbopropulseur PT6 brésilien est remplacé par un **Garrett TPE331** de mille cent chevaux, la structure est renforcée pour doubler la durée de vie en fatigue, la verrière est redessinée et l''avionique refaite. Il ne reste que la moitié des pièces du Tucano d''origine — assez peu pour que la RAF le désigne autrement.\n\n## Carrière opérationnelle\nCent trente exemplaires. Il forme les pilotes britanniques de 1989 à **2019**, trente ans, notamment ceux qui piloteront Tornado, Harrier et Typhoon. Le **Kenya** en achète douze et le **Koweït** seize. Un Tucano est immobilisé au sol en 2019 pour devenir le premier appareil d''essais de la RAF sur carburant durable.\n\n## Place dans l''histoire\nCent trente exemplaires. Le Tucano T.1 illustre une pratique constante des marchés d''armement européens : acheter le meilleur appareil disponible à condition de le fabriquer chez soi. Le **T-6 Texan II** américain qui lui succède est lui-même un **Pilatus PC-9** américanisé selon le même principe.',
    E'## Genesis\nThe RAF had trained on the **Jet Provost** since 1955 and in 1984 sought a turboprop replacement — the same economic reasoning as everywhere else. The competition set the Swiss **Pilatus PC-9** against the Brazilian **Embraer Tucano**. The Tucano won, on one political condition: it had to be built in the United Kingdom, at Belfast, by Short Brothers.\n\n## Design\nShort did not merely assemble. The Brazilian PT6 turboprop was replaced by an eleven-hundred-horsepower **Garrett TPE331**, the structure strengthened to double fatigue life, the canopy redrawn and the avionics remade. Only half the original Tucano''s parts remain — few enough for the RAF to designate it differently.\n\n## Operational career\nOne hundred and thirty built. It trained British pilots from 1989 to **2019**, thirty years, including those who would fly the Tornado, Harrier and Typhoon. **Kenya** bought twelve and **Kuwait** sixteen. One Tucano was grounded in 2019 to become the RAF''s first sustainable-fuel test aircraft.\n\n## Place in history\nOne hundred and thirty built. The Tucano T.1 illustrates a constant practice of European arms procurement: buy the best available aircraft on condition of building it at home. The American **T-6 Texan II** that succeeded it is itself an Americanised **Pilatus PC-9** on the same principle.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1984-01-01',
    '1986-02-14',
    '1989-06-01',
    507.0,
    1916.0,
    (SELECT id FROM manufacturer WHERE code = 'SHO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Shorts Tucano'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Shorts Tucano'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.86,
  wingspan          = 11.28,
  height            = 3.4,
  wing_area         = 19.4,
  empty_weight      = 1800,
  mtow              = 3175,
  service_ceiling   = 10400,
  climb_rate        = 17.8,
  g_limit_pos       = 7.0,
  g_limit_neg       = -3.5,
  combat_radius     = 600,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett TPE331-12B',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1986,
  production_end    = 1993,
  units_built       = 130,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Tucano T.1** : version RAF, cent trente exemplaires\n- Dérivé de l''**Embraer EMB-312 Tucano** brésilien, profondément remanié\n- Moteur **Garrett** de 1 100 ch au lieu du PT6 de 750 ch : soixante pour cent de plus\n- Cellule renforcée pour une **durée de vie de 12 000 heures**, contre 8 000 à l''origine\n- Retiré en **2019**, remplacé par le **Beechcraft T-6 Texan II**',
  variants_en       = E'- **Tucano T.1** : RAF version, one hundred and thirty aircraft\n- Derived from the Brazilian **Embraer EMB-312 Tucano**, heavily reworked\n- **Garrett** engine of 1,100 hp instead of the 750 hp PT6: sixty per cent more\n- Airframe strengthened for a **12,000-hour life**, against 8,000 originally\n- Retired in **2019**, replaced by the **Beechcraft T-6 Texan II**',

  -- Strate 4 : qualitatif
  nickname          = 'Tucano',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Short_Tucano',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Short_Tucano',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Adrian Pingstone',
  image_licence     = 'Public domain'
WHERE name = 'Shorts Tucano';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Shorts Tucano';
