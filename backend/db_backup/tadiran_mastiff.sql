-- Tadiran Mastiff
--
-- Photo : USMC Mastiff III UAV, Tadiran, 1975 - Evergreen Aviation & Space Museum - McMinnville, Oregon - DSC01103.jpg
--   licence CC0 — Daderot
--   https://commons.wikimedia.org/wiki/File:USMC_Mastiff_III_UAV,_Tadiran,_1975_-_Evergreen_Aviation_%26_Space_Museum_-_McMinnville,_Oregon_-_DSC01103.jpg

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
    'Tadiran Mastiff',
    'Tadiran Mastiff',
    'Tadiran Mastiff',
    'Tadiran Mastiff',
    'Considéré comme le premier drone de surveillance moderne : sept heures en l''air et la vidéo en direct',
    'Seen as the first modern surveillance drone: seven hours aloft and live video',
    '/assets/airplanes/tadiran-mastiff.jpg',
    E'## Genèse\nLe Mastiff naît d''une rencontre : un groupe d''entrepreneurs qui travaillent sur un petit avion piloté à distance cherche chez **Tadiran Electronic Industries** sa radiocommande, et l''entreprise israélienne finit par développer elle-même le **Mastiff Mini Remote Piloted Vehicle**. Il vole pour la première fois en 1973. Après la **guerre du Kippour**, les forces de défense israéliennes formulent un besoin opérationnel qui lui donne sa raison d''être : permettre aux commandants sur le terrain de voir « de l''autre côté de la colline », avec un engin capable d''emporter 10 kg de charge utile à 30 ou 50 km.\n\n## Conception\nLe Mastiff est un petit monoplan bipoutre à aile haute et train tricycle fixe, qui décolle et se pose sur piste. Un moteur allemand **Limbach** à deux cylindres et deux temps entraîne une hélice propulsive bipale fabriquée en Californie. Sa vraie nouveauté est à l''intérieur : une **liaison de données** et une électronique miniaturisée qui transmettent en direct aux opérateurs une vidéo haute résolution de la zone visée. Avec plus de sept heures d''autonomie, il offre aux forces israéliennes une profondeur d''observation, une rapidité de transmission et une permanence sur zone sans précédent.\n\n## Carrière opérationnelle\nTrois générations de Mastiff servent dans l''armée israélienne et accomplissent de nombreuses missions. La plus célèbre a lieu pendant la **guerre du Liban de 1982**, quand la caméra d''un Mastiff filme **Yasser Arafat**. Avec le **Scout** d''IAI, il fournit aussi une partie du renseignement qui permet de détruire les 28 sites de missiles sol-air syriens de la Bekaa. Le programme est vendu à l''US Navy, qui le déploie à bord de porte-avions et dans l''escadrille de drones de Camp Talega, en Californie ; l''escadron VMUT-2 des Marines l''emploie de 1984 à 1986. Singapour l''adopte également. Au début des années 1990, l''**IAI Searcher** le remplace, comme le Scout.\n\n## Place dans l''histoire\nCertains historiens militaires voient dans le Mastiff le premier drone de surveillance militaire moderne : le premier à associer longue endurance et vidéo en temps réel, la formule que reprendront ses successeurs. Il est aussi à l''origine de l''association entre Tadiran et l''américain **AAI**, qui le commercialise aux États-Unis ; ce partenariat conduit au **Pioneer**, né du regroupement des équipes du Mastiff et du Scout. Le Mastiff a ainsi ouvert à l''industrie aéronautique israélienne la spécialité qui fera sa réputation.',
    E'## Genesis\nThe Mastiff was born of a meeting: a group of entrepreneurs working on a small remotely piloted aircraft approached **Tadiran Electronic Industries** for its radio command, and the Israeli company ended up developing the **Mastiff Mini Remote Piloted Vehicle** itself. It first flew in 1973. After the **Yom Kippur War**, the Israel Defense Forces set out an operational requirement that gave it its purpose: to let field commanders look ''over the hill'', with a vehicle able to carry a 10 kg payload to ranges of 30 to 50 km.\n\n## Design\nThe Mastiff is a small high-wing twin-boom monoplane with fixed tricycle landing gear, taking off from and landing on runways. A German **Limbach** two-cylinder two-stroke engine drives a two-bladed pusher propeller made in California. Its real novelty lay inside: a **data link** and miniaturised electronics that fed live, high-resolution video of the target area to its operators. With an endurance of over seven hours, it gave Israeli forces unprecedented depth of coverage, speed of information delivery and time on station.\n\n## Operational career\nThree generations of Mastiff served with the Israeli Army and flew numerous operational missions. The best known came during the **1982 Lebanon War**, when a Mastiff''s video camera caught sight of **Yasser Arafat**. Together with IAI''s **Scout**, it also supplied part of the intelligence that allowed the 28 Syrian surface-to-air missile sites in the Bekaa to be destroyed. The programme was sold to the US Navy, which deployed it aboard aircraft carriers and with the RPV squadron at Camp Talega, California; the Marine Corps'' VMUT-2 used it from 1984 to 1986. Singapore adopted it as well. In the early 1990s the **IAI Searcher** replaced it, as it did the Scout.\n\n## Place in history\nSome military historians regard the Mastiff as the world''s first modern military surveillance drone: the first to combine long endurance with real-time video, the formula its successors would adopt. It also started the partnership between Tadiran and the American firm **AAI**, which marketed it in the United States; that partnership led to the **Pioneer**, born from the merged Mastiff and Scout teams. The Mastiff thus opened for the Israeli aircraft industry the speciality that would make its name.',
    (SELECT id FROM countries WHERE code = 'ISR'),
    NULL,
    '1973-01-01',
    NULL,
    185,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'TAD'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Tadiran Mastiff'), (SELECT id FROM tech WHERE name = 'Liaison de données tactique')),
((SELECT id FROM airplanes WHERE name = 'Tadiran Mastiff'), (SELECT id FROM tech WHERE name = 'Système de caméra intégré'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Tadiran Mastiff'), (SELECT id FROM missions WHERE name = 'Reconnaissance tactique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Tadiran Mastiff'), (SELECT id FROM wars WHERE name = 'Guerre du Liban'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 3.3,
  wingspan          = 4.25,
  height            = 0.89,
  wing_area         = NULL,
  empty_weight      = 72,
  mtow              = 138,
  service_ceiling   = 4480,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = NULL,

  -- Strate 2 : motorisation
  engine_name       = 'Limbach bicylindre deux temps',
  engine_count      = 1,
  engine_type       = 'Moteur à pistons',
  engine_type_en    = 'Piston engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = NULL,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **Mastiff Mk 1** : première génération, drone de reconnaissance à caméra\n- **Mastiff Mk 2** : deuxième génération, version de guerre électronique destinée au brouillage des communications\n- **Mastiff III** : dernière génération, employée par l''US Navy et l''escadron VMUT-2 des Marines (1984-1986)\n- **Pioneer** : dérivé conçu par Mazlat (IAI) et AAI en regroupant les équipes du Mastiff et du Scout',
  variants_en       = E'- **Mastiff Mk 1**: first generation, camera-equipped reconnaissance drone\n- **Mastiff Mk 2**: second generation, an electronic warfare version for jamming communications\n- **Mastiff III**: final generation, used by the US Navy and the Marine Corps'' VMUT-2 (1984-86)\n- **Pioneer**: derivative developed by Mazlat (IAI) and AAI by merging the Mastiff and Scout teams',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Tadiran_Mastiff',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Tadiran_Mastiff',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Daderot',
  image_licence     = 'CC0'
WHERE name = 'Tadiran Mastiff';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Tadiran Mastiff';
