/**
 * Tests unitaires — frontend/js/utils.js
 * escapeHtml, showToast, animateNumber, setupPasswordToggle, safeSetHTML,
 * trapFocus, setNumberPopIn
 */

const { escapeHtml, safeSetHTML, trapFocus, setNumberPopIn, showToast, animateNumber, setupPasswordToggle, setFieldError, clearFieldError, isValidEmail, calculatePasswordStrength } = require('../js/utils');

beforeEach(() => {
  document.body.innerHTML = '';
});

// =============================================================================
// escapeHtml
// =============================================================================
describe('escapeHtml', () => {
  test('échappe les caractères HTML dangereux', () => {
    expect(escapeHtml('<script>alert("xss")</script>')).toBe(
      '&lt;script&gt;alert("xss")&lt;/script&gt;'
    );
  });

  test('échappe les guillemets et esperluettes', () => {
    expect(escapeHtml('a & b "c"')).toBe('a &amp; b "c"');
  });

  test('retourne une chaîne vide pour null', () => {
    expect(escapeHtml(null)).toBe('');
  });

  test('retourne une chaîne vide pour undefined', () => {
    expect(escapeHtml(undefined)).toBe('');
  });

  test('convertit les nombres en string', () => {
    expect(escapeHtml(42)).toBe('42');
  });

  test('gère une chaîne vide', () => {
    expect(escapeHtml('')).toBe('');
  });

  test('ne modifie pas le texte sans caractères spéciaux', () => {
    expect(escapeHtml('Hello World')).toBe('Hello World');
  });

  test('échappe les chevrons imbriqués', () => {
    expect(escapeHtml('<div onclick="alert(1)">test</div>')).toContain('&lt;div');
  });
});

// =============================================================================
// showToast
// =============================================================================
describe('showToast', () => {
  test('crée un toast dans le body si pas de #toast-container', () => {
    showToast('Test message');

    const toast = document.querySelector('.toast');
    expect(toast).not.toBeNull();
    expect(toast.classList.contains('toast-info')).toBe(true);
    expect(toast.textContent).toContain('Test message');
  });

  test('crée un toast dans #toast-container si présent', () => {
    document.body.innerHTML = '<div id="toast-container"></div>';

    showToast('Container test');

    const container = document.getElementById('toast-container');
    const toast = container.querySelector('.toast');
    expect(toast).not.toBeNull();
  });

  test('applique le type success', () => {
    showToast('Succès', 'success');

    const toast = document.querySelector('.toast');
    expect(toast.classList.contains('toast-success')).toBe(true);
    expect(toast.innerHTML).toContain('fa-check-circle');
  });

  test('applique le type error', () => {
    showToast('Erreur', 'error');

    const toast = document.querySelector('.toast');
    expect(toast.classList.contains('toast-error')).toBe(true);
    expect(toast.innerHTML).toContain('fa-exclamation-circle');
  });

  test('applique le type info par défaut', () => {
    showToast('Info');

    const toast = document.querySelector('.toast');
    expect(toast.classList.contains('toast-info')).toBe(true);
    expect(toast.innerHTML).toContain('fa-info-circle');
  });

  test('le toast a le rôle status (accessibilité)', () => {
    showToast('Accessible');

    const toast = document.querySelector('.toast');
    expect(toast.getAttribute('role')).toBe('status');
  });

  test('le message est en textContent (pas innerHTML) pour la sécurité', () => {
    showToast('<script>alert(1)</script>');

    const span = document.querySelector('.toast span');
    expect(span.textContent).toBe('<script>alert(1)</script>');
    expect(span.innerHTML).not.toContain('<script>');
  });

  test('le toast reçoit fade-out après le duration', () => {
    jest.useFakeTimers();
    showToast('Fade test', 'info', 1000);

    jest.advanceTimersByTime(1000);
    const toast = document.querySelector('.toast');
    expect(toast.classList.contains('fade-out')).toBe(true);

    jest.useRealTimers();
  });
});

// =============================================================================
// animateNumber
// =============================================================================
describe('animateNumber', () => {
  test('ne crash pas si el est null', () => {
    expect(() => animateNumber(null, 100)).not.toThrow();
  });

  test('met à jour le textContent de l\'élément', () => {
    jest.useFakeTimers();
    const el = document.createElement('span');
    document.body.appendChild(el);

    // Mock requestAnimationFrame
    let rafCallback;
    jest.spyOn(window, 'requestAnimationFrame').mockImplementation(cb => {
      rafCallback = cb;
      return 1;
    });

    animateNumber(el, 100, 1000);

    // Simuler la fin de l'animation
    if (rafCallback) rafCallback(window.performance.now() + 1000);

    expect(Number(el.textContent)).toBe(100);

    window.requestAnimationFrame.mockRestore();
    jest.useRealTimers();
  });
});

// =============================================================================
// setupPasswordToggle
// =============================================================================
describe('setupPasswordToggle', () => {
  test('ne crash pas avec des éléments null', () => {
    expect(() => setupPasswordToggle(null, null)).not.toThrow();
    expect(() => setupPasswordToggle(null, document.createElement('input'))).not.toThrow();
  });

  test('toggle le type du champ password → text → password', () => {
    const button = document.createElement('button');
    const icon = document.createElement('i');
    icon.classList.add('fa-eye-slash');
    button.appendChild(icon);

    const input = document.createElement('input');
    input.type = 'password';

    setupPasswordToggle(button, input);

    // Premier clic → text
    button.click();
    expect(input.type).toBe('text');
    expect(icon.classList.contains('fa-eye')).toBe(true);
    expect(icon.classList.contains('fa-eye-slash')).toBe(false);

    // Deuxième clic → password
    button.click();
    expect(input.type).toBe('password');
    expect(icon.classList.contains('fa-eye-slash')).toBe(true);
    expect(icon.classList.contains('fa-eye')).toBe(false);
  });
});

// =============================================================================
// isValidEmail
// =============================================================================
describe('isValidEmail', () => {
  test('accepte un email valide', () => {
    expect(isValidEmail('user@example.com')).toBe(true);
  });

  test('refuse un email sans @', () => {
    expect(isValidEmail('userexample.com')).toBe(false);
  });

  test('refuse un email trop long (> 255)', () => {
    expect(isValidEmail('a'.repeat(250) + '@b.com')).toBe(false);
  });

  test('refuse null/undefined', () => {
    expect(isValidEmail(null)).toBe(false);
    expect(isValidEmail(undefined)).toBe(false);
  });
});

// =============================================================================
// calculatePasswordStrength
// =============================================================================
describe('calculatePasswordStrength', () => {
  test('retourne 0 pour un mot de passe vide', () => {
    expect(calculatePasswordStrength('')).toBe(0);
  });

  test('retourne 100 pour un mot de passe fort', () => {
    expect(calculatePasswordStrength('MyStr0ng!Passw0rd')).toBe(100);
  });

  test('ne dépasse jamais 100', () => {
    expect(calculatePasswordStrength('A1b2c3d4e5f6!@#$%^&*')).toBeLessThanOrEqual(100);
  });
});

// =============================================================================
// setFieldError / clearFieldError
// =============================================================================
describe('setFieldError', () => {
  test('ne crash pas si inputEl est null', () => {
    expect(() => setFieldError(null, 'erreur')).not.toThrow();
  });

  test('ajoute aria-invalid et crée un span.form-error', () => {
    const container = document.createElement('div');
    const input = document.createElement('input');
    input.id = 'test-input';
    container.appendChild(input);
    document.body.appendChild(container);

    setFieldError(input, 'Champ requis');

    expect(input.getAttribute('aria-invalid')).toBe('true');
    expect(input.getAttribute('aria-describedby')).toBe('test-input-error');

    const errEl = document.getElementById('test-input-error');
    expect(errEl).not.toBeNull();
    expect(errEl.textContent).toBe('Champ requis');
    expect(errEl.getAttribute('role')).toBe('alert');
  });

  test('réutilise le span existant au deuxième appel', () => {
    const container = document.createElement('div');
    const input = document.createElement('input');
    input.id = 'reuse-input';
    container.appendChild(input);
    document.body.appendChild(container);

    setFieldError(input, 'Erreur 1');
    setFieldError(input, 'Erreur 2');

    const spans = container.querySelectorAll('.form-error');
    expect(spans.length).toBe(1);
    expect(spans[0].textContent).toBe('Erreur 2');
  });
});

describe('clearFieldError', () => {
  test('ne crash pas si inputEl est null', () => {
    expect(() => clearFieldError(null)).not.toThrow();
  });

  test('retire aria-invalid et vide le texte d\'erreur', () => {
    const container = document.createElement('div');
    const input = document.createElement('input');
    input.id = 'clear-input';
    container.appendChild(input);
    document.body.appendChild(container);

    setFieldError(input, 'Erreur');
    clearFieldError(input);

    expect(input.hasAttribute('aria-invalid')).toBe(false);
    const errEl = document.getElementById('clear-input-error');
    expect(errEl.textContent).toBe('');
  });
});

/* ──────────────────────────────────────────────────────────────────────────
   QUAL-01 — trois fonctions de utils.js n'avaient aucun test : safeSetHTML,
   trapFocus et setNumberPopIn. Ce sont précisément les lignes que la couverture
   signalait comme non couvertes, et trapFocus est un composant d'accessibilité :
   une régression dessus enferme ou libère silencieusement le clavier.
   ────────────────────────────────────────────────────────────────────────── */

describe('safeSetHTML', () => {
  afterEach(() => {
    delete global.DOMPurify;
    delete window.DOMPurify;
  });

  test('sans DOMPurify, le repli DOMParser desarme sans tout detruire', () => {
    const el = document.createElement('div');
    safeSetHTML(el, '<b>gras</b><img src="x" onerror="alert(1)"><script>alert(2)<\/script>');
    // Le balisage sain survit...
    expect(el.querySelector('b')).not.toBeNull();
    expect(el.querySelector('b').textContent).toBe('gras');
    // ...mais le script est retire et le gestionnaire inline desarme.
    expect(el.querySelector('script')).toBeNull();
    expect(el.querySelector('img').hasAttribute('onerror')).toBe(false);
  });

  test('sans DOMPurify, un lien javascript: perd son href', () => {
    const el = document.createElement('div');
    safeSetHTML(el, '<a href="javascript:alert(1)">clic</a>');
    expect(el.querySelector('a').hasAttribute('href')).toBe(false);
  });

  test('avec DOMPurify, la sanitisation est déléguée', () => {
    const sanitize = jest.fn(() => '<b>propre</b>');
    global.DOMPurify = { sanitize };
    window.DOMPurify = global.DOMPurify;
    const el = document.createElement('div');
    safeSetHTML(el, '<b onclick="x">propre</b>');
    expect(sanitize).toHaveBeenCalled();
    expect(el.innerHTML).toBe('<b>propre</b>');
  });

  test('un élément absent ne provoque pas d\'erreur', () => {
    expect(() => safeSetHTML(null, '<p>x</p>')).not.toThrow();
  });
});

describe('trapFocus', () => {
  let conteneur;

  beforeEach(() => {
    conteneur = document.createElement('div');
    conteneur.innerHTML = '<button id="a">A</button><button id="b">B</button><button id="c">C</button>';
    document.body.appendChild(conteneur);
    // jsdom ne calcule pas offsetParent : le filtre de visibilité de trapFocus
    // s'appuie dessus, on le rend donc non nul pour les boutons du test.
    conteneur.querySelectorAll('button').forEach((b) => {
      Object.defineProperty(b, 'offsetParent', { get: () => conteneur, configurable: true });
    });
  });

  afterEach(() => {
    document.body.innerHTML = '';
  });

  const tab = (opts = {}) => new window.KeyboardEvent('keydown', { key: 'Tab', bubbles: true, ...opts });

  test('Tab depuis le dernier élément revient au premier', () => {
    const piege = trapFocus(conteneur);
    document.getElementById('c').focus();
    conteneur.dispatchEvent(tab());
    expect(document.activeElement.id).toBe('a');
    piege.destroy();
  });

  test('Shift+Tab depuis le premier élément va au dernier', () => {
    const piege = trapFocus(conteneur);
    document.getElementById('a').focus();
    conteneur.dispatchEvent(tab({ shiftKey: true }));
    expect(document.activeElement.id).toBe('c');
    piege.destroy();
  });

  test('Tab au milieu ne détourne pas le focus', () => {
    const piege = trapFocus(conteneur);
    document.getElementById('b').focus();
    conteneur.dispatchEvent(tab());
    expect(document.activeElement.id).toBe('b'); // le navigateur fait le reste
    piege.destroy();
  });

  test('Échap déclenche le rappel fourni', () => {
    const onEscape = jest.fn();
    const piege = trapFocus(conteneur, { onEscape });
    conteneur.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Escape', bubbles: true }));
    expect(onEscape).toHaveBeenCalledTimes(1);
    piege.destroy();
  });

  test('destroy() retire l\'écouteur : le piège ne retient plus rien', () => {
    const piege = trapFocus(conteneur);
    piege.destroy();
    document.getElementById('c').focus();
    conteneur.dispatchEvent(tab());
    expect(document.activeElement.id).toBe('c');
  });

  test('un conteneur absent rend un objet inerte mais utilisable', () => {
    const piege = trapFocus(null);
    expect(() => piege.destroy()).not.toThrow();
  });

  test('un conteneur sans élément focusable ne casse pas', () => {
    const vide = document.createElement('div');
    document.body.appendChild(vide);
    const piege = trapFocus(vide);
    expect(() => vide.dispatchEvent(tab())).not.toThrow();
    piege.destroy();
  });
});

describe('setNumberPopIn', () => {
  test('un span par caractère, avec décalage sur les deux derniers', () => {
    const el = document.createElement('strong');
    setNumberPopIn(el, 383);
    const spans = el.querySelectorAll('span.t-digit');
    expect(spans).toHaveLength(3);
    expect([...spans].map((s) => s.textContent).join('')).toBe('383');
    expect(spans[1].dataset.stagger).toBe('1');
    expect(spans[2].dataset.stagger).toBe('2');
    expect(el.classList.contains('t-digit-group')).toBe(true);
    expect(el.classList.contains('is-animating')).toBe(true);
  });

  test('un second appel remplace le contenu au lieu de l\'empiler', () => {
    const el = document.createElement('strong');
    setNumberPopIn(el, 12);
    setNumberPopIn(el, 3456);
    expect(el.querySelectorAll('span.t-digit')).toHaveLength(4);
    expect(el.textContent).toBe('3456');
  });

  test('un élément absent ne provoque pas d\'erreur', () => {
    expect(() => setNumberPopIn(null, 5)).not.toThrow();
  });
});
