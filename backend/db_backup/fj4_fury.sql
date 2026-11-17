-- North American FJ-4 Fury
--
-- Photo : North American FJ-4 Fury in flight c1957.jpg
--   licence Public domain — U.S. Navy
--   https://commons.wikimedia.org/wiki/File:North_American_FJ-4_Fury_in_flight_c1957.jpg

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
    'FJ-4 Fury',
    'FJ-4 Fury',
    'North American FJ-4 Fury',
    'North American FJ-4 Fury',
    'Dernier des Fury embarqués, un Sabre redessiné de fond en comble et armé pour la frappe nucléaire',
    'The last of the carrier-borne Furies, a Sabre redesigned from the ground up and armed for nuclear strike',
    '/assets/airplanes/fj4-fury.jpg',
    E'## Genèse\nLe FJ-4 est le dernier maillon d''une lignée qui comprend le **F-86 Sabre** de l''US Air Force et les Fury embarqués FJ-2 et FJ-3. La marine veut cette fois un **intercepteur tous-temps**, ce qui exige une grande autonomie sur le seul carburant interne. Plutôt qu''un simple dérivé, **North American Aviation** livre une cellule profondément remaniée : elle garde l''allure générale et le réacteur Wright J65 du FJ-3, mais n''a presque plus rien de commun avec lui. Le premier FJ-4 vole le 28 octobre 1954 et les livraisons commencent en février 1955.\n\n## Conception\nTout est nouveau dans la voilure : une aile bien plus mince, d''une épaisseur relative de 6 %, plus grande et plus effilée, aux panneaux de revêtement usinés dans la masse et formant réservoirs intégraux. Le fuselage, approfondi pour loger davantage de carburant, prend une arête dorsale caractéristique. Avec 50 % de carburant de plus que le FJ-3, l''avion est allégé de son blindage et d''une partie de ses munitions ; le train principal, redessiné, se replie dans l''aile, dont seules les extrémités se replient. Le Wright J65-W-16A de série donne 34 kN, et l''armement réunit quatre canons Colt Mk 12 de 20 mm et des missiles **AIM-9 Sidewinder**.\n\n## Carrière opérationnelle\nSur les 221 avions de la première commande, les 71 derniers deviennent des **FJ-4B** d''attaque : aile renforcée à six points d''emport, aérofreins ventraux utiles aussi en piqué, charge externe doublée et surtout capacité nucléaire, avec le système de bombardement à basse altitude **LABS**. La marine, qui dispute la mission nucléaire à l''Air Force, en équipe dix flottilles, et trois escadrons de Marines le reçoivent aussi. Le FJ-4B peut guider le missile air-sol **AGM-12 Bullpup**. Deux FJ-4F dotés d''un moteur-fusée d''appoint AR-1 atteignent Mach 1,41 et 21 600 m d''altitude.\n\n## Place dans l''histoire\nConstruit à 374 exemplaires, 152 FJ-4 et 222 FJ-4B, le dernier Fury clôt une famille qui aura livré 1 115 avions à la marine et aux Marines. Rebaptisés F-1E et AF-1E en 1962, les AF-1E servent dans les unités de réserve de la marine jusqu''à la fin des années 1960. Né d''un chasseur terrestre, le FJ-4 montre jusqu''où pouvait aller la navalisation : sous un air de famille, un avion presque entièrement neuf, qui donna à la marine un chasseur-bombardier embarqué capable de porter l''arme nucléaire en pleine guerre froide.',
    E'## Genesis\nThe FJ-4 was the final link in a lineage that included the US Air Force''s **F-86 Sabre** and the carrier-borne FJ-2 and FJ-3 Furies. This time the Navy wanted an **all-weather interceptor**, a role that demanded considerable range on internal fuel alone. Rather than a simple derivative, **North American Aviation** delivered a thoroughly reworked airframe: it kept the general layout and the Wright J65 engine of the FJ-3 but had little else in common with it. The first FJ-4 flew on 28 October 1954 and deliveries began in February 1955.\n\n## Design\nThe wing was entirely new: much thinner, with a six percent thickness-to-chord ratio, larger and more sharply tapered, with skin panels milled from solid alloy plate and integral fuel tanks. The fuselage was deepened to hold more fuel and gained a distinctive razorback rear deck. With 50% more fuel than the FJ-3, the aircraft was lightened by deleting armour and reducing ammunition; the redesigned main undercarriage folded into the wing, and only the outer panels folded. The production Wright J65-W-16A gave 34 kN, and armament combined four 20 mm Colt Mk 12 cannon with **AIM-9 Sidewinder** missiles.\n\n## Operational career\nOf the original order for 221 aircraft, the last 71 became **FJ-4B** attack aircraft: a stronger wing with six stations, ventral airbrakes also useful in dive attacks, doubled external load and, above all, nuclear capability with the **LABS** low-altitude bombing system. The Navy, competing with the Air Force for the nuclear mission, equipped ten squadrons with it, and three Marine squadrons flew it too. The FJ-4B could guide the **AGM-12 Bullpup** air-to-surface missile. Two FJ-4Fs fitted with an auxiliary AR-1 rocket engine reached Mach 1.41 and an altitude of 21,600 m.\n\n## Place in history\nBuilt in 374 examples, 152 FJ-4s and 222 FJ-4Bs, the last Fury closed a family that delivered 1,115 aircraft to the Navy and Marine Corps. Redesignated F-1E and AF-1E in 1962, the AF-1Es served with Naval Reserve units until the late 1960s. Born from a land-based fighter, the FJ-4 showed how far navalisation could go: behind the family resemblance stood an almost entirely new aircraft, which gave the Navy a carrier-borne fighter-bomber able to carry a nuclear weapon at the height of the Cold War.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1954-10-28',
    '1955-02-01',
    1094,
    3250,
    (SELECT id FROM manufacturer WHERE code = 'NAA'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Chasseur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM tech WHERE name = 'Système navalisé')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM tech WHERE name = 'Perche de ravitaillement en vol'));

-- Armement
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM armement WHERE name = 'Colt Mk 12')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM armement WHERE name = 'AGM-12 Bullpup')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM armement WHERE name = 'Zuni 127 mm'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM missions WHERE name = 'Interception')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM missions WHERE name = 'Dissuasion nucléaire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'FJ-4 Fury'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.1,
  wingspan          = 11.9,
  height            = 4.2,
  wing_area         = 31.46,
  empty_weight      = 6000,
  mtow              = 10750,
  service_ceiling   = 14300,
  climb_rate        = 38.9,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Wright J65-W-16A',
  engine_count      = 1,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 34.0,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1955,
  production_end    = 1958,
  units_built       = 374,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **XFJ-4** : deux prototypes à fuselage redessiné et réacteur J65-W-4\n- **FJ-4** : chasseur-bombardier monoplace à réacteur J65-W-16A de 34 kN, rebaptisé F-1E en 1962\n- **FJ-4B** : version d''attaque à six points d''emport, aérofreins ventraux et capacité nucléaire (LABS), 222 exemplaires, rebaptisée AF-1E\n- **FJ-4F** : deux FJ-4 d''essais dotés d''un moteur-fusée d''appoint AR-1, Mach 1,41 et 21 600 m\n- **AF-1F** : projet d''avion d''attaque léger à réacteur TF30, concurrent de l''A-7, non construit',
  variants_en       = E'- **XFJ-4**: two prototypes with a redesigned fuselage and J65-W-4 engine\n- **FJ-4**: single-seat fighter-bomber with a 34 kN J65-W-16A, redesignated F-1E in 1962\n- **FJ-4B**: attack version with six stations, ventral airbrakes and nuclear capability (LABS), 222 built, redesignated AF-1E\n- **FJ-4F**: two FJ-4 test aircraft fitted with an auxiliary AR-1 rocket engine, Mach 1.41 and 21,600 m\n- **AF-1F**: proposed light attack aircraft with a TF30 engine, competitor to the A-7, not built',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/North_American_FJ-4_Fury',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/North_American_FJ-4_Fury',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'U.S. Navy',
  image_licence     = 'Public domain'
WHERE name = 'FJ-4 Fury';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'FJ-4 Fury';
