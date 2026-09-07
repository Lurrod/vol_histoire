-- Cessna T-37 Tweet
--
-- Photo : Cessna T-37B Tweet (32458198547).jpg
--   licence CC BY 2.0 — Mike LaChance from Crowley, Tx, USA
--   https://commons.wikimedia.org/wiki/File%3ACessna_T-37B_Tweet_%2832458198547%29.jpg

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
    'T-37 Tweet',
    'T-37 Tweet',
    'Cessna T-37 Tweet',
    'Cessna T-37 Tweet',
    'Cinquante-deux ans d’école, et un sifflement qui perçait les protections',
    'Fifty-two years of training, and a whistle that pierced ear defenders',
    '/assets/airplanes/t37-tweet.jpg',
    E'## Genèse\nEn 1952, l''US Air Force cherche son premier avion-école à réaction. Le cahier des charges est spécifique : l''appareil doit être assez petit et assez léger pour qu''un élève puisse le casser sans se tuer, et assez représentatif pour que la transition vers un chasseur ne soit pas un choc. Cessna, constructeur d''aviation légère, l''emporte contre des maisons plus prestigieuses.\n\n## Conception\nDeux petits réacteurs Continental de moins de cinq cents kilogrammes de poussée chacun, une aile droite épaisse, un train solide et deux sièges **côte à côte**. Le tout pèse moins de trois tonnes à pleine charge. Les tuyères, courtes et à haut régime, produisent un sifflement aigu si pénétrant que les mécaniciens le décrivaient comme traversant les casques antibruit — d''où le surnom de « **sifflet à chien de trois tonnes** ».\n\n## Carrière opérationnelle\nMille deux cent soixante-neuf exemplaires. Il forme les pilotes américains de **1957 à 2009**, soit cinquante-deux ans, et treize forces aériennes l''exploitent. Sa descendance est plus guerrière : le **A-37 Dragonfly**, version renforcée et armée, effectue des dizaines de milliers de sorties d''appui au Vietnam.\n\n## Place dans l''histoire\nMille deux cent soixante-neuf exemplaires et un demi-siècle de service. Le Tweet a formé plus de pilotes de chasse américains que n''importe quel autre appareil à réaction. Il est remplacé par le **T-6 Texan II** à turbopropulseur — comme les Britanniques, les Américains sont revenus à l''hélice pour la formation de base.',
    E'## Genesis\nIn 1952 the US Air Force was looking for its first jet trainer. The requirement was specific: the aircraft had to be small and light enough that a pupil could break it without killing himself, and representative enough that the step up to a fighter would not be a shock. Cessna, a light-aircraft builder, beat more prestigious houses.\n\n## Design\nTwo small Continental engines of under five hundred kilogrammes thrust each, a thick straight wing, sturdy landing gear and two **side-by-side** seats. The whole thing weighs under three tonnes fully loaded. The short, high-revving exhausts produce a shriek so penetrating that ground crews described it as going through ear defenders — hence the nickname ''**6,000 lb dog whistle**''.\n\n## Operational career\nOne thousand two hundred and sixty-nine built. It trained American pilots from **1957 to 2009**, fifty-two years, and thirteen air forces flew it. Its descendant is more warlike: the **A-37 Dragonfly**, strengthened and armed, flew tens of thousands of support sorties over Vietnam.\n\n## Place in history\nOne thousand two hundred and sixty-nine built and half a century of service. The Tweet trained more American fighter pilots than any other jet. It was replaced by the turboprop **T-6 Texan II** — like the British, the Americans went back to the propeller for basic training.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1952-01-01',
    '1954-10-12',
    '1957-06-01',
    684.0,
    1500.0,
    (SELECT id FROM manufacturer WHERE code = 'CES'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Entraîneur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'T-37 Tweet'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'T-37 Tweet'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'T-37 Tweet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 8.92,
  wingspan          = 10.3,
  height            = 2.79,
  wing_area         = 17.09,
  empty_weight      = 1846,
  mtow              = 3000,
  service_ceiling   = 10850,
  climb_rate        = 15.5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Continental J69-T-25',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 4.6,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1975,
  units_built       = 1269,
  unit_cost_usd     = 163000,
  unit_cost_year    = 1961,
  operators_count   = 13,
  variants          = E'- **T-37A / B / C** : versions d''entraînement, la C exportée et pourvue de points d''emport\n- **A-37 Dragonfly** : version d''attaque légère, largement engagée au **Vietnam**\n- Places **côte à côte**, comme sur le Fokker S.14 et pour la même raison\n- Surnommé « **Tweet** » ou « 6 000 lb dog whistle » pour le sifflement de ses réacteurs\n- En service à l''US Air Force de 1957 à **2009** : cinquante-deux ans',
  variants_en       = E'- **T-37A / B / C** : training versions, the C exported and fitted with hardpoints\n- **A-37 Dragonfly** : light attack version, widely used over **Vietnam**\n- **Side-by-side** seating, as on the Fokker S.14 and for the same reason\n- Nicknamed ''**Tweet**'' or the ''6,000 lb dog whistle'' for its engine shriek\n- In US Air Force service from 1957 to **2009**: fifty-two years',

  -- Strate 4 : qualitatif
  nickname          = 'Tweet',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Cessna_T-37_Tweet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Cessna_T-37_Tweet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Mike LaChance from Crowley, Tx, USA',
  image_licence     = 'CC BY 2.0'
WHERE name = 'T-37 Tweet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'T-37 Tweet';
