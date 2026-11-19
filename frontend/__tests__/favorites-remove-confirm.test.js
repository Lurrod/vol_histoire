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

describe('binIcon : poubelle partagée', () => {
  test('couvercle, cuve et coche, décorative', () => {
    const svg = window.VH.confirmAction.binIcon();
    expect(svg.tagName.toLowerCase()).toBe('svg');
    expect(svg.classList.contains('cfm-bin')).toBe(true);
    expect(svg.getAttribute('aria-hidden')).toBe('true');
    ['.cfm-bin-lid', '.cfm-bin-can', '.cfm-bin-check'].forEach((sel) => {
      expect(svg.querySelector(sel)).not.toBeNull();
    });
  });

  test('un nœud neuf à chaque appel', () => {
    expect(window.VH.confirmAction.binIcon()).not.toBe(window.VH.confirmAction.binIcon());
  });

  test('côté du panneau reflété sur l’enveloppe (charnière du couvercle en CSS)', () => {
    document.body.innerHTML = '<button id="l">x</button><button id="r">y</button>';
    const left = window.VH.confirmAction.arm(document.getElementById('l'), { onConfirm: jest.fn(), side: 'left', labels: {} });
    const right = window.VH.confirmAction.arm(document.getElementById('r'), { onConfirm: jest.fn(), labels: {} });
    expect(left.wrap.dataset.side).toBe('left');
    expect(right.wrap.dataset.side).toBe('right');
  });
});

test('libellés rafraîchis à i18nReady et langChanged ; contrôle sorti du DOM oublié', () => {
  document.body.innerHTML = '<button id="a">x</button><button id="b">y</button>';
  let text = 'details.delete_confirm';
  const live = window.VH.confirmAction.arm(document.getElementById('a'), {
    onConfirm: jest.fn(), showText: true, labels: { confirm: () => text, cancel: 'Garder' },
  });
  const goneLabel = jest.fn(() => 'Effacer');
  const gone = window.VH.confirmAction.arm(document.getElementById('b'), {
    onConfirm: jest.fn(), labels: { confirm: goneLabel },
  });
  gone.wrap.remove();
  goneLabel.mockClear();
  const yes = live.wrap.querySelector('.cfm-yes');
  expect(yes.querySelector('.cfm-text').textContent).toBe('details.delete_confirm');
  text = 'Supprimer';
  window.dispatchEvent(new window.CustomEvent('i18nReady'));
  expect(yes.querySelector('.cfm-text').textContent).toBe('Supprimer');
  expect(yes.getAttribute('aria-label')).toBe('Supprimer');
  text = 'Delete';
  window.dispatchEvent(new window.CustomEvent('langChanged'));
  expect(yes.getAttribute('aria-label')).toBe('Delete');
  expect(goneLabel).not.toHaveBeenCalled();
});
