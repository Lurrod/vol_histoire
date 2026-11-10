/* Accueil — point d'entrée des widgets et effets du hero.
 * Les modules VH.home.* (js/home/) sont concaténés avant ce fichier dans
 * home.min.js (scripts/build-js.js). En-tête, menu, déconnexion, Échap et
 * mise à jour de l'interface connectée → nav.js.
 */
document.addEventListener('DOMContentLoaded', async () => {
  await auth.init();

  const home = VH.home;
  home.pageEffects.smoothAnchors();
  home.pageEffects.fadeInImages();
  home.heroStats.observe();

  // Un seul appel API pour les deux widgets du hero, sur le même jeu de données.
  (async () => {
    const { facts, aircraft, ephemeris, day } = await home.heroData.fetchHeroDiscoveries();
    home.heroToday.init(ephemeris, facts, day);
    home.heroQuiz.init(aircraft, day);
  })();

  home.pageEffects.ensureHeroAsideOrder();
  home.pageEffects.revealBody();
});
