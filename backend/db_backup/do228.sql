-- Dornier 228
--
-- Photo : Dornier Do228-212NG 98+35 (9425767928).jpg
--   licence CC BY-SA 2.0 — Alan Wilson
--   https://commons.wikimedia.org/wiki/File:Dornier_Do228-212NG_98%2B35_(9425767928).jpg

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
    'Dornier 228',
    'Dornier 228',
    'Dornier 228',
    'Dornier 228',
    'Petit bimoteur à aile de technologie nouvelle, devenu l''œil des marines et garde-côtes de l''Inde à l''Allemagne',
    'A small twin built around a new-technology wing, now the eye of navies and coast guards from India to Germany',
    '/assets/airplanes/dornier-228.jpg',
    E'## Genèse\nÀ la fin des années 1970, **Dornier** met au point, avec l''aide financière de l''État fédéral, une voilure d''un genre nouveau, la **TNT** (*Tragflügel neuer Technologie*). Elle est d''abord essayée sur un **Do 28 Skyservant** à turbopropulseurs, rebaptisé **Do 128**. Pour la commercialiser, Dornier lui dessine un nouveau fuselage en deux longueurs, de 15 et 19 places, présentées au salon de Hanovre en 1980. Les deux prototypes volent le 28 mars et le 9 mai 1981 ; certifié en Allemagne le 18 décembre 1981, le **Do 228** entre en service en juillet 1982 chez la compagnie norvégienne Norving.\n\n## Conception\nL''aile, à profil supercritique, est la vraie nouveauté : un caisson rectangulaire usiné dans quatre panneaux d''alliage, avec nervures, lisses, bord de fuite et volets Fowler en Kevlar, environ 15 % plus léger qu''une aile classique et bien moins riveté. Elle donne beaucoup de portance à basse vitesse et permet d''opérer depuis des pistes courtes et non revêtues. Deux turbopropulseurs **Garrett TPE331** entraînent les hélices ; le fuselage rectangulaire, à grandes portes latérales, accueille 19 passagers ou du fret. Avec dix heures d''endurance, il accepte radar de surveillance à 360 degrés, radar latéral, caméra infrarouge, projecteur, liaison de données et liaison satellite.\n\n## Carrière opérationnelle\nEn novembre 1983, **Hindustan Aeronautics** obtient une licence : la chaîne de Kanpur sort son premier avion en 1985, et 125 exemplaires indiens équipent l''armée de l''air, la marine et les garde-côtes de l''Inde, premier utilisateur mondial du type. La marine allemande en emploie à partir de 1991 pour traquer les pollutions en mer du Nord et en Baltique ; la Thaïlande et le Bangladesh l''adoptent pour la patrouille maritime, et il existe une version d''écoute électronique. Le 24 février 1985, un Do 228 de recherche polaire de l''institut Alfred Wegener est abattu « par erreur » par le Front Polisario au-dessus du Sahara occidental. Le 10 juin 2024, celui de l''armée du Malawi s''écrase avec le vice-président Saulos Chilima à bord.\n\n## Place dans l''histoire\nEnviron 245 Do 228 sortent d''Oberpfaffenhofen jusqu''en 1998, auxquels s''ajoute la production indienne. **RUAG** relance en 2009 un **Do 228NG** à cockpit numérique et hélices composites à cinq pales, puis **General Atomics** rachète la chaîne en 2020-2021. Utilitaire sans éclat apparent, le Do 228 doit sa longévité à son aile : elle en fait un patrouilleur économique, capable de tenir l''air longtemps et de se poser presque partout.',
    E'## Genesis\nIn the late 1970s **Dornier**, with financial support from the federal government, developed a new kind of wing, the **TNT** (*Tragflügel neuer Technologie*). It was first tried on a turboprop **Do 28 Skyservant**, renamed **Do 128**. To market it, Dornier designed a new fuselage in two lengths, with 15 and 19 seats, shown at the Hanover air show in 1980. The two prototypes flew on 28 March and 9 May 1981; certified in Germany on 18 December 1981, the **Do 228** entered service in July 1982 with the Norwegian airline Norving.\n\n## Design\nThe supercritical wing was the real novelty: a rectangular box machined from four alloy panels, with ribs, stringers, trailing edge and Fowler flaps in Kevlar, about 15% lighter than a conventional wing and with far fewer rivets. It generates high lift at low speed and allows operations from short, unpaved strips. Two **Garrett TPE331** turboprops drive the propellers; the rectangular fuselage, with large side doors, carries 19 passengers or cargo. With ten hours'' endurance, it can take a 360-degree surveillance radar, side-looking radar, infrared camera, searchlight, data link and satellite link.\n\n## Operational career\nIn November 1983 **Hindustan Aeronautics** obtained a licence: the Kanpur line rolled out its first aircraft in 1985, and 125 Indian-built examples equip the air force, navy and coast guard of India, the type''s largest user. The German Navy used it from 1991 to hunt down pollution in the North Sea and the Baltic; Thailand and Bangladesh adopted it for maritime patrol, and a signals intelligence version exists. On 24 February 1985 a polar research Do 228 of the Alfred Wegener Institute was shot down, reportedly by mistake, by the Polisario Front over Western Sahara. On 10 June 2024 the Malawi army''s aircraft crashed with Vice-President Saulos Chilima aboard.\n\n## Place in history\nAbout 245 Do 228s left Oberpfaffenhofen until 1998, in addition to Indian production. **RUAG** relaunched it in 2009 as the **Do 228NG**, with a glass cockpit and five-blade composite propellers, then **General Atomics** bought the line in 2020-2021. An unassuming utility aircraft, the Do 228 owes its longevity to its wing: it makes it an economical patrol aircraft, able to stay aloft for a long time and land almost anywhere.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1979-11-07',
    '1981-03-28',
    '1982-07-01',
    NULL,
    2363,
    (SELECT id FROM manufacturer WHERE code = 'DOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier 228'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Dornier 228'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier 228'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Dornier 228'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique')),
((SELECT id FROM airplanes WHERE name = 'Dornier 228'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 16.56,
  wingspan          = 16.97,
  height            = 4.86,
  wing_area         = 32,
  empty_weight      = 3900,
  mtow              = 6575,
  service_ceiling   = 7620,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Garrett (Honeywell) TPE331-10 (776 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1981,
  production_end    = NULL,
  units_built       = 370,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Do 228-100** : version de base à 15 places, premier vol le 28 mars 1981\n- **Do 228-200** : fuselage allongé à 19 places, premier vol le 9 mai 1981, décliné en -201, -202 et -212 plus lourds et plus puissants\n- **HAL 228** : production sous licence à Kanpur pour l''armée de l''air, la marine et les garde-côtes indiens\n- **Do 228 LM / LT** : versions de surveillance des pollutions marines et de transport de la marine allemande\n- **Do 228NG** : relance de RUAG en 2009, cockpit numérique, hélices composites à cinq pales, certifiée par l''EASA le 18 août 2010',
  variants_en       = E'- **Do 228-100**: basic 15-seat version, first flight on 28 March 1981\n- **Do 228-200**: stretched 19-seat fuselage, first flight on 9 May 1981, developed into the heavier and more powerful -201, -202 and -212\n- **HAL 228**: licence production at Kanpur for the Indian air force, navy and coast guard\n- **Do 228 LM / LT**: German Navy marine pollution surveillance and transport versions\n- **Do 228NG**: RUAG relaunch in 2009, glass cockpit, five-blade composite propellers, EASA-certified on 18 August 2010',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dornier_228',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dornier_228',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Alan Wilson',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Dornier 228';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dornier 228';
