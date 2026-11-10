/**
 * Tests — shared/airplane-options.js et listes de filiation du formulaire de
 * création (hangar/admin.js). L'API plafonne `limit` à 100 (JS-001).
 */

const API_CAP = 100;

function jsonResponse(body, ok = true, status = 200) {
  return Promise.resolve({ ok, status, json: () => Promise.resolve(body) });
}

function catalogue(size) {
  return Array.from({ length: size }, (_, i) => ({ id: i + 1, name: `Appareil ${String(i + 1).padStart(3, '0')}` }));
}

function apiFor(list) {
  return jest.fn((url) => {
    const params = new window.URL(url, 'http://local').searchParams;
    const limit = Math.min(API_CAP, parseInt(params.get('limit'), 10) || API_CAP);
    const page = parseInt(params.get('page'), 10) || 1;
    return jsonResponse({ data: list.slice((page - 1) * limit, page * limit), total: list.length, page, limit });
  });
}

function setupGlobals(fetchImpl) {
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.showToast = jest.fn();
  global.i18n = { t: (k) => k, currentLang: 'fr' };
  global.auth = { fetchWithTimeout: fetchImpl };
}

describe('shared/airplane-options', () => {
  let opts;
  beforeEach(() => {
    jest.resetModules();
    window.VH = {};
  });

  test('fetchAll parcourt toutes les pages d\'après total', async () => {
    const api = apiFor(catalogue(434));
    setupGlobals(api);
    opts = require('../js/shared/airplane-options');
    const list = await opts.fetchAll();
    expect(list).toHaveLength(434);
    expect(api).toHaveBeenCalledTimes(5);
    expect(api.mock.calls.every(([u]) => /limit=100&page=\d/.test(u))).toBe(true);
  });

  test('fetchAll garde le résultat, invalidate force un nouveau chargement', async () => {
    const api = apiFor(catalogue(50));
    setupGlobals(api);
    opts = require('../js/shared/airplane-options');
    await opts.fetchAll();
    await opts.fetchAll();
    expect(api).toHaveBeenCalledTimes(1);
    opts.invalidate();
    await opts.fetchAll();
    expect(api).toHaveBeenCalledTimes(2);
  });

  test('un échec rejette et n\'est pas mis en cache', async () => {
    let fail = true;
    const ok = apiFor(catalogue(10));
    setupGlobals(jest.fn((url) => (fail ? jsonResponse({}, false, 429) : ok(url))));
    opts = require('../js/shared/airplane-options');
    await expect(opts.fetchAll()).rejects.toThrow('HTTP 429');
    fail = false;
    await expect(opts.fetchAll()).resolves.toHaveLength(10);
  });

  test('une réponse sans tableau data est rejetée', async () => {
    setupGlobals(jest.fn(() => jsonResponse({ total: 3 })));
    opts = require('../js/shared/airplane-options');
    await expect(opts.fetchAll()).rejects.toThrow();
  });

  test('optionsHtml trie, échappe et exclut l\'appareil courant', () => {
    setupGlobals(jest.fn());
    opts = require('../js/shared/airplane-options');
    const html = opts.optionsHtml([{ id: 2, name: 'Zéro <b>' }, { id: 1, name: 'Alpha' }, { id: 3, name: 'Moi' }], 3);
    expect(html).toBe('<option value="">—</option><option value="1">Alpha</option><option value="2">Zéro &lt;b&gt;</option>');
  });

  test('selectValue ajoute une option manquante au lieu de retomber sur vide', () => {
    setupGlobals(jest.fn());
    opts = require('../js/shared/airplane-options');
    document.body.innerHTML = '<select id="s"><option value="">—</option><option value="1">A</option></select>';
    const s = document.getElementById('s');
    opts.selectValue(s, 292, 'MiG-35');
    expect(s.value).toBe('292');
    expect(s.selectedOptions[0].textContent).toBe('MiG-35');
    opts.selectValue(s, 1);
    expect(s.value).toBe('1');
    expect(s.options).toHaveLength(3);
    opts.selectValue(s, null);
    expect(s.value).toBe('');
    opts.selectValue(s, 7);
    expect(s.selectedOptions[0].textContent).toBe('#7');
  });
});

describe('hangar/admin — formulaire de création', () => {
  const REFERENTIALS = {
    countries: [{ id: 1, name: 'France' }],
    manufacturers: [{ id: 7, name: 'Dassault' }],
    generations: [1, 2, 3, 4, 5],
    types: [{ id: 3, name: 'Chasseur' }],
  };

  /** /api/referentials, puis /api/airplanes paginé comme le vrai backend. */
  function router(list, { referentials = () => jsonResponse(REFERENTIALS) } = {}) {
    const pages = apiFor(list);
    return jest.fn((url) => (url.startsWith('/api/referentials') ? referentials() : pages(url)));
  }

  let authFetch;
  function bootHangar(fetchImpl, { role = 1 } = {}) {
    jest.resetModules();
    window.VH = { hangar: { data: { loadAircraft: jest.fn() } } };
    setupGlobals(fetchImpl);
    authFetch = jest.fn(() => jsonResponse({ id: 999 }));
    global.auth.authFetch = authFetch;
    global.auth.getPayload = () => ({ role });
    global.trapFocus = () => ({ destroy() {} });
    document.body.innerHTML = `
      <button id="add-airplane-btn">Ajouter</button>
      <div id="aircraft-modal" class="modal"><div class="modal-backdrop"></div><button class="modal-close"></button>
        <form id="aircraft-form">
          <div class="form-sections" id="aircraft-form-fields"></div>
          <button id="cancel-btn" type="button">Annuler</button>
          <button id="submit-btn" type="submit"><i class="fas fa-save"></i>OK</button>
        </form>
      </div>`;
    require('../js/shared/airplane-options');
    require('../js/shared/airplane-fields');
    require('../js/shared/airplane-form');
    require('../js/hangar/admin');
    window.VH.hangar.admin.setupAdminModal({});
  }
  const settle = async () => { for (let i = 0; i < 10; i++) await new Promise((r) => setTimeout(r, 0)); };
  const open = async () => { document.getElementById('add-airplane-btn').click(); await settle(); };
  const submit = async () => {
    document.getElementById('aircraft-form').dispatchEvent(new Event('submit', { cancelable: true, bubbles: true }));
    await settle();
  };
  const submitBtn = () => document.getElementById('submit-btn');

  test('les 434 appareils sont proposés (pas seulement les 100 premiers)', async () => {
    bootHangar(router(catalogue(434)));
    await open();
    expect(document.querySelectorAll('#aircraft-successor-id option')).toHaveLength(435);
    expect(document.querySelector('#aircraft-rival-id option[value="434"]')).not.toBeNull();
    expect(submitBtn().disabled).toBe(false);
  });

  test('échec des appareils : toast, « Enregistrer » désactivé, aucun POST', async () => {
    bootHangar(jest.fn((url) => (url.startsWith('/api/referentials')
      ? jsonResponse(REFERENTIALS) : jsonResponse({}, false, 500))));
    await open();
    expect(global.showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    expect(submitBtn().disabled).toBe(true);
    await submit();
    expect(authFetch).not.toHaveBeenCalled();
  });

  test('échec des référentiels : même garde', async () => {
    bootHangar(router(catalogue(5), { referentials: () => jsonResponse({}, false, 500) }));
    await open();
    expect(global.showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    expect(submitBtn().disabled).toBe(true);
  });

  test('référentiels déjà chargés par le hangar : réutilisés sans requête', async () => {
    const api = router(catalogue(5));
    bootHangar(api);
    window.VH.hangar.admin.populateFormSelects({ ...REFERENTIALS, countries: [{ id: 9, name: 'Suède' }] });
    await open();
    expect(api.mock.calls.some(([u]) => u.startsWith('/api/referentials'))).toBe(false);
    expect(document.querySelector('#aircraft-country option[value="9"]').textContent).toBe('Suède');
  });

  test('référentiels incomplets transmis par le hangar : ignorés, la modale les recharge', async () => {
    const api = router(catalogue(5));
    bootHangar(api);
    window.VH.hangar.admin.populateFormSelects({ countries: [] });
    await open();
    expect(api.mock.calls.some(([u]) => u.startsWith('/api/referentials'))).toBe(true);
    expect(submitBtn().disabled).toBe(false);
  });

  test('création : POST du formulaire commun, liste des appareils invalidée', async () => {
    bootHangar(router(catalogue(5)));
    await open();
    document.getElementById('aircraft-name').value = 'Nouveau';
    document.getElementById('aircraft-country').value = '1';
    document.getElementById('aircraft-engine-type-en').value = 'Turbojet';
    document.getElementById('aircraft-successor-id').value = '3';
    await submit();
    expect(authFetch).toHaveBeenCalledTimes(1);
    const [url, init] = authFetch.mock.calls[0];
    expect(url).toBe('/api/airplanes');
    expect(init.method).toBe('POST');
    expect(JSON.parse(init.body)).toMatchObject({
      name: 'Nouveau', country_id: 1, engine_type_en: 'Turbojet', successor_id: 3, rival_id: null,
    });
    expect(global.showToast).toHaveBeenCalledWith('common.added', 'success');
    expect(window.VH.hangar.data.loadAircraft).toHaveBeenCalled();
    expect(submitBtn().disabled).toBe(false);
  });

  test('rôle utilisateur : refus sans requête', async () => {
    bootHangar(router(catalogue(5)), { role: 3 });
    await open();
    await submit();
    expect(authFetch).not.toHaveBeenCalled();
    expect(global.showToast).toHaveBeenCalledWith('common.unauthorized', 'error');
  });

  test('échec du POST : toast d\'erreur, bouton réactivé', async () => {
    bootHangar(router(catalogue(5)));
    authFetch.mockImplementation(() => jsonResponse({}, false, 400));
    await open();
    document.getElementById('aircraft-name').value = 'X';
    await submit();
    expect(global.showToast).toHaveBeenCalledWith('common.create_error', 'error');
    expect(submitBtn().disabled).toBe(false);
  });

  test('fermeture (Annuler, fond) puis réouverture', async () => {
    bootHangar(router(catalogue(5)));
    window.matchMedia = () => ({ matches: true });
    await open();
    const modal = document.getElementById('aircraft-modal');
    expect(modal.classList.contains('show')).toBe(true);
    document.getElementById('cancel-btn').click();
    expect(modal.classList.contains('show')).toBe(false);
    window.VH.hangar.admin.closeModal(); // déjà fermée : sans effet
    await open();
    modal.querySelector('.modal-backdrop').click();
    expect(modal.classList.contains('show')).toBe(false);
  });
});
