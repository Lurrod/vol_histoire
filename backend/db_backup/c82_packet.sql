-- Fairchild C-82 Packet
--
-- Photo : FAIRCHILD C-82A PACKET.jpg
--   licence CC BY-SA 4.0 — Thornfield Hall
--   https://commons.wikimedia.org/wiki/File:FAIRCHILD_C-82A_PACKET.jpg

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
    'Fairchild C-82 Packet',
    'Fairchild C-82 Packet',
    'Fairchild C-82 Packet',
    'Fairchild C-82 Packet',
    'Cargo bipoutre à portes arrière, trop peu motorisé mais père du Flying Boxcar',
    'Twin-boom freighter with rear doors, underpowered but father of the Flying Boxcar',
    '/assets/airplanes/c82-packet.jpg',
    E'## Genèse\n**Fairchild** conçoit le C-82 pendant la Seconde Guerre mondiale comme un cargo lourd appelé à succéder aux avions de ligne d''avant-guerre militarisés, le **C-46 Commando** et le **C-47**. Pour ne pas concurrencer la production des avions de combat, il devait d''abord être construit en contreplaqué et en acier, matériaux non stratégiques ; au début de 1943, l''évolution du cahier des charges le fait passer au tout-métal. L''appareil doit tout savoir faire : fret, transport de troupes, parachutage, évacuation sanitaire et remorquage de planeurs. Le prototype unique vole le 10 septembre 1944.\n\n## Conception\nL''originalité tient à l''architecture bipoutre. Le fuselage est une nacelle centrale qui s''ouvre à l''arrière par une rampe et de larges portes, tandis que l''empennage, porté par deux poutres, culmine à 4,3 m du sol : camions et remorques peuvent reculer jusqu''à la soute sans rien heurter. Deux moteurs en étoile **Pratt & Whitney R-2800** de 2 100 ch entraînent l''ensemble, qui emporte 42 soldats, 34 civières ou plus de 8 tonnes de fret. Le poste de pilotage offre en revanche une mauvaise visibilité.\n\n## Carrière opérationnelle\nLes livraisons, assurées par l''usine de Hagerstown, commencent en juin 1945, trop tard pour la guerre. Les équipages découvrent vite un avion sous-motorisé : en charge, il ne tient pas l''altitude sur un seul moteur, ce qui cause plusieurs accidents. Il sert néanmoins au fret, aux troupes et parfois aux parachutages, part en 1948 dans l''Arctique avec le 62d Troop Carrier Group, et reçoit à titre d''essai un train à chenilles. Pendant le **pont aérien de Berlin**, à l''automne 1948, cinq C-82 apportent en pièces les engins de terrassement qui permettent de construire l''aéroport de Tegel. L''US Air Force le retire en 1954.\n\n## Place dans l''histoire\nSeuls 223 exemplaires sont construits, peu pour un cargo de cette époque, mais la formule est la bonne. Remotorisé en R-4360 sous la désignation XC-82B, il devient le **C-119 Flying Boxcar**, et il ouvre aussi la voie au **C-123 Provider**. Les surplus volent pour des transporteurs civils jusqu''à la fin des années 1980. Le grand public le connaît surtout par *Le Vol du Phénix* (1965), où un C-82 écrasé dans le désert est reconstruit par ses passagers.',
    E'## Genesis\n**Fairchild** designed the C-82 during the Second World War as a heavy-lift freighter to succeed the militarised pre-war airliners, the **C-46 Commando** and the **C-47**. So as not to compete with combat aircraft production, it was first to be built of plywood and steel, non-critical materials; in early 1943 changes to the specification turned it into an all-metal aircraft. It had to do everything: cargo, troop transport, paradropping, medical evacuation and glider towing. The single prototype flew on 10 September 1944.\n\n## Design\nIts originality lay in the twin-boom layout. The fuselage was a central pod opening at the rear onto a ramp and wide doors, while the tail, carried on two booms, stood 4.3 m off the ground: trucks and trailers could back right up to the hold without obstruction. Two **Pratt & Whitney R-2800** radials of 2,100 hp powered an aircraft carrying 42 troops, 34 stretchers or over 8 tonnes of freight. The cockpit gave poor visibility, however.\n\n## Operational career\nDeliveries from the Hagerstown factory began in June 1945, too late for the war. Crews quickly found the aircraft underpowered: when loaded, it could not hold level flight on one engine, which caused several crashes. It nevertheless flew freight, troops and occasionally paratroops, went to the Arctic in 1948 with the 62d Troop Carrier Group, and was tested with tracked landing gear. During the **Berlin Airlift**, in autumn 1948, five C-82s flew in the dismantled earthmoving equipment that made it possible to build Tegel airport. The US Air Force retired it in 1954.\n\n## Place in history\nOnly 223 were built, few for a freighter of the period, but the formula was right. Re-engined with R-4360s as the XC-82B, it became the **C-119 Flying Boxcar**, and it also paved the way for the **C-123 Provider**. Surplus aircraft flew for civil carriers until the late 1980s. The wider public knows it mostly from *The Flight of the Phoenix* (1965), in which a C-82 crashed in the desert is rebuilt by its passengers.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1944-09-10',
    '1945-06-01',
    399,
    6236,
    (SELECT id FROM manufacturer WHERE code = 'FRC'),
    (SELECT id FROM generation WHERE generation = 1),
    (SELECT id FROM type WHERE name = 'Transport'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild C-82 Packet'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild C-82 Packet'), (SELECT id FROM missions WHERE name = 'Transport logistique')),
((SELECT id FROM airplanes WHERE name = 'Fairchild C-82 Packet'), (SELECT id FROM missions WHERE name = 'Largage de troupes'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Fairchild C-82 Packet'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 23.5,
  wingspan          = 32.45,
  height            = 8.03,
  wing_area         = 130.1,
  empty_weight      = 14742,
  mtow              = 24494,
  service_ceiling   = 6500,
  climb_rate        = 4.8,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 3,

  -- Strate 2 : motorisation
  engine_name       = 'Pratt & Whitney R-2800-85 Double Wasp (2 100 ch)',
  engine_count      = 2,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1944,
  production_end    = 1948,
  units_built       = 223,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 3,
  variants          = E'- **XC-82** : prototype unique, premier vol le 10 septembre 1944\n- **C-82A Packet** : version de série, 220 exemplaires construits à Hagerstown\n- **C-82N** : trois exemplaires construits par North American, les 997 autres annulés\n- **EC-82A** : essai d''un train à chenilles Firestone en 1948, un seul converti sur treize prévus\n- **XC-82B** : C-82A remotorisé en R-4360 Wasp Major, prototype du C-119\n- **Jet-Packet** : conversions civiles Steward-Davis avec un réacteur d''appoint au-dessus du fuselage',
  variants_en       = E'- **XC-82**: single prototype, first flight on 10 September 1944\n- **C-82A Packet**: production version, 220 built at Hagerstown\n- **C-82N**: three built by North American, the other 997 cancelled\n- **EC-82A**: 1948 trial of Firestone tracked landing gear, one converted out of thirteen planned\n- **XC-82B**: C-82A re-engined with R-4360 Wasp Majors, prototype of the C-119\n- **Jet-Packet**: Steward-Davis civil conversions with a booster jet above the fuselage',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Fairchild_C-82_Packet',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Fairchild_C-82_Packet',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Thornfield Hall',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Fairchild C-82 Packet';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Fairchild C-82 Packet';
