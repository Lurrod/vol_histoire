-- Saunders-Roe SR.A/1
--
-- Photo : Saunders-Roe SR A1.jpg
--   licence Public domain — British official photographer
--   https://commons.wikimedia.org/wiki/File:Saunders-Roe_SR_A1.jpg

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
    'Saunders-Roe SR.A/1',
    'Saunders-Roe SR.A/1',
    'Saunders-Roe SR.A/1',
    'Saunders-Roe SR.A/1',
    'Premier avion à réaction à coque de l''histoire, un hydravion de chasse resté prototype',
    'The world''s first jet-powered flying boat, a seaplane fighter that never left the prototype stage',
    '/assets/airplanes/saro-sra1.jpg',
    E'## Genèse\nL''idée naît pendant la Seconde Guerre mondiale, devant les succès des hydravions de chasse japonais comme le **Nakajima A6M2-N**, dérivé du Zero. **Saunders-Roe** voit dans le turboréacteur le moyen de lever leur handicap : sans hélice à dégager, le fuselage peut descendre dans l''eau et prendre la forme d''une coque, sans flotteurs encombrants. La firme présente son projet SR.44 au ministère de l''Air à la mi-1943 ; la spécification E.6/44 suit en avril 1944, puis un contrat pour trois prototypes. Pensé pour le Pacifique, l''avion devait pouvoir opérer depuis n''importe quel plan d''eau calme proche de ses objectifs.\n\n## Conception\nLe SR.A/1 est un hydravion à coque monoplace propulsé par deux turboréacteurs **Metropolitan-Vickers Beryl** de 17,1 kN, alimentés par une entrée d''air de nez prolongeable qui limite l''ingestion d''eau. Ses flotteurs d''aile se rétractent en vol. Le cockpit pressurisé, spacieux, souffre d''une verrière très charpentée qui gêne la vue du pilote. Deux prototypes reçoivent les deux premiers **sièges éjectables Martin-Baker** de série, et un système d''amarrage automatique permet au pilote de s''amarrer sans quitter son poste. L''armement prévu comprend quatre canons Hispano de 20 mm, des roquettes ou deux bombes de 454 kg.\n\n## Essais\nLa fin de la guerre et la priorité donnée à l''hydravion de ligne **Saunders-Roe Princess** retardent le programme : le premier prototype ne vole que le 16 juillet 1947, piloté par **Geoffrey Tyson**. L''avion se montre plutôt performant et maniable ; Tyson le présente en voltige rapide et en vol inversé au salon de Farnborough de 1948. Mais deux des trois prototypes sont perdus dans des accidents, et le Beryl n''est plus produit depuis que Metropolitan-Vickers a renoncé aux réacteurs. La RAF conclut que l''appareil ne peut égaler les chasseurs basés à terre.\n\n## Place dans l''histoire\nRemisé début 1950, le programme est brièvement relancé en novembre 1950 avec la guerre de Corée, et ses données sont transmises aux États-Unis, avant un abandon définitif : le dernier vol a lieu en juin 1951. Le porte-avions avait démontré une manière bien plus efficace de projeter la puissance aérienne au-dessus des océans. Surnommé « Squirt » par les ouvriers de l''usine, le SR.A/1 reste le premier avion à réaction à coque de l''histoire. Le prototype TG263 est exposé au musée Solent Sky de Southampton.',
    E'## Genesis\nThe idea was born during the Second World War, prompted by the successes of Japanese seaplane fighters such as the **Nakajima A6M2-N**, a Zero derivative. **Saunders-Roe** saw in the turbojet a way to overcome their handicap: with no propeller to clear, the fuselage could sit low in the water as a hull, without bulky floats. The company presented its SR.44 design to the Air Ministry in mid-1943; Specification E.6/44 followed in April 1944, then a contract for three prototypes. Intended for the Pacific, the aircraft was to operate from any calm stretch of water close to its targets.\n\n## Design\nThe SR.A/1 was a single-seat flying boat powered by two 17.1 kN **Metropolitan-Vickers Beryl** turbojets, fed by an extendable nose intake that limited water ingestion. Its wing floats retracted in flight. The pressurised cockpit was roomy but its heavily framed canopy gave the pilot a poor view. Two prototypes received the first two production **Martin-Baker ejection seats**, and an automatic mooring system allowed the pilot to moor without leaving his seat. Planned armament was four 20 mm Hispano cannon, plus rockets or two 454 kg bombs.\n\n## Testing\nThe end of the war and the priority given to the **Saunders-Roe Princess** airliner delayed the programme: the first prototype did not fly until 16 July 1947, piloted by **Geoffrey Tyson**. The aircraft showed good performance and handling; Tyson flew high-speed aerobatics and inverted flight at the 1948 Farnborough Airshow. But two of the three prototypes were lost in accidents, and the Beryl had gone out of production since Metropolitan-Vickers withdrew from jet engines. The RAF concluded that the design could not match land-based fighters.\n\n## Place in history\nPlaced in storage in early 1950, the programme was briefly revived in November 1950 with the Korean War, and its data passed to the United States, before final cancellation: the last flight took place in June 1951. The aircraft carrier had shown a far more effective way to project air power over the oceans. Nicknamed "Squirt" by the company''s workers, the SR.A/1 remains the world''s first jet-powered flying boat. The TG263 prototype is displayed at the Solent Sky museum in Southampton.',
    (SELECT id FROM countries WHERE code = 'GBR'),
    '1944-04-01',
    '1947-07-16',
    NULL,
    824,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'SRO'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Annulé',
    'Cancelled'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.A/1'), (SELECT id FROM tech WHERE name = 'Coque d''hydravion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.A/1'), (SELECT id FROM armement WHERE name = 'Hispano-Suiza HS.404')),
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.A/1'), (SELECT id FROM armement WHERE name = '1000 lb GP'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.A/1'), (SELECT id FROM missions WHERE name = 'Essais en vol')),
((SELECT id FROM airplanes WHERE name = 'Saunders-Roe SR.A/1'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 15.24,
  wingspan          = 14.02,
  height            = 5.11,
  wing_area         = 38.6,
  empty_weight      = 5108,
  mtow              = 8633,
  service_ceiling   = 14630,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Metropolitan-Vickers Beryl MVB.2',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 17.1,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **SR.44** : projet initial présenté au ministère de l''Air à la mi-1943\n- **SR.A/1 TG263** : premier prototype, premier vol le 16 juillet 1947, dernier vol en juin 1951, préservé à Southampton\n- **SR.A/1 TG267 et TG271** : deuxième et troisième prototypes, tous deux perdus en essais\n- **P.121** : étude d''hydravion de chasse sur hydroskis du début des années 1950, abandonnée en janvier 1955',
  variants_en       = E'- **SR.44**: original design submitted to the Air Ministry in mid-1943\n- **SR.A/1 TG263**: first prototype, first flight 16 July 1947, last flight June 1951, preserved in Southampton\n- **SR.A/1 TG267 and TG271**: second and third prototypes, both lost during testing\n- **P.121**: early-1950s hydro-ski naval fighter study, abandoned in January 1955',

  -- Strate 4 : qualitatif
  nickname          = 'Squirt',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Saunders-Roe_SR.A/1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Saunders-Roe_SR.A/1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = NULL,
  image_licence     = 'Public domain'
WHERE name = 'Saunders-Roe SR.A/1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Saunders-Roe SR.A/1';
