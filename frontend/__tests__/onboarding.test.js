/**
 * Tests unitaires — frontend/js/onboarding.js
 * Icône remplacée à chaque étape (icons.js ignore les changements de classe),
 * focus conservé au changement d'étape, piège à focus et fermeture.
 */

const { escapeHtml, trapFocus } = require('../js/utils');

global.escapeHtml = escapeHtml;
global.trapFocus = jest.fn(trapFocus);
global.auth = {
  getToken: jest.fn().mockReturnValue('jeton'),
  getPayload: jest.fn().mockReturnValue({ name: 'Jean' }),
};
global.i18n = { t: jest.fn((key) => key) };

const { createTour } = require('../js/onboarding');

beforeEach(() => {
  jest.useFakeTimers();
  jest.clearAllMocks();
  document.body.innerHTML = '<button id="avant" type="button">Avant</button>';
  localStorage.clear();
});

afterEach(() => {
  jest.useRealTimers();
});

function openTour() {
  const tour = createTour();
  jest.advanceTimersByTime(20);
  return tour;
}

describe('onboarding — icône', () => {
  test('la première étape insère un <i> avec la classe de son icône', () => {
    openTour();
    const icon = document.querySelector('.ob-icon-ring i');
    expect(icon).not.toBeNull();
    expect(icon.className).toBe('fas fa-satellite-dish');
    expect(icon.getAttribute('aria-hidden')).toBe('true');
  });

  test('l’étape suivante remplace l’élément au lieu de changer sa classe', () => {
    openTour();
    jest.advanceTimersByTime(500);
    const first = document.querySelector('.ob-icon-ring i');

    document.querySelector('.ob-next').click();
    jest.advanceTimersByTime(700);

    const second = document.querySelector('.ob-icon-ring i');
    expect(second).not.toBe(first);
    expect(first.isConnected).toBe(false);
    expect(second.className).toBe('fas fa-jet-fighter');
    expect(document.querySelectorAll('.ob-icon-ring > *')).toHaveLength(1);
  });
});

describe('onboarding — focus', () => {
  test('le dialogue pose un piège à focus', () => {
    openTour();
    expect(global.trapFocus).toHaveBeenCalledTimes(1);
    expect(global.trapFocus.mock.calls[0][0].classList.contains('ob')).toBe(true);
  });

  test('« Suivant » garde le focus après reconstruction des boutons', () => {
    openTour();
    jest.advanceTimersByTime(500);
    document.querySelector('.ob-next').focus();

    document.querySelector('.ob-next').click();
    jest.advanceTimersByTime(700);

    const next = document.querySelector('.ob-next');
    expect(next).not.toBeNull();
    expect(document.activeElement).toBe(next);
  });

  test('à la dernière étape, le focus passe au bouton « Commencer »', () => {
    openTour();
    for (let i = 0; i < 3; i++) {
      jest.advanceTimersByTime(700);
      document.querySelector('.ob-next').focus();
      document.querySelector('.ob-next').click();
    }
    jest.advanceTimersByTime(700);
    expect(document.activeElement).toBe(document.querySelector('.ob-finish'));
  });

  test('une flèche pendant la transition ne saute pas d’étape', () => {
    openTour();
    jest.advanceTimersByTime(500);
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowRight' }));
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowRight' }));
    jest.advanceTimersByTime(700);
    expect(document.querySelector('.ob-counter').textContent).toBe('2 / 4');
  });

  test('Échap ferme, mémorise et rend le focus à l’élément d’origine', () => {
    const before = document.getElementById('avant');
    before.focus();
    openTour();
    jest.advanceTimersByTime(500);

    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
    expect(document.activeElement).toBe(before);
    expect(localStorage.getItem('vh-onboarding-done')).toBe('1');

    jest.advanceTimersByTime(700);
    expect(document.querySelector('.ob')).toBeNull();

    // Plus aucun écouteur clavier actif après fermeture.
    expect(() => document.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowRight' }))).not.toThrow();
  });
});
