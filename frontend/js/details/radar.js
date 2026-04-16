/* Chart radar : SVG pur, normalisation sur les max connus de la base. */
(function () {
  window.VH = window.VH || {};
  window.VH.details = window.VH.details || {};

  const REF_SPEED = 3529;   // SR-71 Blackbird
  const REF_RANGE = 15000;
  const REF_ARMAMENT = 10;
  const REF_MISSIONS = 8;
  const REF_TECH = 8;

  function render(state, armament, tech, missions) {
    const chartEl = document.getElementById('radar-chart');
    const legendEl = document.getElementById('radar-legend');
    const a = state.aircraftData;
    if (!chartEl || !legendEl || !a) return;

    const axes = [
      { label: i18n.t('details.radar_speed'), icon: 'gauge-high',
        score: Math.min((a.max_speed || 0) / REF_SPEED * 100, 100),
        raw: a.max_speed ? `${Number(a.max_speed).toLocaleString()} km/h` : 'N/A' },
      { label: i18n.t('details.radar_range'), icon: 'route',
        score: Math.min((a.max_range || 0) / REF_RANGE * 100, 100),
        raw: a.max_range ? `${Number(a.max_range).toLocaleString()} km` : 'N/A' },
      { label: i18n.t('details.radar_armament'), icon: 'crosshairs',
        score: Math.min((armament.length || 0) / REF_ARMAMENT * 100, 100),
        raw: `${armament.length} ${i18n.currentLang === 'en' ? (armament.length !== 1 ? 'systems' : 'system') : (armament.length > 1 ? 'systèmes' : 'système')}` },
      { label: i18n.t('details.radar_versatility'), icon: 'bullseye',
        score: Math.min((missions.length || 0) / REF_MISSIONS * 100, 100),
        raw: `${missions.length} ${i18n.currentLang === 'en' ? (missions.length !== 1 ? 'missions' : 'mission') : (missions.length > 1 ? 'missions' : 'mission')}` },
      { label: i18n.t('details.radar_technology'), icon: 'microchip',
        score: Math.min((tech.length || 0) / REF_TECH * 100, 100),
        raw: `${tech.length} tech${tech.length > 1 ? 's' : ''}` },
    ];

    const cx = 150, cy = 150, r = 95;
    const n = axes.length;
    const angles = axes.map((_, i) => -Math.PI / 2 + (i * 2 * Math.PI / n));
    const pt = (angle, val) => [
      +(cx + (val / 100) * r * Math.cos(angle)).toFixed(2),
      +(cy + (val / 100) * r * Math.sin(angle)).toFixed(2),
    ];

    const gridLevels = [20, 40, 60, 80, 100];
    const gridPolygons = gridLevels.map((level, gi) => {
      const pts = angles.map(ang => pt(ang, level).join(',')).join(' ');
      const isOuter = gi === 4;
      const fill = gi % 2 === 0 && !isOuter ? 'rgba(200,169,110,0.02)' : 'none';
      const stroke = isOuter ? 'rgba(200,169,110,0.25)' : 'rgba(255,255,255,0.07)';
      return `<polygon points="${pts}" fill="${fill}" stroke="${stroke}" stroke-width="${isOuter ? 1.5 : 1}" />`;
    }).join('');

    const axisLines = angles.map(ang => {
      const [x2, y2] = pt(ang, 100);
      return `<line x1="${cx}" y1="${cy}" x2="${x2}" y2="${y2}" stroke="rgba(255,255,255,0.12)" stroke-width="1" />`;
    }).join('');

    const dataPolygonPts = angles.map((ang, i) => pt(ang, axes[i].score).join(',')).join(' ');
    const dataDots = angles.map((ang, i) => {
      const [x, y] = pt(ang, axes[i].score);
      return `<circle cx="${x}" cy="${y}" r="4.5" fill="#C8A96E" stroke="#0D0D0D" stroke-width="2" />`;
    }).join('');

    const labelR = 118;
    const textAnchors = ['middle', 'start', 'start', 'end', 'end'];
    const dyOffsets = [-6, 4, 4, 4, 4];
    const axisLabels = angles.map((ang, i) => {
      const lx = +(cx + labelR * Math.cos(ang)).toFixed(2);
      const ly = +(cy + labelR * Math.sin(ang) + dyOffsets[i]).toFixed(2);
      return `<text x="${lx}" y="${ly}" text-anchor="${textAnchors[i]}" dominant-baseline="middle" fill="rgba(255,255,255,0.6)" font-size="9" font-family="DM Sans, sans-serif" font-weight="600" letter-spacing="0.05em">${axes[i].label.toUpperCase()}</text>`;
    }).join('');

    chartEl.innerHTML = `
      <svg viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" class="radar-svg">
        <defs>
          <radialGradient id="radarFill_${state.aircraftId}" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stop-color="rgba(200,169,110,0.3)" />
            <stop offset="100%" stop-color="rgba(200,169,110,0.04)" />
          </radialGradient>
        </defs>
        ${gridPolygons}
        ${axisLines}
        <polygon class="radar-polygon" points="${dataPolygonPts}"
          fill="url(#radarFill_${state.aircraftId})"
          stroke="#C8A96E" stroke-width="2" stroke-linejoin="round" stroke-opacity="0.85" />
        ${dataDots}
        ${axisLabels}
      </svg>
    `;

    legendEl.innerHTML = axes.map(axis => `
      <div class="radar-stat">
        <div class="radar-stat-head">
          <div class="radar-stat-icon"><i class="fas fa-${axis.icon}"></i></div>
          <div class="radar-stat-info">
            <span class="radar-stat-label">${escapeHtml(axis.label)}</span>
            <span class="radar-stat-value">${escapeHtml(axis.raw)}</span>
          </div>
          <span class="radar-stat-pct">${Math.round(axis.score)}%</span>
        </div>
        <div class="radar-bar">
          <div class="radar-bar-fill" data-target="${axis.score.toFixed(1)}"></div>
        </div>
      </div>
    `).join('');

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        legendEl.querySelectorAll('.radar-bar-fill').forEach(bar => {
          bar.style.width = bar.dataset.target + '%';
        });
      });
    });
  }

  VH.details.radar = { render };
})();
