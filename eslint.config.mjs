import js from '@eslint/js';

export default [
  {
    ignores: [
      'frontend/js/dist/**',
      'frontend/js/vendor/**',
      'frontend/css/*.min.css',
      'node_modules/**',
      'backend/node_modules/**',
      'e2e/node_modules/**',
      'coverage/**',
      'backend/test_sitemap.js',
    ],
  },

  // Backend — Node.js CommonJS
  {
    ...js.configs.recommended,
    files: ['backend/**/*.js', 'scripts/**/*.js'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'commonjs',
      globals: {
        require: 'readonly', module: 'readonly', exports: 'readonly',
        __dirname: 'readonly', __filename: 'readonly',
        process: 'readonly', console: 'readonly', Buffer: 'readonly',
        setTimeout: 'readonly', clearTimeout: 'readonly',
        setInterval: 'readonly', clearInterval: 'readonly',
        URL: 'readonly', URLSearchParams: 'readonly', fetch: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': ['warn', { argsIgnorePattern: '^_|^err|^e$', varsIgnorePattern: '^_' }],
      'no-console': 'off',
      'no-undef': 'error',
      'no-constant-condition': 'warn',
      'no-debugger': 'error',
      'no-duplicate-case': 'error',
      'no-empty': ['warn', { allowEmptyCatch: true }],
      'no-redeclare': 'error',
      'eqeqeq': ['warn', 'smart'],
      'no-eval': 'error',
      'no-implied-eval': 'error',
      'no-new-func': 'error',
    },
  },

  // Frontend — Browser globals
  {
    ...js.configs.recommended,
    files: ['frontend/js/**/*.js'],
    ignores: ['frontend/js/dist/**', 'frontend/js/vendor/**'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'script',
      globals: {
        // Browser APIs
        window: 'readonly', document: 'readonly', navigator: 'readonly',
        localStorage: 'readonly', sessionStorage: 'readonly',
        fetch: 'readonly', console: 'readonly',
        setTimeout: 'readonly', clearTimeout: 'readonly',
        setInterval: 'readonly', clearInterval: 'readonly',
        requestIdleCallback: 'readonly', requestAnimationFrame: 'readonly',
        cancelAnimationFrame: 'readonly', performance: 'readonly',
        HTMLElement: 'readonly', Node: 'readonly',
        Event: 'readonly', ErrorEvent: 'readonly', CustomEvent: 'readonly',
        PromiseRejectionEvent: 'readonly', BroadcastChannel: 'readonly',
        MutationObserver: 'readonly', IntersectionObserver: 'readonly',
        ResizeObserver: 'readonly',
        URL: 'readonly', URLSearchParams: 'readonly',
        FormData: 'readonly', AbortController: 'readonly', Image: 'readonly',
        location: 'readonly', history: 'readonly',
        atob: 'readonly', btoa: 'readonly',
        confirm: 'readonly', alert: 'readonly', prompt: 'readonly',
        // Third-party
        DOMPurify: 'readonly', hcaptcha: 'readonly', dataLayer: 'readonly',
        // Project globals (defined in utils.js, auth.js, i18n.js, nav.js)
        auth: 'writable', i18n: 'writable', nav: 'writable',
        escapeHtml: 'writable', safeSetHTML: 'writable',
        showToast: 'writable', animateNumber: 'writable',
        setupPasswordToggle: 'writable', isValidEmail: 'writable',
        calculatePasswordStrength: 'writable',
        setFieldError: 'writable', clearFieldError: 'writable',
        trapFocus: 'writable',
        VH: 'writable', APP_VERSION: 'readonly', APP_BUILD: 'readonly',
        SENTRY_DSN: 'readonly', module: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': ['warn', { argsIgnorePattern: '^_|^err|^e$', varsIgnorePattern: '^_' }],
      'no-console': 'off',
      'no-undef': 'error',
      'no-constant-condition': 'warn',
      'no-debugger': 'error',
      'no-duplicate-case': 'error',
      'no-empty': ['warn', { allowEmptyCatch: true }],
      'no-redeclare': 'error',
      'eqeqeq': ['warn', 'smart'],
      'no-eval': 'error',
      'no-implied-eval': 'error',
      'no-new-func': 'error',
    },
  },

  // Files that DEFINE project globals — allow redeclare
  {
    files: [
      'frontend/js/utils.js',
      'frontend/js/auth.js',
      'frontend/js/i18n.js',
      'frontend/js/nav.js',
    ],
    rules: {
      'no-redeclare': 'off',
    },
  },

  // Tests — Jest globals
  {
    ...js.configs.recommended,
    files: ['**/__tests__/**/*.js', '**/*.test.js', '**/*.spec.js'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'commonjs',
      globals: {
        require: 'readonly', module: 'readonly', exports: 'readonly',
        __dirname: 'readonly', process: 'readonly', console: 'readonly',
        setTimeout: 'readonly', clearTimeout: 'readonly',
        describe: 'readonly', test: 'readonly', it: 'readonly',
        expect: 'readonly', beforeAll: 'readonly', afterAll: 'readonly',
        beforeEach: 'readonly', afterEach: 'readonly', jest: 'readonly',
        document: 'readonly', window: 'readonly', navigator: 'readonly',
        localStorage: 'readonly', sessionStorage: 'readonly', fetch: 'readonly',
        Event: 'readonly', KeyboardEvent: 'readonly',
        MutationObserver: 'readonly', HTMLElement: 'readonly',
        global: 'writable', auth: 'writable', i18n: 'writable', nav: 'writable',
        showToast: 'writable', escapeHtml: 'writable',
      },
    },
    rules: {
      'no-unused-vars': ['warn', { argsIgnorePattern: '^_|^err|^e$', varsIgnorePattern: '^_' }],
      'no-console': 'off',
      'no-undef': 'error',
      'no-empty': ['warn', { allowEmptyCatch: true }],
    },
  },
];
