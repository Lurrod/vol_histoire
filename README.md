# Documentation de Vol d'Histoire

**Vol d'Histoire** est un projet web interactif dédié à l'histoire de l'aviation militaire, permettant aux utilisateurs d'explorer une collection d'avions de chasse historiques via un catalogue détaillé, une frise chronologique, et des fonctionnalités personnalisées. Cette documentation s'adresse à deux publics principaux :

- **Les utilisateurs** du site web hébergé, qui souhaitent naviguer et utiliser ses fonctionnalités.
- **Les développeurs** qui veulent installer, exécuter ou contribuer au projet en local.

---

## 1. Guide pour les Utilisateurs (Site Hébergé)

Cette section s'adresse aux visiteurs du site "Vol d'Histoire" accessible en ligne.

### Présentation du Site Web

"Vol d'Histoire" vous plonge dans l'univers de l'aviation militaire à travers :
- Un **catalogue d'avions** avec des fiches détaillées (caractéristiques techniques, historiques, images).
- Une **frise chronologique interactive** retraçant l'évolution des avions dans le temps.
- Une **gestion de compte** pour personnaliser votre expérience selon votre rôle (administrateur, éditeur, membre).

### Fonctionnalités Principales

- **Catalogue d'Avions** : Parcourez une liste d'avions avec filtres (nation, génération, type) et consultez leurs fiches détaillées.
- **Frise Chronologique** : Visualisez les avions dans leur contexte historique en cliquant pour plus d'informations.
- **Gestion de Compte** :
  - **Inscription/Connexion** : Créez un compte ou connectez-vous pour accéder à des fonctionnalités avancées.
  - **Rôles Utilisateurs** :
    - **Administrateur** : Gère les utilisateurs et les fiches d'avions (ajout, modification, suppression).
    - **Éditeur** : Ajoute ou modifie des fiches d'avions.
    - **Membre** : Consulte le catalogue et la frise chronologique.

### Guide d'Utilisation

1. **Accéder au Site** :
   - Rendez-vous sur l'URL hébergée <https://vol-histoire.titouan-borde.com/>

2. **Inscription et Connexion** :
   - Cliquez sur l'icône de connexion en haut à droite.
   - Inscrivez-vous avec un nom, un email et un mot de passe, ou connectez-vous si vous avez déjà un compte.
   - Une fois connecté, votre nom et rôle apparaissent dans le menu utilisateur.

3. **Explorer le Hangar** :
   - Depuis la page d'accueil, cliquez sur "Visiter le Hangar".
   - Utilisez le menu déroulant "Trier par" pour filtrer par nation, génération, type, date d'entrée en service ou ordre alphabétique.
   - Cliquez sur une fiche pour voir les détails (armement, technologies, guerres, missions).

4. **Consulter la Frise Chronologique** :
   - Cliquez sur "Découvrir la Frise" depuis l'accueil ou le menu.
   - Parcourez les événements et cliquez sur un avion pour accéder à sa fiche.

5. **Gérer Votre Compte** :
   - Accédez à "Mon Compte" pour modifier vos informations (nom, email, mot de passe) ou supprimer votre compte.
   - Les administrateurs peuvent aussi gérer les utilisateurs depuis cette section.

6. **Pour les Éditeurs/Administrateurs** :
   - Ajoutez un avion via le bouton "Ajouter un avion" dans le hangar (si autorisé).
   - Modifiez ou supprimez une fiche depuis la page de détails d'un avion.

---

## 2. Pour les Développeurs (Utilisation en Local)

Cette section explique comment installer et exécuter "Vol d'Histoire" sur votre machine locale.

### Prérequis

- **Node.js** (version 14 ou supérieure) : Pour exécuter le serveur backend.
- **PostgreSQL** (version 12 ou supérieure) : Pour la base de données.
- **Git** : Pour cloner le dépôt.

### Structure du Projet

Le projet est organisé comme suit :

```
├── README.md
├── LICENSE
├── list.md
├── backend/
│   ├── package-lock.json
│   ├── package.json
│   ├── server.js
│   └── db_backup/
│       ├── [fichiers SQL des avions, ex. rafale.sql]
└── frontend/
    ├── [pages HTML : index.html, hangar.html, etc.]
    ├── css/
    │   ├── [fichiers CSS : style.css, etc.]
    └── js/
        ├── [fichiers JavaScript : hangar.js, etc.]
```

- **Backend** : Serveur Node.js avec API et scripts SQL pour la base de données.
- **Frontend** : Interface utilisateur en HTML, CSS, et JavaScript.

### Instructions pour Lancer le Projet en Local

1. **Cloner le Dépôt** :
   ```bash
   git clone https://github.com/Lurrod/vol_histoire.git
   cd vol-dhistoire
   ```

2. **Configurer la Base de Données** :
   - Créez une base PostgreSQL nommée `vol_histoire` :
     ```bash
     createdb vol_histoire
     ```
   - Configurez un utilisateur PostgreSQL (ex. `vol_user`) avec un mot de passe :
     ```sql
     CREATE USER vol_user WITH PASSWORD 'votre_mot_de_passe';
     GRANT ALL PRIVILEGES ON DATABASE vol_histoire TO vol_user;
     ```
   - Exécutez le script principal `db.sql` pour créer les tables :
     ```bash
     psql -U vol_user -d vol_histoire -f backend/db_backup/db.sql
     ```
   - Importez les données des avions depuis `db_backup/` (ex. `rafale.sql`) :
     ```bash
     psql -U vol_user -d vol_histoire -f backend/db_backup/rafale.sql
     ```

3. **Installer les Dépendances du Backend** :
   ```bash
   cd backend
   npm install
   ```

4. **Configurer les Variables d'Environnement** :
   - Créez un fichier `.env` dans `backend/` avec :
     ```
     DB_USER=vol_user
     DB_HOST=localhost
     DB_NAME=vol_histoire
     DB_PASSWORD=votre_mot_de_passe
     DB_PORT=5432
     JWT_SECRET=une_chaine_secrete
     PORT=3000
     ```

5. **Lancer le Serveur Backend** :
   ```bash
   node server.js
   ```

6. **Accéder au Frontend** :
   - Depuis le dossier `frontend/`, ouvrez `index.html` avec un serveur local :
     ```bash
     npx live-server frontend/
     ```
   - Ou utilisez un serveur web comme Apache/Nginx pointant vers `frontend/`.

7. **Tester l'Application** :
   - Accédez à `http://localhost:3000` (ou le port configuré).
   - Connectez-vous, explorez le hangar, et testez les fonctionnalités selon votre rôle.

### Contribution

- Soumettez une pull request ou ouvrez une issue sur GitHub pour proposer des améliorations.
- Assurez-vous de tester vos modifications localement avant de contribuer.

---

## 3. Documentation de l'API

L'API du backend, construite avec Node.js et Express, expose des endpoints pour gérer les utilisateurs, les avions et les données associées. Elle utilise PostgreSQL et l'authentification via JWT.

### Configuration

- **Port** : Par défaut `3000` (configurable via `.env`).
- **Authentification** : Token JWT requis pour les routes protégées (admin/éd ത്തeur).

### Endpoints Principaux

#### **Utilisateurs**
- **`POST /api/register`**  
  Inscrit un nouvel utilisateur (rôle par défaut : membre).  
  - **Body** : `{ "name": "string", "email": "string", "password": "string" }`  
  - **Réponse** : `201 { "message": "Utilisateur créé avec succès" }`

- **`POST /api/login`**  
  Connecte un utilisateur et renvoie un token JWT.  
  - **Body** : `{ "email": "string", "password": "string" }`  
  - **Réponse** : `200 { "message": "Connexion réussie", "token": "string" }`

- **`GET /api/users/:id`**  
  Récupère les informations d’un utilisateur (authentifié).  
  - **Paramètre** : `id` (integer)  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `200 { "id": int, "name": "string", "email": "string" }`

- **`PUT /api/users/:id`**  
  Met à jour un utilisateur (authentifié).  
  - **Paramètre** : `id` (integer)  
  - **Body** : `{ "name": "string", "email": "string", "password": "string" }` (optionnel)  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `200 { "message": "Mise à jour réussie", "user": object }`

- **`DELETE /api/users/:id`**  
  Supprime un utilisateur (authentifié).  
  - **Paramètre** : `id` (integer)  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `200 { "message": "Compte supprimé avec succès" }`

- **`GET /api/users`** *(Admin seulement)*  
  Liste tous les utilisateurs.  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `200 [{ "id": int, "name": "string", "email": "string", "role_id": int }]`

#### **Avions**
- **`GET /api/airplanes`**  
  Récupère la liste des avions avec filtres et pagination.  
  - **Query** : 
    - `sort` : `"nation" | "service-date" | "alphabetical" | "generation" | "type" | "default"`
    - `country` : `"string"` (filtre par pays)
    - `generation` : `int` (filtre par génération)
    - `type` : `"string"` (filtre par type)
    - `page` : `int` (pagination, défaut : 1)
  - **Réponse** : `200 { "data": [airplanes], "pagination": { "currentPage": int, "totalPages": int, "totalItems": int } }`

- **`GET /api/airplanes/:id`**  
  Récupère les détails d’un avion.  
  - **Paramètre** : `id` (integer)  
  - **Réponse** : `200 { "id": int, "name": "string", ... }`

- **`POST /api/airplanes`** *(Admin/Éditeur)*  
  Ajoute un avion.  
  - **Body** : `{ "name": "string", "complete_name": "string", ... }`  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `201 { airplane object }`

- **`PUT /api/airplanes/:id`** *(Admin/Éditeur)*  
  Met à jour un avion.  
  - **Paramètre** : `id` (integer)  
  - **Body** : `{ "name": "string", ... }`  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `200 { updated airplane object }`

- **`DELETE /api/airplanes/:id`** *(Admin/Éditeur)*  
  Supprime un avion.  
  - **Paramètre** : `id` (integer)  
  - **Header** : `Authorization: Bearer <token>`  
  - **Réponse** : `200 { "message": "Avion supprimé avec succès" }`

- **`GET /api/airplanes/:id/armament`**  
  Liste l’armement d’un avion.  
  - **Réponse** : `200 [{ "name": "string", "description": "string" }]`

- **`GET /api/airplanes/:id/tech`**  
  Liste les technologies d’un avion.  
  - **Réponse** : `200 [{ "name": "string", "description": "string" }]`

- **`GET /api/airplanes/:id/wars`**  
  Liste les guerres liées à un avion.  
  - **Réponse** : `200 [{ "name": "string", "date_start": "date", "date_end": "date", "description": "string" }]`

- **`GET /api/airplanes/:id/missions`**  
  Liste les missions d’un avion.  
  - **Réponse** : `200 [{ "name": "string", "description": "string" }]`

#### **Autres**
- **`GET /api/countries`** : Liste des pays.  
  - **Réponse** : `200 [{ "id": int, "name": "string" }]`
- **`GET /api/generations`** : Liste des générations.  
  - **Réponse** : `200 [int]`
- **`GET /api/types`** : Liste des types d’avions.  
  - **Réponse** : `200 [{ "id": int, "name": "string", "description": "string" }]`
- **`GET /api/manufacturers`** : Liste des fabricants.  
  - **Réponse** : `200 [{ "id": int, "name": "string", "country_name": "string" }]`

### Exemple d’Utilisation

Pour récupérer les avions triés par nation avec curl :
```bash
curl "http://localhost:3000/api/airplanes?sort=nation&country=France&page=1"
```

---

## Informations Supplémentaires

- **Licence** : Ce projet est protégé par la licence "All Rights Reserved". Aucune utilisation commerciale ou modification sans autorisation.
- **Contact** : Pour toute question, contactez moi <https://titouan-borde.com>

Merci d’explorer "Vol d'Histoire" ! Que vous soyez passionné d’aviation ou développeur, nous espérons que ce projet vous inspirera.