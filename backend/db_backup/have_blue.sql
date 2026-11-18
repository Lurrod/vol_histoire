-- Lockheed Have Blue
--
-- Photo : Have Blue bottom view.jpg
--   licence Public domain — Unknown author
--   https://commons.wikimedia.org/wiki/File:Have_Blue_bottom_view.jpg

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
    'Lockheed Have Blue',
    'Lockheed Have Blue',
    'Lockheed Have Blue',
    'Lockheed Have Blue',
    'Le « losange sans espoir » de Groom Lake, premier avion dessiné par l''ingénierie radar et ancêtre du F-117',
    'The Hopeless Diamond of Groom Lake, the first aircraft shaped by radar engineering and forerunner of the F-117',
    '/assets/airplanes/have-blue.jpg',
    E'## Genèse\nLa guerre du Kippour sert d''avertissement : en 1973, l''aviation israélienne perd 109 appareils en 18 jours face aux missiles sol-air. À ce rythme, l''OTAN serait à court d''avions en deux semaines face au Pacte de Varsovie. En 1974, la **DARPA** interroge en secret cinq constructeurs sur la possibilité d''un avion pratiquement indétectable ; **Lockheed**, absent des chasseurs depuis dix ans, n''est pas consulté et doit forcer l''entrée, sans contrat public. Le 1er novembre 1975, Lockheed et Northrop reçoivent chacun 1,5 million de dollars pour la phase 1 du programme **Experimental Survivable Testbed** ; en avril 1976, Lockheed l''emporte.\n\n## Conception\nAux **Skunk Works** de **Ben Rich**, l''ingénieur **Denys Overholser** propose une idée simple : des surfaces planes, inclinées pour renvoyer les ondes radar loin de l''émetteur. Le logiciel ECHO 1, enrichi des travaux du Soviétique **Pyotr Ufimtsev** sur la diffraction, départage vingt formes et retient une aile delta à facettes, le « Hopeless Diamond », dont **Kelly Johnson** se moque ouvertement. C''est le premier avion dont la forme est dictée par l''ingénierie radar plutôt que par l''aérodynamique. Instable par nature, il vole grâce à des commandes de vol électriques à quadruple redondance reprises du F-16 ; le train vient du F-5, les deux réacteurs J85 du T-2C Buckeye.\n\n## Essais\nAchevé pendant une grève par des cadres de Lockheed, le HB1001 est acheminé en C-5 jusqu''à Groom Lake et vole pour la première fois le 1er décembre 1977, piloté par **Bill Park**. Le 4 mai 1978, à son 36e vol, un atterrissage trop dur bloque son train à demi rentré : Park doit s''éjecter et ne volera plus en essais. Le HB1002, couvert de matériau absorbant et réservé aux mesures de signature, vole dès le 20 juillet 1978 avec le major **Ken Dyson**, seul à le piloter ; un incendie moteur le détruit le 11 juillet 1979, à son 52e vol. Les débris des deux appareils sont enterrés en secret.\n\n## Place dans l''histoire\nMalgré ses deux pertes, Have Blue est jugé concluant. Dès novembre 1977, l''US Air Force commande sous le nom de **Senior Trend** un avion opérationnel qui en dérive : le **F-117 Nighthawk**, plus grand, à la flèche réduite, aux dérives inclinées vers l''extérieur et doté de deux soutes. La compétition perdue par Northrop débouche, elle, sur le **Tacit Blue** puis le B-2. Le petit losange de Groom Lake ouvre l''ère des avions furtifs.',
    E'## Genesis\nThe Yom Kippur War was a warning: in 1973 the Israeli Air Force lost 109 aircraft in 18 days to surface-to-air missiles. At that rate NATO would run out of aircraft within two weeks against the Warsaw Pact. In 1974 **DARPA** secretly asked five manufacturers whether a virtually undetectable aircraft could be built; **Lockheed**, out of the fighter business for ten years, was not approached and had to force its way in, without a government contract. On 1 November 1975 Lockheed and Northrop each received $1.5 million for phase 1 of the **Experimental Survivable Testbed** programme; in April 1976 Lockheed won.\n\n## Design\nAt **Ben Rich**''s **Skunk Works**, engineer **Denys Overholser** proposed a simple idea: flat surfaces, tilted to reflect radar waves away from the emitter. The ECHO 1 software, enriched with Soviet scientist **Pyotr Ufimtsev**''s work on diffraction, sorted through twenty shapes and settled on a faceted delta, the Hopeless Diamond, openly mocked by **Kelly Johnson**. It was the first aircraft whose shape was set by radar engineering rather than aerodynamics. Inherently unstable, it flew thanks to a quadruple-redundant fly-by-wire system taken from the F-16; the landing gear came from the F-5 and the two J85 engines from the T-2C Buckeye.\n\n## Testing\nCompleted during a strike by Lockheed managers, HB1001 was flown by C-5 to Groom Lake and made its first flight on 1 December 1977 with **Bill Park** at the controls. On 4 May 1978, on its 36th flight, a hard landing jammed its gear half-retracted: Park had to eject and never flew test sorties again. HB1002, covered in radar-absorbent material and devoted to signature measurements, flew from 20 July 1978 with Major **Ken Dyson**, its only pilot; an engine fire destroyed it on 11 July 1979, on its 52nd flight. The debris of both aircraft was buried in secret.\n\n## Place in history\nDespite both losses, Have Blue was judged a success. As early as November 1977 the US Air Force ordered an operational derivative under the name **Senior Trend**: the **F-117 Nighthawk**, larger, with less sweep, outward-canted fins and two weapons bays. The competition Northrop lost led instead to **Tacit Blue** and then the B-2. The little diamond of Groom Lake opened the age of stealth aircraft.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1975-11-01',
    '1977-12-01',
    NULL,
    965,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Have Blue'), (SELECT id FROM tech WHERE name = 'Conception furtive')),
((SELECT id FROM airplanes WHERE name = 'Lockheed Have Blue'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed Have Blue'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.4,
  wingspan          = 6.86,
  height            = 2.29,
  wing_area         = 35.9,
  empty_weight      = 4060,
  mtow              = 5670,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-4A',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 13.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **HB1001** : premier vol le 1er décembre 1977, camouflage trois tons, perdu le 4 mai 1978 à son 36e vol\n- **HB1002** : peint en gris, couvert de matériau absorbant pour les mesures radar, perdu le 11 juillet 1979 à son 52e vol\n- **Maquettes au tiers** : en bois, l''une couverte de feuille métallique pour valider ECHO 1, l''autre pour la soufflerie\n- **Senior Trend** : programme opérationnel commandé en 1977, devenu le F-117 Nighthawk',
  variants_en       = E'- **HB1001**: first flight on 1 December 1977, three-tone camouflage, lost on 4 May 1978 on its 36th flight\n- **HB1002**: grey paint, covered in radar-absorbent material for signature tests, lost on 11 July 1979 on its 52nd flight\n- **One-third scale models**: wooden, one foil-covered to check ECHO 1, the other for the wind tunnel\n- **Senior Trend**: operational programme ordered in 1977, which became the F-117 Nighthawk',

  -- Strate 4 : qualitatif
  nickname          = 'Hopeless Diamond',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Lockheed_Have_Blue',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_Have_Blue',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Lockheed Have Blue';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'tres_elevee' WHERE name = 'Lockheed Have Blue';
