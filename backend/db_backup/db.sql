GRANT ALL PRIVILEGES ON DATABASE vol_histoire TO vol_user;
GRANT USAGE ON SCHEMA public TO vol_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO vol_user;

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO roles (name) VALUES ('admin'), ('editeur'), ('utilisateur');


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL DEFAULT 3,
    email_verified BOOLEAN NOT NULL DEFAULT false,
    failed_login_count INTEGER NOT NULL DEFAULT 0,
    locked_until TIMESTAMPTZ NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Index pour les recherches fréquentes par email (login, register, reset password)
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_users_locked_until ON users (locked_until) WHERE locked_until IS NOT NULL;

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id          SERIAL PRIMARY KEY,
    jti         VARCHAR(36) UNIQUE NOT NULL,       -- UUID v4, identifiant unique du token
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    revoked     BOOLEAN NOT NULL DEFAULT FALSE,
    expires_at  TIMESTAMP NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Index pour les requêtes fréquentes :
-- 1. Vérification de validité (lookup par jti)
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_jti ON refresh_tokens (jti) WHERE revoked = FALSE;

-- 2. Révocation de tous les tokens d'un utilisateur
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens (user_id) WHERE revoked = FALSE;

-- 3. Nettoyage des tokens expirés
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_expires_at ON refresh_tokens (expires_at);

-- Permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON refresh_tokens TO vol_user;
GRANT USAGE, SELECT ON SEQUENCE refresh_tokens_id_seq TO vol_user;

CREATE TABLE IF NOT EXISTS email_tokens (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       VARCHAR(64) NOT NULL UNIQUE,
    type        VARCHAR(10) NOT NULL CHECK (type IN ('verify', 'reset')),
    expires_at  TIMESTAMP NOT NULL,
    used_at     TIMESTAMP,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_email_tokens_token ON email_tokens (token) WHERE used_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_email_tokens_user_type ON email_tokens (user_id, type) WHERE used_at IS NULL;
GRANT SELECT, INSERT, UPDATE, DELETE ON email_tokens TO vol_user;
GRANT USAGE, SELECT ON SEQUENCE email_tokens_id_seq TO vol_user;

CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    code VARCHAR(3) UNIQUE NOT NULL
);

CREATE TABLE manufacturer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    country_id INTEGER REFERENCES countries(id) ON DELETE SET NULL,
    code VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE generation (
    id SERIAL PRIMARY KEY,
    generation SMALLINT NOT NULL,
    description VARCHAR(255),
    description_en VARCHAR(255)
);

CREATE TABLE tech (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description VARCHAR(255),
    description_en VARCHAR(255)
);

CREATE TABLE type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    name_en VARCHAR(50),
    description VARCHAR(255),
    description_en VARCHAR(255)
);

CREATE TABLE airplanes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    complete_name VARCHAR(255),
    complete_name_en VARCHAR(255),
    little_description VARCHAR(255),
    little_description_en VARCHAR(255),
    image_url VARCHAR(255),
    description TEXT,
    description_en TEXT,
    country_id INTEGER REFERENCES countries(id) ON DELETE SET NULL,
    date_concept DATE,
    date_first_fly DATE,
    date_operationel DATE,
    max_speed FLOAT,
    max_range FLOAT,
    id_manufacturer INTEGER REFERENCES manufacturer(id) ON DELETE SET NULL,
    id_generation SMALLINT REFERENCES generation(id) ON DELETE SET NULL,
    type INTEGER REFERENCES type(id) ON DELETE SET NULL,
    status VARCHAR(50),
    status_en VARCHAR(50),
    weight FLOAT,
    -- Strate 1 : fiche technique étendue
    length FLOAT,
    wingspan FLOAT,
    height FLOAT,
    wing_area FLOAT,
    empty_weight FLOAT,
    mtow FLOAT,
    service_ceiling INTEGER,
    climb_rate FLOAT,
    g_limit_pos FLOAT,
    g_limit_neg FLOAT,
    combat_radius FLOAT,
    crew SMALLINT,
    -- Strate 2 : motorisation
    engine_name VARCHAR(255),
    engine_count SMALLINT,
    engine_type VARCHAR(100),
    engine_type_en VARCHAR(100),
    thrust_dry FLOAT,
    thrust_wet FLOAT,
    -- Strate 3 : production & service
    production_start SMALLINT,
    production_end SMALLINT,
    units_built INTEGER,
    unit_cost_usd BIGINT,
    unit_cost_year SMALLINT,
    operators_count SMALLINT,
    variants TEXT,
    variants_en TEXT,
    -- Strate 4 : qualitatif + références croisées
    stealth_level VARCHAR(20) CHECK (stealth_level IS NULL OR stealth_level IN ('aucune','reduite','moderee','elevee','tres_elevee')),
    nickname VARCHAR(255),
    predecessor_id INTEGER REFERENCES airplanes(id) ON DELETE SET NULL,
    successor_id INTEGER REFERENCES airplanes(id) ON DELETE SET NULL,
    rival_id INTEGER REFERENCES airplanes(id) ON DELETE SET NULL,
    -- Strate 6 : médias externes
    wikipedia_fr VARCHAR(500),
    wikipedia_en VARCHAR(500),
    youtube_showcase VARCHAR(500),
    manufacturer_page VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Index pour navigation prédécesseur/successeur/rival (strate 4)
CREATE INDEX IF NOT EXISTS idx_airplanes_predecessor ON airplanes (predecessor_id) WHERE predecessor_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_airplanes_successor   ON airplanes (successor_id)   WHERE successor_id   IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_airplanes_rival       ON airplanes (rival_id)       WHERE rival_id       IS NOT NULL;

-- Indexes pour les filtres et tris fréquents sur /api/airplanes
CREATE INDEX IF NOT EXISTS idx_airplanes_country_id     ON airplanes (country_id);
CREATE INDEX IF NOT EXISTS idx_airplanes_id_generation  ON airplanes (id_generation);
CREATE INDEX IF NOT EXISTS idx_airplanes_type           ON airplanes (type);
CREATE INDEX IF NOT EXISTS idx_airplanes_id_manufacturer ON airplanes (id_manufacturer);
-- Index composite pour les requêtes combinant les 3 filtres principaux
CREATE INDEX IF NOT EXISTS idx_airplanes_filters        ON airplanes (country_id, id_generation, type);
-- Index pour le JOIN manufacturer → countries (page /manufacturers)
CREATE INDEX IF NOT EXISTS idx_manufacturer_country_id  ON manufacturer (country_id);

-- Full-text search : colonne générée + GIN index
-- (voir aussi migrations/001_airplanes_search_vector.sql pour les bases existantes)
ALTER TABLE airplanes
  ADD COLUMN IF NOT EXISTS search_vector tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('simple', coalesce(name, '')),                'A') ||
    setweight(to_tsvector('simple', coalesce(name_en, '')),             'A') ||
    setweight(to_tsvector('simple', coalesce(complete_name, '')),       'B') ||
    setweight(to_tsvector('simple', coalesce(complete_name_en, '')),    'B') ||
    setweight(to_tsvector('simple', coalesce(little_description, '')),  'C') ||
    setweight(to_tsvector('simple', coalesce(little_description_en, '')),'C') ||
    setweight(to_tsvector('simple', coalesce(description, '')),         'D') ||
    setweight(to_tsvector('simple', coalesce(description_en, '')),      'D')
  ) STORED;
CREATE INDEX IF NOT EXISTS idx_airplanes_search_vector  ON airplanes USING GIN (search_vector);

CREATE TABLE favorites (
  user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  airplane_id INTEGER NOT NULL REFERENCES airplanes(id) ON DELETE CASCADE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, airplane_id)
);

CREATE TABLE wars (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    date_start DATE,
    date_end DATE,
    country_id INTEGER REFERENCES countries(id) ON DELETE SET NULL,
    description TEXT,
    description_en TEXT
);

CREATE TABLE armement (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    description_en TEXT
);

CREATE TABLE missions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    name_en VARCHAR(255),
    description TEXT,
    description_en TEXT
);

CREATE TABLE airplane_armement (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_armement INTEGER REFERENCES armement(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_armement)
);

CREATE TABLE airplane_wars (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_wars INTEGER REFERENCES wars(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_wars)
);

CREATE TABLE airplane_missions (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_mission INTEGER REFERENCES missions(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_mission)
);

CREATE TABLE airplane_tech (
    id_airplane INTEGER REFERENCES airplanes(id) ON DELETE CASCADE,
    id_tech INTEGER REFERENCES tech(id) ON DELETE CASCADE,
    PRIMARY KEY (id_airplane, id_tech)
);

-- Trigger updated_at automatique (partagé par users et airplanes)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_airplanes_updated_at
  BEFORE UPDATE ON airplanes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO countries (name, name_en, code) VALUES
('États-Unis', 'United States', 'USA'),
('Russie', 'Russia', 'RUS'),
('Chine', 'China', 'CHN'),
('France', 'France', 'FRA'),
('Royaume-Uni', 'United Kingdom', 'GBR'),
('Allemagne', 'Germany', 'DEU'),
('Italie', 'Italy', 'ITA'),
('Suède', 'Sweden', 'SWE'),
('Inde', 'India', 'IND'),
('Japon', 'Japan', 'JPN'),
('Brésil', 'Brazil', 'BRA'),
('Israël', 'Israel', 'ISR'),
('Vietnam', 'Vietnam', 'VNM'),
('Afghanistan', 'Afghanistan', 'AFG'),
('Irak', 'Iraq', 'IRQ'),
('Yougoslavie', 'Yugoslavia', 'YUG'),
('Corée', 'Korea', 'KOR'),
('Îles Malouines', 'Falkland Islands', 'FLK'),
('Liban', 'Lebanon', 'LBN'),
('Algérie', 'Algeria', 'DZA'),
('Syrie', 'Syria', 'SYR'),
('Iran', 'Iran', 'IRN');

INSERT INTO wars (name, name_en, date_start, date_end, country_id, description, description_en) VALUES
('Guerre du Vietnam', 'Vietnam War', '1955-11-01', '1975-04-30', (SELECT id FROM countries WHERE code = 'VNM'), 'Conflit prolongé entre le Nord-Vietnam communiste et le Sud-Vietnam soutenu par les États-Unis.', 'Prolonged conflict between communist North Vietnam and US-backed South Vietnam.'),
('Guerre des Six Jours', 'Six-Day War', '1967-06-05', '1967-06-10', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes (Égypte, Jordanie, Syrie).', 'Conflict between Israel and a coalition of Arab countries (Egypt, Jordan, Syria).'),
('Guerre du Kippour', 'Yom Kippur War', '1973-10-06', '1973-10-25', (SELECT id FROM countries WHERE code = 'ISR'), 'Conflit entre Israël et une coalition de pays arabes menée par l''Égypte et la Syrie.', 'Conflict between Israel and a coalition of Arab countries led by Egypt and Syria.'),
('Guerre froide', 'Cold War', '1947-03-12', '1991-12-26', NULL, 'Confrontation indirecte entre les États-Unis et l''Union soviétique, marquée par des tensions géopolitiques et des conflits par procuration à travers le monde.', 'Indirect confrontation between the United States and the Soviet Union, marked by geopolitical tensions and proxy conflicts worldwide.'),
('Guerre Iran-Irak', 'Iran-Iraq War', '1980-09-22', '1988-08-20', (SELECT id FROM countries WHERE code = 'IRQ'), 'Conflit prolongé entre l''Iran et l''Irak, marqué par des batailles aériennes et terrestres intenses.', 'Prolonged conflict between Iran and Iraq, marked by intense air and ground battles.'),
('Guerre du Golfe', 'Gulf War', '1990-08-02', '1991-02-28', (SELECT id FROM countries WHERE code = 'IRQ'), 'Conflit entre une coalition internationale dirigée par les États-Unis et l''Irak après l''invasion du Koweït.', 'Conflict between a US-led international coalition and Iraq following the invasion of Kuwait.'),
('Guerre de Yougoslavie', 'Yugoslav Wars', '1991-03-31', '2001-06-21', (SELECT id FROM countries WHERE code = 'YUG'), 'Série de conflits ethniques et politiques dans les Balkans, impliquant plusieurs pays et factions.', 'Series of ethnic and political conflicts in the Balkans involving several countries and factions.'),
('Guerre d''Afghanistan', 'War in Afghanistan', '2001-10-07', '2021-08-30', (SELECT id FROM countries WHERE code = 'AFG'), 'Conflit prolongé en Afghanistan impliquant les États-Unis et leurs alliés contre les talibans et Al-Qaïda.', 'Prolonged conflict in Afghanistan involving the United States and its allies against the Taliban and Al-Qaeda.'),
('Guerre d''Irak', 'Iraq War', '2003-03-20', '2011-12-18', (SELECT id FROM countries WHERE code = 'IRQ'), 'Conflit en Irak mené par une coalition dirigée par les États-Unis pour renverser le régime de Saddam Hussein.', 'Conflict in Iraq led by a US-led coalition to overthrow Saddam Hussein'),
('Conflit israélo-arabe', 'Arab-Israeli Conflict', '1948-05-15', NULL, (SELECT id FROM countries WHERE code = 'ISR'), 'Série de conflits et tensions entre Israël et les pays arabes voisins.', 'Series of conflicts and tensions between Israel and neighboring Arab countries.'),
('Guerre de Corée', 'Korean War', '1950-06-25', '1953-07-27', (SELECT id FROM countries WHERE code = 'KOR'), 'Conflit entre la Corée du Nord (soutenue par la Chine et l''URSS) et la Corée du Sud (soutenue par les États-Unis et l''ONU).', 'Conflict between North Korea (backed by China and the USSR) and South Korea (backed by the United States and the UN).'),
('Guerre des Malouines', 'Falklands War', '1982-04-02', '1982-06-14', (SELECT id FROM countries WHERE code = 'FLK'), 'Conflit entre l''Argentine et le Royaume-Uni pour le contrôle des îles Malouines.', 'Conflict between Argentina and the United Kingdom for control of the Falkland Islands.'),
('Guerre civile syrienne', 'Syrian Civil War', '2011-03-15', NULL, (SELECT id FROM countries WHERE code = 'SYR'), 'Conflit complexe en Syrie impliquant le gouvernement syrien, des rebelles, et des forces internationales.', 'Complex conflict in Syria involving the Syrian government, rebels, and international forces.'),
('Guerre du Liban', 'Lebanon War', '1982-06-06', '1982-09-30', (SELECT id FROM countries WHERE code = 'LBN'), 'Conflit entre Israël et des factions libanaises et palestiniennes.', 'Conflict between Israel and Lebanese and Palestinian factions.'),
('Guerre d''Indochine', 'First Indochina War', '1946-12-19', '1954-07-20', (SELECT id FROM countries WHERE code = 'VNM'), 'Conflit entre la France et le Viet Minh pour le contrôle de l''Indochine.', 'Conflict between France and the Viet Minh for control of Indochina.'),
('Guerre Indo-Pakistanaise de 1971', 'Indo-Pakistani War of 1971', '1971-12-03', '1971-12-16', (SELECT id FROM countries WHERE code = 'IND'), 'Conflit entre l''Inde et le Pakistan entraînant la création du Bangladesh.', 'Conflict between India and Pakistan leading to the creation of Bangladesh.'),
('Guerre d''Algérie', 'Algerian War', '1954-11-01', '1962-03-19', (SELECT id FROM countries WHERE code = 'DZA'), 'Conflit entre la France et le Front de libération nationale (FLN) pour l''indépendance de l''Algérie.', 'Conflict between France and the National Liberation Front (FLN) for Algerian independence.');

-- Insertion des missions
INSERT INTO missions (name, name_en, description, description_en) VALUES
('Supériorité aérienne', NULL, 'Contrôle de l’espace aérien par l’élimination des menaces ennemies.', NULL),
('Interception', 'Interception', 'Engagement rapide d’avions ennemis pour protéger l’espace aérien.', 'Rapid engagement of enemy aircraft to protect airspace.'),
('Frappe stratégique', 'Strategic Strike', 'Attaques de précision sur des cibles stratégiques à longue portée.', 'Precision attacks on long-range strategic targets.'),
('Frappe tactique', 'Tactical Strike', 'Attaques ciblées sur des objectifs militaires au sol pour soutenir les opérations immédiates.', 'Targeted attacks on ground military objectives to support immediate operations.'),
('Appui aérien rapproché', 'Close Air Support', 'Soutien direct aux troupes au sol avec des frappes précises.', 'Direct support to ground troops with precision strikes.'),
('Reconnaissance armée', 'Armed Reconnaissance', 'Surveillance avec capacité d’engagement en cas de menace détectée.', 'Surveillance with engagement capability if threats are detected.'),
('Reconnaissance stratégique', 'Strategic Reconnaissance', 'Collecte d’informations sur des zones ou cibles éloignées sans engagement.', 'Intelligence gathering on distant zones or targets without engagement.'),
('Guerre électronique', 'Electronic Warfare', 'Perturbation des systèmes ennemis via brouillage ou attaques électroniques.', 'Disruption of enemy systems via jamming or electronic attacks.'),
('Patrouille aérienne de combat', 'Combat Air Patrol', 'Surveillance prolongée et défense proactive de l’espace aérien.', 'Prolonged surveillance and proactive airspace defense.'),
('Attaque antinavire', 'Anti-ship Attack', 'Engagement de navires ennemis avec des missiles ou des bombes spécialisées.', 'Engagement of enemy ships with specialized missiles or bombs.'),
('Suppression des défenses aériennes ennemies', 'Suppression of Enemy Air Defenses', 'Destruction ou neutralisation des systèmes antiaériens ennemis.', 'Destruction or neutralization of enemy anti-aircraft systems.'),
('Largage de secours', 'Supply Drop', 'Livraison de matériel ou de provisions dans des zones difficiles d’accès.', 'Delivery of equipment or supplies to hard-to-reach areas.'),
('Escorte', 'Escort', 'Protection d’autres aéronefs (bombardiers, transports) contre les menaces aériennes.', 'Protection of other aircraft (bombers, transports) against air threats.'),
('Entraînement au combat', 'Combat Training', 'Simulation de missions pour préparer les pilotes au combat réel.', 'Mission simulation to prepare pilots for real combat.'),
('Dissuasion nucléaire', 'Nuclear Deterrence', 'Transport et éventuel largage d’armes nucléaires pour des missions stratégiques.', 'Carriage and potential release of nuclear weapons for strategic missions.');

INSERT INTO manufacturer (name, name_en, country_id, code) VALUES
('Lockheed Martin', 'Lockheed Martin', (SELECT id FROM countries WHERE code = 'USA'), 'LM'),
('Boeing', 'Boeing', (SELECT id FROM countries WHERE code = 'USA'), 'BOE'),
('Sukhoi', 'Sukhoi', (SELECT id FROM countries WHERE code = 'RUS'), 'SUK'),
('Mikoyan (MiG)', 'Mikoyan (MiG)', (SELECT id FROM countries WHERE code = 'RUS'), 'MIG'),
('Tupolev', 'Tupolev', (SELECT id FROM countries WHERE code = 'RUS'), 'TUP'),
('Chengdu Aerospace Corporation', 'Chengdu Aerospace Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'CAC'),
('Shenyang Aircraft Corporation', 'Shenyang Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'SAC'),
('Dassault Aviation', 'Dassault Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'DAS'),
('BAE Systems', 'BAE Systems', (SELECT id FROM countries WHERE code = 'GBR'), 'BAE'),
('Airbus Defence and Space', 'Airbus Defence and Space', (SELECT id FROM countries WHERE code = 'DEU'), 'ADS'),
('Leonardo S.p.A.', 'Leonardo S.p.A.', (SELECT id FROM countries WHERE code = 'ITA'), 'LEO'),
('Saab AB', 'Saab AB', (SELECT id FROM countries WHERE code = 'SWE'), 'SAAB'),
('HAL (Hindustan Aeronautics Limited)', 'HAL (Hindustan Aeronautics Limited)', (SELECT id FROM countries WHERE code = 'IND'), 'HAL'),
('Mitsubishi Heavy Industries', 'Mitsubishi Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'MHI'),
('Embraer', 'Embraer', (SELECT id FROM countries WHERE code = 'BRA'), 'EMB'),
('IAI (Israel Aerospace Industries)', 'IAI (Israel Aerospace Industries)', (SELECT id FROM countries WHERE code = 'ISR'), 'IAI');

INSERT INTO generation (generation, description, description_en) VALUES
(1, 'Première génération : Avions à réaction subsoniques des années 1940-1950', NULL),
(2, 'Deuxième génération : Améliorations de l’aérodynamique et de l’armement dans les années 1950-1960', 'Second generation: Improved aerodynamics and armament in the 1950s–1960s'),
(3, 'Troisième génération : Introduction des missiles guidés et meilleure maniabilité dans les années 1960-1970', 'Third generation: Introduction of guided missiles and improved maneuverability in the 1960s–1970s'),
(4, 'Quatrième génération : Hautes performances, systèmes fly-by-wire et radars avancés des années 1970-1990', 'Fourth generation: High performance, fly-by-wire systems and advanced radars from the 1970s–1990s'),
(5, 'Cinquième génération : Technologie furtive, supercroisière et fusion de capteurs depuis les années 2000', 'Fifth generation: Stealth technology, supercruise and sensor fusion since the 2000s');

INSERT INTO type (name, name_en, description, description_en) VALUES
('Chasseur', 'Fighter', 'Avion de combat conçu pour la supériorité aérienne', 'Combat aircraft designed for air superiority'),
('Bombardier', 'Bomber', 'Avion militaire destiné à attaquer des cibles au sol', 'Military aircraft designed to attack ground targets'),
('Reconnaissance', 'Reconnaissance', 'Avion utilisé pour la surveillance et la collecte d’informations', 'Aircraft used for surveillance and intelligence gathering'),
('Intercepteur', 'Interceptor', 'Avion rapide conçu pour intercepter et neutraliser les menaces aériennes', 'Fast aircraft designed to intercept and neutralize airborne threats'),
('Multirôle', 'Multirole', 'Avion capable d’effectuer plusieurs types de missions', 'Aircraft capable of performing multiple mission types'),
('Appui aérien', 'Close Air Support', 'Avion conçu pour soutenir les troupes au sol avec des frappes ciblées', 'Aircraft designed to support ground troops with precision strikes');

INSERT INTO armement (name, name_en, description, description_en) VALUES
('DEFA 552', NULL, 'Canon de 30 mm, 125 coups par canon', '30 mm cannon, 125 rounds per gun'),
('DEFA 553', NULL, 'Canon de 30 mm, 135-150 coups par canon', '30 mm cannon, 135-150 rounds per gun'),
('DEFA 554', NULL, 'Canon de 30 mm amélioré, 125 coups par canon', 'Improved 30 mm cannon, 125 rounds per gun'),
('GIAT 30M791', NULL, 'Canon de 30 mm, 125 coups', '30 mm cannon, 125 rounds'),
('Colt Mk 12', NULL, 'Canon de 20 mm, 125 coups par canon', '20 mm cannon, 125 rounds per gun'),
('M61 Vulcan', NULL, 'Canon rotatif 20 mm, 6000 coups/min', '20 mm rotary cannon, 6000 rounds/min'),
('GAU-8 Avenger', NULL, 'Canon rotatif 30 mm, 3900 coups/min', '30 mm rotary cannon, 3900 rounds/min'),
('GSh-23', NULL, 'Canon double de 23 mm, 3400 coups/min', '23 mm twin cannon, 3400 rounds/min'),
('GSh-30-1', NULL, 'Canon de 30 mm, 1500 coups/min', '30 mm cannon, 1500 rounds/min'),
('GSh-30-2', NULL, 'Canon double de 30 mm, 3000 coups/min', '30 mm twin cannon, 3000 rounds/min'),
('NR-30', NULL, 'Canon de 30 mm, 850 coups/min', '30 mm cannon, 850 rounds/min'),
('GSh-6-23', NULL, 'Canon rotatif 23 mm, 6000 coups/min', '23 mm rotary cannon, 6000 rounds/min'),
('ADEN 30 mm', NULL, 'Canon de 30 mm, 1300 coups/min', '30 mm cannon, 1300 rounds/min'),
('GAU-12 Equalizer', NULL, 'Canon rotatif 25 mm, 3600 coups/min', '25 mm rotary cannon, 3600 rounds/min'),
('Mauser BK-27', NULL, 'Canon de 27 mm, 1700 coups/min', '27 mm cannon, 1700 rounds/min'),
('JM61A1', NULL, 'Variante japonaise du M61 Vulcan', 'Japanese variant of the M61 Vulcan'),
('M39', NULL, 'Canon de 20 mm', '20 mm cannon'),
('Matra R530', NULL, 'Missile moyenne portée, guidage radar semi-actif ou infrarouge', 'Medium-range missile, semi-active radar or infrared guidance'),
('Matra R550 Magic', NULL, 'Missile courte portée, guidage infrarouge', 'Short-range missile, infrared guidance'),
('Matra Super 530F', NULL, 'Missile moyenne portée, guidage radar semi-actif', 'Medium-range missile, semi-active radar guidance'),
('Matra Super 530D', NULL, 'Missile moyenne portée, guidage radar semi-actif', 'Medium-range missile, semi-active radar guidance'),
('MICA IR', NULL, 'Missile air-air à guidage infrarouge, portée 80 km', 'Infrared-guided air-to-air missile, 80 km range'),
('MICA EM', NULL, 'Missile air-air à guidage radar actif, portée 80 km', 'Active radar-guided air-to-air missile, 80 km range'),
('Meteor', NULL, 'Missile air-air longue portée, guidage radar actif, 100-150 km', 'Long-range air-to-air missile, active radar guidance, 100-150 km'),
('AIM-9 Sidewinder', NULL, 'Missile air-air courte portée, guidage infrarouge, 18 km', 'Short-range air-to-air missile, infrared guidance, 18 km'),
('AIM-7 Sparrow', NULL, 'Missile moyenne portée, guidage radar semi-actif, 70 km', 'Medium-range missile, semi-active radar guidance, 70 km'),
('AIM-54 Phoenix', NULL, 'Missile longue portée, guidage radar actif, 190 km', 'Long-range missile, active radar guidance, 190 km'),
('AIM-120 AMRAAM', NULL, 'Missile moyenne/longue portée, guidage radar actif, 120 km', 'Medium/long-range missile, active radar guidance, 120 km'),
('R-3S', NULL, 'Missile courte portée, guidage infrarouge, 8 km', 'Short-range missile, infrared guidance, 8 km'),
('R-13M', NULL, 'Missile courte portée, guidage infrarouge, 15 km', 'Short-range missile, infrared guidance, 15 km'),
('R-23R', NULL, 'Missile moyenne portée, guidage radar semi-actif, 35 km', 'Medium-range missile, semi-active radar guidance, 35 km'),
('R-23T', NULL, 'Missile moyenne portée, guidage infrarouge, 35 km', 'Medium-range missile, infrared guidance, 35 km'),
('R-24R', NULL, 'Missile moyenne portée, guidage radar semi-actif, 50 km', 'Medium-range missile, semi-active radar guidance, 50 km'),
('R-24T', NULL, 'Missile moyenne portée, guidage infrarouge, 50 km', 'Medium-range missile, infrared guidance, 50 km'),
('R-27R', NULL, 'Missile moyenne portée, guidage radar semi-actif, 80 km', 'Medium-range missile, semi-active radar guidance, 80 km'),
('R-27T', NULL, 'Missile moyenne portée, guidage infrarouge, 70 km', 'Medium-range missile, infrared guidance, 70 km'),
('R-33', NULL, 'Missile longue portée, guidage radar semi-actif, 120 km', 'Long-range missile, semi-active radar guidance, 120 km'),
('R-37', NULL, 'Missile très longue portée, guidage radar actif, 300 km', 'Very long-range missile, active radar guidance, 300 km'),
('R-40R', NULL, 'Missile longue portée, guidage radar semi-actif, 80 km', 'Long-range missile, semi-active radar guidance, 80 km'),
('R-40T', NULL, 'Missile longue portée, guidage infrarouge, 80 km', 'Long-range missile, infrared guidance, 80 km'),
('R-60', NULL, 'Missile courte portée, guidage infrarouge, 8 km', 'Short-range missile, infrared guidance, 8 km'),
('R-73', NULL, 'Missile courte portée, guidage infrarouge, 30 km', 'Short-range missile, infrared guidance, 30 km'),
('R-77', NULL, 'Missile moyenne/longue portée, guidage radar actif, 110 km', 'Medium/long-range missile, active radar guidance, 110 km'),
('Firestreak', NULL, 'Missile courte portée, guidage infrarouge, 15 km', 'Short-range missile, infrared guidance, 15 km'),
('Red Top', NULL, 'Missile courte portée, guidage infrarouge, 12 km', 'Short-range missile, infrared guidance, 12 km'),
('Skyflash', NULL, 'Missile moyenne portée, guidage radar semi-actif, 45 km', 'Medium-range missile, semi-active radar guidance, 45 km'),
('ASRAAM', NULL, 'Missile courte portée, guidage infrarouge, 50 km', 'Short-range missile, infrared guidance, 50 km'),
('Python 3', NULL, 'Missile courte portée, guidage infrarouge, 15 km', 'Short-range missile, infrared guidance, 15 km'),
('Python 4', NULL, 'Missile courte portée, guidage infrarouge, 20 km', 'Short-range missile, infrared guidance, 20 km'),
('Python 5', NULL, 'Missile courte portée, guidage infrarouge, 20 km, haute manœuvrabilité', 'Short-range missile, infrared guidance, 20 km, high maneuverability'),
('Derby', NULL, 'Missile moyenne portée, guidage radar actif, 50 km', 'Medium-range missile, active radar guidance, 50 km'),
('AAM-3', NULL, 'Missile courte portée, guidage infrarouge', 'Short-range missile, infrared guidance'),
('AAM-4', NULL, 'Missile moyenne/longue portée, guidage radar actif', 'Medium/long-range missile, active radar guidance'),
('AAM-5', NULL, 'Missile courte portée, guidage infrarouge', 'Short-range missile, infrared guidance'),
('IRIS-T', NULL, 'Missile courte portée, guidage infrarouge, 25 km', 'Short-range missile, infrared guidance, 25 km'),
('PL-2', NULL, 'Missile air-air courte portée, guidage infrarouge, 8 km', 'Short-range air-to-air missile, infrared guidance, 8 km'),
('PL-5', NULL, 'Missile air-air courte portée, guidage infrarouge, 16-20 km', 'Short-range air-to-air missile, infrared guidance, 16-20 km'),
('PL-8', NULL, 'Missile air-air courte portée, guidage infrarouge, 20 km', 'Short-range air-to-air missile, infrared guidance, 20 km'),
('PL-12', NULL, 'Missile air-air moyenne/longue portée, guidage radar actif, 70-100 km', 'Medium/long-range air-to-air missile, active radar guidance, 70-100 km'),
('AS-30', NULL, 'Missile air-sol, guidage radio', 'Air-to-surface missile, radio guidance'),
('AS-30L', NULL, 'Missile air-sol, guidage laser, portée 11 km', 'Air-to-surface missile, laser guidance, 11 km range'),
('AS-37 Martel', NULL, 'Missile air-sol anti-radar ou guidage TV, portée 60 km', 'Anti-radar or TV-guided air-to-surface missile, 60 km range'),
('Apache', NULL, 'Missile de croisière anti-piste, portée 140 km', 'Anti-runway cruise missile, 140 km range'),
('SCALP EG', NULL, 'Missile de croisière, portée 500 km', 'Cruise missile, 500 km range'),
('AGM-65 Maverick', NULL, 'Missile air-sol à guidage optique/TV, portée 27 km', 'Optical/TV-guided air-to-surface missile, 27 km range'),
('AASM Hammer', NULL, 'Bombe guidée avec kit de propulsion, portée 70 km', 'Guided bomb with propulsion kit, 70 km range'),
('AS-20', NULL, 'Missile air-sol, guidage radio, portée 7 km', 'Air-to-surface missile, radio guidance, 7 km range'),
('AGM-12 Bullpup', NULL, 'Missile air-sol, guidage radio, 10 km', 'Air-to-surface missile, radio guidance, 10 km'),
('AGM-45 Shrike', NULL, 'Missile anti-radar, portée 40 km', 'Anti-radar missile, 40 km range'),
('AGM-78 Standard ARM', NULL, 'Missile anti-radar, portée 90 km', 'Anti-radar missile, 90 km range'),
('AGM-84 Harpoon', NULL, 'Missile antinavire, portée 124 km', 'Anti-ship missile, 124 km range'),
('AGM-86 ALCM', NULL, 'Missile de croisière à lancement aérien, portée 2400 km', 'Air-launched cruise missile, 2400 km range'),
('AGM-88 HARM', NULL, 'Missile anti-radar, portée 150 km', 'Anti-radar missile, 150 km range'),
('AGM-114 Hellfire', NULL, 'Missile air-sol, guidage laser, 8 km', 'Air-to-surface missile, laser guidance, 8 km'),
('AGM-130', NULL, 'Missile air-sol guidé, portée 64 km', 'Guided air-to-surface missile, 64 km range'),
('AGM-154 JSOW', NULL, 'Arme stand-off, guidage GPS/INS, 130 km', 'Stand-off weapon, GPS/INS guidance, 130 km'),
('AGM-158 JASSM', NULL, 'Missile de croisière furtif, portée 370-1000 km', 'Stealth cruise missile, 370-1000 km range'),
('Kh-23', NULL, 'Missile air-sol, guidage radio, 10 km', 'Air-to-surface missile, radio guidance, 10 km'),
('Kh-25ML', NULL, 'Missile air-sol, guidage laser, 20 km', 'Air-to-surface missile, laser guidance, 20 km'),
('Kh-29L', NULL, 'Missile air-sol, guidage laser, 30 km', 'Air-to-surface missile, laser guidance, 30 km'),
('Kh-29T', NULL, 'Missile air-sol, guidage TV, 30 km', 'Air-to-surface missile, TV guidance, 30 km'),
('Kh-31P', NULL, 'Missile anti-radar, portée 110 km', 'Anti-radar missile, 110 km range'),
('Kh-31A', NULL, 'Missile antinavire, portée 110 km', 'Anti-ship missile, 110 km range'),
('Kh-35', NULL, 'Missile antinavire, portée 130 km', 'Anti-ship missile, 130 km range'),
('Kh-58', NULL, 'Missile anti-radar, portée 120 km', 'Anti-radar missile, 120 km range'),
('Kh-59', NULL, 'Missile air-sol, guidage TV, 115 km', 'Air-to-surface missile, TV guidance, 115 km'),
('Kh-66', NULL, 'Missile air-sol, guidage radio, 10 km', 'Air-to-surface missile, radio guidance, 10 km'),
('S-25L', NULL, 'Roquette guidée laser, 340 mm', '340 mm laser-guided rocket'),
('Martel AJ-168', NULL, 'Missile air-sol, guidage TV, 60 km', 'Air-to-surface missile, TV guidance, 60 km'),
('Martel AS-37', NULL, 'Missile anti-radar, portée 60 km', 'Anti-radar missile, 60 km range'),
('Brimstone', NULL, 'Missile air-sol, guidage radar/laser, 60 km', 'Air-to-surface missile, radar/laser guidance, 60 km'),
('Storm Shadow', NULL, 'Missile de croisière, portée 560 km', 'Cruise missile, 560 km range'),
('MAR-1', NULL, 'Missile anti-radar, portée 60 km', 'Anti-radar missile, 60 km range'),
('Popeye', NULL, 'Missile air-sol, guidage TV, portée 78 km', 'Air-to-surface missile, TV guidance, 78 km range'),
('Spice', NULL, 'Bombe guidée avec kit de propulsion, portée 60-100 km', 'Guided bomb with propulsion kit, 60-100 km range'),
('AM39 Exocet', NULL, 'Missile antinavire, portée 70 km', 'Anti-ship missile, 70 km range'),
('Sea Eagle', NULL, 'Missile antinavire, portée 110 km', 'Anti-ship missile, 110 km range'),
('Sea Skua', NULL, 'Missile antinavire léger, portée 25 km', 'Light anti-ship missile, 25 km range'),
('Gabriel', NULL, 'Missile antinavire, portée 36 km', 'Anti-ship missile, 36 km range'),
('ASM-1', NULL, 'Missile antinavire, guidage radar actif, portée 50 km', 'Anti-ship missile, active radar guidance, 50 km range'),
('ASM-2', NULL, 'Missile antinavire, guidage radar actif, portée 100 km', 'Anti-ship missile, active radar guidance, 100 km range'),
('Marte Mk2A', NULL, 'Missile antinavire, portée 30 km', 'Anti-ship missile, 30 km range'),
('Kh-32', NULL, 'Missile antinavire supersonique, portée 600-1000 km', 'Supersonic anti-ship missile, 600-1000 km range'),
('Kh-35U', NULL, 'Missile antinavire subsonique, portée 260 km', 'Subsonic anti-ship missile, 260 km range'),
('Kh-20', NULL, 'Missile de croisière nucléaire, portée 600 km', 'Nuclear cruise missile, 600 km range'),
('Kh-22', NULL, 'Missile antinavire supersonique, portée 600 km', 'Supersonic anti-ship missile, 600 km range'),
('Kh-55', NULL, 'Missile de croisière subsonique, portée 2500 km', 'Subsonic cruise missile, 2500 km range'),
('Kh-65', NULL, 'Missile de croisière conventionnel, portée 500 km', 'Conventional cruise missile, 500 km range'),
('Kh-101', NULL, 'Missile de croisière furtif conventionnel, portée 4500-5500 km', 'Conventional stealth cruise missile, 4500-5500 km range'),
('Kh-102', NULL, 'Missile de croisière furtif nucléaire, portée 4500-5500 km', 'Nuclear stealth cruise missile, 4500-5500 km range'),
('Kh-555', NULL, 'Missile de croisière conventionnel, portée 2500 km', 'Conventional cruise missile, 2500 km range'),
('AN-11', NULL, 'Bombe nucléaire à chute libre', 'Free-fall nuclear bomb'),
('AN-22', NULL, 'Bombe nucléaire à chute libre', 'Free-fall nuclear bomb'),
('AGM-69 SRAM', NULL, 'Missile nucléaire à courte portée, portée 170 km', 'Short-range nuclear missile, 170 km range'),
('ASMP', NULL, 'Missile nucléaire, portée 300 km', 'Nuclear missile, 300 km range'),
('ASMP-A', NULL, 'Missile nucléaire amélioré, portée 500 km', 'Improved nuclear missile, 500 km range'),
('B28', NULL, 'Bombe nucléaire à chute libre, 1.45 Mt', 'Free-fall nuclear bomb, 1.45 Mt'),
('B43', NULL, 'Bombe nucléaire à chute libre, 1 Mt', 'Free-fall nuclear bomb, 1 Mt'),
('B61', NULL, 'Bombe nucléaire tactique, rendement variable', 'Tactical nuclear bomb, variable yield'),
('B83', NULL, 'Bombe nucléaire stratégique, 1.2 Mt', 'Strategic nuclear bomb, 1.2 Mt'),
('WE.177', NULL, 'Bombe nucléaire à chute libre, 10-400 kt', 'Free-fall nuclear bomb, 10-400 kt'),
('RN-28', NULL, 'Bombe nucléaire tactique à chute libre', 'Tactical free-fall nuclear bomb'),
('TN-1000', NULL, 'Bombe nucléaire à chute libre, 1 Mt', 'Free-fall nuclear bomb, 1 Mt'),
('RN-40', NULL, 'Bombe nucléaire à chute libre', 'Free-fall nuclear bomb'),
('Kh-47M2 Kinzhal', NULL, 'Missile balistique hypersonique, portée 2000 km', 'Hypersonic ballistic missile, 2000 km range'),
('Bombe lisse 250 kg', NULL, 'Bombe conventionnelle non guidée, 250 kg', 'Unguided conventional bomb, 250 kg'),
('Bombe lisse 400 kg', NULL, 'Bombe conventionnelle non guidée, 400 kg', 'Unguided conventional bomb, 400 kg'),
('Bombe lisse 500 kg', NULL, 'Bombe conventionnelle non guidée, 500 kg', 'Unguided conventional bomb, 500 kg'),
('Bombe lisse 1000 kg', NULL, 'Bombe conventionnelle non guidée, 1000 kg', 'Unguided conventional bomb, 1000 kg'),
('GBU-12 Paveway II', NULL, 'Bombe guidée laser, 224 kg', 'Laser-guided bomb, 224 kg'),
('GBU-24 Paveway III', NULL, 'Bombe guidée laser, portée accrue', 'Laser-guided bomb, extended range'),
('BL755', NULL, 'Bombe à sous-munitions', 'Cluster bomb'),
('JDAM', NULL, 'Kit de guidage GPS pour bombes, portée 24 km', 'GPS guidance kit for bombs, 24 km range'),
('Mk 82', NULL, 'Bombe lisse 227 kg', '227 kg unguided bomb'),
('Mk 83', NULL, 'Bombe lisse 454 kg', '454 kg unguided bomb'),
('Mk 84', NULL, 'Bombe lisse 907 kg', '907 kg unguided bomb'),
('GBU-10 Paveway II', NULL, 'Bombe guidée laser, 907 kg', 'Laser-guided bomb, 907 kg'),
('GBU-16 Paveway II', NULL, 'Bombe guidée laser, 454 kg', 'Laser-guided bomb, 454 kg'),
('GBU-27 Paveway III', NULL, 'Bombe guidée laser furtive, 907 kg', 'Stealth laser-guided bomb, 907 kg'),
('GBU-31 JDAM', NULL, 'Bombe guidée GPS, 907 kg', 'GPS-guided bomb, 907 kg'),
('GBU-32 JDAM', NULL, 'Bombe guidée GPS, 454 kg', 'GPS-guided bomb, 454 kg'),
('GBU-38 JDAM', NULL, 'Bombe guidée GPS, 227 kg', 'GPS-guided bomb, 227 kg'),
('GBU-39 SDB', NULL, 'Petite bombe guidée, 113 kg', 'Small guided bomb, 113 kg'),
('CBU-87', NULL, 'Bombe à sous-munitions, 430 kg', 'Cluster bomb, 430 kg'),
('CBU-97', NULL, 'Bombe à sous-munitions avec capteurs, 430 kg', 'Sensor-fuzed cluster bomb, 430 kg'),
('FAB-250', NULL, 'Bombe lisse 250 kg', 'Unguided bomb, 250 kg'),
('FAB-500', NULL, 'Bombe lisse 500 kg', 'Unguided bomb, 500 kg'),
('FAB-1000', NULL, 'Bombe lisse 1000 kg', 'Unguided bomb, 1000 kg'),
('FAB-1500', NULL, 'Bombe lisse 1500 kg', 'Unguided bomb, 1500 kg'),
('KAB-500L', NULL, 'Bombe guidée laser, 500 kg', 'Laser-guided bomb, 500 kg'),
('KAB-1500L', NULL, 'Bombe guidée laser, 1500 kg', 'Laser-guided bomb, 1500 kg'),
('BetAB-500', NULL, 'Bombe anti-bunker, 500 kg', 'Anti-bunker bomb, 500 kg'),
('ODAB-500', NULL, 'Bombe thermobarique, 500 kg', 'Thermobaric bomb, 500 kg'),
('LT-2', NULL, 'Bombe guidée laser, 500 kg', 'Laser-guided bomb, 500 kg'),
('LS-6', NULL, 'Bombe guidée par GPS/glide, 500 kg', 'GPS/glide-guided bomb, 500 kg'),
('GBU-250', NULL, 'Bombe guidée chinoise, 250 kg', 'Chinese guided bomb, 250 kg'),
('Type 200A', NULL, 'Bombe anti-piste, 500 kg', 'Anti-runway bomb, 500 kg'),
('Paveway IV', NULL, 'Bombe guidée laser/GPS, 227 kg', 'Laser/GPS-guided bomb, 227 kg'),
('1000 lb GP', NULL, 'Bombe lisse 454 kg', '454 kg unguided bomb'),
('M/71 120 kg', NULL, 'Bombe lisse 120 kg', '120 kg unguided bomb'),
('M/71 500 kg', NULL, 'Bombe lisse 500 kg', '500 kg unguided bomb'),
('GBU-49', NULL, 'Bombe guidée laser/GPS, 227 kg', 'Laser/GPS-guided bomb, 227 kg'),
('OFAB-250', NULL, 'Bombe lisse 250 kg', 'Unguided bomb, 250 kg'),
('OFAB-500', NULL, 'Bombe lisse 500 kg', 'Unguided bomb, 500 kg'),
('FAB-3000', NULL, 'Bombe lisse conventionnelle, 3000 kg', 'Conventional unguided bomb, 3000 kg'),
('FAB-5000', NULL, 'Bombe lisse conventionnelle, 5000 kg', 'Conventional unguided bomb, 5000 kg'),
('BAP 100', NULL, 'Bombe anti-piste', 'Anti-runway bomb'),
('KAB-1500Kr', NULL, 'Bombe guidée TV, 1500 kg', 'TV-guided bomb, 1500 kg'),
('SNEB 68 mm', NULL, 'Roquettes non guidées, pod de 68 mm', 'Unguided rockets, 68 mm pod'),
('Zuni 127 mm', NULL, 'Roquettes non guidées, pod de 127 mm', 'Unguided rockets, 127 mm pod'),
('Hydra 70', NULL, 'Roquettes non guidées, 70 mm', 'Unguided rockets, 70 mm'),
('S-5', NULL, 'Roquettes non guidées, 57 mm', 'Unguided rockets, 57 mm'),
('S-8', NULL, 'Roquettes non guidées, 80 mm', 'Unguided rockets, 80 mm'),
('S-13', NULL, 'Roquettes non guidées, 122 mm', 'Unguided rockets, 122 mm'),
('S-24', NULL, 'Roquettes non guidées, 240 mm', 'Unguided rockets, 240 mm'),
('S-25', NULL, 'Roquettes non guidées, 340 mm', 'Unguided rockets, 340 mm'),
('CRV7', NULL, 'Roquettes non guidées, 70 mm', 'Unguided rockets, 70 mm'),
('Bofors 135 mm', NULL, 'Roquettes non guidées, 135 mm', 'Unguided rockets, 135 mm'),
('Type 90-1', NULL, 'Roquettes non guidées, 90 mm', 'Unguided rockets, 90 mm'),
('HF-16', NULL, 'Roquettes non guidées, 57 mm', 'Unguided rockets, 57 mm'),
('HVAR 70 mm', NULL, 'Roquettes non guidées, 70 mm', 'Unguided rockets, 70 mm'),
('APR-3', NULL, 'Torpille légère anti-sous-marine, guidage acoustique', 'Lightweight anti-submarine torpedo, acoustic guidance'),
('RGB-75', NULL, 'Bouée acoustique pour détection sous-marine', 'Acoustic sonobuoy for underwater detection'),
('Shafrir 2', NULL, 'Missile air-air courte portée israélien, guidage infrarouge, 5 km', 'Israeli short-range air-to-air missile, infrared guidance, 5 km'),
('Rampage', NULL, 'Missile air-sol supersonique stand-off israélien, portée 150 km', 'Israeli supersonic stand-off air-to-surface missile, 150 km range'),
('Delilah', NULL, 'Missile de croisière israélien air-sol/antinavire, portée 250 km', 'Israeli air-to-surface/anti-ship cruise missile, 250 km range'),
('Rb 04E', NULL, 'Missile antinavire suédois subsonique, portée 32 km', 'Swedish subsonic anti-ship missile, 32 km range'),
('Rb 05A', NULL, 'Missile air-sol suédois, guidage radio, portée 9 km', 'Swedish air-to-surface missile, radio guidance, 9 km range'),
('Rb 15F', NULL, 'Missile antinavire suédois turbo, portée 200 km', 'Swedish turbojet anti-ship missile, 200 km range'),
('Astra Mk1', NULL, 'Missile air-air BVR indien à guidage radar actif, portée 110 km', 'Indian BVR air-to-air missile with active radar guidance, 110 km range'),
('BrahMos-A', NULL, 'Missile de croisière supersonique indo-russe air-sol/antinavire, portée 450 km', 'Indo-Russian supersonic air-to-surface/anti-ship cruise missile, 450 km range'),
('ASM-3', NULL, 'Missile antinavire supersonique japonais, portée 200 km', 'Japanese supersonic anti-ship missile, 200 km range'),
('Popeye Turbo', NULL, 'Missile de croisière israélien à longue portée, 1500 km', 'Israeli long-range cruise missile, 1500 km range');

-- Technologies génériques réutilisables
INSERT INTO tech (name, name_en, description, description_en) VALUES
('Aile delta', 'Delta wing', 'Configuration aérodynamique sans empennage horizontal pour les hautes vitesses', 'Aerodynamic configuration without horizontal tail for high speeds'),
('Aile en flèche', 'Swept wing', 'Configuration aérodynamique pour les hautes vitesses', 'Aerodynamic configuration for high speeds'),
('Aile à géométrie variable', 'Variable-geometry wing', 'Aile avec des panneaux mobiles pour optimiser les performances à différentes vitesses', 'Wing with movable panels to optimize performance at different speeds'),
('Aile canard delta', 'Delta canard wing', 'Configuration aérodynamique combinant canards et aile delta', 'Aerodynamic configuration combining canards and delta wing'),
('Aile à forte flèche', 'Highly swept wing', 'Conception aérodynamique pour une grande maniabilité', 'Aerodynamic design for high maneuverability'),
('Aile droite à faible allongement', 'Low aspect ratio straight wing', 'Configuration aérodynamique pour les hautes vitesses', 'Aerodynamic configuration for high speeds'),
('Aile en flèche légère', 'Light swept wing', 'Conception légère pour une grande maniabilité', 'Lightweight design for high maneuverability'),
('Aile à incidence variable', 'Variable-incidence wing', 'Dispositif mécanique modifiant l''angle de l''aile en vol', 'Mechanical device modifying the wing angle in flight'),
('Aile delta-canard', 'Delta-canard wing', 'Configuration aérodynamique combinant canards et aile delta', 'Aerodynamic configuration combining canards and delta wing'),
('Aile en flèche avec canards', 'Swept wing with canards', 'Configuration aérodynamique combinant canards et aile en flèche pour une grande maniabilité', 'Aerodynamic configuration combining canards and swept wing for high maneuverability'),
('Configuration aérodynamique en double delta', 'Double-delta aerodynamic configuration', 'Combinaison de deux ailes delta pour une grande maniabilité et des performances à haute vitesse', 'Combination of two delta wings for high maneuverability and high-speed performance'),
('Réacteur à postcombustion', 'Afterburning jet engine', 'Moteur SNECMA Atar permettant des performances supersoniques', 'SNECMA Atar engine enabling supersonic performance'),
('Réacteur Tumansky R-25', 'Tumansky R-25 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur General Electric J79', 'General Electric J79 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Moteurs à poussée vectorielle', 'Thrust-vectoring engines', 'Moteurs permettant une grande maniabilité', 'Engines providing high maneuverability'),
('Moteurs à turbofan', 'Turbofan engines', 'Moteurs modernes pour améliorer l''efficacité et la portée', 'Modern engines to improve efficiency and range'),
('Moteur à poussée vectorielle', 'Thrust-vectoring engine', 'Moteur Rolls-Royce Pegasus permettant le décollage et l''atterrissage vertical (VTOL)', 'Rolls-Royce Pegasus engine enabling vertical take-off and landing (VTOL)'),
('Réacteur Klimov VK-1', 'Klimov VK-1 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur Tumansky R-9', 'Tumansky R-9 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur WP-7', 'WP-7 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur WP-13', 'WP-13 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur AL-31FN', 'AL-31FN engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur WS-10', 'WS-10 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur RD-93', 'RD-93 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur Rolls-Royce Avon', 'Rolls-Royce Avon engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur Volvo RM8', 'Volvo RM8 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur Volvo RM12', 'Volvo RM12 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur Rolls-Royce Orpheus', 'Rolls-Royce Orpheus engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'),
('Réacteur General Electric F404', 'General Electric F404 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur Rolls-Royce/Turbomeca Adour', 'Rolls-Royce/Turbomeca Adour engine', 'Moteur à double flux pour des performances subsoniques', 'Bypass engine for subsonic performance'),
('Réacteur Kuznetsov NK-12', 'Kuznetsov NK-12 engine', 'Moteur à turbopropulseur pour une grande autonomie', 'Turboprop engine for long range'),
('Réacteur Ishikawajima-Harima F3-IHI-30', 'Ishikawajima-Harima F3-IHI-30 engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'),
('Réacteur Larzac 04', 'Larzac 04 engine', 'Moteur à double flux pour des performances subsoniques', 'Bypass engine for subsonic performance'),
('Réacteur Rolls-Royce Viper', 'Rolls-Royce Viper engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'),
('Réacteur Rolls-Royce Spey', 'Rolls-Royce Spey engine', 'Moteur à turboréacteur pour des performances subsoniques', 'Turbojet engine for subsonic performance'),
('Réacteur Honeywell TFE731', 'Honeywell TFE731 engine', 'Moteur à turbofan pour des performances subsoniques', 'Turbofan engine for subsonic performance'),
('Moteurs Tumansky R-15', 'Tumansky R-15 engines', 'Moteurs à postcombustion pour des vitesses supérieures à Mach 3', 'Afterburning engines for speeds above Mach 3'),
('Moteurs D-30F6', 'D-30F6 engines', 'Moteurs à postcombustion pour des performances supersoniques', 'Afterburning engines for supersonic performance'),
('Moteurs Tumansky R-11', 'Tumansky R-11 engines', 'Moteurs à postcombustion pour des performances supersoniques', 'Afterburning engines for supersonic performance'),
('Moteurs à turbopropulseurs', 'Turboprop engines', 'Moteurs à hélices contrarotatives pour une grande autonomie', 'Contra-rotating propeller engines for long range'),
('Réacteur AL-31F', 'AL-31F engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Réacteur WP-6', 'WP-6 engine', 'Moteur à postcombustion pour des performances supersoniques', 'Afterburning engine for supersonic performance'),
('Radar Cyrano', 'Cyrano radar', 'Radar monopulse Cyrano I/II pour interception et tir air-air', 'Cyrano I/II monopulse radar for interception and air-to-air firing'),
('Radar Cyrano IV', 'Cyrano IV radar', 'Radar multimode amélioré avec capacité de cartographie terrain', 'Improved multi-mode radar with terrain mapping capability'),
('Radar RDM/RDI', 'RDM/RDI radar', 'Radar Doppler multi-mode pour détection air-air/air-sol', 'Multi-mode Doppler radar for air-to-air/air-to-ground detection'),
('Radar RBE2 AESA', 'RBE2 AESA radar', 'Premier radar à antenne active européenne en service', 'First European active-array radar in service'),
('Radar AN/APQ-120', 'AN/APQ-120 radar', 'Radar de tir et de navigation multifonction', 'Multifunction fire-control and navigation radar'),
('Radar AN/ASG-14', 'AN/ASG-14 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar AN/APG-63', 'AN/APG-63 radar', 'Radar Doppler à impulsions pour détection longue portée', 'Pulse-Doppler radar for long-range detection'),
('Radar AN/APG-68', 'AN/APG-68 radar', 'Radar Doppler multi-mode pour détection air-air/air-sol', 'Multi-mode Doppler radar for air-to-air/air-to-ground detection'),
('Radar AN/APG-77', 'AN/APG-77 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'),
('Radar AN/APG-81', 'AN/APG-81 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'),
('Radar RP-21', 'RP-21 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar RP-23', 'RP-23 radar', 'Radar de tir et de navigation multifonction', 'Multifunction fire-control and navigation radar'),
('Radar RP-25', 'RP-25 radar', 'Radar à longue portée pour interception à haute altitude', 'Long-range radar for high-altitude interception'),
('Radar N019', 'N019 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'),
('Radar Zaslon', 'Zaslon radar', 'Radar à balayage électronique passif (PESA) pour détection longue portée', 'Passive electronically scanned array (PESA) for long-range detection'),
('Radar RP-15', 'RP-15 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar Klen', 'Klen radar', 'Radar de tir et de navigation pour attaque au sol', 'Fire-control and navigation radar for ground attack'),
('Radar Puma', 'Puma radar', 'Radar de suivi de terrain pour vol à basse altitude', 'Terrain-following radar for low-altitude flight'),
('Radar N001', 'N001 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'),
('Radar N011M Bars', 'N011M Bars radar', 'Radar à balayage électronique passif (PESA) pour détection longue portée', 'Passive electronically scanned array (PESA) for long-range detection'),
('Radar V004', 'V004 radar', 'Radar à balayage électronique passif (PESA) pour détection air-air/air-sol', 'Passive electronically scanned array (PESA) for air-to-air/air-to-ground detection'),
('Radar Irbis-E', 'Irbis-E radar', 'Radar à balayage électronique passif (PESA) pour détection longue portée', 'Passive electronically scanned array (PESA) for long-range detection'),
('Radar N036', 'N036 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'),
('Radar PN-AD', 'PN-AD radar', 'Radar de navigation et d''attaque pour missions de bombardement', 'Navigation and attack radar for bombing missions'),
('Radar Obzor-K', 'Obzor-K radar', 'Radar de navigation et d''attaque pour missions de bombardement', 'Navigation and attack radar for bombing missions'),
('Radar RP-9', 'RP-9 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar Type 226', 'Type 226 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar Type 1471', 'Type 1471 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar Type 1473', 'Type 1473 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'),
('Radar AESA', 'AESA radar', 'Radar à antenne active pour détection longue portée', 'Active-array radar for long-range detection'),
('Radar KLJ-7', 'KLJ-7 radar', 'Radar Doppler pour détection air-air et air-sol', 'Doppler radar for air-to-air and air-to-ground detection'),
('Radar AI.23', 'AI.23 radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar Blue Fox', 'Blue Fox radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar CAPTOR', 'CAPTOR radar', 'Radar à balayage électronique mécanique pour détection air-air et air-sol', 'Mechanically scanned array radar for air-to-air and air-to-ground detection'),
('Radar Blue Parrot', 'Blue Parrot radar', 'Radar de suivi de terrain pour missions de bombardement', 'Terrain-following radar for bombing missions'),
('Radar H2S', 'H2S radar', 'Radar de navigation et de bombardement pour missions stratégiques', 'Navigation and bombing radar for strategic missions'),
('Radar R21G/M1', 'R21G/M1 radar', 'Radar de tir et de navigation amélioré pour interception', 'Improved fire-control and navigation radar for interception'),
('Radar PS-02/A', 'PS-02/A radar', 'Radar de tir et de navigation pour interception', 'Fire-control and navigation radar for interception'),
('Radar PS-37/A', 'PS-37/A radar', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol', 'Terrain-following and navigation radar for air-to-air and air-to-ground missions'),
('Radar PS-05/A', 'PS-05/A radar', 'Radar à balayage électronique mécanique pour détection air-air et air-sol', 'Mechanically scanned array radar for air-to-air and air-to-ground detection'),
('Radar EL/M-2032', 'EL/M-2032 radar', 'Radar Doppler multi-mode pour détection air-air/air-sol', 'Multi-mode Doppler radar for air-to-air/air-to-ground detection'),
('Radar J/APG-1', 'J/APG-1 radar', 'Radar à antenne active (AESA) pour détection longue portée', 'Active-array (AESA) radar for long-range detection'),
('Radar AN/AWG-9', 'AN/AWG-9 radar', 'Radar à longue portée pour missiles AIM-54 Phoenix', 'Long-range radar for AIM-54 Phoenix missiles'),
('Radar de suivi de terrain', 'Terrain-following radar', 'Radar permettant un vol à basse altitude en suivant le relief', 'Radar enabling low-altitude flight by following terrain contours'),
('Radar multi-mode', 'Multi-mode radar', 'Radar de suivi de terrain et de navigation pour missions air-air et air-sol', 'Terrain-following and navigation radar for air-to-air and air-to-ground missions'),
('Radar Type 242', 'Type 242 radar', 'Radar de navigation et d''attaque pour missions de bombardement', 'Navigation and attack radar for bombing missions'),
('Système de navigation inertielle', 'Inertial navigation system', 'Système de navigation autonome sans GPS', 'Autonomous navigation system without GPS'),
('Système de navigation semi-automatique', 'Semi-automatic navigation system', 'Intégration précoce d''un système de navigation inertielle', 'Early integration of inertial navigation system'),
('Système de navigation et d''attaque intégré', 'Integrated navigation and attack system', 'Système combinant navigation inertielle et radar', 'System combining inertial navigation and radar'),
('Système de navigation attaque à basse altitude', 'Low-altitude navigation and attack system', 'Couplage radar altimètre/ordinateur de navigation', 'Coupling of radar altimeter and navigation computer'),
('Commande de vol électrique (fly-by-wire)', 'Fly-by-wire flight control', 'Système numérique de contrôle de stabilité', 'Digital stability control system'),
('Système de contrôle de vol numérique', 'Digital flight control system', 'Système de contrôle de vol assisté par ordinateur', 'Computer-assisted flight control system'),
('Système de contrôle de réacteur', 'Engine control system', 'Système de contrôle numérique pour la gestion de la poussée vectorielle', 'Digital control system for thrust vectoring management'),
('Système SPECTRA', 'SPECTRA system', 'Suite complète de guerre électronique et contre-mesures', 'Comprehensive electronic warfare and countermeasures suite'),
('Système de contre-mesures électroniques', 'Electronic countermeasures system', 'Système intégré de brouillage et de leurres', 'Integrated jamming and decoy system'),
('Conception furtive', 'Stealth design', 'Forme et matériaux réduisant la signature radar', 'Shape and materials reducing radar signature'),
('Fusion de capteurs', 'Sensor fusion', 'Intégration des données radar, IR et ROEM', 'Integration of radar, IR and ELINT data'),
('Système de fusion de capteurs', 'Sensor fusion system', 'Intégration des données radar, IR et ROEM', 'Integration of radar, IR and ELINT data'),
('Système de gestion de mission avancé', 'Advanced mission management system', 'Système intégré de navigation, d''attaque et de contre-mesures', 'Integrated navigation, attack and countermeasures system'),
('Système de caméra intégré', 'Integrated camera system', 'Caméra gunshot pour enregistrement des combats', 'Gunshot camera for combat recording'),
('Liaison de données tactique', 'Tactical data link', 'Système d''échange d''informations avec la flotte', 'Information exchange system with the fleet'),
('Canon M39', 'M39 cannon', 'Canon de 20 mm à haute cadence de tir', '20 mm high rate-of-fire cannon'),
('Canon GAU-8 Avenger', 'GAU-8 Avenger cannon', 'Canon rotatif de 30 mm à haute cadence de tir', '30 mm rotary cannon with high rate of fire'),
('Canon GSh-30-2', 'GSh-30-2 cannon', 'Canon double de 30 mm à haute cadence de tir', '30 mm twin cannon with high rate of fire'),
('Canon NR-23', 'NR-23 cannon', 'Canon de 23 mm à haute cadence de tir', '23 mm high rate-of-fire cannon'),
('Matériaux composites', 'Composite materials', 'Utilisation de carbone et kevlar dans la structure', 'Use of carbon and Kevlar in the structure'),
('Blindage en titane', 'Titanium armor', 'Blindage lourd pour protéger le pilote et les systèmes vitaux', 'Heavy armor to protect pilot and vital systems'),
('Conception en acier inoxydable', 'Stainless steel design', 'Structure en acier pour résister aux hautes vitesses et températures', 'Steel structure to withstand high speeds and temperatures'),
('Matériaux résistants à la chaleur', 'Heat-resistant materials', 'Utilisation de titane et de matériaux composites résistants à la chaleur', 'Use of titanium and heat-resistant composite materials'),
('Système navalisé', 'Navalized system', 'Renforcement structurel et corrosion contrôlée pour porte-avions', 'Structural reinforcement and corrosion control for carriers'),
('Soute à armement pressurisée', 'Pressurized weapons bay', 'Soute spéciale pour armes nucléaires stratégiques', 'Special bay for strategic nuclear weapons'),
('Perche de ravitaillement en vol', 'Fixed aerial refueling probe', 'Système de ravitaillement en vol fixe', 'Fixed in-flight refueling system'),
('Système de ravitaillement en vol automatique', 'Automatic aerial refueling system', 'Perche de ravitaillement avec automate de connexion', 'Refueling probe with automatic connection control'),
('Siège incliné', 'Reclined seat', 'Siège incliné pour réduire les effets de la gravité sur le pilote', 'Reclined seat to reduce the effects of gravity on the pilot'),
('Pod désignateur laser', 'Laser designator pod', 'Capacité d''illumination laser pour bombes guidées', 'Laser illumination capability for guided bombs'),
('Poste de pilotage côte à côte', 'Side-by-side cockpit', 'Configuration côte à côte pour les missions longues durées', 'Side-by-side configuration for long-duration missions'),
('Configuration bi-moteurs superposés', 'Stacked twin-engine configuration', 'Moteurs empilés verticalement pour réduire la traînée', 'Engines stacked vertically to reduce drag'),
('Système de décollage et d''atterrissage sur porte-avions', 'Carrier take-off and landing system', 'Renforcement structurel et corrosion contrôlée pour porte-avions', 'Structural reinforcement and corrosion control for carriers'),
('Conception aérodynamique pour haute altitude', 'High-altitude aerodynamic design', 'Forme optimisée pour le vol à haute altitude et haute vitesse', 'Optimized shape for high-altitude and high-speed flight');

-- =============================================================================
-- timeline_events — chronologie éditoriale du ciel militaire (1945 → aujourd'hui).
-- Les INSERT (54 événements éditoriaux) sont fournis par db_backup/timeline_events.sql
-- qui est autonome et re-runnable (DELETE + INSERT).
-- =============================================================================

CREATE TABLE IF NOT EXISTS timeline_events (
    id              SERIAL PRIMARY KEY,
    event_date      DATE NOT NULL,
    era_decade      SMALLINT NOT NULL,
    kind            VARCHAR(16) NOT NULL CHECK (kind IN ('milestone','war','tech','doctrine','rupture')),
    title_fr        VARCHAR(160) NOT NULL,
    title_en        VARCHAR(160) NOT NULL,
    body_fr         TEXT NOT NULL,
    body_en         TEXT NOT NULL,
    airplane_id     INTEGER REFERENCES airplanes(id) ON DELETE SET NULL,
    quote_author_fr VARCHAR(160),
    quote_author_en VARCHAR(160),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_timeline_events_decade   ON timeline_events (era_decade, event_date);
CREATE INDEX IF NOT EXISTS idx_timeline_events_airplane ON timeline_events (airplane_id) WHERE airplane_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_timeline_events_kind     ON timeline_events (kind);

GRANT SELECT, INSERT, UPDATE, DELETE ON timeline_events TO vol_user;
GRANT USAGE, SELECT ON SEQUENCE timeline_events_id_seq TO vol_user;
