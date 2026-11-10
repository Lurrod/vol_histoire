<p align="center">
  <img src="https://img.shields.io/badge/version-4.14.0-C8A96E?style=for-the-badge&labelColor=0D0D0D" alt="Version">
  <img src="https://img.shields.io/badge/node-20%20%7C%2024-339933?style=for-the-badge&logo=node.js&labelColor=0D0D0D" alt="Node.js">
  <img src="https://img.shields.io/badge/PostgreSQL-%3E%3D14-4169E1?style=for-the-badge&logo=postgresql&labelColor=0D0D0D&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/tests-2120-27ae60?style=for-the-badge&labelColor=0D0D0D" alt="Tests">
  <img src="https://img.shields.io/badge/licence-All%20Rights%20Reserved-C0392B?style=for-the-badge&labelColor=0D0D0D" alt="Licence">
</p>

<h1 align="center">Vol d'Histoire</h1>

<p align="center">
  <strong>Encyclopedie interactive de l'aviation militaire depuis 1960</strong><br>
  <em>434 appareils &middot; 33 nations &middot; 61 conflits &middot; 200+ systemes d'armes</em>
</p>

<p align="center">
  <a href="https://vol-histoire.titouan-borde.com">Site en ligne</a> &middot;
  <a href="#-installation-locale">Installation</a> &middot;
  <a href="#-documentation-api">API</a> &middot;
  <a href="https://titouan-borde.com">Contact</a>
</p>

---

## Presentation

**Vol d'Histoire** est une application web dediee a l'histoire de l'aviation militaire de 1960 a nos jours. Elle propose un catalogue interactif d'avions de chasse, bombardiers et appareils de reconnaissance, enrichi de fiches techniques detaillees (dimensions, motorisation, production, variantes), de narratifs Markdown bilingues FR/EN, d'une frise chronologique et d'un systeme de favoris personnalise.

---

## Fonctionnalites

**Visiteurs** — Hangar avec filtres (nation, generation, type, conflit, mission, tri), recherche full-text PostgreSQL avec saisie partielle (« mira » trouve les Mirage), page par conflit (`/conflits/<slug>`) listant les appareils engages, fiches detaillees enrichies (specs dimensionnelles, motorisation, production, appareils lies, chaine de filiation complete, liens externes Wikipedia / YouTube), éphéméride « Ce jour-là » et appareil du jour sur l'accueil, carte des nations de conception sur l'accueil et comme filtre du hangar, comparateur de trois appareils partageable par lien, frise chronologique interactive, statistiques globales, export PDF.

**Membres** — Favoris personnels, preferences cookies, parametres de compte (nom, email, mot de passe, suppression).

**Editeurs** — Ajout et modification d'avions via formulaire complet (40+ champs : fiche technique, moteur, production, qualitatif, liens croises predecessor / successor / rival, liens externes).

**Administrateurs** — Gestion des utilisateurs (roles, suppression), gestion complete du catalogue, dashboard statistiques.

---

## Architecture

```
vol_histoire/
├── backend/                       Node.js / Express (CommonJS)
│   ├── server.js                  Boot, pool PostgreSQL, graceful shutdown
│   ├── app.js                     Config, CSP nonce, CORS, rate-limit, Swagger UI
│   ├── db.js                      Helper withTransaction
│   ├── logger.js                  Logging JSON + scrub PII + Sentry
│   ├── mailer.js                  SMTP OVH, templates email
│   ├── i18n.js                    pickLang (FR/EN fallback)
│   ├── validators.js              Validation pure (testable)
│   ├── openapi.yaml               Spec OpenAPI 3.0
│   ├── assets/
│   │   └── swagger-theme.css      Theme sombre Swagger UI
│   ├── middleware/
│   │   ├── auth.js                JWT + refresh rotation atomique + replay detection
│   │   ├── asyncHandler.js        Wrapper async → next(err)
│   │   ├── hcaptcha.js            Verification hCaptcha (register, forgot, contact)
│   │   ├── sanitize-logs.js       Scrub PII dans logs Sentry
│   │   ├── observability.js       Request tracing + metrics
│   │   └── serveHtml.js           Cache busting assets + injection CSP nonce
│   ├── routes/
│   │   ├── auth.js                Register, login (lockout par compte), refresh, logout
│   │   ├── users.js               CRUD utilisateurs + admin (revocation sessions)
│   │   ├── airplanes.js           CRUD avions + recherche FTS + referentiels
│   │   ├── favorites.js           Favoris
│   │   ├── contact.js             Formulaire contact (hCaptcha)
│   │   ├── details-ssr.js         SSR + 301 canonicalisation URL
│   │   ├── facets.js              Facettes dynamiques hangar
│   │   ├── monitoring.js          Endpoint status protege
│   │   ├── stats.js               Stats (cache 5 min + invalidation)
│   │   ├── conflicts-ssr.js       SSR des pages conflit (langue du visiteur)
│   │   └── sitemap.js             Sitemap XML (cache Redis 24h)
│   ├── repositories/              Requetes SQL par domaine (pool en parametre, lignes en retour)
│   ├── utils/
│   │   ├── airplane-fields.js     Table unique des 52 champs d'un appareil (INSERT/UPDATE)
│   │   └── ssr-head.js            Meta, JSON-LD et en-tetes communs du SSR
│   ├── __tests__/
│   │   ├── integration/           Suite sur vraie base PostgreSQL (IT_DATABASE_URL, base *_it)
│   │   ├── api.test.js            Tests des routes (Jest + Supertest, base simulee)
│   │   ├── ssr-*.test.js          SSR, partials, redirections
│   │   ├── validators.test.js     Tests unitaires validators
│   │   ├── mailer / logger / cache Tests des gabarits d'email, du logger, du cache
│   │   └── load.test.js           Tests de charge (autocannon)
│   └── db_backup/
│       ├── db.sql                 Schema complet (14 tables + triggers)
│       └── *.sql                  434 fichiers avions (INSERT + enrichissement complet)
│
├── frontend/                      Vanilla HTML / CSS / JS (pas de framework)
│   ├── assets/
│   │   └── airplanes/             434 appareils en tri-format (AVIF + WebP + JPG)
│   ├── css/
│   │   ├── tokens.css             Design tokens (source unique de verite)
│   │   ├── base.css               Reset, container, typographie
│   │   ├── shared.css             Header, nav, footer, toasts, modals
│   │   ├── cookies.css            Banniere RGPD
│   │   └── [page].css + .min.css  Sources + bundles page-specifiques
│   ├── fonts/                     DM Sans + Barlow Condensed (woff2 self-hosted)
│   ├── js/
│   │   ├── icons.js               Dictionnaire SVG local (159 icones FA)
│   │   ├── utils.js               escapeHtml, showToast, safeSetHTML (DOMPurify)
│   │   ├── nav.js                 Navigation partagee
│   │   ├── auth.js                Module auth (tokens memoire, refresh, multi-tab)
│   │   ├── i18n.js                Internationalisation fr/en
│   │   ├── cookies.js             Consentement RGPD + GTM gate
│   │   ├── captcha.js             hCaptcha invisible
│   │   ├── details/
│   │   │   ├── data.js            Chargement /api/airplanes/:id + related
│   │   │   ├── render.js          Rendu fiche + specs + production + sources
│   │   │   ├── markdown.js        Parser Markdown safe (3 sections narratif)
│   │   │   ├── radar.js           Radar SVG capacites
│   │   │   ├── favorites.js       Toggle favori
│   │   │   ├── admin.js           Modal edition (formulaire partage)
│   │   │   └── ui.js              Share bar, scroll progress, PDF export
│   │   ├── hangar/
│   │   │   ├── data.js            Fetch + recherche FTS
│   │   │   ├── filters.js         URL state, session, facettes
│   │   │   ├── render.js          Cartes + pagination (etat URL preserve)
│   │   │   ├── compare.js         Modale comparaison 2-4 avions
│   │   │   ├── view-toggle.js     Grille / liste
│   │   │   ├── admin.js           Modal creation avion (formulaire partage)
│   │   │   └── mobile-sheet.js    Sheet filtres mobile
│   │   ├── shared/
│   │   │   ├── airplane-form.js   Formulaire d'appareil unique (creation + edition)
│   │   │   ├── airplane-fields.js GENERE par build-js.js depuis backend/utils/airplane-fields.js
│   │   │   ├── card.js            Carte appareil (motif « block link »)
│   │   │   └── compare.js         Comparateur partage hangar + fiche
│   │   ├── favorites/ timeline/ settings/ login/ home/   Modules par page (state, data, render…)
│   │   └── [page].js              Point d'entree court par page
│   ├── locales/                   fr.json, en.json (parite 100%)
│   ├── partials/                  header.html, footer.html (inclus par serveHtml au demarrage)
│   ├── __tests__/                 64 suites Jest + jsdom (couverture mesuree sur tout js/**)
│   └── *.html                     19 pages
│
├── e2e/                           Tests Playwright (21 specs)
│   ├── tests/
│   │   ├── auth-flow.spec.js      Register, login, favoris, logout
│   │   ├── admin-crud.spec.js     CRUD avions (admin)
│   │   ├── admin-users.spec.js    Gestion utilisateurs (admin)
│   │   ├── settings-profile.spec.js  Profil, securite, danger zone
│   │   ├── navigation.spec.js     Flux inter-pages, 404, recherche
│   │   ├── responsive.spec.js     Mobile, tablette, hamburger
│   │   ├── hangar.spec.js         Filtres, cartes, pagination
│   │   ├── details.spec.js        Fiche avion, image, 404
│   │   ├── favorites.spec.js      Auth gate, acces connecte
│   │   ├── login.spec.js          Formulaire, erreurs, ARIA tabs
│   │   └── i18n.spec.js           Changement de langue, persistence
│   └── helpers/auth.js            Login via API pour les tests
│
├── scripts/                       Outils de build
│   ├── build-css.js               Bundle CSS par page (minification + dedup keyframes)
│   ├── build-js.js                Bundle JS par page (esbuild)
│   ├── build-icons.py             Generation icons.js depuis Font Awesome (jsDelivr)
│   └── scope-css.js               Helper scoping CSS
│
├── .github/workflows/ci.yml      CI GitHub Actions (tests + audit)
├── CLAUDE.md                      Documentation projet (agent IA)
└── README.md
```

---

## Base de donnees

**14 tables** PostgreSQL avec relations many-to-many, audit trail (`created_at`, `updated_at`), triggers automatiques, colonne `tsvector` generee pour la recherche full-text :

```
roles ──────────┐
                ▼
users ─── favorites ───┐
  │                    ▼
  │  countries ── airplanes ──┬── airplane_armement ── armement
  │      │            │       ├── airplane_tech ────── tech
  │      │            │       ├── airplane_wars ────── wars
  │  manufacturer ────┘       └── airplane_missions ── missions
  │                   │
  │  generation ──────┘
  │  type ────────────┘
  │
  ├── refresh_tokens (JTI, revocation, expiration)
  └── email_tokens (verification, reset, TTL)
```

La table `airplanes` contient 61 colonnes incluant les strates d'enrichissement, et
15 contraintes `CHECK` de coherence (ordre chronologique, plages de valeurs,
`mtow >= empty_weight`, pas d'auto-reference predecesseur/successeur/rival) :

| Strate | Champs |
|---|---|
| **1. Fiche technique** | `length`, `wingspan`, `height`, `wing_area`, `empty_weight`, `mtow`, `service_ceiling`, `climb_rate`, `g_limit_pos/neg`, `combat_radius`, `crew` |
| **2. Motorisation** | `engine_name`, `engine_count`, `engine_type` (+ `_en`), `thrust_dry`, `thrust_wet` |
| **3. Production** | `production_start/end`, `units_built`, `unit_cost_usd`, `unit_cost_year`, `operators_count`, `variants` (+ `_en`) |
| **4. Qualitatif** | `stealth_level` (enum), `nickname`, `predecessor_id`, `successor_id`, `rival_id` (FK self-join) |
| **5. Narratif** | `description` / `description_en` en Markdown (parse cote front) |
| **6. Medias externes** | `wikipedia_fr`, `wikipedia_en`, `youtube_showcase`, `manufacturer_page`, `image_credit`, `image_licence` (attribution de la photo, affichee en legende) |

---

## Installation locale

### Prerequis

| Outil | Version |
|---|---|
| Node.js | 24 (`.nvmrc`, champ `engines` des `package.json`) |
| PostgreSQL | 14+ |
| Redis | optionnel (fallback memoire) |

### 1. Cloner et installer

```bash
git clone https://github.com/Lurrod/vol_histoire.git
cd vol_histoire/backend
npm install
```

### 2. Configurer la base de donnees

Le schema et les donnees (y compris l'enrichissement complet) sont distribues dans `backend/db_backup/` :

```bash
createdb vol_histoire

# 1. Schema complet (14 tables, triggers, index, FTS)
psql -U vol_user -d vol_histoire -f backend/db_backup/db.sql

# 2. Importer les 434 avions (chaque fichier contient INSERT + enrichissement)
#    L'ordre alphabetique compte : zz_backfill_relations.sql passe en dernier et
#    pose les liens predecesseur / successeur / rival, qui exigent que les 434
#    fiches soient deja inserees.
for f in backend/db_backup/*.sql; do
  [ "$f" != "backend/db_backup/db.sql" ] && psql -U vol_user -d vol_histoire -f "$f"
done
```

> Sous Windows, forcer `PGCLIENTENCODING=UTF8` avant les `psql` : sinon les noms
> accentues (`Etendard IV`, `AMX A-1 Bresilien`) sont importes corrompus.

Pour une base **deja installee**, voir `backend/migrations/README.md` :
une migration unique et rejouable (`001_mise_a_niveau.sql`) couvre schema,
referentiel, furtivite, credits photo et contraintes `CHECK`.

### 3. Configurer l'environnement

```bash
cp backend/.env.example backend/.env
```

`backend/.env.example` liste **toutes** les variables lues par le code, commentées, avec des valeurs factices.

- Requises (arrêt au démarrage sinon) : `DB_USER`, `DB_HOST`, `DB_NAME`, `DB_PASSWORD`, `JWT_SECRET`, `REFRESH_SECRET` (ces deux derniers : 32 caractères minimum).
- Requises en production : `NODE_ENV=production` (sans lui, et sans erreur : cookies sans `Secure`, `/api/docs` exposé, `/api/metrics` sans jeton), `MAIL_USER` / `MAIL_PASS` (arrêt au démarrage s'ils manquent), `HCAPTCHA_SECRET` (sinon la vérification du captcha est sautée), `METRICS_TOKEN`, `ALLOWED_ORIGINS`, `FRONTEND_URL`.
- Optionnelles : `DB_PORT`, `DB_SSL` (`false` | `no-verify` | `true`, défaut `true`), `PORT`, `HOST`, `LOG_LEVEL`, `CONTACT_EMAIL`, `HCAPTCHA_SITEKEY`, `REDIS_URL`, `SENTRY_DSN`, `SENTRY_ENVIRONMENT`, `SENTRY_RELEASE`, `SENTRY_TRACES_SAMPLE_RATE`, `SENTRY_CAPTURE_WARN`.

Email : le serveur SMTP est fixé dans `backend/mailer.js` (OVH, `ssl0.ovh.net:465`, SSL/TLS) ; seuls `MAIL_USER` et `MAIL_PASS` se configurent — il n'existe pas de variables `SMTP_*`.

### 4. Demarrer

```bash
# Backend (port 3000)
cd backend && npm start

# Frontend (port 8080)
cd frontend && npx live-server --port=8080
```

### 5. Assets (apres modification des sources)

```bash
# Bundles CSS par page
node scripts/build-css.js

# Bundles JS par page
node scripts/build-js.js

# Icones locales (regenere icons.js depuis Font Awesome)
python scripts/build-icons.py

# Carte des nations (regenere le planisphere depuis Natural Earth 110m)
# A relancer seulement apres l'ajout d'un pays dans db.sql
node scripts/build-map.js
```

Le site est accessible sur `http://localhost:8080`.
La documentation API Swagger est sur `http://localhost:3000/api/docs` (mode dev uniquement).

---

## Tests

Le projet dispose de **828 tests backend**, **1 292 tests frontend** et **21 specs E2E** :

```bash
# Backend — 754 tests (routes, validators, SSR, mailer, logger…) ; la suite
# d'integration (74 tests sur vraie base) est sautee sans IT_DATABASE_URL
cd backend && npm test

# Backend — suite d'integration sur vraie base (nom de base obligatoirement en *_it)
IT_DATABASE_URL=postgres://user:mdp@localhost:5432/vol_histoire_it npm test

# Backend — couverture de code
npm run test:coverage

# Backend — tests de charge (autocannon, 50-100 connexions)
npm run test:load

# Frontend — tests unitaires et DOM (jsdom) de tout js/**
cd frontend && npx jest --coverage

# E2E — Playwright (21 specs ; serveur sur le port 3000, NODE_ENV=test)
cd e2e && npx playwright test
```

| Suite | Tests | Outil |
|-------|-------|-------|
| Backend (routes, unitaires) | 754 | Jest + Supertest |
| Backend integration (vraie base) | 74 | Jest + PostgreSQL |
| Backend charge | inclus | autocannon |
| Frontend unit + DOM | 1 292 | Jest + jsdom |
| E2E | 136 scenarios (21 specs) | Playwright |

Couverture : backend 95,9 % des lignes (seuil 80), frontend 99,9 % des lignes et 89,9 % des branches sur tout `js/**` (seuils globaux 95/85/95/95, plancher de 80 % par fichier).

---

## Integration continue et deploiement

`.github/workflows/ci.yml`, sur chaque PR vers `main` et chaque push sur `main` :

| Job | Contenu |
|---|---|
| `quality` | `npm run lint` (ESLint), `html-validate` sur `frontend/*.html`, `npm run build` puis échec si un fichier généré diffère du dépôt (`frontend/js/dist`, `frontend/js/vendor`, `frontend/css/*.min.css`, `app-version.js`, `shared/airplane-fields.js`) |
| `test` | `npm audit` (backend : dépendances de production au seuil `high`, arbre complet au seuil `critical` ; frontend : `high`), Jest backend avec couverture et suite d'intégration sur PostgreSQL, Jest frontend avec couverture (seuils de `frontend/jest.config.json`) |
| `e2e` | Playwright sur une base seedée |
| `load` | tests de charge autocannon |
| `deploy` | push sur `main` uniquement, après les quatre jobs ci-dessus |

Node 24 est la cible : `.nvmrc` (lu par `setup-node`). **Le serveur de production tourne encore en Node 20**, partagé avec d'autres applications : le champ `engines` des quatre `package.json` accepte `>=20 <25`, le job `test-prod-runtime` teste le backend sous Node 20, et le déploiement affiche un avertissement tant que `node -v` diffère de `.nvmrc`. Les actions tierces sont épinglées par SHA de commit ; Dependabot les met à jour.

Les bundles sont versionnés et déployés tels quels : **toute modification de JS/CSS source doit être suivie de `npm run build` et du commit des fichiers générés**, sinon le job `quality` échoue.

### Deroulement du deploiement

1. Un seul déploiement à la fois (`concurrency: deploy-production`, jamais annulé en cours de route).
2. Le run vérifie qu'il porte toujours la tête de `main` ; sinon il s'arrête sans rien faire, le run du commit plus récent déploiera.
3. Sur le serveur (`/var/www/vol-histoire`) : le commit en ligne est noté dans `~/.vol-histoire-deploy/previous_sha` (journal : `history.log`), puis `git reset --hard <commit testé>`, `npm ci --omit=dev` et `pm2 restart vol-histoire`. **Jamais `pm2 restart all`** : le serveur héberge d'autres applications.
4. Smoke tests : `/api/health` (base joignable, processus redémarré depuis moins de 10 min), `/api/config` (la version servie doit être celle de `backend/package.json` du commit déployé), `/`, `/api/airplanes`.
5. Si le déploiement ou un smoke test échoue : **retour arrière automatique** au commit noté à l'étape 3, nouveau contrôle de santé, et le job reste rouge.

Retour arrière manuel (problème découvert plus tard), sur le serveur :

```bash
cd /var/www/vol-histoire
bash scripts/rollback.sh --list   # historique des déploiements
bash scripts/rollback.sh          # revient au commit précédent le dernier déploiement
bash scripts/rollback.sh <sha>    # ou à un commit précis
```

Puis faire un revert sur `main`, sinon le prochain push redéploie la version fautive.

**Migrations SQL : manuelles, et non annulées par le retour arrière.** Avant toute migration : `pg_dump` de la base ; la migration se joue en `postgres` par l'entrée standard (`sudo -u postgres psql -d vol_histoire < backend/migrations/<fichier>.sql`, `postgres` ne pouvant pas lire `/var/www`). Préférer des migrations additives et compatibles avec le code précédent : le retour arrière du code reste alors sans risque.

---

## Securite

| Couche | Implementation |
|--------|---------------|
| **Auth** | JWT access (15 min) + refresh token rotation atomique (7j) avec JTI en BDD + replay detection |
| **Lockout** | Compteur d'echecs par compte, blocage 15 min apres 10 echecs (defense contre credential-stuffing distribue) |
| **Cookies** | HttpOnly, Secure, SameSite=Strict, Path=/api |
| **CSRF** | SameSite + Bearer header + CORS whitelist + CSP form-action |
| **Mots de passe** | bcryptjs cost 12, validation 8-128 chars, 1 maj/min/chiffre |
| **Email** | Verification obligatoire, tokens 24h, rate limit 3 req/15 min |
| **Captcha** | hCaptcha invisible sur register, forgot-password, contact |
| **XSS** | escapeHtml() partout, DOMPurify 3.x pour injection HTML, safeSetHTML() wrapper |
| **Headers** | CSP nonce (style-src-attr 'none'), HSTS (1 an + preload), COOP same-origin, CORP same-site, X-Frame-Options DENY, Permissions-Policy |
| **Rate limiting** | Par route (register 10, login 20, forgot 5, contact 5, global 200 / 15 min) + Redis fallback memoire |
| **SQL** | Requetes parametrees, transactions atomiques, whitelist sort |
| **SEO redirect** | 301 canonicalisation `/details?id=X` → `/details/<slug>-<id>` |

---

## Documentation API

**Swagger UI** : `http://localhost:3000/api/docs` (dev uniquement)

**Spec OpenAPI 3.0** : `backend/openapi.yaml`

| Tag | Routes principales |
|-----|--------|
| Auth | register, login, refresh, logout, verify-email, resend-verification, forgot-password, reset-password |
| Users | list (admin), get, update (revocation sessions), delete, admin update |
| Airplanes | list (filtres + tri + recherche FTS), get (+ predecessor/successor/rival), create, update, delete |
| Airplanes related | armament, tech, missions, wars |
| Referentials | countries, generations, types, manufacturers, nations, wars (liste + detail par slug) |
| Facets | comptes par facette pour filtres dynamiques |
| Favorites | list, add, remove, check |
| Stats | stats globales (cache 5 min) |
| Contact | formulaire (hCaptcha + rate-limit) |
| Sitemap | sitemap.xml dynamique (cache Redis 24h) |

---

## Stack technique

| Couche | Technologies |
|---|---|
| **Frontend** | HTML5, CSS3 (design tokens, responsive mobile-first), JavaScript ES6+ vanilla (pas de framework) |
| **Backend** | Node.js 20 (prod) / 24 (CI), Express 5.3 (CommonJS) |
| **Base de donnees** | PostgreSQL 14+ (pg 8.20) avec `tsvector` + GIN pour la recherche full-text |
| **Cache** | Redis (optionnel, fallback memoire) |
| **Auth** | JWT (jsonwebtoken 9.0) + refresh tokens + bcryptjs (cost 12) |
| **Email** | Nodemailer (SMTP OVH) |
| **Captcha** | hCaptcha (invisible) |
| **Tests** | Jest 30, Supertest 7, Playwright 1, autocannon 8 |
| **Documentation** | OpenAPI 3.0 + Swagger UI |
| **Sanitization** | DOMPurify 3.2.x (SRI sur vendor), parser Markdown safe maison |
| **CI/CD** | GitHub Actions |
| **Typographie** | DM Sans + Barlow Condensed (woff2 self-hosted) |
| **Icones** | 159 icones Font Awesome self-hosted (script `build-icons.py`) |
| **Images** | 434 appareils en tri-format AVIF + WebP + JPG, servis via `<picture>` (pas de CDN tiers) |

---

## Nations couvertes

France (9) &middot; Etats-Unis (13) &middot; Russie (17) &middot; Chine (13) &middot; Royaume-Uni (8) &middot; Allemagne (8) &middot; Italie (13) &middot; Suede (3) &middot; Inde (11) &middot; Japon (6) &middot; Bresil (5) &middot; Israel (8)

---

## Licence

Ce projet est protege par la licence **All Rights Reserved**.

&copy; 2026 [Titouan Borde](https://titouan-borde.com)
