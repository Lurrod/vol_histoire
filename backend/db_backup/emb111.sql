-- Embraer EMB 111 Bandeirante Patrulha (P-95 Bandeirulha)
--
-- Photo : P-95B at SBCO - EXCON Escudo-Tínia 2023.jpg
--   licence CC BY-SA 4.0 — HLAssis
--   https://commons.wikimedia.org/wiki/File:P-95B_at_SBCO_-_EXCON_Escudo-T%C3%ADnia_2023.jpg

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
    'Embraer EMB 111 Bandeirulha',
    'Embraer EMB 111 Bandeirulha',
    'Embraer EMB 111 Bandeirante Patrulha (P-95 Bandeirulha)',
    'Embraer EMB 111 Bandeirante Patrulha (P-95 Bandeirulha)',
    'Le Bandeirante devenu patrouilleur maritime, du littoral brésilien à la marine argentine des Malouines',
    'The Bandeirante turned maritime patroller, from Brazil''s coast to the Argentine Navy in the Falklands',
    '/assets/airplanes/embraer-emb111.jpg',
    E'## Genèse\nEn 1965, le ministère brésilien de l''Aéronautique demande un avion de transport à turbopropulseurs, fiable et économique, utilisable par les civils comme par les militaires. L''ingénieur français **Max Holste** le dessine, le Brésilien **Ozires Silva** en supervise la construction, et le prototype YC-95 vole le 26 octobre 1968 à São José dos Campos. Pour le produire naît en 1969 une entreprise nouvelle, **Embraer**. La force aérienne brésilienne commande 80 appareils en mai 1970 et reçoit le premier le 9 février 1973. Conçu dès l''origine pour être adapté à des rôles spécialisés, ce **Bandeirante** — le « pionnier » — donne naissance à une version de patrouille maritime, l''**EMB 111**.\n\n## Conception\nL''**EMB 111A Patrulha** conserve la formule du Bandeirante : bimoteur à aile basse, deux turbopropulseurs Pratt & Whitney Canada PT6A, deux pilotes et une cellule simple, peu coûteuse à exploiter. La force aérienne brésilienne le désigne **P-95** et le surnomme « Bandeirulha », d''après son nom de Bandeirante Patrulha. Le **P-95B** qui lui succède reçoit une avionique plus avancée et une structure renforcée ; dix exemplaires sont construits pour la force aérienne. Au XXIe siècle, celle-ci modernise ses Bandeirante avec des systèmes installés par Aeroeletronica, filiale brésilienne de l''israélien Elbit Systems.\n\n## Carrière opérationnelle\nAu Brésil, le P-95 patrouille au-dessus de l''Atlantique, mais il s''exporte aussi : la marine chilienne achète six **EMB 111AN**. Pendant la **guerre des Malouines**, la marine argentine loue deux EMB 111A pour combler le vide entre le retrait de ses derniers Lockheed SP-2H Neptune et l''arrivée de Lockheed L-188 Electra modifiés. La carrière brésilienne a ses drames : le 26 octobre 1993, le P-95 FAB-2290, parti de Canoas, s''abîme en mer près d''Angra dos Reis par mauvais temps avec ses trois hommes ; le 17 novembre 1996, le FAB-7102, qui vole en formation de quatre Bandeirante entre Salvador et Natal, est percuté à la queue par l''hélice d''un autre appareil.\n\n## Place dans l''histoire\nL''EMB 111 montre comment un petit avion de transport régional peut devenir, à moindre coût, un patrouilleur maritime pour des forces aux moyens limités. Il prolonge la carrière militaire du Bandeirante, l''avion pour lequel Embraer a été fondée, construit à 494 exemplaires entre 1968 et 1990. Plus de cent Bandeirante de toutes versions ont servi dans la force aérienne brésilienne, et 48 y volaient encore en 2017.',
    E'## Genesis\nIn 1965 the Brazilian Ministry of Aeronautics called for a reliable, economical turboprop transport usable by both civil and military operators. The French engineer **Max Holste** designed it, the Brazilian **Ozires Silva** supervised its construction, and the YC-95 prototype flew on 26 October 1968 at São José dos Campos. A new company, **Embraer**, was founded in 1969 to produce it. The Brazilian Air Force ordered 80 aircraft in May 1970 and received the first on 9 February 1973. Designed from the outset to be adapted to specialist roles, this **Bandeirante** — the "pioneer" — gave rise to a maritime patrol version, the **EMB 111**.\n\n## Design\nThe **EMB 111A Patrulha** keeps the Bandeirante formula: a low-wing twin with two Pratt & Whitney Canada PT6A turboprops, two pilots and a simple airframe that is cheap to operate. The Brazilian Air Force designated it **P-95** and nicknamed it "Bandeirulha", after its name of Bandeirante Patrulha. The **P-95B** that followed received more advanced avionics and a strengthened structure; ten were built for the air force. In the twenty-first century the air force upgraded its Bandeirantes with systems installed by Aeroeletronica, the Brazilian subsidiary of Israel''s Elbit Systems.\n\n## Operational career\nIn Brazil the P-95 patrolled over the Atlantic, but it was also exported: the Chilean Navy bought six **EMB 111ANs**. During the **Falklands War**, the Argentine Navy leased two EMB 111As to fill the gap between the retirement of its last Lockheed SP-2H Neptunes and the arrival of modified Lockheed L-188 Electras. The Brazilian career had its tragedies: on 26 October 1993, P-95 FAB-2290, out of Canoas, crashed into the sea near Angra dos Reis in bad weather with its three crew; on 17 November 1996, FAB-7102, flying in a formation of four Bandeirantes between Salvador and Natal, had its tail struck by the propeller of another aircraft.\n\n## Place in history\nThe EMB 111 shows how a small regional transport can become, at low cost, a maritime patrol aircraft for forces with limited means. It extends the military career of the Bandeirante, the aircraft for which Embraer was founded, built in 494 examples between 1968 and 1990. More than a hundred Bandeirantes of all versions served with the Brazilian Air Force, and 48 were still flying there in 2017.',
    (SELECT id FROM countries WHERE code = 'BRA'),
    NULL,
    NULL,
    NULL,
    411,
    1964,
    (SELECT id FROM manufacturer WHERE code = 'EMB'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'En service',
    'In service'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB 111 Bandeirulha'), (SELECT id FROM tech WHERE name = 'Moteurs à turbopropulseurs'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB 111 Bandeirulha'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Embraer EMB 111 Bandeirulha'), (SELECT id FROM wars WHERE name = 'Guerre des Malouines'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = NULL,
  wingspan          = NULL,
  height            = 4.92,
  wing_area         = 29.1,
  empty_weight      = NULL,
  mtow              = NULL,
  service_ceiling   = 6550,
  climb_rate        = 8.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney Canada PT6A-34 (750 ch)',
  engine_count      = 2,
  engine_type       = 'Turbopropulseur',
  engine_type_en    = 'Turboprop',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **EMB 111A Patrulha (P-95)** : version de patrouille maritime de la force aérienne brésilienne, surnommée Bandeirulha\n- **P-95B** : avionique plus avancée et structure renforcée, dix exemplaires\n- **EMB 111AN** : six patrouilleurs vendus à la marine chilienne\n- **C/P-95** : Bandeirante modernisés par Aeroeletronica (Elbit Systems), premier vol le 15 décembre 2010',
  variants_en       = E'- **EMB 111A Patrulha (P-95)**: Brazilian Air Force maritime patrol version, nicknamed Bandeirulha\n- **P-95B**: more advanced avionics and strengthened structure, ten built\n- **EMB 111AN**: six patrol aircraft sold to the Chilean Navy\n- **C/P-95**: Bandeirantes upgraded by Aeroeletronica (Elbit Systems), first flight on 15 December 2010',

  -- Strate 4 : qualitatif
  nickname          = 'Bandeirulha',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Embraer_EMB_110',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Embraer_EMB_110_Bandeirante',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'HLAssis',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Embraer EMB 111 Bandeirulha';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Embraer EMB 111 Bandeirulha';
