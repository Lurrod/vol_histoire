-- Valmet L-70 Vinka (Miltrainer)
--
-- Photo : Valmet Vinka at Kauhava Air Show 2025.jpg
--   licence CC BY 4.0 — VynedJ
--   https://commons.wikimedia.org/wiki/File%3AValmet_Vinka_at_Kauhava_Air_Show_2025.jpg

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
    'Valmet L-70 Vinka',
    'Valmet L-70 Vinka',
    'Valmet L-70 Vinka (Miltrainer)',
    'Valmet L-70 Vinka (Miltrainer)',
    'Le premier avion militaire finlandais conçu depuis 1944',
    'The first Finnish military aircraft designed since 1944',
    '/assets/airplanes/valmet-vinka.jpg',
    E'## Genèse\nLa Finlande sort de la Seconde Guerre mondiale avec un traité qui limite son aviation militaire et une position géographique qui lui interdit de dépendre d''un seul fournisseur. Former ses pilotes sur un appareil étranger, c''est accepter une dépendance ; les former sur un appareil national suppose de reconstruire une industrie. En 1970, **Valmet** s''y attelle.\n\n## Conception\nLe cahier des charges est finlandais dans chacune de ses lignes. Deux places **côte à côte** plus une troisième derrière, un moteur Lycoming à injection capable de partir par grand froid, une aile contrainte à six g pour la voltige, et un train adapté aux **pistes enneigées** — l''appareil peut recevoir des skis. Petit, simple, robuste : rien qui ne serve.\n\n## Carrière opérationnelle\nTrente exemplaires, un seul client. Le Vinka forme tous les pilotes militaires finlandais de 1980 à **2020**, quarante ans durant, sans qu''aucun n''ait été perdu par défaut de conception. Valmet tente de l''exporter sous le nom de Miltrainer : aucun client étranger.\n\n## Place dans l''histoire\nTrente exemplaires — mais le premier avion militaire **conçu en Finlande** depuis 1944, et le point de départ d''une filière nationale qui donnera le **L-90 Redigo**. Il a rempli le rôle qu''on lui demandait : garantir que la formation des pilotes finlandais ne dépende de personne.',
    E'## Genesis\nFinland came out of the Second World War with a treaty limiting its military aviation and a geographical position forbidding dependence on a single supplier. Training its pilots on a foreign aircraft means accepting dependence; training them on a national one means rebuilding an industry. In 1970 **Valmet** set about it.\n\n## Design\nThe requirement is Finnish in every line. Two **side-by-side** seats plus a third behind, a fuel-injected Lycoming able to start in deep cold, a wing stressed to six g for aerobatics, and gear suited to **snow-covered strips** — the aircraft can take skis. Small, simple, rugged: nothing that does not earn its place.\n\n## Operational career\nThirty aircraft, a single customer. The Vinka trained every Finnish military pilot from 1980 to **2020**, forty years, without one being lost to a design fault. Valmet tried to export it as the Miltrainer: no foreign customer.\n\n## Place in history\nThirty built — but the first military aircraft **designed in Finland** since 1944, and the starting point of a national line that would produce the **L-90 Redigo**. It did what was asked of it: guarantee that the training of Finnish pilots depends on nobody.',
    (SELECT id FROM countries WHERE code = 'FIN'),
    '1970-01-01',
    '1975-07-01',
    '1980-10-01',
    236.0,
    900.0,
    (SELECT id FROM manufacturer WHERE code = 'VAL'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Valmet L-70 Vinka'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Valmet L-70 Vinka'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Valmet L-70 Vinka'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 7.5,
  wingspan          = 9.63,
  height            = 3.31,
  wing_area         = 14.0,
  empty_weight      = 768,
  mtow              = 1250,
  service_ceiling   = 5000,
  climb_rate        = 5.5,
  g_limit_pos       = 6.0,
  g_limit_neg       = -3.0,
  combat_radius     = 350,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Lycoming AEIO-360-A1B6',
  engine_count      = 1,
  engine_type       = 'Moteur à plat',
  engine_type_en    = 'Flat engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1979,
  production_end    = 1982,
  units_built       = 30,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **L-70 Vinka** : trente exemplaires, tous pour la force aérienne finlandaise\n- *Vinka* signifie « **bourrasque** » en finnois ; désignation export **Miltrainer**\n- Places **côte à côte**, avec une troisième place derrière pour un observateur\n- Conçu pour opérer sur **skis** et sur pistes enneigées, contrainte nationale\n- Retiré en **2020** après quarante ans, remplacé par le **Grob G 115**',
  variants_en       = E'- **L-70 Vinka** : thirty aircraft, all for the Finnish Air Force\n- *Vinka* means ''**gust**'' in Finnish; the export designation was **Miltrainer**\n- **Side-by-side** seating, with a third seat behind for an observer\n- Designed to operate on **skis** and snow-covered strips, a national requirement\n- Withdrawn in **2020** after forty years, replaced by the **Grob G 115**',

  -- Strate 4 : qualitatif
  nickname          = 'Vinka',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Valmet_L-70_Vinka',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Valmet_L-70_Vinka',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'VynedJ',
  image_licence     = 'CC BY 4.0'
WHERE name = 'Valmet L-70 Vinka';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Valmet L-70 Vinka';
