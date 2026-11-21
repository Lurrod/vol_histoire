/**
 * Tests — frontend/js/contact.js sur le vrai <main> de contact.html :
 * validation, envoi (avec ou sans hCaptcha), états du bouton, message de
 * succès effacé à la reprise de saisie, erreurs 429 / serveur / réseau,
 * sujet en pastilles et délais, fiche concernée (?fiche=), compteur, copie
 * de l'adresse.
 *
 * Les aides de formulaire (isValidEmail, setFieldError, clearFieldError) sont
 * celles de utils.js, comme dans le bundle app.min.js.
 */
const fs = require('fs');
const path = require('path');
const utils = require('../js/utils');

const MAIN = /<main[\s\S]*<\/main>/.exec(fs.readFileSync(path.join(__dirname, '..', 'contact.html'), 'utf8'))[0];
const flush = async () => { for (let i = 0; i < 10; i++) await Promise.resolve(); };

let domReady = [];
let addSpy;

function loadContact() {
  document.body.innerHTML = MAIN;
  domReady = [];
  addSpy = jest.spyOn(document, 'addEventListener').mockImplementation(function (type, fn, opts) {
    if (type === 'DOMContentLoaded') { domReady.push(fn); return undefined; }
    return window.EventTarget.prototype.addEventListener.call(this, type, fn, opts);
  });
  jest.isolateModules(() => { require('../js/shared/motion'); require('../js/contact'); });
  // jsdom ne calcule aucune durée : on simule la sortie de 200 ms de contact.css.
  window.VH.motion.exit = (el, done, opts) => {
    el.classList.add(opts.className);
    const timer = setTimeout(() => { el.classList.remove(opts.className); done(); }, 200);
    return () => { clearTimeout(timer); el.classList.remove(opts.className); };
  };
  addSpy.mockRestore();
  domReady.forEach((fn) => fn());
}

const $ = (id) => document.getElementById(id);
function fill({ email = 'ada@test.local', message = 'Bonjour', name = ' Ada Lovelace ', subject = 'bug' } = {}) {
  $('contact-name').value = name;
  $('contact-email').value = email;
  document.querySelector(`input[name="subject"][value="${subject}"]`).checked = true;
  $('contact-message').value = message;
}
const activeDelay = () => document.querySelector('.contact-delays .is-active')?.dataset.topic || null;
const submit = async () => {
  $('contact-form').dispatchEvent(new Event('submit', { cancelable: true }));
  await flush();
};

beforeEach(() => {
  global.isValidEmail = utils.isValidEmail;
  global.setFieldError = utils.setFieldError;
  global.clearFieldError = utils.clearFieldError;
  global.showToast = jest.fn();
  global.i18n = { t: jest.fn((k) => k), currentLang: 'fr' };
  global.fetch = jest.fn(() => Promise.resolve({ ok: true, status: 200, json: () => Promise.resolve({}) }));
  delete window.getHcaptchaToken;
  window.history.replaceState(null, '', '/contact');
});

describe('contact.js — validation', () => {
  test('email invalide : erreur sur le champ, focus, aucun envoi', async () => {
    loadContact();
    fill({ email: 'pas-un-email' });
    await submit();
    expect(global.fetch).not.toHaveBeenCalled();
    expect($('contact-email').getAttribute('aria-invalid')).toBe('true');
    expect($('contact-email-error').textContent).toBe('contact.form_error_email');
    expect(document.activeElement).toBe($('contact-email'));
  });

  test('message vide (espaces) : erreur sur le message, aucun envoi', async () => {
    loadContact();
    fill({ message: '   ' });
    await submit();
    expect(global.fetch).not.toHaveBeenCalled();
    expect($('contact-message-error').textContent).toBe('contact.form_error_message');
    expect(document.activeElement).toBe($('contact-message'));
  });

  test('la saisie efface l’erreur du champ', async () => {
    loadContact();
    fill({ email: '' });
    await submit();
    expect($('contact-email').getAttribute('aria-invalid')).toBe('true');
    $('contact-email').dispatchEvent(new Event('input'));
    expect($('contact-email').hasAttribute('aria-invalid')).toBe(false);
    $('contact-message').dispatchEvent(new Event('input'));
  });

  test('page sans formulaire : rien n’est branché', () => {
    document.body.innerHTML = '<main></main>';
    jest.isolateModules(() => { require('../js/contact'); });
    expect(() => document.dispatchEvent(new Event('DOMContentLoaded'))).not.toThrow();
  });
});

describe('contact.js — envoi', () => {
  test('payload nettoyé envoyé en JSON à /api/contact, formulaire vidé, succès affiché', async () => {
    loadContact();
    fill();
    await submit();

    expect(global.fetch).toHaveBeenCalledWith('/api/contact', expect.objectContaining({
      method: 'POST', headers: { 'Content-Type': 'application/json' },
    }));
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)).toEqual({
      name: 'Ada Lovelace', email: 'ada@test.local', subject: 'bug', message: 'Bonjour',
    });
    expect($('contact-email').value).toBe('');
    expect($('contact-success').classList.contains('visible')).toBe(true);
    expect(document.querySelector('.t-success-check').getAttribute('data-state')).toBe('in');
    expect(showToast).toHaveBeenCalledWith('contact.form_success', 'success');
  });

  test('jeton hCaptcha ajouté quand il existe', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.resolve('jeton-h'));
    loadContact();
    fill();
    await submit();
    expect(window.getHcaptchaToken).toHaveBeenCalledWith('contact');
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)['h-captcha-response']).toBe('jeton-h');
  });

  test('hCaptcha non configuré (null) : pas de champ h-captcha-response', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.resolve(null));
    loadContact();
    fill();
    await submit();
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)).not.toHaveProperty('h-captcha-response');
  });

  test('bouton bloqué pendant l’envoi (aria-busy), restauré à l’identique ensuite', async () => {
    let release;
    global.fetch = jest.fn(() => new Promise((r) => { release = r; }));
    loadContact();
    const btn = document.querySelector('.btn-send');
    const original = btn.innerHTML;
    fill();
    await submit();
    expect(btn.disabled).toBe(true);
    expect(btn.getAttribute('aria-busy')).toBe('true');
    expect(btn.textContent).toContain('contact.form_sending');
    release({ ok: true, status: 200 });
    await flush();
    // Pendant la coche (« envoyé »), pas de second envoi possible.
    expect(btn.disabled).toBe(true);
    expect(btn.hasAttribute('aria-busy')).toBe(false);
    expect(btn.innerHTML.replace(' data-state="done"', '')).toBe(original.replace(' data-state="idle"', ''));
    await new Promise((r) => setTimeout(r, 1900));
    expect(btn.disabled).toBe(false);
    expect(btn.dataset.state).toBe('idle');
  });

  test('échec de l’envoi : bouton réactivé aussitôt, avion reposé', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 500, json: () => Promise.resolve({}) }));
    loadContact();
    const btn = document.querySelector('.btn-send');
    fill();
    await submit();
    await flush();
    expect(btn.disabled).toBe(false);
    expect(btn.dataset.state).toBe('idle');
  });

  test('avion : decolle pendant l’envoi (data-state), libellé « Envoi… », puis coche et retour au repos', async () => {
    let release;
    global.fetch = jest.fn(() => new Promise((r) => { release = r; }));
    loadContact();
    const btn = document.querySelector('.btn-send');
    const label = btn.querySelector('span');
    const labelBefore = label.textContent;
    expect(btn.querySelector('svg.send-icon').getAttribute('aria-hidden')).toBe('true');
    expect(btn.querySelector('i')).toBeNull();
    expect(btn.dataset.state).toBe('idle');
    fill();
    await submit();
    expect(btn.dataset.state).toBe('sending');
    expect(label.textContent).toBe('contact.form_sending');
    jest.useFakeTimers();
    release({ ok: true, status: 200 });
    await flush();
    expect(btn.dataset.state).toBe('done');
    expect(label.textContent).toBe(labelBefore);
    expect(label.getAttribute('data-i18n')).toBe('contact.form_submit');
    jest.advanceTimersByTime(1900);
    expect(btn.dataset.state).toBe('idle');
    jest.useRealTimers();
  });

  test('avion : echec serveur, il revient se poser aussitot (idle)', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 500 }));
    loadContact();
    fill();
    await submit();
    expect(document.querySelector('.btn-send').dataset.state).toBe('idle');
  });

  test('429 : message du serveur affiché', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 429, json: () => Promise.resolve({ message: 'Trop de messages' }) }));
    loadContact();
    fill();
    await submit();
    expect(showToast).toHaveBeenCalledWith('Trop de messages', 'error');
    expect($('contact-email').value).toBe('ada@test.local'); // rien n'est perdu
  });

  test('429 au corps illisible : message générique de limitation', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 429, json: () => Promise.reject(new Error('html')) }));
    loadContact();
    fill();
    await submit();
    expect(showToast).toHaveBeenCalledWith('login.too_many_attempts', 'error');
  });

  test('erreur serveur : message d’échec d’envoi', async () => {
    global.fetch = jest.fn(() => Promise.resolve({ ok: false, status: 500 }));
    loadContact();
    fill();
    await submit();
    expect(showToast).toHaveBeenCalledWith('contact.form_error_send', 'error');
    expect($('contact-success').classList.contains('visible')).toBe(false);
  });

  test('réseau coupé ou hCaptcha bloqué : message d’échec, bouton rendu', async () => {
    window.getHcaptchaToken = jest.fn(() => Promise.reject(new Error('hCaptcha script load error')));
    loadContact();
    fill();
    await submit();
    expect(global.fetch).not.toHaveBeenCalled();
    expect(showToast).toHaveBeenCalledWith('contact.form_error_send', 'error');
    expect(document.querySelector('.btn-send').disabled).toBe(false);
  });
});

describe('contact.js — message de succès', () => {
  beforeEach(() => jest.useFakeTimers());
  afterEach(() => jest.useRealTimers());

  async function sendOk() {
    loadContact();
    fill();
    $('contact-form').dispatchEvent(new Event('submit', { cancelable: true }));
    jest.useRealTimers();
    await flush();
    jest.useFakeTimers();
  }

  test('reprendre la saisie efface le message en fondu (200 ms)', async () => {
    await sendOk();
    const msg = $('contact-success');
    $('contact-form').dispatchEvent(new Event('input'));
    expect(msg.classList.contains('is-hiding')).toBe(true);
    // Un second événement pendant le fondu ne relance rien.
    $('contact-form').dispatchEvent(new Event('change'));
    jest.advanceTimersByTime(200);
    expect(msg.classList.contains('visible')).toBe(false);
    expect(msg.classList.contains('is-hiding')).toBe(false);
    expect(msg.querySelector('.t-success-check').getAttribute('data-state')).toBe('out');
  });

  test('saisie sans message affiché : rien à masquer', () => {
    loadContact();
    $('contact-form').dispatchEvent(new Event('input'));
    expect($('contact-success').classList.contains('is-hiding')).toBe(false);
  });

  test('un nouvel envoi pendant le fondu annule le masquage différé', async () => {
    await sendOk();
    const msg = $('contact-success');
    $('contact-form').dispatchEvent(new Event('input'));
    fill();
    $('contact-form').dispatchEvent(new Event('submit', { cancelable: true }));
    jest.useRealTimers();
    await flush();
    jest.useFakeTimers();
    jest.advanceTimersByTime(500);
    expect(msg.classList.contains('visible')).toBe(true);
    expect(msg.classList.contains('is-hiding')).toBe(false);
  });
});

describe('contact.js — sujet et délais', () => {
  test('sujet par défaut « question » : délai des questions mis en avant', () => {
    loadContact();
    expect(document.querySelector('input[name="subject"]:checked').value).toBe('general');
    expect(activeDelay()).toBe('general');
  });

  test('changer de sujet déplace la mise en avant ; partenariat : aucune ligne', () => {
    loadContact();
    const pick = (v) => {
      const radio = document.querySelector(`input[name="subject"][value="${v}"]`);
      radio.checked = true;
      radio.dispatchEvent(new Event('change', { bubbles: true }));
    };
    pick('contrib');
    expect(activeDelay()).toBe('contrib');
    pick('partner');
    expect(activeDelay()).toBeNull();
  });

  test('?sujet=bug présélectionne la pastille ; valeur inconnue ignorée', () => {
    window.history.replaceState(null, '', '/contact?sujet=bug');
    loadContact();
    expect(document.querySelector('input[name="subject"]:checked').value).toBe('bug');
    expect(activeDelay()).toBe('bug');
    window.history.replaceState(null, '', '/contact?sujet=%22%5D%2C*');
    loadContact();
    expect(document.querySelector('input[name="subject"]:checked').value).toBe('general');
  });
});

describe('contact.js — fiche concernée', () => {
  const aircraftOk = () => Promise.resolve({ ok: true, status: 200, json: () => Promise.resolve({ id: 30, name: 'Dassault Rafale' }) });

  test('?fiche=30 : nom relu par l’API, lien vers la fiche, envoyé avec le message', async () => {
    window.history.replaceState(null, '', '/contact?sujet=bug&fiche=30');
    global.fetch = jest.fn((url) => (url === '/api/airplanes/30'
      ? aircraftOk()
      : Promise.resolve({ ok: true, status: 200, json: () => Promise.resolve({}) })));
    window.VH.shared = { buildDetailsPath: (id, n) => `/details/${n.toLowerCase().replace(/ /g, '-')}-${id}` };
    loadContact();
    await flush();
    expect($('contact-aircraft').hidden).toBe(false);
    expect($('contact-aircraft-link').textContent).toBe('Dassault Rafale');
    expect($('contact-aircraft-link').getAttribute('href')).toBe('/details/dassault-rafale-30');
    fill();
    await submit();
    const body = JSON.parse(global.fetch.mock.calls.find((c) => c[0] === '/api/contact')[1].body);
    expect(body.aircraft_id).toBe(30);
    // Après l'envoi, la fiche ne vaut plus pour le message suivant.
    expect($('contact-aircraft').hidden).toBe(true);
    expect(window.location.search).toBe('?sujet=bug');
    delete window.VH.shared;
  });

  test('sans buildDetailsPath : lien de repli /details?id=', async () => {
    window.history.replaceState(null, '', '/contact?fiche=30');
    global.fetch = jest.fn(aircraftOk);
    loadContact();
    await flush();
    expect($('contact-aircraft-link').getAttribute('href')).toBe('/details?id=30');
  });

  test('retirer la fiche : encadré masqué, adresse nettoyée, rien n’est envoyé', async () => {
    window.history.replaceState(null, '', '/contact?fiche=30#x');
    global.fetch = jest.fn(aircraftOk);
    loadContact();
    await flush();
    $('contact-aircraft-remove').click();
    expect($('contact-aircraft').hidden).toBe(true);
    expect(window.location.search).toBe('');
    expect(window.location.hash).toBe('#x');
    expect(document.activeElement).toBe($('contact-message'));
    global.fetch = jest.fn(() => Promise.resolve({ ok: true, status: 200 }));
    fill();
    await submit();
    expect(JSON.parse(global.fetch.mock.calls[0][1].body)).not.toHaveProperty('aircraft_id');
  });

  test('fiche introuvable, réponse sans nom ou réseau coupé : pas d’encadré', async () => {
    for (const impl of [
      () => Promise.resolve({ ok: false, status: 404 }),
      () => Promise.resolve({ ok: true, status: 200, json: () => Promise.resolve({}) }),
      () => Promise.reject(new Error('réseau')),
    ]) {
      window.history.replaceState(null, '', '/contact?fiche=12');
      global.fetch = jest.fn(impl);
      loadContact();
      await flush();
      expect($('contact-aircraft').hidden).toBe(true);
    }
  });

  test('?fiche= non numérique : aucune requête', () => {
    window.history.replaceState(null, '', '/contact?fiche=abc');
    loadContact();
    expect(global.fetch).not.toHaveBeenCalled();
  });
});

describe('contact.js — compteur du message', () => {
  test('compte les caractères, se met en avant près de la limite', () => {
    loadContact();
    global.i18n.t = jest.fn((k, p) => (k === 'contact.form_count' ? `${p.n} / ${p.max}` : k));
    $('contact-message').value = 'x'.repeat(4600);
    $('contact-message').dispatchEvent(new Event('input'));
    expect($('contact-count').textContent).toBe(`${(4600).toLocaleString('fr-FR')} / ${(5000).toLocaleString('fr-FR')}`);
    expect($('contact-count').classList.contains('is-near')).toBe(true);
    global.i18n.currentLang = 'en';
    window.dispatchEvent(new Event('langChanged'));
    expect($('contact-count').textContent).toBe('4,600 / 5,000');
  });

  test('locales non chargées : repli « n / max » (jamais la clé brute)', () => {
    global.i18n.t = jest.fn((k) => k);
    loadContact();
    $('contact-message').value = 'abc';
    $('contact-message').dispatchEvent(new Event('input'));
    expect($('contact-count').textContent).toBe(`3 / ${(5000).toLocaleString('fr-FR')}`);
  });
});

describe('contact.js — copie de l’adresse', () => {
  afterEach(() => { delete navigator.clipboard; jest.useRealTimers(); });

  test('copie réussie : coche puis retour à l’icône de copie, toast de succès', async () => {
    Object.defineProperty(navigator, 'clipboard', { value: { writeText: jest.fn(() => Promise.resolve()) }, configurable: true });
    loadContact();
    jest.useFakeTimers();
    $('contact-copy').click();
    await Promise.resolve(); await Promise.resolve();
    expect(navigator.clipboard.writeText).toHaveBeenCalledWith('vdh@titouan-borde.com');
    expect($('contact-copy').classList.contains('is-copied')).toBe(true);
    expect(showToast).toHaveBeenCalledWith('Adresse copiée', 'success');
    jest.advanceTimersByTime(1700);
    expect($('contact-copy').classList.contains('is-copied')).toBe(false);
  });

  test('presse-papiers refusé : toast d’erreur', async () => {
    Object.defineProperty(navigator, 'clipboard', { value: { writeText: jest.fn(() => Promise.reject(new Error('refus'))) }, configurable: true });
    loadContact();
    $('contact-copy').click();
    await flush();
    expect($('contact-copy').classList.contains('is-copied')).toBe(false);
    expect(showToast).toHaveBeenCalledWith(expect.stringMatching(/Copie impossible/), 'error');
  });
});
