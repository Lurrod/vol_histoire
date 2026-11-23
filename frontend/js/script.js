/* Accueil — point d'entrée des widgets et effets du hero.
 * Les modules VH.home.* (js/home/) sont concaténés avant ce fichier dans
 * home.min.js (scripts/build-js.js). En-tête, menu, déconnexion, Échap et
 * mise à jour de l'interface connectée → nav.js.
 */
document.addEventListener('DOMContentLoaded', async () => {
  const home = VH.home;
  // Un seul appel API pour la photo du jour et le quiz, sur le même jeu de
  // données. Lancé AVANT auth.init() : la photo du jour est l'élément LCP de
  // l'accueil, et cette route publique n'a pas besoin de la session.
  const discoveries = home.heroData.fetchHeroDiscoveries();

  await auth.init();

  home.pageEffects.smoothAnchors();
  home.pageEffects.fadeInImages();
  home.heroStats.observe();

  (async () => {
    const { facts, aircraft, ephemeris, day } = await discoveries;
    home.heroToday.init(ephemeris, facts, day, aircraft);
    home.heroQuiz.init(aircraft, day);
  })();
});
