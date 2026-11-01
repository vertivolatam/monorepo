import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Vertivo — Micro-Invernaderos Autónomos Aeropónicos',
  tagline: 'Nebuponía urbana autónoma: robot agrónomo + SaaS + marketplace',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://vertivolatam.github.io',
  baseUrl: '/monorepo/',

  organizationName: 'vertivolatam',
  projectName: 'monorepo',

  onBrokenLinks: 'throw',
  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid', 'docusaurus-theme-openapi-docs'],

  i18n: {
    defaultLocale: 'es',
    locales: ['es'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: './sidebars.ts',
          editUrl:
            'https://github.com/vertivolatam/monorepo/edit/main/docs/content/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  plugins: [
    [
      'docusaurus-plugin-openapi-docs',
      {
        id: 'api',
        docsPluginId: 'classic',
        config: {
          vertivo: {
            specPath: '../api/openapi.yaml',
            outputDir: 'docs/api',
            sidebarOptions: {
              groupPathsBy: 'tag',
            },
          },
        },
      },
    ],
    [
      '@docusaurus/plugin-client-redirects',
      {
        redirects: [
          {from: '/docs/producto/propuesta-de-valor', to: '/producto/propuesta-de-valor'},
          {from: '/docs/producto/segmentos', to: '/producto/segmentos'},
          {from: '/docs/producto/verticales', to: '/producto/verticales'},
          {from: '/docs/producto/roadmap', to: '/producto/roadmap'},
          {from: '/docs/getting-started/installation', to: '/getting-started/installation'},
          {from: '/docs/getting-started/setup', to: '/getting-started/setup'},
          {from: '/docs/backend', to: '/backend'},
          {from: '/docs/backend/api', to: '/backend/api'},
          {from: '/docs/backend/auth', to: '/backend/auth'},
          {from: '/docs/backend/mqtt', to: '/backend/mqtt'},
          {from: '/docs/mobile', to: '/mobile'},
          {from: '/docs/mobile/architecture', to: '/mobile/architecture'},
          {from: '/docs/mobile/design-system', to: '/mobile/design-system'},
          {from: '/docs/iot', to: '/iot'},
          {from: '/docs/iot/sensors', to: '/iot/sensors'},
          {from: '/docs/iot/orchestrator', to: '/iot/orchestrator'},
          {from: '/docs/iot/simulation', to: '/iot/simulation'},
          {from: '/docs/iot/mqtt-topics', to: '/iot/mqtt-topics'},
          {from: '/docs/pagos/latam-payments', to: '/pagos/latam-payments'},
          {from: '/docs/pagos/pasarelas', to: '/pagos/pasarelas'},
          {from: '/docs/architecture/overview', to: '/architecture/overview'},
          {from: '/docs/architecture/technologies', to: '/architecture/technologies'},
          {from: '/docs/architecture/data-flow', to: '/architecture/data-flow'},
          {from: '/docs/deployment/kubernetes', to: '/deployment/kubernetes'},
          {from: '/docs/deployment/emqx', to: '/deployment/emqx'},
          {from: '/docs/deployment/cicd', to: '/deployment/cicd'},
          {from: '/docs/deployment/balena', to: '/deployment/balena'},
          {from: '/docs/development/local-setup', to: '/development/local-setup'},
          {from: '/docs/development/structure', to: '/development/structure'},
          {from: '/docs/development/testing', to: '/development/testing'},
          {from: '/docs/estrategia/srd', to: '/estrategia/srd'},
          {from: '/docs/estrategia/linear', to: '/estrategia/linear'},
        ],
      },
    ],
    [
      '@easyops-cn/docusaurus-search-local',
      {
        hashed: true,
        language: ['es'],
        indexDocs: true,
        indexBlog: false,
      },
    ],
  ],

  themeConfig: {
    image: 'img/isotipo.svg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'Vertivo',
      logo: {
        alt: 'Vertivo',
        src: 'img/isotipo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          type: 'doc',
          docId: 'api/vertivo-api',
          position: 'left',
          label: 'API',
        },
        {
          href: 'https://github.com/vertivolatam/monorepo',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {label: 'Flujo de datos', to: '/architecture/data-flow'},
            {label: 'MQTT Topics', to: '/iot/mqtt-topics'},
          ],
        },
        {
          title: 'Proyecto',
          items: [
            {href: 'https://github.com/vertivolatam/monorepo', label: 'GitHub'},
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Vertivo Horticultura Urbana Vertical S.R.L. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
