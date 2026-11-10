/**
 * Tests DOM — modale d'édition de la fiche (details/admin.js).
 *
 * JS-001 : l'API plafonne `limit` à 100. La modale demandait `?limit=500` et
 * ne recevait donc que les 100 premiers appareils : un prédécesseur, un
 * successeur ou un rival d'identifiant plus élevé n'avait pas d'option, la
 * liste retombait sur « — » et l'enregistrement réécrivait la colonne à NULL,
 * sans rien signaler. Ces tests simulent l'API réelle (plafond à 100, champ
 * `total`) et vérifient ce que le PUT envoie.
 */

const fs = require('fs');
const path = require('path');

const API_CAP = 100;
const CATALOGUE_SIZE = 300;

// Catalogue simulé : ids 1..300, noms triables.
const CATALOGUE = Array.from({ length: CATALOGUE_SIZE }, (_, i) => ({
  id: i + 1,
  name: `Appareil ${String(i + 1).padStart(3, '0')}`,
}));

const REFERENTIALS = {
  countries: [{ id: 1, name: 'France' }, { id: 2, name: 'URSS' }],
  manufacturers: [{ id: 7, name: 'Mikoyan' }],
  generations: [1, 2, 3, 4, 5],
  types: [{ id: 3, name: 'Chasseur' }],
};

// Fiche éditée : MiG-29 (id 24), successeur 292 — absent des 100 premiers.
const AIRCRAFT_FR = {
  id: 24, name: 'MiG-29', description: 'Chasseur soviétique',
  country_id: 2, id_manufacturer: 7, id_generation: 4, type: 3,
  predecessor_id: 22, predecessor_name: 'Appareil 022',
  successor_id: 292, successor_name: 'MiG-35',
  rival_id: 11, rival_name: 'Appareil 011',
};

function jsonResponse(body, ok = true, status = 200) {
  return Promise.resolve({ ok, status, json: () => Promise.resolve(body) });
}

/** Simule /api/airplanes tel que le sert le backend (plafond, OFFSET, total). */
function airplanesPage(url) {
  const params = new window.URL(url, 'http://local').searchParams;
  const limit = Math.min(API_CAP, Math.max(1, parseInt(params.get('limit'), 10) || API_CAP));
  const page = Math.max(1, parseInt(params.get('page'), 10) || 1);
  const data = CATALOGUE.slice((page - 1) * limit, page * limit);
  return { data, total: CATALOGUE.length, page, limit };
}

function makeFetch(overrides = {}) {
  return jest.fn((url) => {
    for (const [prefix, handler] of Object.entries(overrides)) {
      if (url.startsWith(prefix)) return handler(url);
    }
    if (url.startsWith('/api/referentials')) return jsonResponse(REFERENTIALS);
    if (/^\/api\/airplanes\/\d+/.test(url)) return jsonResponse(AIRCRAFT_FR);
    if (url.startsWith('/api/airplanes')) return jsonResponse(airplanesPage(url));
    return jsonResponse({}, false, 404);
  });
}

function loadModalHtml() {
  // On lit la vraie modale de details.html (identifiants et bouton d'envoi),
  // par analyse DOM : la page évolue (inclusions d'en-tête et de pied).
  const html = fs.readFileSync(path.join(__dirname, '..', 'details.html'), 'utf8');
  const doc = new window.DOMParser().parseFromString(html, 'text/html');
  const modal = doc.getElementById('edit-modal');
  if (!modal) throw new Error('modale d\'édition introuvable dans details.html');
  return modal.outerHTML;
}

const flush = () => new Promise((r) => setTimeout(r, 0));
async function settle() {
  for (let i = 0; i < 10; i++) await flush();
}

let authFetch;

function boot({ fetchOverrides, lang = 'fr', aircraftData = AIRCRAFT_FR } = {}) {
  jest.resetModules();
  document.body.innerHTML =
    '<button type="button" id="edit-btn">Modifier</button>' +
    '<button type="button" id="delete-btn">Supprimer</button>' +
    loadModalHtml();

  global.i18n = { t: (k) => k, currentLang: lang };
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.showToast = jest.fn();
  global.trapFocus = () => ({ destroy() {} });
  global.requestAnimationFrame = (fn) => setTimeout(fn, 0);
  authFetch = jest.fn(() => jsonResponse({}));
  global.auth = {
    fetchWithTimeout: makeFetch(fetchOverrides),
    authFetch,
    getToken: () => 'jeton',
  };
  window.VH = { details: { data: { loadAircraftDetails: jest.fn(() => Promise.resolve()) } } };

  require('../js/shared/airplane-options');
  require('../js/shared/airplane-fields');
  require('../js/shared/airplane-form');
  const admin = require('../js/details/admin');
  const state = { aircraftId: aircraftData.id, aircraftData: { ...aircraftData }, userRole: 1 };
  admin.setup(state);
  return state;
}

async function openModal() {
  document.getElementById('edit-btn').click();
  await settle();
}

async function submitForm() {
  const form = document.getElementById('edit-form');
  form.dispatchEvent(new Event('submit', { cancelable: true, bubbles: true }));
  await settle();
}

function sentBody() {
  expect(authFetch).toHaveBeenCalledTimes(1);
  return JSON.parse(authFetch.mock.calls[0][1].body);
}

const submitButton = () => document.querySelector('#edit-form [type="submit"]');

describe('details/admin — filiations conservées à l\'enregistrement (JS-001)', () => {
  test('les listes proposent tout le catalogue, pas seulement les 100 premiers', async () => {
    boot();
    await openModal();
    const options = document.querySelectorAll('#edit-successor-id option');
    // « — » + 299 appareils (l'appareil édité est exclu)
    expect(options).toHaveLength(CATALOGUE_SIZE);
    expect(document.querySelector('#edit-successor-id option[value="24"]')).toBeNull();
  });

  test('un successeur d\'identifiant élevé (292) reste sélectionné', async () => {
    boot();
    await openModal();
    expect(document.getElementById('edit-successor-id').value).toBe('292');
    expect(document.getElementById('edit-predecessor-id').value).toBe('22');
    expect(document.getElementById('edit-rival-id').value).toBe('11');
  });

  test('enregistrer sans toucher aux listes renvoie les mêmes filiations', async () => {
    boot();
    await openModal();
    await submitForm();
    const body = sentBody();
    expect(body.successor_id).toBe(292);
    expect(body.predecessor_id).toBe(22);
    expect(body.rival_id).toBe(11);
    expect(body.country_id).toBe(2);
    expect(body.id_manufacturer).toBe(7);
    expect(body.type).toBe(3);
  });

  test('défense : une cible absente de la liste est ajoutée depuis le nom de la fiche', async () => {
    boot({ aircraftData: { ...AIRCRAFT_FR, rival_id: 999, rival_name: 'Fantôme' } });
    // La fiche relue en français porte elle aussi le rival 999.
    global.auth.fetchWithTimeout = makeFetch({
      '/api/airplanes/24': () => jsonResponse({ ...AIRCRAFT_FR, rival_id: 999, rival_name: 'Fantôme' }),
    });
    await openModal();
    const select = document.getElementById('edit-rival-id');
    expect(select.value).toBe('999');
    expect(select.selectedOptions[0].textContent).toBe('Fantôme');
    await submitForm();
    expect(sentBody().rival_id).toBe(999);
  });

  test('échec des référentiels : « Enregistrer » désactivé, toast d\'erreur, aucun PUT', async () => {
    boot({ fetchOverrides: { '/api/referentials': () => jsonResponse({}, false, 500) } });
    await openModal();
    expect(submitButton().disabled).toBe(true);
    expect(global.showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    await submitForm();
    expect(authFetch).not.toHaveBeenCalled();
  });

  test('échec du chargement des appareils : même garde', async () => {
    boot({ fetchOverrides: { '/api/airplanes?': () => jsonResponse({}, false, 429) } });
    await openModal();
    expect(submitButton().disabled).toBe(true);
    expect(global.showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    await submitForm();
    expect(authFetch).not.toHaveBeenCalled();
  });

  test('après un échec, une réouverture qui réussit réactive « Enregistrer »', async () => {
    let fail = true;
    boot({
      fetchOverrides: {
        '/api/referentials': () => (fail ? jsonResponse({}, false, 500) : jsonResponse(REFERENTIALS)),
      },
    });
    await openModal();
    expect(submitButton().disabled).toBe(true);
    window.VH.details.admin.closeEditModal();
    await new Promise((r) => setTimeout(r, 350));
    fail = false;
    await openModal();
    expect(submitButton().disabled).toBe(false);
    await submitForm();
    expect(sentBody().successor_id).toBe(292);
  });

  test('interface en anglais : le formulaire est rempli avec la fiche française', async () => {
    // L'API renvoie les champs traduits quand ?lang=en : les recopier dans le
    // formulaire puis les renvoyer écraserait les colonnes françaises.
    const english = { ...AIRCRAFT_FR, name: 'MiG-29 (EN)', description: 'Soviet fighter' };
    boot({ lang: 'en', aircraftData: english });
    await openModal();
    const calls = global.auth.fetchWithTimeout.mock.calls.map((c) => c[0]);
    expect(calls).toContain('/api/airplanes/24?lang=fr');
    expect(document.getElementById('edit-description').value).toBe('Chasseur soviétique');
    await submitForm();
    const body = sentBody();
    expect(body.name).toBe('MiG-29');
    expect(body.description).toBe('Chasseur soviétique');
  });
});

describe('details/admin — formulaire commun (ARCH-007)', () => {
  // L'API en ?lang=en remplace engine_type / variants par leur version
  // anglaise ; en ?lang=fr elle retire les colonnes _en.
  const AIRCRAFT_EN = { ...AIRCRAFT_FR, engine_type: 'Turbofan', variants: 'MiG-29A (EN)' };
  const frRecord = { ...AIRCRAFT_FR, engine_type: 'Turboréacteur', variants: 'MiG-29A' };

  test('le formulaire est construit dans la modale, avec les champs anglais', async () => {
    boot();
    expect(document.getElementById('edit-name')).toBeNull();
    await openModal();
    expect(document.getElementById('edit-name')).not.toBeNull();
    expect(document.getElementById('edit-engine-type-en')).not.toBeNull();
    expect(document.getElementById('edit-variants-en')).not.toBeNull();
  });

  test('interface française : les colonnes _en viennent de la fiche anglaise et sont renvoyées', async () => {
    boot({
      aircraftData: frRecord,
      fetchOverrides: { '/api/airplanes/24?lang=en': () => jsonResponse(AIRCRAFT_EN) },
    });
    await openModal();
    expect(document.getElementById('edit-engine-type').value).toBe('Turboréacteur');
    expect(document.getElementById('edit-engine-type-en').value).toBe('Turbofan');
    await submitForm();
    const body = sentBody();
    expect(body.engine_type).toBe('Turboréacteur');
    expect(body.engine_type_en).toBe('Turbofan');
    expect(body.variants_en).toBe('MiG-29A (EN)');
  });

  test('le PUT porte toutes les colonnes de la table', async () => {
    const { AIRPLANE_COLUMNS } = require('../../backend/utils/airplane-fields.js');
    boot();
    await openModal();
    await submitForm();
    expect(Object.keys(sentBody()).sort()).toEqual([...AIRPLANE_COLUMNS].sort());
  });

  test('échec de la fiche anglaise : même garde, aucun PUT', async () => {
    boot({ fetchOverrides: { '/api/airplanes/24?lang=en': () => jsonResponse({}, false, 500) } });
    await openModal();
    expect(submitButton().disabled).toBe(true);
    expect(global.showToast).toHaveBeenCalledWith('common.loading_error', 'error');
    await submitForm();
    expect(authFetch).not.toHaveBeenCalled();
  });
});

describe('details/admin — ouverture, fermeture et focus de la modale', () => {
  const modal = () => document.getElementById('edit-modal');
  const editBtn = () => document.getElementById('edit-btn');

  test('ouverture : modale affichée, défilement bloqué, piège à focus avec Échap', async () => {
    boot();
    global.trapFocus = jest.fn(() => ({ destroy: jest.fn() }));
    await openModal();
    expect(modal().classList.contains('show')).toBe(true);
    expect(document.body.style.overflow).toBe('hidden');
    expect(global.trapFocus).toHaveBeenCalledWith(modal(), { onEscape: expect.any(Function) });
  });

  test('ouverture : le focus passe sur le premier champ du formulaire (WCAG 2.4.3)', async () => {
    boot();
    editBtn().focus();
    await openModal();
    const first = document.querySelector('#edit-form input:not([type="hidden"]), #edit-form select, #edit-form textarea');
    expect(first).not.toBeNull();
    expect(document.activeElement).toBe(first);
  });

  test('formulaire sans champ : repli du focus sur le bouton « Fermer »', async () => {
    boot();
    // Formulaire monté vide : aucun champ focalisable.
    window.VH.shared.airplaneForm.mount = () => ({
      setReferentials() {}, setAirplanes() {}, fill() {}, read: () => ({}),
    });
    await openModal();
    expect(document.activeElement).toBe(document.querySelector('.modal-close'));
  });

  test('fiche pas encore chargée : le bouton « Modifier » n\'ouvre rien', async () => {
    const state = boot();
    state.aircraftData = null;
    await openModal();
    expect(modal().classList.contains('show')).toBe(false);
    expect(global.auth.fetchWithTimeout).not.toHaveBeenCalled();
  });

  test('fermeture : animation de sortie, piège détruit, focus rendu au bouton d\'origine', async () => {
    boot();
    const destroy = jest.fn();
    global.trapFocus = () => ({ destroy });
    editBtn().focus();
    await openModal();
    window.VH.details.admin.closeEditModal();
    expect(destroy).toHaveBeenCalled();
    expect(modal().classList.contains('is-closing')).toBe(true);
    expect(document.activeElement).toBe(editBtn());
    modal().dispatchEvent(new Event('animationend'));
    expect(modal().classList.contains('show')).toBe(false);
    expect(modal().classList.contains('is-closing')).toBe(false);
    expect(document.body.style.overflow).toBe('');
  });

  test('fermeture sans animationend : repli par minuterie (320 ms)', async () => {
    boot();
    await openModal();
    window.VH.details.admin.closeEditModal();
    expect(modal().classList.contains('show')).toBe(true);
    await new Promise((r) => setTimeout(r, 330));
    expect(modal().classList.contains('show')).toBe(false);
  });

  test('fermer une modale déjà fermée ou en cours de fermeture : sans effet', async () => {
    boot();
    const destroy = jest.fn();
    global.trapFocus = () => ({ destroy });
    window.VH.details.admin.closeEditModal();
    expect(modal().classList.contains('is-closing')).toBe(false);
    await openModal();
    window.VH.details.admin.closeEditModal();
    window.VH.details.admin.closeEditModal();
    expect(destroy).toHaveBeenCalledTimes(1);
  });

  test('« Annuler », croix et clic sur le fond ferment ; un clic dans le formulaire non', async () => {
    boot();
    for (const close of [
      () => document.getElementById('cancel-edit-btn').click(),
      () => document.querySelector('.modal-close').click(),
      () => document.querySelector('.modal-backdrop').click(),
      () => modal().dispatchEvent(new window.MouseEvent('click', { bubbles: true })),
    ]) {
      await openModal();
      modal().dispatchEvent(new Event('animationend'));
      expect(modal().classList.contains('show')).toBe(true);
      document.getElementById('edit-form').click();
      expect(modal().classList.contains('is-closing')).toBe(false);
      close();
      expect(modal().classList.contains('is-closing')).toBe(true);
      modal().dispatchEvent(new Event('animationend'));
    }
  });

  test('réouverture rapide : un chargement plus ancien ne remplit pas le formulaire', async () => {
    let releaseFirst;
    let calls = 0;
    boot({
      fetchOverrides: {
        '/api/referentials': () => {
          calls += 1;
          if (calls === 1) return new Promise((r) => { releaseFirst = () => r({ ok: false, status: 500, json: () => Promise.resolve({}) }); });
          return jsonResponse(REFERENTIALS);
        },
      },
    });
    await openModal();
    window.VH.details.admin.closeEditModal();
    modal().dispatchEvent(new Event('animationend'));
    await openModal();
    expect(submitButton().disabled).toBe(false);
    // Le premier chargement échoue APRÈS la réouverture : il est ignoré.
    releaseFirst();
    await settle();
    expect(submitButton().disabled).toBe(false);
    expect(global.showToast).not.toHaveBeenCalledWith('common.loading_error', 'error');
  });
});

describe('details/admin — enregistrement', () => {
  test('succès : PUT JSON, toast, modale fermée, fiche rechargée', async () => {
    const state = boot();
    await openModal();
    await submitForm();
    const [url, opts] = authFetch.mock.calls[0];
    expect(url).toBe('/api/airplanes/24');
    expect(opts.method).toBe('PUT');
    expect(opts.headers).toEqual({ 'Content-Type': 'application/json' });
    expect(global.showToast).toHaveBeenCalledWith('common.saved', 'success');
    expect(document.getElementById('edit-modal').classList.contains('is-closing')).toBe(true);
    expect(window.VH.details.data.loadAircraftDetails).toHaveBeenCalledWith(state);
    expect(submitButton().hasAttribute('aria-busy')).toBe(false);
  });

  test('refus du serveur : toast d\'erreur, modale ouverte, bouton réactivé', async () => {
    boot();
    await openModal();
    authFetch.mockImplementation(() => jsonResponse({ error: 'x' }, false, 400));
    await submitForm();
    expect(global.showToast).toHaveBeenCalledWith('common.update_error', 'error');
    expect(document.getElementById('edit-modal').classList.contains('is-closing')).toBe(false);
    expect(submitButton().disabled).toBe(false);
    expect(window.VH.details.data.loadAircraftDetails).not.toHaveBeenCalled();
  });

  test('erreur sans message : repli sur le texte traduit', async () => {
    boot();
    await openModal();
    authFetch.mockImplementation(() => Promise.reject(new Error('')));
    await submitForm();
    expect(global.showToast).toHaveBeenCalledWith('common.update_error', 'error');
  });

  test('pendant l\'envoi : aria-busy + disabled, un second envoi est ignoré', async () => {
    boot();
    await openModal();
    let release;
    authFetch.mockImplementation(() => new Promise((r) => { release = r; }));
    const form = document.getElementById('edit-form');
    form.dispatchEvent(new Event('submit', { cancelable: true }));
    expect(submitButton().getAttribute('aria-busy')).toBe('true');
    expect(submitButton().disabled).toBe(true);
    form.dispatchEvent(new Event('submit', { cancelable: true }));
    expect(authFetch).toHaveBeenCalledTimes(1);
    release({ ok: true, json: () => Promise.resolve({}) });
    await settle();
    expect(submitButton().hasAttribute('aria-busy')).toBe(false);
  });

  test.each([
    ['utilisateur simple (rôle 3)', { userRole: 3 }, 'jeton'],
    ['session expirée (pas de jeton)', { userRole: 1 }, null],
  ])('%s : refus côté client, aucun PUT', async (_, patch, token) => {
    const state = boot();
    Object.assign(state, patch);
    global.auth.getToken = () => token;
    await openModal();
    await submitForm();
    expect(global.showToast).toHaveBeenCalledWith('common.unauthorized', 'error');
    expect(authFetch).not.toHaveBeenCalled();
  });

  test('éditeur (rôle 2) : autorisé', async () => {
    const state = boot();
    state.userRole = 2;
    await openModal();
    await submitForm();
    expect(authFetch).toHaveBeenCalledTimes(1);
  });

  test('envoi avant toute ouverture (formulaire jamais construit) : ignoré', async () => {
    boot();
    await submitForm();
    expect(authFetch).not.toHaveBeenCalled();
  });
});

describe('details/admin — suppression', () => {
  let consoleSpy;
  beforeEach(() => { consoleSpy = jest.spyOn(console, 'error').mockImplementation(() => {}); });
  afterEach(() => consoleSpy.mockRestore());

  const deleteBtn = () => document.getElementById('delete-btn');

  test('confirmation refusée : aucune requête', async () => {
    boot();
    global.confirm = jest.fn(() => false);
    deleteBtn().click();
    await settle();
    expect(global.confirm).toHaveBeenCalledWith('common.confirm_delete "MiG-29" ?');
    expect(authFetch).not.toHaveBeenCalled();
  });

  test('confirmée : DELETE, bouton bloqué, toast, redirection vers le hangar après 1,5 s', async () => {
    boot();
    global.confirm = jest.fn(() => true);
    deleteBtn().click();
    expect(deleteBtn().disabled).toBe(true);
    expect(deleteBtn().getAttribute('aria-busy')).toBe('true');
    await settle();
    expect(authFetch).toHaveBeenCalledWith('/api/airplanes/24', { method: 'DELETE' });
    expect(global.showToast).toHaveBeenCalledWith('common.deleted', 'success');
    const navigated = () => consoleSpy.mock.calls.some((c) => /navigation/.test(String(c[0] && c[0].message)));
    expect(navigated()).toBe(false);
    await new Promise((r) => setTimeout(r, 1510));
    expect(navigated()).toBe(true);
  });

  test('échec : toast d\'erreur, bouton réactivé, pas de redirection', async () => {
    boot();
    global.confirm = jest.fn(() => true);
    authFetch.mockImplementation(() => jsonResponse({}, false, 403));
    deleteBtn().click();
    await settle();
    expect(global.showToast).toHaveBeenCalledWith('common.delete_error', 'error');
    expect(deleteBtn().disabled).toBe(false);
    expect(deleteBtn().hasAttribute('aria-busy')).toBe(false);
  });

  test('échec sans message : repli sur le texte traduit', async () => {
    boot();
    global.confirm = jest.fn(() => true);
    authFetch.mockImplementation(() => Promise.reject(new Error('')));
    deleteBtn().click();
    await settle();
    expect(global.showToast).toHaveBeenCalledWith('common.delete_error', 'error');
  });
});

describe('details/admin — page sans contrôles d\'administration', () => {
  test('setup sans modale ni boutons : ne lève pas', () => {
    jest.resetModules();
    document.body.innerHTML = '';
    window.VH = { details: {} };
    const admin = require('../js/details/admin');
    expect(() => admin.setup({ aircraftId: 1 })).not.toThrow();
  });

  test('closeEditModal par défaut (avant setup) : no-op', () => {
    jest.resetModules();
    window.VH = { details: {} };
    const admin = require('../js/details/admin');
    expect(() => admin.closeEditModal()).not.toThrow();
  });
});
