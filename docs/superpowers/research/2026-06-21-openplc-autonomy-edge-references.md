# Referencias: OpenPLC · Autonomy Edge · IEC 61131-3 (dashboard + capa de control)

- **Fecha:** 2026-06-21
- **Estado:** Material de referencia — para el rediseño de `vertivo_dashboard` y la capa de control/actuación. Pendiente de brainstorm/OpenSpec propio.
- **Conexión:** Liga con el spike `openspec/changes/2026-06-01-vertivo-nvidia-physical-ai/` (decisión #5/#6: extender el orquestador custom, NO adoptar OpenPLC como "cerebro"; Modbus/OpenPLC como adaptador de edge + HIL; el gap real es la capa de actuadores).

## Dato clave
**Vertivo ya tiene un tenant en Autonomy Edge:**
`https://edge.autonomylogic.com/vertivolatam_60efxf/orchestrators` → el dashboard de
orquestadores/vPLCs de Autonomy Edge es un **modelo de UI real** para `vertivo_dashboard`.

## Autonomy Edge (plataforma — modelo de UX para el dashboard)
- Quick start: https://edge.autonomylogic.com/docs/getting-started/quick-start/
- Dashboard tour: https://edge.autonomylogic.com/docs/getting-started/dashboard-tour/
- Orchestrators overview: https://edge.autonomylogic.com/docs/platform/orchestrators/overview/
- Orchestrators list: https://edge.autonomylogic.com/docs/platform/orchestrators/orchestrators-list/
- Managing orchestrators: https://edge.autonomylogic.com/docs/platform/orchestrators/managing-orchestrators/
- Crear un vPLC: https://edge.autonomylogic.com/docs/platform/vplcs/creating-a-vplc/
- Detalle de vPLC: https://edge.autonomylogic.com/docs/platform/vplcs/vplc-detail/
- Troubleshooting (orchestrator not connecting): https://edge.autonomylogic.com/docs/troubleshooting/orchestrator-not-connecting/

## OpenPLC (runtime + editor — capa de control / actuación)
- Runtime v4: https://github.com/Autonomy-Logic/openplc-runtime
- Editor v4: https://github.com/Autonomy-Logic/openplc-editor
- POUs (Program Organization Units): https://edge.autonomylogic.com/docs/openplc-editor/iec-concepts/pous/
- Structured Text (ST) básico: https://edge.autonomylogic.com/docs/openplc-editor/programming-languages/structured-text/st-basics/
- Ladder Diagram (LD) básico: https://edge.autonomylogic.com/docs/openplc-editor/programming-languages/ladder-diagram/ld-basics/
- Function Block Diagram (FBD) básico: https://edge.autonomylogic.com/docs/openplc-editor/programming-languages/function-block-diagram/fbd-basics/

## IEC 61131-3 (estándar de programación de PLC)
- OOP en IEC 61131-3 (whitepaper): https://www.plantautomation-technology.com/whitepapers/oop-in-iec-61131-3-for-experts
  · PDF: https://industry.plantautomation-technology.com/whitepapers/1485925902-oop-in-iec-061131-3-for-experts.pdf
- ISA — programming standards: https://www.isa.org/intech-home/2016/september-october/features/programming-standards-improve-automation-controls
- RTA — IEC 61131-3 overview: https://www.rtautomation.com/technologies/control-iec-61131-3/
- Videos: https://www.youtube.com/watch?v=ig8IbhSRxNY (crash course EN) · https://www.youtube.com/watch?v=5p331L0_Bqs (ES) · https://www.youtube.com/watch?v=N0Se8Rj96cU (intro) · https://www.youtube.com/watch?v=NxMdpr9SsdA (mejor lenguaje PLC, ES)

## Preguntas para el brainstorm (antes de OpenSpec)
1. **Dashboard:** ¿`vertivo_dashboard` debería converger hacia un dashboard tipo Autonomy Edge (orquestadores + vPLCs) en vez del actual (Jaspr + D3 ad-hoc)? ¿O integrarse/embeberse con el tenant existente?
2. **Capa de control:** ¿se adopta OpenPLC Runtime como capa de actuación HIL/edge (alineado con el ADR NVIDIA #5/#6), o se extiende el orquestador Python con un `ControlOrchestrator` + abstracción de actuadores?
3. **IEC 61131-3:** ¿las recetas de cultivo (crop recipes) se modelan como POUs/ST, o se quedan en Python? (trade-off: portabilidad PLC vs IP ya en Python).
4. ¿Relación con el twin de fábrica del spike NVIDIA (OpenPLC↔Isaac Sim Modbus HIL)?
