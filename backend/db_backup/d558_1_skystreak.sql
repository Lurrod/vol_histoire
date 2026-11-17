-- Douglas D-558-1 Skystreak
--
-- Photo : D-558-1 in Flight - GPN-2000-000392.jpg
--   licence Public domain — NACA
--   https://commons.wikimedia.org/wiki/File:D-558-1_in_Flight_-_GPN-2000-000392.jpg

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
    'D-558-1 Skystreak',
    'D-558-1 Skystreak',
    'Douglas D-558-1 Skystreak',
    'Douglas D-558-1 Skystreak',
    'Avion de recherche à réaction et aile droite, recordman du monde de vitesse en 1947, éprouvette du vol transsonique',
    'A straight-winged jet research aircraft, world speed record holder in 1947 and a test tube for transonic flight',
    '/assets/airplanes/d558-1-skystreak.jpg',
    E'## Genèse\nEn 1945, le Bureau of Aeronautics de l''**US Navy** et le **NACA** lancent un programme commun de recherche sur le vol transsonique et supersonique, confié à **Douglas**. Trois phases sont prévues : un avion à réaction, une version à propulsion mixte fusée et réacteur, puis l''étude d''un avion de combat. Le contrat de la première phase, signé le 22 juin 1945, porte sur six D-558-1 aux entrées d''air et aux profils variés ; il est vite réduit à trois appareils identiques à entrée d''air dans le nez. La deuxième phase est remplacée par un avion entièrement nouveau, le **D-558-2 Skyrocket**.\n\n## Conception\nLe Skystreak est un avion à réaction qui décolle seul d''une piste, avec une aile et des empennages droits. Son fuselage fait largement appel à un alliage de magnésium léger et résistant, et la cellule est calculée pour des charges inhabituelles, jusqu''à 18 g, tant le vol transsonique reste mal connu. Tout l''avant, cockpit compris, peut être largué en cas d''urgence. L''appareil emporte plus de 230 kg d''instruments, avec des capteurs en 400 points, et une aile percée de 400 petits trous pour mesurer les pressions. Il est propulsé par un **Allison J35**, l''un des premiers turboréacteurs axiaux américains.\n\n## Carrière opérationnelle\nPeints en rouge vif, d''où leur surnom d''« éprouvette écarlate », puis en blanc pour faciliter le suivi optique, les Skystreak volent pour la première fois le 14 avril 1947 à Muroc. Le 20 août 1947, le commander **Turner Caldwell** établit un record du monde officiel de vitesse à 1 031 km/h ; cinq jours plus tard, **Marion Carl** le bat de 16 km/h sur le deuxième exemplaire. Celui-ci s''écrase au décollage le 3 mai 1948 après la désintégration de son compresseur, tuant le pilote du NACA **Howard Lilly**. Le troisième prend le relais et accomplit 78 vols de recherche avec sept pilotes du NACA, jusqu''à son retrait le 10 juin 1953.\n\n## Place dans l''histoire\nLe Skystreak atteint Mach 0,99 en palier et ne passe le mur du son qu''en piqué ; dans l''opinion, ses travaux sont vite éclipsés par **Chuck Yeager** et le **Bell X-1**. Il joue pourtant un rôle essentiel : en volant longuement aux vitesses transsoniques, il recueille une masse de données sur le comportement près de Mach 1 et libère le X-1, dont l''autonomie est brève, pour les vitesses supersoniques. Deux exemplaires sont conservés, à Pensacola et à Charlotte.',
    E'## Genesis\nIn 1945 the **US Navy** Bureau of Aeronautics and the **NACA** launched a joint research programme on transonic and supersonic flight, entrusted to **Douglas**. Three phases were planned: a jet aircraft, a mixed rocket and jet version, then the design of a combat aircraft. The first-phase contract, signed on 22 June 1945, covered six D-558-1s with various intakes and wing sections; it was soon cut to three identical aircraft with a nose intake. The second phase was replaced by an entirely new aircraft, the **D-558-2 Skyrocket**.\n\n## Design\nThe Skystreak was a jet aircraft that took off from a runway under its own power, with unswept wings and tail. Its fuselage made wide use of a light, strong magnesium alloy, and the airframe was designed for unusually high loads of up to 18 g, so uncertain was transonic flight. The whole forward fuselage, cockpit included, could be jettisoned in an emergency. The aircraft carried more than 230 kg of instrumentation, with sensors at 400 points, and one wing pierced with 400 small holes to measure pressures. It was powered by an **Allison J35**, one of the first American axial-flow turbojets.\n\n## Operational career\nPainted scarlet, hence the nickname crimson test tube, then white to help optical tracking, the Skystreaks first flew on 14 April 1947 at Muroc. On 20 August 1947 Commander **Turner Caldwell** set an official world air speed record of 1,031 km/h; five days later **Marion Carl** beat it by 16 km/h in the second aircraft. That aircraft crashed on take-off on 3 May 1948 when its compressor disintegrated, killing NACA pilot **Howard Lilly**. The third took over and made 78 research flights with seven NACA pilots, until it was retired on 10 June 1953.\n\n## Place in history\nThe Skystreak reached Mach 0.99 in level flight and only went supersonic in a dive; in the public mind its work was quickly overshadowed by **Chuck Yeager** and the **Bell X-1**. Yet it played a vital role: by flying for long periods at transonic speeds, it gathered a wealth of data on behaviour near Mach 1 and freed the X-1, with its short endurance, for supersonic speeds. Two aircraft survive, at Pensacola and Charlotte.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-06-22',
    '1947-04-14',
    NULL,
    1048,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'DOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'D-558-1 Skystreak'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 10.88,
  wingspan          = 7.62,
  height            = 3.95,
  wing_area         = 14.0,
  empty_weight      = NULL,
  mtow              = 4584,
  service_ceiling   = NULL,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Allison J35-A-11',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 22.2,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 3,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **D-558-1 n° 1** (BuNo 37970) : record du monde de vitesse le 20 août 1947, conservé au musée de l''aéronavale de Pensacola\n- **D-558-1 n° 2** (BuNo 37971) : record de Marion Carl le 25 août 1947, détruit le 3 mai 1948\n- **D-558-1 n° 3** (BuNo 37972) : avion de recherche du NACA jusqu''en 1953, conservé à Charlotte\n- **N° 4 à 6** : exemplaires supplémentaires commandés à l''origine, puis annulés',
  variants_en       = E'- **D-558-1 No. 1** (BuNo 37970): world speed record on 20 August 1947, preserved at the National Naval Aviation Museum, Pensacola\n- **D-558-1 No. 2** (BuNo 37971): Marion Carl''s record on 25 August 1947, destroyed on 3 May 1948\n- **D-558-1 No. 3** (BuNo 37972): NACA research aircraft until 1953, preserved at Charlotte\n- **Nos 4 to 6**: additional aircraft originally ordered, then cancelled',

  -- Strate 4 : qualitatif
  nickname          = 'Crimson Test Tube',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Douglas_Skystreak',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Douglas_D-558-1_Skystreak',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'NACA',
  image_licence     = 'Public domain'
WHERE name = 'D-558-1 Skystreak';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'D-558-1 Skystreak';
