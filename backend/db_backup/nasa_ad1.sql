-- NASA AD-1 (Ames-Dryden-1)
--
-- Photo : AD-1 in flight (EC81-15846).jpg
--   licence Public domain — NASA Armstrong Flight Research Center / NASA/Bob Rhine
--   https://commons.wikimedia.org/wiki/File:AD-1_in_flight_(EC81-15846).jpg

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
    'NASA AD-1',
    'NASA AD-1',
    'NASA AD-1 (Ames-Dryden-1)',
    'NASA AD-1 (Ames-Dryden-1)',
    'Petit jet en fibre de verre dont l''aile d''un seul tenant pivotait en biais jusqu''à 60 degrés',
    'A small fibreglass jet whose one-piece wing pivoted obliquely up to 60 degrees',
    '/assets/airplanes/nasa-ad1.jpg',
    E'## Genèse\nL''idée d''une aile oblique, qui pivote d''un seul bloc autour de son centre, remonte au **Blohm & Voss P.202** proposé par **Richard Vogt** en 1942. À la NASA, l''ingénieur **Robert T. Jones** la reprend au centre de recherche Ames : ses calculs et ses essais en soufflerie montrent qu''un avion de transport à aile oblique, volant jusqu''à Mach 1,4, ferait nettement mieux qu''avec une voilure classique. Au décollage et à l''atterrissage, l''aile resterait perpendiculaire au fuselage ; en accélérant, elle pivoterait jusqu''à 60 degrés pour réduire la traînée et la consommation. Pour valider la formule à basse vitesse, la NASA commande un petit avion d''essai, l''**AD-1**, pour Ames-Dryden-1.\n\n## Conception\nLa NASA fixe la configuration d''après une étude de Boeing Commercial Airplanes ; la Rutan Aircraft Factory de **Burt Rutan**, à Mojave, en assure le dessin détaillé et le calcul des charges sous le nom de Model 35. Construit par **Ames Industrial**, à Bohemia (New York), pour un contrat à prix fixe de 240 000 dollars, l''appareil est livré à Dryden en février 1979. Sa structure associe une peau en fibre de verre et une âme en mousse rigide ; deux petits turboréacteurs Microturbo TRS 18, ceux du BD-5J, le propulsent, et sa vitesse est limitée par sécurité à environ 270 km/h. Un mécanisme électrique placé devant les moteurs fait pivoter l''aile, extrémité droite vers l''avant. Son train fixe, plaqué contre le fuselage, lui donne au sol une allure accroupie.\n\n## Essais\nLe pilote de recherche de la NASA **Thomas C. McMurtry** effectue le premier vol le 21 décembre 1979 ; **Pete Knight** participe lui aussi au programme. L''angle de l''aile augmente par étapes pendant dix-huit mois, jusqu''aux 60 degrés atteints au milieu de 1981, puis les vols se poursuivent un an à différentes vitesses et positions d''aile. Le dernier vol, le 7 août 1982, n''a pas lieu à Dryden mais au salon de l''Experimental Aircraft Association à Oshkosh, où l''AD-1 vole huit fois devant le public. Le programme totalise 79 vols.\n\n## Place dans l''histoire\nL''AD-1 prouve qu''une aile oblique fonctionne, mais en révèle aussi les limites : au-delà de 45 degrés, la souplesse de l''aile en fibre de verre et le couplage tangage-roulis dégradent la maniabilité. Une structure plus rigide ou de meilleures commandes auraient corrigé ces défauts, et il faudrait encore un avion transsonique pour étudier les effets de la compressibilité. Jones continue de croire à la formule pour les grands transports transocéaniques. L''AD-1 est aujourd''hui exposé au Hiller Aviation Museum de San Carlos, en Californie.',
    E'## Genesis\nThe idea of an oblique wing, pivoting in one piece about its centre, goes back to the **Blohm & Voss P.202** proposed by **Richard Vogt** in 1942. At NASA, engineer **Robert T. Jones** took it up at the Ames Research Center: his analyses and wind tunnel tests showed that an oblique-wing transport flying at up to Mach 1.4 would perform substantially better than with conventional wings. For take-off and landing the wing would sit perpendicular to the fuselage; as speed rose, it would pivot up to 60 degrees to cut drag and fuel burn. To validate the concept at low speed, NASA ordered a small test aircraft, the **AD-1**, for Ames-Dryden-1.\n\n## Design\nNASA set the configuration from a study by Boeing Commercial Airplanes; **Burt Rutan**''s Rutan Aircraft Factory at Mojave produced the detailed design and load analysis under the name Model 35. Built by **Ames Industrial** of Bohemia, New York, under a $240,000 fixed-price contract, the aircraft was delivered to Dryden in February 1979. Its structure combined a fibreglass skin with a rigid foam core; two small Microturbo TRS 18 turbojets, as used on the BD-5J, powered it, and its speed was limited for safety to about 270 km/h. An electrically driven mechanism ahead of the engines pivoted the wing, right wingtip forward. Its fixed landing gear, mounted close to the fuselage, gave it a squat look on the ground.\n\n## Testing\nNASA research pilot **Thomas C. McMurtry** made the first flight on 21 December 1979; **Pete Knight** also took part in the programme. The wing angle was increased step by step over eighteen months until the full 60 degrees was reached in mid-1981, then flying continued for another year at various speeds and wing angles. The last flight, on 7 August 1982, took place not at Dryden but at the Experimental Aircraft Association show at Oshkosh, where the AD-1 flew eight times in front of the public. The programme totalled 79 flights.\n\n## Place in history\nThe AD-1 proved that an oblique wing works, but also showed its limits: beyond 45 degrees, the flexibility of the fibreglass wing and pitch-roll coupling degraded handling. A stiffer structure or better controls would have cured these faults, and a transonic aircraft was still needed to study compressibility effects. Jones still believed in the concept for large transoceanic transports. The AD-1 is now on display at the Hiller Aviation Museum in San Carlos, California.',
    (SELECT id FROM countries WHERE code = 'USA'),
    NULL,
    '1979-12-21',
    NULL,
    320,
    NULL,
    (SELECT id FROM manufacturer WHERE code = 'AMI'),
    (SELECT id FROM generation WHERE generation = 4),
    (SELECT id FROM type WHERE name = 'Recherche'),
    'Retiré',
    'Retired'
);

-- Technologies
INSERT INTO airplane_tech (id_airplane, id_tech) VALUES
((SELECT id FROM airplanes WHERE name = 'NASA AD-1'), (SELECT id FROM tech WHERE name = 'Aile oblique')),
((SELECT id FROM airplanes WHERE name = 'NASA AD-1'), (SELECT id FROM tech WHERE name = 'Matériaux composites'));

-- Missions
INSERT INTO airplane_missions (id_airplane, id_mission) VALUES
((SELECT id FROM airplanes WHERE name = 'NASA AD-1'), (SELECT id FROM missions WHERE name = 'Essais en vol'));

-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),
-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.
BEGIN;

UPDATE airplanes SET
  -- Strate 1 : fiche technique étendue
  length            = 11.83,
  wingspan          = 9.85,
  height            = 2.06,
  wing_area         = 8.6,
  empty_weight      = 658,
  mtow              = 973,
  service_ceiling   = 3700,
  climb_rate        = NULL,
  g_limit_pos       = NULL,
  g_limit_neg       = NULL,
  combat_radius     = NULL,
  crew              = 1,

  -- Strate 2 : motorisation
  engine_name       = 'Microturbo TRS 18-046',
  engine_count      = 2,
  engine_type       = 'Turboréacteur',
  engine_type_en    = 'Turbojet',
  thrust_dry        = 0.98,
  thrust_wet        = NULL,

  -- Strate 3 : production & service
  production_start  = NULL,
  production_end    = NULL,
  units_built       = 1,
  unit_cost_usd     = 240000,
  unit_cost_year    = NULL,
  operators_count   = 1,
  variants          = E'- **AD-1** (Ames-Dryden-1) : exemplaire unique, livré à Dryden en février 1979\n- **Model 35** : désignation interne à la Rutan Aircraft Factory, chargée du dessin détaillé\n- **Aile à 0 degré** pour le décollage et l''atterrissage, jusqu''à **60 degrés** atteints mi-1981\n- **79 vols** de 1979 à 1982, dont huit au salon d''Oshkosh',
  variants_en       = E'- **AD-1** (Ames-Dryden-1): single aircraft, delivered to Dryden in February 1979\n- **Model 35**: internal designation at the Rutan Aircraft Factory, in charge of detailed design\n- **Wing at 0 degrees** for take-off and landing, up to **60 degrees** reached in mid-1981\n- **79 flights** from 1979 to 1982, eight of them at the Oshkosh show',

  -- Strate 4 : qualitatif
  nickname          = NULL,

  -- Strate 6 : médias externes et attribution de la photo
  wikipedia_fr      = 'https://fr.wikipedia.org/wiki/NASA_AD-1',
  wikipedia_en      = 'https://en.wikipedia.org/wiki/NASA_AD-1',
  youtube_showcase  = NULL,
  manufacturer_page = NULL,
  image_credit      = 'Bob Rhine, NASA',
  image_licence     = 'Public domain'
WHERE name = 'NASA AD-1';

COMMIT;

-- [auto:006] furtivité (strate 4).
-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite
-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.
UPDATE airplanes SET stealth_level = 'aucune' WHERE name = 'NASA AD-1';
