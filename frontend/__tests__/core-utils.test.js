/**
 * Tests — frontend/js/utils.js : chemins de secours de safeSetHTML
 * (DOMPurify absent) et leur signalement à Sentry plutôt qu'en console.
 */
const { safeSetHTML } = require('../js/utils');

beforeEach(() => {
  delete global.DOMPurify;
  delete window.Sentry;
});

afterEach(() => jest.restoreAllMocks());

describe('safeSetHTML — repli sans DOMPurify', () => {
  test('Sentry présent : avertissement envoyé à Sentry, rien en console', () => {
    window.Sentry = { captureMessage: jest.fn(), captureException: jest.fn() };
    const warn = jest.spyOn(console, 'warn').mockImplementation(() => {});
    const el = document.createElement('div');
    safeSetHTML(el, '<b>ok</b><script>alert(1)</script>');
    expect(el.innerHTML).toBe('<b>ok</b>');
    expect(window.Sentry.captureMessage).toHaveBeenCalledWith(expect.stringContaining('DOMPurify indisponible'), 'warning');
    expect(warn).not.toHaveBeenCalled();
  });

  test('analyse impossible : injection refusée (élément vidé) et exception remontée', () => {
    window.Sentry = { captureMessage: jest.fn(), captureException: jest.fn() };
    const boom = new Error('DOMParser indisponible');
    jest.spyOn(window.DOMParser.prototype, 'parseFromString').mockImplementation(() => { throw boom; });
    const el = document.createElement('div');
    el.textContent = 'ancien contenu';
    safeSetHTML(el, '<b>x</b>');
    expect(el.textContent).toBe('');
    expect(window.Sentry.captureException).toHaveBeenCalledWith(boom);
  });

  test('analyse impossible sans Sentry : erreur en console, élément vidé', () => {
    const error = jest.spyOn(console, 'error').mockImplementation(() => {});
    jest.spyOn(console, 'warn').mockImplementation(() => {});
    jest.spyOn(window.DOMParser.prototype, 'parseFromString').mockImplementation(() => { throw new Error('x'); });
    const el = document.createElement('div');
    el.textContent = 'ancien';
    safeSetHTML(el, '<b>x</b>');
    expect(el.textContent).toBe('');
    expect(error).toHaveBeenCalledWith(expect.stringContaining('injection refusée'), expect.any(Error));
  });

  test('Sentry sans captureException : message d’erreur envoyé à la place', () => {
    window.Sentry = { captureMessage: jest.fn() };
    jest.spyOn(window.DOMParser.prototype, 'parseFromString').mockImplementation(() => { throw new Error('x'); });
    safeSetHTML(document.createElement('div'), '<b>x</b>');
    expect(window.Sentry.captureMessage).toHaveBeenLastCalledWith(expect.stringContaining('injection refusée'), 'error');
  });
});
