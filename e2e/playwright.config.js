// e2e/playwright.config.js
const { defineConfig, devices } = require('@playwright/test');

// Backend (port 3000) sert AUSSI le frontend statique via express.static.
// On unifie tout sur la même origine → cookies HttpOnly partagés correctement
// entre /api et les pages HTML.
const BASE_URL = process.env.E2E_BASE_URL || 'http://localhost:3000';

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30000,
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? [['list'], ['html', { open: 'never' }]] : 'list',
  use: {
    baseURL: BASE_URL,
    headless: true,
    screenshot: 'only-on-failure',
    video: process.env.CI ? 'retain-on-failure' : 'off',
    trace: process.env.CI ? 'retain-on-failure' : 'off',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  // Si le backend est déjà démarré (CI : démarré séparément avant playwright),
  // on ne le respawn pas. En local, on le démarre.
  webServer: process.env.E2E_BASE_URL
    ? undefined
    : {
        command: 'cd ../backend && node server.js',
        port: 3000,
        timeout: 15000,
        reuseExistingServer: true,
        env: {
          NODE_ENV: 'test',
          PORT: '3000',
        },
      },
});
