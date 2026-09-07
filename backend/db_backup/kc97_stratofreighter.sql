-- Boeing KC-97 Stratofreighter
--
-- Photo : USAF KC-97F refueling B-47B.jpg
--   licence Public domain — USAF
--   https://commons.wikimedia.org/wiki/File%3AUSAF_KC-97F_refueling_B-47B.jpg

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
    'KC-97 Stratofreighter',
    'KC-97 Stratofreighter',
    'Boeing KC-97 Stratofreighter',
    'Boeing KC-97 Stratofreighter',
    'Ravitailleur à hélices contraint de plonger pour suivre les bombardiers à réaction',
    'Piston tanker forced to dive to keep up with the jet bombers',
    '/assets/airplanes/kc97-stratofreighter.jpg',
    E'## Genèse\nLe Strategic Air Command a besoin de ravitailleurs, et il les lui faut vite. Boeing prend le chemin le plus court : greffer un fuselage à double bulle sur l''aile, les moteurs et l''empennage du **B-29**, déjà produits en série. Le C-97 naît ainsi en quelques mois, et sa version ravitailleuse suit en 1950 avec la perche rigide inventée pour le B-29.\n\n## Conception\nLe fuselage en huit couché offre deux ponts : équipage et fret en haut, réservoirs de transfert en bas. Le problème est ailleurs, et il est structurel : le KC-97 vole à **quatre cents nœuds au mieux**, quand un B-47 décroche en dessous de trois cent cinquante. Le ravitaillement ne peut donc se faire qu''en **descente commune** — le ravitailleur pique, le bombardier le suit, et les deux perdent trois mille mètres pendant le transfert. La manœuvre, appelée *toboggan*, est éprouvante et dangereuse.\n\n## Carrière opérationnelle\nHuit cent onze exemplaires portent à bout de bras toute la dissuasion américaine des années 1950 : sans eux, les B-47 ne franchissent pas l''Atlantique. On finit par leur ajouter **deux réacteurs en bout d''aile** pour combler l''écart de vitesse — un aveu mécanique. Ils servent encore au Vietnam, et la Garde nationale les exploite jusqu''en 1978.\n\n## Place dans l''histoire\nIl illustre une transition mal négociée : une flotte de bombardiers passée à la réaction avant ses ravitailleurs. Boeing en tirera la leçon en finançant sur ses fonds propres le démonstrateur qui donnera simultanément le **KC-135 Stratotanker** et le Boeing 707 — cette fois, ravitailleur et ravitaillé volant à la même vitesse.',
    E'## Genesis\nStrategic Air Command needed tankers, and needed them fast. Boeing took the shortest route: graft a double-bubble fuselage onto the wing, engines and tail of the **B-29**, already in mass production. The C-97 was born in months, and its tanker version followed in 1950 with the flying boom invented for the B-29.\n\n## Design\nThe figure-of-eight fuselage gives two decks: crew and freight above, transfer tanks below. The problem lies elsewhere, and it is structural: the KC-97 flies at **four hundred knots at best**, while a B-47 stalls below three hundred and fifty. Refuelling could therefore only happen in a **shared descent** — the tanker dives, the bomber follows, and both lose three thousand metres during the transfer. The manoeuvre, called the *toboggan*, was exhausting and dangerous.\n\n## Operational career\nEight hundred and eleven aircraft carried the whole of American deterrence through the 1950s: without them the B-47s could not cross the Atlantic. **Two jet engines were eventually added at the wingtips** to close the speed gap — a mechanical admission of defeat. They served over Vietnam, and the National Guard flew them until 1978.\n\n## Place in history\nIt illustrates a badly managed transition: a bomber fleet that went jet before its tankers did. Boeing learned the lesson and funded, from its own money, the demonstrator that produced both the **KC-135 Stratotanker** and the Boeing 707 — this time with tanker and receiver flying at the same speed.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1947-01-01',
    '1950-11-15',
    '1951-07-14',
    604.0,
    6920.0,
    (SELECT id FROM manufacturer WHERE code = 'BOE'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'), (SELECT id FROM wars WHERE name = 'Guerre froide')),
((SELECT id FROM airplanes WHERE name = 'KC-97 Stratofreighter'), (SELECT id FROM wars WHERE name = 'Guerre du Vietnam'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 35.8,
  wingspan          = 43.05,
  height            = 11.7,
  wing_area         = 164.3,
  empty_weight      = 37400,
  mtow              = 79400,
  service_ceiling   = 9500,
  climb_rate        = 5.1,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 3000,
  crew              = 5,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-4360-59B Wasp Major',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1956,
  units_built       = 811,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **KC-97E / F / G** : versions de ravitaillement successives\n- **KC-97L** : **deux réacteurs J47 ajoutés** en bout d''aile pour tenir la vitesse des jets\n- **C-97 Stratofreighter** : version de transport pur, sans perche\n- **Guppy / Super Guppy** : dérivés civils au fuselage démesuré, transport de fusées\n- Dérivé du bombardier **B-29** dont il reprend l''aile et les moteurs',
  variants_en       = E'- **KC-97E / F / G** : successive refuelling versions\n- **KC-97L** : **two J47 jets added** at the wingtips to hold jet speeds\n- **C-97 Stratofreighter** : pure transport version, without a boom\n- **Guppy / Super Guppy** : civil derivatives with outsize fuselages for rocket transport\n- Derived from the **B-29** bomber, whose wing and engines it reuses',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Boeing_C-97_Stratofreighter',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Boeing_KC-97_Stratofreighter',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'USAF',
  image_licence     = 'Public domain'
WHERE name = 'KC-97 Stratofreighter';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'KC-97 Stratofreighter';
