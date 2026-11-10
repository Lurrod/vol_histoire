/**
 * Tests DOM — shared/airplane-form.js (ARCH-007) : formulaire d'appareil
 * unique, dérivé de la table backend/utils/airplane-fields.js.
 */

const BACKEND_FIELDS = require('../../backend/utils/airplane-fields.js');

function jsonResponse(body, ok = true, status = 200) {
  return Promise.resolve({ ok, status, json: () => Promise.resolve(body) });
}

const REFERENTIALS = {
  countries: [{ id: 1, name: 'France' }, { id: 2, name: 'URSS' }],
  manufacturers: [{ id: 7, name: 'Mikoyan', country_name: 'URSS' }, { id: 8, name: 'Dassault' }],
  generations: [1, 2, 3, 4, 5],
  types: [{ id: 3, name: 'Chasseur' }],
};

let AF;

function boot(fetchImpl = jest.fn()) {
  jest.resetModules();
  window.VH = {};
  global.i18n = {
    currentLang: 'fr',
    t: (k, p) => (k === 'details.admin_generation_option' ? `${p.n}e génération` : k),
  };
  global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  global.auth = { fetchWithTimeout: fetchImpl };
  require('../js/shared/airplane-options');
  require('../js/shared/airplane-fields');
  AF = require('../js/shared/airplane-form');
}

function mountForm(prefix = 'edit') {
  document.body.innerHTML = '<form id="f"><div id="fields"></div></form>';
  return AF.mount(document.getElementById('fields'), { prefix });
}

describe('shared/airplane-fields.js — copie générée de la table backend', () => {
  test('identique à backend/utils/airplane-fields.js (sinon : node scripts/build-js.js)', () => {
    jest.resetModules();
    window.VH = {};
    const generated = require('../js/shared/airplane-fields');
    expect(JSON.parse(JSON.stringify(generated)))
      .toEqual(JSON.parse(JSON.stringify(BACKEND_FIELDS.AIRPLANE_FIELDS)));
  });
});

describe('shared/airplane-form — présentation', () => {
  beforeEach(() => boot());

  test('chaque colonne de la table est placée une fois, et rien d\'autre', () => {
    const placed = AF.SECTIONS.flatMap((s) => s.fields.map(([column]) => column));
    expect(new Set(placed).size).toBe(placed.length);
    expect([...placed].sort()).toEqual([...BACKEND_FIELDS.AIRPLANE_COLUMNS].sort());
  });

  test('engine_type_en et variants_en sont éditables', () => {
    mountForm();
    expect(document.getElementById('edit-engine-type-en').tagName).toBe('INPUT');
    expect(document.getElementById('edit-variants-en').tagName).toBe('TEXTAREA');
  });

  test('identifiants uniques, chaque contrôle a son <label for>', () => {
    mountForm('aircraft');
    const controls = [...document.querySelectorAll('#fields input, #fields select, #fields textarea')];
    expect(controls).toHaveLength(BACKEND_FIELDS.AIRPLANE_FIELDS.length);
    const ids = controls.map((c) => c.id);
    expect(new Set(ids).size).toBe(ids.length);
    controls.forEach((c) => {
      expect(document.querySelector(`label[for="${c.id}"]`)).not.toBeNull();
    });
  });

  test('identifiants historiques conservés (spec E2E admin-crud)', () => {
    mountForm('aircraft');
    ['aircraft-name', 'aircraft-little-description', 'aircraft-image-url', 'aircraft-country',
      'aircraft-manufacturer', 'aircraft-generation', 'aircraft-type', 'aircraft-date-operational',
      'aircraft-predecessor-id', 'aircraft-successor-id', 'aircraft-rival-id']
      .forEach((id) => expect(document.getElementById(id)).not.toBeNull());
  });

  test('type de contrôle selon `kind`', () => {
    mountForm();
    const el = (id) => document.getElementById(id);
    expect(el('edit-description').tagName).toBe('TEXTAREA');
    expect(el('edit-image-url').type).toBe('url');
    expect(el('edit-date-concept').type).toBe('date');
    expect(el('edit-crew').type).toBe('number');
    expect(el('edit-crew').getAttribute('step')).toBe('1');
    expect(el('edit-max-speed').getAttribute('step')).toBe('any');
    expect(el('edit-stealth-level').tagName).toBe('SELECT');
    expect([...el('edit-stealth-level').options].map((o) => o.value))
      .toEqual(['', ...BACKEND_FIELDS.STEALTH_LEVELS]);
    expect(el('edit-country').tagName).toBe('SELECT');
    expect(el('edit-name').type).toBe('text');
    expect(el('edit-image-licence').getAttribute('maxlength')).toBe('100');
  });

  test('obligatoires : name (serveur) et les quatre clés de classement', () => {
    mountForm();
    const required = [...document.querySelectorAll('#fields [required]')].map((c) => c.id).sort();
    expect(required).toEqual(['edit-country', 'edit-generation', 'edit-manufacturer', 'edit-name', 'edit-type']);
  });

  test('libellés et titres traduisibles (data-i18n)', () => {
    mountForm();
    expect(document.querySelector('label[for="edit-name"] [data-i18n="details.name"]')).not.toBeNull();
    expect(document.querySelectorAll('.form-section h3 [data-i18n]')).toHaveLength(AF.SECTIONS.length);
  });

  test('sans table de champs chargée : erreur explicite', () => {
    delete window.VH.shared.AIRPLANE_FIELDS;
    expect(() => AF.formHtml('edit')).toThrow('AIRPLANE_FIELDS');
  });

  test('mount sans conteneur : erreur explicite', () => {
    expect(() => AF.mount(null, { prefix: 'edit' })).toThrow();
  });
});

describe('shared/airplane-form — listes', () => {
  beforeEach(() => boot());

  test('setReferentials remplit pays, constructeurs, générations, types', () => {
    const form = mountForm();
    form.setReferentials(REFERENTIALS);
    const values = (id) => [...document.getElementById(id).options].map((o) => o.value);
    expect(values('edit-country')).toEqual(['', '1', '2']);
    expect(values('edit-generation')).toEqual(['', '1', '2', '3', '4', '5']);
    expect(document.querySelector('#edit-generation option[value="4"]').textContent).toBe('4e génération');
    expect(document.querySelector('#edit-manufacturer option[value="7"]').textContent).toBe('Mikoyan (URSS)');
    expect(document.querySelector('#edit-manufacturer option[value="8"]').textContent).toBe('Dassault');
  });

  test('setReferentials garde un choix fait pendant le chargement', () => {
    const form = mountForm();
    form.fill({ type: 42, type_name: 'Ravitailleur' });
    form.setReferentials(REFERENTIALS);
    const select = document.getElementById('edit-type');
    expect(select.value).toBe('42');
    expect(select.selectedOptions[0].textContent).toBe('Ravitailleur');
  });

  test('setReferentials refuse des référentiels incomplets', () => {
    const form = mountForm();
    expect(() => form.setReferentials({ countries: [] })).toThrow('Référentiels incomplets');
  });

  test('setAirplanes : trois listes de filiation, appareil courant exclu', () => {
    const form = mountForm();
    form.setAirplanes([{ id: 1, name: 'B' }, { id: 2, name: 'A' }, { id: 24, name: 'Moi' }], 24);
    ['edit-predecessor-id', 'edit-successor-id', 'edit-rival-id'].forEach((id) => {
      expect([...document.getElementById(id).options].map((o) => o.value)).toEqual(['', '2', '1']);
    });
  });
});

describe('shared/airplane-form — remplissage et lecture', () => {
  beforeEach(() => boot());

  const RECORD = {
    id: 24, name: 'MiG-29', description: 'Chasseur', country_id: 2, id_manufacturer: 7,
    id_generation: 4, type: 3, date_first_fly: '1977-10-06T00:00:00.000Z', crew: 1,
    max_speed: 2450.5, stealth_level: 'reduite', engine_type: 'Turbofan',
    variants: 'MiG-29A, MiG-29S', successor_id: 292, successor_name: 'MiG-35',
  };

  test('aller-retour : la lecture rend ce que la fiche contenait', () => {
    const form = mountForm();
    form.setReferentials(REFERENTIALS);
    form.setAirplanes([{ id: 22, name: 'MiG-23' }], 24);
    form.fill(RECORD, { engine_type: 'Turbofan (EN)', variants: 'MiG-29A (EN)' });
    const body = form.read();
    expect(Object.keys(body).sort()).toEqual([...BACKEND_FIELDS.AIRPLANE_COLUMNS].sort());
    expect(body).toMatchObject({
      name: 'MiG-29', description: 'Chasseur', country_id: 2, id_manufacturer: 7, id_generation: 4,
      type: 3, date_first_fly: '1977-10-06', crew: 1, max_speed: 2450.5, stealth_level: 'reduite',
      engine_type: 'Turbofan', engine_type_en: 'Turbofan (EN)',
      variants: 'MiG-29A, MiG-29S', variants_en: 'MiG-29A (EN)',
      successor_id: 292, predecessor_id: null, nickname: null, date_concept: null,
    });
    // Successeur absent de la liste : ajouté à la volée avec son nom.
    expect(document.getElementById('edit-successor-id').selectedOptions[0].textContent).toBe('MiG-35');
  });

  test('colonne _en : « Translation needed » de l\'API vaut champ vide', () => {
    const form = mountForm();
    form.fill(RECORD, { engine_type: AF.TRANSLATION_NEEDED, variants: null });
    expect(document.getElementById('edit-engine-type-en').value).toBe('');
    const body = form.read();
    expect(body.engine_type_en).toBeNull();
    expect(body.variants_en).toBeNull();
  });

  test('colonne _en présente dans la fiche brute : prioritaire sur la fiche anglaise', () => {
    const form = mountForm();
    form.fill({ ...RECORD, engine_type_en: 'Brut' }, { engine_type: 'Autre' });
    expect(form.read().engine_type_en).toBe('Brut');
  });

  test('conversions : vide → null, nom obligatoire → \'\', nombres', () => {
    const form = mountForm();
    const set = (id, v) => { document.getElementById(id).value = v; };
    set('edit-crew', '2');
    set('edit-g-limit-neg', '-3.5');
    set('edit-status', 'En service');
    const body = form.read();
    expect(body.name).toBe('');
    expect(body.crew).toBe(2);
    expect(body.g_limit_neg).toBe(-3.5);
    expect(body.status).toBe('En service');
    expect(body.complete_name).toBeNull();
    expect(body.country_id).toBeNull();
  });

  test('un champ absent du DOM n\'est pas envoyé (le PUT le laisse inchangé)', () => {
    const form = mountForm();
    document.getElementById('edit-nickname').closest('.form-group').remove();
    expect(Object.hasOwn(form.read(), 'nickname')).toBe(false);
  });
});

describe('shared/airplane-form — loadReferentials', () => {
  test('renvoie les référentiels valides', async () => {
    boot(jest.fn(() => jsonResponse(REFERENTIALS)));
    await expect(AF.loadReferentials()).resolves.toEqual(REFERENTIALS);
    expect(global.auth.fetchWithTimeout).toHaveBeenCalledWith('/api/referentials');
  });

  test('HTTP en erreur : rejet', async () => {
    boot(jest.fn(() => jsonResponse({}, false, 503)));
    await expect(AF.loadReferentials()).rejects.toThrow('HTTP 503');
  });

  test('réponse incomplète : rejet', async () => {
    boot(jest.fn(() => jsonResponse({ countries: [] })));
    await expect(AF.loadReferentials()).rejects.toThrow('Référentiels incomplets');
  });
});
