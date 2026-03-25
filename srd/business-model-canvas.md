# Modelo de Negocio — Vertivo

## Basado en Lean Canvas (Ash Maurya) y Business Model Canvas (Alexander Osterwalder)

> Vertivo Horticultura Urbana Vertical S.R.L.
> Cédula Jurídica 3-102-815230 | San Francisco, Heredia, Costa Rica

---

## 1. Segmentos de Mercado

### Clientes Objetivo

Personas, organizaciones y gobiernos en América Latina que desean cultivar o acceder a alimentos libres de pesticidas de forma autónoma en espacios urbanos reducidos — sin depender de ingenieros agrónomos, luz solar, ni control manual de plagas.

> Los clientes no existen para comprarle a uno. *Uno existe para resolverles a ellos.*

### Verticales de Negocio

| Vertical | Modelo | Target |
|----------|--------|--------|
| **Farm Automation** | Venta de micro-invernaderos + Upselling (SaaS monitoreo + Insumos) | Familias de poder adquisitivo medio-alto, empresas medianas y grandes |
| **Product-as-a-Service** | Alquiler de micro-invernaderos + Upselling (SaaS + Insumos) | Familias de poder adquisitivo medio, locales comerciales, personas sin capacidad de compra |
| **Urban-Farming-as-a-Service** | Venta de alimentos orgánicos bajo suscripción | Familias de bajo poder adquisitivo, personas sin espacio para un invernadero |

### Segmentos por Tipo de Cliente

| Segmento | Tipo | Descripción | % Usuarios | % Revenue |
|----------|------|-------------|-----------|-----------|
| **Residential B2C** | Persona | Familias, entusiastas tech, jubilados — 1-3 invernaderos en casa/oficina | 55% | 32% |
| **Commercial B2B** | PyME | Restaurantes, juice bars, estudios de bienestar, empresas medianas — 4-10 invernaderos | 20% | 32% |
| **Industrial B2B** | Empresa grande | Cadenas de restaurantes, operaciones agroindustriales — 10+ invernaderos | 4% | 22% |
| **Government B2G** | Institución pública | Instituciones gubernamentales educativas, comedores infantiles, municipalidades | 3% | 3% |
| **Expert** | Agrónomo consultor | Agrónomos que gestionan flotas de clientes remotamente | 3% | 4% |
| **Ecosystem** | Proveedor / Data buyer | Proveedores de insumos (3P), compradores de datos agrícolas | 4% | 5% |
| *Inactivos/trial* | — | Usuarios en prueba o churned | 11% | 2% |

### Perfiles de Cliente (Buyer Personas)

> Se definen 10 buyer personas que cubren los segmentos B2C, B2B, B2G y Ecosystem.

---

#### Perfil del Consumidor Ideal #1 — María, La Mamá Urbana Consciente

- **Demografía**: 34 años, San José Costa Rica, Marketing Manager en agencia, casada con 2 hijos (6 y 9), ingreso familiar ~$4,000/mes, tech savviness media (iPhone, apps, no técnica)
- **Comportamientos**: Compra orgánico en AutoMercado, activa en WhatsApp e Instagram, busca recetas saludables en Pinterest, compara precios online antes de comprar electrodomésticos, toma decisiones de compra del hogar
- **Necesidades**: Alimentos sin pesticidas para sus hijos, solución que no requiera conocimientos de agronomía, algo que funcione en un apartamento sin patio, interfaz simple que no la abrume
- **Objetivos**: Que sus hijos coman saludable y vean de dónde viene su comida, reducir el gasto en orgánicos, tener un hobby que comparta con la familia

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Alimentos sin pesticidas para los niños | **Muy importante** |
| Funcione sin conocimiento técnico | **Muy importante** |
| Quepa en un apartamento | **Muy importante** |
| App simple e intuitiva | Un poco importante |
| Variedad de cultivos disponibles | Un poco importante |
| Comunidad de otros padres que cultivan | Un poco insignificante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| No sabe si los "orgánicos" del súper son realmente orgánicos | **Muy extrema** |
| Intentó huerta en maceta 2 veces — ambas murieron | **Muy extrema** |
| No tiene espacio exterior ni luz solar directa | Un poco extrema |
| No tiene tiempo para investigar aeroponía | Un poco moderada |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Cosechar hierbas y lechugas en casa cada mes | **Muy esencial** |
| Que los niños participen en el proceso | **Muy esencial** |
| Ahorrar vs. comprar orgánico | Un poco esencial |
| Compartir logros en redes sociales | Un poco deseable |

**Vertical**: Farm Automation | **Plan**: Basic ([ver pricing]) | **Hardware**: Vertivo Home ([precio redactado]) | **Marketplace**: Caja Básica ([ver pricing]) + on-demand | **SRD**: user% 22%, revenue% 12%

---

#### Perfil del Consumidor Ideal #2 — Carlos, El Techie Entusiasta

- **Demografía**: 28 años, Medellín Colombia, developer en fintech, soltero, renta apartamento en El Poblado, ingreso ~$3,500/mes, tech savviness muy alta (Home Assistant, 3D printer, IoT hobbyist)
- **Comportamientos**: Early adopter de todo, tiene 4 dispositivos IoT en casa, publica en Reddit y Twitter, compra gadgets por specs no por precio, contribuye a proyectos open source, mide todo con datos
- **Necesidades**: Sistema con API abierta que pueda integrar, datos de sensores accesibles y exportables, firmware estable que no rompa sus integraciones, microgreens frescos para sus smoothies
- **Objetivos**: Optimizar el cultivo con datos, integrar el invernadero en su ecosistema de home automation, contribuir feedback técnico que mejore el producto

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| API accesible para integrar con Home Assistant | **Muy importante** |
| Datos de sensores en tiempo real exportables | **Muy importante** |
| Sistema estable que no requiera "debug" constante | **Muy importante** |
| Variedad de cultivos experimentales (microgreens, chiles) | Un poco importante |
| Comunidad técnica / foro | Un poco importante |
| Precio bajo | Un poco insignificante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| Su setup DIY Arduino murió por pH sensor drift — no quiere mantener hardware | **Muy extrema** |
| Los productos "smart garden" comerciales no tienen API | Un poco extrema |
| No encuentra comunidad de aeroponía técnica en LATAM | Un poco moderada |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Dashboard en Grafana con datos de su invernadero | **Muy esencial** |
| Cosechar microgreens cada 2 semanas | Un poco esencial |
| Contribuir al producto como beta tester | Un poco deseable |

**Vertical**: Farm Automation | **Plan**: Pro ([ver pricing]) | **Hardware**: Vertivo Home ([precio redactado]) | **Marketplace**: $35/mo on-demand | **SRD**: user% 15%, revenue% 10%

---

#### Perfil del Consumidor Ideal #3 — Rosa, La Abuela Jardinera

- **Demografía**: 63 años, Heredia Costa Rica, maestra jubilada, vive sola (hijos la visitan los fines de semana), pensión ~$1,200/mes, tech savviness baja (WhatsApp y Facebook únicamente)
- **Comportamientos**: Jardinería de toda la vida pero la artritis le impide seguir con el jardín exterior, va a misa los domingos y conversa con 30+ personas, confía en recomendaciones de familia, no compra tecnología por sí misma
- **Necesidades**: Algo que le devuelva la rutina de cuidar plantas sin esfuerzo físico, interfaz con letras grandes y lenguaje simple, que el robot se encargue de lo técnico, no sentirse sola
- **Objetivos**: Volver a cosechar culantro y chile dulce como antes, tener algo que mostrarle a sus nietos cuando visitan, sentirse útil y activa

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| No tener que agacharse, cargar tierra ni regar manualmente | **Muy importante** |
| Interfaz accesible (letras grandes, lenguaje simple) | **Muy importante** |
| Que el robot maneje todo lo técnico automáticamente | **Muy importante** |
| Poder llamar a alguien si algo sale mal | Un poco importante |
| Que sea bonito en su casa | Un poco insignificante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| Artritis le impide jardinería tradicional | **Muy extrema** |
| Jardín exterior fue invadido por insectos y especies invasoras | **Muy extrema** |
| Se siente desconectada de la naturaleza | Un poco extrema |
| No entiende tecnología moderna | Un poco moderada |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Cosechar culantro y chile dulce cada mes | **Muy esencial** |
| Rutina diaria de revisar sus plantas | **Muy esencial** |
| Compartir la experiencia con sus nietos | Un poco esencial |
| Que otros vecinos le pregunten sobre su "jardincito" | Un poco deseable |

**Vertical**: Farm Automation | **Plan**: Basic ([ver pricing], pagado por su hijo) | **Hardware**: Vertivo Home ([precio redactado], regalo) | **Marketplace**: Caja Básica ($20/mo) | **SRD**: user% 8%, revenue% 4%

---

#### Perfil del Consumidor Ideal #4 — Diego, El Dueño de Restaurante Farm-to-Table

- **Demografía**: 41 años, Ciudad de Panamá, dueño de restaurante de 40 asientos en Casco Viejo, casado con 1 hijo, ingreso del negocio ~$15,000/mes, tech savviness media (POS, dashboards de negocio)
- **Comportamientos**: Obsesionado con la calidad del ingrediente, sigue tendencias gastronómicas en Instagram, asiste a ferias food & bev, toma decisiones basadas en ROI, compara proveedores trimestralmente
- **Necesidades**: Reducir costos de hierbas frescas ([costo redactado]/mes actual), garantizar calidad consistente, branding "harvested today served tonight", acceso a API para conectar con su POS
- **Objetivos**: Reducir dependencia de proveedores externos, diferenciar su restaurante, tener reportes de ROI que justifiquen la inversión ante su socio

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Reducir costo de hierbas vs. proveedores | **Muy importante** |
| Calidad consistente sin variaciones estacionales | **Muy importante** |
| API para integrar con POS y procurement | **Muy importante** |
| Branding "farm-to-table" visible para clientes | Un poco importante |
| Multi-usuario para staff de cocina | Un poco importante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| Proveedores entregan hierbas marchitas | **Muy extrema** |
| Precios fluctúan 30% por temporada | **Muy extrema** |
| No puede garantizar "orgánico" a clientes | Un poco extrema |
| Espacio de cocina limitado para cultivo | Un poco moderada |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| ROI visible en menos de 4 meses | **Muy esencial** |
| Cortar gasto de proveedores de hierbas en 40%+ | **Muy esencial** |
| Menú con badge "Grown In-House" | Un poco esencial |
| Cobertura de prensa / food bloggers | Un poco deseable |

**Vertical**: Farm Automation | **Plan**: Commercial ([ver pricing] + API) | **Hardware**: Vertivo Pro ([precio redactado]) | **Marketplace**: Caja Comercial ([ver pricing]) | **SRD**: user% 12%, revenue% 20%

---

#### Perfil del Consumidor Ideal #5 — Valentina, La Emprendedora de Bienestar

- **Demografía**: 36 años, Bogotá Colombia, dueña de estudio de yoga + juice bar, soltera, vive con su perro, ingreso del negocio ~$8,000/mes, tech savviness media (Canva, Instagram business)
- **Comportamientos**: Cuida su marca personal obsesivamente, todo debe ser "Instagrammable", compra orgánico aunque cueste más, su clientela es health-conscious y dispuesta a pagar premium, networking constante en comunidad wellness
- **Necesidades**: Ingredientes frescos visibles para clientes (marketing + producto en uno), reducir costos de orgánicos, estética del dispositivo que combine con su estudio, variedad de hierbas para jugos y smoothies
- **Objetivos**: Diferenciar su juice bar como el único con cultivo in-house, reducir costos, generar contenido orgánico para Instagram

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Estética del invernadero que combine con su local | **Muy importante** |
| Ingredientes frescos cosechados frente al cliente | **Muy importante** |
| Reducir costo de hierbas orgánicas | Un poco importante |
| Variedad: wheatgrass, mint, lemongrass, edible flowers | Un poco importante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| Hierbas de Corabastos se marchitan en 2 días | **Muy extrema** |
| No puede garantizar "truly organic" a su clientela | Un poco extrema |
| Refrigeración de hierbas frescas es costosa | Un poco extrema |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Clientes ven sus ingredientes creciendo mientras esperan | **Muy esencial** |
| Reducir costos de ingredientes orgánicos en 35% | Un poco esencial |
| Contenido orgánico para redes (fotos, stories) | Un poco esencial |

**Vertical**: Farm Automation | **Plan**: Commercial ([ver pricing] + API) | **Hardware**: Vertivo Pro ([precio redactado]) | **Marketplace**: $95/mo mixto | **SRD**: user% 8%, revenue% 12%

---

#### Perfil del Consumidor Ideal #6 — Roberto, El Director de Operaciones Agroindustrial

- **Demografía**: 48 años, Ciudad de México, COO de cadena de 15 restaurantes, casado con 3 hijos adolescentes, ingreso >$20,000/mes, tech savviness alta en herramientas enterprise (ERP, BI, procurement)
- **Comportamientos**: Toma decisiones con datos, presenta a board trimestralmente, audita proveedores, busca eficiencia operativa, participa en conferencias AgTech, procurement cycle de 6-12 meses
- **Necesidades**: Centralizar producción de hierbas para 15 locations, integración con SAP/ERP, reportes de compliance (COFEPRIS), SLA con soporte dedicado, ROI demostrable para el CFO
- **Objetivos**: Verticalizar cadena de suministro, eliminar dependencia de 6 proveedores, reducir waste rate del 22% al <5%, pasar auditorías de seguridad alimentaria al primer intento

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Integración ERP/SAP vía API | **Muy importante** |
| Compliance reports para COFEPRIS / regulatory | **Muy importante** |
| SLA con soporte dedicado y uptime garantizado | **Muy importante** |
| ROI demostrable para presentar al board | **Muy importante** |
| Escalabilidad: agregar locations sin fricciones | Un poco importante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| 6 proveedores en 3 ciudades con calidad inconsistente | **Muy extrema** |
| Waste rate del 22% en hierbas frescas | **Muy extrema** |
| Auditorías de compliance son manuales y costosas | **Muy extrema** |
| [costo redactado]/mes en hierbas con precios volátiles | Un poco extrema |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Reducir costos de hierbas en 45%+ | **Muy esencial** |
| Waste rate <5% | **Muy esencial** |
| Pasar auditorías COFEPRIS al primer intento | **Muy esencial** |
| Rollout a 15 locations en 6 meses | Un poco esencial |

**Vertical**: Farm Automation | **Plan**: Industrial ([ver pricing] + SLA) | **Hardware**: 4x Vertivo Scale ([precio redactado]) | **Marketplace**: $480/mo bulk | **SRD**: user% 4%, revenue% 22%

---

#### Perfil del Consumidor Ideal #7 — Lucía, La Ingeniera Agrónoma Consultora

- **Demografía**: 39 años, Cartago Costa Rica, agrónoma independiente con 12 clientes, casada con 1 hijo, ingreso ~$3,000/mes, tech savviness alta en software agronómico, media en general
- **Comportamientos**: Visita clientes semanalmente para chequeos de pH y nutrientes, recomienda productos y prácticas, publica en LinkedIn sobre agricultura urbana, conectada con la comunidad universitaria agronómica
- **Necesidades**: Monitorear todos sus clientes desde un solo dashboard, que el robot agrónomo no contradiga sus recomendaciones sin explicar por qué, escalar a más de 12 clientes sin contratar
- **Objetivos**: Duplicar cartera de clientes (de 12 a 25) sin duplicar horas de trabajo, posicionarse como la agrónoma de referencia en urban farming en CR

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Dashboard de fleet con todos los clientes en una vista | **Muy importante** |
| El robot sugiere, ella decide (Expert Mode) | **Muy importante** |
| Reducir visitas presenciales de semanales a quincenales | **Muy importante** |
| Cross-client analytics (patterns entre invernaderos) | Un poco importante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| 60% de su tiempo se va en traslados a clientes | **Muy extrema** |
| No puede escalar más allá de 12 clientes sin contratar | **Muy extrema** |
| Datos de rendimiento son manuales en Excel | Un poco extrema |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Monitorear 25 clientes con el mismo esfuerzo que 12 | **Muy esencial** |
| Cada cliente recomendado compra un Vertivo | **Muy esencial** |
| Generar reportes automáticos por cliente | Un poco esencial |

**Vertical**: Farm Automation | **Plan**: Commercial ([ver pricing]) | **Hardware**: $0 (clientes compran) | **SRD**: user% 3%, revenue% 4% (multiplicador)

---

#### Perfil del Consumidor Ideal #8 — Andrés, El Influencer de Barrio

- **Demografía**: 31 años, Envigado Colombia, arquitecto + content creator (15K seguidores Instagram), vive con novia, ingreso ~$2,800/mes, tech savviness alta
- **Comportamientos**: Documenta todo en Stories, busca aesthetic en cada compra, asiste a eventos locales, genera engagement con su comunidad, monetiza contenido con marcas
- **Necesidades**: Producto fotogénico que genere contenido, programa de referral con incentivos reales, herramientas de sharing integradas, early access a features nuevos
- **Objetivos**: Ser el referente de "urban farming lifestyle" en Medellín, monetizar su relación con Vertivo, crecer su audiencia

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Programa de referral con incentivos económicos | **Muy importante** |
| Producto fotogénico que genere contenido orgánico | **Muy importante** |
| Herramientas de sharing (harvest cards, timelapse auto) | Un poco importante |
| Early access a features nuevos | Un poco importante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| No existe referral program — sus referidos no le generan nada | **Muy extrema** |
| La app no tiene función de "compartir cosecha" con branding | Un poco extrema |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Generar ingresos pasivos por referrals | **Muy esencial** |
| Contenido de calidad con mínimo esfuerzo (automate) | **Muy esencial** |
| Crecer audiencia con contenido de urban farming | Un poco esencial |

**Vertical**: Farm Automation | **Plan**: Pro ([ver pricing]) | **Hardware**: Vertivo Home ([precio redactado]) | **Marketplace**: [ver pricing] | **SRD**: user% 10%, revenue% 6%

---

#### Perfil del Consumidor Ideal #9 — Directora de Comedor Escolar (B2G)

- **Demografía**: 52 años, San José Costa Rica, directora de escuela pública con 400 estudiantes, presupuesto del MEP, tech savviness baja
- **Comportamientos**: Gestiona presupuesto limitado para comedores infantiles, depende de proveedores del gobierno, busca certificaciones para auditorías, prioriza nutrición infantil, reporta a junta directiva y MEP
- **Necesidades**: Suministro constante de alimentos frescos para cientos de niños, no tiene espacio ni personal ni conocimientos para cultivar, necesita precios accesibles o subsidio, documentación para auditorías públicas
- **Objetivos**: Alimentar a los niños con alimentos más nutritivos y frescos, cumplir requisitos del MEP/SENASA, reducir desperdicio de alimentos en el comedor

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Suministro constante sin interrupciones | **Muy importante** |
| Precio accesible dentro del presupuesto público | **Muy importante** |
| Documentación de trazabilidad para auditorías | **Muy importante** |
| Que no requiera personal técnico especializado | Un poco importante |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| Presupuesto insuficiente para alimentos de calidad | **Muy extrema** |
| Proveedores del gobierno entregan productos de baja calidad | **Muy extrema** |
| No tiene espacio, personal ni conocimientos para cultivar | Un poco extrema |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Niños comen alimentos más frescos y nutritivos | **Muy esencial** |
| Pasar auditorías de SENASA / MEP sin observaciones | **Muy esencial** |
| Reducir desperdicio de alimentos | Un poco esencial |

**Vertical**: Urban-Farming-as-a-Service (suscripción de alimentos) o Product-as-a-Service (alquiler) | **SRD**: user% 3%, revenue% 3%

---

#### Perfil del Consumidor Ideal #10 — AgriData Corp (Comprador de Datos del Enjambre)

- **Demografía**: Empresas AgTech, universidades, ministerios de agricultura, laboratorios de R&D de semillas — LATAM y global
- **Comportamientos**: Procurement de 6-12 meses, requieren datos con rigor estadístico, publican papers y reportes, presupuestos de investigación aprobados anualmente
- **Necesidades**: Datos granulares geo-tagged de rendimiento de cultivos aeropónicos en LATAM (que no existen en otro lugar), cobertura estadísticamente significativa (50+ devices por metro area), API estable con SLA
- **Objetivos**: Reducir costos de field trials ([costo redactado] por cultivo por location), descubrir patrones de rendimiento por clima/altitud

##### Priorización de Necesidades

| Necesidad | Prioridad |
|-----------|-----------|
| Datos geo-tagged de rendimiento únicos | **Muy importante** |
| Cobertura suficiente para significancia estadística | **Muy importante** |
| API estable con SLA y documentación | **Muy importante** |

##### Severidad de los Problemas

| Problema | Severidad |
|----------|-----------|
| Datos agrícolas en LATAM son fragmentados e inaccesibles | **Muy extrema** |
| Field trials son prohibitivamente caros | **Muy extrema** |

##### Relevancia de los Resultados Deseados

| Resultado | Relevancia |
|-----------|-----------|
| Dataset de rendimiento continuo para R&D | **Muy esencial** |
| Reducir costos de field trials en 60%+ | **Muy esencial** |

**Plan**: Custom enterprise ([ver pricing]) | **SRD**: user% 1%, revenue% 5%

---

## 2. Propuesta de Valor

### Problemática (de Notion)

> Imposibilidad de auto-abastecimiento de alimentos suficientes, inocuos, libres de pesticidas y nutritivos que satisfagan sus necesidades energéticas diarias y preferencias alimentarias para llevar una vida activa y sana.

Los clientes están expuestos a inseguridad alimentaria y son incapaces de volverse autosuficientes debido a: malas condiciones socioeconómicas, brotes de enfermedades, falta de acceso a agua potable, efectos del cambio climático, altos costos de energía eléctrica, alto impacto económico del aprendizaje a prueba y error, falta de conocimientos técnicos, y poca o nula disponibilidad de espacios aptos para auto-cultivar en zonas urbanas de LATAM.

### Top 3 Problemas que Vertivo Resuelve

| # | Problema | Quién lo sufre | Alternativa actual |
|---|----------|---------------|-------------------|
| 1 | **No pueden verificar que sus alimentos sean realmente libres de pesticidas** — los "orgánicos" del supermercado no son trazables, y cultivar manualmente requiere conocimientos, espacio y luz solar que no tienen | María, Rosa, Valentina, Directora B2G | Comprar "orgánico" a ciegas en el súper, o intentar macetas que mueren en semanas |
| 2 | **Auto-cultivar en zonas urbanas es imposible sin automatización** — no hay espacio exterior, el clima es impredecible, las plagas destruyen cultivos abiertos, y el aprendizaje por prueba y error es carísimo en tiempo y dinero | Carlos, Andrés, María, Rosa | Kits de huerta manual sin sensores, tutoriales de YouTube, jardinería tradicional con 12h de foto-período solar |
| 3 | **Las cadenas de suministro de alimentos frescos son frágiles y caras** — precios volátiles (±30% por temporada), calidad inconsistente, waste rate >20%, y sin trazabilidad para compliance regulatorio | Diego, Roberto, Directora B2G, Valentina | 6+ proveedores con calidad variable, logística de frío costosa, auditorías manuales |

### Solución

- **Micro-invernaderos autónomos aeropónicos urbanos** con ambiente cerrado (sin plagas ni especies invasoras), LEDs de horticultura especializados (18h de foto-período vs. 12h solar), y robot agrónomo embebido (Raspberry Pi + sensores Atlas Scientific EZO) que controla pH, nutrientes, temperatura, humedad, CO2 automáticamente.
- **Nebuponía** (aeroponía por nebulización) como método de irrigación — 90% menos agua que agricultura tradicional.
- **Comunicación descentralizada** entre invernaderos del enjambre — cada dispositivo alimenta el cerebro colectivo.
- **Gemelos digitales** para experimentación de recetas de cultivo sin arriesgar plantas reales.
- **Predicción de rendimientos de cultivo** basada en datos del enjambre.
- **App móvil + Dashboard cloud** para monitoreo en tiempo real, alertas push, predicciones, fitopatología AI, reportes de ROI.
- **Marketplace de insumos** con suscripción tipo "Caja Vertivo" donde el robot calcula necesidades.

### Propuesta de Valor Única

**"Una Huerta Pensada para Vos"** — Tu robot agrónomo personal: cultiva tus alimentos en casa sin saber nada de agronomía, sin luz solar, sin plagas, y con insumos en tu puerta cada mes.

### Generadores de Resultados

| Vertical | Propuesta Principal | Down-selling |
|----------|-------------------|-------------|
| **Farm Automation** | Micro-invernadero + Robot agrónomo + App SaaS | Kits orquestadores, soluciones nutritivas embotelladas, insumos a domicilio |
| **Product-as-a-Service** | Alquiler del micro-invernadero + monitoreo remoto | Insumos a domicilio |
| **Urban-Farming-as-a-Service** | Suscripción de alimentos orgánicos cultivados por Vertivo | — |

---

## 3. Ventaja Injusta o Competitiva

> ¿Por qué somos nosotros los indicados para resolver este problema? ¿Qué tenemos que (casi) nadie más tiene?

| Ventaja | Difícil de copiar porque... |
|---------|---------------------------|
| **Enjambre de datos** (network effect) | Cada dispositivo mejora las recetas para todos. Más devices = mejor data = mejores recomendaciones = más devices. |
| **Robot agrónomo IP** | Algoritmos de control calibrados con datos reales de miles de micro-entornos aeropónicos en LATAM. No es un producto gringo adaptado. |
| **Nebuponía patentable** | Método de irrigación por nebulización optimizado para micro-invernaderos urbanos. |
| **Integración vertical** (hardware + software + insumos) | Competidores ofrecen 1 de 3. Vertivo controla la experiencia completa. Triple lock-in. |
| **LATAM-first** | Pagos locales (SINPE, PSE, SPEI, PIX, OXXO), español nativo, distribución regional, recetas para clima tropical. |
| **Datos de rendimiento geo-tagged** | No existe otra fuente de datos de cultivo aeropónico por especie x geolocalización x micro-clima en LATAM. Activo monopolístico. |
| **Diseños Modelo XL y Modelo S** | Hardware propio diseñado internamente — no es ensamblaje de componentes genéricos. |
| **Gemelos digitales** | Experimentación de recetas sin arriesgar plantas reales — ventaja de velocidad en I+D. |

---

## 4. Canales de Distribución

| Canal | Tipo | Target | Etapa |
|-------|------|--------|-------|
| **Web D2C** (vertivo.com) | Digital | Residential + Commercial | Awareness → Compra |
| **App móvil** (Flutter) | Digital | Todos | Retención → Marketplace |
| **Referral program** | Orgánico | Residential | Adquisición (18% referral rate) |
| **Agrónomos consultores** (Lucía) | Partnership | Residential + Commercial | Multiplicador |
| **Video testimonials** (casos de éxito) | Content | Residential | Awareness → Confianza |
| **Instagram / WhatsApp** | Social | Residential | Awareness → Viralidad |
| **Ventas directas B2B** | Outbound | Industrial + B2G | Enterprise sales cycle |
| **Ferias AgTech + Food & Bev** | Eventos | Commercial + Industrial | Lead generation |
| **Alianzas municipales** | Gobierno | B2G | Comedores escolares, programas sociales |

---

## 5. Relaciones con los Clientes

| Etapa | Mecanismo | Herramienta |
|-------|-----------|-------------|
| **Adquisición** | Referral, video testimonials, Instagram, agrónomos | Web, social media |
| **Onboarding** | Video setup, primer cultivo asistido por robot, "primera cosecha" push | App móvil, FCM |
| **Retención** | Alertas automáticas, Caja Vertivo mensual, ROI reports | App, WhatsApp Business |
| **Upselling** | Feature gates (AI phytopathology), módulos adicionales | In-app prompts |
| **Cross-selling** | Marketplace on-demand, nuevas variedades | Push notifications, robot recs |
| **Comunidad** | Feed de cosechas, rankings, recetas colaborativas | App (futuro) |
| **Soporte** | Chat in-app, WhatsApp Business, SLA dedicado (Industrial) | Zendesk, WhatsApp API |

---

## 6. Fuentes de Ingresos

| Fuente | Tipo | Rango | % MRR |
|--------|------|-------|-------|
| **Hardware** (Farm Automation) | One-time | [precio redactado] – [precio redactado] | 14% |
| **SaaS Monitoring** | Recurrente mensual | $29 – [ver pricing] | 43% |
| **Marketplace — Caja Vertivo** | Suscripción mensual | $25 – [ver pricing] | 22% |
| **Marketplace — On-demand** | Transaccional | Variable | 14% |
| **Alquiler** (Product-as-a-Service) | Recurrente mensual | TBD | Futuro |
| **Suscripción alimentos** (UFaaS) | Recurrente mensual | TBD | Futuro |
| **Data & B2B** | Contratos anuales | $2,500 – $5,500/mo | 7% |

Proyeccion: ver success-reality.md (privado). Ver `srd/success-reality.md`.

---

## 7. Estructura de Costos

### Costos Fijos

| Concepto | Costo/mes estimado |
|----------|-------------------|
| Cloud infrastructure (K8s, EMQX, PostgreSQL) | REDACTED |
| Equipo de desarrollo (4 devs + 1 designer) | REDACTED |
| Fulfillment center (bodega + 2 operarios) | REDACTED |
| Soporte al cliente (2 agentes) | REDACTED |
| Marketing + content creation | REDACTED |
| Legal + contabilidad | REDACTED |
| **Total fijos** | **$42,500/mo** |

### Costos Variables

| Concepto | Costo unitario |
|----------|---------------|
| Hardware COGS (Vertivo Home) | REDACTED |
| Hardware COGS (Vertivo Pro) | REDACTED |
| Hardware COGS (Vertivo Scale) | ~$11,000/unit |
| Fulfillment Caja Vertivo | $8-15/shipment |
| Nutritivas manufacturing | 35% of GMV |
| Payment processing | 3.5% + $0.30/tx |
| MQTT bandwidth | $0.15/device/mo |

### Punto de Equilibrio

Con $42,500/mo en costos fijos y ~64% gross margin blended, break-even en **~$66K MRR** (~mes 4-5 post-launch).

---

## 8. Recursos Clave

| Recurso | Tipo | Descripción |
|---------|------|-------------|
| Robot agrónomo firmware | Intelectual | Python orchestrator + Atlas Scientific EZO drivers + Balena deploy |
| Nebuponía tech | Intelectual | Método de irrigación aeropónico por nebulización |
| Gemelos digitales | Intelectual | Simulación de recetas de cultivo |
| Serverpod backend | Tecnología | 10 endpoints, MQTT ingestion, 29 tables |
| App Flutter | Tecnología | Mobile experience (en desarrollo) |
| Dashboard Jaspr | Tecnología | Admin dashboard (en desarrollo) |
| Hardware design (Modelo XL + S) | Físico | RPi + Atlas Scientific EZO + LEDs + pump |
| Fulfillment center | Físico | Bodega para nutritivas, semillas, hardware |
| Enjambre dataset | Intelectual | Datos geo-tagged (crece con cada device) |
| latam_payments SDK | Tecnología | Pagos locales integrados |

---

## 9. Actividades Clave

| Actividad | Prioridad | Estado |
|-----------|-----------|--------|
| Implementar billing (latam_payments) | **Crítica** | 0% |
| Desarrollar Flutter app MVP | **Crítica** | 8% |
| Manufacturing de hardware | **Crítica** | Diseño listo |
| Push notifications (FCM) | Alta | Schema listo |
| Conectar dashboard a datos reales | Alta | 35% |
| Marketplace (catálogo, carrito, checkout) | Alta | 0% |
| Fulfillment de Caja Vertivo | Alta | Manual al inicio |
| Onboarding proveedores 3P | Media | Pendiente |
| Data pipeline enjambre API | Media | MQTT ingestion funciona |
| Certificaciones (SENASA, COFEPRIS) | Media | Templates en schema |
| Implementar Product-as-a-Service | Baja (fase 2) | 0% |
| Implementar Urban-Farming-as-a-Service | Baja (fase 3) | 0% |

---

## 10. Cadena de Valor (Socios Clave)

| Socio | Producto/Servicio | Importancia |
|-------|-------------------|-------------|
| Atlas Scientific | Sensores EZO I2C | Crítica |
| Raspberry Pi Foundation | SBC robot agrónomo | Crítica |
| OnvoPay / Tilopay | Pagos CR + PA | Crítica |
| Wompi | Pagos CO | Crítica |
| EMQX | MQTT Broker (open source) | Alta |
| Balena | Deployment + OTA updates RPi | Alta |
| Proveedores de semillas | Semillas orgánicas certificadas | Alta |
| Fabricante LEDs horticultura | Full spectrum LED panels | Alta |
| Logística last-mile | Envíos Caja Vertivo | Alta |
| Fabricante de nutrientes | Soluciones aeropónicas pre-mezcladas | Alta |

---

## 11. Métricas de Impacto

### KPIs Principales

| Métrica | Target (18mo) |
|---------|---------------|
| MRR | [MRR target] |
| MAU | 2,550 |
| Devices vendidos (cumul.) | [redactado] |
| SaaS churn mensual | <2.5% |
| NPS | >60 |
| Time-to-first-harvest | <30 días |

### AARRR (Pirate Metrics)

| Etapa | Métrica | Target |
|-------|---------|--------|
| **Acquisition** | Referral rate | 18% |
| **Activation** | % cosecha en <30 días | 85% |
| **Retention** | SaaS renewal rate | 97.8% |
| **Revenue** | ARPU (SaaS + marketplace) | $165/mo |
| **Referral** | Devices por referral | 40% del total |

---

## 12. Objetivos y Resultados Clave (OKRs)

### Corto Plazo (3 meses)

- **O1: Lanzar billing y app MVP**
  - KR 1.1: Integrar latam_payments (OnvoPay/Tilopay) en Flutter
  - KR 1.2: 5 pantallas core: login, dashboard, greenhouse detail, alerts, profile
  - KR 1.3: Push notifications (FCM) funcionales
  - KR 1.4: Feature gating por plan

- **O2: Soft launch Costa Rica (120 devices)**
  - KR 2.1: Manufacturing de 150 Vertivo Home
  - KR 2.2: 120 devices vendidos con SaaS activo
  - KR 2.3: $12K MRR
  - KR 2.4: Time-to-first-harvest <30 días para 85%

### Mediano Plazo (12 meses)

- **O1: 4 países con $230K MRR**
  - KR 1.1: CR + PA + CO + MX operando
  - KR 1.2: 1,700 devices acumulados
  - KR 1.3: Marketplace + Caja generando 36% del MRR
  - KR 1.4: Data API beta con 2+ enterprise customers

### Objetivos Estratégicos (de Notion)

1. Lograr product-market fit y service-market fit exitosos
2. Construir un producto y servicio de categoría mundial
3. Alcanzar la rentabilidad
4. Crear una organización de empresa de categoría mundial

### Moonshot Goals (ODS)

> **Moonshot 1**: Proveer a la mayoría de familias de Centroamérica de una herramienta para autoabastecerse de alimentos y superar las crisis alimentarias del futuro.

> **Moonshot 2**: Lograr que la mayoría de campos de cultivo de Centroamérica se transformen en bosques nativos para secuestrar y capturar dióxido de carbono.

---

## 13. Identidad de Marca

- **Razón Social**: Vertivo Horticultura Urbana Vertical S.R.L.
- **Slogan**: "Una Huerta Pensada para Vos"

- **Propósito** (¿Por qué?): Solventar los problemas de disponibilidad y acceso a los alimentos libres de pesticidas y sus medios de producción; que restringen a los consumidores finales satisfacer su necesidad de seguridad alimentaria y nutrición personalizada.

- **Misión** (¿Cómo?): Hacer accesible a las personas alimentos de alto valor nutricional y libres de pesticidas, mediante la aeroponía, una solución nutritiva estandarizada, la automatización de los sistemas de cultivo, y el monitoreo remoto del ciclo fenológico de las plantas. Impulsar un movimiento social para que la mayor cantidad de personas adquieran conciencia sobre la procedencia de sus alimentos.

- **Visión** (¿Qué?): Mitigar la emergencia climática cultivando la mayor cantidad posible de huertas urbanas verticales automatizadas, para reducir la dependencia de las tierras de cultivo y bosques devastados por la perturbación humana.

- **Principios**: Antifragilidad, Rendición de Cuentas, Empatía, Proactividad, Sentido de Urgencia, Curiosidad, Transparencia.

- **ODS prioritarios**: 12 (Producción Responsable), 11 (Ciudades Sostenibles), 13 (Acción Climática), 8 (Trabajo Decente), 2 (Hambre Cero).

- **Triple Impacto**:
  - Social: Fuentes de empleo con poca capacitación requerida
  - Económico: Reinversión de ganancias para expansión exponencial
  - Ambiental: Reducción de dependencia en suelos fértiles y combustibles fósiles

- **Reseña**: Fundada en mayo 2021 por Verónica (paciente de Síndrome de Sensibilidad Química Múltiple y Fibromialgia) y Andrés, tras la necesidad de consumir alimentos libres de pesticidas que causaban enfermedades neurodegenerativas.
