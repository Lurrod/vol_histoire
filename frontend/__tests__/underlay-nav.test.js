/**
 * Tests — frontend/js/shared/underlay-nav.js : menu « underlay » du bureau.
 * Activation (bureau + API Popover), ouverture (classes, mesures, recalage
 * des éléments fixes, inertie, focus), fermeture animée ou immédiate,
 * réouverture pendant la fermeture, et fermetures implicites.
 */
require('../js/shared/motion');

const STYLE_ID = 'test-underlay-css';

let mod;
let panel;
let trigger;
let closeBtn;
let header;

function load() {
  jest.isolateModules(() => { mod = require('../js/shared/underlay-nav'); });
  return mod;
}

function setDesktop(desktop) {
  window.matchMedia = jest.fn((q) => ({
    matches: q.includes('64em') ? desktop : false,
    addEventListener() {}, removeEventListener() {},
  }));
}

/** jsdom ne calcule aucune mise en page : on la fournit. */
function layout(el, { top = 0, height = 0 } = {}) {
  Object.defineProperty(el, 'offsetTop', { configurable: true, get: () => top });
  Object.defineProperty(el, 'offsetHeight', { configurable: true, get: () => height });
  el.getClientRects = () => [{ top, height }];
}

function setCloseDuration(ms) {
  let style = document.getElementById(STYLE_ID);
  if (!style) {
    style = document.createElement('style');
    style.id = STYLE_ID;
    document.head.appendChild(style);
  }
  style.textContent = ms ? `html.ul-closing{transition-duration:${ms}ms}` : '';
}

beforeEach(() => {
  jest.useFakeTimers();
  setDesktop(true);
  setCloseDuration(0);
  document.documentElement.className = '';
  document.documentElement.removeAttribute('style');
  document.body.innerHTML = `
    <a class="skip-link" href="#main-content">Aller au contenu</a>
    <header>
      <nav class="container">
        <a href="/" class="logo">Logo</a>
        <button type="button" class="hamburger" aria-expanded="false">Menu</button>
        <div class="nav-panel" id="nav-panel" popover="manual">
          <button type="button" class="nav-close" aria-expanded="false">Fermer</button>
          <ul class="nav-links" id="nav-links"><li><a href="/hangar">Hangar</a></li></ul>
        </div>
        <div class="nav-actions"><button id="lang-toggle">FR</button></div>
      </nav>
    </header>
    <main id="main-content">
      <div class="toast" id="toast">Toast</div>
      <div class="cadre" id="cadre"><div class="dedans" id="dedans">Dedans</div></div>
    </main>
    <footer>Pied</footer>`;
  header = document.querySelector('header');
  panel = document.querySelector('.nav-panel');
  trigger = document.querySelector('.hamburger');
  closeBtn = document.querySelector('.nav-close');
  panel.showPopover = jest.fn();
  panel.hidePopover = jest.fn();
  header.style.position = 'fixed';
  layout(header, { top: 0, height: 70 });
  window.scrollTo = jest.fn();
  Object.defineProperty(window, 'scrollY', { configurable: true, value: 400 });
  document.body.getBoundingClientRect = () => ({ top: -330, left: 0, width: 1440, height: 3000 });
  trigger.getBoundingClientRect = () => ({ top: 12, left: 1284, width: 92, height: 44 });
  panel.querySelector('.nav-links').getBoundingClientRect = () => ({ width: 384 });
  Object.defineProperty(document.body, 'offsetHeight', { configurable: true, get: () => 3000 });
  load().init({ panel, trigger, closeBtn });
});

afterEach(() => {
  jest.useRealTimers();
});

const html = () => document.documentElement;
const v = (name) => html().style.getPropertyValue(name);

describe('activation', () => {
  test('bureau et API Popover : actif', () => {
    expect(mod.enabled()).toBe(true);
  });

  test('sous 64em : inactif, open() ne fait rien', () => {
    setDesktop(false);
    expect(mod.enabled()).toBe(false);
    expect(mod.open()).toBe(false);
    expect(panel.showPopover).not.toHaveBeenCalled();
  });

  test('sans API Popover : inactif', () => {
    delete panel.showPopover;
    expect(mod.enabled()).toBe(false);
  });

  test('sans panneau ou sans déclencheur : inactif', () => {
    load().init({});
    expect(mod.enabled()).toBe(false);
    load().init({ panel });
    expect(mod.enabled()).toBe(false);
  });
});

describe('ouverture', () => {
  test('structure posée, état cible, popover affiché, boutons à jour', () => {
    expect(mod.open()).toBe(true);
    expect(html().classList.contains('ul-on')).toBe(true);
    expect(html().classList.contains('ul-open')).toBe(true);
    expect(panel.showPopover).toHaveBeenCalledTimes(1);
    expect(mod.isOpen()).toBe(true);
    expect(trigger.getAttribute('aria-expanded')).toBe('true');
    expect(closeBtn.getAttribute('aria-expanded')).toBe('true');
    expect(document.activeElement).toBe(closeBtn);
  });

  test('mesures en repère de body (marge haute fusionnée de 70 px)', () => {
    mod.open();
    // body commence à 400 - 330 = 70 px : défilement de 400 → 330 dans body.
    expect(v('--ul-y')).toBe('330px');
    expect(v('--ul-oy')).toBe(`${330 + html().clientHeight / 2}px`);
    expect(v('--ul-pw')).toBe('384px');
    expect(v('--ul-btn-top')).toBe('12px');
    expect(v('--ul-btn-left')).toBe('1284px');
  });

  test('les éléments fixes sont recalés à leur place à l’écran', () => {
    mod.open();
    expect(header.style.getPropertyValue('top')).toBe('330px');
    expect(header.style.getPropertyPriority('top')).toBe('important');
    expect(header.style.getPropertyValue('bottom')).toBe('auto');
    expect(header.style.getPropertyValue('height')).toBe('70px');
  });

  test('un fixe dont un ancêtre fournit le bloc conteneur n’est pas touché', () => {
    const cadre = document.getElementById('cadre');
    const dedans = document.getElementById('dedans');
    cadre.style.transform = 'translateX(0)';
    dedans.style.position = 'fixed';
    layout(dedans, { top: 50, height: 20 });
    mod.open();
    expect(dedans.style.getPropertyValue('top')).toBe('');
  });

  test('un fixe non rendu est ignoré', () => {
    const toast = document.getElementById('toast');
    toast.style.position = 'fixed';
    mod.open();
    expect(toast.style.getPropertyValue('top')).toBe('');
  });

  test('tout est inerte sauf le panneau', () => {
    mod.open();
    expect(document.querySelector('main').inert).toBe(true);
    expect(document.querySelector('footer').inert).toBe(true);
    expect(document.querySelector('.skip-link').inert).toBe(true);
    expect(document.querySelector('.logo').inert).toBe(true);
    expect(trigger.inert).toBe(true);
    expect(header.inert).toBeFalsy();
    expect(panel.inert).toBeFalsy();
  });

  test('gouttière gardée seulement si la page avait une barre de défilement', () => {
    Object.defineProperty(window, 'innerWidth', { configurable: true, value: html().clientWidth + 15 });
    mod.open();
    expect(html().classList.contains('ul-gutter')).toBe(true);
  });

  test('second appel sans effet', () => {
    mod.open();
    mod.open();
    expect(panel.showPopover).toHaveBeenCalledTimes(1);
  });
});

describe('fermeture', () => {
  test('sans durée CSS : tout est rendu à son état d’origine', () => {
    header.style.setProperty('top', '5px');
    mod.open();
    mod.close();
    expect(mod.isOpen()).toBe(false);
    expect(html().className).toBe('');
    expect(v('--ul-y')).toBe('');
    expect(header.style.getPropertyValue('top')).toBe('5px');
    expect(header.style.getPropertyValue('height')).toBe('');
    expect(document.querySelector('main').inert).toBe(false);
    expect(panel.hidePopover).toHaveBeenCalledTimes(1);
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
    expect(document.activeElement).toBe(trigger);
  });

  test('un inerte d’origine le reste', () => {
    document.querySelector('footer').inert = true;
    mod.open();
    mod.close();
    expect(document.querySelector('footer').inert).toBe(true);
  });

  test('animée : la structure reste jusqu’à la fin de la durée lue sur le CSS', () => {
    setCloseDuration(200);
    mod.open();
    mod.close();
    expect(html().classList.contains('ul-open')).toBe(false);
    expect(html().classList.contains('ul-on')).toBe(true);
    jest.advanceTimersByTime(300);
    expect(html().classList.contains('ul-on')).toBe(false);
    expect(panel.hidePopover).toHaveBeenCalled();
  });

  test('réouverture pendant la fermeture : rien n’est démonté', () => {
    setCloseDuration(200);
    mod.open();
    mod.close();
    mod.toggle();
    jest.advanceTimersByTime(300);
    expect(mod.isOpen()).toBe(true);
    expect(html().classList.contains('ul-on')).toBe(true);
    expect(html().classList.contains('ul-open')).toBe(true);
    expect(panel.showPopover).toHaveBeenCalledTimes(1);
    expect(panel.hidePopover).not.toHaveBeenCalled();
  });

  test('immédiate : pas d’attente même avec une durée CSS', () => {
    setCloseDuration(200);
    mod.open();
    mod.close({ immediate: true });
    expect(html().classList.contains('ul-on')).toBe(false);
  });

  test('fermée : close() sans effet', () => {
    mod.close();
    expect(panel.hidePopover).not.toHaveBeenCalled();
  });

  test('hidePopover qui lève (déjà masqué) : sans conséquence', () => {
    panel.hidePopover = jest.fn(() => { throw new Error('InvalidStateError'); });
    mod.open();
    expect(() => mod.close()).not.toThrow();
    expect(html().className).toBe('');
  });

  test('le focus n’est pas déplacé s’il a quitté le panneau', () => {
    mod.open();
    document.getElementById('lang-toggle').inert = false;
    closeBtn.blur();
    mod.close();
    expect(document.activeElement).not.toBe(trigger);
  });
});

describe('fermetures implicites', () => {
  test('bouton Fermer', () => {
    mod.open();
    closeBtn.click();
    expect(mod.isOpen()).toBe(false);
  });

  test('clic dans la zone vide du popover, pas sur un lien', () => {
    mod.open();
    panel.querySelector('.nav-links').dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
    expect(mod.isOpen()).toBe(true);
    panel.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
    expect(mod.isOpen()).toBe(false);
  });

  test('redimensionnement : fermeture immédiate', () => {
    window.dispatchEvent(new Event('resize')); // fermé : rien
    mod.open();
    window.dispatchEvent(new Event('resize'));
    jest.advanceTimersByTime(150);
    expect(html().classList.contains('ul-on')).toBe(false);
  });

  test('retour depuis le cache d’historique : fermé', () => {
    mod.open();
    const evt = new Event('pageshow');
    evt.persisted = false;
    window.dispatchEvent(evt);
    expect(mod.isOpen()).toBe(true);
    const restored = new Event('pageshow');
    restored.persisted = true;
    window.dispatchEvent(restored);
    expect(mod.isOpen()).toBe(false);
  });

  test('toggle ouvre puis ferme', () => {
    mod.toggle();
    expect(mod.isOpen()).toBe(true);
    mod.toggle();
    expect(mod.isOpen()).toBe(false);
  });
});
