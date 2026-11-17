/**
 * Tests unitaires — frontend/js/shared/motion.js
 *
 * VH.motion est l'unique orchestrateur des sorties animées : il pose la
 * classe de sortie, attend la durée réelle lue dans le CSS (plus aucune
 * durée recopiée en JS), puis exécute la suite.
 */
require('../js/shared/motion');

const { parseTime, exitDuration, exit, replay, swapText, prefersReducedMotion } = window.VH.motion;

function setReducedMotion(reduce) {
  window.matchMedia = jest.fn().mockImplementation((q) => ({
    matches: reduce && q.includes('reduce'),
    media: q,
    addEventListener() {},
    removeEventListener() {},
  }));
}

describe('parseTime', () => {
  test('lit les millisecondes et les secondes', () => {
    expect(parseTime('160ms')).toBe(160);
    expect(parseTime('0.24s')).toBe(240);
    expect(parseTime(' 1s ')).toBe(1000);
  });

  test('0 pour une valeur vide ou illisible', () => {
    expect(parseTime('')).toBe(0);
    expect(parseTime(null)).toBe(0);
    expect(parseTime('auto')).toBe(0);
  });
});

describe('exitDuration', () => {
  test('retient la plus longue durée + délai, animations et transitions confondues', () => {
    const el = document.createElement('div');
    el.style.transitionDuration = '160ms, 240ms';
    el.style.transitionDelay = '0s, 20ms';
    el.style.animationDuration = '200ms';
    el.style.animationDelay = '0s';
    document.body.appendChild(el);
    expect(exitDuration(el)).toBe(260);
    el.remove();
  });

  test('0 sans animation ni transition', () => {
    const el = document.createElement('div');
    document.body.appendChild(el);
    expect(exitDuration(el)).toBe(0);
    el.remove();
  });
});

describe('exit', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    setReducedMotion(false);
  });
  afterEach(() => jest.useRealTimers());

  test('pose la classe, attend la durée CSS, la retire puis rappelle', () => {
    const el = document.createElement('div');
    el.style.transitionDuration = '160ms';
    document.body.appendChild(el);
    const done = jest.fn();

    exit(el, done);
    expect(el.classList.contains('is-closing')).toBe(true);
    jest.advanceTimersByTime(150);
    expect(done).not.toHaveBeenCalled();
    jest.advanceTimersByTime(60);
    expect(done).toHaveBeenCalledTimes(1);
    expect(el.classList.contains('is-closing')).toBe(false);
    el.remove();
  });

  test('accepte une autre classe de sortie', () => {
    const el = document.createElement('div');
    el.style.animationDuration = '200ms';
    document.body.appendChild(el);
    exit(el, () => {}, { className: 'is-hiding' });
    expect(el.classList.contains('is-hiding')).toBe(true);
    el.remove();
  });

  test('mesure la durée sur un enfant quand c\'est lui qui s\'anime', () => {
    const el = document.createElement('div');
    const content = document.createElement('div');
    content.style.animationDuration = '300ms';
    el.appendChild(content);
    document.body.appendChild(el);
    const done = jest.fn();
    exit(el, done, { measure: content });
    expect(el.classList.contains('is-closing')).toBe(true);
    jest.advanceTimersByTime(320);
    expect(done).not.toHaveBeenCalled();
    jest.advanceTimersByTime(40);
    expect(done).toHaveBeenCalledTimes(1);
    el.remove();
  });

  test('sans durée, rappelle aussitôt', () => {
    const el = document.createElement('div');
    const done = jest.fn();
    exit(el, done);
    expect(done).toHaveBeenCalledTimes(1);
    expect(el.classList.contains('is-closing')).toBe(false);
  });

  test('mouvements réduits : rappelle aussitôt, sans classe', () => {
    setReducedMotion(true);
    const el = document.createElement('div');
    el.style.transitionDuration = '300ms';
    const done = jest.fn();
    exit(el, done);
    expect(done).toHaveBeenCalledTimes(1);
    expect(el.classList.contains('is-closing')).toBe(false);
  });

  test('annuler (réouverture pendant la sortie) retire la classe sans rappeler', () => {
    const el = document.createElement('div');
    el.style.transitionDuration = '300ms';
    document.body.appendChild(el);
    const done = jest.fn();
    const cancel = exit(el, done);
    cancel();
    jest.advanceTimersByTime(1000);
    expect(done).not.toHaveBeenCalled();
    expect(el.classList.contains('is-closing')).toBe(false);
    el.remove();
  });

  test('élément absent : rappelle quand même', () => {
    const done = jest.fn();
    exit(null, done);
    expect(done).toHaveBeenCalledTimes(1);
  });
});

describe('replay', () => {
  test('retire puis repose la classe pour rejouer l\'animation', () => {
    const el = document.createElement('div');
    el.classList.add('is-popping');
    const spy = jest.spyOn(el, 'offsetWidth', 'get').mockReturnValue(10);
    replay(el, 'is-popping');
    expect(spy).toHaveBeenCalled();
    expect(el.classList.contains('is-popping')).toBe(true);
  });

  test('ignore un élément absent', () => {
    expect(() => replay(null, 'x')).not.toThrow();
  });
});

describe('swapText', () => {
  test('remplace le texte et rejoue .is-swapping quand il change', () => {
    const el = document.createElement('span');
    swapText(el, '12 avions');
    swapText(el, '3 avions');
    expect(el.textContent).toBe('3 avions');
    expect(el.classList.contains('is-swapping')).toBe(true);
  });

  test("texte identique : rien ne bouge (pas d'animation à chaque rendu)", () => {
    const el = document.createElement('span');
    swapText(el, '3 avions');
    swapText(el, '3 avions');
    expect(el.classList.contains('is-swapping')).toBe(false);
  });

  test("premier remplissage d'un élément vide : texte posé sans animation", () => {
    const el = document.createElement('span');
    swapText(el, '3 avions');
    expect(el.textContent).toBe('3 avions');
    expect(el.classList.contains('is-swapping')).toBe(false);
  });

  test('premier remplissage par-dessus un texte provisoire du HTML : sans animation', () => {
    const el = document.createElement('span');
    el.textContent = '0 avions trouvés';
    swapText(el, '109 avions trouvés');
    expect(el.textContent).toBe('109 avions trouvés');
    expect(el.classList.contains('is-swapping')).toBe(false);
  });

  test('ignore un élément absent', () => {
    expect(() => swapText(null, 'x')).not.toThrow();
  });
});

describe('prefersReducedMotion', () => {
  test('reflète la préférence système', () => {
    setReducedMotion(true);
    expect(prefersReducedMotion()).toBe(true);
    setReducedMotion(false);
    expect(prefersReducedMotion()).toBe(false);
  });

  test('false si matchMedia lève', () => {
    window.matchMedia = jest.fn(() => { throw new Error('bac à sable'); });
    expect(prefersReducedMotion()).toBe(false);
  });

  test('false sans matchMedia', () => {
    const saved = window.matchMedia;
    delete window.matchMedia;
    expect(prefersReducedMotion()).toBe(false);
    window.matchMedia = saved;
  });
});
