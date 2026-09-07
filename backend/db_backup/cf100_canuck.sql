-- Avro Canada CF-100 Canuck
--
-- Photo : Avro CF-100 Canuck Nanton 2013.jpg
--   licence CC BY 3.0 — Canoe1967
--   https://commons.wikimedia.org/wiki/File%3AAvro_CF-100_Canuck_Nanton_2013.jpg

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
    'Avro Canada CF-100 Canuck',
    'Avro Canada CF-100 Canuck',
    'Avro Canada CF-100 Canuck',
    'Avro Canada CF-100 Canuck',
    'Seul chasseur de conception canadienne à avoir atteint la série',
    'The only Canadian-designed fighter ever to reach production',
    '/assets/airplanes/cf100-canuck.jpg',
    E'## Genèse\nLe Canada occupe, sur une carte polaire, la place exacte que suivraient les bombardiers soviétiques pour atteindre l''Amérique du Nord. Aucun chasseur allié ne convient : il faut un appareil capable de tenir l''air par moins quarante degrés, de patrouiller des heures au-dessus d''un territoire vide et de trouver sa cible de nuit, dans la nuit polaire. Avro Canada, filiale du britannique Avro, reçoit la commande en 1946 — le premier avion militaire entièrement conçu au Canada.\n\n## Conception\nAile droite épaisse, deux hommes en tandem, et un radar dans le nez. Tout est dicté par l''**endurance** plutôt que par la vitesse : la formule paraît démodée dès sa sortie, à l''heure où tout le monde passe à la flèche, mais elle donne trois mille deux cents kilomètres de rayon d''action. Les réacteurs **Orenda** sont canadiens, ce qui est en soi remarquable pour un pays sans tradition de motoriste. Les équipages le surnomment le *Clunk*, du bruit du train rentrant.\n\n## Carrière opérationnelle\nIl tient les approches nord du continent pendant vingt ans, au sein du NORAD, sans jamais tirer en colère — la mesure exacte de sa réussite. Neuf escadrons canadiens sont déployés en **Europe** au titre de l''OTAN, où le CF-100 est longtemps le seul intercepteur tout-temps de l''Alliance. Les derniers exemplaires, convertis au brouillage, volent jusqu''en 1981.\n\n## Place dans l''histoire\nSix cent quatre-vingt-douze exemplaires : aucun autre chasseur conçu au Canada n''a jamais été produit en série, ni avant ni depuis. Il a démontré qu''un pays de quinze millions d''habitants pouvait mener seul un programme de chasse complet, cellule et moteur compris — ce qui rendra d''autant plus brutale l''annulation de son successeur, le **CF-105 Arrow**.',
    E'## Genesis\nOn a polar map, Canada sits exactly where Soviet bombers would pass to reach North America. No Allied fighter suited: what was needed was an aircraft able to stay up at minus forty degrees, patrol for hours over empty territory and find its target at night, in the polar dark. Avro Canada, a subsidiary of Britain''s Avro, received the order in 1946 — the first military aircraft designed entirely in Canada.\n\n## Design\nA thick straight wing, two men in tandem, and a radar in the nose. Everything was dictated by **endurance** rather than speed: the formula looked dated the moment it appeared, just as everyone else was moving to swept wings, but it delivered three thousand two hundred kilometres of range. The **Orenda** engines were Canadian, remarkable in itself for a country with no engine-building tradition. Crews nicknamed it the *Clunk*, after the sound of the gear retracting.\n\n## Operational career\nIt held the continent''s northern approaches for twenty years within NORAD, without ever firing in anger — the exact measure of its success. Nine Canadian squadrons were deployed to **Europe** under NATO, where the CF-100 was for a long time the Alliance''s only all-weather interceptor. The last aircraft, converted for jamming, flew until 1981.\n\n## Place in history\nSix hundred and ninety-two built: no other Canadian-designed fighter has ever been series-produced, before or since. It proved that a country of fifteen million could run a complete fighter programme alone, airframe and engine included — which made the cancellation of its successor, the **CF-105 Arrow**, all the more brutal.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1946-10-01',
    '1950-01-19',
    '1953-04-01',
    1046.0,
    3200.0,
    (SELECT id FROM manufacturer WHERE code = 'AVC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM armement WHERE name = 'M3 Browning 12,7 mm')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-100 Canuck'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.5,
  wingspan          = 17.68,
  height            = 4.38,
  wing_area         = 54.9,
  empty_weight      = 10478,
  mtow              = 16783,
  service_ceiling   = 13700,
  climb_rate        = 44.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1000,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Avro Canada Orenda 11',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 32.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1951,
  production_end    = 1958,
  units_built       = 692,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **CF-100 Mk 3** : version initiale à huit mitrailleuses de 12,7 mm\n- **CF-100 Mk 4** : radar APG-40 et paniers de roquettes en bout d''aile\n- **CF-100 Mk 5** : envergure augmentée pour la haute altitude, version principale\n- **CF-100 Mk 5D** : convertie en guerre électronique, dernière en service jusqu''en 1981\n- La **Belgique** en a reçu cinquante-trois, seul client à l''exportation',
  variants_en       = E'- **CF-100 Mk 3** : initial version with eight 12.7 mm machine guns\n- **CF-100 Mk 4** : APG-40 radar and wingtip rocket pods\n- **CF-100 Mk 5** : increased span for high altitude, the main version\n- **CF-100 Mk 5D** : converted for electronic warfare, the last in service until 1981\n- **Belgium** received fifty-three, the only export customer',

  -- Strate 4 : qualitatif
  nickname          = 'Clunk',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_Canada_CF-100_Canuck',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_Canada_CF-100_Canuck',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Canoe1967',
  image_licence     = 'CC BY 3.0'
WHERE name = 'Avro Canada CF-100 Canuck';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro Canada CF-100 Canuck';
