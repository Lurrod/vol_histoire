// Vérifie que les liens des widgets Fact + Quiz pointent désormais
// sur /details?id=N (lien direct sur la fiche correspondante) plutôt
// que sur /hangar?search=…
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  const errors = [];
  page.on('pageerror', (err) => errors.push(String(err)));

  await page.goto('http://localhost:3000/', { waitUntil: 'networkidle' });

  // 1) Fact : on attend que le href soit muté (≠ "#")
  await page.waitForFunction(
    () => {
      const f = document.getElementById('hero-fact-link');
      return f && f.getAttribute('href') && f.getAttribute('href') !== '#';
    },
    { timeout: 8000 },
  );
  const factHref = await page.getAttribute('#hero-fact-link', 'href');
  console.log('fact link href :', factHref);

  // Clic sur le fact → doit naviguer vers /details?id=…
  await page.click('#hero-fact-link');
  await page.waitForLoadState('networkidle', { timeout: 5000 }).catch(() => null);
  console.log('after fact click → URL :', page.url());
  console.log('       title :', await page.title());

  // 2) Quiz : retour à la home, on déclenche la révélation
  await page.goto('http://localhost:3000/', { waitUntil: 'networkidle' });
  // Attendre que load() ait peuplé les boutons (dataset.value présent =
  // l'init est passée, sans ça le placeholder HTML "—" donne le change).
  await page.waitForFunction(
    () => {
      const b = document.querySelector('.hero-quiz-option');
      return b && b.dataset.value;
    },
    { timeout: 8000 },
  );

  const preState = await page.evaluate(() => {
    const btns = [...document.querySelectorAll('.hero-quiz-option')];
    return {
      count: btns.length,
      texts: btns.map(b => b.textContent),
      disabled: btns.map(b => b.disabled),
      datasets: btns.map(b => b.dataset.value),
      linkHidden: document.getElementById('hero-quiz-link').hasAttribute('hidden'),
    };
  });
  console.log('pre-click state :', preState);

  // Dispatch un click natif sur la première option, en JS
  const postState = await page.evaluate(() => {
    const btn = document.querySelector('.hero-quiz-options .hero-quiz-option');
    btn.click();
    // Lecture immédiate après bubble
    const link = document.getElementById('hero-quiz-link');
    return {
      cardRevealed: document.getElementById('hero-quiz-card').classList.contains('is-revealed'),
      linkHidden: link.hasAttribute('hidden'),
      linkHref: link.getAttribute('href'),
    };
  });
  console.log('post-click state :', postState);

  if (postState.linkHref && postState.linkHref !== '#') {
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'load', timeout: 8000 }).catch(() => null),
      page.click('#hero-quiz-link'),
    ]);
    console.log('after quiz click → URL :', page.url());
    console.log('       title :', await page.title());
  } else {
    console.log('Quiz link not revealed — skipping click test');
  }

  console.log('---');
  console.log('pageerrors :', errors.length === 0 ? 'NONE ✓' : errors);

  await browser.close();
})();
