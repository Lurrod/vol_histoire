/**
 * Tests unitaires — frontend/js/shared/toc.js
 *
 * Sommaire collant : construit depuis les sections d'un conteneur [data-toc],
 * suit la lecture, gère le clic (adresse complète malgré <base href>) et se
 * reconstruit quand une section apparaît. jsdom ne fait aucune mise en page :
 * positions et visibilité sont simulées.
 */
require('../js/shared/motion');

const tops = new Map();   // section → top simulé (getBoundingClientRect)

function page(count, { hiddenLast = false } = {}) {
  const sections = Array.from({ length: count }, (_, i) =>
    `<section class="s${hiddenLast && i === count - 1 ? ' hidden' : ''}"><h2><i class="icon"></i> ${i + 1}. Titre ${i + 1}</h2><p>…</p></section>`).join('');
  document.body.innerHTML = `<div class="container"><div id="host" data-toc data-toc-sections=".s">${sections}</div></div>`;
  document.querySelectorAll('.s').forEach((s, i) => {
    tops.set(s, 1000 + i * 800);
    s.getBoundingClientRect = () => ({ top: tops.get(s) - window.scrollY, bottom: 0, height: 700 });
    // visible sauf .hidden
    s.getClientRects = () => (s.classList.contains('hidden') ? [] : [{}]);
  });
  document.getElementById('host').getBoundingClientRect = () => ({ top: 1000 - window.scrollY, height: count * 800 });
  // jsdom : document de hauteur nulle, toujours « en bas de page » sans ceci
  Object.defineProperty(document.documentElement, 'scrollHeight', { configurable: true, value: 20000 });
}

let toc;

beforeEach(() => {
  jest.resetModules();
  tops.clear();
  window.scrollY = 0;
  window.innerHeight = 900;
  // Synchrone ; renvoie 0 : l'identifiant d'image ne reste pas « en attente »
  window.requestAnimationFrame = (cb) => { cb(); return 0; };
  window.HTMLElement.prototype.scrollIntoView = jest.fn();
  delete window.i18n;
});

function load() {
  toc = require('../js/shared/toc');
  return document.querySelector('.toc');
}

describe('construction', () => {
  test('une entrée par section, libellés tirés des titres, ancres posées', () => {
    page(5);
    const nav = load();
    expect(nav).not.toBeNull();
    const links = [...nav.querySelectorAll('.toc-link')];
    expect(links.map((l) => l.textContent)).toEqual(['1. Titre 1', '2. Titre 2', '3. Titre 3', '4. Titre 4', '5. Titre 5']);
    const first = document.querySelector('.s');
    expect(first.id).toMatch(/^toc-1-titre-1-1$/);
    expect(first.hasAttribute('data-toc-target')).toBe(true);
    // adresse complète : la fiche déclare <base href="/">
    expect(links[0].getAttribute('href')).toBe(window.location.pathname + '#' + first.id);
    expect(nav.parentNode.classList.contains('has-toc')).toBe(true);
    expect(nav.nextElementSibling.id).toBe('host');
  });

  test('moins de quatre sections : pas de sommaire', () => {
    page(3);
    expect(load()).toBeNull();
  });

  test('titre traduit par i18n, repli « Sommaire » sinon', () => {
    page(4);
    window.i18n = { t: (k) => (k === 'toc.title' ? 'Contents' : k) };
    const nav = load();
    expect(nav.querySelector('.toc-title').textContent).toBe('Contents');
    expect(nav.querySelector('.toc-toggle-title').textContent).toBe('Contents');
  });
});

describe('suivi de lecture', () => {
  test('la section dont le titre a passé 30 % de l’écran est en cours', () => {
    page(5);
    const nav = load();
    const links = () => [...nav.querySelectorAll('.toc-link')];
    expect(links()[0].classList.contains('is-active')).toBe(true);
    expect(links()[0].getAttribute('aria-current')).toBe('location');
    window.scrollY = 1000 + 2 * 800 - 100; // titre 3 à 100 px du haut
    window.dispatchEvent(new Event('scroll'));
    expect(links()[2].classList.contains('is-active')).toBe(true);
    expect(links()[0].hasAttribute('aria-current')).toBe(false);
    expect(nav.querySelector('.toc-toggle-current').textContent).toBe('3. Titre 3');
  });
});

describe('clic sur une entrée', () => {
  test('défile jusqu’à la section, met l’adresse à jour, sans naviguer', () => {
    page(5);
    const nav = load();
    const link = nav.querySelectorAll('.toc-link')[3];
    const target = document.querySelectorAll('.s')[3];
    const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true, button: 0 });
    link.dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(true);
    expect(target.scrollIntoView).toHaveBeenCalled();
    expect(window.location.hash).toBe('#' + target.id);
    expect(link.classList.contains('is-active')).toBe(true);
    expect(document.activeElement).toBe(target);
  });

  test('pendant le défilement du clic, le suivi attend', () => {
    page(5);
    const nav = load();
    nav.querySelectorAll('.toc-link')[4].dispatchEvent(new window.MouseEvent('click', { bubbles: true, cancelable: true, button: 0 }));
    window.scrollY = 1000; // section 1 traversée
    window.dispatchEvent(new Event('scroll'));
    expect(nav.querySelectorAll('.toc-link')[4].classList.contains('is-active')).toBe(true);
  });

  test('Ctrl + clic : laissé au navigateur (nouvel onglet)', () => {
    page(5);
    const nav = load();
    const ev = new window.MouseEvent('click', { bubbles: true, cancelable: true, button: 0, ctrlKey: true });
    nav.querySelector('.toc-link').dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(false);
  });
});

describe('barre repliable (petits écrans)', () => {
  test('le bouton ouvre et ferme la liste ; Échap la ferme', () => {
    page(4);
    const nav = load();
    const btn = nav.querySelector('.toc-toggle');
    btn.click();
    expect(nav.classList.contains('is-open')).toBe(true);
    expect(btn.getAttribute('aria-expanded')).toBe('true');
    nav.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape', bubbles: true }));
    expect(nav.classList.contains('is-open')).toBe(false);
    expect(document.activeElement).toBe(btn);
  });

  test('un clic ailleurs dans la page referme la liste', () => {
    page(4);
    const nav = load();
    nav.querySelector('.toc-toggle').click();
    document.body.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
    expect(nav.classList.contains('is-open')).toBe(false);
  });
});

describe('sections qui apparaissent (fiche)', () => {
  test('une section révélée après coup rejoint le sommaire', async () => {
    page(5, { hiddenLast: true });
    const nav = load();
    expect(nav.querySelectorAll('.toc-link')).toHaveLength(4);
    document.querySelectorAll('.s')[4].classList.remove('hidden');
    await new Promise((r) => setTimeout(r, 0));
    expect(nav.querySelectorAll('.toc-link')).toHaveLength(5);
  });

  test('survol d’une entrée : second filet posé', () => {
    page(4);
    const nav = load();
    nav.querySelector('.toc-link').dispatchEvent(new Event('pointerover', { bubbles: true }));
    expect(nav.classList.contains('is-hovering')).toBe(true);
    nav.querySelector('.toc-track').dispatchEvent(new Event('pointerleave'));
    expect(nav.classList.contains('is-hovering')).toBe(false);
  });

  test('init() sur une page sans [data-toc] : rien', () => {
    document.body.innerHTML = '<main></main>';
    toc = require('../js/shared/toc');
    expect(toc.init(document)).toEqual([]);
  });
});

describe('crochet et cas limites', () => {
  function linkOffsets(nav) {
    nav.querySelectorAll('.toc-link').forEach((l, i) => {
      Object.defineProperty(l, 'offsetTop', { configurable: true, value: i * 30 });
      Object.defineProperty(l, 'offsetHeight', { configurable: true, value: 30 });
    });
  }

  test('changement de section : le crochet descend jusqu’à l’entrée en cours', () => {
    page(5);
    const nav = load();
    linkOffsets(nav);
    window.dispatchEvent(new Event('resize'));
    expect(nav.style.getPropertyValue('--toc-y')).toBe('15px');
    window.scrollY = 1000 + 3 * 800 - 100;
    window.dispatchEvent(new Event('scroll'));
    expect(nav.style.getPropertyValue('--toc-y')).toBe(3 * 30 + 15 + 'px');
    expect(nav.querySelector('.toc-dot')).toBeNull();
  });

  test('focus clavier sur une entrée : second filet, retiré à la sortie', () => {
    page(4);
    const nav = load();
    const link = nav.querySelector('.toc-link');
    link.focus();
    expect(nav.classList.contains('is-hovering')).toBe(true);
    link.blur();
    expect(nav.classList.contains('is-hovering')).toBe(false);
  });

  test('sections masquées sous le minimum : le sommaire disparaît', async () => {
    page(4);
    const nav = load();
    expect(document.querySelector('.toc')).toBe(nav);
    document.querySelectorAll('.s')[0].classList.add('hidden');
    await new Promise((r) => setTimeout(r, 0));
    expect(document.querySelector('.toc')).toBeNull();
    expect(document.querySelector('.container').classList.contains('has-toc')).toBe(false);
  });

  test('fin du défilement d’un clic : le suivi reprend', () => {
    page(5);
    const nav = load();
    nav.querySelectorAll('.toc-link')[4].dispatchEvent(new window.MouseEvent('click', { bubbles: true, cancelable: true, button: 0 }));
    window.scrollY = 1000 + 800 - 100;
    window.dispatchEvent(new Event('scrollend'));
    expect(nav.querySelectorAll('.toc-link')[1].classList.contains('is-active')).toBe(true);
  });
});
