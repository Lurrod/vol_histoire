-- Canadair CL-215
--
-- Photo : Canadair CL-215T "Scooper" (2461854645).jpg
--   licence CC BY-SA 2.0 — Andy Mitchell from Glasgow, UK
--   https://commons.wikimedia.org/wiki/File:Canadair_CL-215T_%22Scooper%22_(2461854645).jpg

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
    'Canadair CL-215',
    'Canadair CL-215',
    'Canadair CL-215',
    'Canadair CL-215',
    'Le premier avion conçu pour bombarder les feux d''eau, au point que « Canadair » est devenu un nom commun',
    'The first aircraft designed from the outset as a water bomber, so famous that in France its maker''s name became a word',
    '/assets/airplanes/canadair-cl215.jpg',
    E'## Genèse\nÀ la fin des années 1950, on combat les feux de forêt avec des avions hérités de la guerre, bombardiers B-17 ou hydravions **Catalina** convertis. Au début des années 1960, le service aérien du gouvernement du Québec demande à **Canadair** un moyen plus efficace de jeter de l''eau sur les incendies. Un projet d''hydravion de transport devient ainsi, en 1962, l''avant-projet **CL-204** : un bombardier d''eau amphibie à deux moteurs en étoile **Pratt & Whitney R-2800**. Dévoilé au salon du Bourget en 1965, le **CL-215** est lancé le 1er février 1966 et vole le 23 octobre 1967 : c''est le premier avion conçu dès l''origine pour ce rôle.\n\n## Conception\nToute la cellule est dictée par la mission. Sous le plancher, deux soutes placées au centre de gravité se vident par de grandes trappes ; pour les remplir, l''avion frôle la surface d''un lac ou de la mer et ses écopes avalent environ cinq tonnes d''eau en une dizaine de secondes, sans s''arrêter. La coque, sur toute la longueur du fuselage, encaisse ces chocs hydrodynamiques ; la structure, à sécurité intégrée, est protégée contre la corrosion selon les normes de l''US Navy. Choix étonnant, le R-2800 n''est plus fabriqué : mais les stocks sont immenses et un moteur à pistons est jugé plus robuste en milieu marin. L''avion doit rester maniable à basse vitesse, par vent en rafales, au-dessus d''un feu.\n\n## Carrière opérationnelle\nEn juin 1969, le premier exemplaire est livré à la Protection civile française, qui en utilise quinze jusqu''en 1996 : le mot « Canadair » y désigne désormais tout bombardier d''eau. Plusieurs forces armées l''adoptent. L''armée de l''air espagnole en loue deux en 1970, puis en achète d''autres en 1973, payés en vin espagnol livré au Québec ; ils forment le 43e Groupe, avec une mission secondaire de sauvetage en mer. L''armée de l''air grecque, l''aviation yougoslave de 1981 à 1992 puis l''armée de l''air croate l''emploient aussi, et la marine thaïlandaise en reçoit deux en 1978, consacrés au sauvetage dans le golfe de Thaïlande. Un CL-215 dépasse souvent les cent largages par jour.\n\n## Place dans l''histoire\nCanadair construit 125 CL-215 pour onze pays jusqu''en 1990. La version **CL-215T** remplace les moteurs à pistons par des turbopropulseurs **PW123AF** (premier vol le 8 juin 1989) et ouvre la voie au **CL-415**, produit à partir de 1993. En 2018, Viking Air rachète les droits et lance le **CL-515**. Plus d''un demi-siècle après son premier vol, le CL-215 a fait de l''hydravion écopeur l''outil de référence contre les feux, des forêts canadiennes aux îles grecques.',
    E'## Genesis\nIn the late 1950s forest fires were fought with aircraft inherited from the war, converted B-17 bombers or **Catalina** flying boats. In the early 1960s the Quebec government air service asked **Canadair** for a more effective way of delivering water to fires. A transport floatplane project thus became, in 1962, the **CL-204** preliminary design: an amphibious water bomber with two **Pratt & Whitney R-2800** radial engines. Unveiled at the 1965 Paris Air Show, the **CL-215** was launched on 1 February 1966 and flew on 23 October 1967: it was the first aircraft designed from the outset for the role.\n\n## Design\nThe whole airframe was dictated by the mission. Under the floor, two tanks placed at the centre of gravity emptied through large doors; to refill them, the aircraft skimmed the surface of a lake or the sea and its scoops took in about five tonnes of water in some ten seconds, without stopping. The hull, running the full length of the fuselage, absorbed these hydrodynamic loads; the fail-safe structure was protected against corrosion to US Navy standards. Surprisingly, the R-2800 was no longer in production: but stocks were huge and a piston engine was judged more durable in a maritime environment. The aircraft had to remain manoeuvrable at low speed, in gusty air, over a fire.\n\n## Operational career\nIn June 1969 the first aircraft was delivered to the French civil protection agency, which used fifteen until 1996: in France the word "Canadair" now means any water bomber. Several armed forces adopted it. The Spanish Air Force leased two in 1970, then bought more in 1973, paid for with Spanish wine delivered to Quebec; they formed 43 Group, with a secondary sea rescue mission. The Hellenic Air Force, the Yugoslav air force from 1981 to 1992 and then the Croatian air force also used it, and the Royal Thai Navy received two in 1978, devoted to rescue in the Gulf of Thailand. A CL-215 often makes more than a hundred drops a day.\n\n## Place in history\nCanadair built 125 CL-215s for eleven countries until 1990. The **CL-215T** replaced the piston engines with **PW123AF** turboprops (first flight on 8 June 1989) and paved the way for the **CL-415**, produced from 1993. In 2018 Viking Air bought the rights and launched the **CL-515**. More than half a century after its first flight, the CL-215 made the scooping flying boat the reference tool against fires, from the Canadian forests to the Greek islands.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1962-01-01',
    '1967-10-23',
    '1969-06-01',
    NULL,
    2094,
    (SELECT id FROM manufacturer WHERE code = 'CDR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-215'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion')),
((SELECT id FROM airplanes WHERE name = 'Canadair CL-215'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Canadair CL-215'), (SELECT id FROM tech WHERE name = 'Système d''écopage'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CL-215'), (SELECT id FROM missions WHERE name = 'Largage de secours')),
((SELECT id FROM airplanes WHERE name = 'Canadair CL-215'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.82,
  wingspan          = 28.6,
  height            = 8.92,
  wing_area         = 100.33,
  empty_weight      = 12160,
  mtow              = 19731,
  service_ceiling   = NULL,
  climb_rate        = 5,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-83AM (2 100 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1969,
  production_end    = 1990,
  units_built       = 125,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 11,
  variants          = E'- **CL-215A** : version initiale de bombardier d''eau et de transport utilitaire, soutes, trappes et écopes\n- **CL-215B** : adaptée au sauvetage en mer et au fret, dont les deux appareils de la marine thaïlandaise\n- **CL-215C** : transport de passagers sans équipement de bombardier d''eau, jusqu''à 36 places\n- **CL-215T** : remotorisation à turbopropulseurs PW123AF annoncée en 1987, premier vol le 8 juin 1989 ; **CL-215GR** pour l''armée de l''air grecque\n- **CL-415EAF / CL-515** : modernisation proposée par Viking Air à partir de 2018, premier vol le 12 mars 2020',
  variants_en       = E'- **CL-215A**: initial water bomber and utility transport version, with tanks, doors and scoops\n- **CL-215B**: adapted for sea rescue and freight, including the Royal Thai Navy''s two aircraft\n- **CL-215C**: passenger transport without water-bombing equipment, up to 36 seats\n- **CL-215T**: re-engining with PW123AF turboprops announced in 1987, first flight on 8 June 1989; **CL-215GR** for the Hellenic Air Force\n- **CL-415EAF / CL-515**: upgrade offered by Viking Air from 2018, first flight on 12 March 2020',

  -- Strate 4 : qualitatif
  nickname          = 'Scooper',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Canadair_CL-215',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Canadair_CL-215',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Andy Mitchell',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Canadair CL-215';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Canadair CL-215';
