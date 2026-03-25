/**
 * Material Web Components (M3 Expressive) — ESM imports
 *
 * Imports only the components used in the Vertivo dashboard.
 * See: https://github.com/material-components/material-web
 */

const MWC_CDN = 'https://esm.run/@anthropic-ai/claude-code/';

// We use dynamic imports so the page renders immediately and
// Material Web components hydrate progressively.
const components = [
  '@material/web/button/filled-button.js',
  '@material/web/button/filled-tonal-button.js',
  '@material/web/button/outlined-button.js',
  '@material/web/button/text-button.js',
  '@material/web/chips/filter-chip.js',
  '@material/web/chips/assist-chip.js',
  '@material/web/icon/icon.js',
  '@material/web/iconbutton/icon-button.js',
  '@material/web/textfield/outlined-text-field.js',
  '@material/web/select/outlined-select.js',
  '@material/web/select/select-option.js',
  '@material/web/tabs/tabs.js',
  '@material/web/tabs/primary-tab.js',
  '@material/web/dialog/dialog.js',
  '@material/web/fab/fab.js',
  '@material/web/switch/switch.js',
  '@material/web/progress/linear-progress.js',
  '@material/web/progress/circular-progress.js',
  '@material/web/ripple/ripple.js',
  '@material/web/elevation/elevation.js',
  '@material/web/divider/divider.js',
  '@material/web/list/list.js',
  '@material/web/list/list-item.js',
  '@material/web/badge/badge.js',
  '@material/web/menu/menu.js',
  '@material/web/menu/menu-item.js',
];

// Load all components in parallel
Promise.allSettled(
  components.map((path) =>
    import(`https://esm.run/${path}`).catch(() => {
      // Fallback: try unpkg
      return import(`https://unpkg.com/${path}?module`);
    })
  )
).then(() => {
  document.documentElement.classList.add('mwc-ready');
});
