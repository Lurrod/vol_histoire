// e2e/helpers/auth.js
// Helper réutilisable pour authentifier un test E2E.
//
// Stratégie :
//  1. POST /api/login via page.request → le serveur pose le cookie refreshToken
//     dans le BrowserContext (même origine que le frontend → cookie envoyé sur
//     les navigations suivantes).
//  2. page.goto('/') → auth.init() de auth.js appelle /api/refresh, récupère
//     un access token et le stocke en mémoire.
//  3. waitForFunction polle auth.getPayload() jusqu'à ce qu'il retourne un
//     payload non-null → garantit que l'utilisateur est authentifié AVANT
//     que le test ne fasse quoi que ce soit. Pas de timing fragile.

async function loginViaApi(page, email, password) {
  // 1. Login via API REST. URL relative → page.request hérite du baseURL
  //    du context (http://localhost:3000), donc même origine que le frontend.
  const response = await page.request.post('/api/login', {
    data: { email, password },
  });
  if (!response.ok()) {
    const body = await response.text();
    throw new Error(`Login API failed (${response.status()}) : ${body}`);
  }

  // 2. Navigate to home — déclenche auth.init() → /api/refresh → token en mémoire.
  await page.goto('/');

  // 3. Attend que auth.getPayload() retourne un payload non-null.
  //    C'est la VRAIE condition de succès : pas de timing, pas de proxy,
  //    pas de networkidle. On vérifie directement l'état applicatif.
  // Note : `auth` est un `const` au top-level d'un script classique → vit
  // dans le scope script partagé, accessible depuis waitForFunction sans
  // préfixe window. (window.auth n'existe PAS car const ne s'attache pas
  // au global object.)
  await page.waitForFunction(
    () => {
      try {
        return typeof auth !== 'undefined' && auth.getPayload() !== null;
      } catch {
        return false;
      }
    },
    null,
    { timeout: 10000 }
  );
}

module.exports = { loginViaApi };
