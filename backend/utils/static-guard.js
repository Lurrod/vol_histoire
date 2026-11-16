/**
 * Fichiers de frontend/ qui ne doivent jamais être servis.
 *
 * express.static expose tout le dossier frontend/, qui contient aussi les
 * outils de dev (node_modules de Jest, tests, manifestes npm, docs, coverage).
 * Rien de secret, mais ça révèle les versions exactes des dépendances et le
 * code des tests. Le filtre passe avant express.static et répond 404 avec la
 * même page que n'importe quelle URL absente : un format à part (« Not Found »
 * en texte brut) signalait justement qu'il y avait là quelque chose à cacher.
 */

const PRIVATE_DIRS = new Set(['node_modules', '__tests__', 'coverage']);
const PRIVATE_FILES = new Set(['package.json', 'package-lock.json', 'jest.config.json']);
const PUBLIC_DOT_DIRS = new Set(['.well-known']);

function isPrivateStaticPath(urlPath) {
  let decoded;
  try {
    decoded = decodeURIComponent(urlPath);
  } catch {
    return true; // encodage invalide : express.static le rejetterait aussi
  }
  const segments = decoded.toLowerCase().split('/').filter(Boolean);
  const basename = segments[segments.length - 1] || '';
  return segments.some(s => PRIVATE_DIRS.has(s) || (s.startsWith('.') && !PUBLIC_DOT_DIRS.has(s)))
    || PRIVATE_FILES.has(basename)
    || basename.endsWith('.md');
}

/**
 * @param {(req: object, res: object) => void} sendNotFound réponse 404 du site
 * @returns {Function} middleware Express
 */
function createPrivateStaticGuard(sendNotFound) {
  return function blockPrivateStatic(req, res, next) {
    if (isPrivateStaticPath(req.path)) return sendNotFound(req, res);
    return next();
  };
}

module.exports = { isPrivateStaticPath, createPrivateStaticGuard };
