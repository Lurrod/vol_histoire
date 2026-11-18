/**
 * Tests — retrait d'un favori en deux temps, sur place
 * (VH.favorites.remove.armRemoveButton, frontend/js/favorites/remove.js).
 *
 * La poubelle ouvre un panneau « confirmer / garder » à côté d'elle ; seule la
 * confirmation lance le retrait (removeWithUndo, inchangé). Échap, la croix,
 * un second clic sur la poubelle, un clic ailleurs ou le focus qui part
 * referment sans rien retirer.
 */
global.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({
  '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
}[c]));
global.i18n = { t: (k) => k };
global.showToast = jest.fn();

require('../js/shared/motion');
require('../js/shared/confirm-action');
const remove = require('../js/favorites/remove');

let card, bin, onConfirm, api;
const wrap = () => card.querySelector('.cfm');
const confirmBtn = () => card.querySelector('.cfm-yes');
const cancelBtn = () => card.querySelector('.cfm-no');
const panel = () => card.querySelector('.cfm-panel');
const key = (el, k) => el.dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true }));

beforeEach(() => {
  document.body.innerHTML = `
    <article class="aircraft-card" id="c1">
      <button class="favorite-remove" data-airplane-id="7" aria-label="details.remove_favorite"></button>
    </article>
    <button id="ailleurs">ailleurs</button>`;
  card = document.getElementById('c1');
  bin = card.querySelector('.favorite-remove');
  onConfirm = jest.fn();
  api = remove.armRemoveButton(bin, onConfirm);
});

describe('structure', () => {
  test('la poubelle est enveloppée avec un panneau inerte, relié par aria-expanded / aria-controls', () => {
    expect(wrap().dataset.state).toBe('idle');
    expect(bin.parentElement).toBe(wrap());
    expect(bin.getAttribute('aria-expanded')).toBe('false');
    expect(bin.getAttribute('aria-controls')).toBe(panel().id);
    expect(panel().getAttribute('role')).toBe('group');
    expect(panel().hasAttribute('inert')).toBe(true);
    expect(confirmBtn().getAttribute('aria-label')).toBe('favorites.remove_confirm');
    expect(cancelBtn().getAttribute('aria-label')).toBe('favorites.remove_keep');
  });

  test('armer deux fois le même bouton ne double rien', () => {
    expect(remove.armRemoveButton(bin, onConfirm)).toBeNull();
    expect(card.querySelectorAll('.cfm')).toHaveLength(1);
  });
});

describe('confirmation', () => {
  test('clic sur la poubelle : panneau ouvert, focus sur « garder », rien de retiré', () => {
    bin.click();
    expect(wrap().dataset.state).toBe('confirm');
    expect(bin.getAttribute('aria-expanded')).toBe('true');
    expect(panel().hasAttribute('inert')).toBe(false);
    // Focus sur l'action la MOINS destructrice : un appui prolongé sur
    // Entrée (répétition de touche) ne doit pas confirmer la suppression.
    expect(document.activeElement).toBe(cancelBtn());
    expect(onConfirm).not.toHaveBeenCalled();
  });

  test('confirmer : coche dessinée (état done), puis retrait', () => {
    bin.click();
    confirmBtn().click();
    expect(wrap().dataset.state).toBe('done');
    // jsdom : aucune durée de transition, le retrait suit aussitôt
    expect(onConfirm).toHaveBeenCalledTimes(1);
    // le focus reste dans la carte (removeWithUndo le reporte sur la voisine)
    expect(document.activeElement).toBe(bin);
  });

  test('confirmer : le retrait attend la fin du tracé de la coche', () => {
    jest.useFakeTimers();
    const style = document.createElement('style');
    style.textContent = '.cfm[data-state="done"] .fav-bin-check { transition-duration: 300ms; }';
    document.head.appendChild(style);
    bin.innerHTML = '<svg><path class="fav-bin-check"></path></svg>';
    bin.click();
    confirmBtn().click();
    expect(onConfirm).not.toHaveBeenCalled();
    jest.advanceTimersByTime(360);
    expect(onConfirm).toHaveBeenCalledTimes(1);
    style.remove();
    jest.useRealTimers();
  });

  test('un clic pendant le tracé ne relance pas le retrait', () => {
    bin.click();
    confirmBtn().click();
    bin.click();
    expect(onConfirm).toHaveBeenCalledTimes(1);
    expect(wrap().dataset.state).toBe('done');
  });

  test('le clic ne remonte pas jusqu\'à la carte (lien étendu)', () => {
    const bubbled = jest.fn();
    card.addEventListener('click', bubbled);
    bin.click();
    confirmBtn().click();
    expect(bubbled).not.toHaveBeenCalled();
  });
});

describe('annulation', () => {
  beforeEach(() => bin.click());

  test('la croix referme, rend le focus à la poubelle', () => {
    cancelBtn().click();
    expect(wrap().dataset.state).toBe('idle');
    expect(panel().hasAttribute('inert')).toBe(true);
    expect(document.activeElement).toBe(bin);
    expect(onConfirm).not.toHaveBeenCalled();
  });

  test('un second clic sur la poubelle referme', () => {
    bin.click();
    expect(wrap().dataset.state).toBe('idle');
  });

  test('Échap referme sans remonter à la page', () => {
    const pageEsc = jest.fn();
    document.addEventListener('keydown', pageEsc);
    key(confirmBtn(), 'Escape');
    expect(wrap().dataset.state).toBe('idle');
    expect(document.activeElement).toBe(bin);
    expect(pageEsc).not.toHaveBeenCalled();
    document.removeEventListener('keydown', pageEsc);
  });

  test('clic ailleurs : referme', () => {
    document.getElementById('ailleurs').dispatchEvent(new window.MouseEvent('pointerdown', { bubbles: true }));
    expect(wrap().dataset.state).toBe('idle');
  });

  test('le focus part hors du contrôle (Tab) : referme', () => {
    confirmBtn().dispatchEvent(new window.FocusEvent('focusout', { bubbles: true, relatedTarget: document.getElementById('ailleurs') }));
    expect(wrap().dataset.state).toBe('idle');
  });

  test('ouvrir une autre poubelle referme la première', () => {
    const other = document.createElement('article');
    other.innerHTML = '<button class="favorite-remove" data-airplane-id="8"></button>';
    document.body.appendChild(other);
    const otherBin = other.querySelector('.favorite-remove');
    remove.armRemoveButton(otherBin, jest.fn());
    otherBin.click();
    expect(wrap().dataset.state).toBe('idle');
    expect(other.querySelector('.cfm').dataset.state).toBe('confirm');
  });
});

test('libellé de groupe fourni par une fonction : évalué à l’ouverture (donnée chargée plus tard)', () => {
  document.body.innerHTML = '<button id="del">Supprimer</button>';
  const data = { name: null };
  window.VH.confirmAction.arm(document.getElementById('del'), {
    onConfirm: jest.fn(),
    labels: { group: () => `Supprimer « ${data.name} » ?`, confirm: 'Oui', cancel: 'Non' },
  });
  data.name = 'Rafale';
  document.getElementById('del').click();
  expect(document.querySelector('.cfm-panel').getAttribute('aria-label')).toBe('Supprimer « Rafale » ?');
});

test('Entrée maintenue sur la poubelle : la répétition ne confirme rien', () => {
  bin.focus();
  bin.click(); // premier appui : ouverture, focus sur « garder »
  // Les répétitions de la touche atterrissent sur le bouton focalisé : « garder ».
  document.activeElement.click();
  expect(onConfirm).not.toHaveBeenCalled();
  expect(card.querySelector('.cfm').dataset.state).toBe('idle');
});

test('libellés des boutons fournis par des fonctions : évalués à l’ouverture (langue chargée plus tard)', () => {
  document.body.innerHTML = '<button id="del">Supprimer</button>';
  const dict = {};
  window.VH.confirmAction.arm(document.getElementById('del'), {
    onConfirm: jest.fn(),
    showText: true,
    labels: { group: 'g', confirm: () => dict.yes || 'clé.yes', cancel: () => dict.no || 'clé.no' },
  });
  dict.yes = 'Supprimer';
  dict.no = 'Garder';
  document.getElementById('del').click();
  const yesBtn = document.querySelector('.cfm-yes');
  expect(yesBtn.getAttribute('aria-label')).toBe('Supprimer');
  expect(yesBtn.querySelector('.cfm-text').textContent).toBe('Supprimer');
  expect(document.querySelector('.cfm-no').getAttribute('aria-label')).toBe('Garder');
});

test('bouton absent : rien ne lève', () => {
  expect(remove.armRemoveButton(null, onConfirm)).toBeNull();
  expect(api).not.toBeNull();
});

test('option when : faux → le clic passe au code de la page (pas de panneau), vrai → panneau', () => {
  document.body.innerHTML = '<button id="t">cœur</button>';
  const t = document.getElementById('t');
  let needed = false;
  const pageClick = jest.fn((e) => e.defaultPrevented);
  const ctl = window.VH.confirmAction.arm(t, { onConfirm: jest.fn(), when: () => needed, labels: {} });
  t.addEventListener('click', pageClick);
  t.click();
  expect(ctl.wrap.dataset.state).toBe('idle');
  expect(pageClick.mock.results[0].value).toBe(false); // clic non intercepté
  needed = true;
  t.click();
  expect(ctl.wrap.dataset.state).toBe('confirm');
  // Panneau ouvert : un clic sur le déclencheur referme, quel que soit when.
  needed = false;
  t.click();
  expect(ctl.wrap.dataset.state).toBe('idle');
});

describe('option morph : le déclencheur se transforme sur place', () => {
  function armMorph() {
    document.body.innerHTML = '<div id="row"><button id="t">Supprimer</button></div>';
    const t = document.getElementById('t');
    Object.defineProperty(t, 'offsetWidth', { configurable: true, get: () => 120 });
    const ctl = window.VH.confirmAction.arm(t, { onConfirm: jest.fn(), morph: true, labels: {} });
    Object.defineProperty(ctl.wrap.querySelector('.cfm-panel'), 'scrollWidth', { configurable: true, get: () => 210 });
    return { t, ctl };
  }

  test('enveloppe marquée cfm-morph ; sans l\'option, rien', () => {
    const { ctl } = armMorph();
    expect(ctl.wrap.classList.contains('cfm-morph')).toBe(true);
    document.body.innerHTML = '<button id="u">x</button>';
    const plain = window.VH.confirmAction.arm(document.getElementById('u'), { onConfirm: jest.fn(), labels: {} });
    expect(plain.wrap.classList.contains('cfm-morph')).toBe(false);
  });

  test('largeur : du bouton à la paire à l\'ouverture, retour au bouton, puis auto', async () => {
    const { t, ctl } = armMorph();
    t.click();
    await Promise.resolve();
    expect(ctl.wrap.style.width).toBe('210px');
    ctl.wrap.querySelector('.cfm-no').click();
    await Promise.resolve();
    expect(ctl.wrap.style.width).toBe('120px');
    const end = new window.Event('transitionend', { bubbles: true });
    Object.defineProperty(end, 'propertyName', { value: 'width' });
    ctl.wrap.dispatchEvent(end);
    expect(ctl.wrap.style.width).toBe('');
  });
});

test('morph : après la coche (done), retour au repos à même largeur → largeur rendue à auto', async () => {
  document.body.innerHTML = '<button id="t">Supprimer</button>';
  const t = document.getElementById('t');
  Object.defineProperty(t, 'offsetWidth', { configurable: true, get: () => 120 });
  const ctl = window.VH.confirmAction.arm(t, { onConfirm: jest.fn(), morph: true, labels: {} });
  Object.defineProperty(ctl.wrap, 'offsetWidth', { configurable: true, get: () => 120 });
  t.click();
  await Promise.resolve();
  ctl.wrap.querySelector('.cfm-yes').click(); // done
  await Promise.resolve();
  expect(ctl.wrap.style.width).toBe('120px');
  ctl.reset(); // idle, même largeur : pas de transition
  await Promise.resolve();
  expect(ctl.wrap.style.width).toBe('');
});
