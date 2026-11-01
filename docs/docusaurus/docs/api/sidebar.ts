import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebar: SidebarsConfig = {
  apisidebar: [
    {
      type: "doc",
      id: "api/vertivo-api",
    },
    {
      type: "category",
      label: "system",
      items: [
        {
          type: "doc",
          id: "api/health-check",
          label: "Healthcheck del servicio",
          className: "api-method get",
        },
      ],
    },
  ],
};

export default sidebar.apisidebar;
