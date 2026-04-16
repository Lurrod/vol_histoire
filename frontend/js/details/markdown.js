/* Parser Markdown minimaliste (safe via DOMPurify) pour les descriptions
 * enrichies d'avions (strate 5).
 *
 * Gère :
 *   - ## Titres   → <h3 class="md-section">
 *   - ### Titres  → <h4 class="md-subsection">
 *   - **gras**    → <strong>
 *   - *italique*  → <em>
 *   - Paragraphes (double saut de ligne)
 *   - Listes - item → <ul><li>
 *   - Liens [texte](url) → <a href rel="noopener">
 *
 * Sortie systématiquement re-passée par DOMPurify (safeSetHTML).
 */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  function escapeHtmlLocal(str) {
    return String(str).replace(/[&<>"']/g, c => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
    }[c]));
  }

  function parseInline(text) {
    // Échappement d'abord, puis on ré-active les patterns reconnus via placeholders
    let s = escapeHtmlLocal(text);
    // Liens [texte](url) — n'accepte que http/https, bloque javascript:
    s = s.replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g,
      (_, label, url) => `<a href="${escapeHtmlLocal(url)}" target="_blank" rel="noopener noreferrer">${label}</a>`);
    // **gras**
    s = s.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
    // *italique* (non greedy, évite conflits avec **)
    s = s.replace(/(^|[\s(])\*([^*\n]+)\*(?=[\s).,;:!?]|$)/g, '$1<em>$2</em>');
    return s;
  }

  function parse(markdown) {
    if (!markdown || typeof markdown !== 'string') return '';
    const lines = markdown.replace(/\r\n/g, '\n').split('\n');
    const out = [];
    let paragraph = [];
    let listBuffer = [];

    function flushParagraph() {
      if (paragraph.length > 0) {
        out.push(`<p>${parseInline(paragraph.join(' '))}</p>`);
        paragraph = [];
      }
    }
    function flushList() {
      if (listBuffer.length > 0) {
        out.push(`<ul>${listBuffer.map(item => `<li>${parseInline(item)}</li>`).join('')}</ul>`);
        listBuffer = [];
      }
    }

    for (const rawLine of lines) {
      const line = rawLine.trimEnd();

      // Titre niveau 2 (##)
      if (/^##\s+/.test(line)) {
        flushParagraph(); flushList();
        out.push(`<h3 class="md-section">${parseInline(line.replace(/^##\s+/, ''))}</h3>`);
        continue;
      }
      // Titre niveau 3 (###)
      if (/^###\s+/.test(line)) {
        flushParagraph(); flushList();
        out.push(`<h4 class="md-subsection">${parseInline(line.replace(/^###\s+/, ''))}</h4>`);
        continue;
      }
      // Liste - item
      if (/^\s*-\s+/.test(line)) {
        flushParagraph();
        listBuffer.push(line.replace(/^\s*-\s+/, ''));
        continue;
      }
      // Ligne vide → fermer paragraphe/liste courante
      if (line.trim() === '') {
        flushParagraph(); flushList();
        continue;
      }
      // Texte ordinaire → agréger en paragraphe
      flushList();
      paragraph.push(line);
    }
    flushParagraph(); flushList();
    return out.join('\n');
  }

  VH.details.markdown = { parse };
})();
