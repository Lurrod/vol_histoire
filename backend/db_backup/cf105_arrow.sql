-- Avro Canada CF-105 Arrow
--
-- Photo : Avro Arrow 04.jpg
--   licence Public domain — Unknown photographer, copyright originally held by the Government of Canada
--   https://commons.wikimedia.org/wiki/File%3AAvro_Arrow_04.jpg

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
    'Avro Canada CF-105 Arrow',
    'Avro Canada CF-105 Arrow',
    'Avro Canada CF-105 Arrow',
    'Avro Canada CF-105 Arrow',
    'Intercepteur en avance d’une décennie, annulé et détruit avant d’avoir servi',
    'An interceptor a decade ahead of its time, cancelled and destroyed before it served',
    '/assets/airplanes/cf105-arrow.jpg',
    E'## Genèse\nDès 1953, le Canada anticipe : les bombardiers soviétiques voleront bientôt plus haut et plus vite que le **CF-100** ne peut monter. Il faut un intercepteur capable de croiser à Mach 2 à dix-huit mille mètres et d''abattre sa cible du premier coup, très loin de ses bases. Avro Canada conçoit l''Arrow autour de cette seule exigence, sans compromis et sans marché à l''exportation en vue.\n\n## Conception\nImmense aile delta montée en position haute, deux réacteurs côte à côte dans le fuselage, soute à armement interne, commandes de vol **électriques** — une première mondiale sur un appareil de série. La cellule est dessinée pour la loi des aires, et la structure emploie des alliages de titane encore expérimentaux. Dès son cinquième vol, l''Arrow dépasse Mach 1,5 ; les ingénieurs estiment qu''avec les Iroquois canadiens il aurait atteint Mach 2,5.\n\n## Carrière opérationnelle\nIl n''en a pas. Le 20 février 1959, le gouvernement Diefenbaker annule le programme du jour au lendemain : coût vertigineux, aucun client étranger, et une conviction — erronée — que le missile sol-air rendait l''intercepteur obsolète. Les cinq appareils et tous les outillages sont détruits dans les semaines qui suivent. **Quatorze mille personnes** perdent leur emploi le même jour.\n\n## Place dans l''histoire\nAucun avion n''a laissé au Canada une plaie comparable. Une trentaine d''ingénieurs d''Avro partent aussitôt à la **NASA**, où ils occuperont des postes clés du programme Apollo. Le pays achètera finalement des F-101 Voodoo américains d''occasion. Soixante-cinq ans plus tard, l''Arrow reste dans l''imaginaire canadien le symbole d''une ambition industrielle sacrifiée.',
    E'## Genesis\nAs early as 1953 Canada looked ahead: Soviet bombers would soon fly higher and faster than the **CF-100** could climb. What was needed was an interceptor able to cruise at Mach 2 at eighteen thousand metres and destroy its target on the first pass, far from its bases. Avro Canada designed the Arrow around that single requirement, without compromise and with no export market in view.\n\n## Design\nA vast delta wing mounted high, two engines side by side in the fuselage, an internal weapons bay, and **fly-by-wire** flight controls — a world first on a production aircraft. The airframe was drawn to the area rule, and the structure used titanium alloys still experimental at the time. On its fifth flight the Arrow passed Mach 1.5; engineers reckoned that with the Canadian Iroquois engines it would have reached Mach 2.5.\n\n## Operational career\nIt had none. On 20 February 1959 the Diefenbaker government cancelled the programme overnight: staggering cost, no foreign customer, and a conviction — mistaken — that surface-to-air missiles had made the interceptor obsolete. The five aircraft and all the tooling were destroyed within weeks. **Fourteen thousand people** lost their jobs on the same day.\n\n## Place in history\nNo aircraft has left Canada a comparable wound. Some thirty Avro engineers left at once for **NASA**, where they would hold key positions on the Apollo programme. The country eventually bought second-hand American F-101 Voodoos. Sixty-five years on, the Arrow remains in the Canadian imagination the symbol of an industrial ambition sacrificed.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1953-04-01',
    '1958-03-25',
    NULL,
    2104.0,
    2400.0,
    (SELECT id FROM manufacturer WHERE code = 'AVC'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Intercepteur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'), (SELECT id FROM tech WHERE name = 'Aile delta')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'), (SELECT id FROM tech WHERE name = 'Radar multi-mode'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'Avro Canada CF-105 Arrow'), (SELECT id FROM missions WHERE name = 'Patrouille aérienne de combat'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.71,
  wingspan          = 15.24,
  height            = 6.48,
  wing_area         = 113.8,
  empty_weight      = 22244,
  mtow              = 31103,
  service_ceiling   = 17700,
  climb_rate        = 203.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 660,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney J75-P-3',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 105.0,
  thrust_wet        = 155.7,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1959,
  units_built       = 5,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 0,
  variants          = E'- **Arrow Mk 1** : cinq exemplaires de vol à réacteurs américains J75\n- **Arrow Mk 2** : version de série à réacteurs canadiens **Orenda Iroquois**, jamais volée\n- **Astra / Sparrow II** : système d''armes intégré, abandonné avant l''appareil lui-même\n- Programme annulé le **20 février 1959**, jour resté connu au Canada sous le nom de *Black Friday*\n- Les cinq cellules et les gabarits furent **découpés au chalumeau** ; aucun exemplaire n''a survécu',
  variants_en       = E'- **Arrow Mk 1** : five flying aircraft with American J75 engines\n- **Arrow Mk 2** : production version with Canadian **Orenda Iroquois** engines, never flown\n- **Astra / Sparrow II** : integrated weapons system, abandoned before the aircraft itself\n- Programme cancelled on **20 February 1959**, a day still known in Canada as *Black Friday*\n- The five airframes and the jigs were **cut up with torches**; not one survives',

  -- Strate 4 : qualitatif
  nickname          = 'Arrow',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Avro_Canada_CF-105_Arrow',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Avro_Canada_CF-105_Arrow',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Unknown photographer, copyright originally held by the Government of Canada',
  image_licence     = 'Public domain'
WHERE name = 'Avro Canada CF-105 Arrow';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Avro Canada CF-105 Arrow';
