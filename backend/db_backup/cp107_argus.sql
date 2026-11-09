-- Canadair CP-107 Argus (CL-28)
--
-- Photo : Argus (CP 107).jpg
--   licence CC BY-SA 4.0 — Taylormcalear
--   https://commons.wikimedia.org/wiki/File:Argus_(CP_107).jpg

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
    'Canadair CP-107 Argus',
    'Canadair CP-107 Argus',
    'Canadair CP-107 Argus (CL-28)',
    'Canadair CP-107 Argus (CL-28)',
    'Une aile de Britannia, quatre moteurs en étoile et une journée entière au-dessus de l’Atlantique',
    'A Britannia wing, four radial engines and a whole day over the Atlantic',
    '/assets/airplanes/cp107-argus.jpg',
    E'## Genèse\nEn 1952, l''Aviation royale du Canada cherche à remplacer les **Avro Lancaster** reconvertis qui patrouillent l''Atlantique Nord. Il lui faut un appareil capable de rester une journée entière au-dessus de l''océan pour traquer les sous-marins soviétiques, loin de toute côte. Canadair propose de partir du **Bristol Britannia**, un long-courrier britannique dont elle détient la licence de fabrication.\n\n## Conception\nDe l''avion de ligne, l''Argus garde l''aile et l''empennage ; le fuselage est redessiné autour de deux soutes à armes. Les turbopropulseurs Proteus du Britannia cèdent la place à quatre moteurs en étoile **Wright R-3350 Turbo-Compound** de 3 700 ch, bien plus sobres à basse altitude, là où se joue la chasse au sous-marin. Le Mk 1 porte un radar américain AN/APS-20 dans un volumineux carénage sous le nez ; le Mk 2, un radar britannique ASV-21 plus compact. Une perche de détection d''anomalies magnétiques prolonge la queue. Quinze hommes d''équipage, jusqu''à 3 600 kg de torpilles et de grenades anti-sous-marines en soute.\n\n## Carrière opérationnelle\nPremier vol le 27 mars 1957, mise en service en 1958 à Greenwood, en Nouvelle-Écosse, puis à Summerside. Trente-trois exemplaires sont livrés jusqu''en 1960. Ils traquent les sous-marins soviétiques dans l''Atlantique et, après 1968, dans le Pacifique depuis Comox, où ils succèdent aux **P-2 Neptune** acquis comme solution d''attente. L''endurance est hors norme : vingt-six heures et demie à pleine charge d''armement, et un vol de plus de trente et une heures en 1959, record de l''aviation militaire canadienne. L''appareil quitte le service au début des années 1980.\n\n## Place dans l''histoire\nSouvent cité comme l''un des meilleurs patrouilleurs anti-sous-marins de son temps, l''Argus incarne la contribution canadienne à la lutte anti-sous-marine de l''OTAN, au même titre que l''**Avro Shackleton** britannique. Il marque aussi la fin d''une époque : son remplaçant, le **CP-140 Aurora**, dérivé du **P-3 Orion**, revient aux turbopropulseurs que l''Argus avait écartés.',
    E'## Genesis\nIn 1952 the Royal Canadian Air Force set out to replace the converted **Avro Lancasters** patrolling the North Atlantic. It needed an aircraft able to stay a whole day over the ocean hunting Soviet submarines, far from any coast. Canadair proposed starting from the **Bristol Britannia**, a British long-haul airliner it held the licence to build.\n\n## Design\nFrom the airliner the Argus kept the wing and tail; the fuselage was redesigned around two weapons bays. The Britannia''s Proteus turboprops gave way to four **Wright R-3350 Turbo-Compound** radial engines of 3,700 hp, far more economical at low altitude, where submarine hunting takes place. The Mk 1 carried an American AN/APS-20 radar in a bulky fairing under the nose; the Mk 2 a more compact British ASV-21. A magnetic anomaly detector boom extended the tail. A crew of fifteen and up to 3,600 kg of torpedoes and depth charges in the bays.\n\n## Operational career\nFirst flight on 27 March 1957, service entry in 1958 at Greenwood, Nova Scotia, then at Summerside. Thirty-three were delivered by 1960. They hunted Soviet submarines in the Atlantic and, after 1968, in the Pacific from Comox, where they succeeded the **P-2 Neptunes** bought as a stopgap. Endurance was exceptional: twenty-six and a half hours with a full weapons load, and a flight of more than thirty-one hours in 1959, a Canadian military record. The aircraft left service in the early 1980s.\n\n## Place in history\nOften cited as one of the finest anti-submarine patrol aircraft of its day, the Argus embodies Canada''s contribution to NATO anti-submarine warfare, alongside the British **Avro Shackleton**. It also marks the end of an era: its replacement, the **CP-140 Aurora**, derived from the **P-3 Orion**, returned to the turboprops the Argus had set aside.',
    (SELECT id FROM countries WHERE code = 'CAN'),
    '1952-01-01',
    '1957-03-27',
    '1958-01-01',
    507.0,
    9500.0,
    (SELECT id FROM manufacturer WHERE code = 'CDR'),
    (SELECT id FROM generation WHERE generation = 2),
    (SELECT id FROM type WHERE name = 'Reconnaissance'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus'), (SELECT id FROM tech WHERE name = 'Moteur à pistons en étoile')),
((SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus'), (SELECT id FROM tech WHERE name = 'Aile droite à faible allongement'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus'), (SELECT id FROM missions WHERE name = 'Reconnaissance stratégique')),
((SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus'), (SELECT id FROM missions WHERE name = 'Attaque antinavire'));

-- Conflits
INSERT INTO airplane_wars (id_airplane, id_wars) VALUES
((SELECT id FROM airplanes WHERE name = 'Canadair CP-107 Argus'), (SELECT id FROM wars WHERE name = 'Guerre froide'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 40.35,
  wingspan          = 43.37,
  height            = 12.42,
  wing_area         = 192.8,
  empty_weight      = 36741,
  mtow              = 71214,
  service_ceiling   = 7600,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 15,

  -- Strate 2 : motorisation
  engine_name       = 'Wright R-3350 (TC18EA1) Turbo-Compound',
  engine_count      = 4,
  engine_type       = 'Moteur en étoile',
  engine_type_en    = 'Radial engine',
  thrust_dry        = NULL,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = 1957,
  production_end    = 1960,
  units_built       = 33,
  unit_cost_usd     = NULL,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **Argus Mk 1** : 13 exemplaires, radar américain AN/APS-20 sous un gros carénage de nez\n- **Argus Mk 2** : 20 exemplaires, radar britannique ASV-21 plus compact et électronique revue\n- **CL-28** : désignation constructeur Canadair ; **CP-107** dans les Forces canadiennes unifiées\n- Dérivé du **Bristol Britannia**, dont il conserve l''aile et l''empennage\n- Remplacé par le **CP-140 Aurora**, dérivé du **P-3 Orion**',
  variants_en       = E'- **Argus Mk 1** : 13 built, American AN/APS-20 radar under a large nose fairing\n- **Argus Mk 2** : 20 built, more compact British ASV-21 radar and revised electronics\n- **CL-28** : Canadair company designation; **CP-107** in the unified Canadian Forces\n- Derived from the **Bristol Britannia**, keeping its wing and tail\n- Replaced by the **CP-140 Aurora**, derived from the **P-3 Orion**',

  -- Strate 4 : qualitatif
  nickname          = 'Argus',

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/Canadair_CP-107_Argus',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/Canadair_CP-107_Argus',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Taylormcalear',
  image_licence     = 'CC BY-SA 4.0'
WHERE name = 'Canadair CP-107 Argus';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'Canadair CP-107 Argus';
