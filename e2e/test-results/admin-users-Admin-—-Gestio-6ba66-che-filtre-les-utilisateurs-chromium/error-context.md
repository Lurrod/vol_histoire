# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: admin-users.spec.js >> Admin — Gestion des utilisateurs >> la recherche filtre les utilisateurs
- Location: tests\admin-users.spec.js:39:3

# Error details

```
TimeoutError: page.waitForURL: Timeout 10000ms exceeded.
=========================== logs ===========================
waiting for navigation until "load"
  navigated to "http://localhost:3000/login?"
============================================================
```

# Page snapshot

```yaml
- generic [active] [ref=e1]:
  - link "Aller au contenu" [ref=e2] [cursor=pointer]:
    - /url: "#main-content"
  - region "Consentement cookies" [ref=e3]:
    - generic [ref=e4]:
      - generic [ref=e5]:
        - generic [ref=e7]: 
        - generic [ref=e8]:
          - heading "We use cookies" [level=3] [ref=e9]
          - paragraph [ref=e10]: We use cookies to improve your experience, analyze traffic and personalize content. By clicking "Accept all", you consent to the use of all cookies.
      - generic [ref=e11]:
        - button " Customize" [ref=e12] [cursor=pointer]:
          - generic [ref=e13]: 
          - generic [ref=e14]: Customize
        - button "Decline" [ref=e15] [cursor=pointer]:
          - generic [ref=e16]: Decline
        - button " Accept all" [ref=e17] [cursor=pointer]:
          - generic [ref=e18]: 
          - generic [ref=e19]: Accept all
  - text:            
  - banner [ref=e20]:
    - navigation [ref=e21]:
      - generic [ref=e22]:
        - generic [ref=e23]: 
        - generic [ref=e24]: Vol d'Histoire
      - list [ref=e25]:
        - listitem [ref=e26]:
          - link " Home" [ref=e27] [cursor=pointer]:
            - /url: /
            - generic [ref=e28]: 
            - generic [ref=e29]: Home
        - listitem [ref=e30]:
          - link " Hangar" [ref=e31] [cursor=pointer]:
            - /url: /hangar
            - generic [ref=e32]: 
            - generic [ref=e33]: Hangar
        - listitem [ref=e34]:
          - link " Timeline" [ref=e35] [cursor=pointer]:
            - /url: /timeline
            - generic [ref=e36]: 
            - generic [ref=e37]: Timeline
        - listitem [ref=e38]:
          - link " Favorites" [ref=e39] [cursor=pointer]:
            - /url: /favorites
            - generic [ref=e40]: 
            - generic [ref=e41]: Favorites
        - listitem [ref=e42]:
          - button "Passer en français" [ref=e43] [cursor=pointer]:
            - generic [ref=e44]: 
        - listitem [ref=e45]:
          - generic [ref=e46]:
            - link "" [ref=e47] [cursor=pointer]:
              - /url: /login
              - generic [ref=e48]: 
            - text:   
  - main [ref=e49]:
    - generic [ref=e50]:
      - generic [ref=e64]:
        - generic [ref=e66]: 
        - heading "Vol d'Histoire" [level=2] [ref=e67]
        - paragraph [ref=e68]: Military aviation database
        - generic [ref=e69]:
          - generic [ref=e70]:
            - generic [ref=e71]: "8"
            - text: Aircraft
          - generic [ref=e73]:
            - generic [ref=e74]: "74"
            - text: À nos jours
          - generic [ref=e76]:
            - generic [ref=e77]: "3"
            - text: Nations
        - generic [ref=e80]: Operator access required
      - generic [ref=e87]:
        - generic [ref=e88]:
          - generic [ref=e89]:
            - generic [ref=e90]:
              - generic [ref=e92]: 
              - heading "Identification" [level=1] [ref=e93]
              - paragraph [ref=e94]: Enter your credentials to access the database
            - generic [ref=e95]:
              - generic [ref=e96]:
                - generic [ref=e97]:
                  - generic [ref=e98]: 
                  - generic [ref=e99]: Email address
                - textbox " Email address" [ref=e100]:
                  - /placeholder: votre@email.com
              - generic [ref=e101]:
                - generic [ref=e102]:
                  - generic [ref=e103]: 
                  - generic [ref=e104]: Password
                - generic [ref=e105]:
                  - textbox " Password" [ref=e106]:
                    - /placeholder: ••••••••
                  - button "Afficher le mot de passe" [ref=e107] [cursor=pointer]:
                    - generic [ref=e108]: 
              - generic [ref=e109]:
                - generic [ref=e110] [cursor=pointer]:
                  - checkbox " Remember me"
                  - generic [ref=e112]: 
                  - generic [ref=e113]: Remember me
                - link "Forgot password?" [ref=e114] [cursor=pointer]:
                  - /url: /forgot-password
              - button "Log in " [ref=e115] [cursor=pointer]:
                - generic [ref=e116]: Log in
                - generic [ref=e117]: 
            - generic [ref=e118]:
              - paragraph [ref=e119]: Don't have an account?
              - button "Create an account " [ref=e120] [cursor=pointer]:
                - generic [ref=e121]: Create an account
                - generic [ref=e122]: 
          - text:        
        - generic [ref=e123]:
          - generic [ref=e124]:
            - generic [ref=e125]: 
            - generic [ref=e126]: Secure connection
          - generic [ref=e127]:
            - generic [ref=e128]: 
            - generic [ref=e129]: Encryption
          - generic [ref=e130]:
            - generic [ref=e131]: 
            - generic [ref=e132]: GDPR
  - contentinfo [ref=e133]:
    - generic [ref=e134]:
      - generic [ref=e135]:
        - generic [ref=e136]:
          - generic [ref=e137]:
            - generic [ref=e138]: 
            - generic [ref=e139]: Vol d'Histoire
          - paragraph [ref=e140]: Explore the history of military aviation through our comprehensive collection of fighter aircraft.
          - generic [ref=e141]:
            - link "Facebook" [ref=e142] [cursor=pointer]:
              - /url: "#"
              - generic [ref=e143]: 
            - link "Twitter" [ref=e144] [cursor=pointer]:
              - /url: "#"
              - generic [ref=e145]: 
            - link "Instagram" [ref=e146] [cursor=pointer]:
              - /url: "#"
              - generic [ref=e147]: 
            - link "YouTube" [ref=e148] [cursor=pointer]:
              - /url: "#"
              - generic [ref=e149]: 
        - generic [ref=e150]:
          - heading "Navigation" [level=3] [ref=e151]
          - list [ref=e152]:
            - listitem [ref=e153]:
              - link "Home" [ref=e154] [cursor=pointer]:
                - /url: /
            - listitem [ref=e155]:
              - link "Hangar" [ref=e156] [cursor=pointer]:
                - /url: /hangar
            - listitem [ref=e157]:
              - link "Timeline" [ref=e158] [cursor=pointer]:
                - /url: /timeline
            - listitem [ref=e159]:
              - link "Favorites" [ref=e160] [cursor=pointer]:
                - /url: /favorites
            - listitem [ref=e161]:
              - link "Log in" [ref=e162] [cursor=pointer]:
                - /url: /login
        - generic [ref=e163]:
          - heading "Resources" [level=3] [ref=e164]
          - list [ref=e165]:
            - listitem [ref=e166]:
              - link "About (coming soon)" [ref=e167] [cursor=pointer]:
                - /url: "#"
            - listitem [ref=e168]:
              - link "Contact" [ref=e169] [cursor=pointer]:
                - /url: /contact
            - listitem [ref=e170]:
              - link "FAQ (coming soon)" [ref=e171] [cursor=pointer]:
                - /url: "#"
            - listitem [ref=e172]:
              - link "Support (coming soon)" [ref=e173] [cursor=pointer]:
                - /url: "#"
        - generic [ref=e174]:
          - heading "Legal" [level=3] [ref=e175]
          - list [ref=e176]:
            - listitem [ref=e177]:
              - link "Legal notices" [ref=e178] [cursor=pointer]:
                - /url: /mentions-legales
            - listitem [ref=e179]:
              - link "Privacy policy" [ref=e180] [cursor=pointer]:
                - /url: /politique-confidentialite
            - listitem [ref=e181]:
              - link "Terms of service" [ref=e182] [cursor=pointer]:
                - /url: /cgu
            - listitem [ref=e183]:
              - link "Cookies" [ref=e184] [cursor=pointer]:
                - /url: "#"
      - generic [ref=e185]:
        - paragraph [ref=e186]: © 2025 Vol d'Histoire. All rights reserved.
        - paragraph [ref=e187]: Made with <i class="fas fa-heart"></i> for aviation enthusiasts
```

# Test source

```ts
  1  | // e2e/helpers/auth.js
  2  | // Helper réutilisable pour se connecter via l'API avant les tests E2E
  3  | 
  4  | /**
  5  |  * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
  6  |  * @param {import('@playwright/test').Page} page
  7  |  * @param {string} email
  8  |  * @param {string} password
  9  |  */
  10 | async function loginViaApi(page, email, password) {
  11 |   // Login via le FORMULAIRE réel.
  12 |   //
  13 |   // RACE CRITIQUE : login.js fait `await auth.init()` au DOMContentLoaded
  14 |   // (qui appelle /api/refresh). Le handler submit est bindé APRÈS cette
  15 |   // attente. Si on clique submit avant que init() ne se termine, le handler
  16 |   // n'est pas encore bindé → le formulaire submit nativement en GET vers
  17 |   // /login? et le test échoue. SOLUTION : waitForLoadState('networkidle')
  18 |   // après goto pour garantir que auth.init() + setupFormSwitching ont fini.
  19 |   await page.goto('/login');
  20 |   await page.waitForLoadState('networkidle');
  21 |   // Sécurité supplémentaire : attendre que le handler soit effectivement
  22 |   // attaché en vérifiant que login.js a fini son init (le bouton existe).
  23 |   await page.waitForSelector('#login-form button[type="submit"]', { state: 'visible' });
  24 | 
  25 |   await page.fill('#login-email', email);
  26 |   await page.fill('#login-password', password);
  27 |   await Promise.all([
> 28 |     page.waitForURL((url) => !url.pathname.includes('login'), { timeout: 10000 }),
     |          ^ TimeoutError: page.waitForURL: Timeout 10000ms exceeded.
  29 |     page.click('#login-form button[type="submit"]'),
  30 |   ]);
  31 |   await page.waitForLoadState('networkidle');
  32 | }
  33 | 
  34 | module.exports = { loginViaApi };
  35 | 
```