-- Nord-Aviation N262 Frégate
--
-- Photo : No. 51 a Nord 262E 28 Flotille Marine Nationale French Navy (3100246182).jpg
--   licence CC BY 2.0 — Jerry Gunner from Lincoln, UK
--   https://commons.wikimedia.org/wiki/File:No._51_a_Nord_262E_28_Flotille_Marine_Nationale_French_Navy_(3100246182).jpg

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
    'Nord 262',
    'Nord 262',
    'Nord-Aviation N262 Frégate',
    'Nord-Aviation N 262 Frégate',
    'Le petit biturbopropulseur français qui a formé et transporté les équipages de l''Aéronavale jusqu''en 2009',
    'The small French twin turboprop that trained and carried French naval aircrew until 2009',
    '/assets/airplanes/nord-262.jpg',
    E'## Genèse\nEn 1957, **Max Holste** lance un bimoteur utilitaire destiné à remplacer le DC-3 : le MH.250 Super Broussard, à moteurs en étoile, vole le 20 mai 1959 à Reims, suivi le 29 juillet 1960 du MH.260 à turbopropulseurs **Turbomeca Bastan**. Trop petite pour produire en série, la société s''associe à **Nord-Aviation**, qui reprend tout le programme. Le N260 non pressurisé ne trouve guère d''acheteurs ; Nord le redessine donc à partir de mai 1961 pour satisfaire aux nouvelles normes françaises et américaines. Le prototype du **N262** prend l''air le 24 décembre 1962.\n\n## Conception\nLe N262 est un monoplan à aile haute entièrement métallique, à train tricycle escamotable dont les roues principales se logent dans des carénages de fuselage. La pressurisation impose un fuselage de section circulaire, qui accueille 26 à 29 passagers derrière deux pilotes. Deux Bastan entraînent des hélices tripales Ratier-Figeac de 3,2 m. Les versions C et D reçoivent le Bastan VIIC, plus puissant, et une envergure accrue ; la version D est commercialisée sous le nom de **Frégate**. Aux États-Unis, le Mohawk 298 remplace le Bastan par le Pratt & Whitney Canada PT6A.\n\n## Carrière opérationnelle\nCertifié le 16 juillet 1964, l''avion entre en service chez Air Inter en septembre, mais l''essentiel des ventes est militaire. L''Armée de l''air l''emploie dans ses escadrilles de liaison puis ses escadrons de transport et d''entraînement jusqu''au 1er juillet 2004, ainsi que pour former navigateurs et officiers systèmes d''armes. L''**Aéronautique navale** en acquiert une vingtaine à partir de 1967 : transport, liaisons d''état-major, formation des pilotes d''Atlantic et des mécaniciens navigants. Douze N262E reçoivent un radar pour la surveillance maritime et l''entraînement de la flottille 28F, qui les engage aussi lors du naufrage de l''*Erika*. Le dernier est retiré le 25 février 2009.\n\n## Place dans l''histoire\nCent dix N262 sont construits jusqu''en 1976, la production passant à l''Aérospatiale après la fusion de 1970. Le Gabon, le Burkina Faso, le Congo et l''Angola l''emploient aussi. À la fin des années 1970, le gouvernement préfère l''**Embraer EMB-121 Xingu**, plus économique, à une relance du Frégate pour les liaisons et l''entraînement militaires. Modeste commercialement, le N262 a pourtant permis à l''industrie française de s''installer sur le marché du transport régional et de préparer les futurs **ATR 42 et ATR 72**.',
    E'## Genesis\nIn 1957 **Max Holste** launched a utility twin intended to replace the DC-3: the radial-engined MH.250 Super Broussard flew on 20 May 1959 at Reims, followed on 29 July 1960 by the MH.260 with **Turbomeca Bastan** turboprops. Too small to build it in series, the company teamed up with **Nord-Aviation**, which took over the whole programme. The unpressurised N260 found few buyers, so from May 1961 Nord redesigned it to meet new French and American standards. The **N262** prototype took to the air on 24 December 1962.\n\n## Design\nThe N262 was an all-metal high-wing monoplane with retractable tricycle gear, the main wheels retracting into fuselage fairings. Pressurisation required a circular-section fuselage, seating 26 to 29 passengers behind two pilots. Two Bastans drove three-bladed 3.2 m Ratier-Figeac propellers. The C and D versions received the more powerful Bastan VIIC and a greater span; the D was marketed as the **Frégate**. In the United States, the Mohawk 298 replaced the Bastan with the Pratt & Whitney Canada PT6A.\n\n## Operational career\nCertified on 16 July 1964, the aircraft entered service with Air Inter in September, but most sales were military. The French Air Force used it in its liaison flights and later its transport and training squadrons until 1 July 2004, as well as to train navigators and weapon systems officers. The **Aéronautique navale** acquired some twenty from 1967: transport, staff liaison, training of Atlantic pilots and flight engineers. Twelve N262Es received radar for maritime surveillance and training with flotilla 28F, which also deployed them after the sinking of the *Erika*. The last was retired on 25 February 2009.\n\n## Place in history\nA hundred and ten N262s were built until 1976, production passing to Aérospatiale after the 1970 merger. Gabon, Burkina Faso, Congo and Angola also used it. In the late 1970s the government preferred the more economical **Embraer EMB-121 Xingu** to a relaunch of the Frégate for military liaison and training. A modest commercial success, the N262 nonetheless gave the French industry a foothold in the regional transport market and paved the way for the future **ATR 42 and ATR 72**.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1961-05-01',
    '1962-12-24',
    '1964-09-01',
    385,
    1110,
    (SELECT id FROM manufacturer WHERE code = 'NRD'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord 262'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Nord 262'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Nord 262'), (SELECT id FROM missions WHERE name = 'Entraînement au combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 19.28,
  wingspan          = 21.9,
  height            = 6.21,
  wing_area         = 55,
  empty_weight      = 6654,
  mtow              = 10300,
  service_ceiling   = 7300,
  climb_rate        = 6.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Turbomeca Bastan VIC (1 065 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1962,
  production_end    = 1976,
  units_built       = 110,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 5,
  variants          = E'- **N262A** : première version de série à Bastan VIC, achetée par des compagnies, l''Armée de l''air et l''Aéronautique navale\n- **N262B** : quatre exemplaires pour Air Inter, livrés à partir de juillet 1964\n- **N262C / D Frégate** : Bastan VIIC et envergure accrue ; le D, version de l''Armée de l''air, trouve surtout des clients militaires\n- **N262E** : douze N262A de l''Aéronautique navale dotés d''un radar pour la surveillance maritime et l''entraînement\n- **Mohawk 298** : neuf conversions américaines à turbopropulseurs PT6A-45 et hélices pentapales, de 1975 à 1978',
  variants_en       = E'- **N262A**: first production version with the Bastan VIC, bought by airlines, the French Air Force and the Aéronautique navale\n- **N262B**: four aircraft for Air Inter, delivered from July 1964\n- **N262C / D Frégate**: Bastan VIIC and greater span; the D, the Air Force version, found mainly military customers\n- **N262E**: twelve Aéronautique navale N262As fitted with radar for maritime surveillance and training\n- **Mohawk 298**: nine American conversions with PT6A-45 turboprops and five-bladed propellers, 1975 to 1978',

  -- Strate 4 : qualitatif
  nickname          = 'Frégate',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Nord-Aviation_N262',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Aérospatiale_N_262',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jerry Gunner',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Nord 262';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Nord 262';
