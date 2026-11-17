-- Canadair CL-44-6 / CC-106 Yukon
--
-- Photo : 15925 Canadair CC106 Yukon RCAF LGW 17MAY69 (6800623087).jpg
--   licence CC BY-SA 3.0 — Ken Fielding
--   https://commons.wikimedia.org/wiki/File:15925_Canadair_CC106_Yukon_RCAF_LGW_17MAY69_(6800623087).jpg

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
    'Canadair CC-106 Yukon',
    'Canadair CC-106 Yukon',
    'Canadair CL-44-6 / CC-106 Yukon',
    'Canadair CL-44-6 / CC-106 Yukon',
    'Le Britannia allongé de l''aviation canadienne, recordman du vol sans escale Tokyo-Trenton',
    'The RCAF''s stretched Britannia, record-holder for the non-stop Tokyo-Trenton flight',
    '/assets/airplanes/cc106-yukon.jpg',
    E'## Genèse\nDans les années 1950, Canadair acquiert la licence du **Bristol Britannia**, dont il tire d''abord le patrouilleur maritime **CP-107 Argus**. L''Aviation royale canadienne cherche alors à remplacer ses North Star, des **C-54** profondément remaniés et motorisés par des Merlin, par un transport à long rayon d''action destiné à soutenir les forces canadiennes en Europe. En janvier 1957, Canadair reçoit un contrat pour huit appareils, porté ensuite à douze : le CL-44-6, que la RCAF désigne **CC-106 Yukon**, du nom du territoire canadien.\n\n## Conception\nLe Yukon reprend l''aile modifiée de l''Argus et allonge de 3,75 m le fuselage du Britannia 300 ; la cabine est pressurisée et certains appareils reçoivent deux grandes portes cargo à gauche. Prévu avec des Bristol Orion, il passe aux **Rolls-Royce Tyne 11** quand le ministère britannique de l''Approvisionnement annule l''Orion. Il accueille 134 passagers et neuf membres d''équipage, ou 80 blessés en évacuation sanitaire. Sa sortie d''usine tourne presque au fiasco : la dérive du prototype ne passe pas sous la porte du hangar.\n\n## Carrière opérationnelle\nLe Yukon vole le 15 novembre 1959 à Cartierville, mais les essais sont émaillés d''incidents, de la panne électrique totale aux moteurs qui menacent de se détacher, et Rolls-Royce livre si mal ses Tyne que des « planeurs Yukon » attendent encore leurs moteurs en 1961. Une fois au point, l''avion se montre excellent : en décembre 1961, un Yukon relie Tokyo à la base de Trenton, en Ontario, sans escale, soit 10 860 km en 17 h 3 min, record de sa catégorie, puis tient l''air 23 h 51 min. Ces records ne tombent qu''en 1975, devant le Boeing 747SP. Au No. 412 Squadron, deux appareils transportent des personnalités.\n\n## Place dans l''histoire\nLes Yukon quittent le service en mars 1971, remplacés par le CC-137, un Boeing 707 capable de ravitailler en vol, et handicapés par le coût de pièces détachées produites en petite série. Ils ont alors parcouru 105 millions de kilomètres. Faute de certification de leurs pare-brise hérités du Britannia, ils ne peuvent voler en Amérique du Nord ni en Europe et finissent chez des opérateurs sud-américains et africains. Cousin du **Short Belfast**, né de la même lignée, le Yukon a aussi ouvert la voie à la famille civile CL-44 à queue pivotante.',
    E'## Genesis\nIn the 1950s Canadair acquired a licence for the **Bristol Britannia**, from which it first derived the **CP-107 Argus** maritime patrol aircraft. The Royal Canadian Air Force then sought to replace its North Stars, heavily redesigned Merlin-powered **C-54s**, with a long-range transport to support Canadian forces in Europe. In January 1957 Canadair received a contract for eight aircraft, later raised to twelve: the CL-44-6, which the RCAF designated **CC-106 Yukon**, after the Canadian territory.\n\n## Design\nThe Yukon used the Argus''s modified wing and stretched the Britannia 300 fuselage by 3.75 m; the cabin was pressurised and some aircraft had two large cargo doors on the port side. Planned with Bristol Orion engines, it switched to the **Rolls-Royce Tyne 11** when the British Ministry of Supply cancelled the Orion. It carried 134 passengers and a crew of nine, or 80 patients for casualty evacuation. Its rollout was a near-disaster: the prototype''s fin would not clear the hangar doors.\n\n## Operational career\nThe Yukon flew from Cartierville on 15 November 1959, but testing was dogged by problems, from total electrical failure to engines shaking loose, and Rolls-Royce delivered its Tynes so slowly that engineless "Yukon gliders" were still parked outside Canadair in 1961. Once sorted, the aircraft performed well: in December 1961 a Yukon flew non-stop from Tokyo to RCAF Station Trenton, Ontario, 10,860 km in 17 hours 3 minutes, a record for its class, and later stayed aloft for 23 hours 51 minutes. These records stood until the Boeing 747SP in 1975. With No. 412 Squadron, two aircraft served as VIP transports.\n\n## Place in history\nThe Yukons were retired in March 1971, replaced by the CC-137, a Boeing 707 able to act as a tanker, and hampered by the high cost of spares for a type never built in quantity. By then they had flown 105 million kilometres. Because their Britannia windshields could not be certified, they could not fly in North America or Europe and ended their days with South American and African operators. A cousin of the **Short Belfast**, sprung from the same lineage, the Yukon also paved the way for the swing-tail civil CL-44 family.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1957-01-01',
    '1959-11-15',
    NULL,
    NULL,
    10860,
    (SELECT id FROM manufacturer WHERE code = 'CDR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CC-106 Yukon'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CC-106 Yukon'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 41.73,
  wingspan          = 43.37,
  height            = 11.18,
  wing_area         = 192.7,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 9,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce Tyne 11',
  engine_count      = 4,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 12,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **CC-106 Yukon (CL-44-6)** : version de la RCAF, 134 passagers ou 80 blessés, douze exemplaires\n- **Yukon VIP** : deux appareils du No. 412 Squadron aménagés pour le transport de personnalités\n- **CL-44D4** : dérivé civil cargo à queue pivotante pour Seaboard World, Flying Tiger et Slick Airways\n- **CL-44J** : CL-44D4 allongé pour Loftleiðir, jusqu''à 189 passagers\n- **CL-44-O Skymonster** : un CL-44D4 converti par Conroy avec un fuselage de type Guppy',
  variants_en       = E'- **CC-106 Yukon (CL-44-6)**: RCAF version, 134 passengers or 80 patients, twelve built\n- **Yukon VIP**: two No. 412 Squadron aircraft fitted out as VIP transports\n- **CL-44D4**: swing-tail civil freighter derivative for Seaboard World, Flying Tiger and Slick Airways\n- **CL-44J**: stretched CL-44D4 for Loftleiðir, up to 189 passengers\n- **CL-44-O Skymonster**: one CL-44D4 converted by Conroy with a Guppy-type fuselage',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Canadair_CL-44',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Canadair_CL-44',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Ken Fielding',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Canadair CC-106 Yukon';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Canadair CC-106 Yukon';
