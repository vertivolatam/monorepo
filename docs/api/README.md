# Vertivo — API Reference (Stoplight Elements)

Visor interactivo de la especificación OpenAPI de Vertivo, renderizado con
[Stoplight Elements](https://docs.stoplight.io/docs/elements/d6a8ba3f3c186-stoplight-elements).

## Ver localmente

Desde la raíz del repo, levanta un servidor estático sobre `docs/api/`:

```bash
# Opción A — Python
python3 -m http.server -d docs/api 8080

# Opción B — Node (sin instalación si ya tienes npx)
npx serve docs/api
```

Luego abre `http://localhost:8080/` (o la URL que imprima `serve`).

## Archivos

- `index.html` — Página de entrada. Carga Stoplight Elements desde unpkg (CDN,
  sin dependencias npm) y apunta a `./openapi.yaml`.
- `openapi.yaml` — **Placeholder** OpenAPI 3.1 con un único endpoint `/health`.
  Reemplazar cuando aterrice la primera superficie REST pública.
- `README.md` — Este archivo.

## Regeneración del spec (futuro)

Vertivo corre sobre **Serverpod** (Dart). Serverpod no genera OpenAPI
nativamente — sus clientes se generan vía SDK Dart dedicado. Rutas realistas
para obtener un spec OpenAPI real cuando haga falta:

1. **Webhooks REST de `latam_payments`** (OnvoPay, Tilopay, Wompi): son los
   primeros endpoints REST puros que el sistema necesita. Documentarlos aquí
   cuando se implementen.
2. **Gateway REST sobre Serverpod:** si partners externos (marketplace de
   insumos, integradores agrónomos) necesitan acceso, añadir un gateway REST
   ligero y generar OpenAPI desde sus handlers.
3. **Bridge MQTT → REST para dashboards:** para exponer lecturas de sensores
   Atlas Scientific a terceros vía HTTP en lugar de solo MQTT/EMQX.
4. **Script de introspección sobre `apps/vertivo_server/lib/src/`:** si se
   quiere documentar el contrato Serverpod actual como OpenAPI informal,
   escribir un generador que recorra las clases `Endpoint` y emita paths.

Mientras tanto, editar `openapi.yaml` a mano conforme se estabilice la
superficie pública.

## Publicación online (opcional, futuro)

`docs/api/` es una página estática autocontenida. El sitio MkDocs principal
vive en `docs/content/` + `docs/mkdocs.yml` y se publica en
`https://vertivolatam.github.io/monorepo`. El visor de Stoplight puede
publicarse como artefacto adicional del mismo sitio GitHub Pages.

Si se quiere enlazar desde MkDocs, agregar una entrada a `docs/mkdocs.yml`
bajo `nav.Backend:` apuntando al visor — fuera del alcance de esta integración
inicial.

## Referencias

- Docs oficiales de Stoplight Elements: <https://docs.stoplight.io/docs/elements/d6a8ba3f3c186-stoplight-elements>
- Repositorio: <https://github.com/stoplightio/elements>
