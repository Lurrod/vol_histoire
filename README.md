<p align="center">
  <img src="https://img.shields.io/badge/version-2.0.1-00e5ff?style=for-the-badge&labelColor=080c14" alt="Version">
  <img src="https://img.shields.io/badge/node-%3E%3D14-339933?style=for-the-badge&logo=node.js&labelColor=080c14" alt="Node.js">
  <img src="https://img.shields.io/badge/PostgreSQL-%3E%3D12-4169E1?style=for-the-badge&logo=postgresql&labelColor=080c14&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/licence-All%20Rights%20Reserved-e74c3c?style=for-the-badge&labelColor=080c14" alt="Licence">
</p>

<h1 align="center">✈️ Vol d'Histoire</h1>

<p align="center">
  <strong>Encyclopédie interactive de l'aviation militaire depuis 1960</strong><br>
  <em>45 appareils · 12 nations · 17 conflits · 150+ systèmes d'armes</em>
</p>

<p align="center">
  <a href="https://vol-histoire.titouan-borde.com">🌐 Site en ligne</a> · 
  <a href="#-installation-locale">⚙️ Installation</a> · 
  <a href="#-documentation-api">📡 API</a> · 
  <a href="https://titouan-borde.com">👤 Contact</a>
</p>

---

## 📖 Présentation

**Vol d'Histoire** est une application web dédiée à l'histoire de l'aviation militaire de 1960 à nos jours. Elle propose un catalogue interactif d'avions de chasse, bombardiers et appareils de reconnaissance, enrichi de fiches techniques détaillées, d'une frise chronologique et d'un système de favoris personnalisé.

Le projet s'articule autour d'un **frontend vanilla** (HTML, CSS, JavaScript) et d'un **backend Node.js/Express** connecté à une base **PostgreSQL** relationnelle complète.

---

## 🎯 Fonctionnalités

### Pour tous les visiteurs

- **Hangar** — Catalogue paginé avec filtres par nation, génération (1ère à 5ème), type d'appareil et tri alphabétique ou chronologique.
- **Fiches détaillées** — Caractéristiques techniques (vitesse max, rayon d'action, poids), armement embarqué, technologies, conflits et missions associées.
- **Frise chronologique** — Visualisation interactive de l'évolution des appareils dans le temps avec navigation par clics.
- **Statistiques** — Compteurs globaux (nombre d'avions, pays, fabricants) affichés sur la page d'accueil.

### Pour les membres connectés

- **Favoris** — Sauvegarde personnelle d'appareils avec accès rapide depuis une page dédiée.
- **Paramètres de compte** — Modification du nom, de l'email et du mot de passe.

### Pour les éditeurs

- **Ajout d'avions** — Formulaire complet pour enrichir le catalogue (données techniques, images, relations).
- **Modification de fiches** — Édition des informations existantes depuis la page de détails.

### Pour les administrateurs

- **Gestion des utilisateurs** — Liste, modification de rôles et suppression de comptes.
- **Gestion complète du catalogue** — Ajout, modification et suppression de tout appareil.

---

## 🏗️ Architecture

```
vol_histoire/
│
├── backend/
│   ├── server.js              # Point d'entrée — connexion PostgreSQL et démarrage Express
│   ├── app.js                 # Routes API, middlewares, sécurité (726 lignes)
│   ├── validators.js          # Fonctions de validation extraites et testables
│   ├── __tests__/
│   │   ├── api.test.js        # Tests d'intégration (Jest + Supertest)
│   │   └── validators.test.js # Tests unitaires des validateurs
│   ├── db_backup/
│   │   ├── db.sql             # Schéma complet + données de référence
│   │   └── *.sql              # 44 fichiers de données par appareil
│   └── package.json
│
├── frontend/
│   ├── index.html             # Page d'accueil avec hero vidéo et statistiques
│   ├── hangar.html            # Catalogue avec filtres et pagination
│   ├── details.html           # Fiche technique complète d'un appareil
│   ├── timeline.html          # Frise chronologique interactive
│   ├── favorites.html         # Liste des favoris de l'utilisateur
│   ├── login.html             # Inscription et connexion
│   ├── settings.html          # Paramètres du compte et admin
│   ├── 404.html               # Page d'erreur avec animation radar
│   ├── contact.html           # Formulaire de contact
│   ├── a-propos.html          # Page À propos
│   ├── faq.html               # Foire aux questions
│   ├── support.html           # Page de support
│   ├── mentions-legales.html  # Mentions légales
│   ├── politique-confidentialite.html
│   ├── cgu.html               # Conditions générales d'utilisation
│   ├── cookie-consent.html    # Bandeau de cookies
│   ├── css/                   # 9 feuilles de styles (~6 100 lignes)
│   ├── js/                    # 8 scripts (~5 000 lignes)
│   ├── validators.js          # Validateurs côté client
│   ├── sitemap.xml            # Sitemap pour le référencement
│   └── robots.txt             # Directives pour les crawlers
│
├── LICENSE
├── list.md                    # Inventaire des 108 appareils par nation
└── README.md
```

---

## 🗄️ Base de données

Le schéma PostgreSQL est constitué de **12 tables** avec des relations many-to-many pour modéliser la richesse des données :

```
roles ──────────┐
                ▼
users ─── favorites ───┐
                       ▼
countries ──── airplanes ──┬── airplane_armement ──── armement
    │              │       ├── airplane_tech ───────── tech
    │              │       ├── airplane_wars ───────── wars
manufacturer ──────┘       └── airplane_missions ──── missions
                   │
generation ────────┘
type ──────────────┘
```

### Données pré-chargées

| Catégorie | Quantité |
|---|---|
| Appareils | 44 fiches complètes (108 prévus) |
| Nations | 22 pays |
| Fabricants | 16 constructeurs |
| Générations | 5 (1ère à 5ème) |
| Types | 6 (Chasseur, Bombardier, Reconnaissance, Intercepteur, Multirôle, Appui) |
| Armements | 150+ systèmes (canons, missiles, bombes, roquettes) |
| Technologies | 80+ systèmes (radars, moteurs, avionique) |
| Conflits | 17 guerres (1946–présent) |
| Missions | 15 types de missions |

---

## ⚙️ Installation locale

### Prérequis

| Outil | Version minimale |
|---|---|
| Node.js | 14+ |
| PostgreSQL | 12+ |
| Git | — |

### 1. Cloner le dépôt

```bash
git clone https://github.com/Lurrod/vol_histoire.git
cd vol_histoire
```

### 2. Configurer la base de données

Créez la base et l'utilisateur PostgreSQL :

```bash
createdb vol_histoire
```

```sql
CREATE USER vol_user WITH PASSWORD 'votre_mot_de_passe';
GRANT ALL PRIVILEGES ON DATABASE vol_histoire TO vol_user;
```

Importez le schéma et les données de référence :

```bash
psql -U vol_user -d vol_histoire -f backend/db_backup/db.sql
```

Puis importez les fiches d'avions (chaque fichier SQL est autonome) :

```bash
# Importer tous les appareils d'un coup
for f in backend/db_backup/*.sql; do
  [ "$f" != "backend/db_backup/db.sql" ] && psql -U vol_user -d vol_histoire -f "$f"
done
```

### 3. Configurer l'environnement

Créez un fichier `.env` dans le dossier `backend/` :

```env
DB_USER=vol_user
DB_HOST=localhost
DB_NAME=vol_histoire
DB_PASSWORD=votre_mot_de_passe
DB_PORT=5432
JWT_SECRET=une_chaine_secrete_longue_et_aleatoire
PORT=3000
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

### 4. Installer les dépendances et démarrer

```bash
cd backend
npm install
npm start
```

### 5. Lancer le frontend

Depuis un autre terminal, servez les fichiers statiques :

```bash
cd frontend
npx live-server --port=8080
```

Le site est accessible sur `http://localhost:8080`.

---

## 🧪 Tests

Le projet utilise **Jest** et **Supertest** pour les tests unitaires et d'intégration.

```bash
cd backend

# Lancer les tests
npm test

# Avec couverture de code
npm run test:coverage
```

Les tests couvrent les validateurs (`validators.test.js`) et les routes API (`api.test.js`).

---

## 🔒 Sécurité

Le backend intègre plusieurs couches de protection :

- **Authentification JWT** — Tokens signés pour les routes protégées, avec vérification du rôle utilisateur (admin, éditeur, membre).
- **Hachage bcrypt** — Les mots de passe sont salés et hachés avant stockage.
- **Rate limiting** — Limite de requêtes par IP avec nettoyage périodique automatique.
- **CORS restreint** — Seules les origines autorisées peuvent accéder à l'API.
- **Validation stricte** — Toutes les entrées sont validées côté serveur (emails, noms, URLs, dates, nombres).
- **Headers HTTP** — `X-Content-Type-Options`, `X-Frame-Options`, `X-XSS-Protection`, `Referrer-Policy`, `Permissions-Policy`.
- **Taille des requêtes limitée** — Body JSON limité à 100 Ko.

---

## 📡 Documentation API

Base URL : `http://localhost:3000/api`

L'authentification se fait via un header `Authorization: Bearer <token>` pour les routes protégées.

### Authentification

| Méthode | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/register` | Inscription (rôle membre par défaut) | Non |
| `POST` | `/login` | Connexion, retourne un token JWT | Non |

### Utilisateurs

| Méthode | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/users` | Liste tous les utilisateurs | Admin |
| `GET` | `/users/:id` | Détails d'un utilisateur | Connecté |
| `PUT` | `/users/:id` | Modifier son propre profil | Connecté |
| `PUT` | `/admin/users/:id` | Modifier le rôle d'un utilisateur | Admin |
| `DELETE` | `/users/:id` | Supprimer un compte | Connecté |

### Avions

| Méthode | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/airplanes` | Liste paginée avec filtres | Non |
| `GET` | `/airplanes/:id` | Fiche complète d'un appareil | Non |
| `POST` | `/airplanes` | Ajouter un appareil | Admin/Éditeur |
| `PUT` | `/airplanes/:id` | Modifier un appareil | Admin/Éditeur |
| `DELETE` | `/airplanes/:id` | Supprimer un appareil | Admin/Éditeur |
| `GET` | `/airplanes/:id/armament` | Armement de l'appareil | Non |
| `GET` | `/airplanes/:id/tech` | Technologies de l'appareil | Non |
| `GET` | `/airplanes/:id/wars` | Conflits liés | Non |
| `GET` | `/airplanes/:id/missions` | Missions associées | Non |
| `GET` | `/airplanes/:id/favorite` | Vérifie si en favori | Connecté |

**Paramètres de filtrage pour `GET /airplanes` :**

| Paramètre | Type | Description |
|---|---|---|
| `sort` | `string` | `nation`, `service-date`, `alphabetical`, `generation`, `type`, `default` |
| `country` | `string` | Filtre par nom de pays |
| `generation` | `int` | Filtre par génération (1–5) |
| `type` | `string` | Filtre par type d'appareil |
| `page` | `int` | Numéro de page (défaut : 1) |

### Favoris

| Méthode | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/favorites` | Liste des favoris de l'utilisateur | Connecté |
| `POST` | `/favorites/:airplaneId` | Ajouter un favori | Connecté |
| `DELETE` | `/favorites/:airplaneId` | Retirer un favori | Connecté |

### Données de référence

| Méthode | Endpoint | Description |
|---|---|---|
| `GET` | `/countries` | Liste des pays |
| `GET` | `/generations` | Liste des générations |
| `GET` | `/types` | Liste des types d'avions |
| `GET` | `/manufacturers` | Liste des fabricants |
| `GET` | `/stats` | Statistiques globales |

### Exemples d'utilisation

```bash
# Récupérer les avions français, triés par date de service
curl "http://localhost:3000/api/airplanes?sort=service-date&country=France&page=1"

# S'inscrire
curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Jean","email":"jean@test.com","password":"monmotdepasse"}'

# Se connecter et récupérer le token
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"jean@test.com","password":"monmotdepasse"}'

# Ajouter un favori (avec token)
curl -X POST http://localhost:3000/api/favorites/1 \
  -H "Authorization: Bearer <token>"
```

### Codes de réponse

| Code | Signification |
|---|---|
| `200` | Succès |
| `201` | Ressource créée |
| `400` | Requête invalide (validation échouée) |
| `401` | Non authentifié |
| `403` | Accès refusé (rôle insuffisant) |
| `404` | Ressource introuvable |
| `409` | Conflit (email déjà utilisé, favori existant) |
| `429` | Trop de requêtes (rate limit) |
| `500` | Erreur serveur |

---

## 🛠️ Stack technique

| Couche | Technologies |
|---|---|
| **Frontend** | HTML5, CSS3 (custom properties, animations, responsive), JavaScript ES6+ |
| **Backend** | Node.js, Express 4.21 |
| **Base de données** | PostgreSQL (pg 8.13) |
| **Authentification** | JSON Web Tokens (jsonwebtoken 9.0), bcryptjs 3.0 |
| **Tests** | Jest 30, Supertest 7 |
| **Typographie** | Space Grotesk, Orbitron (Google Fonts) |
| **Icônes** | Font Awesome 6 |
| **Hébergement** | [vol-histoire.titouan-borde.com](https://vol-histoire.titouan-borde.com) |

---

## 🌍 Nations couvertes

🇫🇷 France (9) · 🇺🇸 États-Unis (13) · 🇷🇺 Russie (17) · 🇨🇳 Chine (13) · 🇬🇧 Royaume-Uni (8) · 🇩🇪 Allemagne (8) · 🇮🇹 Italie (7) · 🇸🇪 Suède (3) · 🇮🇳 Inde (11) · 🇯🇵 Japon (6) · 🇧🇷 Brésil (5) · 🇮🇱 Israël (8)

---

## 🤝 Contribution

Les contributions sont les bienvenues via pull request ou issue sur GitHub. Merci de tester vos modifications localement avant de soumettre.

---

## 📄 Licence

Ce projet est protégé par la licence **All Rights Reserved**.

© 2025 [Titouan Borde](https://titouan-borde.com) — Aucune utilisation commerciale ou modification sans autorisation.