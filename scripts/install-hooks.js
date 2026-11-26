/* Active les hooks Git versionnés (.githooks/) : lancé par le script
 * « prepare » de package.json à chaque `npm install` / `npm ci` à la racine.
 * Hors dépôt Git (archive, image de déploiement), ne fait rien. */
const { execFileSync } = require('child_process');

try {
  execFileSync('git', ['rev-parse', '--is-inside-work-tree'], { stdio: 'ignore' });
  execFileSync('git', ['config', 'core.hooksPath', '.githooks'], { stdio: 'ignore' });
  console.log('Hooks Git : core.hooksPath → .githooks');
} catch {
  // Pas de dépôt Git ou git absent : rien à activer.
}
