# Spec — Améliorations Techniques Vol d'Histoire

**Date :** 2026-04-01  
**Projet :** vol-histoire.titouan-borde.com  
**Version cible :** v3.0 technique  
**Approche :** 4 tracks indépendants, avancement long terme  

---

## Contexte

Vol d'Histoire est une encyclopédie web d'aviation militaire (1960→aujourd'hui). Stack : HTML/CSS/JS vanilla + Node.js/Express + PostgreSQL. 68 avions sur 108 prévus. V2.3 en production avec JWT auth, XSS protection, i18n fr/en.

L'objectif est une démarche de qualité globale sans urgence critique, couvrant 4 axes techniques : tests, code quality, performance/SEO, accessibilité. Le redesign visuel est réservé à une session ultérieure (v3.1+).

---

## Track A — Tests

### Objectif
Atteindre 80%+ de couverture backend, introduire des tests E2E frontend, prévenir les régressions lors de l'ajout des 40 avions restants.

### Backend (Jest + Supertest)
- Auditer la couverture actuelle avec `npm run test:coverage`
- Identifier les routes non couvertes : filtres avions (`sort`, `country`, `generation`, `type`), gestion des favoris, refresh token, reset password
- Ajouter des tests d'intégration pour chaque route manquante
- Ajouter des tests unitaires pour les cas limites de `validators.js` (email malformé, mot de passe hors limites, données avion invalides)
- Configurer un seuil bloquant à 80% dans `jest.config.json` (`coverageThreshold`)

### Frontend (Playwright)
- Installer Playwright dans un package `e2e/` à la racine
- Couvrir les flows critiques :
  1. Login / logout
  2. Navigation hangar (filtres, pagination, recherche)
  3. Page détails d'un avion
  4. Ajout/suppression d'un favori (utilisateur connecté)
  5. Changement de langue fr/en
- Les tests E2E tournent contre `localhost` (backend + frontend live-server)

### CI
- Script `npm run test:all` qui enchaîne tests backend + E2E
- Pas de CI cloud pour l'instant — exécution locale avant chaque commit important

---

## Track B — Code Quality

### Objectif
Ramener tous les fichiers sous 400 lignes, une responsabilité par fichier. Aucun changement de comportement — restructuration pure, couverte par les tests Track A.

### Backend — découpage `app.js` (~1000 lignes)
Extraire par domaine :
```
backend/
├── app.js              # assembly : middlewares globaux, mount des routers (~150 lignes)
├── routes/
│   ├── airplanes.js    # GET /airplanes, GET /airplanes/:id, filtres
│   ├── auth.js         # register, login, logout, refresh, verify-email, reset-password
│   ├── users.js        # GET/PUT /users/:id, settings, password change
│   └── favorites.js    # GET/POST/DELETE /favorites
```
- Chaque router exporte un `express.Router()`
- `app.js` fait `app.use('/api', router)` pour chaque module
- Les middlewares partagés (authenticateToken, authorizeRole, rate limiters) vont dans `middleware/auth.js`

### Frontend JS — `settings.js` (1119 lignes)
Découper en sections fonctionnelles :
```
frontend/js/
├── settings.js         # orchestration, init, navigation entre sections (~200 lignes)
├── settings-profile.js # nom, avatar, infos publiques
├── settings-security.js# mot de passe, sessions actives
└── settings-account.js # suppression compte, export données
```

### Frontend CSS — audit duplication
- `tokens.css` : variables CSS (couleurs, espacements, typo) — source unique de vérité
- `base.css` : reset + styles HTML natifs
- `shared.css` : composants réutilisables (boutons, cards, toasts, modals)
- `style.css` : styles spécifiques à l'index uniquement
- Supprimer toute règle dupliquée entre `style.css` et `shared.css`
- Cible : `style.css` < 400 lignes, `shared.css` < 600 lignes

---

## Track C — Performance + SEO

### Objectif
Score Lighthouse ≥ 90 sur Performance et SEO. Indexation Google des 68 fiches avions individuelles.

### Images
- Ajouter `loading="lazy"` sur toutes les `<img>` des cartes hangar et pages détails
- Ajouter `width` et `height` explicites sur chaque image pour éviter le CLS (Cumulative Layout Shift)
- Image hero de l'index : ajouter `<link rel="preload">` dans le `<head>`

### Core Web Vitals
- Identifier le LCP sur l'index et la page hangar via Lighthouse
- Minifier les CSS critiques (inline le CSS above-the-fold si nécessaire)
- Vérifier qu'aucun script bloque le rendu (`defer` ou `async` sur les scripts non-critiques)

### SEO on-page
- Ajouter une `<meta name="description">` unique sur chaque page HTML (hangar, details, timeline, favorites, login, settings)
- Page `details.html` : métadonnées dynamiques générées par JS depuis les données de l'API (`document.title`, `og:title`, `og:description`, `og:image` spécifiques à chaque avion)
- Ajouter des données structurées JSON-LD sur chaque fiche avion (schema.org `ItemPage` avec name, description, image, url)

### Sitemap dynamique
- Ajouter une route `GET /sitemap.xml` dans le backend
- Elle interroge la BDD et génère un XML avec une `<url>` par avion (`/details.html?id=X`) avec `<lastmod>` = date de création
- Le fichier statique `frontend/sitemap.xml` est supprimé — remplacé intégralement par la route backend

### Canonical + hreflang
- Vérifier que toutes les pages ont `<link rel="canonical">` correct
- Hreflang anglais : hors scope de cette spec (traduction en cours)

---

## Track D — Accessibilité

### Objectif
Score Lighthouse Accessibility ≥ 90. Site utilisable sans souris, conforme WCAG AA.

### Navigation clavier
- Tester au clavier chaque page : Tab, Shift+Tab, Enter, Escape, flèches
- Cartes hangar : `tabindex="0"` + gestionnaire `keydown` Enter pour naviguer vers la fiche
- Modals : piéger le focus à l'intérieur (focus trap), fermeture avec Escape
- Filtres et pagination : accessibles au clavier

### ARIA
- Boutons icônes sans texte visible : ajouter `aria-label` (ex: bouton favori "Ajouter aux favoris")
- Toasts de notification : ajouter `aria-live="polite"` sur le conteneur
- Modals : `role="dialog"`, `aria-modal="true"`, `aria-labelledby` pointant sur le titre
- Filtres actifs : `aria-pressed="true/false"` sur les boutons de filtre

### Contrastes WCAG AA
- Auditer avec Lighthouse ou axe DevTools
- Ratio minimum 4.5:1 pour le texte normal, 3:1 pour le texte large
- Corriger les variables CSS dans `tokens.css` si des couleurs ne passent pas

### Sémantique HTML
- Vérifier la présence de `<main>`, `<nav>`, `<header>`, `<footer>` sur chaque page
- Hiérarchie des titres : un seul `<h1>` par page, `<h2>` pour les sections, `<h3>` pour les sous-sections
- Corriger les usages de `<div>` là où un élément sémantique est plus approprié

### Skip link
- Ajouter sur chaque page un lien `<a href="#main-content" class="skip-link">Aller au contenu</a>` visible uniquement au focus
- Style dans `shared.css` : positionné hors écran par défaut, affiché quand `:focus`

---

## Ordre recommandé

1. **Track A** (Tests) en premier — filet de sécurité pour tous les autres tracks
2. **Track B** (Code quality) en second — code plus facile à maintenir pour C et D
3. **Track C et D** en parallèle ou dans l'ordre selon les préférences

---

## Critères de succès

| Track | Critère |
|-------|---------|
| A — Tests | Couverture backend ≥ 80%, 5 flows E2E qui passent |
| B — Code quality | Aucun fichier > 400 lignes (sauf exceptions justifiées), 0 duplication CSS majeure |
| C — Perf/SEO | Lighthouse Performance ≥ 90, SEO ≥ 90, sitemap dynamique actif |
| D — Accessibilité | Lighthouse Accessibility ≥ 90, navigation clavier fonctionnelle sur toutes les pages |

---

## Hors scope (cette spec)

- Redesign visuel UI / animations (prévu v3.1+)
- Ajout des 40 avions manquants (contenu, pas technique)
- Migration vers un framework frontend
- TypeScript
