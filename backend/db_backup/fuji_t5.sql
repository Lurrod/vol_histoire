-- Fuji T-5 (KM-2Kai)
--
-- Photo : T-5 Ozuki (22103680772).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:T-5_Ozuki_(22103680772).jpg

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
    'Fuji T-5',
    'Fuji T-5',
    'Fuji T-5 (KM-2Kai)',
    'Fuji T-5 (KM-2Kai)',
    'Dernier descendant japonais du T-34 Mentor, passé à la turbine pour former les pilotes de la marine',
    'The last Japanese descendant of the T-34 Mentor, converted to turbine power to train naval pilots',
    '/assets/airplanes/fuji-t5.jpg',
    E'## Genèse\nPour l''instruction élémentaire de ses pilotes, la **Force maritime d''autodéfense japonaise** utilise le **Fuji KM-2**, un avion à pistons lui-même dérivé du **T-34 Mentor** américain. Pour préparer sa relève, **Fuji Heavy Industries** choisit de garder la cellule : elle remplace le moteur Lycoming d''un KM-2 par un turbopropulseur **Allison Model 250**. L''appareil obtenu, le **KM-2D**, vole pour la première fois le 28 juin 1984 et reçoit sa certification le 14 février 1985. Il conserve toutefois les portières latérales du KM-2, ouvertes comme celles d''une automobile.\n\n## Conception\nLe **KM-2Kai** pousse l''évolution plus loin avec un poste de pilotage modernisé, où l''élève et l''instructeur sont assis côte à côte sous une verrière coulissante qui remplace les portières. C''est un monoplan à aile basse cantilever entièrement métallique, à train tricycle escamotable, dont l''Allison 250-B17D de 350 ch entraîne une hélice tripale à vitesse constante. Il atteint 357 km/h à 2 440 m d''altitude, monte à 8,6 m/s, plafonne à 7 620 m et franchit 945 km. La version de voltige porte deux sièges à doubles commandes, la version utilitaire quatre sièges disposés par paires.\n\n## Carrière opérationnelle\nLa marine japonaise commande le KM-2Kai en mars 1987 sous la désignation **T-5**, et les livraisons commencent en 1988. Quarante exemplaires sont construits pour ce seul client. Les T-5 servent au **201e escadron d''instruction aérienne**, sur la base d''Ozuki, où les futurs pilotes de la marine reçoivent leurs premières leçons de vol. Le KM-2 d''origine, qu''il a remplacé, n''est plus en service.\n\n## Place dans l''histoire\nLe T-5 est l''aboutissement d''une filiation ouverte par le **T-34 Mentor** : un Mentor transformé en KM-2, puis un KM-2 remotorisé, enfin une cabine entièrement repensée. Fuji a ainsi fait évoluer pas à pas une même formule plutôt que de dessiner un avion neuf, et la même famille compte aussi, chez lui, les écoles T-3 et **Fuji T-7**. Toujours en service plus de trente-cinq ans après les premières livraisons, le T-5 donne encore aux élèves de la marine leurs premières heures de vol. La marine en aligne même une patrouille de démonstration, les **White Arrows**, qui présente ces avions en formation.',
    E'## Genesis\nFor the elementary training of its pilots, the **Japan Maritime Self-Defense Force** used the **Fuji KM-2**, a piston-engined aircraft itself derived from the American **T-34 Mentor**. To prepare its successor, **Fuji Heavy Industries** chose to keep the airframe: it replaced a KM-2''s Lycoming engine with an **Allison Model 250** turboprop. The resulting **KM-2D** flew for the first time on 28 June 1984 and was certified on 14 February 1985. It kept, however, the KM-2''s side doors, opening like those of a car.\n\n## Design\nThe **KM-2Kai** took the evolution further with a modernised cockpit, in which student and instructor sat side by side under a sliding canopy that replaced the doors. It is an all-metal cantilever low-wing monoplane with a retractable tricycle undercarriage, its 350 hp Allison 250-B17D driving a three-blade constant-speed propeller. It reached 357 km/h at 2,440 m, climbed at 8.6 m/s, had a ceiling of 7,620 m and a range of 945 km. The aerobatic version had two seats with dual controls, the utility version four seats in pairs.\n\n## Operational career\nThe Japanese navy ordered the KM-2Kai in March 1987 as the **T-5**, and deliveries began in 1988. Forty were built for this single customer. The T-5s serve with the **201st Air Training Squadron** at Ozuki, where future naval pilots receive their first flying lessons. The original KM-2, which it replaced, is no longer in service.\n\n## Place in history\nThe T-5 is the culmination of a lineage opened by the **T-34 Mentor**: a Mentor turned into the KM-2, then a re-engined KM-2, and finally a completely redesigned cabin. Fuji thus developed one formula step by step rather than designing a new aircraft, and the same family also includes its T-3 and **Fuji T-7** trainers. Still in service more than thirty-five years after the first deliveries, the T-5 continues to give naval students their first flying hours. The navy even fields a display team with it, the **White Arrows**, which shows these aircraft in formation.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    NULL,
    '1984-06-28',
    '1988-01-01',
    357,
    945,
    (SELECT id FROM manufacturer WHERE code = 'FUJ'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-5'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Fuji T-5'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fuji T-5'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.4,
  wingspan          = 10.0,
  height            = 2.9,
  wing_area         = 16.5,
  empty_weight      = 1082,
  mtow              = 1805,
  service_ceiling   = 7620,
  climb_rate        = 8.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Allison 250-B17D (350 ch)',
  engine_count      = 1,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1988,
  production_end    = NULL,
  units_built       = 40,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **KM-2** : école à pistons dérivée du T-34 Mentor, prédécesseur du T-5\n- **KM-2D** : KM-2 remotorisé par un turbopropulseur Allison 250, premier vol le 28 juin 1984, portières latérales conservées\n- **KM-2Kai** : poste côte à côte modernisé sous verrière coulissante, version biplace de voltige ou quadriplace utilitaire\n- **T-5** : désignation du KM-2Kai dans la Force maritime d''autodéfense, 40 exemplaires livrés à partir de 1988',
  variants_en       = E'- **KM-2**: piston trainer derived from the T-34 Mentor, the T-5''s predecessor\n- **KM-2D**: KM-2 re-engined with an Allison 250 turboprop, first flown on 28 June 1984, side doors retained\n- **KM-2Kai**: modernised side-by-side cockpit under a sliding canopy, two-seat aerobatic or four-seat utility version\n- **T-5**: designation of the KM-2Kai in the Maritime Self-Defense Force, 40 delivered from 1988',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fuji_T-5',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert from Holland',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Fuji T-5';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fuji T-5';
