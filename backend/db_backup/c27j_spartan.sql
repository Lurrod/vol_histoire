-- Alenia C-27J Spartan
--
-- Photo : EGVA - Alenia C-27J Spartan - Slovak Air Force - 1962.jpg
--   licence CC BY 2.0 — Steve Lynes
--   https://commons.wikimedia.org/wiki/File%3AEGVA_-_Alenia_C-27J_Spartan_-_Slovak_Air_Force_-_1962.jpg

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
    'Alenia C-27J Spartan',
    'Alenia C-27J Spartan',
    'Alenia C-27J Spartan',
    'Alenia C-27J Spartan',
    'Transport tactique italien greffé sur la motorisation du C-130J',
    'Italian tactical transport grafted onto the C-130J’s powerplant',
    '/assets/airplanes/c27j-spartan.jpg',
    E'## Genèse\nL''Italie exploite depuis les années 1970 le **G.222**, bon appareil dont la motorisation est dépassée. Plutôt que de repartir de zéro, Alenia conclut avec Lockheed un accord singulier : greffer sur la cellule du G.222 les **moteurs, hélices et cockpit du C-130J**, alors en cours de développement. Le résultat n''est ni tout à fait un avion neuf ni une simple modernisation.\n\n## Conception\nLa cellule reste celle du G.222 — aile haute, rampe arrière, dimensions modestes — mais tout le système propulsif vient du C-130J. Le gain est considérable : trente-cinq pour cent de puissance en plus, et surtout une **communauté logistique** avec l''Hercules, dont les pièces et les mécaniciens sont partout. Le C-27J emporte le tiers de la charge d''un C-130 mais se pose sur des terrains plus courts et plus étroits, ce qui le rend complémentaire plutôt que concurrent.\n\n## Carrière opérationnelle\nIl sert en **Afghanistan**, où sa capacité à rejoindre des bases avancées inaccessibles aux gros-porteurs le rend précieux, puis en Afrique et en Méditerranée. Quatorze pays l''exploitent. L''US Air Force en a commandé vingt et un avant de les céder aux garde-côtes et aux forces spéciales trois ans plus tard, décision restée controversée.\n\n## Place dans l''histoire\nQuatre-vingt-onze exemplaires. Sa véritable originalité est industrielle : il démontre qu''un constructeur moyen peut rester compétitif en adossant son appareil à la chaîne logistique d''un concurrent plus gros. Il occupe, sous le **C-130**, un créneau que l''A400M et le KC-390, tous deux plus lourds, ont laissé vacant.',
    E'## Genesis\nItaly had flown the **G.222** since the 1970s, a good aircraft with an outdated powerplant. Rather than start again, Alenia struck an unusual agreement with Lockheed: graft onto the G.222 airframe the **engines, propellers and cockpit of the C-130J**, then under development. The result is neither quite a new aircraft nor a simple upgrade.\n\n## Design\nThe airframe remains the G.222''s — high wing, rear ramp, modest dimensions — but the whole propulsion system comes from the C-130J. The gain is considerable: thirty-five per cent more power, and above all **logistic commonality** with the Hercules, whose parts and mechanics are everywhere. The C-27J carries a third of a C-130''s load but lands on shorter, narrower strips, which makes it complementary rather than competing.\n\n## Operational career\nIt served in **Afghanistan**, where its ability to reach forward bases closed to larger aircraft made it valuable, then in Africa and the Mediterranean. Fourteen countries operate it. The US Air Force ordered twenty-one before handing them to the Coast Guard and special forces three years later, a decision that remains contested.\n\n## Place in history\nNinety-one built. Its real originality is industrial: it shows that a mid-sized manufacturer can stay competitive by attaching its aircraft to a larger rival''s supply chain. It occupies, below the **C-130**, a niche that the A400M and the KC-390, both heavier, have left vacant.',
    (SELECT id FROM countries WHERE code = 'ITA'),
    '1995-01-01',
    '1999-09-24',
    '2007-01-01',
    602.0,
    4260.0,
    (SELECT id FROM manufacturer WHERE code = 'LEO'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Transport'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs')),
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement')),
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM missions WHERE name = 'Largage de troupes')),
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM missions WHERE name = 'Largage de secours'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Alenia C-27J Spartan'), (SELECT id FROM wars WHERE name = 'Guerre civile syrienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 22.7,
  wingspan          = 28.7,
  height            = 9.64,
  wing_area         = 82.0,
  empty_weight      = 17000,
  mtow              = 31800,
  service_ceiling   = 9145,
  climb_rate        = 10.2,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 1850,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce AE 2100-D2',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1999,
  production_end    = NULL,
  units_built       = 91,
  unit_cost_usd     = 42000000,
  unit_cost_year    = 2013,
  operators_count   = 14,
  variants          = E'- **C-27J** : version de transport tactique standard\n- **MC-27J Praetorian** : version armée d''un canon de 30 mm sur palette, à la manière de l''AC-130\n- **HC-27J** : version de patrouille côtière des garde-côtes américains\n- **G.222** : prédécesseur direct des années 1970, dont il reprend la cellule\n- Partage **moteurs et hélices** avec le C-130J, ce qui mutualise le soutien',
  variants_en       = E'- **C-27J** : the standard tactical transport version\n- **MC-27J Praetorian** : armed version with a palletised 30 mm gun, in AC-130 fashion\n- **HC-27J** : coastal patrol version for the US Coast Guard\n- **G.222** : direct 1970s predecessor, whose airframe it reuses\n- Shares **engines and propellers** with the C-130J, pooling support',

  -- Strate 4 : qualitatif
  nickname          = 'Spartan',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Alenia_C-27J_Spartan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Alenia_C-27J_Spartan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Steve Lynes',
  image_licence     = 'CC BY 2.0'
WHERE name = 'Alenia C-27J Spartan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Alenia C-27J Spartan';
