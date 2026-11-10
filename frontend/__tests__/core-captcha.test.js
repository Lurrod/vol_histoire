/**
 * Tests — frontend/js/captcha.js : chargement à la demande de hCaptcha.
 *
 * Exigences vérifiées :
 *   - sans clé de site configurée côté serveur, aucun script tiers n'est
 *     chargé et le jeton vaut null (le backend saute alors la vérification) ;
 *   - le script n'est chargé qu'au premier appel (soumission), une seule fois ;
 *   - un widget invisible par formulaire, réinitialisé aux appels suivants.
 */

const hcaptchaScripts = () => Array.from(document.head.querySelectorAll('script'))
  .filter((s) => (s.src || '').includes('hcaptcha.com'));
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };

function loadCaptcha() {
  delete window.getHcaptchaToken;
  jest.isolateModules(() => { require('../js/captcha'); });
  return window.getHcaptchaToken;
}

function configResponse(body, ok = true) {
  return Promise.resolve({ ok, json: () => Promise.resolve(body) });
}

/** Appelle getHcaptchaToken et simule l'arrivée du script hCaptcha. */
async function callAndLoad(getToken, scope, { fail = false } = {}) {
  const p = getToken(scope);
  await flush();
  const script = hcaptchaScripts()[0];
  if (script && !script.dataset.done) {
    script.dataset.done = '1';
    if (fail) script.onerror(); else script.onload();
  }
  return p;
}

beforeEach(() => {
  document.head.innerHTML = '';
  document.body.innerHTML = '';
  global.fetch = jest.fn();
  delete global.hcaptcha;
});

describe('captcha.js — sans clé de site', () => {
  test('clé absente de /api/config : null, aucun script tiers', async () => {
    global.fetch.mockReturnValue(configResponse({}));
    const getToken = loadCaptcha();
    await expect(getToken('contact')).resolves.toBeNull();
    expect(global.fetch).toHaveBeenCalledWith('/api/config');
    expect(hcaptchaScripts()).toHaveLength(0);
  });

  test('/api/config en erreur HTTP : null, aucun script tiers', async () => {
    global.fetch.mockReturnValue(configResponse({}, false));
    const getToken = loadCaptcha();
    await expect(getToken('forgot')).resolves.toBeNull();
    expect(hcaptchaScripts()).toHaveLength(0);
  });

  test('réseau coupé : null, et nouvel essai au prochain appel', async () => {
    global.fetch.mockRejectedValueOnce(new TypeError('Failed to fetch'));
    const getToken = loadCaptcha();
    await expect(getToken('forgot')).resolves.toBeNull();
    global.fetch.mockReturnValue(configResponse({}));
    await getToken('forgot');
    expect(global.fetch).toHaveBeenCalledTimes(2);
  });

  test('rien n’est demandé au chargement de la page', () => {
    loadCaptcha();
    expect(global.fetch).not.toHaveBeenCalled();
    expect(typeof window.getHcaptchaToken).toBe('function');
  });
});

describe('captcha.js — avec clé de site', () => {
  beforeEach(() => {
    global.fetch.mockReturnValue(configResponse({ hcaptchaSitekey: 'site-123' }));
    global.hcaptcha = {
      render: jest.fn(() => 'w1'),
      reset: jest.fn(),
      execute: jest.fn(() => Promise.resolve({ response: 'jeton-abc' })),
    };
  });

  test('premier appel : script chargé en mode explicite, widget invisible, jeton rendu', async () => {
    const getToken = loadCaptcha();
    const token = await callAndLoad(getToken, 'contact');

    expect(token).toBe('jeton-abc');
    const [script] = hcaptchaScripts();
    expect(script.src).toBe('https://js.hcaptcha.com/1/api.js?render=explicit');
    expect(script.async).toBe(true);
    const container = document.getElementById('hcaptcha-contact');
    expect(container).not.toBeNull();
    expect(global.hcaptcha.render).toHaveBeenCalledWith(container, { sitekey: 'site-123', size: 'invisible' });
    expect(global.hcaptcha.execute).toHaveBeenCalledWith('w1', { async: true });
  });

  test('appels suivants : un seul script, une seule requête de config, widget réinitialisé', async () => {
    const getToken = loadCaptcha();
    await callAndLoad(getToken, 'contact');
    await getToken('contact');

    expect(hcaptchaScripts()).toHaveLength(1);
    expect(global.fetch).toHaveBeenCalledTimes(1);
    expect(global.hcaptcha.render).toHaveBeenCalledTimes(1);
    expect(global.hcaptcha.reset).toHaveBeenCalledWith('w1');
  });

  test('un widget par formulaire', async () => {
    global.hcaptcha.render.mockReturnValueOnce('w1').mockReturnValueOnce('w2');
    const getToken = loadCaptcha();
    await callAndLoad(getToken, 'register');
    await getToken('forgot');
    expect(document.getElementById('hcaptcha-register')).not.toBeNull();
    expect(document.getElementById('hcaptcha-forgot')).not.toBeNull();
    expect(global.hcaptcha.render).toHaveBeenCalledTimes(2);
    expect(global.hcaptcha.reset).not.toHaveBeenCalled();
  });

  test('conteneur déjà présent dans la page : réutilisé', async () => {
    document.body.innerHTML = '<div id="hcaptcha-contact"></div>';
    const existing = document.getElementById('hcaptcha-contact');
    const getToken = loadCaptcha();
    await callAndLoad(getToken, 'contact');
    expect(global.hcaptcha.render.mock.calls[0][0]).toBe(existing);
    expect(document.querySelectorAll('#hcaptcha-contact')).toHaveLength(1);
  });

  test('deux appels simultanés : le script n’est inséré qu’une fois', async () => {
    const getToken = loadCaptcha();
    const a = getToken('contact');
    const b = getToken('contact');
    await flush();
    expect(hcaptchaScripts()).toHaveLength(1);
    hcaptchaScripts()[0].onload();
    await expect(Promise.all([a, b])).resolves.toEqual(['jeton-abc', 'jeton-abc']);
  });

  test('défi refusé ou fermé (execute rejette) : null', async () => {
    global.hcaptcha.execute.mockRejectedValueOnce(new Error('challenge-closed'));
    const getToken = loadCaptcha();
    await expect(callAndLoad(getToken, 'contact')).resolves.toBeNull();
  });

  test('réponse sans jeton : null', async () => {
    global.hcaptcha.execute.mockResolvedValueOnce({});
    const getToken = loadCaptcha();
    await expect(callAndLoad(getToken, 'contact')).resolves.toBeNull();
  });

  test('script chargé mais objet hcaptcha absent (bloqueur) : null', async () => {
    delete global.hcaptcha;
    const getToken = loadCaptcha();
    await expect(callAndLoad(getToken, 'contact')).resolves.toBeNull();
  });

  test('script bloqué (onerror) : la promesse est rejetée — l’appelant affiche son erreur', async () => {
    const getToken = loadCaptcha();
    await expect(callAndLoad(getToken, 'contact', { fail: true })).rejects.toThrow('hCaptcha script load error');
  });

  /*
   * Régression (captcha.js, loadScript) — après un échec de chargement,
   * `scriptLoading` gardait la promesse rejetée : tous les appels suivants
   * échouaient sans réessayer, jusqu'au rechargement de la page.
   */
  test('après un échec de chargement, un nouvel appel retente le script', async () => {
    const getToken = loadCaptcha();
    await callAndLoad(getToken, 'contact', { fail: true }).catch(() => {});
    // La balise en échec est retirée par captcha.js lui-même
    expect(hcaptchaScripts()).toHaveLength(0);
    const p = getToken('contact');
    await flush();
    expect(hcaptchaScripts()).toHaveLength(1);
    hcaptchaScripts()[0].onload();
    await expect(p).resolves.toBe('jeton-abc');
  });
});
