#!/usr/bin/env node
/**
 * Build CSS bundle : concatène tous les fichiers CSS dans le bon ordre,
 * applique une minification basique (commentaires + whitespace), écrit
 * frontend/css/app.min.css.
 *
 * Utilisé en CI au déploiement (npm run build:css). Le développement local
 * continue à utiliser les fichiers individuels via les <link> existants.
 *
 * Pourquoi pure Node : pas d'esbuild/webpack, zero dépendance ajoutée.
 * La minification est simple mais sûre (regex sur whitespace + commentaires).
 *
 * Stratégie d'intégration : à toi de mettre à jour les <link> dans les HTML
 * pour pointer vers app.min.css à la place des fichiers individuels — c'est
 * une étape manuelle pour ne pas casser le dev workflow par mégarde.
 */

const fs = require('fs');
const path = require('path');

// Ordre de chargement : tokens → icons → base → shared → page-specific.
// Reproduit l'ordre actuel des <link> dans les HTML.
const ORDER = [
  'tokens.css',
  'icons.css',
  'base.css',
  'shared.css',
  'fonts.css',
  // Page-specific : on les inclut TOUS dans le bundle commun. Si une page
  // ne les utilise pas, c'est ~quelques Ko de gaspillage mais 0 RTT.
  'hangar.css',
  'details.css',
  'timeline.css',
  'favorites.css',
  'login.css',
  'settings.css',
  'legal.css',
  'cookies.css',
  'style.css',
  'skeleton.css',
];

const CSS_DIR = path.join(__dirname, '..', 'frontend', 'css');
const OUT = path.join(CSS_DIR, 'app.min.css');

function minify(css) {
  return css
    // Strip /* ... */ comments (non-greedy, multiline)
    .replace(/\/\*[\s\S]*?\*\//g, '')
    // Collapse whitespace runs (mais préserve les espaces nécessaires)
    .replace(/\s+/g, ' ')
    // Remove whitespace around { } : ; ,
    .replace(/\s*([{}:;,>+~])\s*/g, '$1')
    // Remove leading/trailing whitespace
    .replace(/^\s+|\s+$/g, '')
    // Remove le ; final avant }
    .replace(/;}/g, '}')
    // Restore newline avant @media / @keyframes / @layer pour la lisibilité
    .replace(/}@/g, '}\n@');
}

function main() {
  let raw = '';
  let totalIn = 0;
  const missing = [];

  for (const file of ORDER) {
    const fp = path.join(CSS_DIR, file);
    if (!fs.existsSync(fp)) {
      missing.push(file);
      continue;
    }
    const content = fs.readFileSync(fp, 'utf8');
    totalIn += content.length;
    raw += `\n/* === ${file} === */\n` + content;
  }

  if (missing.length) {
    console.warn('  fichiers manquants (skip) :', missing.join(', '));
  }

  const minified = minify(raw);
  fs.writeFileSync(OUT, minified, 'utf8');

  const inKB = (totalIn / 1024).toFixed(1);
  const outKB = (minified.length / 1024).toFixed(1);
  const ratio = (100 - (minified.length / totalIn) * 100).toFixed(0);

  console.log(`OK ${OUT}`);
  console.log(`   ${inKB} KB → ${outKB} KB (-${ratio}%)`);
}

main();
