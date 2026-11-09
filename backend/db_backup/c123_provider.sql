-- Fairchild C-123 Provider
--
-- Photo : NC-123K.jpg
--   licence Public domain — U.S. Air Force
--   https://commons.wikimedia.org/wiki/File:NC-123K.jpg

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
    'C-123 Provider',
    'C-123 Provider',
    'Fairchild C-123 Provider',
    'Fairchild C-123 Provider',
    'Né d’un planeur, il ravitaille les camps du Vietnam — et répand l’agent orange',
    'Born of a glider, it supplied Vietnam’s outposts — and sprayed Agent Orange',
    '/assets/airplanes/c123-provider.jpg',
    E'## Genèse\nLe Provider descend d''un planeur. À la fin des années 1940, **Chase Aircraft** dessine le XCG-20, un grand planeur d''assaut entièrement métallique, puis lui ajoute des moteurs : le XC-123 vole le 14 octobre 1949. Chase n''a pas les moyens de produire en série ; après un épisode avorté chez Kaiser-Frazer, c''est **Fairchild** qui industrialise l''avion, et le C-123B entre en service en 1956.\n\n## Conception\nHéritage du planeur, la cellule est simple et robuste : aile haute, fuselage à fond plat, grande rampe arrière. Deux moteurs en étoile **Pratt & Whitney R-2800** de 2 500 ch lui permettent d''opérer depuis des terrains courts et sommaires. La version C-123K, issue de modifications de la seconde moitié des années 1960, reçoit sous les ailes deux turboréacteurs d''appoint **J85** qui améliorent le décollage court et la sécurité en cas de panne. L''appareil emporte soixante soldats ou près de onze tonnes de fret.\n\n## Carrière opérationnelle\nLe **Vietnam** fait sa réputation. Le C-123 ravitaille les camps isolés et les pistes de montagne, évacue les blessés, dépose des agents derrière les lignes. Le 12 mai 1968, à Kham Duc, le lieutenant-colonel **Joe M. Jackson** pose son C-123K sur une piste battue par les tirs pour récupérer une équipe de contrôle de trois hommes oubliée lors de l''évacuation, ce qui lui vaut la Medal of Honor. Une autre mission marque plus durablement l''histoire : l''opération **Ranch Hand**, lancée fin 1961, durant laquelle des UC-123 répandent des herbicides, dont l''**agent orange**, sur les forêts et les cultures du Sud-Vietnam.\n\n## Place dans l''histoire\nTrois cent sept exemplaires. Le Provider a été un cheval de trait du transport tactique américain avant la généralisation du **C-130 Hercules**, qui le remplace dans la Réserve et la Garde nationale au début des années 1980 ; la Thaïlande l''utilise jusqu''en 1995. Mais il reste attaché à l''un des chapitres les plus lourds de la guerre : la dioxine des épandages a contaminé jusqu''aux appareils eux-mêmes, dont les équipages d''après-guerre n''ont été reconnus exposés que des décennies plus tard.',
    E'## Genesis\nThe Provider descends from a glider. In the late 1940s **Chase Aircraft** designed the XCG-20, a large all-metal assault glider, then added engines: the XC-123 flew on 14 October 1949. Chase lacked the means for series production; after an aborted episode at Kaiser-Frazer, **Fairchild** industrialised the aircraft, and the C-123B entered service in 1956.\n\n## Design\nA legacy of the glider, the airframe is simple and rugged: high wing, flat-bottomed fuselage, large rear ramp. Two **Pratt & Whitney R-2800** radial engines of 2,500 hp let it operate from short, rough strips. The C-123K version, the product of modifications in the second half of the 1960s, gained two **J85** auxiliary jets under the wings, improving short take-off and engine-out safety. The aircraft carries sixty troops or nearly eleven tonnes of freight.\n\n## Operational career\n**Vietnam** made its reputation. The C-123 supplied isolated camps and mountain strips, evacuated the wounded and inserted agents behind the lines. On 12 May 1968 at Kham Duc, Lieutenant Colonel **Joe M. Jackson** landed his C-123K on a runway under fire to recover a three-man control team left behind during the evacuation, earning the Medal of Honor. Another mission left a more lasting mark: Operation **Ranch Hand**, launched at the end of 1961, in which UC-123s sprayed herbicides, including **Agent Orange**, over the forests and crops of South Vietnam.\n\n## Place in history\nThree hundred and seven built. The Provider was a workhorse of American tactical airlift until the **C-130 Hercules** became widespread, replacing it in the Reserve and Air National Guard in the early 1980s; Thailand flew it until 1995. But it remains tied to one of the war''s darkest chapters: the dioxin from the spraying contaminated the aircraft themselves, and their post-war crews were recognised as exposed only decades later.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1949-10-14',
    '1956-01-01',
    367.0,
    5280.0,
    (SELECT id FROM manufacturer WHERE code = 'FRC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'C-123 Provider'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.25,
  wingspan          = 33.53,
  height            = 10.39,
  wing_area         = 113.6,
  empty_weight      = 16042,
  mtow              = 27216,
  service_ceiling   = 6430,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-99W Double Wasp + 2 General Electric J85-GE-17',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 307,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **XC-123 / XC-123A** : prototypes Chase, à moteurs en étoile puis à quatre réacteurs\n- **C-123B** : version de série principale, construite par Fairchild\n- **C-123J** : réacteurs d''appoint en bout d''aile, pour les terrains enneigés de l''Alaska\n- **C-123K** : deux réacteurs d''appoint **J85** en nacelles sous les ailes\n- **UC-123B / UC-123K** : épandage d''herbicides de l''opération **Ranch Hand**',
  variants_en       = E'- **XC-123 / XC-123A** : Chase prototypes, with radial engines and then four jets\n- **C-123B** : main production version, built by Fairchild\n- **C-123J** : wingtip auxiliary jets, for Alaska''s snow-covered strips\n- **C-123K** : two **J85** auxiliary jets in pods under the wings\n- **UC-123B / UC-123K** : herbicide spraying for Operation **Ranch Hand**',

  -- Strate 4 : qualitatif
  nickname          = 'Provider',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairchild_C-123_Provider',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairchild_C-123_Provider',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force',
  image_licence     = 'Public domain'
WHERE name = 'C-123 Provider';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'C-123 Provider';
