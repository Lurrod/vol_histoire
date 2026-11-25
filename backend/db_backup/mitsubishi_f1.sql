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
    'Mitsubishi F-1',
    'Mitsubishi F-1',
    'Mitsubishi F-1 (Japan Air Self-Defense Force)',
    'Mitsubishi F-1 (Japan Air Self-Defense Force)',
    'Premier avion de combat de conception japonaise depuis 1945, dérivé du T-2',
    'First Japanese-designed combat aircraft since 1945, derived from the T-2',
    '/assets/airplanes/mitsubishi-f1.jpg',
    'Le Mitsubishi F-1 est le premier chasseur-bombardier à réaction de conception japonaise depuis la Seconde Guerre mondiale, dérivé monoplace du T-2 avec le poste arrière converti en baie avionique et un système de navigation/attaque intégré Fujitsu. Spécialisé dans la frappe antinavire avec le missile ASM-1, il assurait la défense du littoral japonais contre une éventuelle flotte soviétique. 77 exemplaires produits entre 1977 et 1987. Retiré en 2006, remplacé par le F-2.',
    'The Mitsubishi F-1 is Japan''s first domestically designed jet fighter-bomber since World War II, a single-seat derivative of the T-2 with the rear seat converted into an avionics bay and a Fujitsu integrated navigation/attack system. Specialised in anti-ship strike with the ASM-1 missile, it provided coastal defence for Japan against a potential Soviet fleet. 77 examples built between 1977 and 1987. Retired in 2006, replaced by the F-2.',
    (SELECT id FROM countries WHERE code = 'JPN'),
    '1972-01-01',
    '1975-06-03',
    '1977-09-16',
    1700.0,
    2870.0,
    (SELECT id FROM manufacturer WHERE code = 'MHI'),
    (SELECT id FROM generation WHERE generation = 3),
    (SELECT id FROM type WHERE name = 'Appui aérien'),
    'Retiré',
    'Retired'
);

-- Insertion des technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Aile en flèche')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Réacteur Rolls-Royce/Turbomeca Adour')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Système de navigation et d''attaque intégré')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM tech WHERE name = 'Système de contre-mesures électroniques'));

-- Insertion des armements
INSERT INTO airplane_armement (id_airplane, id_armement) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'JM61A1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'AIM-9 Sidewinder')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'ASM-1')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'Bombe lisse 500 kg')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM armement WHERE name = 'Mk 82'));

-- Insertion des guerres

-- Insertion des missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM missions WHERE name = 'Attaque antinavire')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM missions WHERE name = 'Frappe tactique')),
((SELECT id FROM airplanes WHERE name = 'Mitsubishi F-1'), (SELECT id FROM missions WHERE name = 'Appui aérien rapproché'));

-- [auto:005] enrichment block
UPDATE airplanes SET
  length = 17.86, wingspan = 7.88, height = 4.39, wing_area = 21.17,
  empty_weight = 6358, mtow = 13700, service_ceiling = 15240, climb_rate = 178,
  combat_radius = 556, crew = 1, g_limit_pos = 7.33, g_limit_neg = -3.0,
  engine_name = 'Ishikawajima-Harima TF40-IHI-801A (licence Adour)', engine_count = 2,
  engine_type = 'Turbofan avec postcombustion', engine_type_en = 'Afterburning turbofan',
  thrust_dry = 22.8, thrust_wet = 32.5,
  production_start = 1977, production_end = 1987, units_built = 77,
  operators_count = 1,
  wikipedia_fr = 'https://fr.wikipedia.org/wiki/Mitsubishi_F-1',
  wikipedia_en = 'https://en.wikipedia.org/wiki/Mitsubishi_F-1'
WHERE name = 'Mitsubishi F-1';

-- [auto:006] enrichment block
UPDATE airplanes SET
  unit_cost_usd = 12000000, unit_cost_year = 1980,
  manufacturer_page = 'https://www.mhi.com/',
  variants    = E'- **F-1** : version unique monoplace d''attaque antinavire\n- **F-1 Kai** : modernisation avionique années 1990\n- Évolution du T-2 biplace avec poste arrière transformé en baie avionique Fujitsu\n- 77 appareils produits pour 3 escadrons (3 Hikōtai à Tsuiki, 6 Hikōtai à Tsuiki, 8 Hikōtai à Misawa)',
  variants_en = E'- **F-1** : unique single-seat anti-ship attack version\n- **F-1 Kai** : 1990s avionics upgrade\n- Evolution of the two-seat T-2 with rear seat transformed into a Fujitsu avionics bay\n- 77 aircraft produced for 3 squadrons (3 Hikōtai at Tsuiki, 6 Hikōtai at Tsuiki, 8 Hikōtai at Misawa)'
WHERE name = 'Mitsubishi F-1';

-- [auto:007] enrichment block
UPDATE airplanes SET
  description = E'## Genèse\nEn 1972, le Japon décide de remplacer ses **F-86F Sabre** de soutien tactique. Plutôt que d''acheter à l''étranger, il choisit de dériver un monoplace d''attaque du **T-2**, l''avion-école supersonique de **Mitsubishi** qui a volé le 20 juillet 1971. Les contrats de développement de cette version, alors appelée FS-T2-Kai, sont passés en 1973 ; deux T-2 sont transformés en prototypes, et le premier vole le 3 juin 1975.\n\n## Conception\nLe F-1 garde la cellule du T-2 et ses deux turbofans **Adour** construits sous licence par Ishikawajima-Harima, mais la place arrière disparaît : elle abrite l''électronique d''un système de navigation et d''attaque intégré. Le nez reçoit un radar J/AWG-12. L''avion porte un canon **JM61A1** de 20 mm et sept points d''emport pour bombes Mk 82 et M117, missiles Sidewinder et surtout le **ASM-1** (Type 80), missile antinavire japonais d''une portée d''environ 50 km, remplacé au milieu des années 1990 par l''**ASM-2** (Type 93). C''est le premier avion de combat supersonique développé au Japon.\n\n## Carrière opérationnelle\nLe premier F-1 de série vole le 16 juin 1977 et est livré le 16 septembre suivant. Le 3e escadron de la 3e escadre, à **Misawa**, est opérationnel en avril 1978 ; le 8e escadron, sur la même base, se transforme entre juin 1979 et février 1980, et le 6e escadron de la 8e escadre, à **Tsuiki**, devient opérationnel le 1er mars 1981. Leur mission : attaquer en mer une flotte soviétique qui tenterait un débarquement. Les restrictions budgétaires ramènent la commande de 160 à 77 appareils, le dernier livré le 9 mars 1987.\n\nDans les années 1990, 70 avions voient leur potentiel porté de 3 500 à 4 000 heures de vol, car le **F-2** prend du retard. Le 8e escadron passe sur F-4EJ Kai, le 3e reçoit des F-2 entre octobre 2000 et février 2001, et les six derniers F-1, à Tsuiki, sont retirés le 9 mars 2006. L''avion n''a jamais combattu.\n\n## Place dans l''histoire\nModeste par ses performances, le F-1 a rendu au Japon la maîtrise d''un avion de combat complet, de la cellule au système d''armes. Le F-2 hérite de sa mission antinavire.',
  description_en = E'## Genesis\nIn 1972 Japan decided to replace its **F-86F Sabres** in the tactical support role. Rather than buy abroad, it chose to derive a single-seat attack aircraft from the **T-2**, the supersonic trainer **Mitsubishi** had flown on 20 July 1971. Development contracts for this version, then called FS-T2-Kai, were awarded in 1973; two T-2s were converted into prototypes, and the first flew on 3 June 1975.\n\n## Design\nThe F-1 kept the T-2 airframe and its two licence-built **Adour** turbofans from Ishikawajima-Harima, but the rear seat gave way to the electronics of an integrated navigation and attack system. The nose housed a J/AWG-12 radar. The aircraft carried a 20 mm **JM61A1** cannon and seven hardpoints for Mk 82 and M117 bombs, Sidewinder missiles and above all the **ASM-1** (Type 80), a Japanese anti-ship missile with a range of about 50 km, replaced in the mid-1990s by the **ASM-2** (Type 93). It was the first supersonic combat aircraft developed in Japan.\n\n## Operational career\nThe first production F-1 flew on 16 June 1977 and was delivered on 16 September. The 3rd Squadron of the 3rd Air Wing at **Misawa** was operational by April 1978; the 8th Squadron, at the same base, converted between June 1979 and February 1980, and the 6th Squadron of the 8th Air Wing at **Tsuiki** became operational on 1 March 1981. Their mission was to attack at sea a Soviet fleet attempting a landing. Budget cuts reduced the order from 160 to 77 aircraft, the last delivered on 9 March 1987.\n\nIn the 1990s, 70 aircraft had their airframe life extended from 3,500 to 4,000 flight hours, because the **F-2** was running late. The 8th Squadron switched to F-4EJ Kai, the 3rd received F-2s between October 2000 and February 2001, and the last six F-1s, at Tsuiki, were retired on 9 March 2006. The aircraft never saw combat.\n\n## Place in history\nModest in performance, the F-1 gave Japan back the mastery of a complete combat aircraft, from airframe to weapon system. The F-2 inherited its anti-ship mission.'
WHERE name = 'Mitsubishi F-1';

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Mitsubishi F-1';
