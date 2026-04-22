<p align="center">
  <img src="https://img.shields.io/badge/version-4.2.0-C8A96E?style=for-the-badge&labelColor=0D0D0D" alt="Version">
  <img src="https://img.shields.io/badge/node-%3E%3D18-339933?style=for-the-badge&logo=node.js&labelColor=0D0D0D" alt="Node.js">
  <img src="https://img.shields.io/badge/PostgreSQL-%3E%3D14-4169E1?style=for-the-badge&logo=postgresql&labelColor=0D0D0D&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/tests-435-27ae60?style=for-the-badge&labelColor=0D0D0D" alt="Tests">
  <img src="https://img.shields.io/badge/licence-All%20Rights%20Reserved-C0392B?style=for-the-badge&labelColor=0D0D0D" alt="Licence">
</p>

<h1 align="center">Vol d'Histoire</h1>

<p align="center">
  <strong>Encyclopedie interactive de l'aviation militaire depuis 1960</strong><br>
  <em>68 appareils &middot; 12 nations &middot; 17 conflits &middot; 150+ systemes d'armes</em>
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

**Visiteurs** — Hangar avec filtres (nation, generation, type, tri), recherche full-text PostgreSQL, fiches detaillees enrichies (specs dimensionnelles, motorisation, production, appareils lies, liens externes Wikipedia / YouTube), frise chronologique interactive, statistiques globales, export PDF.

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
│   │   └── sitemap.js             Sitemap XML (cache Redis 24h)
│   ├── __tests__/
│   │   ├── api.test.js            Tests integration (Jest + Supertest)
│   │   ├── validators.test.js     Tests unitaires validators
│   │   ├── sanitize-logs.test.js  Tests scrub PII
│   │   ├── url.test.js            Tests slugify / idFromSlug
│   │   └── load.test.js           Tests de charge (autocannon)
│   └── db_backup/
│       ├── db.sql                 Schema complet (14 tables + triggers)
│       └── *.sql                  68 fichiers avions (INSERT + enrichissement complet)
│
├── frontend/                      Vanilla HTML / CSS / JS (pas de framework)
│   ├── assets/
│   │   └── airplanes/             68 images locales (JPG/PNG)
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
│   │   │   ├── admin.js           Modal edition 40+ champs
│   │   │   └── ui.js              Share bar, scroll progress, PDF export
│   │   ├── hangar/
│   │   │   ├── data.js            Fetch + recherche FTS
│   │   │   ├── filters.js         URL state, session, facettes
│   │   │   ├── render.js          Cartes + pagination (etat URL preserve)
│   │   │   ├── compare.js         Modale comparaison 2-4 avions
│   │   │   ├── view-toggle.js     Grille / liste
│   │   │   ├── admin.js           Modal creation avion
│   │   │   └── mobile-sheet.js    Sheet filtres mobile
│   │   └── [page].js              Logique specifique par page
│   ├── locales/                   fr.json, en.json (parite 100%)
│   ├── __tests__/
│   │   └── utils.test.js          Tests unitaires utils (Jest + jsdom)
│   └── *.html                     18 pages
│
├── e2e/                           Tests Playwright (11 specs)
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

La table `airplanes` contient ~55 colonnes incluant les strates d'enrichissement :

| Strate | Champs |
|---|---|
| **1. Fiche technique** | `length`, `wingspan`, `height`, `wing_area`, `empty_weight`, `mtow`, `service_ceiling`, `climb_rate`, `g_limit_pos/neg`, `combat_radius`, `crew` |
| **2. Motorisation** | `engine_name`, `engine_count`, `engine_type` (+ `_en`), `thrust_dry`, `thrust_wet` |
| **3. Production** | `production_start/end`, `units_built`, `unit_cost_usd`, `unit_cost_year`, `operators_count`, `variants` (+ `_en`) |
| **4. Qualitatif** | `stealth_level` (enum), `nickname`, `predecessor_id`, `successor_id`, `rival_id` (FK self-join) |
| **5. Narratif** | `description` / `description_en` en Markdown (parse cote front) |
| **6. Medias externes** | `wikipedia_fr`, `wikipedia_en`, `youtube_showcase`, `manufacturer_page` |

---

## Installation locale

### Prerequis

| Outil | Version |
|---|---|
| Node.js | 18+ |
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

# 2. Importer les 68 avions (chaque fichier contient INSERT + enrichissement)
for f in backend/db_backup/*.sql; do
  [ "$f" != "backend/db_backup/db.sql" ] && psql -U vol_user -d vol_histoire -f "$f"
done
```

### 3. Configurer l'environnement

```bash
cp backend/.env.example backend/.env
```

Variables requises : `DB_USER`, `DB_HOST`, `DB_NAME`, `DB_PASSWORD`, `DB_PORT`, `JWT_SECRET`, `REFRESH_SECRET`, `MAIL_USER`, `MAIL_PASS`, `FRONTEND_URL`.

Optionnelles : `REDIS_URL`, `HCAPTCHA_SECRET`, `HCAPTCHA_SITEKEY`, `SENTRY_DSN`.

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
```

Le site est accessible sur `http://localhost:8080`.
La documentation API Swagger est sur `http://localhost:3000/api/docs` (mode dev uniquement).

---

## Tests

Le projet dispose de **435 tests backend** + **tests frontend et E2E** :

```bash
# Backend — 431 tests unitaires + integration
cd backend && npm test

# Backend — couverture de code
npm run test:coverage

# Backend — tests de charge (autocannon, 50-100 connexions)
npm run test:load

# Frontend — tests unitaires (utils.js)
cd frontend && npm test

# E2E — Playwright (11 specs)
cd e2e && npx playwright test
```

| Suite | Tests | Outil |
|-------|-------|-------|
| Backend unit/integration | 388 | Jest + Supertest |
| Backend charge | 5 | autocannon |
| Frontend unit | 20 | Jest + jsdom |
| E2E | 49 | Playwright |

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
| Referentials | countries, generations, types, manufacturers |
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
| **Backend** | Node.js 18+, Express 4.21 (CommonJS) |
| **Base de donnees** | PostgreSQL 14+ (pg 8.13) avec `tsvector` + GIN pour la recherche full-text |
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
| **Images** | 68 images d'avions en local (pas de CDN tiers) |

---

## Nations couvertes

France (9) &middot; Etats-Unis (13) &middot; Russie (17) &middot; Chine (13) &middot; Royaume-Uni (8) &middot; Allemagne (8) &middot; Italie (7) &middot; Suede (3) &middot; Inde (11) &middot; Japon (6) &middot; Bresil (5) &middot; Israel (8)

---

## Licence

Ce projet est protege par la licence **All Rights Reserved**.

&copy; 2026 [Titouan Borde](https://titouan-borde.com)
