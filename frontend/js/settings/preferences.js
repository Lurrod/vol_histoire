/* Paramètres — Préférences (2026-11-20) : langue du site, « Réduire les
 * animations », « Revoir la visite guidée ». Trois réglages propres au
 * navigateur, appliqués aussitôt (pas de barre d'enregistrement).
 *
 *   langue      : i18n.setLang, comme le sélecteur de l'en-tête ;
 *   animations  : VH.motion.setReducedMotion (clé vh-reduce-motion, classe
 *                 html.vh-reduce-motion, garde-fou de shared-utilities.css) ;
 *   visite      : la clé vh-onboarding-done est effacée, puis l'accueil, où
 *                 la visite se lance d'elle-même (onboarding.js). */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.settings = root.VH.settings || {};

  const ONBOARDING_KEY = 'vh-onboarding-done';

  /** Navigation (remplaçable dans les tests : jsdom ne navigue pas). */
  function navigate(url) {
    window.location.href = url;
  }

  function currentLang() {
    return typeof i18n !== 'undefined' && i18n.currentLang === 'en' ? 'en' : 'fr';
  }

  /** Coche la langue courante. */
  function syncLang() {
    document.querySelectorAll('input[name="pref-lang"]').forEach((radio) => {
      radio.checked = radio.value === currentLang();
    });
  }

  function onLangChange(e) {
    const lang = e.target.value;
    if (lang === currentLang() || typeof i18n === 'undefined' || typeof i18n.setLang !== 'function') return;
    i18n.setLang(lang);
  }

  /** Interrupteur et mention « le système réduit déjà » selon l'état courant. */
  function syncMotion() {
    const motion = window.VH.motion;
    const toggle = document.getElementById('pref-reduce-motion');
    if (toggle && motion) toggle.checked = motion.siteReducesMotion();
    const note = document.getElementById('pref-motion-system');
    if (note && motion) note.hidden = !motion.systemPrefersReducedMotion();
  }

  function onMotionChange(e) {
    window.VH.motion?.setReducedMotion(e.target.checked);
    syncMotion();
  }

  /** Efface la marque « visite vue » puis renvoie à l'accueil, où elle démarre. */
  function replayTour() {
    try {
      window.localStorage.removeItem(ONBOARDING_KEY);
    } catch {
      // stockage refusé : la visite ne peut pas être relancée
      showToast(VH.settings.ui.tr('settings.pref_tour_error', 'Impossible de relancer la visite dans ce navigateur.'), 'error');
      return false;
    }
    VH.settings.preferences.navigate('/');
    return true;
  }

  function setup() {
    syncLang();
    syncMotion();
    document.querySelectorAll('input[name="pref-lang"]').forEach((radio) => {
      radio.addEventListener('change', onLangChange);
    });
    document.getElementById('pref-reduce-motion')?.addEventListener('change', onMotionChange);
    document.getElementById('pref-tour-btn')?.addEventListener('click', replayTour);
    window.addEventListener('langChanged', syncLang);
    window.addEventListener('i18nReady', syncLang);
  }

  VH.settings.preferences = { syncLang, syncMotion, replayTour, setup, navigate };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.settings.preferences;
  }
})();
