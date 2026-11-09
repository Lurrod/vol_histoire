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
    -- Incrémenté à chaque changement de rôle, d'email ou de mot de passe :
    -- les access tokens émis avant sont refusés (claim `tv`).
    token_version INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index pour les recherches fréquentes par email (login, register, reset password)
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_users_locked_until ON users (locked_until) WHERE locked_until IS NOT NULL;

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id          SERIAL PRIMARY KEY,
    jti         VARCHAR(36) UNIQUE NOT NULL,       -- UUID v4, identifiant unique du token
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    revoked     BOOLEAN NOT NULL DEFAULT FALSE,
    rotated_at  TIMESTAMPTZ NULL,                  -- renseigné quand le token est remplacé par rotation (détection de rejeu)
    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
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
    type        VARCHAR(10) NOT NULL CHECK (type IN ('verify', 'reset', 'email')),
    new_email   VARCHAR(255) NULL,                 -- type 'email' : adresse à appliquer après confirmation
    expires_at  TIMESTAMPTZ NOT NULL,
    used_at     TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
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
    -- Attribution de la photo. Les licences Creative Commons imposent de citer
    -- l'auteur ; ces deux colonnes alimentent la légende affichée sous l'image.
    image_credit VARCHAR(255),
    image_licence VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Contraintes de cohérence : garde-fous sur les plages de valeurs et l'ordre
-- chronologique. Toutes vérifiées sans violation sur le catalogue des 107 fiches.
ALTER TABLE airplanes
  ADD CONSTRAINT chk_airplanes_masses      CHECK (mtow IS NULL OR empty_weight IS NULL OR mtow >= empty_weight),
  ADD CONSTRAINT chk_airplanes_masses_pos  CHECK ((empty_weight IS NULL OR empty_weight > 0) AND (mtow IS NULL OR mtow > 0)),
  ADD CONSTRAINT chk_airplanes_chrono      CHECK (
        (date_first_fly   IS NULL OR date_concept   IS NULL OR date_first_fly   >= date_concept)
    AND (date_operationel IS NULL OR date_first_fly IS NULL OR date_operationel >= date_first_fly)),
  ADD CONSTRAINT chk_airplanes_production  CHECK (production_end IS NULL OR production_start IS NULL OR production_end >= production_start),
  ADD CONSTRAINT chk_airplanes_dimensions  CHECK (
        (length IS NULL OR length > 0) AND (wingspan  IS NULL OR wingspan  > 0)
    AND (height IS NULL OR height > 0) AND (wing_area IS NULL OR wing_area > 0)),
  ADD CONSTRAINT chk_airplanes_perfs       CHECK (
        (max_speed       IS NULL OR max_speed       > 0) AND (max_range  IS NULL OR max_range  > 0)
    AND (service_ceiling IS NULL OR service_ceiling > 0) AND (climb_rate IS NULL OR climb_rate > 0)
    AND (combat_radius   IS NULL OR combat_radius   > 0)),
  ADD CONSTRAINT chk_airplanes_rayon       CHECK (combat_radius IS NULL OR max_range IS NULL OR combat_radius <= max_range),
  ADD CONSTRAINT chk_airplanes_facteur_g   CHECK ((g_limit_pos IS NULL OR g_limit_pos > 0) AND (g_limit_neg IS NULL OR g_limit_neg < 0)),
  ADD CONSTRAINT chk_airplanes_equipage    CHECK (crew IS NULL OR crew BETWEEN 1 AND 35),
  ADD CONSTRAINT chk_airplanes_moteurs     CHECK (engine_count IS NULL OR engine_count BETWEEN 1 AND 10),
  ADD CONSTRAINT chk_airplanes_poussee     CHECK (
        (thrust_dry IS NULL OR thrust_dry > 0) AND (thrust_wet IS NULL OR thrust_wet > 0)
    AND (thrust_wet IS NULL OR thrust_dry IS NULL OR thrust_wet >= thrust_dry)),
  ADD CONSTRAINT chk_airplanes_qte_prod    CHECK (units_built IS NULL OR units_built >= 0),
  ADD CONSTRAINT chk_airplanes_annee_cout  CHECK (unit_cost_year IS NULL OR unit_cost_year BETWEEN 1940 AND 2100),
  ADD CONSTRAINT chk_airplanes_auto_ref    CHECK (
        (predecessor_id IS NULL OR predecessor_id <> id)
    AND (successor_id   IS NULL OR successor_id   <> id)
    AND (rival_id       IS NULL OR rival_id       <> id));

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

-- Index pour les sorts (sortMap dans backend/routes/airplanes.js).
-- Tie-breaker `id` pour un ordre stable entre pages.
CREATE INDEX IF NOT EXISTS idx_airplanes_date_operationel ON airplanes (date_operationel DESC NULLS LAST, id);
CREATE INDEX IF NOT EXISTS idx_airplanes_name             ON airplanes (name ASC, id);
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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
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
('Iran', 'Iran', 'IRN'),
('Libye', 'Libya', 'LBY'),
('Ukraine', 'Ukraine', 'UKR'),
('Corée du Sud', 'South Korea', 'ROK'),
('Turquie', 'Turkey', 'TUR'),
('Tchécoslovaquie', 'Czechoslovakia', 'CSK'),
('Taïwan', 'Taiwan', 'TWN'),
('Pologne', 'Poland', 'POL'),
('Espagne', 'Spain', 'ESP'),
('Afrique du Sud', 'South Africa', 'ZAF'),
('Argentine', 'Argentina', 'ARG'),
('Suisse', 'Switzerland', 'CHE'),
('Pays-Bas', 'Netherlands', 'NLD'),
('Finlande', 'Finland', 'FIN'),
('Chili', 'Chile', 'CHL'),
('Pakistan', 'Pakistan', 'PAK'),
('Indonésie', 'Indonesia', 'IDN'),
('Canada', 'Canada', 'CAN'),
('Roumanie', 'Romania', 'ROU'),
('Australie', 'Australia', 'AUS'),
('Égypte', 'Egypt', 'EGY');

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
('Guerre Indo-Pakistanaise de 1971', 'Indo-Pakistani War of 1971', '1971-12-03', '1971-12-16', (SELECT id FROM countries WHERE code = 'IND'), 'Conflit entre l''Inde et le Pakistan entraînant la création du Bangladesh.', 'Conflict between India and Pakistan leading to the creation of Bangladesh.'),
('Guerre d''Algérie', 'Algerian War', '1954-11-01', '1962-03-19', (SELECT id FROM countries WHERE code = 'DZA'), 'Conflit entre la France et le Front de libération nationale (FLN) pour l''indépendance de l''Algérie.', 'Conflict between France and the National Liberation Front (FLN) for Algerian independence.'),
('Intervention en Libye', 'Libyan Intervention', '2011-03-19', '2011-10-31', (SELECT id FROM countries WHERE code = 'LBY'), 'Campagne aérienne d''une coalition OTAN contre les forces de Mouammar Kadhafi, sous mandat de la résolution 1973 du Conseil de sécurité.', 'NATO-led air campaign against Muammar Gaddafi''s forces, mandated by UN Security Council Resolution 1973.'),
('Conflit indo-pakistanais de 2019', 'India-Pakistan Standoff of 2019', '2019-02-26', '2019-03-01', (SELECT id FROM countries WHERE code = 'IND'), 'Affrontement aérien entre l''Inde et le Pakistan après la frappe de Balakot, incluant le premier combat aérien entre puissances nucléaires.', 'Air confrontation between India and Pakistan following the Balakot strike, including the first air combat between nuclear powers.'),
('Invasion russe de l''Ukraine', 'Russian Invasion of Ukraine', '2022-02-24', NULL, (SELECT id FROM countries WHERE code = 'UKR'), 'Conflit de haute intensité opposant la Russie à l''Ukraine, marqué par une guerre aérienne contestée et un usage massif de missiles de croisière et de drones.', 'High-intensity conflict between Russia and Ukraine, marked by contested air warfare and massive use of cruise missiles and drones.'),
('Guerre d''Indochine', 'First Indochina War', '1946-12-19', '1954-07-21', (SELECT id FROM countries WHERE code = 'VNM'), 'Guerre de décolonisation entre la France et le Viêt Minh. L''aviation française, équipée surtout de matériel américain, y assure appui au sol et ravitaillement de camps isolés jusqu''à Diên Biên Phu.', 'Decolonisation war between France and the Viet Minh. French air power, largely American-supplied, provided ground support and supplied isolated garrisons up to Dien Bien Phu.'),
('Insurrection malaise', 'Malayan Emergency', '1948-06-16', '1960-07-31', NULL, 'Guérilla communiste en Malaisie britannique, combattue par le Commonwealth. Les opérations aériennes (opération Firedog) frappent les camps dans la jungle.', 'Communist guerrilla war in British Malaya, fought by the Commonwealth. Air operations (Operation Firedog) struck jungle camps.'),
('Crise de Suez', 'Suez Crisis', '1956-10-29', '1956-11-07', (SELECT id FROM countries WHERE code = 'EGY'), 'Intervention franco-britannique (opération Mousquetaire) et offensive israélienne dans le Sinaï contre l''Égypte après la nationalisation du canal. Les aérodromes égyptiens sont neutralisés en quelques jours depuis Chypre, Malte et les porte-avions.', 'Anglo-French intervention (Operation Musketeer) and Israeli offensive in the Sinai against Egypt after the canal''s nationalisation. Egyptian airfields were neutralised within days from Cyprus, Malta and carriers.'),
('Crise congolaise', 'Congo Crisis', '1960-07-05', '1965-11-25', NULL, 'Guerre civile et sécession du Katanga après l''indépendance du Congo belge, avec intervention des Nations unies puis de mercenaires appuyés par la CIA. Premier engagement aérien de combat d''une force de l''ONU.', 'Civil war and Katangan secession after Belgian Congo''s independence, with UN intervention and later CIA-backed mercenaries. First combat air operation by a United Nations force.'),
('Guerre coloniale portugaise', 'Portuguese Colonial War', '1961-02-04', '1974-04-25', NULL, 'Guerres menées par le Portugal contre les mouvements indépendantistes d''Angola, de Guinée et du Mozambique, jusqu''à la révolution des Œillets. L''appui aérien et le transport de troupes y sont permanents.', 'Wars fought by Portugal against independence movements in Angola, Guinea and Mozambique until the Carnation Revolution. Air support and troop transport were constant.'),
('Invasion de la baie des Cochons', 'Bay of Pigs Invasion', '1961-04-17', '1961-04-20', NULL, 'Débarquement d''exilés cubains soutenus par la CIA, repoussé en trois jours par les forces de Fidel Castro. L''aviation cubaine, réduite à quelques appareils, coule deux navires et abat plusieurs B-26 de l''invasion.', 'CIA-backed landing by Cuban exiles, defeated within three days by Fidel Castro''s forces. Cuba''s handful of aircraft sank two ships and shot down several of the invaders'' B-26s.'),
('Annexion de Goa', 'Annexation of Goa', '1961-12-18', '1961-12-19', (SELECT id FROM countries WHERE code = 'IND'), 'Opération Vijay : l''Inde s''empare en deux jours des possessions portugaises de Goa, Daman et Diu. L''aviation indienne neutralise l''aérodrome de Dabolim et les transmissions.', 'Operation Vijay: India seized Portugal''s enclaves of Goa, Daman and Diu in two days. The Indian Air Force neutralised Dabolim airfield and communications.'),
('Confrontation indonésio-malaisienne', 'Indonesia–Malaysia Confrontation', '1963-01-20', '1966-08-11', (SELECT id FROM countries WHERE code = 'IDN'), 'Conflit de basse intensité opposant l''Indonésie de Soekarno à la Malaisie et au Commonwealth, surtout à Bornéo. L''aviation britannique y assure défense aérienne et appui.', 'Low-intensity conflict between Sukarno''s Indonesia and Malaysia and the Commonwealth, mainly on Borneo. British air power provided air defence and support.'),
('Urgence d''Aden', 'Aden Emergency', '1963-12-10', '1967-11-30', NULL, 'Insurrection nationaliste contre la présence britannique à Aden et dans le protectorat, jusqu''au retrait de 1967. La campagne du Radfan (1964) mobilise chasseurs et bombardiers de la RAF.', 'Nationalist insurgency against British rule in Aden and its protectorate until the 1967 withdrawal. The 1964 Radfan campaign drew in RAF fighters and bombers.'),
-- Conflit armé colombien : Accord de paix avec les FARC signé le 24 novembre 2016, conflit poursuivi avec l'ELN et les dissidences.
('Conflit armé colombien', 'Colombian conflict', '1964-05-27', NULL, NULL, 'Guerre entre l''État colombien et les guérillas FARC et ELN, puis les groupes paramilitaires et narcotrafiquants. L''aviation colombienne y emploie canonnières et avions d''attaque légers.', 'War between the Colombian state and the FARC and ELN guerrillas, then paramilitary and drug-trafficking groups. Colombia''s air force used gunships and light attack aircraft.'),
('Guerre du Bush rhodésien', 'Rhodesian Bush War', '1964-07-04', '1979-12-12', NULL, 'Guerre entre le gouvernement blanc de Rhodésie et les guérillas nationalistes ZANLA et ZIPRA. L''aviation rhodésienne frappe jusqu''aux camps du Mozambique et de Zambie.', 'War between Rhodesia''s white-minority government and the ZANLA and ZIPRA nationalist guerrillas. The Rhodesian air force struck camps as far as Mozambique and Zambia.'),
('Guerre indo-pakistanaise de 1965', 'Indo-Pakistani War of 1965', '1965-08-05', '1965-09-23', (SELECT id FROM countries WHERE code = 'PAK'), 'Deuxième guerre entre l''Inde et le Pakistan, née au Cachemire. Les deux aviations s''affrontent pendant trois semaines, notamment dans le duel Gnat contre Sabre.', 'Second war between India and Pakistan, born in Kashmir. Both air forces fought for three weeks, notably in the Gnat-versus-Sabre duel.'),
('Guerre de la frontière sud-africaine', 'South African Border War', '1966-08-26', '1990-03-21', (SELECT id FROM countries WHERE code = 'ZAF'), 'Guerre menée par l''Afrique du Sud en Namibie et en Angola contre la SWAPO, l''armée angolaise et le corps expéditionnaire cubain. Elle culmine avec la bataille de Cuito Cuanavale (1987-1988).', 'War waged by South Africa in Namibia and Angola against SWAPO, the Angolan army and the Cuban expeditionary force. It peaked at the battle of Cuito Cuanavale (1987-88).'),
('Guerre d''usure', 'War of Attrition', '1967-07-01', '1970-08-07', (SELECT id FROM countries WHERE code = 'EGY'), 'Affrontement entre Israël et l''Égypte, soutenue par l''URSS, le long du canal de Suez après la guerre des Six Jours. Raids profonds israéliens et combats aériens, dont l''embuscade Rimon 20 contre des MiG-21 pilotés par des Soviétiques.', 'Conflict between Israel and Soviet-backed Egypt along the Suez Canal after the Six-Day War. Deep Israeli raids and air battles, including the Rimon 20 ambush of Soviet-flown MiG-21s.'),
('Guerre du Biafra', 'Nigerian Civil War', '1967-07-06', '1970-01-15', NULL, 'Guerre de sécession de la province nigériane du Biafra. L''aviation fédérale, équipée de matériel soviétique, bombarde les villes et le pont aérien humanitaire.', 'Secession war of Nigeria''s Biafra region. The Federal air force, equipped with Soviet aircraft, bombed towns and the humanitarian airlift.'),
('Invasion turque de Chypre', 'Turkish invasion of Cyprus', '1974-07-20', '1974-08-18', (SELECT id FROM countries WHERE code = 'TUR'), 'Débarquement turc à Chypre après le coup d''État soutenu par la junte grecque. L''aviation turque appuie les troupes ; la Grèce tente de renforcer l''île par un pont aérien nocturne.', 'Turkish landing on Cyprus after the coup backed by the Greek junta. Turkish air power supported the troops; Greece attempted a night airlift to reinforce the island.'),
-- Guerre du Sahara occidental : Début : entrée des troupes marocaines fin octobre 1975, fin : cessez-le-feu de l'ONU. L'emploi espagnol du Saeta (1975) précède de peu cette date.
('Guerre du Sahara occidental', 'Western Sahara War', '1975-10-30', '1991-09-06', NULL, 'Guerre opposant le Front Polisario au Maroc (et à la Mauritanie jusqu''en 1979) pour le contrôle de l''ancien Sahara espagnol. Les missiles sol-air du Polisario infligent des pertes à l''aviation marocaine.', 'War between the Polisario Front and Morocco (and Mauritania until 1979) over former Spanish Sahara. Polisario surface-to-air missiles inflicted losses on Moroccan aviation.'),
('Guerre de l''Ogaden', 'Ogaden War', '1977-07-13', '1978-03-15', NULL, 'Invasion somalienne de l''Ogaden éthiopien, repoussée avec l''aide soviétique et cubaine. Les F-5E éthiopiens y obtiennent la supériorité aérienne face aux MiG somaliens.', 'Somali invasion of Ethiopia''s Ogaden, repelled with Soviet and Cuban help. Ethiopian F-5Es won air superiority over Somali MiGs.'),
-- Conflit tchado-libyen : Début non établi au jour près : 1978 (offensive du FROLINAT appuyée par la Libye, opération Tacaud).
('Conflit tchado-libyen', 'Chadian–Libyan War', NULL, '1987-09-11', NULL, 'Guerre entre la Libye de Kadhafi et le Tchad, appuyé par la France (opérations Tacaud, Manta puis Épervier). Elle s''achève par la « guerre des Toyota » et la défaite libyenne à Ouadi Doum.', 'War between Gaddafi''s Libya and Chad, backed by France (Operations Tacaud, Manta and Épervier). It ended with the ''Toyota War'' and the Libyan defeat at Ouadi Doum.'),
('Guerre civile salvadorienne', 'Salvadoran Civil War', '1979-10-15', '1992-01-16', NULL, 'Guerre entre le gouvernement salvadorien, soutenu par les États-Unis, et la guérilla du FMLN, close par les accords de Chapultepec. L''aviation salvadorienne y emploie avions d''attaque légers et canonnières.', 'War between the US-backed Salvadoran government and the FMLN guerrillas, ended by the Chapultepec accords. The Salvadoran air force used light attack aircraft and gunships.'),
('Guerre soviéto-afghane', 'Soviet–Afghan War', '1979-12-24', '1989-02-15', (SELECT id FROM countries WHERE code = 'AFG'), 'Intervention de l''URSS en Afghanistan contre les moudjahidines, jusqu''au retrait des troupes soviétiques. Guerre d''appui, de bombardement et de pont aérien, transformée par l''arrivée des Stinger en 1986.', 'Soviet intervention in Afghanistan against the mujahideen, until Soviet troops withdrew. An air war of support, bombing and airlift, transformed by the arrival of Stingers in 1986.'),
('Guerre civile du Sri Lanka', 'Sri Lankan Civil War', '1983-07-23', '2009-05-18', NULL, 'Guerre entre l''État sri-lankais et les Tigres de libération de l''Îlam tamoul (LTTE), jusqu''à leur écrasement en 2009. L''aviation sri-lankaise y passe d''avions légers à des chasseurs-bombardiers.', 'War between the Sri Lankan state and the Liberation Tigers of Tamil Eelam (LTTE), until their defeat in 2009. The Sri Lankan air force moved from light aircraft to fighter-bombers.'),
('Invasion de la Grenade', 'Invasion of Grenada', '1983-10-25', '1983-12-15', NULL, 'Opération Urgent Fury : les États-Unis renversent le régime militaire de la Grenade. Parachutage des Rangers à Point Salines et appui aérien embarqué.', 'Operation Urgent Fury: the United States overthrew Grenada''s military regime. Rangers parachuted onto Point Salines with carrier air support.'),
-- Conflit turco-kurde (PKK) : Fin : annonce de la dissolution du PKK (mai 2025).
('Conflit turco-kurde (PKK)', 'Kurdish–Turkish conflict (PKK)', '1984-08-15', '2025-05-12', (SELECT id FROM countries WHERE code = 'TUR'), 'Insurrection du PKK contre l''État turc, étendue au nord de l''Irak et de la Syrie, jusqu''à l''annonce de la dissolution du mouvement. La Turquie y a développé sa doctrine de drones armés.', 'PKK insurgency against the Turkish state, extended into northern Iraq and Syria, until the movement announced its dissolution. Turkey built its armed-drone doctrine there.'),
('Invasion du Panama', 'United States invasion of Panama', '1989-12-20', '1990-01-31', NULL, 'Opération Just Cause : les États-Unis renversent le général Noriega. Premier emploi au combat de l''avion furtif F-117 et assauts aéroportés simultanés.', 'Operation Just Cause: the United States overthrew General Noriega. First combat use of the F-117 stealth aircraft and simultaneous airborne assaults.'),
-- Intervention en Somalie : Fin : achèvement du retrait de l'ONUSOM II (opération United Shield), début mars 1995.
('Intervention en Somalie', 'UN intervention in Somalia', '1992-12-09', '1995-03-03', NULL, 'Interventions internationales (UNITAF puis ONUSOM II) dans la guerre civile somalienne, marquées par les combats de Mogadiscio en 1993. L''appui aérien et le pont aérien y sont constants.', 'International interventions (UNITAF then UNOSOM II) in the Somali civil war, marked by the 1993 fighting in Mogadishu. Air support and airlift were constant.'),
-- Guerres de Tchétchénie : Couvre les deux guerres, fin officielle de l'opération antiterroriste le 16 avril 2009.
('Guerres de Tchétchénie', 'Chechen Wars', '1994-12-11', '2009-04-16', NULL, 'Deux guerres russes contre les indépendantistes tchétchènes (1994-1996 et 1999-2009), marquées par le bombardement de Grozny.', 'Two Russian wars against Chechen separatists (1994-96 and 1999-2009), marked by the bombing of Grozny.'),
('Guerre du Cenepa', 'Cenepa War', '1995-01-26', '1995-02-28', NULL, 'Bref conflit frontalier entre l''Équateur et le Pérou dans la haute vallée du Cenepa. Le 10 février 1995, la chasse équatorienne abat trois appareils péruviens.', 'Short border war between Ecuador and Peru in the upper Cenepa valley. On 10 February 1995 Ecuadorian fighters shot down three Peruvian aircraft.'),
('Guerre Érythrée-Éthiopie', 'Eritrean–Ethiopian War', '1998-05-06', '2000-06-18', NULL, 'Guerre frontalière entre l''Érythrée et l''Éthiopie, l''une des plus meurtrières de la fin du siècle. Premiers combats entre Su-27 et MiG-29, pilotés pour partie par des mercenaires.', 'Border war between Eritrea and Ethiopia, among the deadliest of the late century. First combat between Su-27s and MiG-29s, partly flown by foreign pilots.'),
('Guerre de Kargil', 'Kargil War', '1999-05-03', '1999-07-26', (SELECT id FROM countries WHERE code = 'IND'), 'Conflit de haute montagne au Cachemire après l''infiltration de troupes pakistanaises au-delà de la ligne de contrôle. L''aviation indienne y frappe des positions à plus de 5 000 mètres (opération Safed Sagar).', 'High-altitude conflict in Kashmir after Pakistani troops crossed the Line of Control. The Indian Air Force struck positions above 5,000 metres (Operation Safed Sagar).'),
('Guerre du Liban de 2006', '2006 Lebanon War', '2006-07-12', '2006-08-14', (SELECT id FROM countries WHERE code = 'LBN'), 'Guerre de 34 jours entre Israël et le Hezbollah, déclenchée par un enlèvement de soldats. Campagne aérienne israélienne massive sur le Liban.', '34-day war between Israel and Hezbollah, triggered by the abduction of soldiers. Massive Israeli air campaign over Lebanon.'),
('Guerre russo-géorgienne', 'Russo-Georgian War', '2008-08-07', '2008-08-12', NULL, 'Guerre de cinq jours entre la Russie et la Géorgie autour de l''Ossétie du Sud. L''aviation russe y perd plusieurs appareils face à la défense antiaérienne géorgienne.', 'Five-day war between Russia and Georgia over South Ossetia. Russian aviation lost several aircraft to Georgian air defences.'),
-- Guerre du Sahel : Début : rébellion du MNLA au nord du Mali, conflit en cours.
('Guerre du Sahel', 'Sahel War', '2012-01-16', NULL, NULL, 'Insurrection jihadiste au Mali puis au Niger et au Burkina Faso, avec les opérations françaises Serval (2013) et Barkhane (2014-2022). Guerre de drones, de frappes et de projection sur de très longues distances.', 'Jihadist insurgency in Mali, then Niger and Burkina Faso, with French Operations Serval (2013) and Barkhane (2014-22). A war of drones, strikes and very long-range projection.'),
-- Guerre du Donbass : Fin fixée à la veille de l'invasion du 24 février 2022, déjà en base.
('Guerre du Donbass', 'War in Donbas', '2014-04-06', '2022-02-23', (SELECT id FROM countries WHERE code = 'UKR'), 'Guerre dans l''est de l''Ukraine entre l''armée ukrainienne et les séparatistes soutenus par la Russie, jusqu''à l''invasion de 2022. L''aviation ukrainienne y subit de lourdes pertes en 2014 avant de se retirer du ciel du front.', 'War in eastern Ukraine between the Ukrainian army and Russian-backed separatists, until the 2022 invasion. Ukrainian aviation suffered heavy losses in 2014 before withdrawing from the front.'),
('Guerre civile libyenne (2014-2020)', 'Second Libyan Civil War', '2014-05-16', '2020-10-23', (SELECT id FROM countries WHERE code = 'LBY'), 'Guerre entre les forces du maréchal Haftar et les gouvernements de Tripoli, soutenus de part et d''autre par des puissances étrangères. Premier affrontement entre flottes de drones armés chinois et turcs.', 'War between Marshal Haftar''s forces and the Tripoli governments, each backed by foreign powers. First clash between fleets of Chinese and Turkish armed drones.'),
-- Guerre contre l'État islamique : Fin non fixée : califat territorial tombé le 23 mars 2019 (Baghouz), opérations de la coalition poursuivies depuis.
('Guerre contre l''État islamique', 'War against the Islamic State', '2014-08-08', NULL, (SELECT id FROM countries WHERE code = 'IRQ'), 'Campagne aérienne de la coalition internationale (Inherent Resolve, Chammal, Shader, Okra) contre l''État islamique en Irak et en Syrie, jusqu''à la chute du califat territorial en 2019. Les frappes en Syrie recoupent la guerre civile syrienne.', 'Air campaign by the international coalition (Inherent Resolve, Chammal, Shader, Okra) against the Islamic State in Iraq and Syria, until the territorial caliphate fell in 2019. Strikes in Syria overlap the Syrian civil war.'),
-- Guerre civile yéménite : Début : prise de Sanaa par les Houthis (septembre 2014), jour à confirmer.
('Guerre civile yéménite', 'Yemeni Civil War', '2014-09-16', NULL, NULL, 'Guerre entre les Houthis et le gouvernement yéménite, élargie en 2015 à l''intervention de la coalition saoudienne, puis aux frappes américaines et britanniques contre les Houthis à partir de 2024.', 'War between the Houthis and Yemen''s government, widened in 2015 by the Saudi-led coalition and from 2024 by US and British strikes on the Houthis.'),
('Siège de Marawi', 'Siege of Marawi', '2017-05-23', '2017-10-23', NULL, 'Bataille de cinq mois entre l''armée philippine et des groupes affiliés à l''État islamique dans la ville de Marawi, sur Mindanao. Premier emploi au combat de l''avion d''armes léger FA-50.', 'Five-month battle between the Philippine army and Islamic State-affiliated groups in the city of Marawi, Mindanao. First combat use of the FA-50 light combat aircraft.'),
('Guerre du Haut-Karabagh (2020)', 'Second Nagorno-Karabakh War', '2020-09-27', '2020-11-10', NULL, 'Guerre de 44 jours remportée par l''Azerbaïdjan contre les forces arméniennes du Haut-Karabagh. Le premier conflit décidé en grande partie par les drones et les munitions rôdeuses.', '44-day war won by Azerbaijan against Armenian forces in Nagorno-Karabakh. The first conflict decided largely by drones and loitering munitions.'),
-- Guerre Israël-Hamas : Cessez-le-feu en vigueur depuis le 10 octobre 2025, fin non actée.
('Guerre Israël-Hamas', 'Israel–Hamas war', '2023-10-07', NULL, NULL, 'Guerre ouverte par l''attaque du Hamas du 7 octobre 2023 et la campagne militaire israélienne sur la bande de Gaza, la plus longue de l''histoire d''Israël.', 'War opened by Hamas''s attack of 7 October 2023 and Israel''s military campaign over the Gaza Strip, the longest in Israel''s history.'),
('Conflit indo-pakistanais de 2025', '2025 India–Pakistan conflict', '2025-05-07', '2025-05-10', (SELECT id FROM countries WHERE code = 'PAK'), 'Affrontement de quatre jours ouvert par les frappes indiennes de l''opération Sindoor, après l''attentat de Pahalgam. Le plus grand combat aérien entre les deux pays depuis 1971, à longue distance de missiles.', 'Four-day clash opened by India''s Operation Sindoor strikes after the Pahalgam attack. The largest air battle between the two countries since 1971, fought at long missile range.'),
('Guerre Iran-Israël', 'Iran–Israel war', '2025-06-13', '2025-06-24', (SELECT id FROM countries WHERE code = 'IRN'), 'Guerre de douze jours ouverte par la campagne aérienne israélienne contre les sites nucléaires et militaires iraniens (opération Rising Lion), avec frappes américaines sur Fordo le 22 juin.', 'Twelve-day war opened by Israel''s air campaign against Iranian nuclear and military sites (Operation Rising Lion), with US strikes on Fordow on 22 June.');

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
('Dissuasion nucléaire', 'Nuclear Deterrence', 'Transport et éventuel largage d’armes nucléaires pour des missions stratégiques.', 'Carriage and potential release of nuclear weapons for strategic missions.'),
('Transport logistique', 'Logistic Transport', 'Acheminement de troupes, de fret et de matériel entre bases ou vers un théâtre d’opérations.', 'Movement of troops, freight and equipment between bases or into a theatre of operations.'),
('Ravitaillement en vol', 'Aerial Refuelling', 'Transfert de carburant en vol vers d’autres aéronefs, prolongeant leur autonomie et leur temps sur zone.', 'In-flight fuel transfer to other aircraft, extending their range and time on station.'),
('Largage de troupes', 'Paratroop Drop', 'Mise à terre de parachutistes et de charges par largage, y compris à très basse altitude.', 'Delivery of paratroops and loads by air drop, including at very low level.'),
('Essais en vol', 'Flight testing', 'Évaluation en vol d''un appareil ou d''une technologie', 'In-flight evaluation of an aircraft or a technology'),
('Reconnaissance tactique', 'Tactical reconnaissance', 'Observation du champ de bataille au profit des forces engagées', 'Battlefield observation in support of engaged forces');

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
('IAI (Israel Aerospace Industries)', 'IAI (Israel Aerospace Industries)', (SELECT id FROM countries WHERE code = 'ISR'), 'IAI'),
-- Constructeurs partages par plusieurs fiches : déclarés ici et non dans une
-- fiche, l'ordre de chargement alphabetique ne garantissant pas leur présence.
('Convair', 'Convair', (SELECT id FROM countries WHERE code = 'USA'), 'CVR'),
('Grumman', 'Grumman', (SELECT id FROM countries WHERE code = 'USA'), 'GRU'),
('English Electric', 'English Electric', (SELECT id FROM countries WHERE code = 'GBR'), 'EE'),
('Vought', 'Vought', (SELECT id FROM countries WHERE code = 'USA'), 'VOU'),
('Korea Aerospace Industries', 'Korea Aerospace Industries', (SELECT id FROM countries WHERE code = 'ROK'), 'KAI');

-- Constructeurs historiques déclarés jusqu'ici dans les fiches individuelles.
-- Remontés ici sans exception : une fiche qui référence un constructeur déclaré
-- par une fiche chargée après elle entre en base avec id_manufacturer = NULL,
-- sans qu'aucune erreur ne soit levée (la clé étrangère est nullable).
INSERT INTO manufacturer (name, name_en, country_id, code) VALUES
('Aero Vodochody', 'Aero Vodochody', (SELECT id FROM countries WHERE code = 'CSK'), 'AERO'),
('AIDC (Aerospace Industrial Development Corporation)', 'AIDC (Aerospace Industrial Development Corporation)', (SELECT id FROM countries WHERE code = 'TWN'), 'AIDC'),
('British Aircraft Corporation', 'British Aircraft Corporation', (SELECT id FROM countries WHERE code = 'GBR'), 'BAC'),
('Baykar', 'Baykar', (SELECT id FROM countries WHERE code = 'TUR'), 'BAY'),
('CASA (Construcciones Aeronáuticas SA)', 'CASA (Construcciones Aeronáuticas SA)', (SELECT id FROM countries WHERE code = 'ESP'), 'CASA'),
('de Havilland', 'de Havilland', (SELECT id FROM countries WHERE code = 'GBR'), 'DH'),
('Douglas Aircraft Company', 'Douglas Aircraft Company', (SELECT id FROM countries WHERE code = 'USA'), 'DOU'),
('Fiat Aviazione', 'Fiat Aviazione', (SELECT id FROM countries WHERE code = 'ITA'), 'FIAT'),
('General Atomics', 'General Atomics', (SELECT id FROM countries WHERE code = 'USA'), 'GA'),
('Gloster Aircraft Company', 'Gloster Aircraft Company', (SELECT id FROM countries WHERE code = 'GBR'), 'GLO'),
('HESA (Iran Aircraft Manufacturing Industrial Company)', 'HESA (Iran Aircraft Manufacturing Industrial Company)', (SELECT id FROM countries WHERE code = 'IRN'), 'HESA'),
('Hongdu Aviation Industry', 'Hongdu Aviation Industry', (SELECT id FROM countries WHERE code = 'CHN'), 'HONG'),
('Handley Page', 'Handley Page', (SELECT id FROM countries WHERE code = 'GBR'), 'HP'),
('Hawker Siddeley', 'Hawker Siddeley', (SELECT id FROM countries WHERE code = 'GBR'), 'HS'),
('Iliouchine', 'Ilyushin', (SELECT id FROM countries WHERE code = 'RUS'), 'ILY'),
('Kawasaki Heavy Industries', 'Kawasaki Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'KHI'),
('Ling-Temco-Vought', 'Ling-Temco-Vought', (SELECT id FROM countries WHERE code = 'USA'), 'LTV'),
('McDonnell Douglas', 'McDonnell Douglas', (SELECT id FROM countries WHERE code = 'USA'), 'MDD'),
('North American Aviation', 'North American Aviation', (SELECT id FROM countries WHERE code = 'USA'), 'NAA'),
('Nanchang Aircraft Corporation', 'Nanchang Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'NAMC'),
('Northrop', 'Northrop', (SELECT id FROM countries WHERE code = 'USA'), 'NOR'),
('PZL-Mielec', 'PZL-Mielec', (SELECT id FROM countries WHERE code = 'POL'), 'PZL'),
('Republic Aviation', 'Republic Aviation', (SELECT id FROM countries WHERE code = 'USA'), 'REP'),
('Soko', 'Soko', (SELECT id FROM countries WHERE code = 'YUG'), 'SOKO'),
('Sud Aviation', 'Sud Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'SUD'),
('Supermarine', 'Supermarine', (SELECT id FROM countries WHERE code = 'GBR'), 'SUP'),
('Xian Aircraft Corporation', 'Xian Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'XAC'),
('Yakovlev', 'Yakovlev', (SELECT id FROM countries WHERE code = 'RUS'), 'YAK'),
('Vickers-Armstrongs', 'Vickers-Armstrongs', (SELECT id FROM countries WHERE code = 'GBR'), 'VIC'),
('Folland Aircraft', 'Folland Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'FOL'),
('Fouga', 'Fouga', (SELECT id FROM countries WHERE code = 'FRA'), 'FOU'),
('Myasishchev', 'Myasishchev', (SELECT id FROM countries WHERE code = 'RUS'), 'MYA'),
('North American Rockwell', 'North American Rockwell', (SELECT id FROM countries WHERE code = 'USA'), 'ROC'),
('Cessna', 'Cessna', (SELECT id FROM countries WHERE code = 'USA'), 'CES'),
('Atlas Aircraft Corporation', 'Atlas Aircraft Corporation', (SELECT id FROM countries WHERE code = 'ZAF'), 'ATL'),
('FMA (Fábrica Militar de Aviones)', 'FMA (Fábrica Militar de Aviones)', (SELECT id FROM countries WHERE code = 'ARG'), 'FMA'),
('Pilatus Aircraft', 'Pilatus Aircraft', (SELECT id FROM countries WHERE code = 'CHE'), 'PIL'),
('TAI (Turkish Aerospace Industries)', 'TAI (Turkish Aerospace Industries)', (SELECT id FROM countries WHERE code = 'TUR'), 'TAI'),
('Beriev', 'Beriev', (SELECT id FROM countries WHERE code = 'RUS'), 'BER'),
('Breguet Aviation', 'Breguet Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'BRG'),
('Avro Canada', 'Avro Canada', (SELECT id FROM countries WHERE code = 'CAN'), 'AVC'),
('Fairey Aviation', 'Fairey Aviation', (SELECT id FROM countries WHERE code = 'GBR'), 'FAI'),
('IAR (Industria Aeronautică Română)', 'IAR (Industria Aeronautică Română)', (SELECT id FROM countries WHERE code = 'ROU'), 'IAR'),
('Avro (A.V. Roe)', 'Avro (A.V. Roe)', (SELECT id FROM countries WHERE code = 'GBR'), 'AVR'),
('CAC (Commonwealth Aircraft Corporation)', 'CAC (Commonwealth Aircraft Corporation)', (SELECT id FROM countries WHERE code = 'AUS'), 'CWA'),
('Helwan Aircraft Factory', 'Helwan Aircraft Factory', (SELECT id FROM countries WHERE code = 'EGY'), 'HEL'),
('Antonov', 'Antonov', (SELECT id FROM countries WHERE code = 'UKR'), 'ANT'),
('Transall', 'Transall', (SELECT id FROM countries WHERE code = 'FRA'), 'TRA'),
('de Havilland Canada', 'de Havilland Canada', (SELECT id FROM countries WHERE code = 'CAN'), 'DHC'),
('Fairchild Aircraft', 'Fairchild Aircraft', (SELECT id FROM countries WHERE code = 'USA'), 'FRC'),
('Westland Aircraft', 'Westland Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'WES'),
('Nord Aviation', 'Nord Aviation', (SELECT id FROM countries WHERE code = 'FRA'), 'NRD'),
('Lavochkine', 'Lavochkin', (SELECT id FROM countries WHERE code = 'RUS'), 'LAV'),
('Saunders-Roe', 'Saunders-Roe', (SELECT id FROM countries WHERE code = 'GBR'), 'SRO'),
('FFA (Flug- und Fahrzeugwerke Altenrhein)', 'FFA (Flug- und Fahrzeugwerke Altenrhein)', (SELECT id FROM countries WHERE code = 'CHE'), 'FFA'),
('Hispano Aviación', 'Hispano Aviación', (SELECT id FROM countries WHERE code = 'ESP'), 'HSP'),
('Dornier', 'Dornier', (SELECT id FROM countries WHERE code = 'DEU'), 'DOR'),
('EWR (Entwicklungsring Süd)', 'EWR (Entwicklungsring Süd)', (SELECT id FROM countries WHERE code = 'DEU'), 'EWR'),
('VFW (Vereinigte Flugtechnische Werke)', 'VFW (Vereinigte Flugtechnische Werke)', (SELECT id FROM countries WHERE code = 'DEU'), 'VFW'),
('Ryan Aeronautical', 'Ryan Aeronautical', (SELECT id FROM countries WHERE code = 'USA'), 'RYA'),
('Bell Aircraft', 'Bell Aircraft', (SELECT id FROM countries WHERE code = 'USA'), 'BEL'),
('Short Brothers', 'Short Brothers', (SELECT id FROM countries WHERE code = 'GBR'), 'SHO'),
('Hawker Aircraft', 'Hawker Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'HAW'),
('General Dynamics', 'General Dynamics', (SELECT id FROM countries WHERE code = 'USA'), 'GD'),
('Fokker', 'Fokker', (SELECT id FROM countries WHERE code = 'NLD'), 'FOK'),
('Valmet', 'Valmet', (SELECT id FROM countries WHERE code = 'FIN'), 'VAL'),
('ENAER (Empresa Nacional de Aeronáutica de Chile)', 'ENAER (Empresa Nacional de Aeronáutica de Chile)', (SELECT id FROM countries WHERE code = 'CHL'), 'ENA'),
('SIAI-Marchetti', 'SIAI-Marchetti', (SELECT id FROM countries WHERE code = 'ITA'), 'SIAI'),
('Hunting Aircraft', 'Hunting Aircraft', (SELECT id FROM countries WHERE code = 'GBR'), 'HUN'),
('Beechcraft', 'Beechcraft', (SELECT id FROM countries WHERE code = 'USA'), 'BEE'),
('PZL Warszawa-Okęcie', 'PZL Warszawa-Okęcie', (SELECT id FROM countries WHERE code = 'POL'), 'PZLW'),
('Kratos Defense', 'Kratos Defense', (SELECT id FROM countries WHERE code = 'USA'), 'KRA'),
('Elbit Systems', 'Elbit Systems', (SELECT id FROM countries WHERE code = 'ISR'), 'ELB'),
('ShinMaywa', 'ShinMaywa', (SELECT id FROM countries WHERE code = 'JPN'), 'SHM'),
('Fuji Heavy Industries', 'Fuji Heavy Industries', (SELECT id FROM countries WHERE code = 'JPN'), 'FUJ'),
('Shaanxi Aircraft Corporation', 'Shaanxi Aircraft Corporation', (SELECT id FROM countries WHERE code = 'CHN'), 'SHX'),
('Guizhou Aircraft Industry', 'Guizhou Aircraft Industry', (SELECT id FROM countries WHERE code = 'CHN'), 'GAIC'),
('IPTN (Industri Pesawat Terbang Nusantara)', 'IPTN (Industri Pesawat Terbang Nusantara)', (SELECT id FROM countries WHERE code = 'IDN'), 'IPTN'),
('Canadair', 'Canadair', (SELECT id FROM countries WHERE code = 'CAN'), 'CDR'),
('GAF (Government Aircraft Factories)', 'GAF (Government Aircraft Factories)', (SELECT id FROM countries WHERE code = 'AUS'), 'GAF'),
('Aeritalia', 'Aeritalia', (SELECT id FROM countries WHERE code = 'ITA'), 'AIT'),
('Let Kunovice', 'Let Kunovice', (SELECT id FROM countries WHERE code = 'CSK'), 'LET'),
('HFB (Hamburger Flugzeugbau)', 'HFB (Hamburger Flugzeugbau)', (SELECT id FROM countries WHERE code = 'DEU'), 'HFB'),
('PAC (Pakistan Aeronautical Complex)', 'PAC (Pakistan Aeronautical Complex)', (SELECT id FROM countries WHERE code = 'PAK'), 'PAC'),
('SOCATA', 'SOCATA', (SELECT id FROM countries WHERE code = 'FRA'), 'SOC'),
('Scottish Aviation', 'Scottish Aviation', (SELECT id FROM countries WHERE code = 'GBR'), 'SAL'),
('Britten-Norman', 'Britten-Norman', (SELECT id FROM countries WHERE code = 'GBR'), 'BN'),
('Martin (Glenn L. Martin Company)', 'Martin (Glenn L. Martin Company)', (SELECT id FROM countries WHERE code = 'USA'), 'MAR'),
('CASC (China Aerospace Science and Technology Corporation)', 'CASC (China Aerospace Science and Technology Corporation)', (SELECT id FROM countries WHERE code = 'CHN'), 'CASC'),
('René Leduc', 'René Leduc', (SELECT id FROM countries WHERE code = 'FRA'), 'LED');

INSERT INTO generation (generation, description, description_en) VALUES
(1, 'Première génération : Avions à réaction subsoniques des années 1940-1950', 'First generation: Subsonic jet aircraft from the 1940s–1950s'),
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
('Appui aérien', 'Close Air Support', 'Avion conçu pour soutenir les troupes au sol avec des frappes ciblées', 'Aircraft designed to support ground troops with precision strikes'),
('Entraîneur', 'Trainer', 'Avion d''entraînement conçu pour la formation des pilotes militaires', 'Aircraft designed for the training of military pilots'),
('Guerre électronique', 'Electronic Warfare', 'Avion dédié au brouillage et à la neutralisation des systèmes électroniques adverses', 'Aircraft dedicated to jamming and neutralising enemy electronic systems'),
('Drone de combat', 'Combat Drone', 'Aéronef de combat sans équipage embarqué, piloté à distance ou autonome', 'Combat aircraft without an onboard crew, remotely piloted or autonomous'),
('Transport', 'Transport', 'Aéronef dédié au transport de troupes, de fret ou de matériel lourd', 'Aircraft dedicated to carrying troops, freight or heavy equipment'),
('Ravitailleur', 'Tanker', 'Aéronef dédié au ravitaillement en vol, prolongeant l’allonge des autres appareils', 'Aircraft dedicated to aerial refuelling, extending the reach of other aircraft'),
('Recherche', 'Research', 'Aéronef expérimental dédié à l''étude d''un concept, sans vocation opérationnelle', 'Experimental aircraft dedicated to studying a concept, with no operational role');

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

-- Armements spécifiques aux appareils chinois. Ils étaient auparavant déclarés
-- dans les fiches elles-mêmes (h6, j15, j16, j20, jf17), ce qui créait une
-- dépendance à l'ordre de chargement alphabétique : une fiche pouvait référencer
-- un armement déclaré par une fiche chargée après elle. Déclarés ici, ils sont
-- disponibles pour toutes les fiches.
INSERT INTO armement (name, name_en, description, description_en) VALUES
('NR-23', NULL, 'Canon de 23 mm, 850 coups/min', '23 mm cannon, 850 rounds/min'),
('PL-10', NULL, 'Missile air-air courte portée, guidage infrarouge à imagerie, 20 km', 'Short-range air-to-air missile, imaging infrared guidance, 20 km'),
('PL-15', NULL, 'Missile air-air longue portée, guidage radar actif, 200+ km', 'Long-range air-to-air missile, active radar guidance, 200+ km'),
('YJ-83', NULL, 'Missile antinavire subsonique, guidage radar actif, portée 180 km', 'Subsonic anti-ship missile, active radar guidance, 180 km range'),
('YJ-91', NULL, 'Missile anti-radar/antinavire, portée 120 km', 'Anti-radiation / anti-ship missile, 120 km range'),
('KD-88', NULL, 'Missile air-sol de précision, guidage TV/IR, portée 180 km', 'Precision air-to-surface missile, TV/IR guidance, 180 km range'),
('C-802A', NULL, 'Missile antinavire subsonique, guidage radar actif, portée 180 km', 'Subsonic anti-ship missile, active radar guidance, 180 km range'),
('CJ-10', NULL, 'Missile de croisière à lancement aérien, portée 1500-2000 km', 'Air-launched cruise missile, 1500-2000 km range'),
('CJ-20', NULL, 'Missile de croisière furtif à lancement aérien, portée 2000+ km', 'Stealthy air-launched cruise missile, 2000+ km range'),
('AIM-4 Falcon', NULL, 'Missile air-air à guidage infrarouge ou radar semi-actif, portée 11 km', 'Infrared or semi-active radar guided air-to-air missile, 11 km range'),
('AIR-2 Genie', NULL, 'Roquette air-air à charge nucléaire de 1,5 kt, non guidée', 'Unguided air-to-air rocket with a 1.5 kt nuclear warhead'),
('Hispano-Suiza HS.404', NULL, 'Canon de 20 mm à alimentation par bande, 600 coups/min', '20 mm belt-fed cannon, 600 rounds/min'),
('M3 Browning 12,7 mm', NULL, 'Mitrailleuse lourde américaine de 12,7 mm, 1 200 coups/min, armement standard des premiers jets', 'American 12.7 mm heavy machine gun, 1,200 rounds/min, standard armament of the first jets'),
('Mk 46', NULL, 'Torpille légère anti-sous-marine américaine, portée 11 km, immersion 365 m', 'American lightweight anti-submarine torpedo, 11 km range, 365 m depth'),
('Sting Ray', NULL, 'Torpille légère anti-sous-marine britannique à guidage actif/passif', 'British lightweight anti-submarine torpedo with active/passive homing'),
('FFAR Mighty Mouse', NULL, 'Roquette air-air non guidée de 70 mm, tirée en salve depuis un panier ventral', 'Unguided 70 mm air-to-air rocket, salvo-fired from a belly tray'),
-- Remontés des fiches (ac130_spectre, bayraktar_tb2, fck1_ching_kuo, su_9, tu_128) puis lots 25-28
('Canon M102 105 mm', NULL, 'Obusier de 105 mm tirant en dérive depuis le flanc gauche de l''appareil', 'Side-firing 105 mm howitzer mounted on the left side of the aircraft'),
('MAM-L', NULL, 'Munition guidée laser de 22 kg conçue pour les drones tactiques légers', 'Laser-guided 22 kg munition designed for light tactical drones'),
('TC-1 Tien Chien I', NULL, 'Missile air-air courte portée à guidage infrarouge, portée 8 km', 'Short-range infrared-guided air-to-air missile, 8 km range'),
('TC-2 Tien Chien II', NULL, 'Missile air-air moyenne portée à guidage radar actif, portée 60 km', 'Medium-range active radar-guided air-to-air missile, 60 km range'),
('RS-2US', NULL, 'Missile air-air à guidage radar par faisceau directeur, portée 6 km', 'Beam-riding radar-guided air-to-air missile, 6 km range'),
('R-4', NULL, 'Missile air-air lourd, versions à guidage radar semi-actif et infrarouge, portée 25 km', 'Heavy air-to-air missile in semi-active radar and infrared versions, 25 km range'),
('NS-23', NULL, 'Canon soviétique de 23 mm Noudelman-Souranov, mis au point en 1944, armement des premiers chasseurs à réaction Yakovlev', 'Soviet Nudelman-Suranov 23 mm cannon, developed in 1944, fitted to the first Yakovlev jet fighters'),
('Gökdoğan', NULL, 'Missile air-air turc à guidage radar actif, au-delà de la portée visuelle (TÜBİTAK SAGE)', 'Turkish beyond-visual-range air-to-air missile, active radar guidance (TÜBİTAK SAGE)'),
('AR-1', NULL, 'Missile air-sol léger chinois à guidage laser semi-actif, conçu pour les drones', 'Light Chinese semi-active laser-guided air-to-surface missile designed for drones'),
('M134 Minigun', 'M134 Minigun', 'Mitrailleuse rotative à six canons de 7,62 mm entraînée électriquement, jusqu''à 6 000 coups/min (désignation USAF : GAU-2/A)', 'Electrically driven six-barrel 7.62 mm rotary machine gun, up to 6,000 rounds/min (USAF designation: GAU-2/A)');

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
('Conception aérodynamique pour haute altitude', 'High-altitude aerodynamic design', 'Forme optimisée pour le vol à haute altitude et haute vitesse', 'Optimized shape for high-altitude and high-speed flight'),
('Aile en flèche inversée', 'Forward-swept wing', 'Voilure dont les extrémités sont en avant de l''emplanture, gain de manoeuvrabilité au prix d''une divergence aéroélastique', 'Wing whose tips lie ahead of the root, improving manoeuvrability at the cost of aeroelastic divergence'),
('Moteur-fusée', 'Rocket engine', 'Propulsion emportant son comburant, autorisant le vol au-delà de l''atmosphère respirable', 'Propulsion carrying its own oxidiser, allowing flight beyond the breathable atmosphere');

-- Mêmes causes que pour l'armement ci-dessus : références mortes depuis les fiches.
INSERT INTO tech (name, name_en, description, description_en) VALUES
('Radar AN/APQ-94', 'AN/APQ-94 radar', 'Radar de conduite de tir monopulse pour l''interception tout temps', 'Monopulse fire-control radar for all-weather interception'),
('Système de ravitaillement en vol', 'Aerial refuelling system', 'Perche ou réceptacle permettant l''extension du rayon d''action en vol', 'Probe or receptacle extending combat radius in flight'),
-- Remonté de a1_skyraider puis lots 25-28
('Moteur à pistons en étoile', 'Radial piston engine', 'Motorisation à cylindres disposés en étoile, longue endurance à basse altitude', 'Engine with radially arranged cylinders, long endurance at low altitude'),
('Rotors basculants', 'Tiltrotors', 'Rotors montés en bout d''aile dans des nacelles qui pivotent de la verticale à l''horizontale : décollage vertical comme un hélicoptère, croisière comme un avion à hélices', 'Wingtip rotors in nacelles that pivot from vertical to horizontal: vertical take-off like a helicopter, cruise like a propeller aircraft'),
('Aile volante', 'Flying wing', 'Voilure sans fuselage ni empennage horizontal, qui porte à elle seule l''équipage, les moteurs et la charge', 'Wing with no fuselage or horizontal tail, carrying crew, engines and payload on its own');

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
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_timeline_events_decade   ON timeline_events (era_decade, event_date);
CREATE INDEX IF NOT EXISTS idx_timeline_events_airplane ON timeline_events (airplane_id) WHERE airplane_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_timeline_events_kind     ON timeline_events (kind);

GRANT SELECT, INSERT, UPDATE, DELETE ON timeline_events TO vol_user;
GRANT USAGE, SELECT ON SEQUENCE timeline_events_id_seq TO vol_user;
