-- Ryan XV-5 Vertifan
--
-- Photo : XV-5B (NASA-705) on Flight Line at Ames Research Center with hangar in the background (ARC-1969-AC-41358).jpg
--   licence Public domain — NASA Ames Research Center / Jim Remington
--   https://commons.wikimedia.org/wiki/File:XV-5B_(NASA-705)_on_Flight_Line_at_Ames_Research_Center_with_hangar_in_the_background_(ARC-1969-AC-41358).jpg

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
    'Ryan XV-5 Vertifan',
    'Ryan XV-5 Vertifan',
    'Ryan XV-5 Vertifan',
    'Ryan XV-5 Vertifan',
    'Avion de recherche à décollage vertical de l''US Army, sustenté par des soufflantes noyées dans les ailes',
    'US Army vertical take-off research jet, lifted by fans buried in its wings',
    '/assets/airplanes/xv5-vertifan.jpg',
    E'## Genèse\nAu début des années 1960, l''**US Army** pense que l''avion à décollage vertical peut lui donner, loin des aérodromes, la mobilité qu''exige une guerre limitée. En 1961, elle commande à **Ryan Aeronautical**, associé à **General Electric**, le **VZ-11-RY**, rebaptisé XV-5A en 1962, en même temps que le Lockheed VZ-10 Hummingbird. Le XV-5 doit démontrer une idée précise : la sustentation par des **soufflantes carénées** logées dans la voilure et entraînées par les gaz des réacteurs. Il vole le 25 mai 1964.\n\n## Conception\nDeux turboréacteurs **General Electric J85** de 11,8 kN assurent le vol horizontal. Pour le vol vertical, leurs gaz sont dirigés vers deux soufflantes **X353-5** de 1,59 m noyées dans les ailes et vers une soufflante de 0,91 m dans le nez. Mues par des aubes de turbine placées à leur périphérie, elles brassent treize fois plus d''air que les réacteurs et fournissent environ 71 kN de sustentation, près de trois fois leur poussée directe. Des persiennes sous les soufflantes orientent le flux vers l''avant ou l''arrière et assurent le contrôle en lacet et en roulis. L''avion a une aile delta, une entrée d''air au-dessus du poste biplace côte à côte et un empennage en T.\n\n## Essais\nLes soufflantes donnent moins de poussée qu''espéré, et la transition entre vol vertical et horizontal est brutale. Le 27 avril 1965, lors d''une démonstration publique, le pilote de Ryan **Lou Everett** déclenche sans doute par mégarde l''interrupteur de conversion, mal placé sur le levier de pas collectif : l''avion pique, et il périt en s''éjectant, son siège ayant été mal réglé. Le 5 octobre 1966, lors d''essais de sauvetage, la sangle suspendue destinée aux naufragés est aspirée par une soufflante ; le **major David Tittle** est tué par son siège éjectable, déclenché après l''impact. Reconstruit avec des commandes améliorées et un train élargi, le second appareil devient le **XV-5B**, essayé jusqu''en 1971.\n\n## Place dans l''histoire\nLe programme est abandonné, mais le principe de la soufflante carénée est jugé réussi : silencieuse pour son époque, elle rejette un air assez frais pour se poser sur un sol ordinaire, sans tapis de protection. L''association du J85 et de la soufflante annonce le **General Electric TF39**, premier réacteur à fort taux de dilution, monté sur le **C-5 Galaxy**. Seul le **Harrier** franchira le siècle parmi les dizaines d''avions à décollage vertical de l''époque, avant que le **F-35B** ne reprenne l''idée d''une soufflante, entraînée cette fois par un arbre. Le XV-5B est conservé au musée de l''aviation de l''US Army à Fort Rucker.',
    E'## Genesis\nIn the early 1960s the **US Army** believed vertical take-off aircraft could give it, away from airfields, the mobility a limited war demanded. In 1961 it ordered the **VZ-11-RY** from **Ryan Aeronautical**, teamed with **General Electric**, alongside the Lockheed VZ-10 Hummingbird; the two became the XV-5A and XV-4 in 1962. The XV-5 was to prove a specific idea: lift from **ducted fans** set in the wings and driven by the engines'' exhaust gas. It made its first flight on 25 May 1964.\n\n## Design\nTwo 11.8 kN **General Electric J85** turbojets provided horizontal flight. For vertical flight their exhaust was diverted to two 1.59 m **X353-5** fans buried in the wings, under hinged doors on the upper surface, and to a 0.91 m fan in the nose. Driven by turbine blades around their periphery, they moved thirteen times the engines'' mass flow and gave about 71 kN of lift, nearly three times the engines'' direct thrust. Louvres under the fans vectored the flow fore and aft and provided yaw and roll control. The aircraft had a delta wing, an intake above the two-seat side-by-side cockpit and a T-tail.\n\n## Testing\nThe fans produced less thrust than hoped, and the transition between vertical and horizontal flight was abrupt. On 27 April 1965, during a public demonstration, Ryan test pilot **Lou Everett** apparently tripped the conversion switch by mistake, badly placed on the collective lever: the aircraft pitched down and he was killed ejecting, his seat having been improperly rigged. On 5 October 1966, during rescue trials, the suspended survivor sling was ingested by a wing fan; **Major David Tittle** was killed by his ejection seat, fired after the impact. Rebuilt with improved controls and a wider undercarriage, the second aircraft became the **XV-5B**, tested until 1971.\n\n## Place in history\nThe programme was cancelled, but the ducted fan concept was judged a success: quiet for its time, it exhausted air cool enough to operate from ordinary surfaces without protective mats. The pairing of the J85 and the fan led towards the **General Electric TF39**, the first high-bypass engine, fitted to the **C-5 Galaxy**. Of the dozens of vertical take-off aircraft of the era, only the **Harrier** would still be operational at the turn of the century, before the **F-35B** revived the lift fan, this time shaft-driven. The XV-5B is kept at the US Army Aviation Museum at Fort Rucker.',
    (SELECT id FROM countries WHERE code = 'USA'),
    '1961-01-01',
    '1964-05-25',
    NULL,
    880,
    1600,
    (SELECT id FROM manufacturer WHERE code = 'RYA'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan XV-5 Vertifan'), (SELECT id FROM tech WHERE name = 'Soufflante de sustentation')),
((SELECT id FROM airplanes WHERE name = 'Ryan XV-5 Vertifan'), (SELECT id FROM tech WHERE name = 'Poste de pilotage côte à côte'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Ryan XV-5 Vertifan'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 13.56,
  wingspan          = 9.09,
  height            = 4.5,
  wing_area         = 24.18,
  empty_weight      = 3421,
  mtow              = 6169,
  service_ceiling   = 12192,
  climb_rate        = 40.6,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 2,

  -- Strate 2 : motorisation
  engine_name       = 'General Electric J85-GE-5',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 11.8,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 2,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 2,
  variants          = E'- **VZ-11-RY** : désignation d''origine de la commande de l''US Army en 1961\n- **XV-5A** : deux exemplaires au standard initial, en livrée vert armée ; le premier détruit le 27 avril 1965\n- **XV-5B** : second XV-5A reconstruit après l''accident de 1966, commandes améliorées, train fixe à voie large et sustentation renforcée ; aux couleurs de la NASA, essayé jusqu''en 1971\n- **Version de sauvetage** : proposée avec un compartiment derrière les pilotes et un treuil, essayée sans suite',
  variants_en       = E'- **VZ-11-RY**: original designation of the 1961 US Army order\n- **XV-5A**: two aircraft to the initial standard, in Army green; the first was destroyed on 27 April 1965\n- **XV-5B**: the second XV-5A rebuilt after the 1966 accident, with improved controls, a fixed wide-track undercarriage and up-rated lift system; in NASA colours, tested until 1971\n- **Rescue version**: proposed with a compartment behind the pilots and a winch, trialled without follow-up',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Ryan_XV-5_Vertifan',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Ryan_XV-5_Vertifan',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Jim Remington, NASA Ames Research Center',
  image_licence     = 'Public domain'
WHERE name = 'Ryan XV-5 Vertifan';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Ryan XV-5 Vertifan';
