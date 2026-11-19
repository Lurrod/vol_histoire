"""Génère toute la famille de logos de Vol d'Histoire (frontend/assets/logo/).

    python scripts/build-logos.py

Le signe « Livre-delta » : un livre ouvert vu de dessus dont les deux pages
forment les ailes d'un avion en delta, le dos du livre faisant le fuselage.
L'encyclopédie et l'aviation en un seul dessin (il évoque aussi un avion en
papier). Deux tons, page éclairée à gauche, page dans l'ombre à droite ;
version épurée, sans lignes gravées (ribs() reste disponible). Logo
horizontal sur une ligne.

Le lettrage « VOL D'HISTOIRE » est vectorisé depuis Barlow Condensed (les
polices du site) : un SVG chargé en <img> ne peut pas utiliser les polices de
la page, un <text> retombait sur une police système.

Une seule définition, déclinée en couleurs et en formats ; les noms de
fichiers sont ceux déjà référencés par le site (en-tête, favicons, icônes
PWA, illustration de repli). Ensuite, pour les PNG :
    node scripts/build-favicons.js && node scripts/build-pwa-icons.js
"""
from pathlib import Path

from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

RACINE = Path(__file__).resolve().parent.parent
LOGO = RACINE / 'frontend' / 'assets' / 'logo'
FONTS = RACINE / 'frontend' / 'fonts'

# Palette de la charte (tokens.css)
GOLD = '#C8A96E'
GOLD_LIGHT = '#DCC293'   # page éclairée
GOLD_SHADE = '#A98B54'   # page dans l'ombre
NIGHT = '#0B0B0C'
PAPER = '#F0EDE8'
PAPER_SHADE = '#D6D0C5'
DARK_GOLD = '#9C8253'    # or assombri, lisible sur fond clair
DARK_GOLD_SHADE = '#7E683F'


def _fmt(v: float) -> str:
    s = f'{v:.2f}'.rstrip('0').rstrip('.')
    return s if s not in ('-0', '') else '0'


# ── Le signe ───────────────────────────────────────────────────────────────
# Carré de 128, nez (haut du dos) en haut. Chaque page est un triangle : bord
# d'attaque droit du nez à la pointe, tranche basse incurvée (la page qui se
# soulève vers le dos), bord intérieur le long du dos. La fente du dos (5
# unités) est le fuselage, en négatif.
SPINE = 2.5          # demi-largeur de la fente du dos
NOSE_Y, TAIL_Y = 16, 104
TIP_X, TIP_Y = 6, 100  # pointe d'aile (côté droit : 128 - TIP_X)
CURL = (36, 91)      # point de contrôle de la tranche basse (côté gauche)


def _lead_x(y: float) -> float:
    """Abscisse (côté gauche) du bord d'attaque à la hauteur y."""
    return 64 - SPINE - (y - NOSE_Y) * (64 - SPINE - TIP_X) / (TIP_Y - NOSE_Y)


def page(side: int) -> str:
    x = lambda v: _fmt(64 + side * (64 - v))  # noqa: E731  (v : abscisse côté gauche)
    return (f'M{x(64 - SPINE)} {NOSE_Y} L{x(TIP_X)} {TIP_Y} '
            f'Q{x(CURL[0])} {CURL[1]} {x(64 - SPINE)} {TAIL_Y} Z')


def ribs(side: int) -> str:
    """Trois lignes de texte par page : elles épousent la courbure de la
    tranche, partent à égale distance du dos et s'arrêtent à égale distance du
    bord d'attaque."""
    out = []
    for ys in (60, 74, 88):
        x0 = 64 - SPINE - 4.5
        ye = ys - 1
        xe = _lead_x(ye) + 7
        cx, cy = x0 - (x0 - xe) * .55, ys - 3.2
        f = lambda v: _fmt(64 + side * (64 - v))  # noqa: E731
        out.append(f'M{f(x0)} {_fmt(ys)}Q{f(cx)} {_fmt(cy)} {f(xe)} {_fmt(ye)}')
    return ''.join(out)


def sign(light: str, shade: str, rib: str | None, rib_width: float = 1.2) -> str:
    parts = [f'<path d="{page(-1)}" fill="{light}"/>', f'<path d="{page(1)}" fill="{shade}"/>']
    if rib:
        parts.append(f'<path d="{ribs(-1)}{ribs(1)}" fill="none" stroke="{rib}" stroke-width="{_fmt(rib_width)}" '
                     f'stroke-linecap="round" opacity=".42"/>')
    return ''.join(parts)


# ── Lettrage vectorisé ─────────────────────────────────────────────────────
_fonts: dict[int, TTFont] = {}


def font(weight: int) -> TTFont:
    if weight not in _fonts:
        _fonts[weight] = TTFont(str(FONTS / f'BarlowCondensed-{weight}.woff2'))
    return _fonts[weight]


_kern_cache: dict[int, dict[tuple[str, str], int]] = {}


def kerning(weight: int) -> dict[tuple[str, str], int]:
    """Paires de crénage de la police (GPOS, PairPos formats 1 et 2)."""
    if weight in _kern_cache:
        return _kern_cache[weight]
    pairs: dict[tuple[str, str], int] = {}
    f = font(weight)
    if 'GPOS' in f:
        for lookup in f['GPOS'].table.LookupList.Lookup:
            for st in lookup.SubTable:
                if getattr(st, 'ExtSubTable', None) is not None:
                    st = st.ExtSubTable
                if type(st).__name__ != 'PairPos':
                    continue
                firsts = st.Coverage.glyphs
                if st.Format == 1:
                    for g1, ps in zip(firsts, st.PairSet):
                        for rec in ps.PairValueRecord:
                            v = getattr(rec.Value1, 'XAdvance', 0) or 0
                            if v:
                                pairs.setdefault((g1, rec.SecondGlyph), v)
                elif st.Format == 2:
                    c1 = st.ClassDef1.classDefs
                    c2 = st.ClassDef2.classDefs
                    for g1 in firsts:
                        row = st.Class1Record[c1.get(g1, 0)].Class2Record
                        for g2, k2 in c2.items():
                            v = getattr(row[k2].Value1, 'XAdvance', 0) or 0
                            if v:
                                pairs.setdefault((g1, g2), v)
    _kern_cache[weight] = pairs
    return pairs


def text_path(text: str, weight: int, size: float, x: float, baseline: float,
              tracking: float = 0.0) -> tuple[str, float]:
    """Contours SVG d'un texte (taille en unités du viewBox), et sa largeur.
    Crénage de la police appliqué ; tracking : espacement ajouté, en em."""
    f = font(weight)
    scale = size / f['head'].unitsPerEm
    cmap, gs, hmtx = f.getBestCmap(), f.getGlyphSet(), f['hmtx']
    kern = kerning(weight)
    pen = SVGPathPen(gs, ntos=_fmt)
    cursor = x
    names = []
    for ch in text:
        name = cmap.get(ord(ch))
        if name is None:
            raise SystemExit(f'glyphe absent de Barlow Condensed {weight} : {ch!r}')
        names.append(name)
    for i, name in enumerate(names):
        gs[name].draw(TransformPen(pen, (scale, 0, 0, -scale, cursor, baseline)))
        cursor += hmtx[name][0] * scale
        if i < len(names) - 1:
            cursor += kern.get((name, names[i + 1]), 0) * scale + tracking * size
    return pen.getCommands(), cursor - x


def cap(size: float) -> float:
    """Hauteur des capitales (Barlow Condensed : 0,7 em)."""
    return size * font(400)['OS/2'].sCapHeight / font(400)['head'].unitsPerEm


def words(text: str, weight: int, size: float, x: float, baseline: float, tracking: float,
          fill: str, anchor: str = 'start', opacity: float = 1) -> tuple[str, float]:
    _, w = text_path(text, weight, size, 0, 0, tracking)
    x0 = x - w / 2 if anchor == 'middle' else x
    p, _ = text_path(text, weight, size, x0, baseline, tracking)
    op = '' if opacity == 1 else f' opacity="{_fmt(opacity)}"'
    return f'<path d="{p}" fill="{fill}"{op}/>', w


HIST = 'D’HISTOIRE'
TAG = 'AVIATION MILITAIRE · DEPUIS 1945'


# ── Déclinaisons ───────────────────────────────────────────────────────────
# nom : (page éclairée, page ombrée, lignes gravées, « VOL », « D'HISTOIRE »)
# Signe épuré (choix du 2026-11-19, variante B du canevas) : deux pages
# pleines, sans lignes gravées ; le troisième champ (gravure) reste à None.
VARIANTS = {
    'gold':  (GOLD_LIGHT, GOLD_SHADE, None, PAPER, GOLD),
    'dark':  (DARK_GOLD, DARK_GOLD_SHADE, None, NIGHT, DARK_GOLD),
    'paper': (PAPER, PAPER_SHADE, None, PAPER, PAPER),
}
MONO = {
    'gold': (GOLD, GOLD, None, GOLD, GOLD),
    'dark': (NIGHT, NIGHT, None, NIGHT, NIGHT),
}
LABEL = 'Vol d&#39;Histoire'


def svg(view: str, body: str, label: str = LABEL) -> str:
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{view}" role="img" aria-label="{label}">\n'
            f'  {body}\n</svg>\n')


def write(name: str, content: str) -> None:
    (LOGO / name).write_text(content, encoding='utf-8', newline='\n')
    print(f'ok {name:36} {len(content):6} o')


def mark(v) -> str:
    light, shade, rib, *_ = v
    return svg('0 0 128 128', sign(light, shade, rib))


def mark_flat(v) -> str:
    # Petites tailles : un seul ton, sans lignes gravées.
    light, *_ = v
    return svg('0 0 64 64', f'<g transform="scale(.5)">{sign(light, light, None)}</g>')


def lockup_horizontal(v) -> str:
    """Logo sur une ligne : signe, puis « VOL » (graisse 700) et « D'HISTOIRE »
    (graisse 400) sur la même ligne de base. Le signe mesure 1,6 hauteur de
    capitale et se centre sur elle ; le texte commence à une demi-capitale du
    signe (choix du 2026-11-19 : plus lisible à la hauteur de l'en-tête)."""
    light, shade, rib, vol, hist = v
    s = 56
    c = cap(s)
    h = c * 1.6
    pad = 16
    top = pad
    base = top + h - (h - c) / 2
    k = h / (TAIL_Y - NOSE_Y)
    gx = pad - TIP_X * k
    tx = pad + (128 - 2 * TIP_X) * k + c * .55
    p1, w1 = words('VOL', 700, s, tx, base, 0.04, vol)
    p2, w2 = words(HIST, 400, s, tx + w1 + s * .28, base, 0.08, hist)
    width = int(tx + w1 + s * .28 + w2 + pad)
    height = int(top + h + pad)
    g = f'<g transform="translate({_fmt(gx)} {_fmt(top - NOSE_Y * k)}) scale({_fmt(k)})">{sign(light, shade, rib)}</g>'
    return svg(f'0 0 {width} {height}', f'{g}\n  {p1}\n  {p2}')


def lockup_stacked(v) -> str:
    """Signe au-dessus, puis « VOL », « D'HISTOIRE » et la signature, centrés ;
    le signe est aussi large que « D'HISTOIRE »."""
    light, shade, rib, vol, hist = v
    s1, s2 = 64, 36
    _, w2 = text_path(HIST, 400, s2, 0, 0, 0.3)
    k = w2 / (128 - 2 * TIP_X)
    top = 28
    sign_h = (TAIL_Y - NOSE_Y) * k
    cx = 180
    g = (f'<g transform="translate({_fmt(cx - 64 * k)} {_fmt(top - NOSE_Y * k)}) scale({_fmt(k)})">'
         f'{sign(light, shade, rib)}</g>')
    base1 = top + sign_h + 30 + cap(s1)
    base2 = base1 + s2 * .6 + cap(s2)
    p1, _ = words('VOL', 700, s1, cx, base1, 0.04, vol, anchor='middle')
    p2, _ = words(HIST, 400, s2, cx, base2, 0.3, hist, anchor='middle')
    tag, _ = words(TAG, 500, 11.5, cx, base2 + 30, 0.3, hist, anchor='middle', opacity=.7)
    return svg(f'0 0 360 {int(base2 + 58)}', f'{g}\n  {p1}\n  {p2}\n  {tag}')


def emblem(v) -> str:
    light, shade, rib, *_ = v
    frame = (f'<rect x="1.5" y="1.5" width="125" height="125" rx="12" fill="none" stroke="{GOLD}" stroke-width="1" opacity=".55"/>\n'
             f'  <rect x="7" y="7" width="114" height="114" rx="8" fill="none" stroke="{GOLD}" stroke-width=".5" opacity=".3"/>')
    return svg('0 0 128 128', f'{frame}\n  <g transform="translate(15 13) scale(.77)">{sign(light, shade, rib)}</g>',
               LABEL + ' — emblem')


def monogram(v) -> str:
    light, shade, rib, vol, hist = v
    frame = f'<rect x="1.5" y="1.5" width="125" height="125" rx="12" fill="none" stroke="{GOLD}" stroke-width="1" opacity=".5"/>'
    _, wv = text_path('V', 700, 66, 0, 0)
    _, wh = text_path('H', 400, 66, 0, 0)
    x0 = 64 - (wv + 2 + wh) / 2
    pv, _ = text_path('V', 700, 66, x0, 78)
    ph, _ = text_path('H', 400, 66, x0 + wv + 2, 78)
    tail = f'<g transform="translate(52 88) scale(.19)">{sign(light, shade, None)}</g>'
    return svg('0 0 128 128', f'{frame}\n  <path d="{pv}" fill="{vol}"/>\n  <path d="{ph}" fill="{hist}"/>\n  {tail}', 'VH')


def favicon(size: int) -> str:
    """Pastille anthracite, signe centré ; deux tons et lignes dès 64 px."""
    if size == 16:
        return svg('0 0 16 16', f'<rect width="16" height="16" rx="3" fill="{NIGHT}"/>\n'
                                f'  <g transform="translate(.6 .1) scale(.115)">{sign(GOLD, GOLD, None)}</g>')
    return svg('0 0 64 64', f'<rect width="64" height="64" rx="12" fill="{NIGHT}"/>\n'
                            f'  <g transform="translate(2.4 1.8) scale(.46)">{sign(GOLD_LIGHT, GOLD_SHADE, None)}</g>')


def placeholder(label: str, lang: str) -> str:
    _, w = text_path(label, 500, 18, 0, 0, 0.18)
    p, _ = text_path(label, 500, 18, 400 - w / 2, 350, 0.18)
    body = (f'<rect width="800" height="500" fill="#0D0D0D"/>\n'
            f'  <g transform="translate(320 120) scale(1.25)" opacity=".35">{sign(GOLD, GOLD, None)}</g>\n'
            f'  <path d="{p}" fill="{GOLD}" opacity=".55"/>')
    aria = 'Image indisponible' if lang == 'fr' else 'Image unavailable'
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" preserveAspectRatio="xMidYMid slice" '
            f'role="img" aria-label="{aria}">\n  {body}\n</svg>\n')


def main() -> None:
    for name, v in VARIANTS.items():
        write(f'vh-mark-primary-{name}.svg', mark(v))
        write(f'vh-icon-only-{name}.svg', mark(v).replace(f'aria-label="{LABEL}"', f'aria-label="{LABEL} — icon only"'))
        write(f'vh-mark-flat-{name}.svg', mark_flat(v))
        write(f'vh-lockup-horizontal-{name}.svg', lockup_horizontal(v))
        write(f'vh-lockup-stacked-{name}.svg', lockup_stacked(v))
    for name, v in MONO.items():
        write(f'vh-lockup-horizontal-mono-{name}.svg', lockup_horizontal(v))
    write('vh-emblem-gold.svg', emblem(VARIANTS['gold']))
    write('vh-monogram-gold.svg', monogram(VARIANTS['gold']))
    write('favicon.svg', favicon(64))
    write('favicon-16.svg', favicon(16))
    write('placeholder-airplane-fr.svg', placeholder('IMAGE INDISPONIBLE', 'fr'))
    write('placeholder-airplane-en.svg', placeholder('IMAGE UNAVAILABLE', 'en'))


if __name__ == '__main__':
    main()
