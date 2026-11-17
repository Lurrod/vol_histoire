-- Vought F6U Pirate
--
-- Photo : Vought F6U-1 Pirate BuNo 122481 over NATC Patuxent River.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:Vought_F6U-1_Pirate_BuNo_122481_over_NATC_Patuxent_River.jpg

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
    'F6U Pirate',
    'F6U Pirate',
    'Vought F6U Pirate',
    'Vought F6U Pirate',
    'Premier jet de Vought et premier chasseur de l''US Navy à postcombustion, jugé inapte au combat',
    'Vought''s first jet and the US Navy''s first afterburning fighter, judged unfit for combat',
    '/assets/airplanes/f6u-pirate.jpg',
    E'## Genèse\nLe 5 septembre 1944, le Bureau of Aeronautics de l''US Navy demande un chasseur embarqué monoplace propulsé par le nouveau turboréacteur axial **Westinghouse 24C**, futur J34. **Chance Vought** obtient le 29 décembre 1944 un contrat pour trois prototypes V-340. Un concours interne à l''entreprise lui donne son nom, **Pirate**, et le premier prototype vole le 2 octobre 1946. C''est le premier avion à réaction du constructeur.\n\n## Conception\nLe XF6U est un petit chasseur à aile et empennages droits, à train tricycle, dont le réacteur logé à l''arrière respire par des entrées d''air à l''emplanture des ailes. Assez courtes pour se passer de repliage, celles-ci portent des réservoirs largables en bout. Son originalité tient au revêtement en **Metalite**, du balsa pris entre deux fines tôles d''aluminium, et au **Fabrilite** à base de fibre de verre de la dérive. Quatre canons de 20 mm sont logés sous le cockpit. Sous-motorisé, l''avion souffre aussi de graves défauts aérodynamiques ; le troisième prototype, allongé de 2,4 m, reçoit en 1947 un J34-WE-30 à **postcombustion**, une première pour un chasseur de l''US Navy.\n\n## Carrière opérationnelle\nTrente avions de série sont commandés en 1947, avant même la fin des essais, avec siège éjectable, dérive redessinée et deux dérives auxiliaires sur l''empennage. Le transfert de l''usine Vought de Stratford à Dallas désorganise la production : les cellules partent par camion au Texas, puis à Ardmore, dans l''Oklahoma, seul terrain à la piste assez longue pour les essais de réception. Le premier F6U-1 vole le 29 juin 1949 et vingt avions rejoignent l''escadrille d''évaluation **VX-3** à Patuxent River. Le verdict tombe le 30 octobre 1950 : l''avion est « si peu performant que son emploi au combat n''est pas envisageable ».\n\n## Place dans l''histoire\nSurnommé « groundhog » (la marmotte) par les aviateurs de la marine, le Pirate ne rejoint aucune flottille opérationnelle. Les trente avions de série ne totalisent que 945 heures de vol, 31,5 heures chacun, et servent surtout à mettre au point brins d''arrêt et barrières, brièvement aussi dans une unité de réserve au Texas. Il reste pourtant un jalon : premier chasseur de la marine doté de la postcombustion, l''un des premiers avions construits en matériaux composites. Un seul exemplaire subsiste, restauré par les anciens de Vought.',
    E'## Genesis\nOn 5 September 1944 the US Navy''s Bureau of Aeronautics called for a single-seat carrier fighter powered by the new **Westinghouse 24C** axial turbojet, later the J34. **Chance Vought** won a contract for three V-340 prototypes on 29 December 1944. A company-wide contest gave the aircraft its name, **Pirate**, and the first prototype flew on 2 October 1946. It was the company''s first jet aircraft.\n\n## Design\nThe XF6U was a small fighter with straight wings and tail surfaces and a tricycle undercarriage; its rear-mounted engine breathed through intakes in the wing roots. Short enough to need no folding, the wings carried jettisonable tip tanks. Its originality lay in its **Metalite** skin, balsa wood sandwiched between two thin aluminium sheets, and the glass-fibre **Fabrilite** of the fin. Four 20 mm cannon sat beneath the cockpit. Underpowered, the aircraft also suffered severe aerodynamic problems; the third prototype, lengthened by 2.4 m, received an **afterburning** J34-WE-30 in 1947, a first for a US Navy fighter.\n\n## Operational career\nThirty production aircraft were ordered in 1947, before flight testing was even complete, with an ejection seat, a redesigned fin and two auxiliary fins on the tailplane. The move of Vought''s factory from Stratford to Dallas badly disrupted production: airframes were trucked to Texas, then on to Ardmore, Oklahoma, the only field with a runway long enough for acceptance testing. The first F6U-1 flew on 29 June 1949 and twenty aircraft joined evaluation squadron **VX-3** at Patuxent River. The verdict came on 30 October 1950: the aircraft was "so sub-marginal in performance that combat utilization is not feasible".\n\n## Place in history\nNicknamed the "groundhog" by naval aviators, the Pirate never joined an operational squadron. The thirty production aircraft logged only 945 flying hours, 31.5 hours each, and were used mainly to develop arresting gear and barriers, and briefly by a reserve squadron in Texas. It nonetheless marks a milestone: the Navy''s first fighter with an afterburner and one of the first aircraft built with composite materials. A single example survives, restored by Vought''s heritage foundation.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-09-05',
    '1946-10-02',
    NULL,
    959,
    1880,
    (SELECT id FROM manufacturer WHERE code = 'VOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F6U Pirate'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'F6U Pirate'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'F6U Pirate'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F6U Pirate'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F6U Pirate'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'F6U Pirate'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.46,
  wingspan          = 10.0,
  height            = 3.39,
  wing_area         = 18.9,
  empty_weight      = 3320,
  mtow              = 5850,
  service_ceiling   = 14100,
  climb_rate        = 41.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J34-WE-30A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 14.0,
  thrust_wet        = 18.8,

  -- Strate 3 : production & service
  production_start  = 1949,
  production_end    = 1950,
  units_built       = 33,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XF6U-1** : trois prototypes, deux à réacteur J34-WE-22 et le troisième, allongé, à J34-WE-30 avec postcombustion\n- **F6U-1** : version de série à postcombustion, siège éjectable et dérives auxiliaires, 30 exemplaires, 35 annulés\n- **F6U-1P** : un F6U-1 converti pour la reconnaissance photographique',
  variants_en       = E'- **XF6U-1**: three prototypes, two with J34-WE-22 engines and the third, lengthened, with an afterburning J34-WE-30\n- **F6U-1**: afterburning production version with ejection seat and auxiliary fins, 30 built, 35 cancelled\n- **F6U-1P**: one F6U-1 converted for photo-reconnaissance',

  -- Strate 4 : qualitatif
  nickname          = 'Groundhog',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vought_F6U_Pirate',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vought_F6U_Pirate',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F6U Pirate';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F6U Pirate';
