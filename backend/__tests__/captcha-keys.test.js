/**
 * Tests — clés hCaptcha effectives (middleware/hcaptcha.js, captchaKeys).
 * hCaptcha refuse localhost et 127.0.0.1 avec de vraies clés (« Please use a
 * valid host ») : en développement, le captcha est désactivé.
 */
const { captchaKeys } = require('../middleware/hcaptcha');

describe('captchaKeys', () => {
  test('production : les vraies clés, telles quelles', () => {
    expect(captchaKeys({ NODE_ENV: 'production', HCAPTCHA_SECRET: '0xreal', HCAPTCHA_SITEKEY: 'real-site' }))
      .toEqual({ secret: '0xreal', sitekey: 'real-site' });
  });

  test('développement : captcha désactivé (aucun widget, vérification sautée), même avec des clés', () => {
    expect(captchaKeys({ NODE_ENV: 'development', HCAPTCHA_SECRET: '0xreal', HCAPTCHA_SITEKEY: 'real-site' }))
      .toEqual({ secret: '', sitekey: '' });
    expect(captchaKeys({ NODE_ENV: 'dev', HCAPTCHA_SECRET: '0xreal', HCAPTCHA_SITEKEY: 'real-site' }))
      .toEqual({ secret: '', sitekey: '' });
  });

  test('développement : verify() laisse passer sans jeton', async () => {
    const { verify } = require('../middleware/hcaptcha');
    const saved = { ...process.env };
    process.env.NODE_ENV = 'dev';
    process.env.HCAPTCHA_SECRET = '0xreal';
    process.env.HCAPTCHA_SITEKEY = 'real-site';
    await expect(verify(undefined)).resolves.toEqual({ ok: true, skipped: true });
    process.env = saved;
  });

  test('tests automatisés : les clés telles que configurées (les suites simulent siteverify)', () => {
    expect(captchaKeys({ NODE_ENV: 'test', HCAPTCHA_SECRET: '0xs', HCAPTCHA_SITEKEY: 'site' }))
      .toEqual({ secret: '0xs', sitekey: 'site' });
  });

  test('hors production sans clés (CI, E2E) : rien, la vérification reste sautée', () => {
    expect(captchaKeys({ NODE_ENV: 'test' })).toEqual({ secret: '', sitekey: '' });
    expect(captchaKeys({ NODE_ENV: 'dev', HCAPTCHA_SECRET: '', HCAPTCHA_SITEKEY: '' })).toEqual({ secret: '', sitekey: '' });
  });

  test('production sans clés : vides (server.js refuse alors de démarrer)', () => {
    expect(captchaKeys({ NODE_ENV: 'production' })).toEqual({ secret: '', sitekey: '' });
  });
});
