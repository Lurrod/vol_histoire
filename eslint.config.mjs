import js from '@eslint/js';
import noUnsanitized from 'eslint-plugin-no-unsanitized';

// Règles communes au code applicatif (backend, frontend, scripts, e2e).
// Tout est bloquant : `npm run lint` passe --max-warnings=0 (ARCH-006).
const BASE_RULES = {
  'no-unused-vars': ['error', { argsIgnorePattern: '^_|^err|^e$', varsIgnorePattern: '^_', caughtErrorsIgnorePattern: '^_|^err|^e$' }],
  'no-console': 'off',
  'no-undef': 'error',
  'no-constant-condition': 'error',
  'no-debugger': 'error',
  'no-duplicate-case': 'error',
  'no-empty': ['error', { allowEmptyCatch: true }],
  'no-redeclare': 'error',
  'eqeqeq': ['error', 'smart'],
  'no-eval': 'error',
  'no-implied-eval': 'error',
  'no-new-func': 'error',
};

// Garde-fous de taille : un fichier source au-delà de 800 lignes ou une
// fonction trop ramifiée se découpe. Les dépassements existants relus pendant
// l'audit sont figés dans eslint-suppressions.json (à résorber, pas à étendre).
const SIZE_RULES = {
  'max-lines': ['error', { max: 800, skipBlankLines: true, skipComments: true }],
  'complexity': ['error', 20],
  'max-depth': ['error', 5],
};

// Insertions HTML : toute valeur interpolée doit passer par une fonction
// d'échappement connue. Les insertions relues pendant l'audit (gabarits
// statiques, générateurs qui échappent eux-mêmes) sont figées dans
// eslint-suppressions.json ; une nouvelle insertion non échappée échoue.
const UNSANITIZED_ESCAPE = {
  methods: [
    'escapeHtml', 'window.escapeHtml', 'esc', 'encodeURIComponent', 'Number',
    'Math.round', 'Math.max', 'fmtNumber', 'VH.shared.buildDetailsPath', 'VH.details.data.slugify',
  ],
};

export default [
  {
    ignores: [
      'frontend/js/dist/**',
      'frontend/js/vendor/**',
      'frontend/css/*.min.css',
      'node_modules/**',
      'backend/node_modules/**',
      'e2e/node_modules/**',
      '**/coverage/**',
      'e2e/playwright-report/**',
      'e2e/test-results/**',
    ],
  },

  // Backend — Node.js CommonJS
  {
    ...js.configs.recommended,
    files: ['backend/**/*.js', 'scripts/**/*.js', 'e2e/**/*.js'],
    languageOptions: {
      // Node 24 : syntaxe la plus récente.
      ecmaVersion: 'latest',
      sourceType: 'commonjs',
      globals: {
        require: 'readonly', module: 'readonly', exports: 'readonly',
        __dirname: 'readonly', __filename: 'readonly',
        process: 'readonly', console: 'readonly', Buffer: 'readonly',
        setTimeout: 'readonly', clearTimeout: 'readonly',
        setInterval: 'readonly', clearInterval: 'readonly',
        URL: 'readonly', URLSearchParams: 'readonly', fetch: 'readonly',
        AbortSignal: 'readonly',
      },
    },
    rules: { ...BASE_RULES, ...SIZE_RULES },
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
        showToast: 'writable', queueToast: 'writable', animateNumber: 'writable',
        setupPasswordToggle: 'writable', takeUrlParams: 'writable', isValidEmail: 'writable',
        calculatePasswordStrength: 'writable', isValidPassword: 'writable',
        PASSWORD_MIN_LENGTH: 'readonly', PASSWORD_MAX_LENGTH: 'readonly',
        setFieldError: 'writable', clearFieldError: 'writable',
        trapFocus: 'writable',
        VH: 'writable', APP_VERSION: 'readonly', APP_BUILD: 'readonly',
        SENTRY_DSN: 'readonly', module: 'readonly',
      },
    },
    plugins: { 'no-unsanitized': noUnsanitized },
    rules: {
      ...BASE_RULES,
      ...SIZE_RULES,
      'no-unsanitized/property': ['error', { escape: UNSANITIZED_ESCAPE }],
      'no-unsanitized/method': ['error', { escape: UNSANITIZED_ESCAPE }],
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

  // E2E — les fonctions passées à page.evaluate / addInitScript s'exécutent
  // dans la page : globals du navigateur et du site.
  {
    files: ['e2e/**/*.js'],
    languageOptions: {
      globals: {
        window: 'readonly', document: 'readonly', localStorage: 'readonly',
        sessionStorage: 'readonly', navigator: 'readonly', auth: 'readonly',
      },
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
      'no-unused-vars': BASE_RULES['no-unused-vars'],
      'no-console': 'off',
      'no-undef': 'error',
      'no-empty': BASE_RULES['no-empty'],
      // Une suite de tests peut être longue et ramifiée : pas de garde de taille.
      'max-lines': 'off',
      'complexity': 'off',
      'max-depth': 'off',
    },
  },
];
