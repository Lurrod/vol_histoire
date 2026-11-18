-- Short SC.7 Skyvan 3M
--
-- Photo : Short SC.7 Skyvan 3-100 ‘G-BEOL’ (45999320712).jpg
--   licence CC BY-SA 2.0 — Alan Wilson from Stilton, Peterborough, Cambs, UK
--   https://commons.wikimedia.org/wiki/File:Short_SC.7_Skyvan_3-100_%E2%80%98G-BEOL%E2%80%99_(45999320712).jpg

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
    'Short SC.7 Skyvan',
    'Short SC.7 Skyvan',
    'Short SC.7 Skyvan 3M',
    'Short SC.7 Skyvan 3M',
    'La « boîte à chaussures volante » de Belfast, utilitaire à décollage court des petites forces aériennes',
    'Belfast''s ''Flying Shoebox'', a rugged short take-off utility transport for smaller air forces',
    '/assets/airplanes/short-skyvan.jpg',
    E'## Genèse\nEn 1958, **Short Brothers**, à Belfast, est approché par **F.G. Miles Ltd**, qui cherche un soutien pour produire le **Caravan**, un utilitaire issu des travaux de **Hurel-Dubois** sur les ailes à grand allongement. Short rachète le projet et les données d''essais du prototype HDM.105, mais rejette le Caravan et dessine son propre utilitaire tout métal : le **SC.7 Skyvan**. La construction commence en 1960 à l''aéroport de Sydenham. Le prototype vole le 17 janvier 1963 avec deux moteurs à pistons Continental, puis reçoit dès cette année-là ses turbopropulseurs **Turbomeca Astazou**.\n\n## Conception\nLe Skyvan est un monoplan à aile haute haubanée de grand allongement, avec un fuselage non pressurisé de section carrée, une double dérive et un train tricycle fixe. Sa silhouette de wagon de marchandises, qui lui vaut le surnom de *Flying Shoebox*, cache une grande porte arrière qui facilite le chargement. Les Astazou se révélant limités en température en altitude, Short passe en 1968 à la **Série 3**, motorisée par deux **Garrett TPE331** de 715 ch. Il lui suffit de 482 m pour décoller et franchir 15 m de hauteur. Pour les militaires, le **Skyvan 3M** porte une masse au décollage accrue, jusqu''à 6 804 kg pour le 3M-200, et jusqu''à 22 passagers.\n\n## Carrière opérationnelle\nLe 3M sert au largage de ravitaillement et de parachutistes, au transport d''assaut, de troupes et de fret, à l''évacuation sanitaire et aux recherches et sauvetage. Une vingtaine de pays l''emploient, dont l''Autriche, le Ghana, le Népal, le Mexique ou la Mauritanie, qui en achète deux en 1975. Le 121e escadron de l''armée de l''air de **Singapour** l''utilise pour le transport et la recherche de 1973 à 1993. Le **Sultanat d''Oman** reçoit 16 Skyvan, dont un converti en patrouilleur maritime, le **Seavan** ; cinq volent encore en 2013. La **Garde côtière argentine** en achète cinq en 1971 et en perd deux pendant la **guerre des Malouines** ; les trois autres sont vendus en 1995, remplacés par des **CASA C-212 Aviocar**.\n\n## Place dans l''histoire\nShort produit 149 Skyvan, prototypes compris, jusqu''en 1986. L''appareil reste en service militaire au **Guyana**, qui en rachète deux d''occasion en 2019, et à Oman. Sa formule de boîte volante se prolonge dans les **Short 330** et **360**, puis dans le cargo militaire **C-23 Sherpa** de l''US Air Force. En 2023, un ancien Skyvan de la Garde côtière argentine revient au pays et est exposé à l''ESMA de Buenos Aires, en mémoire des victimes des « vols de la mort ». Ailleurs, sa grande porte arrière en a fait un favori des parachutistes sportifs.',
    E'## Genesis\nIn 1958 **Short Brothers** of Belfast was approached by **F.G. Miles Ltd**, which was seeking backing to produce the **Caravan**, a utility aircraft drawing on **Hurel-Dubois** work on high aspect ratio wings. Short acquired the design and the trials data from the HDM.105 prototype, but rejected the Caravan and drew up its own all-metal utility aircraft: the **SC.7 Skyvan**. Construction began at Sydenham Airport in 1960. The prototype first flew on 17 January 1963 with two Continental piston engines, before receiving later that year the **Turbomeca Astazou** turboprops intended from the outset.\n\n## Design\nThe Skyvan is a high-wing monoplane with a braced, high aspect ratio wing, an unpressurised square-section fuselage, twin fins and fixed tricycle landing gear. Its railway boxcar silhouette, which earned it the nickname *Flying Shoebox*, hides a large rear door that makes loading easy. As the Astazou proved temperature-limited at altitude, Short switched in 1968 to the **Series 3**, powered by two 715 shp **Garrett TPE331** engines. It needs only 482 m to take off and clear 15 m. For military customers, the **Skyvan 3M** offered higher take-off weights, up to 6,804 kg for the 3M-200, and up to 22 passengers.\n\n## Operational career\nThe 3M was used for supply dropping and paratroop dropping, assault, troop and cargo transport, casualty evacuation and search and rescue. Some twenty countries flew it, often in small forces: Austria, Ghana, Nepal, Mexico, and Mauritania, which bought two in 1975. No. 121 Squadron of the **Republic of Singapore Air Force** used it for transport and search-and-locate duties from 1973 to 1993. The **Sultan of Oman''s** air force received 16 Skyvans, one of them converted into a maritime patrol aircraft, the **Seavan**; five were still flying in 2013. The **Argentine Coast Guard** bought five in 1971 and lost two during the **Falklands War**; the other three were sold in 1995, replaced by **CASA C-212 Aviocars**.\n\n## Place in history\nShort built 149 Skyvans, prototypes included, until 1986. The type remains in military service in **Guyana**, which bought two second-hand examples in 2019, and in Oman. Its flying-box formula lived on in the **Short 330** and **360**, then in the US Air Force''s **C-23 Sherpa** military freighter. In 2023 a former Argentine Coast Guard Skyvan returned home and went on display at the ESMA in Buenos Aires, as a memorial to those killed in the ''death flights''. Elsewhere, its large rear door has made it a favourite of sport parachutists.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1958-01-01',
    '1963-01-17',
    '1971-01-01',
    324,
    1115,
    (SELECT id FROM manufacturer WHERE code = 'SHO'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Short SC.7 Skyvan'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Short SC.7 Skyvan'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Short SC.7 Skyvan'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Short SC.7 Skyvan'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Short SC.7 Skyvan'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 12.21,
  wingspan          = 19.79,
  height            = 4.6,
  wing_area         = 35.12,
  empty_weight      = 3331,
  mtow              = 6804,
  service_ceiling   = 6858,
  climb_rate        = 8.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett AiResearch TPE331-2-201A (715 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1963,
  production_end    = 1986,
  units_built       = 50,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 21,
  variants          = E'- **Skyvan 1 / 1A** : prototype à moteurs à pistons Continental GTSIO-520, remotorisé en 1963 avec des turbopropulseurs Turbomeca Astazou II\n- **Skyvan 2** : première série à turbopropulseurs Astazou, 8 exemplaires dont le second prototype\n- **Skyvan 3** : série principale à turbopropulseurs Garrett TPE331, produite à partir de 1968\n- **Skyvan 3M-100, -200 et -400** : versions militaires à masse au décollage accrue, pour le largage, le transport d''assaut, l''évacuation sanitaire et le sauvetage\n- **Seavan** : patrouilleur maritime unique, converti d''un 3M-400 pour l''armée de l''air d''Oman',
  variants_en       = E'- **Skyvan 1 / 1A**: prototype with Continental GTSIO-520 piston engines, re-engined in 1963 with Turbomeca Astazou II turboprops\n- **Skyvan 2**: first production series with Astazou turboprops, 8 built including the second prototype\n- **Skyvan 3**: main production series with Garrett TPE331 turboprops, built from 1968\n- **Skyvan 3M-100, -200 and -400**: military versions with higher take-off weights, for airdrop, assault transport, casualty evacuation and rescue\n- **Seavan**: single maritime patrol aircraft, converted from a 3M-400 for the Royal Air Force of Oman',

  -- Strate 4 : qualitatif
  nickname          = 'Flying Shoebox',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Short_Skyvan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Short_SC.7_Skyvan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Short SC.7 Skyvan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Short SC.7 Skyvan';
