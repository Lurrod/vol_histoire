/**
 * Vérification hCaptcha côté serveur.
 *
 * Documentation : https://docs.hcaptcha.com/
 *
 * Configuration via variables d'environnement :
 *   HCAPTCHA_SECRET   : clé secrète (sk_xxx, fournie par hCaptcha)
 *   HCAPTCHA_SITEKEY  : clé publique (utilisée côté frontend)
 *
 * Si HCAPTCHA_SECRET n'est pas défini, la vérification est SKIPPÉE
 * (mode développement / pas encore configuré). En CI / test, le secret
 * de test '0x0000000000000000000000000000000000000000' valide tout.
 *
 * Usage :
 *   const verifyHcaptcha = require('./middleware/hcaptcha');
 *   router.post('/register', verifyHcaptcha, asyncHandler(...));
 */

const HCAPTCHA_VERIFY_URL = 'https://api.hcaptcha.com/siteverify';

async function verify(token, remoteIp) {
  const secret = process.env.HCAPTCHA_SECRET;

  // Mode dev / non configuré : on laisse passer
  if (!secret) return { ok: true, skipped: true };

  // Token absent : reject
  if (!token || typeof token !== 'string') {
    return { ok: false, reason: 'missing-token' };
  }

  const params = new URLSearchParams();
  params.set('secret', secret);
  params.set('response', token);
  if (remoteIp) params.set('remoteip', remoteIp);

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
  const token = req.body['h-captcha-response'] || req.body.captcha;
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
