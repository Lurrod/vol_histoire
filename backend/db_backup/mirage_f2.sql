-- Dassault Mirage F2
--
-- Photo : Dassault Mirage F2.jpg
--   licence CC BY-SA 3.0 — Aerolegende
--   https://commons.wikimedia.org/wiki/File:Dassault_Mirage_F2.jpg

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
    'Mirage F2',
    'Mirage F2',
    'Dassault Mirage F2',
    'Dassault Mirage F2',
    'Le biplace d''attaque à aile en flèche qui fit quitter le delta à Dassault et ouvrit la voie au Mirage F1',
    'The swept-wing two-seat strike prototype that took Dassault away from the delta and paved the way for the Mirage F1',
    '/assets/airplanes/mirage-f2.jpg',
    E'## Genèse\nAu début des années 1960, l''**armée de l''Air** cherche un avion de pénétration à basse altitude par tous temps, capable aussi d''interceptions supersoniques, d''opérer depuis des pistes courtes et sommaires et d''approcher à 140 nœuds seulement. L''aile **delta** des Mirage III, qui impose des vitesses d''approche élevées, ne s''y prête pas. Le 21 novembre 1963, la **Générale Aéronautique Marcel Dassault** signe le marché d''étude d''un prototype, d''abord appelé Mirage III F puis **Mirage III F2**. En 1965, l''armée commande trois prototypes biplaces, rebaptisés **Mirage F2** ; un seul sera construit.\n\n## Conception\nL''équipe de **Jean-Jacques Samin** abandonne la formule delta au profit d''une aile haute en flèche de 55°, fortement hypersustentée, associée à un empennage horizontal placé bas sur le fuselage, une première chez Dassault. Cette combinaison doit concilier grande vitesse et courte distance d''atterrissage. Le biplace mesure 17,60 m de long pour une masse maximale de 18 t. Il doit aussi servir de banc d''essai au réacteur double flux **SNECMA TF306** ; le marché initial prévoyait un TF106, dérivé du **Pratt & Whitney TF30** américain.\n\n## Essais\nLe prototype vole pour la première fois le 12 juin 1966 aux mains de **Jean Coureau**, avec un TF30 américain, puis reçoit le **SNECMA TF306** pour son deuxième vol, le 29 décembre 1966. Six mois après son premier vol, il atteint Mach 2, et il démontre ses qualités de terrain en se posant en 480 m. En mai 1966, l''état-major veut en tirer un intercepteur : un monoplace, le **Mirage F3**, est étudié. Mais le **Mirage G** à géométrie variable ouvre d''autres perspectives, et le marché du F3 est annulé en avril 1967.\n\n## Place dans l''histoire\nL''armée de l''Air choisit finalement de développer le **Mirage F1**, version réduite et plus simple étudiée en parallèle et motorisée par un réacteur français : le F2 n''est pas produit. Le programme coûte à l''État 98 millions de francs pour le F2 et 73 millions pour le F3. Ses résultats servent pourtant au F1, intercepteur standard des années 1970, tandis que son fuselage et son moteur forment la base du **Mirage G**. Le prototype est conservé à Toulouse-Balma par **DGA Techniques aéronautiques**.',
    E'## Genesis\nIn the early 1960s the **French Air Force** wanted a low-altitude, all-weather penetration aircraft that could also make supersonic interceptions, operate from short, rudimentary strips and approach at just 140 knots. The **delta** wing of the Mirage III, with its high approach speeds, was ill-suited to the task. On 21 November 1963 the **Générale Aéronautique Marcel Dassault** signed a study contract for a prototype, first called the Mirage III F and then the **Mirage III F2**. In 1965 the air force ordered three two-seat prototypes, renamed **Mirage F2**; only one was built.\n\n## Design\n**Jean-Jacques Samin**''s team abandoned the delta formula in favour of a high-mounted, 55° swept wing with powerful high-lift devices, combined with a horizontal tail set low on the fuselage, a first for Dassault. This combination was meant to reconcile high speed with a short landing distance. The two-seater was 17.60 m long, with a maximum weight of 18 tonnes. It was also to serve as a test bed for the **SNECMA TF306** turbofan; the original contract had specified a TF106, derived from the American **Pratt & Whitney TF30**.\n\n## Testing\nThe prototype first flew on 12 June 1966 with **Jean Coureau** at the controls, powered by an American TF30, then received the **SNECMA TF306** for its second flight on 29 December 1966. Six months after its first flight it reached Mach 2, and it showed its short-field ability by landing in 480 m. In May 1966 the staff wanted an interceptor derived from it, and a single-seater, the **Mirage F3**, was studied. But the variable-geometry **Mirage G** opened up other prospects, and the F3 contract was cancelled in April 1967.\n\n## Place in history\nThe French Air Force eventually chose to develop the **Mirage F1**, a smaller and simpler design studied in parallel and powered by a French engine: the F2 never entered production. The programme cost the state 98 million francs for the F2 and 73 million for the F3. Its results nevertheless fed into the F1, the standard interceptor of the 1970s, while its fuselage and engine formed the basis of the **Mirage G**. The prototype is preserved at Toulouse-Balma by **DGA Techniques Aéronautiques**.',
    (SELECT id FROM countries WHERE code = 'FRA'),
    '1963-11-21',
    '1966-06-12',
    NULL,
    2333,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'DAS'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage F2'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mirage F2'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mirage F2'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 17.6,
  wingspan          = 10.5,
  height            = 5.8,
  wing_area         = NULL,
  empty_weight      = 9500,
  mtow              = 18000,
  service_ceiling   = 20000,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney TF30',
  engine_count      = 1,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 89,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = NULL,
  variants          = E'- **Mirage III F / III F2** : désignations du projet lors du marché d''étude signé le 21 novembre 1963\n- **Mirage F2** : biplace de pénétration, trois prototypes commandés en 1965, un seul construit ; premier vol le 12 juin 1966 avec un Pratt & Whitney TF30, puis SNECMA TF306\n- **Mirage F3** : intercepteur monoplace étudié à partir de mai 1966, annulé en avril 1967\n- **Mirage G** : prototype à géométrie variable bâti à partir du fuselage et du moteur du F2',
  variants_en       = E'- **Mirage III F / III F2**: project designations under the study contract signed on 21 November 1963\n- **Mirage F2**: two-seat penetration aircraft, three prototypes ordered in 1965, only one built; first flown on 12 June 1966 with a Pratt & Whitney TF30, then a SNECMA TF306\n- **Mirage F3**: single-seat interceptor studied from May 1966, cancelled in April 1967\n- **Mirage G**: variable-geometry prototype built around the F2''s fuselage and engine',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Dassault_Mirage_F2',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Dassault_Mirage_F2',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Aerolegende',
  image_licence     = 'CC BY-SA 3.0'
WHERE name = 'Mirage F2';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mirage F2';
