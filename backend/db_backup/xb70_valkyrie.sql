-- North American XB-70 Valkyrie
--
-- Photo : North American XB-70 in Flight EC68-2131.jpg
--   licence CC BY 2.0 — James St. John
--   https://commons.wikimedia.org/wiki/File%3AUnited_States_Air_Force_-_North_American_XB-70A_Valkyrie_bomber_13.jpg

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
    'XB-70 Valkyrie',
    'XB-70 Valkyrie',
    'North American XB-70 Valkyrie',
    'North American XB-70 Valkyrie',
    'Bombardier de Mach 3 rendu inutile par le missile sol-air avant son premier vol',
    'A Mach 3 bomber made pointless by the surface-to-air missile before it first flew',
    '/assets/airplanes/xb70-valkyrie.jpg',
    E'## Genèse\nLa doctrine de 1955 est simple : un bombardier assez haut et assez rapide devient inatteignable. L''US Air Force demande donc Mach 3 à vingt-trois mille mètres, pour remplacer le B-52. Le problème est que le monde change pendant la conception — en 1960, un **missile sol-air** soviétique abat le U-2 de Gary Powers à vingt et un mille mètres. L''altitude ne protège plus de rien, et le B-70 perd sa raison d''être quatre ans avant son premier vol.\n\n## Conception\nImmense delta en acier inoxydable et titane, six réacteurs groupés sous une nacelle unique, et une invention remarquable : les **saumons d''aile s''abaissent de 65°** en vol supersonique. L''appareil se pose alors sur sa propre onde de choc, un phénomène appelé *compression lift* qui lui procure trente pour cent de portance gratuite. À Mach 3, la peau atteint 330 °C — l''avion s''allonge de vingt centimètres en vol.\n\n## Carrière opérationnelle\nAucune. Le programme de série est annulé dès 1961 par McNamara, qui préfère les missiles balistiques ; deux prototypes sont achevés comme bancs d''essai supersoniques. Le **8 juin 1966**, lors d''une séance photo de prestige commanditée par General Electric, un F-104 volant en formation serrée heurte le saumon droit de l''AV-2 : les deux avions s''écrasent, deux pilotes meurent. La photographie de la collision fera le tour du monde.\n\n## Place dans l''histoire\nDeux exemplaires pour un milliard et demi de dollars de l''époque. Il n''a rien accompli, mais tout ce qu''il a appris a servi : ses données de vol à Mach 3 ont nourri le programme **SR-71**, le Concorde et le projet de transport supersonique américain. Son équivalent soviétique, le **Sukhoi T-4**, connaîtra exactement le même sort, pour les mêmes raisons.',
    E'## Genesis\nThe doctrine of 1955 was simple: a bomber high enough and fast enough becomes untouchable. The US Air Force therefore asked for Mach 3 at twenty-three thousand metres, to replace the B-52. The trouble was that the world changed during design — in 1960 a Soviet **surface-to-air missile** shot down Gary Powers''s U-2 at twenty-one thousand metres. Altitude no longer protected anything, and the B-70 lost its purpose four years before it first flew.\n\n## Design\nA vast delta in stainless steel and titanium, six engines grouped under a single nacelle, and one remarkable invention: the **wingtips fold down 65°** in supersonic flight. The aircraft then rides its own shock wave, a phenomenon called *compression lift* that gives it thirty per cent of its lift for free. At Mach 3 the skin reaches 330 °C — the aircraft grows twenty centimetres longer in flight.\n\n## Operational career\nNone. The production programme was cancelled as early as 1961 by McNamara, who preferred ballistic missiles; two prototypes were completed as supersonic testbeds. On **8 June 1966**, during a prestige photo shoot commissioned by General Electric, an F-104 flying in tight formation struck AV-2''s right wingtip: both aircraft crashed and two pilots died. The photograph of the collision went around the world.\n\n## Place in history\nTwo aircraft for one and a half billion dollars of the day. It achieved nothing, but everything it learned was used: its Mach 3 flight data fed the **SR-71** programme, Concorde and the American supersonic transport project. Its Soviet equivalent, the **Sukhoi T-4**, would meet exactly the same fate, for the same reasons.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1955-01-01',
    '1964-09-21',
    NULL,
    3309.0,
    6900.0,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Bombardier'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie'), (SELECT id FROM tech WHERE name = 'Système de navigation inertielle'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie'), (SELECT id FROM missions WHERE name = 'Frappe stratégique')),
((SELECT id FROM airplanes WHERE name = 'XB-70 Valkyrie'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 57.6,
  wingspan          = 32.0,
  height            = 9.14,
  wing_area         = 585.0,
  empty_weight      = 93000,
  mtow              = 246000,
  service_ceiling   = 23600,
  climb_rate        = 137.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3500,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric YJ93-GE-3',
  engine_count      = 6,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 84.2,
  thrust_wet        = 125.0,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1965,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **AV-1** : premier prototype, limité à Mach 2,5 après des problèmes de structure\n- **AV-2** : second exemplaire, atteint Mach 3,08 pendant trente-deux minutes\n- L''**AV-2 est détruit** le 8 juin 1966 lors d''une collision en vol avec un F-104 de chasse photo\n- **B-70 de série** : cent vingt-cinq exemplaires prévus, ramenés à zéro dès 1961\n- L''AV-1 survivant est exposé au musée de l''US Air Force à Dayton',
  variants_en       = E'- **AV-1** : first prototype, limited to Mach 2.5 after structural problems\n- **AV-2** : second aircraft, reached Mach 3.08 for thirty-two minutes\n- **AV-2 was destroyed** on 8 June 1966 in a mid-air collision with a photo-chase F-104\n- **Production B-70** : one hundred and twenty-five planned, cut to none as early as 1961\n- The surviving AV-1 is displayed at the US Air Force museum in Dayton',

  -- Strate 4 : qualitatif
  nickname          = 'Valkyrie',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_XB-70_Valkyrie',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_XB-70_Valkyrie',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA',
  image_licence     = 'Public domain'
WHERE name = 'XB-70 Valkyrie';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'XB-70 Valkyrie';
