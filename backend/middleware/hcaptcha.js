/**
 * Vérification hCaptcha côté serveur.
 *
 * Documentation : https://docs.hcaptcha.com/
 *
 * Configuration via variables d'environnement :
 *   HCAPTCHA_SECRET   : clé secrète (sk_xxx, fournie par hCaptcha)
 *   HCAPTCHA_SITEKEY  : clé publique (utilisée côté frontend)
 *
 * C'est la clé SECRÈTE qui décide, pas la clé publique : dès que
 * HCAPTCHA_SECRET est posé, un jeton valide est exigé (absent, vide, d'un
 * autre type qu'une chaîne → refus sans même interroger hCaptcha).
 * Sans clé secrète :
 *   - hors production, la vérification est sautée (développement local) ;
 *   - en production, elle échoue (fermé par défaut) — et server.js refuse de
 *     démarrer sans les deux clés (captchaConfigErrors).
 * En CI / test, le secret de test '0x0000000000000000000000000000000000000000'
 * valide tout.
 *
 * Usage :
 *   const verifyHcaptcha = require('./middleware/hcaptcha');
 *   router.post('/register', verifyHcaptcha, asyncHandler(...));
 */

const HCAPTCHA_VERIFY_URL = 'https://api.hcaptcha.com/siteverify';

/**
 * Clés effectives. En développement (ni production ni test), le captcha est
 * DÉSACTIVÉ : pas de widget (/api/config ne publie pas de clé) et
 * vérification sautée — hCaptcha refuse de toute façon localhost et
 * 127.0.0.1 avec de vraies clés (« Please use a valid host »), et le .env
 * local porte celles de production. Production et tests automatisés : clés
 * telles que configurées (les suites Jest posent les leurs et simulent
 * siteverify).
 * @param {Record<string, string|undefined>} env
 * @returns {{ secret: string, sitekey: string }}
 */
function captchaKeys(env) {
  if (env.NODE_ENV !== 'production' && env.NODE_ENV !== 'test') return { secret: '', sitekey: '' };
  return { secret: env.HCAPTCHA_SECRET || '', sitekey: env.HCAPTCHA_SITEKEY || '' };
}

/**
 * Variables hCaptcha manquantes au démarrage. En production, les deux clés
 * vont ensemble : sans la secrète, tout serait refusé ; sans la publique, le
 * navigateur n'enverrait jamais de jeton et les formulaires seraient bloqués.
 * @param {Record<string, string|undefined>} env
 * @returns {string[]} noms des variables manquantes (vide si rien à signaler)
 */
function captchaConfigErrors(env) {
  if (env.NODE_ENV !== 'production') return [];
  return ['HCAPTCHA_SECRET', 'HCAPTCHA_SITEKEY'].filter((name) => !env[name]);
}

async function verify(token, remoteIp) {
  const { secret, sitekey } = captchaKeys(process.env);

  if (!secret) {
    // Production sans clé : on refuse plutôt que de tout laisser passer.
    if (process.env.NODE_ENV === 'production') return { ok: false, reason: 'not-configured' };
    return { ok: true, skipped: true }; // développement local
  }

  // Token absent : reject
  if (!token || typeof token !== 'string') {
    return { ok: false, reason: 'missing-token' };
  }

  const params = new URLSearchParams();
  params.set('secret', secret);
  params.set('response', token);
  if (remoteIp) params.set('remoteip', remoteIp);
  // Lie le jeton à la clé publique de CE site : un jeton émis pour une autre
  // clé du même compte hCaptcha est refusé (paramètre recommandé par hCaptcha).
  if (sitekey) params.set('sitekey', sitekey);

  try {
    const res = await fetch(HCAPTCHA_VERIFY_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: params.toString(),
    });
    if (!res.ok) {
      return { ok: false, reason: 'http-' + res.status };
    }
    const data = await res.json();
    return { ok: !!data.success, raw: data };
  } catch (err) {
    return { ok: false, reason: 'network-error', error: err.message };
  }
}

/**
 * Express middleware. Lit le token dans req.body['h-captcha-response']
 * (nom standard du widget hCaptcha) ou req.body.captcha en fallback.
 * Renvoie 400 si invalide. Passe au next() si OK ou skippé.
 */
function verifyHcaptcha(req, res, next) {
  const body = req.body || {};
  const token = body['h-captcha-response'] || body.captcha;
  verify(token, req.ip).then(result => {
    if (!result.ok) {
      return res.status(400).json({
        message: 'Vérification anti-spam échouée. Réessayez.',
        code: 'CAPTCHA_FAILED',
      });
    }
    next();
  }).catch(next);
}

module.exports = verifyHcaptcha;
module.exports.verify = verify;
module.exports.captchaConfigErrors = captchaConfigErrors;
module.exports.captchaKeys = captchaKeys;
