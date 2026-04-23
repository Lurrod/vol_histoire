# `frontend/css/` — Sources & bundles

**Ces fichiers sont des sources — NE PAS linker directement dans les pages HTML.**
Les pages chargent uniquement les bundles `*.min.css` générés par `scripts/build-css.js`.

## Rebuild

```bash
node scripts/build-css.js
```

À relancer après toute modification d'une source.

## Sources (versionnées, non servies)

| Fichier         | Rôle                                                  |
| --------------- | ----------------------------------------------------- |
| `tokens.css`    | Variables CSS (couleurs, spacing, typo, breakpoints). |
| `icons.css`     | Font Awesome subset (161 icônes).                     |
| `base.css`      | Reset, typo globale, styles HTML nus.                 |
| `shared.css`    | Composants partagés (boutons, cartes, toasts).        |
| `fonts.css`     | `@font-face` (Space Grotesk, Orbitron).               |
| `cookies.css`   | Bannière + modale de consentement.                    |
| `style.css`     | Page d'accueil (`/`).                                 |
| `hangar.css`    | `/hangar` (liste + filtres).                          |
| `details.css`   | `/details/:slug` (fiche appareil).                    |
| `timeline.css`  | `/timeline` (Journal de Bord).                        |
| `favorites.css` | `/favorites`.                                         |
| `login.css`     | `/login`, `/check-email`, `/forgot-password`.         |
| `settings.css`  | `/settings` (dashboard + admin).                      |
| `legal.css`     | `/mentions-legales`, `/cgu`, `/politique-confidentialite`, `/contact`. |
| `contact.css`   | Overrides spécifiques à `/contact`.                   |

## Bundles (générés, servis)

Chaque page charge `core.min.css` + le bundle de la page :

```
core.min.css     ← tokens + icons + base + shared + fonts + cookies
home.min.css     ← style.css
hangar.min.css   ← hangar.css
details.min.css  ← details.css
timeline.min.css ← timeline.css
favorites.min.css← favorites.css
login.min.css    ← login.css
settings.min.css ← settings.css
legal.min.css    ← legal.css
contact.min.css  ← contact.css
```

Source de vérité de la map : `scripts/build-css.js` (const `BUNDLES`).

## Règles

- Ajouter une nouvelle source → l'intégrer à un bundle dans `BUNDLES` (sinon elle ne sera jamais servie).
- Renommer une source → mettre à jour `BUNDLES` + rebuilder.
- **Ne pas commiter de modification manuelle dans un `*.min.css`** — il sera écrasé au prochain build.
- CSP : styles inline interdits depuis v4.1.1 (`unsafe-inline` retiré sauf fallback). Toute règle visuelle passe par ces fichiers.
