/**
 * Tests unitaires — frontend/js/utils.js
 * escapeHtml, showToast, animateNumber, setupPasswordToggle
 */

const { escapeHtml, showToast, animateNumber, setupPasswordToggle } = require('../js/utils');

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
    if (rafCallback) rafCallback(performance.now() + 1000);

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
