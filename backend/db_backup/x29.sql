-- Grumman X-29
--
-- Photo : X-29 in Flight - GPN-2002-000193.jpg
--   licence Public domain — NASA / DFRC / Larry Sammons
--   https://commons.wikimedia.org/wiki/File%3AX-29_in_Flight_-_GPN-2002-000193.jpg

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
    'X-29',
    'X-29',
    'Grumman X-29',
    'Grumman X-29',
    'Aile en flèche inversée, instable de trente-cinq pour cent',
    'Forward-swept wing, thirty-five per cent unstable',
    '/assets/airplanes/x29.jpg',
    E'## Genèse\nL''aile en flèche inversée est une vieille idée : elle décroche par l''emplanture et non par le bout, ce qui laisse les ailerons efficaces jusqu''au bout du domaine. Les Allemands l''ont essayée en 1944 sur le **Junkers Ju 287**, et l''ont abandonnée. La raison est physique : la portance tord l''aile vers le haut, ce qui augmente la portance, qui la tord davantage — jusqu''à la rupture.\n\n## Conception\nCe que les années 1980 apportent, c''est le **composite carbone à fibres orientées** : on choisit l''axe des fibres de façon que l''aile, en se tordant, se **détorde** d''elle-même. Grumman greffe cette aile sur un fuselage de F-5A avec un train de F-16, ajoute des canards, et obtient une cellule instable à **trente-cinq pour cent** — impilotable pour un humain. Trois calculateurs numériques la rattrapent quarante fois par seconde.\n\n## Carrière opérationnelle\nAucune. Deux cent quarante-deux vols de 1984 à 1991, la campagne d''essais la plus fournie de tous les avions X. Le X-29 se révèle **exceptionnellement docile** aux grandes incidences : il vole sous contrôle à 67 degrés, là où un F-16 décroche à 25.\n\n## Place dans l''histoire\nDeux exemplaires, aucune suite directe. L''aile inversée reste un cul-de-sac : elle coûte cher, s''accommode mal de la furtivité et n''apporte pas assez. Seuls le **Su-47 Berkut** russe et le Hansa-Jet allemand l''ont reprise. Mais la démonstration qu''un avion violemment instable peut être rendu sûr par le calcul, elle, est passée dans tous les chasseurs modernes.',
    E'## Genesis\nThe forward-swept wing is an old idea: it stalls at the root rather than the tip, leaving the ailerons effective to the edge of the envelope. The Germans tried it in 1944 on the **Junkers Ju 287** and gave it up. The reason is physical: lift twists the wing upward, which increases lift, which twists it further — until it fails.\n\n## Design\nWhat the 1980s brought was **tailored carbon composite**: choose the fibre axis so that the wing, as it twists, **untwists** itself. Grumman grafted such a wing onto an F-5A fuselage with F-16 landing gear, added canards, and obtained an airframe **thirty-five per cent** unstable — unflyable by a human. Three digital computers catch it forty times a second.\n\n## Operational career\nNone. Two hundred and forty-two flights from 1984 to 1991, the most extensive test campaign of any X-plane. The X-29 proved **exceptionally docile** at high angles of attack: it flew under control at 67 degrees, where an F-16 stalls at 25.\n\n## Place in history\nTwo built, no direct successor. The forward-swept wing remains a dead end: expensive, awkward for stealth, and not worth enough. Only the Russian **Su-47 Berkut** and the German Hansa-Jet took it up. But the demonstration that a violently unstable aircraft can be made safe by computation has passed into every modern fighter.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1977-01-01',
    '1984-12-14',
    NULL,
    1770.0,
    560.0,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'X-29'), (SELECT id FROM tech WHERE name = 'Aile en flèche inversée')),
((SELECT id FROM airplanes WHERE name = 'X-29'), (SELECT id FROM tech WHERE name = 'Commande de vol électrique (fly-by-wire)')),
((SELECT id FROM airplanes WHERE name = 'X-29'), (SELECT id FROM tech WHERE name = 'Aile en flèche avec canards'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'X-29'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 14.7,
  wingspan          = 8.29,
  height            = 4.36,
  wing_area         = 17.54,
  empty_weight      = 6260,
  mtow              = 8070,
  service_ceiling   = 16800,
  climb_rate        = 50.0,
  g_limit_pos       = 6.0,
  g_limit_neg       = NULL,
  combat_radius     = 280,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric F404-GE-400',
  engine_count      = 1,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbofan',
  thrust_dry        = 48.9,
  thrust_wet        = 71.2,

  -- Strate 3 : production & service
  production_start  = 1981,
  production_end    = 1984,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **X-29 n°1 et n°2** : deux exemplaires, deux cent quarante-deux vols de 1984 à 1991\n- Cellule empruntée à deux **F-5A**, train d''atterrissage de **F-16**\n- L''aile inversée est en **composite carbone** orienté, seul moyen d''éviter sa rupture\n- **Trente-cinq pour cent d''instabilité** : trois calculateurs corrigent 40 fois par seconde\n- Vole en toute sécurité à **67° d''incidence**, bien au-delà de tout chasseur de série',
  variants_en       = E'- **X-29 No. 1 and No. 2** : two aircraft, two hundred and forty-two flights, 1984–1991\n- Fuselages taken from two **F-5As**, undercarriage from an **F-16**\n- The forward-swept wing is tailored **carbon composite**, the only way to stop it failing\n- **Thirty-five per cent unstable**: three computers correct it forty times a second\n- Flew safely at **67° angle of attack**, far beyond any production fighter',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_X-29',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_X-29',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NASA / DFRC / Larry Sammons',
  image_licence     = 'Public domain'
WHERE name = 'X-29';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'X-29';
