-- Lockheed L-1011-500 TriStar K1 / KC1 / C2
--
-- Photo : Tristar tanker zd952 view2 arp.jpg
--   licence Public domain — Adrian Pingstone (Arpingstone)
--   https://commons.wikimedia.org/wiki/File:Tristar_tanker_zd952_view2_arp.jpg

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
    'Lockheed TriStar (RAF)',
    'Lockheed TriStar (RAF)',
    'Lockheed L-1011-500 TriStar K1 / KC1 / C2',
    'Lockheed L-1011-500 TriStar K1 / KC1 / C2',
    'Triréacteur de ligne racheté après les Malouines pour ravitailler la RAF, de la guerre du Golfe à la Libye',
    'Three-engined airliner bought after the Falklands to refuel the RAF, from the Gulf War to Libya',
    '/assets/airplanes/lockheed-tristar-raf.jpg',
    E'## Genèse\nAu lendemain de la **guerre des Malouines**, en 1982, le ravitaillement des Hercules qui soutiennent la garnison britannique des îles use à toute vitesse le potentiel des **Handley Page Victor** de la RAF. Il faut d''urgence au moins quatre gros porteurs capables de ravitailler, de transporter des troupes et du fret. British Airways, qui veut se défaire de ses **Lockheed L-1011-500 TriStar**, s''associe à **Marshall Aerospace** de Cambridge pour en proposer six : la commande est passée le 14 décembre 1982. Trois anciens TriStar de la Pan Am s''y ajoutent en 1984, pour un total de neuf.\n\n## Conception\nMarshall transforme les avions dans ses ateliers de l''aéroport de Cambridge. Les quatre **KC1** reçoivent une grande porte cargo à l''avant et une cabine adaptable au fret palettisé, aux passagers ou aux évacuations sanitaires ; les deux **K1** n''ont pas la porte. Des réservoirs supplémentaires dans les soutes portent leur capacité à près de 140 t de carburant, délivré par deux enrouleurs Mk 17T sous l''arrière du fuselage. Les trois anciens Pan Am, deux **C2** et un C2A, restent des avions de passagers. Au fil des ans, les TriStar reçoivent un blindage du poste de pilotage et des contre-mesures infrarouges pour voler vers l''Irak.\n\n## Carrière opérationnelle\nLe premier KC1 est livré le 24 mars 1986 au 216 Squadron de Brize Norton. Pendant la **guerre du Golfe**, deux K1 peints en rose désert, surnommés « Pinky » et « Perky », effectuent plus de 90 missions et transfèrent 3 100 t de carburant. Les TriStar ravitaillent ensuite les chasseurs de l''OTAN au-dessus de la Bosnie puis du Kosovo, où cinq avions délivrent 6 100 t de carburant à 1 580 appareils. Ils soutiennent l''aéronavale américaine en Afghanistan, se déploient à Bahreïn pour l''Irak en 2003 et appuient les premières frappes britanniques sur la Libye en mars 2011.\n\n## Place dans l''histoire\nNée d''une leçon des Malouines, la flotte de TriStar sert encore là-bas en 2013-2014, détachée à Mount Pleasant pour remplacer les VC10 en fin de carrière. Sa modernisation, lancée en 2006, est abandonnée par la revue de défense de 2010, qui avance son retrait à 2014. Le 24 mars 2014, deux TriStar ravitaillent une dernière fois quatre Typhoon et un Tornado. L''**Airbus A330 MRTT**, ou Voyager, prend la relève ; les neuf avions finissent tous à la ferraille, six d''entre eux après avoir été revendus.',
    E'## Genesis\nIn the immediate aftermath of the **Falklands War** in 1982, refuelling the Hercules supporting the British garrison on the islands was rapidly using up the fatigue life of the RAF''s **Handley Page Victor** tankers. At least four wide-bodied aircraft able to refuel and carry troops and freight were urgently needed. British Airways, keen to dispose of its **Lockheed L-1011-500 TriStars**, teamed up with **Marshall Aerospace** of Cambridge to offer six: the order was placed on 14 December 1982. Three former Pan Am TriStars were added in 1984, for a total of nine.\n\n## Design\nMarshall converted the aircraft in its workshops at Cambridge Airport. The four **KC1s** received a large forward cargo door and a cabin that could take palletised freight, passengers or medical evacuation; the two **K1s** lacked the door. Extra tanks in the holds raised their capacity to nearly 140 t of fuel, delivered by two Mk 17T hose drum units under the rear fuselage. The three ex-Pan Am aircraft, two **C2s** and a C2A, remained passenger aircraft. Over the years the TriStars received cockpit armour and infrared countermeasures for flights into Iraq.\n\n## Operational career\nThe first KC1 was delivered on 24 March 1986 to No. 216 Squadron at Brize Norton. During the **Gulf War**, two K1s painted in pink desert camouflage, nicknamed "Pinky" and "Perky", flew more than 90 missions and transferred 3,100 t of fuel. The TriStars went on to refuel NATO fighters over Bosnia and then Kosovo, where five aircraft delivered 6,100 t of fuel to 1,580 receivers. They supported US Navy aircraft over Afghanistan, deployed to Bahrain for Iraq in 2003 and backed the first British strikes on Libya in March 2011.\n\n## Place in history\nBorn of a lesson from the Falklands, the TriStar fleet served there again in 2013-2014, detached to Mount Pleasant to stand in for the VC10s at the end of their careers. Its upgrade, launched in 2006, was abandoned by the 2010 defence review, which brought its retirement forward to 2014. On 24 March 2014 two TriStars refuelled four Typhoons and a Tornado for the last time. The **Airbus A330 MRTT**, or Voyager, took over; all nine aircraft were eventually scrapped, six of them after being sold on.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1970-11-16',
    '1986-03-24',
    956,
    7800,
    (SELECT id FROM manufacturer WHERE code = 'LM'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Ravitailleur'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM tech WHERE name = 'Moteurs à turbofan')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM tech WHERE name = 'Système de ravitaillement en vol'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM missions WHERE name = 'Ravitaillement en vol')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM missions WHERE name = 'Transport logistique'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM wars WHERE name = 'Guerre du Golfe')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM wars WHERE name = 'Guerre de Yougoslavie')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM wars WHERE name = 'Guerre d''Afghanistan')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM wars WHERE name = 'Guerre d''Irak')),
((SELECT id FROM airplanes WHERE name = 'Lockheed TriStar (RAF)'), (SELECT id FROM wars WHERE name = 'Intervention en Libye'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 50.06,
  wingspan          = 50.09,
  height            = 16.87,
  wing_area         = 329,
  empty_weight      = 110080,
  mtow              = 244940,
  service_ceiling   = 13106,
  climb_rate        = 14.3,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 4,

  -- Strate 2 : motorisation
  engine_name       = 'Rolls-Royce RB.211-524B',
  engine_count      = 3,
  engine_type       = 'Turboréacteur double flux',
  engine_type_en    = 'Turbofan',
  thrust_dry        = 222.4,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 9,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **TriStar K1** : deux anciens British Airways convertis en ravitailleurs et transports, sans porte cargo, jusqu''à 187 passagers\n- **TriStar KC1** : quatre anciens British Airways, mêmes équipements de ravitaillement que le K1 plus une grande porte cargo avant\n- **TriStar C1** : désignation des anciens British Airways exploités comme avions de passagers avant leur conversion\n- **TriStar C2** : deux anciens Pan Am, transport de passagers et évacuations sanitaires, fret en soute\n- **TriStar C2A** : un ancien Pan Am doté d''une avionique militaire et d''une nouvelle cabine',
  variants_en       = E'- **TriStar K1**: two ex-British Airways aircraft converted into tanker-transports, without a cargo door, up to 187 passengers\n- **TriStar KC1**: four ex-British Airways aircraft, same refuelling equipment as the K1 plus a large forward cargo door\n- **TriStar C1**: designation of the ex-British Airways aircraft flown as passenger aircraft before conversion\n- **TriStar C2**: two ex-Pan Am aircraft, passenger transport and medical evacuation, underfloor freight\n- **TriStar C2A**: one ex-Pan Am aircraft with military avionics and a new interior',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = NULL,
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Lockheed_TriStar_(RAF)',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Adrian Pingstone',
  image_licence     = 'Public domain'
WHERE name = 'Lockheed TriStar (RAF)';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Lockheed TriStar (RAF)';
