-- Vought F7U Cutlass
--
-- Photo : F7U-3 Cutlass fighters of VF-81 in flight in 1954.jpg
--   licence CC BY 2.0 — Clemens Vasters from Viersen, Germany
--   https://commons.wikimedia.org/wiki/File%3AChance-Vought_F7U-3_Cutlass_%286661582435%29.jpg

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
    'F7U Cutlass',
    'F7U Cutlass',
    'Vought F7U Cutlass',
    'Vought F7U Cutlass',
    'Chasseur embarqué sans empennage, qui tua un quart de ses pilotes d’essai',
    'Tailless carrier fighter that killed a quarter of its test pilots',
    '/assets/airplanes/f7u-cutlass.jpg',
    E'## Genèse\nEn 1945, les rapports sur les travaux aérodynamiques allemands arrivent aux États-Unis. Vought y trouve les études d''Arado sur les ailes en flèche sans empennage et bâtit sa proposition dessus. L''US Navy, qui veut un chasseur embarqué supersonique, accepte un pari radical : **supprimer l''empennage horizontal** et confier tangage et roulis à des gouvernes uniques en bord de fuite.\n\n## Conception\nDeux dérives plantées au milieu de l''aile, un train avant démesurément haut qui donne à l''appareil une assiette cabrée permanente, et deux réacteurs Westinghouse J46 qui ne délivreront jamais la poussée promise — d''où le surnom cruel de *Gutless Cutlass*, « le coutelas sans tripes ». La commande de vol est **hydraulique sans réversibilité**, une nouveauté : le pilote ne sent plus l''air. Quand l''hydraulique lâche, l''avion est perdu.\n\n## Carrière opérationnelle\nQuatre ans de service, et un bilan terrible : **soixante-dix-huit exemplaires perdus sur trois cent vingt**, quatre pilotes d''essai tués sur les seize du programme. L''assiette cabrée rend l''appontage effroyable, la visibilité est mauvaise, et le train avant s''effondre régulièrement à l''impact. Les équipages le surnomment aussi *l''Ensign Eliminator* — le tueur d''enseignes de vaisseau.\n\n## Place dans l''histoire\nTrois cent vingt exemplaires pour un échec retentissant, mais un échec instructif : le Cutlass a été le premier avion américain à emporter un missile air-air guidé, et la première expérience à grande échelle de la commande hydraulique irréversible. Vought en tirera les leçons et livrera, quatre ans plus tard, l''un des meilleurs chasseurs embarqués de l''histoire — le **F-8 Crusader**.',
    E'## Genesis\nIn 1945 reports on German aerodynamic work reached the United States. Vought found Arado''s studies on tailless swept wings among them and built its proposal on that. The US Navy, wanting a supersonic carrier fighter, accepted a radical gamble: **delete the horizontal tail** and hand pitch and roll to single trailing-edge surfaces.\n\n## Design\nTwo fins planted mid-wing, a nose leg so tall it gives the aircraft a permanent nose-up attitude, and two Westinghouse J46 engines that would never deliver the promised thrust — hence the cruel nickname *Gutless Cutlass*. The flight controls are **irreversible hydraulic**, a novelty: the pilot no longer feels the air. When the hydraulics failed, the aircraft was lost.\n\n## Operational career\nFour years of service, and a terrible record: **seventy-eight aircraft lost out of three hundred and twenty**, four test pilots killed out of the programme''s sixteen. The nose-high attitude made deck landings appalling, visibility was poor, and the nose gear regularly collapsed on impact. Crews also called it the *Ensign Eliminator*.\n\n## Place in history\nThree hundred and twenty built for a resounding failure — but an instructive one: the Cutlass was the first American aircraft to carry a guided air-to-air missile, and the first large-scale experience of irreversible hydraulic controls. Vought learned from it and delivered, four years later, one of the finest carrier fighters in history — the **F-8 Crusader**.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1945-06-01',
    '1948-09-29',
    '1954-04-01',
    1094.0,
    1000.0,
    (SELECT id FROM manufacturer WHERE code = 'VOU'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM tech WHERE name = 'Réacteur à postcombustion'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM armement WHERE name = 'FFAR Mighty Mouse')),
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM armement WHERE name = 'AIM-7 Sparrow'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM missions WHERE name = 'Supériorité aérienne')),
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'F7U Cutlass'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.55,
  wingspan          = 11.79,
  height            = 4.36,
  wing_area         = 46.08,
  empty_weight      = 8260,
  mtow              = 14350,
  service_ceiling   = 12200,
  climb_rate        = 66.0,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = 400,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Westinghouse J46-WE-8B',
  engine_count      = 2,
  engine_type       = 'Turboréacteur à postcombustion',
  engine_type_en    = 'Afterburning turbojet',
  thrust_dry        = 27.6,
  thrust_wet        = 41.4,

  -- Strate 3 : production & service
  production_start  = 1950,
  production_end    = 1955,
  units_built       = 320,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **F7U-1** : version initiale, jugée inapte au service, quatorze exemplaires\n- **F7U-3** : refonte quasi complète, version principale\n- **F7U-3M** : premier avion américain à emporter le missile guidé **Sparrow I**\n- **F7U-3P** : version de reconnaissance photographique\n- Vingt-cinq pour cent des exemplaires produits ont été perdus par accident',
  variants_en       = E'- **F7U-1** : initial version, judged unfit for service, fourteen built\n- **F7U-3** : near-complete redesign, the main version\n- **F7U-3M** : first American aircraft to carry the **Sparrow I** guided missile\n- **F7U-3P** : photographic reconnaissance version\n- Twenty-five per cent of all aircraft built were lost in accidents',

  -- Strate 4 : qualitatif
  nickname          = 'Gutless Cutlass',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Vought_F7U_Cutlass',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Vought_F7U_Cutlass',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'F7U Cutlass';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'F7U Cutlass';
