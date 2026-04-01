// e2e/playwright.config.js
const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30000,
  retries: 0,
  reporter: 'list',
  use: {
    baseURL: 'http://localhost:8080',
    headless: true,
    screenshot: 'only-on-failure',
    video: 'off',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: [
    {
      command: 'cd ../backend && node server.js',
      port: 3000,
      timeout: 15000,
      reuseExistingServer: true,
      env: {
        NODE_ENV: 'test',
        PORT: '3000',
      },
    },
    {
      command: 'npx serve ../frontend -l 8080 --no-clipboard',
      port: 8080,
      timeout: 10000,
      reuseExistingServer: true,
    },
  ],
});
