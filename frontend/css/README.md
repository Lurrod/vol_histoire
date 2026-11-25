# `frontend/css/` — Sources & bundles

**Ces fichiers sont des sources — NE PAS linker directement dans les pages HTML.**
Les pages chargent uniquement les bundles `*.min.css` générés par `scripts/build-css.js`.

## Rebuild

```bash
node scripts/build-css.js      # ou `npm run build` à la racine (JS + CSS)
```

À relancer après toute modification d'une source.

## Sources (versionnées, non servies)

| Famille | Rôle |
| --- | --- |
| `tokens.css` | Jetons : couleurs et voiles (`--white-aNN`, `--gold-aNN`…), typo, espacements, mouvement, z-index. Ordre des couches `@layer`. |
| `icons.css` | Icônes SVG pré-extraites (`.icon`, `.icon-x`, voir `js/icons.js`). |
| `base.css` | Reset, typographie globale, focus. |
| `shared-*.css` | Composants communs à toutes les pages : en-tête, boutons, formulaires, modales, toasts, pied de page, menu underlay, sommaire, morphings, visite guidée. |
| `fonts.css` | `@font-face` : DM Sans (variable) et Barlow Condensed (400 à 700), auto-hébergées. |
| `cookies.css` | Bandeau et fenêtre de consentement. |
| `style-*.css`, `home-landing.css` | Accueil. |
| `catalog.css` | Bandeau, recherche, filtres et cartes communs au hangar, aux favoris et aux conflits. |
| `hangar.css`, `compare.css`, `nations-map.css` | Hangar, comparateur, carte des nations. |
| `details*.css` | Fiche appareil (`details-print.css` : export PDF / impression). |
| `timeline*.css` | Frise (Journal de bord). |
| `favorites.css`, `conflicts.css` | Favoris, conflits. |
| `login*.css`, `otp-input.css` | Connexion, inscription, étapes par code. |
| `settings*.css` | Paramètres et administration. |
| `legal.css`, `contact.css` | Pages légales, contact. |

## Bundles (générés, servis)

Chaque page charge `core.min.css` + le bundle de la page (la fiche y ajoute `details-print.min.css` en `media="print"`). Composition (recopie
de `BUNDLES` dans `scripts/build-css.js`, vérifiée par
`frontend/__tests__/css-readme.test.js`) :

<!-- bundles:start -->
```
core.min.css          ← tokens.css + icons.css + base.css + shared-base.css + shared-controls.css + shared-feedback.css + shared-layout.css + shared-widgets.css + shared-responsive.css + shared-underlay.css + shared-utilities.css + shared-morph.css + shared-toc.css + shared-onboarding.css + fonts.css + cookies.css
home.min.css          ← style-hero.css + style-sections.css + style-extras.css + style-hero-split.css + nations-map.css + home-landing.css
hangar.min.css        ← catalog.css + hangar.css + compare.css + nations-map.css
details.min.css       ← details.css + details-profile.css + details-specs.css + details-lineage.css + compare.css
details-print.min.css ← details-print.css
timeline.min.css      ← timeline.css + timeline-navigation.css + timeline-responsive.css
favorites.min.css     ← catalog.css + favorites.css
conflicts.min.css     ← catalog.css + favorites.css + conflicts.css
login.min.css         ← otp-input.css + login.css + login-steps.css
settings.min.css      ← otp-input.css + settings.css + settings-sections.css
legal.min.css         ← legal.css
contact.min.css       ← contact.css
```
<!-- bundles:end -->

L'ordre des fichiers dans un bundle est celui de la cascade : ne pas le changer
sans vérifier le rendu.

## Règles

- Ajouter une nouvelle source → l'intégrer à un bundle dans `BUNDLES` (sinon elle ne sera jamais servie), puis recopier la composition ci-dessus.
- Renommer une source → mettre à jour `BUNDLES` + rebuilder.
- **Ne pas commiter de modification manuelle dans un `*.min.css`** — il sera écrasé au prochain build.
- Couleurs : passer par un jeton de `tokens.css` (`frontend/__tests__/css-color-tokens.test.js` refuse toute nouvelle couleur en dur).
- Une feuille source reste sous 800 lignes.
- CSP : aucun attribut `style` dans le HTML (`style-src-attr 'none'`). Toute règle visuelle passe par ces fichiers ; un style dynamique s'écrit par le CSSOM.
