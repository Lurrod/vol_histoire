-- Fiat / Aeritalia G.91Y
--
-- Photo : G91Y (19118518688).jpg
--   licence CC BY-SA 2.0 — Rob Schleiffert from Holland
--   https://commons.wikimedia.org/wiki/File:G91Y_(19118518688).jpg

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
    'Aeritalia G.91Y',
    'Aeritalia G.91Y',
    'Fiat / Aeritalia G.91Y',
    'Fiat / Aeritalia G.91Y',
    'G.91 biréacteur aux performances fortement accrues, avion d''attaque et de reconnaissance italien de 1970 à 1994',
    'Twin-engined G.91 with much improved performance, Italy''s attack and reconnaissance aircraft from 1970 to 1994',
    '/assets/airplanes/g91y.jpg',
    E'## Genèse\nChoisi en 1958 comme premier chasseur d''attaque léger de l''OTAN, le **Fiat G.91** donne satisfaction à l''armée de l''air italienne, qui obtient au milieu des années 1960 le soutien du gouvernement pour une version plus performante. Le projet est confié à son concepteur, **Giuseppe Gabrielli**, invité à ne pas trop s''écarter de l''avion de base pour en limiter le coût. Le nouvel avion dérive du biplace d''entraînement G.91T, mais remplace son unique réacteur Bristol Orpheus par deux **General Electric J85** à postcombustion, soit environ 60 % de poussée en plus. Le premier des avions de présérie vole le 27 décembre 1966.\n\n## Conception\nMalgré une forte ressemblance, le G.91Y est une refonte profonde. La structure est allégée, un réservoir supplémentaire occupe la place du siège arrière du G.91T et des becs de bord d''attaque automatiques améliorent la manœuvrabilité en combat. Il emporte jusqu''à 75 % de charge en plus que le G.91 tout en allant plus loin. L''avionique, très remaniée, réunit des systèmes américains, britanniques et canadiens produits sous licence en Italie. En essais, un avion atteint Mach 0,98 ; le tremblement rencontré à grande vitesse est corrigé sur la série en relevant légèrement l''empennage horizontal. Deux canons DEFA de 30 mm et quatre points d''emport sous voilure, pour 1 814 kg de charges, composent l''armement.\n\n## Carrière opérationnelle\nL''armée de l''air italienne commande deux lots, le second réduit de vingt à dix avions ; le dernier exemplaire est livré vers le milieu de 1976, pour un total de deux prototypes, vingt avions de présérie et quarante-cinq de série. Entre-temps, Fiat Aviazione a fusionné avec Aerfer en 1969 pour former **Aeritalia**. Surnommé *Yankee*, d''après la lettre Y de l''alphabet de l''OTAN, l''avion équipe à partir de 1970 le 101° Gruppo du 8° Stormo à Cervia, puis dès 1974 le 13° Gruppo du 32° Stormo à Brindisi, en attaque comme en reconnaissance, au-dessus de la terre comme de la mer.\n\n## Place dans l''histoire\nLe G.91Y ne trouve aucun client étranger. La **Suisse** évalue le G.91YS, doté d''une avionique améliorée et de points d''emport pour missiles AIM-9 Sidewinder, qui vole le 16 octobre 1970, mais commande finalement le **F-5** de Northrop. Seule utilisatrice, l''armée de l''air italienne garde ses Yankee jusqu''en 1994, quand l''**AMX** les remplace. Dernier développement de la lignée G.91, il montre jusqu''où une cellule conçue pour le concours de l''OTAN de 1953 pouvait être poussée grâce à une nouvelle motorisation.',
    E'## Genesis\nSelected in 1958 as NATO''s first lightweight strike fighter, the **Fiat G.91** satisfied the Italian Air Force, which in the mid-1960s won government backing for a higher-performance version. The project went to the aircraft''s designer, **Giuseppe Gabrielli**, who was asked not to stray too far from the original in order to keep costs down. The new aircraft was derived from the two-seat G.91T trainer, but replaced its single Bristol Orpheus turbojet with a pair of afterburning **General Electric J85s**, giving roughly 60 per cent more thrust. The first pre-production aircraft flew on 27 December 1966.\n\n## Design\nDespite a strong resemblance, the G.91Y was an extensive redesign. The structure was lightened, an extra fuel tank took the place of the G.91T''s rear seat and automatic leading-edge slats improved combat manoeuvrability. It could carry up to 75 per cent more payload than the G.91 while flying further. The avionics were heavily revised, combining American, British and Canadian systems licence-built in Italy. In testing one aircraft reached Mach 0.98; buffeting met at high speed was cured on production aircraft by raising the tailplane slightly. Two 30 mm DEFA cannon and four underwing pylons carrying 1,814 kg of stores made up the armament.\n\n## Operational career\nThe Italian Air Force ordered two batches, the second cut from twenty aircraft to ten; the last was delivered around mid-1976, for a total of two prototypes, twenty pre-series and forty-five series aircraft. In the meantime Fiat Aviazione had merged with Aerfer in 1969 to form **Aeritalia**. Nicknamed *Yankee*, after the letter Y in NATO''s phonetic alphabet, the aircraft equipped 101° Gruppo of 8° Stormo at Cervia from 1970, then 13° Gruppo of 32° Stormo at Brindisi from 1974, in both the attack and reconnaissance roles, over land and sea alike.\n\n## Place in history\nThe G.91Y found no export customer. **Switzerland** evaluated the G.91YS, with improved avionics and pylons for AIM-9 Sidewinder missiles, which first flew on 16 October 1970, but eventually ordered Northrop''s **F-5**. Its sole operator, the Italian Air Force, kept its Yankees until 1994, when the **AMX** replaced them. The last development of the G.91 line, it showed how far an airframe conceived for NATO''s 1953 competition could be pushed with a new powerplant.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    NULL,
    '1966-12-27',
    '1970-01-01',
    1110,
    3400,
    (SELECT id FROM manufacturer WHERE code = 'AIT'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.91Y'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.91Y'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.91Y'), (SELECT id FROM armement WHERE name = 'DEFA 552'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.91Y'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché')),
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.91Y'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Aeritalia G.91Y'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.67,
  wingspan          = 9.01,
  height            = 4.43,
  wing_area         = 18.13,
  empty_weight      = 3900,
  mtow              = 8700,
  service_ceiling   = 12500,
  climb_rate        = 86,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-13A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur avec postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 12.12,
  thrust_wet        = 18.15,

  -- Strate 3 : production & service
  production_start  = 1966,
  production_end    = 1976,
  units_built       = 67,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **G.91Y** : deux prototypes, vingt avions de présérie et quarante-cinq de série, deux réacteurs J85-GE-13A\n- **G.91YS** : prototype destiné à la Suisse, avionique améliorée et points d''emport pour AIM-9 Sidewinder, premier vol le 16 octobre 1970\n- **G.91YT** : projet de biplace d''entraînement, non réalisé',
  variants_en       = E'- **G.91Y**: two prototypes, twenty pre-series and forty-five series aircraft, two J85-GE-13A engines\n- **G.91YS**: prototype for Switzerland, improved avionics and pylons for AIM-9 Sidewinder, first flown on 16 October 1970\n- **G.91YT**: projected two-seat trainer, not built',

  -- Strate 4 : qualitatif
  nickname          = 'Yankee',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Aeritalia_G.91Y',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fiat_G.91Y',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Rob Schleiffert',
  image_licence     = 'CC BY-SA 2.0'
WHERE name = 'Aeritalia G.91Y';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Aeritalia G.91Y';
