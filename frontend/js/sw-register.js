/* Enregistrement du service worker.
 * Respecte prefers-reduced-data (n'enregistre pas si l'utilisateur demande à
 * économiser la data). Ne bloque jamais le rendu — tout est async dans l'idle.
 */
(function () {
  if (!('serviceWorker' in navigator)) return;
  if (location.protocol !== 'https:' && location.hostname !== 'localhost' && location.hostname !== '127.0.0.1') return;
  // Respecte Save-Data (ex: utilisateurs en mode data-saver Chrome Mobile).
  if (navigator.connection && navigator.connection.saveData) return;

  var register = function () {
    navigator.serviceWorker.register('/sw.js', { scope: '/' }).catch(function () {
      /* silencieux : l'échec du SW ne doit pas casser la page */
    });
  };

  if (document.readyState === 'complete') {
    register();
  } else {
    window.addEventListener('load', register, { once: true });
  }
})();
