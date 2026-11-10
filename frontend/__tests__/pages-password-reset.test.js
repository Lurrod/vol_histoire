/**
 * Tests — parcours « mot de passe oublié » sur le vrai <main> des pages :
 *   - js/forgot-password.js : demande du lien (hCaptcha, erreurs, succès) ;
 *   - js/reset-password.js : soumission du nouveau mot de passe (l'indicateur
 *     de force est couvert par reset-password.test.js).
 */
const fs = require('fs');
const path = require('path');

const mainOf = (file) => /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(__dirname, '..', file), 'utf8'))[0];
const FORGOT = mainOf('forgot-password.html');
const RESET = mainOf('reset-password.html');
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };
const $ = (id) => document.getElementById(id);
const jsonRes = (status, body) => Promise.resolve({ ok: status < 300, status, json: () => Promise.resolve(body) });

beforeEach(() => {
  global.auth = { fetchWithTimeout: jest.fn() };
  global.setupPasswordToggle = jest.fn();
  global.i18n = { t: (k) => k };
  delete window.getHcaptchaToken;
});

afterEach(() => {
  jest.useRealTimers();
  window.history.replaceState(null, '', '/');
});

// =============================================================================
// forgot-password.js
// =============================================================================
describe('forgot-password.js', () => {
  function load() {
    document.body.innerHTML = FORGOT;
    jest.isolateModules(() => { require('../js/forgot-password'); });
  }
  async function submit(email) {
    $('fp-email').value = email;
    $('fp-form').dispatchEvent(new Event('submit', { cancelable: true }));
    await flush();
  }

  test('champ vide : aucun envoi', async () => {
    load();
    await submit('   ');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('succès : formulaire masqué, confirmation affichée, adresse nettoyée envoyée', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(200, {}));
    load();
    await submit('  ada@test.local ');
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/auth/forgot-password', expect.objectContaining({ method: 'POST' }));
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ email: 'ada@test.local' });
    expect($('fp-form-section').style.display).toBe('none');
    expect($('fp-success').style.display).toBe('block');
  });

  test('jeton hCaptcha joint à la demande', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('h-tok'));
    auth.fetchWithTimeout.mockReturnValue(jsonRes(200, {}));
    load();
    await submit('ada@test.local');
    expect(window.getHcaptchaToken).toHaveBeenCalledWith('forgot');
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)['h-captcha-response']).toBe('h-tok');
  });

  test('bouton bloqué pendant la requête', async () => {
    let release;
    auth.fetchWithTimeout.mockReturnValue(new Promise((r) => { release = r; }));
    load();
    await submit('ada@test.local');
    expect($('fp-submit-btn').disabled).toBe(true);
    expect($('fp-submit-btn').querySelector('.loading-spinner')).not.toBeNull();
    release({ ok: true });
    await flush();
  });

  test('refus du serveur : message affiché, champ marqué invalide, bouton rendu', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(429, { message: 'Trop de demandes' }));
    load();
    await submit('ada@test.local');
    expect($('fp-error').textContent).toBe('Trop de demandes');
    expect($('fp-error').style.display).toBe('block');
    expect($('fp-email').getAttribute('aria-invalid')).toBe('true');
    expect($('fp-submit-btn').disabled).toBe(false);
  });

  test('refus sans message : texte générique', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(500, {}));
    load();
    await submit('ada@test.local');
    expect($('fp-error').textContent).toBe('Une erreur est survenue.');
  });

  test('nouvel essai : l’erreur précédente est effacée', async () => {
    auth.fetchWithTimeout.mockReturnValueOnce(jsonRes(500, {})).mockReturnValueOnce(jsonRes(200, {}));
    load();
    await submit('ada@test.local');
    await submit('ada@test.local');
    expect($('fp-error').style.display).toBe('none');
    expect($('fp-email').hasAttribute('aria-invalid')).toBe(false);
  });

  test('réseau coupé : message dédié', async () => {
    auth.fetchWithTimeout.mockRejectedValue(new TypeError('Failed to fetch'));
    load();
    await submit('ada@test.local');
    expect($('fp-error').textContent).toBe('Impossible de contacter le serveur. Réessayez plus tard.');
    expect($('fp-submit-btn').disabled).toBe(false);
  });

  /*
   * Régression (forgot-password.js, setLoading) — après une erreur, le bouton
   * était réécrit avec un libellé français en dur et SANS le <span data-i18n> :
   * sur la page anglaise il repassait en « Envoyer le lien ».
   */
  test('le bouton retrouve son balisage traduisible après une erreur', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(500, {}));
    load();
    $('fp-submit-btn').querySelector('[data-i18n]').textContent = 'Send the link';
    const original = $('fp-submit-btn').innerHTML;
    await submit('ada@test.local');
    expect($('fp-submit-btn').innerHTML).toBe(original);
    expect($('fp-submit-btn').textContent).toContain('Send the link');
  });
});

// =============================================================================
// reset-password.js — soumission
// =============================================================================
describe('reset-password.js — soumission', () => {
  function load(search = '?token=tok-1') {
    window.history.replaceState(null, '', `/reset-password${search}`);
    document.body.innerHTML = RESET;
    jest.isolateModules(() => { require('../js/reset-password'); });
  }
  async function submit(pw, confirm = pw) {
    $('rp-password').value = pw;
    $('rp-password-confirm').value = confirm;
    $('rp-form').dispatchEvent(new Event('submit', { cancelable: true }));
    await flush();
  }

  test('branche l’œil sur chacun des deux champs', () => {
    load();
    expect(global.setupPasswordToggle).toHaveBeenCalledWith($('toggle-rp-pw'), $('rp-password'));
    expect(global.setupPasswordToggle).toHaveBeenCalledWith($('toggle-rp-pw-confirm'), $('rp-password-confirm'));
  });

  test('confirmation différente : refusée avant envoi', async () => {
    load();
    await submit('Motdepasse1', 'Motdepasse2');
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    expect($('rp-error').textContent).toBe('Les mots de passe ne correspondent pas.');
    expect($('rp-password').getAttribute('aria-invalid')).toBe('true');
  });

  test.each(['Court1', 'sansmajuscule1', 'SANSMINUSCULE1', 'SansChiffre'])('mot de passe faible refusé : %s', async (pw) => {
    load();
    await submit(pw);
    expect(auth.fetchWithTimeout).not.toHaveBeenCalled();
    expect($('rp-error').textContent).toMatch(/^Mot de passe invalide/);
  });

  test('succès : jeton + mot de passe envoyés, confirmation, redirection vers /login après 2 s', async () => {
    jest.useFakeTimers();
    auth.fetchWithTimeout.mockReturnValue(jsonRes(200, {}));
    load();
    await submit('Motdepasse1');
    expect(auth.fetchWithTimeout).toHaveBeenCalledWith('/api/auth/reset-password', expect.objectContaining({ method: 'POST' }));
    expect(JSON.parse(auth.fetchWithTimeout.mock.calls[0][1].body)).toEqual({ token: 'tok-1', password: 'Motdepasse1' });
    expect($('rp-form-section').querySelector('.rp-success')).not.toBeNull();

    const errors = jest.spyOn(console, 'error').mockImplementation(() => {});
    try {
      jest.advanceTimersByTime(1999);
      expect(errors).not.toHaveBeenCalled();
      jest.advanceTimersByTime(1);
      expect(errors.mock.calls.some(([e]) => /navigation/.test(String(e && e.message)))).toBe(true);
    } finally {
      errors.mockRestore();
    }
  });

  test('autre refus : message du serveur, bouton rendu, erreur effacée au nouvel essai', async () => {
    auth.fetchWithTimeout.mockReturnValueOnce(jsonRes(400, { message: 'Mot de passe déjà utilisé' }))
      .mockReturnValueOnce(jsonRes(400, {}));
    load();
    await submit('Motdepasse1');
    expect($('rp-error').textContent).toBe('Mot de passe déjà utilisé');
    expect($('rp-submit-btn').disabled).toBe(false);
    await submit('Motdepasse1');
    expect($('rp-error').textContent).toBe('Une erreur est survenue.');
  });

  test('réseau coupé : message dédié, bouton rendu', async () => {
    auth.fetchWithTimeout.mockRejectedValue(new TypeError('Failed to fetch'));
    load();
    await submit('Motdepasse1');
    expect($('rp-error').textContent).toBe('Impossible de contacter le serveur. Réessayez plus tard.');
    expect($('rp-submit-btn').disabled).toBe(false);
  });

  test('lien expiré à la soumission : le formulaire est masqué', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(400, { code: 'TOKEN_INVALID' }));
    load();
    await submit('Motdepasse1');
    expect($('rp-form-section').classList.contains('hidden')).toBe(true);
  });

  /*
   * Régression (reset-password.js) — sur TOKEN_INVALID, « Lien invalide » était
   * montré par style.display = 'block', battu par .hidden (display: none
   * !important) : carte vide. Désormais par la classe, comme « jeton absent ».
   */
  test('lien expiré à la soumission : le message « lien invalide » est affiché', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(400, { code: 'TOKEN_INVALID' }));
    load();
    await submit('Motdepasse1');
    expect($('rp-invalid').classList.contains('hidden')).toBe(false);
  });

  test('le bouton retrouve son balisage traduisible après une erreur', async () => {
    auth.fetchWithTimeout.mockReturnValue(jsonRes(400, { message: 'Refus' }));
    load();
    const original = $('rp-submit-btn').innerHTML;
    await submit('Motdepasse1');
    expect($('rp-submit-btn').innerHTML).toBe(original);
    expect($('rp-submit-btn').querySelector('[data-i18n="reset_password.submit"]')).not.toBeNull();
  });
});
