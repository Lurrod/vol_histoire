<p align="center">
  <img src="https://img.shields.io/badge/version-3.2.0-C8A96E?style=for-the-badge&labelColor=0D0D0D" alt="Version">
  <img src="https://img.shields.io/badge/node-%3E%3D18-339933?style=for-the-badge&logo=node.js&labelColor=0D0D0D" alt="Node.js">
  <img src="https://img.shields.io/badge/PostgreSQL-%3E%3D14-4169E1?style=for-the-badge&logo=postgresql&labelColor=0D0D0D&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/tests-350-27ae60?style=for-the-badge&labelColor=0D0D0D" alt="Tests">
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

**Vol d'Histoire** est une application web dediee a l'histoire de l'aviation militaire de 1960 a nos jours. Elle propose un catalogue interactif d'avions de chasse, bombardiers et appareils de reconnaissance, enrichi de fiches techniques detaillees, d'une frise chronologique et d'un systeme de favoris personnalise.

---

## Fonctionnalites

**Visiteurs** — Hangar avec filtres (nation, generation, type, tri), fiches detaillees (specs, armement, technologies, conflits, missions), frise chronologique interactive, statistiques globales.

**Membres** — Favoris personnels, parametres de compte (nom, email, mot de passe).

**Editeurs** — Ajout et modification d'avions via formulaire complet.

**Administrateurs** — Gestion des utilisateurs (roles, suppression), gestion complete du catalogue.

---

## Architecture

```
vol_histoire/
├── backend/                       Node.js / Express
│   ├── server.js                  Boot, pool PostgreSQL, graceful shutdown
│   ├── app.js                     Config, security headers, CORS, Swagger UI
│   ├── db.js                      Helper withTransaction
│   ├── logger.js                  Logging structure JSON (errorId)
│   ├── mailer.js                  SMTP OVH, templates email
│   ├── validators.js              Validation pure (testable)
│   ├── openapi.yaml               Spec OpenAPI 3.0 (33 routes)
│   ├── middleware/
│   │   ├── auth.js                JWT, refresh tokens, authorize
│   │   └── asyncHandler.js        Wrapper async → next(err)
│   ├── routes/
│   │   ├── auth.js                Register, login, refresh, logout, verify, reset
│   │   ├── users.js               CRUD utilisateurs + admin
│   │   ├── airplanes.js           CRUD avions + referentiels
│   │   ├── favorites.js           Favoris
│   │   ├── stats.js               Stats (cache 5 min + invalidation)
│   │   └── sitemap.js             Sitemap XML dynamique
│   ├── __tests__/
│   │   ├── api.test.js            137 tests integration (Jest + Supertest)
│   │   ├── validators.test.js     119 tests unitaires
│   │   └── load.test.js           5 tests de charge (autocannon)
│   └── db_backup/
│       ├── db.sql                 Schema complet + triggers audit
│       └── *.sql                  44 fichiers de donnees par appareil
│
├── frontend/                      Vanilla HTML / CSS / JS
│   ├── css/
│   │   ├── tokens.css             Design tokens (source unique de verite)
│   │   ├── base.css               Reset, body, container, typographie
│   │   ├── shared.css             Header, nav, footer, toasts, boutons, modals
│   │   └── [page].css             Styles specifiques par page
│   ├── js/
│   │   ├── utils.js               escapeHtml, showToast, animateNumber, togglePassword
│   │   ├── nav.js                 Navigation partagee (header, dropdown, logout, ESC)
│   │   ├── auth.js                Module auth (tokens memoire, refresh, multi-tab)
│   │   ├── i18n.js                Internationalisation fr/en (DOMPurify)
│   │   ├── cookies.js             Consentement RGPD
│   │   └── [page].js              Logique specifique par page
│   ├── locales/                   fr.json, en.json
│   ├── __tests__/
│   │   └── utils.test.js          20 tests unitaires (Jest + jsdom)
│   └── *.html                     18 pages
│
├── e2e/                           49 tests Playwright (11 specs)
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
│   │   ├── login.spec.js          Formulaire, erreurs
│   │   └── i18n.spec.js           Changement de langue, persistence
│   └── helpers/auth.js            Login via API pour les tests
│
├── .github/workflows/ci.yml      CI GitHub Actions (tests + audit)
├── CLAUDE.md                      Documentation projet
└── README.md
```

---

## Base de donnees

**14 tables** PostgreSQL avec relations many-to-many, audit trail (`created_at`, `updated_at`) et triggers automatiques :

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

---

## Installation locale

### Prerequis

| Outil | Version |
|---|---|
| Node.js | 18+ |
| PostgreSQL | 14+ |

### 1. Cloner et installer

```bash
git clone https://github.com/Lurrod/vol_histoire.git
cd vol_histoire/backend
npm install
```

### 2. Configurer la base de donnees

```bash
createdb vol_histoire
psql -U vol_user -d vol_histoire -f backend/db_backup/db.sql

# Importer tous les appareils
for f in backend/db_backup/*.sql; do
  [ "$f" != "backend/db_backup/db.sql" ] && psql -U vol_user -d vol_histoire -f "$f"
done
```

### 3. Configurer l'environnement

Copiez le fichier d'exemple et remplissez-le :

```bash
cp backend/.env.example backend/.env
```

Variables requises : `DB_USER`, `DB_HOST`, `DB_NAME`, `DB_PASSWORD`, `DB_PORT`, `JWT_SECRET`, `REFRESH_SECRET`, `MAIL_USER`, `MAIL_PASS`, `FRONTEND_URL`.

### 4. Demarrer

```bash
# Backend (port 3000)
cd backend && npm start

# Frontend (port 8080)
cd frontend && npx live-server --port=8080
```

Le site est accessible sur `http://localhost:8080`.
La documentation API Swagger est sur `http://localhost:3000/api/docs`.

---

## Tests

Le projet dispose de **330 tests** repartis sur 4 suites :

```bash
# Backend — 256 tests unitaires + integration
cd backend && npm test

# Backend — couverture de code (seuil 80%)
npm run test:coverage

# Backend — tests de charge (autocannon, 50-100 connexions)
npm run test:load

# Frontend — 20 tests unitaires (utils.js)
cd frontend && npm test

# E2E — 49 tests Playwright (11 specs)
cd e2e && npx playwright test
```

| Suite | Tests | Outil |
|-------|-------|-------|
| Backend unit/integration | 256 | Jest + Supertest |
| Backend charge | 5 | autocannon |
| Frontend unit | 20 | Jest + jsdom |
| E2E | 49 | Playwright |
| **Total** | **330** | |

---

## Securite

| Couche | Implementation |
|--------|---------------|
| **Auth** | JWT access (15 min) + refresh token rotation (7j) avec JTI en BDD |
| **Cookies** | HttpOnly, Secure, SameSite=Strict, Path=/api |
| **CSRF** | 4 couches : SameSite + Bearer header + CORS whitelist + CSP form-action |
| **Mots de passe** | bcryptjs (salt 10), validation 8-128 chars, 1 maj/min/chiffre |
| **Email** | Verification obligatoire, tokens 24h, rate limit 3 req/15 min |
| **XSS** | escapeHtml() partout, DOMPurify 3.2.4 (SRI) pour i18n HTML |
| **Headers** | CSP, HSTS (1 an + preload), X-Frame-Options DENY, Permissions-Policy |
| **Rate limiting** | Par route (register 10, login 20, global 200 / 15 min) |
| **SQL** | Requetes parametrees, transactions atomiques (withTransaction) |
| **Validation** | Validators dedies, whitelist tri SQL, IDs numeriques |

---

## Documentation API

**Swagger UI** : `http://localhost:3000/api/docs`

**Spec OpenAPI 3.0** : `backend/openapi.yaml` — 33 routes documentees avec schemas, parametres, codes de reponse.

| Tag | Routes |
|-----|--------|
| Auth | register, login, refresh, logout, verify-email, resend-verification, forgot-password, reset-password |
| Users | list (admin), get, update, delete, admin update |
| Airplanes | list (filtres/tri), get, create, update, delete, armament, tech, missions, wars, related |
| Referentials | countries, generations, types, manufacturers |
| Favorites | list, add, remove, check |
| Stats | stats globales (cache 5 min) |

---

## Stack technique

| Couche | Technologies |
|---|---|
| **Frontend** | HTML5, CSS3 (design tokens, responsive), JavaScript ES6+ vanilla |
| **Backend** | Node.js, Express 4.21 |
| **Base de donnees** | PostgreSQL (pg 8.13) |
| **Auth** | JWT (jsonwebtoken 9.0) + refresh tokens + bcryptjs 2.4 |
| **Email** | Nodemailer 8 (SMTP OVH) |
| **Tests** | Jest 29, Supertest 7, Playwright 1, autocannon 8 |
| **Documentation** | OpenAPI 3.0 + Swagger UI |
| **Sanitization** | DOMPurify 3.2.4 (CDN + SRI) |
| **CI/CD** | GitHub Actions |
| **Typographie** | DM Sans, Barlow Condensed (Google Fonts) |
| **Icones** | Font Awesome 6 |

---

## Nations couvertes

France (9) &middot; Etats-Unis (13) &middot; Russie (17) &middot; Chine (13) &middot; Royaume-Uni (8) &middot; Allemagne (8) &middot; Italie (7) &middot; Suede (3) &middot; Inde (11) &middot; Japon (6) &middot; Bresil (5) &middot; Israel (8)

---

## Licence

Ce projet est protege par la licence **All Rights Reserved**.

&copy; 2025 [Titouan Borde](https://titouan-borde.com)
