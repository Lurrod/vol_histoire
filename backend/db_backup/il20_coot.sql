-- Iliouchine Il-20M (Coot-A)
--
-- Photo : Ilyushin IL-20M ‘173011502’ (37201967950).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File%3AIlyushin_IL-20M_%E2%80%98173011502%E2%80%99_%2837201967950%29.jpg

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
    'Iliouchine Il-20',
    'Ilyushin Il-20',
    'Iliouchine Il-20M (Coot-A)',
    'Ilyushin Il-20M (Coot-A)',
    'L’oreille soviétique : cinquante ans d’écoute électronique',
    'The Soviet ear: fifty years of electronic listening',
    '/assets/airplanes/il20-coot.jpg',
    E'## Genèse\nLe renseignement d''origine électromagnétique — écouter les radars, les radios et les liaisons de données de l''adversaire — exige un appareil qui vole longtemps, lentement et près des frontières sans les franchir. L''URSS de 1965 dispose d''un avion de ligne parfaitement adapté : l''**Il-18**, quatre turbopropulseurs et douze heures d''autonomie.\n\n## Conception\nLa cellule est conservée entière ; on lui greffe une **nacelle ventrale de onze mètres** abritant un radar à balayage latéral, deux carénages latéraux pour les capteurs photographiques, et une forêt d''antennes. Treize opérateurs travaillent en cabine. La silhouette qui en résulte est immédiatement reconnaissable, ce qui n''est pas un défaut : l''appareil vole dans l''espace international, à la vue de tous.\n\n## Carrière opérationnelle\nUne vingtaine d''exemplaires depuis 1969, tous russes. Ils longent les côtes de l''OTAN, du Japon et de l''Alaska depuis cinquante ans et sont régulièrement interceptés. Le 17 septembre 2018, un Il-20 est **abattu par erreur au-dessus de la Syrie** par la défense antiaérienne syrienne, quinze militaires russes tués.\n\n## Place dans l''histoire\nVingt exemplaires, cinquante-sept ans de service et toujours en activité. L''Il-20 illustre une constante : les appareils d''écoute vivent bien plus longtemps que les chasseurs, parce que leur valeur tient aux capteurs qu''on remplace et non à la cellule qui les porte. L''américain **RC-135** suit la même trajectoire depuis 1964.',
    E'## Genesis\nSignals intelligence — listening to the opponent''s radars, radios and data links — requires an aircraft that flies for a long time, slowly, and close to borders without crossing them. The USSR of 1965 had a perfectly suited airliner: the **Il-18**, four turboprops and twelve hours endurance.\n\n## Design\nThe airframe is kept entire; onto it are grafted an **eleven-metre ventral pod** housing a side-looking radar, two side fairings for photographic sensors, and a forest of antennas. Thirteen operators work in the cabin. The resulting silhouette is instantly recognisable, which is not a flaw: the aircraft flies in international airspace, in plain sight.\n\n## Operational career\nSome twenty aircraft since 1969, all Russian. They have skirted NATO, Japanese and Alaskan coasts for fifty years and are regularly intercepted. On 17 September 2018 an Il-20 was **shot down by mistake over Syria** by Syrian air defences, killing fifteen Russian servicemen.\n\n## Place in history\nTwenty built, fifty-seven years of service and still active. The Il-20 illustrates a constant: listening aircraft outlive fighters by far, because their value lies in sensors that are replaced rather than in the airframe that carries them. The American **RC-135** has followed the same path since 1964.',
    (SELECT id FROM countries WHERE code = 'RUS'),
    '1965-01-01',
    '1968-03-21',
    '1969-01-01',
    675.0,
    6500.0,
    (SELECT id FROM manufacturer WHERE code = 'ILY'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-20'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-20'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-20'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-20'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-20'), (SELECT id FROM missions WHERE name = 'Guerre électronique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Iliouchine Il-20'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.9,
  wingspan          = 37.42,
  height            = 10.17,
  wing_area         = 140.0,
  empty_weight      = 35000,
  mtow              = 64000,
  service_ceiling   = 10000,
  climb_rate        = 6.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 2500,
  crew              = 13,

  -- Strate 2 : motorisation
  engine_name       = 'Ivchenko AI-20M',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1968,
  production_end    = 1976,
  units_built       = 20,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Il-20M (Coot-A)** : version de renseignement électronique, la plus répandue\n- **Il-22 Coot-B** : version de poste de commandement aéroporté\n- **Il-38** : version de patrouille maritime, déjà au catalogue\n- Dérivé de l''avion de ligne **Il-18**, dont il conserve la cellule intégrale\n- Nacelle **SLAR** ventrale de onze mètres et carénages latéraux : silhouette unique',
  variants_en       = E'- **Il-20M (Coot-A)** : electronic intelligence version, the most common\n- **Il-22 Coot-B** : airborne command post version\n- **Il-38** : maritime patrol version, already in this catalogue\n- Derived from the **Il-18** airliner, whose airframe it keeps entire\n- An eleven-metre ventral **SLAR** pod and side fairings: a unique silhouette',

  -- Strate 4 : qualitatif
  nickname          = 'Coot-A',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Iliouchine_Il-20',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ilyushin_Il-20',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson from Stilton, Peterborough, Cambs, UK',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Iliouchine Il-20';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Iliouchine Il-20';
