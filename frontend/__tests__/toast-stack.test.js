/**
 * Tests unitaires — frontend/js/shared/toast-stack.js
 *
 * Paquet de notifications : le plus récent devant, les précédents derrière
 * (trois visibles), déplié au survol ou au focus. jsdom ne mesure rien :
 * les hauteurs sont simulées par scrollHeight / offsetHeight.
 */
let stack;
let container;

function addToast(text, height = 60) {
  const t = document.createElement('div');
  t.className = 'toast toast-info';
  t.textContent = text;
  Object.defineProperty(t, 'scrollHeight', { configurable: true, get: () => height });
  Object.defineProperty(t, 'offsetHeight', { configurable: true, get: () => height + 2 });
  Object.defineProperty(t, 'clientHeight', { configurable: true, get: () => height });
  container.appendChild(t);
  return t;
}

const prop = (el, name) => el.style.getPropertyValue(name);

beforeEach(() => {
  jest.resetModules();
  document.body.innerHTML = '<div id="toast-container"></div>';
  container = document.getElementById('toast-container');
  window.requestAnimationFrame = (cb) => { cb(); return 1; };
  stack = require('../js/shared/toast-stack');
});

describe('branchement', () => {
  test('le conteneur de la page devient un paquet, vide au départ', () => {
    expect(container.classList.contains('toast-stack')).toBe(true);
    expect(container.classList.contains('is-empty')).toBe(true);
    expect(prop(container, '--stack-h')).toBe('0px');
  });

  test('un second branchement ne double pas les écouteurs', () => {
    expect(stack.attach(container)).toBeNull();
  });

  test('conteneur créé plus tard (cookies.js, sw-register.js) : branché à sa création', async () => {
    jest.resetModules();
    document.body.innerHTML = '';
    require('../js/shared/toast-stack');
    const late = document.createElement('div');
    late.id = 'toast-container';
    document.body.appendChild(late);
    await new Promise((r) => setTimeout(r, 0));
    expect(late.classList.contains('toast-stack')).toBe(true);
  });
});

describe('paquet replié', () => {
  test('le plus récent devant, les autres décalés et réduits, trois visibles', () => {
    const toasts = ['a', 'b', 'c', 'd'].map((x) => addToast(x));
    stack.layout(container);
    const [a, b, c, d] = toasts;
    expect(prop(d, '--toast-y')).toBe('0px');
    expect(prop(d, '--toast-s')).toBe('1');
    expect(d.classList.contains('is-behind')).toBe(false);
    expect(prop(c, '--toast-y')).toBe('-14px');
    expect(prop(c, '--toast-s')).toBe('0.95');
    expect(c.classList.contains('is-behind')).toBe(true);
    expect(prop(b, '--toast-y')).toBe('-28px');
    expect(a.classList.contains('is-hidden-stack')).toBe(true);
    expect(Number(prop(d, '--toast-z'))).toBeGreaterThan(Number(prop(a, '--toast-z')));
    // devant (62 px de haut) + deux décalages
    expect(prop(container, '--stack-h')).toBe(62 + 2 * 14 + 'px');
    expect(prop(container, '--front-h')).toBe('62px');
  });

  test('un toast en sortie quitte le paquet : les autres avancent', () => {
    const a = addToast('a');
    const b = addToast('b');
    b.classList.add('fade-out');
    stack.layout(container);
    expect(prop(a, '--toast-y')).toBe('0px');
    expect(a.classList.contains('is-behind')).toBe(false);
  });
});

describe('paquet déplié', () => {
  test('au survol : chaque toast reprend sa place, l’un au-dessus de l’autre', () => {
    const a = addToast('a', 60);
    const b = addToast('b', 90);
    container.dispatchEvent(new Event('pointerenter'));
    expect(container.classList.contains('is-expanded')).toBe(true);
    expect(prop(b, '--toast-y')).toBe('0px');
    expect(prop(a, '--toast-y')).toBe(-(92 + 12) + 'px');
    expect(prop(a, '--toast-s')).toBe('1');
    expect(a.classList.contains('is-behind')).toBe(false);
    expect(prop(container, '--stack-h')).toBe(92 + 12 + 62 + 'px');
    container.dispatchEvent(new Event('pointerleave'));
    expect(container.classList.contains('is-expanded')).toBe(false);
  });

  test('au clavier : déplié tant que le focus reste dans le paquet', () => {
    const a = addToast('a');
    const btn = document.createElement('button');
    a.appendChild(btn);
    container.dispatchEvent(new window.FocusEvent('focusin'));
    expect(container.classList.contains('is-expanded')).toBe(true);
    container.dispatchEvent(new window.FocusEvent('focusout', { relatedTarget: btn }));
    expect(container.classList.contains('is-expanded')).toBe(true);
    container.dispatchEvent(new window.FocusEvent('focusout', { relatedTarget: document.body }));
    expect(container.classList.contains('is-expanded')).toBe(false);
  });

  test('le paquet vidé se replie', () => {
    const a = addToast('a');
    container.dispatchEvent(new Event('pointerenter'));
    a.remove();
    stack.layout(container);
    expect(container.classList.contains('is-expanded')).toBe(false);
    expect(container.classList.contains('is-empty')).toBe(true);
  });
});
