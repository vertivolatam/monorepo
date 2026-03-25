/**
 * Vertivo Dashboard — D3.js visualizations
 * Gauges, time-series charts, and sparklines for IoT sensor data.
 */

(function () {
  'use strict';

  const COLORS = {
    primary: '#772583',
    primaryLight: '#A85AB3',
    secondary: '#CEDC00',
    accent: '#5E7E29',
    warning: '#FF9E1B',
    error: '#F4493A',
    success: '#5E7E29',
    text: '#e8e6ef',
    textMuted: '#9996a6',
    textDim: '#6b687a',
    bg: '#1a1a22',
    border: '#2e2e3e',
    gridLine: 'rgba(255,255,255,0.06)',
  };

  // --- Gauge Chart ---
  function renderGauge(container) {
    const el = typeof container === 'string' ? document.getElementById(container) : container;
    if (!el || el.querySelector('svg')) return;

    const value = parseFloat(el.dataset.value) || 0;
    const min = parseFloat(el.dataset.min) || 0;
    const max = parseFloat(el.dataset.max) || 100;
    const lower = parseFloat(el.dataset.lowerBound) || min;
    const upper = parseFloat(el.dataset.upperBound) || max;
    const unit = el.dataset.unit || '';
    const label = el.dataset.label || '';

    const w = 160, h = 110;
    const cx = w / 2, cy = h - 10;
    const r = 60;
    const startAngle = -Math.PI;
    const endAngle = 0;

    const svg = d3.select(el).append('svg')
      .attr('viewBox', `0 0 ${w} ${h}`)
      .attr('preserveAspectRatio', 'xMidYMid meet');

    const arc = d3.arc().innerRadius(r - 12).outerRadius(r);
    const scale = d3.scaleLinear().domain([min, max]).range([startAngle, endAngle]).clamp(true);

    // Background arc
    svg.append('path')
      .attr('d', arc({ startAngle, endAngle }))
      .attr('transform', `translate(${cx},${cy})`)
      .attr('fill', COLORS.border);

    // Normal zone
    svg.append('path')
      .attr('d', arc({ startAngle: scale(lower), endAngle: scale(upper) }))
      .attr('transform', `translate(${cx},${cy})`)
      .attr('fill', COLORS.success)
      .attr('opacity', 0.3);

    // Value arc
    const status = (value >= lower && value <= upper) ? COLORS.success
      : (value < lower * 0.8 || value > upper * 1.2) ? COLORS.error
      : COLORS.warning;

    svg.append('path')
      .attr('d', arc({ startAngle, endAngle: scale(value) }))
      .attr('transform', `translate(${cx},${cy})`)
      .attr('fill', status);

    // Needle
    const needleAngle = scale(value);
    const needleLen = r - 18;
    const nx = cx + Math.cos(needleAngle) * needleLen;
    const ny = cy + Math.sin(needleAngle) * needleLen;

    svg.append('line')
      .attr('x1', cx).attr('y1', cy)
      .attr('x2', nx).attr('y2', ny)
      .attr('stroke', COLORS.text)
      .attr('stroke-width', 2)
      .attr('stroke-linecap', 'round');

    svg.append('circle')
      .attr('cx', cx).attr('cy', cy).attr('r', 4)
      .attr('fill', COLORS.text);

    // Value text
    svg.append('text')
      .attr('x', cx).attr('y', cy - 22)
      .attr('text-anchor', 'middle')
      .attr('fill', status)
      .attr('font-size', '18px')
      .attr('font-weight', '700')
      .attr('font-family', 'Inter, sans-serif')
      .text(value.toFixed(value < 10 ? 2 : 1));

    // Unit
    svg.append('text')
      .attr('x', cx).attr('y', cy - 8)
      .attr('text-anchor', 'middle')
      .attr('fill', COLORS.textMuted)
      .attr('font-size', '10px')
      .attr('font-family', 'Inter, sans-serif')
      .text(unit);

    // Label
    svg.append('text')
      .attr('x', cx).attr('y', h)
      .attr('text-anchor', 'middle')
      .attr('fill', COLORS.textDim)
      .attr('font-size', '10px')
      .attr('font-family', 'Inter, sans-serif')
      .text(label);

    // Min/Max labels
    svg.append('text')
      .attr('x', cx - r + 5).attr('y', cy + 12)
      .attr('text-anchor', 'start')
      .attr('fill', COLORS.textDim)
      .attr('font-size', '8px')
      .text(min);

    svg.append('text')
      .attr('x', cx + r - 5).attr('y', cy + 12)
      .attr('text-anchor', 'end')
      .attr('fill', COLORS.textDim)
      .attr('font-size', '8px')
      .text(max);
  }

  // --- Time-Series Chart ---
  function renderTimeSeries(container) {
    const el = typeof container === 'string' ? document.getElementById(container) : container;
    if (!el || el.querySelector('svg')) return;

    const sensorType = el.dataset.sensorType || 'sensor';
    const unit = el.dataset.unit || '';
    const minBound = parseFloat(el.dataset.minBound) || 0;
    const maxBound = parseFloat(el.dataset.maxBound) || 100;

    const margin = { top: 8, right: 12, bottom: 24, left: 44 };
    const w = el.clientWidth || 400;
    const h = 200;
    const innerW = w - margin.left - margin.right;
    const innerH = h - margin.top - margin.bottom;

    // Generate mock data (24h, 5-min intervals)
    const now = new Date();
    const data = [];
    const mean = (minBound + maxBound) / 2;
    const range = maxBound - minBound;
    let val = mean;
    for (let i = 288; i >= 0; i--) {
      const t = new Date(now.getTime() - i * 5 * 60 * 1000);
      // Ornstein-Uhlenbeck style random walk
      val += 0.1 * (mean - val) + (Math.random() - 0.5) * range * 0.08;
      // Add diurnal component
      const hour = t.getHours() + t.getMinutes() / 60;
      const diurnal = Math.sin((hour - 6) * Math.PI / 12) * range * 0.1;
      data.push({ time: t, value: val + diurnal });
    }

    const svg = d3.select(el).append('svg')
      .attr('width', w).attr('height', h);

    const g = svg.append('g')
      .attr('transform', `translate(${margin.left},${margin.top})`);

    const x = d3.scaleTime()
      .domain(d3.extent(data, d => d.time))
      .range([0, innerW]);

    const dataMin = d3.min(data, d => d.value);
    const dataMax = d3.max(data, d => d.value);
    const yMin = Math.min(dataMin, minBound) - range * 0.05;
    const yMax = Math.max(dataMax, maxBound) + range * 0.05;

    const y = d3.scaleLinear()
      .domain([yMin, yMax])
      .range([innerH, 0]);

    // Grid lines
    g.append('g')
      .attr('class', 'grid')
      .call(d3.axisLeft(y).ticks(5).tickSize(-innerW).tickFormat(''))
      .selectAll('line').attr('stroke', COLORS.gridLine);
    g.selectAll('.grid .domain').remove();

    // Bound zone (shaded area for normal range)
    g.append('rect')
      .attr('x', 0)
      .attr('y', y(maxBound))
      .attr('width', innerW)
      .attr('height', Math.max(0, y(minBound) - y(maxBound)))
      .attr('fill', COLORS.success)
      .attr('opacity', 0.08);

    // Bound lines
    [minBound, maxBound].forEach(bound => {
      g.append('line')
        .attr('x1', 0).attr('x2', innerW)
        .attr('y1', y(bound)).attr('y2', y(bound))
        .attr('stroke', COLORS.success)
        .attr('stroke-width', 1)
        .attr('stroke-dasharray', '4,4')
        .attr('opacity', 0.4);
    });

    // Area gradient
    const gradientId = `grad-${sensorType}-${Math.random().toString(36).slice(2, 8)}`;
    const defs = svg.append('defs');
    const gradient = defs.append('linearGradient')
      .attr('id', gradientId)
      .attr('x1', '0').attr('y1', '0')
      .attr('x2', '0').attr('y2', '1');
    gradient.append('stop').attr('offset', '0%').attr('stop-color', COLORS.primaryLight).attr('stop-opacity', 0.3);
    gradient.append('stop').attr('offset', '100%').attr('stop-color', COLORS.primaryLight).attr('stop-opacity', 0.02);

    // Area
    const area = d3.area()
      .x(d => x(d.time))
      .y0(innerH)
      .y1(d => y(d.value))
      .curve(d3.curveMonotoneX);

    g.append('path')
      .datum(data)
      .attr('fill', `url(#${gradientId})`)
      .attr('d', area);

    // Line
    const line = d3.line()
      .x(d => x(d.time))
      .y(d => y(d.value))
      .curve(d3.curveMonotoneX);

    g.append('path')
      .datum(data)
      .attr('fill', 'none')
      .attr('stroke', COLORS.primaryLight)
      .attr('stroke-width', 1.5)
      .attr('d', line);

    // Color out-of-bounds segments red
    const outOfBounds = data.filter(d => d.value < minBound || d.value > maxBound);
    if (outOfBounds.length > 0) {
      const clipped = d3.line()
        .x(d => x(d.time))
        .y(d => y(Math.max(minBound, Math.min(maxBound, d.value)) !== d.value ? d.value : NaN))
        .defined(d => d.value < minBound || d.value > maxBound)
        .curve(d3.curveMonotoneX);

      g.append('path')
        .datum(data)
        .attr('fill', 'none')
        .attr('stroke', COLORS.error)
        .attr('stroke-width', 2)
        .attr('d', clipped);
    }

    // Axes
    g.append('g')
      .attr('transform', `translate(0,${innerH})`)
      .call(d3.axisBottom(x).ticks(6).tickFormat(d3.timeFormat('%H:%M')))
      .selectAll('text').attr('fill', COLORS.textDim).attr('font-size', '10px');

    g.append('g')
      .call(d3.axisLeft(y).ticks(5).tickFormat(d => d.toFixed(d < 10 ? 1 : 0)))
      .selectAll('text').attr('fill', COLORS.textDim).attr('font-size', '10px');

    g.selectAll('.domain').attr('stroke', COLORS.border);
    g.selectAll('.tick line').attr('stroke', COLORS.border);

    // Current value dot
    const last = data[data.length - 1];
    g.append('circle')
      .attr('cx', x(last.time)).attr('cy', y(last.value))
      .attr('r', 4)
      .attr('fill', COLORS.primaryLight)
      .attr('stroke', COLORS.bg)
      .attr('stroke-width', 2);
  }

  // --- Sparkline ---
  function renderSparkline(container) {
    const el = typeof container === 'string' ? document.getElementById(container) : container;
    if (!el || el.querySelector('svg')) return;

    const w = 60, h = 24;
    const data = Array.from({ length: 20 }, () => Math.random());

    const svg = d3.select(el).append('svg')
      .attr('width', w).attr('height', h);

    const x = d3.scaleLinear().domain([0, data.length - 1]).range([0, w]);
    const y = d3.scaleLinear().domain([0, 1]).range([h - 2, 2]);

    const line = d3.line()
      .x((_, i) => x(i))
      .y(d => y(d))
      .curve(d3.curveMonotoneX);

    svg.append('path')
      .datum(data)
      .attr('fill', 'none')
      .attr('stroke', COLORS.primaryLight)
      .attr('stroke-width', 1.5)
      .attr('d', line);
  }

  // --- Initialize ---
  function init() {
    // Gauges
    document.querySelectorAll('.gauge-container').forEach(el => {
      renderGauge(el);
    });

    // Time-series charts
    document.querySelectorAll('.chart-container').forEach(el => {
      renderTimeSeries(el);
    });

    // Sparklines
    document.querySelectorAll('.kpi__sparkline').forEach(el => {
      renderSparkline(el);
    });
  }

  // Run on DOM ready and on navigation (SPA)
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Re-init on Jaspr navigation (MutationObserver)
  const observer = new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      if (mutation.addedNodes.length > 0) {
        requestAnimationFrame(init);
        break;
      }
    }
  });

  const content = document.querySelector('.content');
  if (content) {
    observer.observe(content, { childList: true, subtree: true });
  }

  // Expose for manual re-init
  window.vertivoDashboard = { init, renderGauge, renderTimeSeries, renderSparkline };
})();
