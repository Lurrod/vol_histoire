-- Dornier C-146A Wolfhound (Dornier 328)
--
-- Photo : C-146A Wolfhound from Hurlburt Field, Florida.jpg
--   licence Public domain — U.S. Air National Guard/Master Sgt. Scott Thompson
--   https://commons.wikimedia.org/wiki/File:C-146A_Wolfhound_from_Hurlburt_Field,_Florida.jpg

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
    'Dornier C-146A Wolfhound',
    'Dornier C-146A Wolfhound',
    'Dornier C-146A Wolfhound (Dornier 328)',
    'Dornier C-146A Wolfhound (Dornier 328)',
    'Avion de ligne régional allemand reconverti pour déposer les forces spéciales américaines, jusque sur une autoroute',
    'German regional airliner converted to deliver US special forces, even onto a highway',
    '/assets/airplanes/dornier-c146a-wolfhound.jpg',
    E'## Genèse\nEn 1984, une étude de marché de **Dornier**, alors filiale de Deutsche Aerospace, décèle le besoin d''un avion régional d''une trentaine de places, rapide, silencieux et facile à entretenir. Relancé en décembre 1988, le **Dornier 328** vole le 6 décembre 1991 et entre en service commercial le 13 octobre 1993. Mais il arrive sur un marché encombré, en pleine récession et face aux nouveaux jets régionaux : Fairchild rachète Dornier en 1996, puis fait faillite en avril 2002, après 107 exemplaires. En 2015, l''américain **Sierra Nevada Corporation** acquiert la société qui détient le certificat de type.\n\n## Conception\nLe 328 est un biturbopropulseur pressurisé au fuselage profilé pour la vitesse : il croise à 620 km/h, assez vite pour s''insérer entre les jets dans les approches des grands aéroports. Il reprend la voilure supercritique du Dornier 228 et fait un large usage des composites de Kevlar et de carbone, qui allègent la cellule de 20 %. Deux turbopropulseurs **Pratt & Whitney Canada PW119** entraînent des hélices Hartzell à six pales, peu bruyantes. Son train à pneus basse pression, sa roulette avant orientable et son déflecteur de gravillons lui permettent d''opérer sur pistes sommaires, un atout pour un usage militaire.\n\n## Carrière opérationnelle\nÀ partir de 2009, **Sierra Nevada Corporation** convertit dix-sept 328 en avions de transport tactique pour l''US Air Force, sous la désignation **C-146A Wolfhound**. Livrés entre 2011 et juillet 2013 au 524th Special Operations Squadron du 27th Special Operations Wing, ils servent l''Air Force Special Operations Command, qui en aligne vingt en 2020. Le 24 février 2026, lors d''un exercice avec les forces philippines et des équipes Special Tactics américaines, un C-146A se pose sur une route de contournement à Laoac, dans la province de Pangasinan : c''est la première fois qu''un avion américain de ce type atterrit sur une route publique philippine.\n\n## Place dans l''histoire\nDernier avion de transport entièrement conçu et réalisé par une entreprise allemande, le 328 doit sa seconde vie aux forces spéciales américaines. En août 2019, l''US Air Force est de loin son premier utilisateur, avec vingt appareils sur 58 turbopropulseurs encore en service. Le type renaît aussi chez Deutsche Aircraft, qui développe une version allongée de quarante places, le **D328eco**, assemblée à Leipzig.',
    E'## Genesis\nIn 1984 market research by **Dornier**, then part of Deutsche Aerospace, identified the need for a fast, quiet and easy-to-maintain regional aircraft of around thirty seats. Relaunched in December 1988, the **Dornier 328** first flew on 6 December 1991 and entered commercial service on 13 October 1993. But it reached a crowded market, in a recession and against the new regional jets: Fairchild bought Dornier in 1996, then went bankrupt in April 2002, after 107 aircraft. In 2015 the American firm **Sierra Nevada Corporation** acquired the company holding the type certificate.\n\n## Design\nThe 328 is a pressurised twin turboprop with a fuselage streamlined for speed: it cruises at 620 km/h, fast enough to slot in among jets on approach to major airports. It reuses the supercritical wing of the Dornier 228 and makes extensive use of Kevlar and carbon composites, which cut the airframe''s weight by 20%. Two **Pratt & Whitney Canada PW119** turboprops drive quiet six-bladed Hartzell propellers. Its high-flotation tyres, steerable nose gear and gravel guard let it operate from rough strips, an asset for military use.\n\n## Operational career\nFrom 2009 **Sierra Nevada Corporation** converted seventeen 328s into tactical transports for the US Air Force, designated **C-146A Wolfhound**. Delivered between 2011 and July 2013 to the 524th Special Operations Squadron of the 27th Special Operations Wing, they serve Air Force Special Operations Command, which fielded twenty of them in 2020. On 24 February 2026, during an exercise with Philippine forces and US Special Tactics teams, a C-146A landed on a bypass road at Laoac, in Pangasinan province: the first time an American aircraft of this type had touched down on a Philippine public highway.\n\n## Place in history\nThe last transport aircraft designed and built entirely by a German company, the 328 owes its second life to American special forces. In August 2019 the US Air Force was by far its largest operator, with twenty of the 58 turboprops still in service. The type is also being reborn at Deutsche Aircraft, which is developing a stretched forty-seat version, the **D328eco**, assembled in Leipzig.',
    (SELECT id FROM countries WHERE code = 'DEU'),
    '1988-12-01',
    '1991-12-06',
    '2011-01-01',
    620,
    1852,
    (SELECT id FROM manufacturer WHERE code = 'DOR'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier C-146A Wolfhound'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Dornier C-146A Wolfhound'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Dornier C-146A Wolfhound'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 21.28,
  wingspan          = 20.98,
  height            = 7.24,
  wing_area         = 40.0,
  empty_weight      = 8920,
  mtow              = 13990,
  service_ceiling   = 9492,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PW119B (2 210 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 2009,
  production_end    = NULL,
  units_built       = 20,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **328-100** : version de ligne initiale, jusqu''à 33 passagers\n- **328-110 / 120 / 130** : masses et autonomie accrues, performances de piste courte améliorées, gouverne de direction adaptée aux grandes vitesses\n- **328JET** : version à turbosoufflantes Pratt & Whitney Canada PW308, premier vol le 20 janvier 1998\n- **C-146A Wolfhound** : 328 convertis par Sierra Nevada Corporation pour l''Air Force Special Operations Command, vingt en service\n- **D328eco** : version allongée de quarante places développée par Deutsche Aircraft, assemblée à Leipzig',
  variants_en       = E'- **328-100**: initial airliner version, up to 33 passengers\n- **328-110 / 120 / 130**: higher weights and range, improved short-field performance, rudder authority reduced at high speed\n- **328JET**: version with Pratt & Whitney Canada PW308 turbofans, first flight on 20 January 1998\n- **C-146A Wolfhound**: 328s converted by Sierra Nevada Corporation for Air Force Special Operations Command, twenty in service\n- **D328eco**: stretched forty-seat version developed by Deutsche Aircraft, assembled in Leipzig',

  -- Strate 4 : qualitatif
  nickname          = 'Wolfhound',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dornier_328',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dornier_328',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Master Sgt. Scott Thompson, U.S. Air National Guard',
  image_licence     = 'Public domain'
WHERE name = 'Dornier C-146A Wolfhound';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Dornier C-146A Wolfhound';
