-- Bell X-1 Glamorous Glennis
--
-- Photo : Bell X-1 in flight.jpg
--   licence Public domain — auteur non renseigné
--   https://commons.wikimedia.org/wiki/File%3ABell_X-1_in_flight.jpg

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
    'Bell X-1',
    'Bell X-1',
    'Bell X-1 Glamorous Glennis',
    'Bell X-1 Glamorous Glennis',
    'Le 14 octobre 1947, il franchit le mur du son',
    'On 14 October 1947 it broke the sound barrier',
    '/assets/airplanes/bell-x1.jpg',
    E'## Genèse\nÀ la fin de la guerre, plusieurs pilotes se sont tués en piqué à l''approche de la vitesse du son : les commandes se figent, l''appareil vibre, parfois il se casse. On parle de **mur du son**, et certains ingénieurs pensent qu''il est infranchissable. En 1944, l''US Army et la NACA commandent à Bell un appareil dont l''unique fonction est de le traverser.\n\n## Conception\nFaute de théorie, on copie ce qui marche : le fuselage reprend la forme d''une **balle de mitrailleuse de calibre 12,7 mm**, dont on sait qu''elle reste stable au-delà de Mach 1. L''aile est extrêmement mince, l''empennage horizontal **entièrement mobile** — innovation décisive, car c''est le blocage des gouvernes classiques qui tuait. Un moteur-fusée XLR11 brûle deux tonnes et demie d''ergols en deux minutes et demie.\n\n## Carrière opérationnelle\nAucune. Le **14 octobre 1947**, largué d''un B-29 au-dessus du désert Mojave, le capitaine **Chuck Yeager** atteint **Mach 1,06**. Il vole avec deux côtes cassées deux jours plus tôt en tombant de cheval, et a scié un manche à balai pour pouvoir refermer la trappe d''accès sans lever le bras. L''information reste secrète huit mois.\n\n## Place dans l''histoire\nTrois exemplaires. Le *Glamorous Glennis* est aujourd''hui suspendu au Smithsonian, à côté du *Spirit of St. Louis*. L''empennage entièrement mobile inauguré ici équipe depuis tous les avions supersoniques du monde. Le X-1 ouvre la série des **avions X**, dont ce catalogue compte le X-3, le X-13, le X-14, le X-15, le X-29, le X-31 et le X-47B.',
    E'## Genesis\nAt the end of the war several pilots had died in dives approaching the speed of sound: the controls lock, the aircraft shakes, sometimes it breaks up. People spoke of a **sound barrier**, and some engineers thought it could not be crossed. In 1944 the US Army and NACA ordered from Bell an aircraft whose only function was to cross it.\n\n## Design\nLacking theory, they copied what worked: the fuselage takes the shape of a **.50 calibre bullet**, known to stay stable beyond Mach 1. The wing is extremely thin, the horizontal tail **all-moving** — the decisive innovation, since it was the locking of conventional control surfaces that killed. An XLR11 rocket burns two and a half tonnes of propellant in two and a half minutes.\n\n## Operational career\nNone. On **14 October 1947**, dropped from a B-29 over the Mojave desert, Captain **Chuck Yeager** reached **Mach 1.06**. He flew with two ribs broken two days earlier falling from a horse, and had sawn off a broom handle so he could close the hatch without raising his arm. The news stayed secret for eight months.\n\n## Place in history\nThree built. *Glamorous Glennis* hangs today in the Smithsonian, beside the *Spirit of St. Louis*. The all-moving tailplane introduced here is on every supersonic aircraft in the world. The X-1 opened the **X-plane** series, of which this catalogue holds the X-3, X-13, X-14, X-15, X-29, X-31 and X-47B.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1944-12-01',
    '1946-01-19',
    NULL,
    1541.0,
    8.0,
    (SELECT id FROM manufacturer WHERE code = 'BEL'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-1'), (SELECT id FROM tech WHERE name = 'Moteur-fusée')),
((SELECT id FROM airplanes WHERE name = 'Bell X-1'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Bell X-1'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 9.45,
  wingspan          = 8.53,
  height            = 3.3,
  wing_area         = 12.1,
  empty_weight      = 3175,
  mtow              = 5545,
  service_ceiling   = 21900,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 8,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Reaction Motors XLR11-RM-3',
  engine_count      = 1,
  engine_type       = 'Moteur-fusée à ergols liquides',
  engine_type_en    = 'Liquid-fuel rocket engine',
  thrust_dry        = 26.7,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1945,
  production_end    = 1947,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-1** : trois exemplaires, dont le n°1 baptisé *Glamorous Glennis*\n- **X-1A / X-1B / X-1E** : versions ultérieures, à réservoirs et cellule modifiés\n- **14 octobre 1947** : **Chuck Yeager** atteint Mach 1,06, deux côtes cassées\n- Fuselage dessiné d''après une **balle de mitrailleuse de 12,7 mm**, forme connue stable\n- Largué d''un **B-29** modifié : il n''a jamais décollé par ses propres moyens',
  variants_en       = E'- **X-1** : three aircraft, No. 1 named *Glamorous Glennis*\n- **X-1A / X-1B / X-1E** : later versions with modified tanks and airframe\n- **14 October 1947** : **Chuck Yeager** reached Mach 1.06, with two broken ribs\n- Fuselage shaped after a **.50 calibre bullet**, a form known to be stable\n- Air-launched from a modified **B-29**: it never took off under its own power',

  -- Strate 4 : qualitatif
  nickname          = 'Glamorous Glennis',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Bell_X-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Bell_X-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Bell X-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Bell X-1';
