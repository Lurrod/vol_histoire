/**
 * Tests unitaires — typographie française au rendu (frontend/js/details/markdown.js)
 *
 * Les récits des fiches sont saisis avec une espace ordinaire avant « : ; ? ! »
 * et des apostrophes droites. Le moteur Markdown corrige à l'affichage, pour le
 * français seulement, sans jamais toucher aux URL, au code, aux attributs ni aux
 * nombres et heures (12:30).
 */

window.VH = {};
require('../js/details/markdown');
const { parse, typographyFr } = window.VH.details.markdown;

const NBSP = ' ';
const NNBSP = ' ';

afterEach(() => {
  delete window.i18n;
  document.documentElement.lang = '';
});

/** Rend le HTML produit dans un conteneur pour l'inspecter en DOM. */
function dom(markdown, options) {
  const div = document.createElement('div');
  div.innerHTML = parse(markdown, options);
  return div;
}

describe('typographyFr — ponctuation double', () => {
  test('espace insécable (U+00A0) avant les deux-points', () => {
    expect(typographyFr('Engagements français : Kosovo')).toBe(`Engagements français${NBSP}: Kosovo`);
  });

  test.each([[';'], ['?'], ['!']])('espace fine insécable (U+202F) avant « %s »', (p) => {
    expect(typographyFr(`Vraiment ${p} oui`)).toBe(`Vraiment${NNBSP}${p} oui`);
  });

  test('plusieurs espaces ou une tabulation → une seule insécable', () => {
    expect(typographyFr('a   : b')).toBe(`a${NBSP}: b`);
    expect(typographyFr('a\t? b')).toBe(`a${NNBSP}? b`);
  });

  test('« ?! » : seule l\'espace avant le premier signe est remplacée', () => {
    expect(typographyFr('Quoi ?!')).toBe(`Quoi${NNBSP}?!`);
  });

  test('aucune espace n\'est ajoutée là où il n\'y en avait pas', () => {
    expect(typographyFr('Mach 2!')).toBe('Mach 2!');
    expect(typographyFr('Pourquoi?')).toBe('Pourquoi?');
  });

  test('heures et rapports collés intacts (12:30, 1:72)', () => {
    expect(typographyFr('Décollage à 12:30, maquette au 1:72.')).toBe('Décollage à 12:30, maquette au 1:72.');
  });

  test('une insécable déjà présente n\'est pas doublée', () => {
    expect(typographyFr(`déjà${NBSP}: correct`)).toBe(`déjà${NBSP}: correct`);
    expect(typographyFr(`déjà${NNBSP}? correct`)).toBe(`déjà${NNBSP}? correct`);
  });

  test('les sauts de ligne ne sont pas absorbés', () => {
    expect(typographyFr('fin\n: suite')).toBe('fin\n: suite');
  });
});

describe('typographyFr — guillemets', () => {
  test('espaces ordinaires à l\'intérieur des « » → insécables', () => {
    expect(typographyFr('surnommé « MiG Master » par')).toBe(`surnommé «${NBSP}MiG Master${NBSP}» par`);
  });

  test('guillemets collés → insécables ajoutées', () => {
    expect(typographyFr('le «Viggen»')).toBe(`le «${NBSP}Viggen${NBSP}»`);
  });

  test('insécables déjà présentes : pas de doublon', () => {
    expect(typographyFr(`«${NBSP}ok${NBSP}»`)).toBe(`«${NBSP}ok${NBSP}»`);
    expect(typographyFr(`«${NNBSP}ok${NNBSP}»`)).toBe(`«${NBSP}ok${NBSP}»`);
  });
});

describe('typographyFr — apostrophe', () => {
  test('apostrophe droite entre deux lettres → ’', () => {
    expect(typographyFr("l'Armée de l'air, aujourd'hui")).toBe('l’Armée de l’air, aujourd’hui');
  });

  test('lettres accentuées et majuscules', () => {
    expect(typographyFr("L'Étendard, qu'à")).toBe('L’Étendard, qu’à');
  });

  test('avant du Markdown (**, *), un chiffre ou un guillemet ouvrant', () => {
    expect(typographyFr("l'**Armée** et l'*Atlantique*")).toBe('l’**Armée** et l’*Atlantique*');
    expect(typographyFr("d'1,5 tonne")).toBe('d’1,5 tonne');
    expect(typographyFr("l'« Arrow »")).toBe(`l’«${NBSP}Arrow${NBSP}»`);
  });

  test('pas après un chiffre (pieds, minutes) ni en guillemet simple ouvrant', () => {
    expect(typographyFr("5'10")).toBe("5'10");
    expect(typographyFr("'citation'")).toBe("'citation'");
  });
});

describe('typographyFr — zones protégées', () => {
  test('URL en clair : ni apostrophe, ni « :// », ni « ? » de requête', () => {
    const url = "https://fr.wikipedia.org/wiki/Guerre_d'Alg%C3%A9rie?a=1";
    expect(typographyFr(`Voir ${url} ici`)).toBe(`Voir ${url} ici`);
  });

  test('URL en www. protégée', () => {
    expect(typographyFr("site www.l'exemple.fr : suite")).toBe(`site www.l'exemple.fr${NBSP}: suite`);
  });

  test('destination d\'un lien Markdown protégée, libellé traité', () => {
    const src = "[l'article ?](https://ex.com/l'avion?x=1)";
    expect(typographyFr(src)).toBe(`[l’article${NNBSP}?](https://ex.com/l'avion?x=1)`);
  });

  test('code entre accents graves protégé', () => {
    expect(typographyFr("le code `a ? b : c` et l'avion")).toBe('le code `a ? b : c` et l’avion');
  });

  test('entrée non textuelle ou vide → chaîne vide', () => {
    expect(typographyFr('')).toBe('');
    expect(typographyFr(null)).toBe('');
    expect(typographyFr(42)).toBe('');
  });
});

describe('parse — typographie appliquée au français seulement', () => {
  const RECIT = "## Carrière opérationnelle\nL'Aéronavale l'exploite : il assure la *surveillance* ; vraiment ?";

  test('lang « fr » : paragraphes et titres corrigés', () => {
    const root = dom(RECIT, { lang: 'fr' });
    expect(root.querySelector('p').textContent)
      .toBe(`L’Aéronavale l’exploite${NBSP}: il assure la surveillance${NNBSP}; vraiment${NNBSP}?`);
    expect(root.querySelector('h3').textContent).toBe('Carrière opérationnelle');
  });

  test('l’italique suivi d\'une insécable reste un italique', () => {
    const root = dom('la *Royale* : fin', { lang: 'fr' });
    expect(root.querySelector('em').textContent).toBe('Royale');
  });

  test('l’apostrophe typographique ouvre un italique (l’*Atlantique*)', () => {
    const root = dom("Remplacé par l'*Atlantique* en 1965.", { lang: 'fr' });
    expect(root.querySelector('em').textContent).toBe('Atlantique');
    expect(root.querySelector('p').textContent).toBe('Remplacé par l’Atlantique en 1965.');
  });

  test('éléments de liste et titres de niveau 3', () => {
    const root = dom("### L'héritage\n- **P.1127** : six prototypes", { lang: 'fr' });
    expect(root.querySelector('h4').textContent).toBe('L’héritage');
    expect(root.querySelector('li').textContent).toBe(`P.1127${NBSP}: six prototypes`);
  });

  test('href du lien intact, libellé corrigé, aucun caractère insécable dans l\'attribut', () => {
    const root = dom("Source : [l'article](https://ex.com/a?b=1&c=d'e)", { lang: 'fr' });
    const a = root.querySelector('a');
    expect(a.getAttribute('href')).toBe("https://ex.com/a?b=1&c=d'e");
    expect(a.textContent).toBe('l’article');
    expect(root.querySelector('p').textContent.startsWith(`Source${NBSP}:`)).toBe(true);
  });

  test('l\'échappement HTML reste en place', () => {
    const html = parse("<script>alert('x')</script> : fin", { lang: 'fr' });
    expect(html).not.toContain('<script>');
    expect(html).toContain('&lt;script&gt;');
  });

  test('lang « en » : texte inchangé', () => {
    const root = dom("It's fast : really ?", { lang: 'en' });
    expect(root.querySelector('p').textContent).toBe("It's fast : really ?");
  });

  test('variante régionale « fr-FR » acceptée, « french » refusée', () => {
    expect(dom("l'avion", { lang: 'fr-FR' }).textContent).toBe('l’avion');
    expect(dom("l'avion", { lang: 'french' }).textContent).toBe("l'avion");
  });
});

describe('parse — langue par défaut', () => {
  test('sans option : langue de l\'interface (i18n.currentLang)', () => {
    window.i18n = { currentLang: 'fr' };
    expect(dom("l'avion : ok").textContent).toBe(`l’avion${NBSP}: ok`);
    window.i18n = { currentLang: 'en' };
    expect(dom("l'avion : ok").textContent).toBe("l'avion : ok");
  });

  test('sans i18n : attribut lang du document', () => {
    document.documentElement.lang = 'fr';
    expect(dom("l'avion").textContent).toBe('l’avion');
  });

  test('aucune langue connue : pas de typographie', () => {
    expect(dom("l'avion : ok").textContent).toBe("l'avion : ok");
  });

  test('l\'option explicite l\'emporte sur l\'interface', () => {
    window.i18n = { currentLang: 'fr' };
    expect(dom("l'avion", { lang: 'en' }).textContent).toBe("l'avion");
  });
});
