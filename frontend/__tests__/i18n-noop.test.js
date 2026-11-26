/**
 * i18n.applyToDOM (PERF-003) : un texte déjà dans la langue voulue (rendu
 * serveur) n'est pas réécrit — réécrire un nœud identique le faisait
 * repeindre à l'exécution du script.
 */
let i18n;

beforeAll(async () => {
  localStorage.clear();
  global.fetch = jest.fn().mockResolvedValue({
    ok: true,
    json: async () => ({ home: { title: 'Identique', other: 'Traduit' } }),
  });
  i18n = require('../js/i18n');
  await i18n.setLang('fr');
});

afterAll(() => { delete global.fetch; });

test('texte identique : même nœud, aucune écriture', () => {
  document.body.innerHTML = '<h1 data-i18n="home.title">Identique</h1>';
  const node = document.querySelector('h1').firstChild;
  i18n.applyToDOM();
  expect(document.querySelector('h1').firstChild).toBe(node);
});

test('texte différent : traduit comme avant', () => {
  document.body.innerHTML = '<h1 data-i18n="home.other">Autre</h1>';
  i18n.applyToDOM();
  expect(document.querySelector('h1').textContent).toBe('Traduit');
});
