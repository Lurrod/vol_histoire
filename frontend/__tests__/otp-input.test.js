/**
 * Tests — js/shared/otp-input.js : champ de code à usage unique.
 * Saisie case par case, retour arrière, flèches, collage, remplissage
 * automatique, états succès / erreur, désactivation, accessibilité.
 */
require('../js/shared/motion');
const { create, digitsOf } = require('../js/shared/otp-input');

let root;
let onChange;
let onComplete;
let otp;

const key = (k, extra = {}) => {
  const ev = new window.KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true, ...extra });
  otp.input.dispatchEvent(ev);
  return ev;
};
const type = (text) => [...text].forEach((c) => key(c));
const slots = () => [...root.querySelectorAll('.otp-slot')];
const shown = () => slots().map((s) => s.querySelector('.otp-char:not(.is-out)')?.textContent || '').join('');

beforeEach(() => {
  document.body.innerHTML = '<div id="otp"></div><p id="hint">Aide</p>';
  root = document.getElementById('otp');
  onChange = jest.fn();
  onComplete = jest.fn();
  otp = create(root, { label: 'Code', describedBy: 'hint', onChange, onComplete });
});

describe('structure', () => {
  test('six cases décoratives, un vrai champ étiqueté, curseur', () => {
    expect(slots()).toHaveLength(6);
    expect(root.querySelector('.otp-row').getAttribute('aria-hidden')).toBe('true');
    expect(otp.input.getAttribute('aria-label')).toBe('Code');
    expect(otp.input.getAttribute('aria-describedby')).toBe('hint');
    expect(otp.input.autocomplete).toBe('one-time-code');
    expect(otp.input.inputMode).toBe('numeric');
    expect(otp.input.maxLength).toBe(6);
    expect(root.querySelector('.otp-caret')).not.toBeNull();
    expect(slots()[2].style.getPropertyValue('--otp-i')).toBe('2');
  });

  test('longueur personnalisée et étiquette par défaut', () => {
    const other = document.createElement('div');
    const four = create(other, { length: 4 });
    expect(other.querySelectorAll('.otp-slot')).toHaveLength(4);
    expect(four.input.getAttribute('aria-label')).toBe('Code');
    expect(four.input.hasAttribute('aria-describedby')).toBe(false);
  });

  test('digitsOf ne garde que les chiffres', () => {
    expect(digitsOf('12 34-5a6')).toBe('123456');
    expect(digitsOf(null)).toBe('');
  });
});

describe('saisie', () => {
  test('chiffres un à un : cases remplies, valeur suivie, fin annoncée une fois', () => {
    type('1234');
    expect(otp.value()).toBe('1234');
    expect(shown()).toBe('1234');
    expect(otp.input.value).toBe('1234');
    expect(onChange).toHaveBeenLastCalledWith('1234');
    expect(onComplete).not.toHaveBeenCalled();
    type('56');
    expect(onComplete).toHaveBeenCalledTimes(1);
    expect(onComplete).toHaveBeenCalledWith('123456');
    expect(slots().every((s) => s.classList.contains('is-filled'))).toBe(true);
  });

  test('une lettre, ou une touche avec Ctrl, est laissée au navigateur', () => {
    const ev = key('a');
    expect(ev.defaultPrevented).toBe(false);
    const paste = key('v', { ctrlKey: true });
    expect(paste.defaultPrevented).toBe(false);
    expect(otp.value()).toBe('');
  });

  test('retour arrière : efface la case sur place, puis recule', () => {
    type('123');
    key('ArrowLeft'); // curseur sur la case 3 (remplie)
    key('Backspace');
    expect(otp.value()).toBe('12');
    key('Backspace');
    expect(otp.value()).toBe('1');
    // Le chiffre retiré sort par une animation avant d'être ôté du DOM.
    expect(slots()[1].querySelector('.otp-char:not(.is-out)')).toBeNull();
  });

  test('Suppr efface la case active, Début / Fin déplacent le curseur', () => {
    type('123456');
    key('Home');
    key('Delete');
    expect(otp.value()).toBe('23456'.padStart(5, ''));
    expect(slots()[0].classList.contains('is-filled')).toBe(false);
    key('End'); // première case vide
    key('9');
    expect(shown()).toBe('923456');
  });

  test('flèches : on réécrit une case au milieu', () => {
    type('111111');
    key('Home');
    key('ArrowRight');
    key('ArrowRight');
    key('7');
    expect(otp.value()).toBe('117111');
    key('ArrowRight');
    key('ArrowRight');
    key('ArrowRight');
    key('ArrowRight'); // au bout : reste sur la dernière
    key('8');
    expect(otp.value()).toBe('117118');
  });

  test('collage : code complet (même espacé) depuis le début', () => {
    type('9');
    const ev = new window.Event('paste', { bubbles: true, cancelable: true });
    ev.clipboardData = { getData: () => '12 34 56' };
    otp.input.dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(true);
    expect(otp.value()).toBe('123456');
    expect(onComplete).toHaveBeenCalledWith('123456');
  });

  test('collage partiel : à partir de la case active ; collage sans chiffre ignoré', () => {
    type('1');
    const ev = new window.Event('paste', { bubbles: true, cancelable: true });
    ev.clipboardData = { getData: () => '23' };
    otp.input.dispatchEvent(ev);
    expect(otp.value()).toBe('123');
    const empty = new window.Event('paste', { bubbles: true, cancelable: true });
    empty.clipboardData = { getData: () => 'abc' };
    otp.input.dispatchEvent(empty);
    expect(otp.value()).toBe('123');
  });

  test('remplissage automatique (événement input avec le code entier)', () => {
    otp.input.value = '654321';
    otp.input.dispatchEvent(new window.Event('input', { bubbles: true }));
    expect(otp.value()).toBe('654321');
    expect(onComplete).toHaveBeenCalledWith('654321');
  });

  test('clavier virtuel (un chiffre ajouté par input) ; valeur inchangée : rien', () => {
    otp.input.value = '4';
    otp.input.dispatchEvent(new window.Event('input', { bubbles: true }));
    expect(otp.value()).toBe('4');
    onChange.mockClear();
    otp.input.dispatchEvent(new window.Event('input', { bubbles: true }));
    expect(onChange).not.toHaveBeenCalled();
    otp.input.value = '';
    otp.input.dispatchEvent(new window.Event('input', { bubbles: true }));
    expect(otp.input.value).toBe('4'); // resynchronisé sur les cases
  });
});

describe('focus et curseur', () => {
  test('le focus pose le curseur sur la première case vide', () => {
    type('12');
    otp.input.blur();
    otp.focus();
    expect(root.classList.contains('is-focused')).toBe(true);
    expect(root.querySelector('.otp-caret').classList.contains('is-empty')).toBe(true);
    otp.input.blur();
    expect(root.classList.contains('is-focused')).toBe(false);
  });

  test('clic sur une case : focus et curseur sur cette case', () => {
    type('123456');
    const ev = new window.MouseEvent('mousedown', { bubbles: true, cancelable: true });
    slots()[1].dispatchEvent(ev);
    expect(ev.defaultPrevented).toBe(true);
    expect(document.activeElement).toBe(otp.input);
    key('0');
    expect(otp.value()).toBe('103456');
    // Clic hors des cases : ignoré
    root.querySelector('.otp-row').dispatchEvent(new window.MouseEvent('mousedown', { bubbles: true }));
  });
});

describe('états', () => {
  test('erreur : classe et aria-invalid, puis toute saisie revient à neutre', () => {
    type('123456');
    otp.setStatus('error');
    expect(root.classList.contains('is-error')).toBe(true);
    expect(otp.input.getAttribute('aria-invalid')).toBe('true');
    key('Backspace');
    expect(root.classList.contains('is-error')).toBe(false);
    expect(otp.input.getAttribute('aria-invalid')).toBe('false');
  });

  test('succès puis clear : tout est vidé', () => {
    type('123456');
    otp.setStatus('success');
    expect(root.classList.contains('is-success')).toBe(true);
    otp.clear();
    expect(otp.value()).toBe('');
    expect(root.classList.contains('is-success')).toBe(false);
    expect(otp.input.value).toBe('');
  });

  test('désactivé : la saisie est ignorée', () => {
    otp.setDisabled(true);
    expect(root.classList.contains('is-disabled')).toBe(true);
    key('5');
    expect(otp.value()).toBe('');
    otp.setDisabled(false);
    key('5');
    expect(otp.value()).toBe('5');
  });
});
