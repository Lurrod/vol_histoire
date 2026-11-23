-- Grumman AF Guardian
--
-- Photo : AF-2S 2W VS-24 Jan1951.jpg
--   licence Public domain — USN
--   https://commons.wikimedia.org/wiki/File:AF-2S_2W_VS-24_Jan1951.jpg

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
    'AF Guardian',
    'AF Guardian',
    'Grumman AF Guardian',
    'Grumman AF Guardian',
    'Premier avion anti-sous-marin embarqué de l''US Navy, volant en couple chasseur-tueur',
    'The US Navy''s first purpose-built carrier anti-submarine aircraft, flying as a hunter-killer pair',
    '/assets/airplanes/af-guardian.jpg',
    E'## Genèse\nLe Guardian part d''un projet de bombardier-torpilleur. Le XTB2F bimoteur de 1944, trop gros pour les porte-avions de la classe Essex, est annulé en 1945, tout comme une version dérivée du **F7F Tigercat**. **Grumman** propose alors son modèle G-70, désigné XTB3F-1 : un moteur en étoile **Pratt & Whitney Double Wasp** dans le nez, complété par un turboréacteur Westinghouse dans la queue, jamais utilisé en vol et finalement retiré. Le prototype vole le 19 décembre 1945 ; cinq jours plus tard, la marine réoriente le programme vers la **lutte anti-sous-marine**.\n\n## Conception\nTout l''équipement nécessaire ne tient pas dans une seule cellule : Grumman en dessine deux. Le « chasseur » AF-2W, sans armement, embarque deux membres d''équipage de plus et le radar de recherche **AN/APS-20** dans un imposant radôme ventral, avec des récepteurs de contre-mesures. Le « tueur » AF-2S garde la soute, reçoit un projecteur et un radar de courte portée, et emporte jusqu''à 1 800 kg de bombes, torpilles et grenades anti-sous-marines. En 1952, l''AF-3S ajoute un **détecteur d''anomalie magnétique** escamotable. Le Guardian reste le plus gros monomoteur à pistons jamais mis en service.\n\n## Carrière opérationnelle\nLe Guardian entre en service le 27 septembre 1950 avec trois avions livrés à l''escadrille VS-24, puis à la VS-25. Il opère en équipes « hunter-killer », l''AF-2W repérant la cible pour l''AF-2S qui l''attaque. Pendant la **guerre de Corée**, il assure des patrouilles maritimes. Les pilotes ne l''aiment guère : sous-motorisé, lourd aux commandes, il connaît un taux d''accidents très élevé. Le dernier des 389 exemplaires est livré en mars 1953.\n\n## Place dans l''histoire\nPeu après la fin de la guerre de Corée, il cède la place au **S-2 Tracker**, premier avion anti-sous-marin de l''US Navy à réunir les rôles de chasseur et de tueur dans une seule cellule. Le dernier Guardian quitte le service actif le 31 août 1955, et la réserve navale l''emploie jusqu''en 1957. Cinq exemplaires deviennent ensuite bombardiers d''eau chez Aero Union, en Californie, jusqu''en 1978. Premier avion anti-sous-marin embarqué conçu comme tel à entrer en service dans l''US Navy, il a fixé la doctrine du couple chasseur-tueur que le Tracker allait réunir dans un seul avion.',
    E'## Genesis\nThe Guardian began as a torpedo-bomber project. The twin-engined XTB2F of 1944, too large for Essex-class carriers, was cancelled in 1945, as was a derivative of the **F7F Tigercat**. **Grumman** then offered its Model G-70, designated XTB3F-1: a **Pratt & Whitney Double Wasp** radial in the nose, supplemented by a Westinghouse turbojet in the tail that was never used in flight and was eventually removed. The prototype flew on 19 December 1945; five days later the Navy switched the programme to **anti-submarine warfare**.\n\n## Design\nAll the required equipment would not fit into a single airframe, so Grumman designed two. The unarmed "hunter" AF-2W carried two extra crew members and an **AN/APS-20** search radar in a large ventral radome, along with countermeasures receivers. The "killer" AF-2S kept the bomb bay, gained a searchlight and a short-range radar, and carried up to 1,800 kg of bombs, torpedoes and depth charges. In 1952 the AF-3S added a retractable **magnetic anomaly detector**. The Guardian remains the largest single-engined piston aircraft ever to enter service.\n\n## Operational career\nThe Guardian entered fleet service on 27 September 1950 with three aircraft delivered to VS-24, followed by VS-25. It operated in "hunter-killer" teams, the AF-2W locating the target for the AF-2S to attack. During the **Korean War** it flew maritime patrols. Pilots disliked it: underpowered and heavy on the controls, it suffered a severely high accident rate. The last of 389 aircraft was delivered in March 1953.\n\n## Place in history\nShortly after the end of the Korean War it gave way to the **S-2 Tracker**, the US Navy''s first anti-submarine aircraft to combine the hunter and killer roles in a single airframe. The last Guardian left active service on 31 August 1955, and the Naval Air Reserve used it until 1957. Five later served as water bombers with Aero Union in California until 1978. The first purpose-built carrier anti-submarine aircraft to enter US Navy service, it established the hunter-killer doctrine that the Tracker would fold into a single aircraft.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1945-12-19',
    '1950-09-27',
    510,
    2415,
    (SELECT id FROM manufacturer WHERE code = 'GRU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'AF Guardian'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'AF Guardian'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'AF Guardian'), (SELECT id FROM tech WHERE name = 'Détecteur d''anomalie magnétique'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'AF Guardian'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'AF Guardian'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.21,
  wingspan          = 18.49,
  height            = 5.08,
  wing_area         = 52.03,
  empty_weight      = 6613,
  mtow              = 10270,
  service_ceiling   = 4600,
  climb_rate        = 9.4,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-48W Double Wasp (2 400 ch)',
  engine_count      = 1,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1953,
  units_built       = 389,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **XTB3F-1** : trois prototypes de bombardier-torpilleur biplace, à moteur en étoile et turboréacteur d''appoint\n- **XTB3F-1S et -2S** : deux prototypes modifiés pour la lutte anti-sous-marine, réacteur retiré\n- **AF-2W** : version « chasseur » sans armement, radar de recherche AN/APS-20 en radôme ventral, 153 exemplaires\n- **AF-2S** : version « tueur » à soute d''armement, projecteur et radar de courte portée, 193 exemplaires\n- **AF-3S** : dérivé de l''AF-2S doté d''un détecteur d''anomalie magnétique escamotable, 40 exemplaires',
  variants_en       = E'- **XTB3F-1**: three two-seat torpedo-bomber prototypes, with a radial engine and auxiliary turbojet\n- **XTB3F-1S and -2S**: two prototypes modified for anti-submarine warfare, turbojet removed\n- **AF-2W**: unarmed "hunter" version with AN/APS-20 search radar in a ventral radome, 153 built\n- **AF-2S**: "killer" version with weapons bay, searchlight and short-range radar, 193 built\n- **AF-3S**: AF-2S derivative with a retractable magnetic anomaly detector, 40 built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Grumman_AF_Guardian',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Grumman_AF_Guardian',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'AF Guardian';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'AF Guardian';
