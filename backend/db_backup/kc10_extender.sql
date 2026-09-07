-- McDonnell Douglas KC-10 Extender
--
-- Photo : KC-10 Extender (2151957820).jpg
--   licence Public domain — U.S. Air Force photo by Staff Sgt. Jerry Morrison
--   https://commons.wikimedia.org/wiki/File%3AKC-10_Extender_%282151957820%29.jpg

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
    'KC-10 Extender',
    'KC-10 Extender',
    'McDonnell Douglas KC-10 Extender',
    'McDonnell Douglas KC-10 Extender',
    'Ravitailleur gros-porteur, capable d’emporter sa propre logistique',
    'Wide-body tanker able to carry its own support with it',
    '/assets/airplanes/kc10-extender.jpg',
    E'## Genèse\nLa guerre du Kippour de 1973 met en évidence un problème : quand les États-Unis veulent envoyer des chasseurs en Israël, aucun allié européen n''accorde de droit d''escale. Il faut traverser l''Atlantique **sans se poser**, donc ravitailler, donc déployer aussi les ravitailleurs et leur matériel. L''US Air Force cherche un appareil qui fasse les deux à la fois.\n\n## Conception\nLe KC-10 est un DC-10 de ligne dont on a supprimé les hublots et renforcé le plancher. Sa singularité est de **cumuler les deux systèmes de ravitaillement du monde occidental** : la perche rigide américaine et les tuyaux souples utilisés par la marine américaine et la quasi-totalité des alliés. Il transporte simultanément quatre-vingt-dix tonnes de carburant transférable, du fret et des mécaniciens — un déploiement complet dans un seul appareil.\n\n## Carrière opérationnelle\nEn 1991, les KC-10 rendent possible le déploiement de plus de mille appareils vers le Golfe en quelques semaines. Ils escortent les traversées transatlantiques de chasseurs, ravitaillent les bombardiers furtifs au-dessus de la Serbie et de la Libye, et servent de convoyeurs pour tous les transferts d''appareils vendus à l''étranger. Le surnom de *Gucci Bird* leur vient du confort de leur cabine, sans rapport avec celle d''un C-130.\n\n## Place dans l''histoire\nSoixante exemplaires seulement, retirés en **septembre 2024** au profit du KC-46. Leur départ laisse un vide reconnu : aucun appareil américain ne cumule plus la perche et les tuyaux dans les mêmes proportions, et le **KC-135**, plus ancien de vingt-quatre ans, leur survit.',
    E'## Genesis\nThe 1973 Yom Kippur War exposed a problem: when the United States wanted to send fighters to Israel, no European ally granted staging rights. The Atlantic had to be crossed **without landing**, therefore with refuelling, therefore deploying the tankers and their equipment too. The US Air Force looked for an aircraft that would do both at once.\n\n## Design\nThe KC-10 is an airline DC-10 with the windows deleted and the floor strengthened. Its distinctive feature is **combining both Western refuelling systems**: the American flying boom and the hose-and-drogue units used by the US Navy and nearly every ally. It carries ninety tonnes of transferable fuel, freight and mechanics at the same time — a complete deployment in a single aircraft.\n\n## Operational career\nIn 1991 the KC-10s made it possible to deploy more than a thousand aircraft to the Gulf in a few weeks. They escorted transatlantic fighter crossings, refuelled stealth bombers over Serbia and Libya, and shepherded every delivery of aircraft sold abroad. The nickname *Gucci Bird* came from the comfort of their cabin, which bears no relation to a C-130''s.\n\n## Place in history\nOnly sixty built, retired in **September 2024** in favour of the KC-46. Their departure leaves an acknowledged gap: no American aircraft now combines boom and drogues in the same proportions, and the **KC-135**, twenty-four years older, outlives them.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1975-01-01',
    '1980-07-12',
    '1981-03-17',
    908.0,
    7032.0,
    (SELECT id FROM manufacturer WHERE code = 'MDD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'KC-10 Extender'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 55.35,
  wingspan          = 50.41,
  height            = 17.7,
  wing_area         = 367.7,
  empty_weight      = 109328,
  mtow              = 267620,
  service_ceiling   = 12727,
  climb_rate        = 15.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 7032,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric CF6-50C2',
  engine_count      = 3,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 233.5,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1979,
  production_end    = 1988,
  units_built       = 60,
  unit_cost_usd     = 88400000,
  unit_cost_year    = 1998,
  operators_count   = 2,
  variants          = E'- **KC-10A** : version unique de série, dérivée du DC-10-30 civil\n- **KDC-10** : deux exemplaires convertis pour les **Pays-Bas**, retirés en 2021\n- Seul ravitailleur américain à disposer **à la fois** d''une perche rigide et de tuyaux souples\n- Peut lui-même être ravitaillé en vol, doublant son rayon de déploiement\n- Dernier exemplaire retiré du service le **26 septembre 2024**',
  variants_en       = E'- **KC-10A** : the sole production version, derived from the civil DC-10-30\n- **KDC-10** : two aircraft converted for the **Netherlands**, retired in 2021\n- The only American tanker with **both** a flying boom and hose-and-drogue units\n- Can itself be refuelled in flight, doubling its deployment radius\n- Last aircraft withdrawn from service on **26 September 2024**',

  -- Strate 4 : qualitatif
  nickname          = 'Gucci Bird',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/McDonnell_Douglas_KC-10_Extender',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/McDonnell_Douglas_KC-10_Extender',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Air Force photo by Staff Sgt. Jerry Morrison',
  image_licence     = 'Public domain'
WHERE name = 'KC-10 Extender';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KC-10 Extender';
