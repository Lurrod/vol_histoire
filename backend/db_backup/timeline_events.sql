-- =============================================================================
--  timeline_events — chronologie éditoriale du ciel militaire (1945 → aujourd'hui)
--
--  Fichier autonome :
--    1. crée la table si nécessaire (+ index et GRANT)
--    2. purge les anciennes données (re-runnable)
--    3. insère 54 événements éditoriaux (6 par décennie × 9 décennies)
--
--  Les `airplane_id` sont résolus via sous-requête SELECT ... WHERE name = '...'
--  pour rester indépendant d'un ordre d'import précis. Si l'avion n'existe pas,
--  la sous-requête renvoie NULL et la contrainte ON DELETE SET NULL tolère.
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

-- Re-runnable : repart d'une table vide pour ré-appliquer le contenu éditorial.
DELETE FROM timeline_events;

-- =============================================================================
--  1940s — L'après-guerre, naissance du monde à réaction
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('1945-08-06', 1940, 'rupture',
 'Hiroshima — le ciel devient arme ultime',
 'Hiroshima — the sky becomes the ultimate weapon',
 'À 8 h 15, un B-29 nommé Enola Gay largue Little Boy sur Hiroshima. En une fraction de seconde, l''aviation militaire cesse d''être une affaire de duels et de bombardements massifs : elle devient un instrument d''apocalypse. Les doctrines stratégiques des quarante années suivantes s''écriront à l''ombre de ce champignon.',
 'At 8:15 AM, a B-29 named Enola Gay drops Little Boy on Hiroshima. In a fraction of a second, military aviation stops being a matter of dogfights and mass bombing — it becomes an instrument of apocalypse. Every strategic doctrine of the next forty years will be written in the shadow of that mushroom cloud.',
 NULL),
('1947-07-26', 1940, 'doctrine',
 'Naissance de l''United States Air Force',
 'Birth of the United States Air Force',
 'Signé par Truman, le National Security Act détache l''aviation de l''Army. Pour la première fois, une armée de l''air américaine existe de plein droit, avec son propre chef d''état-major. Derrière la signature administrative se cache une conviction : à l''ère nucléaire, qui tient le ciel tient la guerre — et personne d''autre.',
 'Signed by Truman, the National Security Act splits aviation away from the Army. For the first time, an American Air Force exists in its own right, with its own chief of staff. Behind the paperwork lies a conviction: in the nuclear age, whoever holds the sky holds the war — and nothing else will do.',
 NULL),
('1947-10-14', 1940, 'milestone',
 'Chuck Yeager franchit le mur du son',
 'Chuck Yeager breaks the sound barrier',
 'Au-dessus du lac asséché de Muroc, un Bell X-1 orange vif largué depuis un B-29 pousse son aiguille à Mach 1,06. Chuck Yeager, côtes cassées la veille en tombant de cheval, referme la verrière avec un manche à balai. Le mur du son, tenu pour infranchissable, n''est plus qu''un seuil. L''ère supersonique commence.',
 'Over dry Muroc Lake, a bright-orange Bell X-1 dropped from a B-29 pushes its needle to Mach 1.06. Chuck Yeager, with two ribs cracked the night before from a fall off a horse, latches the canopy shut with a broomstick. The sound barrier, long thought impassable, is now just a threshold. The supersonic era begins.',
 NULL),
('1948-06-24', 1940, 'doctrine',
 'Blocus de Berlin — le pont aérien',
 'Berlin Blockade — the Airlift begins',
 'Staline coupe la route à l''ouest de Berlin. En réponse, Américains et Britanniques lancent Vittles et Plainfare : toutes les trois minutes, un C-54 touche Tempelhof chargé de charbon et de farine. Pendant onze mois, 2,3 millions de tonnes arrivent par le ciel. Le transport aérien devient arme politique et démonstration stratégique.',
 'Stalin cuts off the western routes to Berlin. In response, the Americans and British launch Vittles and Plainfare: every three minutes, a C-54 touches down at Tempelhof loaded with coal and flour. For eleven months, 2.3 million tons are delivered from the sky. Air transport becomes a political weapon and a strategic statement.',
 NULL),
('1949-04-04', 1940, 'doctrine',
 'Naissance de l''OTAN — un ciel commun à l''Ouest',
 'NATO is born — a shared Western sky',
 'À Washington, douze États signent un traité qui scellera quarante ans de Guerre froide : une attaque contre l''un est une attaque contre tous. L''article 5 réécrit la géographie du ciel européen. Les futurs F-86, Mirage III, Starfighter et Tornado voleront sous une même bannière, même quand ils porteront des cocardes différentes.',
 'In Washington, twelve nations sign a treaty that will shape forty years of Cold War: an attack on one is an attack on all. Article 5 redraws the geography of European airspace. The future F-86s, Mirage IIIs, Starfighters and Tornadoes will fly under one banner, even when they wear different roundels.',
 NULL),
('1949-08-29', 1940, 'rupture',
 'RDS-1 — l''URSS entre dans le club atomique',
 'RDS-1 — the USSR joins the atomic club',
 'À Semipalatinsk, un plateau kazakh poussiéreux, une sphère au plutonium explose à 29 kilotonnes. Le monopole américain s''éteint en quelques secondes. À partir de ce jour, chaque décollage de bombardier stratégique, chaque vol de reconnaissance, chaque alerte en base, se joue sous la menace d''une seconde apocalypse. Le monde bipolaire commence vraiment.',
 'At Semipalatinsk, on a dusty Kazakh steppe, a plutonium sphere explodes at 29 kilotons. The American monopoly ends in seconds. From that day on, every strategic bomber takeoff, every recon flight, every base alert is played out under the threat of a second apocalypse. The bipolar world truly begins.',
 NULL);

-- =============================================================================
--  1950s — La Corée, l'âge du jet, le duel stratégique
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('1950-06-25', 1950, 'war',
 'Corée — la guerre redevient ciel',
 'Korea — war returns to the sky',
 'À l''aube, des divisions nord-coréennes franchissent le 38e parallèle. En quatre mois, la guerre engloutira onze pays et invente un nouveau théâtre : le combat aérien à réaction. Pour la première fois, chasseurs américains et soviétiques se toisent en vrai, même s''ils font semblant de ne pas se voir.',
 'At dawn, North Korean divisions cross the 38th parallel. Within four months, the war will draw in eleven countries and invent a new arena: jet-age air combat. For the first time, American and Soviet fighters face each other for real, even while pretending not to see one another.',
 NULL),
('1950-11-08', 1950, 'war',
 'Premier duel à réaction — F-86 contre MiG-15',
 'First jet duel — F-86 versus MiG-15',
 'Au-dessus de la rivière Yalu, un F-86 Sabre abat un MiG-15 : c''est le premier combat tournoyant entre deux avions à réaction de l''histoire. Dans la MiG Alley, le ciel tourne à 900 km/h. Les pilotes soviétiques volent sous un statut officiel nord-coréen. Tout le monde ment, mais chacun apprend la grammaire du dogfight moderne.',
 'Over the Yalu River, an F-86 Sabre shoots down a MiG-15: the first turning combat between two jet fighters in history. Over MiG Alley, the sky spins at 900 km/h. Soviet pilots fly under official North Korean cover. Everyone lies — but everyone learns the grammar of modern dogfighting.',
 NULL),
('1953-01-20', 1950, 'doctrine',
 'Doctrine Eisenhower — le New Look',
 'Eisenhower doctrine — the New Look',
 'Le général-président arrive à la Maison-Blanche avec une idée simple : on ne peut pas rivaliser avec l''Armée rouge soldat pour soldat, donc on misera sur l''arme atomique et l''aviation stratégique. Les budgets des bombardiers enflent, ceux de l''infanterie fondent. Le Strategic Air Command devient, pour une génération, le cœur de la doctrine américaine.',
 'The general-president walks into the White House with a simple idea: you cannot match the Red Army soldier for soldier, so you will bet on the atomic weapon and strategic aviation. Bomber budgets balloon, infantry budgets shrink. The Strategic Air Command becomes, for a generation, the heart of American doctrine.',
 NULL),
('1955-06-29', 1950, 'milestone',
 'B-52 Stratofortress — le bombardier éternel',
 'B-52 Stratofortress — the eternal bomber',
 'Le premier B-52B est livré à Castle AFB. Personne ne sait encore qu''il volera toujours soixante-dix ans plus tard. Conçu pour porter l''arme nucléaire jusqu''à Moscou à 15 km d''altitude, il va finir par bombarder la jungle vietnamienne, tirer des missiles de croisière sur Bagdad, et traquer Daech. Un seul cadre de cellule, sept doctrines.',
 'The first B-52B is delivered to Castle AFB. No one yet knows it will still be flying seventy years later. Designed to carry nuclear weapons to Moscow at 15 km altitude, it will end up bombing Vietnamese jungle, launching cruise missiles at Baghdad, and hunting ISIS. One airframe — seven doctrines.',
 (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress' LIMIT 1)),
('1957-10-04', 1950, 'rupture',
 'Spoutnik — le ciel passe à l''orbite',
 'Sputnik — the sky crosses into orbit',
 'Un bip-bip de 83 kilos tourne autour de la Terre. Les États-Unis découvrent, sidérés, que les Soviétiques peuvent faire survoler Washington par un objet qu''ils ne peuvent pas abattre. L''espace devient aussitôt le toit de l''aviation militaire : alerte avancée, reconnaissance, guidage. Le ciel ne s''arrête plus à la tropopause.',
 'An 83-kilo beep-beep orbits the Earth. The United States discovers, stunned, that the Soviets can fly an object over Washington that no one can shoot down. Space becomes, overnight, the roof of military aviation: early warning, reconnaissance, guidance. The sky no longer ends at the tropopause.',
 NULL),
('1958-07-29', 1950, 'doctrine',
 'Création de la NASA — la course à la Lune commence',
 'NASA is founded — the race to the Moon begins',
 'Eisenhower signe le National Aeronautics and Space Act. L''agence civile absorbe le NACA et hérite d''une mission : battre l''URSS dans l''espace. Elle va aussi, discrètement, former les pilotes et technologies qui nourriront les programmes militaires — du titane du SR-71 aux radars d''alerte précoce en passant par la guidance inertielle.',
 'Eisenhower signs the National Aeronautics and Space Act. The civilian agency absorbs NACA and inherits one mission: beat the USSR in space. It will also, quietly, train the pilots and grow the technologies that feed military programs — from the SR-71''s titanium to early-warning radars and inertial guidance.',
 NULL);

-- =============================================================================
--  1960s — Crises, Vietnam, supériorité technologique
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('1960-05-01', 1960, 'rupture',
 'U-2 de Gary Powers abattu au-dessus de Sverdlovsk',
 'Gary Powers'' U-2 shot down over Sverdlovsk',
 'À 21 000 mètres, là où les Soviétiques étaient réputés aveugles, un SA-2 coupe les ailes d''un U-2. Gary Powers s''éjecte, survit, passe à la télévision de Moscou. Eisenhower est forcé d''avouer. Le sommet Paris-Genève s''effondre. Le ciel très haut vient de perdre son immunité, et le Blackbird est déjà sur la planche à dessin.',
 'At 21,000 meters, where the Soviets were supposedly blind, an SA-2 clips the wings off a U-2. Gary Powers ejects, survives, ends up on Moscow television. Eisenhower is forced to confess. The Paris-Geneva summit collapses. The very-high sky has just lost its immunity — and the Blackbird is already on the drawing board.',
 NULL),
('1962-10-16', 1960, 'war',
 'Crise des missiles de Cuba — treize jours à l''altimètre',
 'Cuban Missile Crisis — thirteen days on the altimeter',
 'Un U-2 ramène des clichés : les Soviétiques installent des missiles nucléaires à 150 km de la Floride. Les B-52 passent en alerte permanente, les chasseurs de la Navy décollent en patrouille sur l''Atlantique, un U-2 est abattu au-dessus de Cuba. Pendant treize jours, le monde joue sa survie à la seconde près. On ne le dépassera plus jamais de si près.',
 'A U-2 brings back the pictures: the Soviets are installing nuclear missiles 150 km from Florida. B-52s shift to round-the-clock alert, Navy fighters launch Atlantic patrols, one U-2 is shot down over Cuba. For thirteen days, the world plays its survival down to the second. We will never come so close again.',
 NULL),
('1961-10-17', 1960, 'milestone',
 'Mirage III — la France prend son envol supersonique',
 'Mirage III — France enters the supersonic age',
 'Le premier escadron de chasse de l''Armée de l''air reçoit son Mirage IIIC. Delta pur, réacteur Atar, Mach 2 en palier : Dassault livre à la France un outil stratégique qui n''a rien à envier aux Américains. Exporté d''Israël à l''Australie, il fera de la firme une puissance aéronautique et armera la dissuasion nucléaire tactique française.',
 'The first Armée de l''air fighter squadron receives its Mirage IIIC. Pure delta, Atar engine, Mach 2 in level flight: Dassault gives France a strategic tool that owes nothing to the Americans. Exported from Israel to Australia, it will turn the firm into an aerospace power and arm France''s tactical nuclear deterrent.',
 (SELECT id FROM airplanes WHERE name = 'Mirage III' LIMIT 1)),
('1965-03-02', 1960, 'war',
 'Rolling Thunder — le ciel vietnamien en feu',
 'Rolling Thunder — the Vietnamese sky on fire',
 'Pendant trois ans et demi, l''US Air Force et la Navy vont jeter 864 000 tonnes de bombes sur le Nord-Vietnam. Les F-4 et F-105 affrontent des MiG-17 et MiG-21 pilotés par des vétérans et un réseau dense de SAM soviétiques. Les pertes sont lourdes, les leçons amères : il faudra réinventer la formation au dogfight. Topgun naîtra de Rolling Thunder.',
 'For three and a half years, the US Air Force and Navy will drop 864,000 tons of bombs on North Vietnam. F-4s and F-105s face MiG-17s and MiG-21s flown by veterans, backed by a dense Soviet SAM network. Losses are heavy, lessons are bitter: dogfight training will have to be reinvented. Topgun will be born out of Rolling Thunder.',
 (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II' LIMIT 1)),
('1966-01-22', 1960, 'tech',
 'SR-71 Blackbird — le reconnaissance à Mach 3',
 'SR-71 Blackbird — Mach 3 reconnaissance',
 'À Beale AFB, le premier SR-71A opérationnel rejoint l''escadron. Titanium brûlant, carburant JP-7 qui refroidit la cellule, vitesse de croisière Mach 3,2 à 24 kilomètres d''altitude : aucun missile sol-air n''arrivera jamais à le rattraper. Pendant vingt-quatre ans, il volera de la Baltique au Moyen-Orient sans jamais en perdre un seul au combat.',
 'At Beale AFB, the first operational SR-71A joins the squadron. Burning titanium, JP-7 fuel that cools the airframe, cruise speed Mach 3.2 at 24 km altitude: no SAM will ever catch it. For twenty-four years it will fly from the Baltic to the Middle East, without ever losing a single airframe to enemy fire.',
 (SELECT id FROM airplanes WHERE name = 'SR-71 Blackbird' LIMIT 1)),
('1967-06-05', 1960, 'war',
 'Guerre des Six Jours — le ciel arabe cloué au sol',
 'Six-Day War — the Arab sky nailed to the ground',
 'En moins de trois heures, l''opération Focus détruit quatre cents appareils égyptiens, syriens et jordaniens au sol. Les Mirage III et Mystère IV israéliens font le travail à basse altitude, en répétant dix fois leurs passes. Le ciel arabe s''éteint avant même d''avoir décollé. La leçon, retenue partout : la supériorité aérienne se gagne au premier jour, ou jamais.',
 'In under three hours, Operation Focus destroys four hundred Egyptian, Syrian and Jordanian aircraft on the ground. Israeli Mirage IIIs and Mystère IVs do the job at low altitude, rehearsing their passes ten times over. The Arab sky goes dark before it can take off. The lesson, learned everywhere: air superiority is won on day one, or never.',
 (SELECT id FROM airplanes WHERE name = 'Mirage III' LIMIT 1));

-- =============================================================================
--  1970s — Géométrie variable, électronique, fatigue stratégique
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('1970-12-21', 1970, 'tech',
 'F-14 Tomcat — le gardien des porte-avions',
 'F-14 Tomcat — guardian of the carriers',
 'Premier vol à Calverton : le Grumman F-14 entre en lice avec ses ailes à géométrie variable et son Phoenix AIM-54, un missile qui vise à 180 km. Sa mission tient en une phrase : empêcher qu''un bombardier soviétique équipé de missiles anti-navires n''arrive à portée de la flotte américaine. Il le fera pendant trente-cinq ans.',
 'First flight at Calverton: the Grumman F-14 arrives with variable-geometry wings and the Phoenix AIM-54, a missile that kills at 180 km. Its mission fits in a sentence: keep a Soviet bomber carrying anti-ship missiles from ever reaching the US fleet. It will do it for thirty-five years.',
 (SELECT id FROM airplanes WHERE name = 'F-14 Tomcat' LIMIT 1)),
('1972-12-18', 1970, 'war',
 'Linebacker II — onze nuits au-dessus de Hanoï',
 'Linebacker II — eleven nights over Hanoi',
 'Nixon envoie les B-52 raser Hanoï et Haïphong pour forcer Hanoi à signer. En onze nuits, 729 sorties, quinze B-52 perdus, plus de mille missiles SA-2 tirés. Le ciel du Nord-Vietnam s''illumine. Le 23 décembre, Hanoi revient à la table. Cette campagne restera longtemps le modèle — et la limite — des bombardements stratégiques de précision.',
 'Nixon sends the B-52s to flatten Hanoi and Haiphong to force North Vietnam to sign. In eleven nights: 729 sorties, fifteen B-52s lost, over a thousand SA-2s fired. The sky over North Vietnam lights up. On December 23rd, Hanoi comes back to the table. This campaign will remain, for years, the model — and the limit — of strategic precision bombing.',
 (SELECT id FROM airplanes WHERE name = 'B-52 Stratofortress' LIMIT 1)),
('1973-10-06', 1970, 'war',
 'Yom Kippour — les SAM réécrivent le combat aérien',
 'Yom Kippur — SAMs rewrite air combat',
 'Les SA-6 mobiles et SA-7 portatifs égyptiens dévorent les Phantom israéliens en quarante-huit heures. Pour la première fois, une force aérienne moderne perd la supériorité locale face à une bulle anti-aérienne électronique. La contre-mesure, la guerre électronique, le pod de brouillage : tout devient un volet essentiel de la doctrine occidentale.',
 'Mobile Egyptian SA-6s and man-portable SA-7s devour Israeli Phantoms in forty-eight hours. For the first time, a modern air force loses local superiority to an electronic air-defense bubble. Countermeasures, electronic warfare, jamming pods — all become essential pillars of Western doctrine.',
 (SELECT id FROM airplanes WHERE name = 'F-4 Phantom II' LIMIT 1)),
('1974-08-14', 1970, 'doctrine',
 'Panavia Tornado — l''Europe fait bloc',
 'Panavia Tornado — Europe closes ranks',
 'Premier vol à Manching : RFA, Royaume-Uni et Italie font voler ensemble un avion pensé pour pénétrer à très basse altitude sous les radars soviétiques. Géométrie variable, radar de suivi de terrain, pilotage à 200 pieds de nuit. Au-delà de la machine, c''est la preuve qu''une coopération européenne peut livrer un appareil de combat au lieu d''un simple prototype.',
 'First flight at Manching: West Germany, the UK and Italy fly together an aircraft built to penetrate very low under Soviet radar. Swing wings, terrain-following radar, 200 feet at night. Beyond the hardware, it is proof that European cooperation can deliver a combat aircraft and not just a prototype.',
 (SELECT id FROM airplanes WHERE name = 'Panavia Tornado' LIMIT 1)),
('1976-09-06', 1970, 'rupture',
 'Viktor Belenko pose son MiG-25 au Japon',
 'Viktor Belenko lands his MiG-25 in Japan',
 'À Hakodate, un chasseur soviétique se pose en catastrophe. C''est un MiG-25 Foxbat, l''oiseau qui faisait trembler l''OTAN depuis six ans. Le pilote Viktor Belenko fait défection. En soixante-dix jours de démontage, la CIA découvre une machine taillée pour l''intercepteur pur : acier au lieu de titane, moteurs brûlants, tubes électroniques. L''aura s''effondre.',
 'At Hakodate, a Soviet fighter makes an emergency landing. It is a MiG-25 Foxbat, the bird that has haunted NATO for six years. The pilot, Viktor Belenko, defects. In seventy days of disassembly, the CIA discovers a pure interceptor: steel instead of titanium, red-hot engines, vacuum tubes in the electronics. The aura collapses.',
 (SELECT id FROM airplanes WHERE name = 'MiG-25' LIMIT 1)),
('1979-12-24', 1970, 'war',
 'Invasion soviétique de l''Afghanistan',
 'Soviet invasion of Afghanistan',
 'À Noël, 30 000 parachutistes soviétiques atterrissent à Kaboul en Il-76. Commence une guerre de dix ans qui, à partir de 1986, va se transformer en piège aérien : les Stinger américains livrés aux moudjahidines abattront des centaines de Mi-24 et Su-25. Le ciel afghan deviendra le Vietnam soviétique. La leçon portera loin.',
 'On Christmas Eve, 30,000 Soviet paratroopers land in Kabul aboard Il-76s. A ten-year war begins, which from 1986 on will turn into an air trap: US-supplied Stingers delivered to the mujahideen shoot down hundreds of Mi-24s and Su-25s. The Afghan sky becomes the Soviet Vietnam. The lesson will carry far.',
 (SELECT id FROM airplanes WHERE name = 'Su-25' LIMIT 1));

-- =============================================================================
--  1980s — La haute technologie entre en guerre
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('1981-06-07', 1980, 'war',
 'Opération Opéra — raid sur Osirak',
 'Operation Opera — raid on Osirak',
 'Huit F-16 et six F-15 israéliens traversent mille kilomètres de désert en silence radio. Leurs cibles : le réacteur Osirak près de Bagdad. En deux minutes, seize bombes MK-84 pulvérisent l''infrastructure nucléaire irakienne. La doctrine de la frappe préventive contre la prolifération nucléaire vient de prendre forme — et personne n''oubliera.',
 'Eight Israeli F-16s and six F-15s cross a thousand kilometers of desert in radio silence. Their target: the Osirak reactor near Baghdad. In two minutes, sixteen MK-84 bombs pulverize Iraq''s nuclear infrastructure. The doctrine of preventive strike against proliferation has just taken shape — and no one will forget.',
 (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon' LIMIT 1)),
('1982-05-01', 1980, 'war',
 'Malouines — le retour des porte-avions',
 'Falklands — the carriers come back',
 'Dans un hiver austral, deux petits porte-avions britanniques font voler des Sea Harrier à décollage vertical. Face à eux, l''aviation argentine utilise des Mirage III, des A-4 Skyhawk et des Super Étendard armés d''Exocet. La Royal Navy perd des navires mais gagne le ciel. Sans les vingt-huit Harrier, pas de reconquête possible.',
 'In the southern winter, two small British carriers fly vertical-launch Sea Harriers. Against them, the Argentine air arm throws Mirage IIIs, A-4 Skyhawks and Exocet-armed Super Étendards. The Royal Navy loses ships but wins the sky. Without the twenty-eight Harriers, retaking the islands would have been impossible.',
 (SELECT id FROM airplanes WHERE name = 'BAE Sea Harrier' LIMIT 1)),
('1983-03-23', 1980, 'doctrine',
 'Reagan annonce SDI — la guerre des étoiles',
 'Reagan announces SDI — Star Wars',
 'Dans une allocution télévisée, le président américain propose de rendre les missiles nucléaires « impuissants et obsolètes » par un bouclier spatial. Techniquement irréaliste, l''annonce agit pourtant comme une bombe stratégique : Moscou dépense des milliards pour tenter de suivre, et s''épuise. La course au dessus de l''atmosphère vient de changer de nature.',
 'In a televised address, the US president proposes to make nuclear missiles "impotent and obsolete" via a space-based shield. Technically unrealistic, the announcement still lands like a strategic bomb: Moscow pours billions trying to keep up, and exhausts itself. The race above the atmosphere has just changed character.',
 NULL),
('1986-04-15', 1980, 'war',
 'El Dorado Canyon — frapper Kadhafi depuis l''Angleterre',
 'El Dorado Canyon — striking Gaddafi from England',
 'Paris et Madrid refusent le survol. Les F-111 américains décollent de Lakenheath, contournent la France, ravitaillent sept fois en vol et frappent Tripoli à minuit. Dix-huit heures d''opération pour quatre minutes au-dessus de la cible. La projection aérienne à très longue portée entre dans une nouvelle ère : partout, tout le temps, même quand les alliés ferment la porte.',
 'Paris and Madrid refuse overflight. American F-111s launch from Lakenheath, swing around France, refuel seven times in the air, and hit Tripoli at midnight. Eighteen hours of operation for four minutes over target. Long-range power projection enters a new era: anywhere, anytime, even when allies shut the door.',
 (SELECT id FROM airplanes WHERE name = 'F-111 Aardvark' LIMIT 1)),
('1988-07-17', 1980, 'tech',
 'B-2 Spirit dévoilé — la furtivité devient volante',
 'B-2 Spirit unveiled — stealth takes wing',
 'À Palmdale, Northrop tire le rideau sur une aile volante noire, le B-2 Spirit. Conçu pour pénétrer le ciel soviétique le plus défendu et frapper les silos mobiles, il combine forme de Flying Wing des années 40, matériaux absorbants et informatique lourde. La furtivité quitte les prototypes noirs pour devenir, discrètement, la colonne vertébrale du bombardement stratégique.',
 'At Palmdale, Northrop pulls back the curtain on a black flying wing, the B-2 Spirit. Built to penetrate the most defended Soviet airspace and hit mobile silos, it combines 1940s Flying Wing shapes, radar-absorbent materials, and heavy computing. Stealth leaves the black prototypes and quietly becomes the backbone of strategic bombing.',
 (SELECT id FROM airplanes WHERE name = 'B-2 Spirit' LIMIT 1)),
('1989-11-09', 1980, 'rupture',
 'Chute du mur de Berlin — l''ennemi désigné s''efface',
 'Fall of the Berlin Wall — the designated enemy fades',
 'À Berlin, la foule perce le mur. Dans les mois qui suivent, le Pacte de Varsovie se dissout. Pour toute une génération de chasseurs conçus pour la troisième guerre mondiale — F-15, Tornado, Mirage 2000, MiG-29 — l''adversaire pour lequel ils ont été dessinés n''existe plus. Les doctrines, les budgets, la géographie stratégique, tout est à réécrire.',
 'In Berlin, the crowd breaks through the Wall. Within months, the Warsaw Pact dissolves. For an entire generation of fighters designed for World War III — F-15, Tornado, Mirage 2000, MiG-29 — the adversary they were drawn for no longer exists. Doctrines, budgets, strategic geography: it all has to be rewritten.',
 (SELECT id FROM airplanes WHERE name = 'MiG-29' LIMIT 1));

-- =============================================================================
--  1990s — Le nouvel ordre, la précision, le ciel unipolaire
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('1991-01-17', 1990, 'war',
 'Tempête du Désert — la guerre high-tech',
 'Desert Storm — the high-tech war',
 'À 3 h du matin, les premiers F-117 furtifs entrent dans le ciel de Bagdad et frappent les centraux téléphoniques. En six semaines, 118 000 sorties de combat, des Tomahawk, des JDAM avant l''heure, des AWACS qui voient tout. Le monde regarde en direct, sur CNN, la démonstration d''une supériorité aérienne qu''aucune armée hors des États-Unis ne peut plus égaler.',
 'At 3 AM, the first stealth F-117s enter the skies over Baghdad and hit the telephone exchanges. In six weeks: 118,000 combat sorties, Tomahawks, pre-JDAM precision munitions, AWACS seeing everything. The world watches, live on CNN, the demonstration of an air superiority no one outside the United States can match anymore.',
 (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle' LIMIT 1)),
('1991-12-26', 1990, 'rupture',
 'Fin de l''URSS — le monde perd sa symétrie',
 'End of the USSR — the world loses its symmetry',
 'Le drapeau rouge descend du Kremlin à 19 h 32. Le complexe militaro-industriel soviétique se disloque. Des Su-27 et MiG-29 sont bradés à l''export, des pilotes partent en exil, des bureaux d''études ferment ou fusionnent. Pendant dix ans, il n''y aura plus de grande puissance adverse dans le ciel. La sieste stratégique occidentale commence.',
 'The red flag comes down from the Kremlin at 7:32 PM. The Soviet military-industrial complex falls apart. Su-27s and MiG-29s get sold cheap, pilots go into exile, design bureaus close or merge. For ten years, there will be no great-power opponent in the sky. The Western strategic nap begins.',
 (SELECT id FROM airplanes WHERE name = 'Su-27' LIMIT 1)),
('1995-08-30', 1990, 'war',
 'Deliberate Force — l''OTAN tire les premiers missiles',
 'Deliberate Force — NATO fires its first missiles',
 'Sur les collines de Bosnie, l''OTAN lance sa première véritable opération de combat. Pendant deux semaines, 3 515 sorties, Mirage 2000, Tornado, F-16, F/A-18 frappent de concert. La chute de l''enclave de Srebrenica avait tétanisé les chancelleries. L''air reprend l''initiative : dix-huit jours après les premiers tirs, les Serbes bosniaques acceptent de négocier.',
 'On the hills of Bosnia, NATO launches its first real combat operation. For two weeks: 3,515 sorties, Mirage 2000s, Tornadoes, F-16s, F/A-18s strike together. The fall of Srebrenica had paralyzed chanceries. Air power seizes the initiative: eighteen days after the first shots, the Bosnian Serbs accept negotiations.',
 (SELECT id FROM airplanes WHERE name = 'Mirage 2000' LIMIT 1)),
('1997-09-07', 1990, 'tech',
 'F-22 Raptor — premier vol',
 'F-22 Raptor — first flight',
 'Le prototype YF-22 s''élève enfin en version de production. Cinq générations de moteurs, super-croisière à Mach 1,8 sans postcombustion, radar AESA, furtivité intégrale. Aucun chasseur au monde ne s''en approchera pendant vingt ans. Mais le Raptor naîtra aussi comme un ovni politique : produit à 187 exemplaires seulement, jamais exporté.',
 'The YF-22 prototype finally climbs in its production form. Five engine generations, supercruise at Mach 1.8 without afterburner, AESA radar, full stealth. No other fighter in the world will come close for twenty years. But the Raptor is also born as a political oddity: only 187 will be built, never exported.',
 (SELECT id FROM airplanes WHERE name = 'F-22 Raptor' LIMIT 1)),
('1999-03-24', 1990, 'war',
 'Allied Force — 78 jours au-dessus de la Serbie',
 'Allied Force — 78 days over Serbia',
 'L''OTAN bombarde la Yougoslavie sans mandat ONU. 38 000 sorties, 10 484 munitions guidées, deux F-117 touchés — dont un abattu par un vieux SA-3 serbe. La furtivité n''est donc pas absolue. Mais l''essentiel est ailleurs : une guerre gagnée entièrement depuis le ciel, sans une seule troupe au sol de l''OTAN. Un précédent stratégique.',
 'NATO bombs Yugoslavia without a UN mandate. 38,000 sorties, 10,484 guided munitions, two F-117s hit — one shot down by an ancient Serbian SA-3. Stealth is not absolute. But the main point is elsewhere: a war won entirely from the sky, without a single NATO soldier on the ground. A strategic precedent.',
 NULL),
('1998-08-07', 1990, 'doctrine',
 'Attentats de Nairobi et Dar es Salaam — l''ère nouvelle',
 'Nairobi and Dar es Salaam bombings — a new era',
 'Deux ambassades américaines en Afrique de l''Est explosent à quelques minutes d''intervalle. Al-Qaïda sort de l''ombre. Treize jours plus tard, Clinton fait tirer 75 Tomahawk sur des camps en Afghanistan et sur une usine soudanaise. La réponse est aérienne, à longue portée, sans humains au-dessus de la cible. Le modèle du contre-terrorisme par le ciel est né.',
 'Two US embassies in East Africa explode minutes apart. Al-Qaeda steps out of the shadows. Thirteen days later, Clinton orders 75 Tomahawks against Afghan camps and a Sudanese factory. The answer is aerial, long-range, with no humans over target. The model of counter-terrorism from the sky is born.',
 NULL);

-- =============================================================================
--  2000s — Le 11 septembre, deux guerres, l'aviation en appui permanent
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('2001-09-11', 2000, 'rupture',
 '11 Septembre — le ciel redevient front',
 '9/11 — the sky becomes a front again',
 'Quatre avions de ligne deviennent des armes. Deux s''encastrent dans les tours jumelles, un dans le Pentagone, un s''écrase en Pennsylvanie. Pour la première fois depuis Pearl Harbor, le territoire américain continental est frappé. Les F-15 décollent à blanc. Aucun n''arrivera à temps. Le ciel civil et le ciel militaire fusionnent en moins de deux heures.',
 'Four airliners become weapons. Two slam into the Twin Towers, one into the Pentagon, one falls in Pennsylvania. For the first time since Pearl Harbor, the continental United States is struck. F-15s scramble. None arrive in time. Civil and military skies fuse in under two hours.',
 NULL),
('2001-10-07', 2000, 'war',
 'Enduring Freedom — Afghanistan vu du ciel',
 'Enduring Freedom — Afghanistan seen from the sky',
 'Les B-52 et B-1 américains frappent les camps talibans. Les forces spéciales guident les bombes GPS depuis le sol à cheval. En trois mois, le régime taliban s''effondre — la campagne est quasi exclusivement aérienne, combinée à une poignée d''hommes. La formule « SOF + air » deviendra le modèle de deux décennies d''intervention occidentale.',
 'US B-52s and B-1s hit Taliban camps. Special forces guide GPS bombs from the ground, on horseback. In three months, the Taliban regime collapses — the campaign is almost entirely aerial, combined with a handful of men. The "SOF + air" formula will become the model for two decades of Western intervention.',
 (SELECT id FROM airplanes WHERE name = 'B-1 Lancer' LIMIT 1)),
('2003-03-20', 2000, 'war',
 'Iraqi Freedom — Bagdad en trois semaines',
 'Iraqi Freedom — Baghdad in three weeks',
 'Le 20 mars à 5 h 34 heure locale, les premiers F-117 et Tomahawk attaquent des palais à Bagdad. Vingt-et-un jours plus tard, les chars américains roulent place Firdos. Le ciel irakien, saturé d''AWACS et de JSTARS, ne fait plus la différence entre Air Force et Navy. La haute supériorité occidentale atteint son apogée. Ce sera aussi le dernier moment simple.',
 'On March 20 at 5:34 AM local, the first F-117s and Tomahawks hit palaces in Baghdad. Twenty-one days later, American tanks roll into Firdos Square. The Iraqi sky, saturated with AWACS and JSTARS, no longer distinguishes Air Force from Navy. Western high-end superiority hits its peak. It will also be the last simple moment.',
 (SELECT id FROM airplanes WHERE name = 'F-15E Strike Eagle' LIMIT 1)),
('2005-12-15', 2000, 'milestone',
 'F-22 Raptor — capacité opérationnelle initiale',
 'F-22 Raptor — initial operational capability',
 'À Langley, le 27e Escadron de chasse déclare la capacité opérationnelle initiale. Une machine à 150 millions de dollars l''unité, sans équivalent mondial, entre en alerte. Paradoxe historique : juste au moment où les États-Unis basculent dans la guerre asymétrique en Irak et Afghanistan, ils mettent en service le chasseur le plus sophistiqué jamais construit.',
 'At Langley, the 27th Fighter Squadron declares initial operational capability. A machine worth 150 million dollars apiece, with no peer in the world, stands alert. A historical paradox: just as the United States plunges into asymmetric warfare in Iraq and Afghanistan, it puts into service the most sophisticated fighter ever built.',
 (SELECT id FROM airplanes WHERE name = 'F-22 Raptor' LIMIT 1)),
('2007-06-27', 2000, 'milestone',
 'Rafale — le standard F3 entre en service',
 'Rafale — the F3 standard enters service',
 'Le Rafale B atteint le standard F3 : frappe nucléaire tactique, reconnaissance, anti-navire, tout dans une seule cellule. Dassault livre enfin à la France l''avion polyvalent qui remplace Jaguar, Mirage F1, Mirage IV-P et Super Étendard d''un coup. Il faudra attendre l''Égypte (2015) et l''Inde (2016) pour que l''export décolle vraiment.',
 'The Rafale B reaches the F3 standard: tactical nuclear strike, reconnaissance, anti-ship, all in a single airframe. Dassault finally delivers to France the multi-role aircraft that replaces Jaguar, Mirage F1, Mirage IV-P and Super Étendard at once. It will take Egypt (2015) and India (2016) for exports to really take off.',
 (SELECT id FROM airplanes WHERE name = 'Rafale' LIMIT 1)),
('2008-08-08', 2000, 'war',
 'Géorgie — la Russie retrouve le ciel',
 'Georgia — Russia returns to the sky',
 'Pendant cinq jours, les Su-25 et Tu-22M russes bombardent Gori, Tskhinvali, le port de Poti. Sept avions sont perdus, en partie à cause des Buk géorgiens. Le bilan est militaire, mais surtout symbolique : après quinze ans d''effondrement, Moscou redéploie sa chasse hors de ses frontières. L''Ouest ne l''a pas vu venir. Il mettra huit ans à intégrer la leçon.',
 'For five days, Russian Su-25s and Tu-22Ms bomb Gori, Tskhinvali, the port of Poti. Seven aircraft are lost, partly to Georgian Buks. The military tally is modest, but the symbolic one is not: after fifteen years of collapse, Moscow is deploying air combat beyond its borders again. The West does not see it coming. It will take eight years to absorb the lesson.',
 (SELECT id FROM airplanes WHERE name = 'Su-25' LIMIT 1));

-- =============================================================================
--  2010s — Le retour de la haute intensité, la 5e génération, les drones
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('2011-01-11', 2010, 'rupture',
 'J-20 — la Chine entre dans la 5e génération',
 'J-20 — China enters the fifth generation',
 'À Chengdu, un prototype noir de Chengdu J-20 effectue son premier vol pendant la visite du secrétaire américain à la Défense. L''effet est maximal. Vingt ans d''espionnage industriel, d''achat de Su-27, de rétro-ingénierie et d''investissements massifs débouchent sur un chasseur furtif de grande dimension. La domination américaine de la haute technologie cesse d''être un acquis.',
 'At Chengdu, a black Chengdu J-20 prototype takes its first flight during the US Secretary of Defense''s visit. The effect is maximal. Twenty years of industrial espionage, Su-27 purchases, reverse engineering and massive investment deliver a large-format stealth fighter. American high-tech dominance stops being a given.',
 (SELECT id FROM airplanes WHERE name = 'Chengdu J-20' LIMIT 1)),
('2011-03-19', 2010, 'war',
 'Harmattan — la France tire les premières missiles en Libye',
 'Harmattan — France fires the first shots in Libya',
 'À 17 h 45, des Rafale français frappent une colonne de chars de Kadhafi devant Benghazi. C''est la première fois qu''ils tirent en situation réelle. La coalition OTAN prend la suite. Sept mois plus tard, Tripoli tombe. Le ciel libyen aura été cent pour cent aérien : aucun soldat occidental au sol.',
 'At 5:45 PM, French Rafales hit a Gaddafi tank column outside Benghazi. It is the first time they fire in a real-world engagement. The NATO coalition picks up from there. Seven months later, Tripoli falls. The Libyan war will have been one hundred percent aerial: not a single Western soldier on the ground.',
 (SELECT id FROM airplanes WHERE name = 'Rafale' LIMIT 1)),
('2014-02-27', 2010, 'rupture',
 'Crimée — la guerre hybride prend son envol',
 'Crimea — hybrid warfare takes wing',
 'Des « hommes verts » sans insignes prennent le Parlement de Simferopol. Au-dessus, des Su-27 patrouillent, des Il-76 déversent des troupes. En quelques jours, la Crimée bascule. Pas de déclaration de guerre, pas de frappe massive, mais une projection aérienne discrète qui crée le fait accompli. L''OTAN se retrouve à court de mots et de réflexes.',
 'Insigniless "little green men" take the Parliament in Simferopol. Above them, Su-27s patrol, Il-76s pour in troops. Within days, Crimea flips. No declaration of war, no massive strike, but a quiet aerial projection that creates the fait accompli. NATO finds itself short on words and reflexes.',
 (SELECT id FROM airplanes WHERE name = 'Su-27' LIMIT 1)),
('2014-08-08', 2010, 'war',
 'Inherent Resolve — la coalition anti-Daech dans le ciel syro-irakien',
 'Inherent Resolve — anti-ISIS coalition over Syria and Iraq',
 'Les F/A-18 de l''USS George H.W. Bush frappent des colonnes de Daech près d''Erbil. Français, Britanniques, Jordaniens, Canadiens, Australiens, Émiratis rejoignent. En cinq ans, plus de 30 000 frappes aériennes. C''est la première grande campagne de frappes coalition-de-dix-pays de l''ère post-11 Septembre. Mais la victoire militaire laisse un terrain politique vide.',
 'F/A-18s from USS George H.W. Bush strike ISIS columns near Erbil. France, the UK, Jordan, Canada, Australia, the UAE join in. In five years, over 30,000 air strikes. It is the first large ten-nation-coalition strike campaign of the post-9/11 era. But the military victory leaves a political vacuum behind.',
 (SELECT id FROM airplanes WHERE name = 'Rafale' LIMIT 1)),
('2015-09-30', 2010, 'war',
 'La Russie entre en Syrie — retour du pôle oriental',
 'Russia enters Syria — the eastern pole returns',
 'Hmeimim, plateau côtier syrien : 34 appareils russes, Su-24, Su-25, Su-30SM, Su-34 débarquent en quelques semaines. En deux ans, près de 40 000 sorties. C''est le premier déploiement expéditionnaire russe hors de l''ex-URSS depuis 1989. Moscou teste en réel les systèmes bloqués pendant vingt ans. L''équation stratégique du Moyen-Orient bascule.',
 'Hmeimim, a Syrian coastal plateau: 34 Russian aircraft, Su-24s, Su-25s, Su-30SMs, Su-34s arrive within weeks. In two years, nearly 40,000 sorties. This is the first Russian expeditionary deployment outside the former USSR since 1989. Moscow combat-tests systems that have been frozen for twenty years. The Middle East''s strategic balance tilts.',
 (SELECT id FROM airplanes WHERE name = 'Su-34' LIMIT 1)),
('2018-05-22', 2010, 'milestone',
 'F-35 au combat — baptême du feu israélien',
 'F-35 in combat — Israeli baptism of fire',
 'Le chef d''état-major israélien l''annonce en conférence : l''Adir, version locale du F-35A, a déjà mené deux frappes réelles, probablement au-dessus de la Syrie ou du Liban. C''est la première confirmation d''un emploi au combat d''un chasseur de 5e génération hors des États-Unis. La guerre électronique du ciel moyen-oriental entre dans une nouvelle ère.',
 'The Israeli chief of staff announces it at a conference: the Adir, the local F-35A, has already carried out two real strikes, probably over Syria or Lebanon. It is the first confirmed combat use of a fifth-generation fighter outside the United States. Electronic warfare in the Middle Eastern sky enters a new era.',
 (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II' LIMIT 1));

-- =============================================================================
--  2020s — Ukraine, drones, 6e génération en vue
-- =============================================================================

INSERT INTO timeline_events (event_date, era_decade, kind, title_fr, title_en, body_fr, body_en, airplane_id) VALUES
('2020-01-03', 2020, 'rupture',
 'Bagdad — un MQ-9 tue le général Soleimani',
 'Baghdad — an MQ-9 kills General Soleimani',
 'À 00 h 47, deux missiles Hellfire tirés par un drone MQ-9 Reaper pulvérisent le convoi du général iranien Qassem Soleimani sur la route de l''aéroport. C''est la première fois qu''une puissance nucléaire élimine ouvertement un chef militaire étranger de haut rang par voie aérienne. Le monde retient son souffle ; la réplique iranienne se limitera à des missiles sur deux bases américaines.',
 'At 12:47 AM, two Hellfire missiles fired by an MQ-9 Reaper obliterate Iranian General Qassem Soleimani''s convoy on the airport road. It is the first time a nuclear power openly eliminates a foreign senior military leader from the air. The world holds its breath; the Iranian reply is limited to missiles on two American bases.',
 NULL),
('2020-09-27', 2020, 'rupture',
 'Haut-Karabagh — les Bayraktar réécrivent la guerre',
 'Nagorno-Karabakh — Bayraktars rewrite warfare',
 'Pendant 44 jours, les drones turcs Bayraktar TB2 azerbaïdjanais filment la destruction de la DCA, de l''artillerie et des chars arméniens. Les vidéos inondent Internet. Pour 5 millions de dollars pièce, ces drones font ce que des Su-25 faisaient pour 20 millions. Partout, les états-majors étudient les images : la guerre aérienne vient de bifurquer.',
 'For 44 days, Azerbaijani Turkish-built Bayraktar TB2 drones film the destruction of Armenian air defense, artillery and armor. The videos flood the internet. For five million dollars apiece, these drones do what Su-25s used to do for twenty. Across the world, general staffs study the footage: aerial warfare has just forked.',
 NULL),
('2022-02-24', 2020, 'war',
 'Invasion de l''Ukraine — la haute intensité revient en Europe',
 'Invasion of Ukraine — high-intensity war returns to Europe',
 'À 4 h du matin, Kyiv entend les premières sirènes. La Russie lance 160 appareils et des centaines de missiles. Mais le ciel ukrainien résiste : les MiG-29 tiennent, les Buk abattent des Su-34 et des Ka-52. Trois ans plus tard, aucune des deux aviations n''a gagné la supériorité aérienne. Un nouveau modèle émerge : la guerre aérienne contestée, durable, électroniquement saturée.',
 'At 4 AM, Kyiv hears the first sirens. Russia launches 160 aircraft and hundreds of missiles. But the Ukrainian sky holds: MiG-29s stay up, Buks shoot down Su-34s and Ka-52s. Three years later, neither air force has secured air superiority. A new pattern emerges: contested air warfare, sustained, electronically saturated.',
 (SELECT id FROM airplanes WHERE name = 'Su-34' LIMIT 1)),
('2023-10-07', 2020, 'war',
 '7 octobre — Tsahal reprend le ciel gazaoui',
 'October 7 — the IDF retakes the Gazan sky',
 'Après l''attaque du Hamas, Israël lance l''opération « Glaives de Fer ». En trois mois, les F-15I, F-16I et F-35I saturent le ciel de Gaza. Les bases aériennes israéliennes tournent 24 heures sur 24. C''est la campagne aérienne la plus dense pour un théâtre aussi petit de l''histoire militaire moderne. Elle redessine les limites morales, politiques et techniques du bombardement urbain.',
 'After the Hamas attack, Israel launches Operation Iron Swords. In three months, F-15Is, F-16Is and F-35Is saturate the Gaza sky. Israeli air bases run around the clock. It is the densest aerial campaign for such a small theater in modern military history. It redraws the moral, political and technical limits of urban bombing.',
 (SELECT id FROM airplanes WHERE name = 'F-35 Lightning II' LIMIT 1)),
('2024-08-06', 2020, 'milestone',
 'F-16 livrés à l''Ukraine',
 'F-16s delivered to Ukraine',
 'À un aérodrome ukrainien dont le nom reste secret, les premiers F-16 livrés par la coalition entrent officiellement en service. L''avion de chasse occidental le plus produit rejoint un camp qui se bat depuis 900 jours. Ils ne retourneront pas la guerre, mais marquent un cap : une flotte soviétique est officiellement remplacée en temps de guerre, par l''Ouest. Le ciel post-1991 a définitivement changé.',
 'At an Ukrainian airfield whose name is kept secret, the first coalition-supplied F-16s officially enter service. The most-produced Western fighter joins a side that has been fighting for 900 days. They will not turn the war, but they mark a threshold: a Soviet fleet is officially replaced in wartime, by the West. The post-1991 sky has changed for good.',
 (SELECT id FROM airplanes WHERE name = 'F-16 Fighting Falcon' LIMIT 1)),
('2024-03-15', 2020, 'tech',
 'NGAD, FCAS, Tempest — la 6e génération prend forme',
 'NGAD, FCAS, Tempest — the sixth generation takes shape',
 'Les trois grands programmes de 6e génération s''approchent du choix industriel : NGAD pour les États-Unis, FCAS pour France/Allemagne/Espagne, GCAP/Tempest pour le Royaume-Uni, l''Italie et le Japon. Au cœur, une idée commune : un chasseur habité piloté au milieu d''un essaim de drones loyaux. La doctrine du pilote unique à bord qui écrase l''adversaire s''achève. Le ciel de 2040 sera collectif.',
 'The three great sixth-generation programs are approaching industrial commitment: NGAD for the United States, FCAS for France/Germany/Spain, GCAP/Tempest for the UK, Italy and Japan. At the core, a shared idea: a manned fighter piloted in the middle of a swarm of loyal drones. The doctrine of the lone pilot crushing the enemy is ending. The sky of 2040 will be collective.',
 NULL);

-- =============================================================================
--  Fin du fichier timeline_events.sql — 54 événements insérés.
-- =============================================================================
