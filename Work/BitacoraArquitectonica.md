# Bitácora Arquitectónica

Registro permanente y acumulativo de reuniones, decisiones de diseño,
cambios arquitectónicos, análisis realizados a las decisiones y pruebas de
concepto, tal como lo pide el profesor en la Clase 5 ("Proceso de diseño
arquitectónico 1"). **Se debe actualizar continuamente durante todo el
semestre** — no reescribir entradas pasadas, solo añadir nuevas.

Cada entrada nueva va arriba (orden cronológico inverso), con este formato:

```
## AAAA-MM-DD — Título breve

**Tipo:** Reunión / Decisión de diseño / Cambio arquitectónico / Análisis / PoC

**Contexto:** ...
**Decisión / resultado:** ...
**Alternativas consideradas:** ...
**Ventajas / desventajas:** ...
**Riesgos técnicos:** ...
**Participantes:** ...
```

---

## 2026-08-20 — Diagramas C4 completados: Panorama de Sistemas, Dinámico y Despliegue

**Tipo:** Cambio arquitectónico

**Contexto:** Se revisó el ejercicio de fin de clase de cada una de las 5
diapositivas del curso. El de la Clase 4 ("Notación y vistas
arquitectónicas") pide explícitamente elaborar **todos** los diagramas del
modelo C4 y validarlos contra el checklist oficial de c4model.com.
`Work/C4Diagrams.tex` solo cubría los 3 diagramas jerárquicos (Contexto,
Contenedores, Componentes) — los 3 diagramas auxiliares (System Landscape,
Dynamic, Deployment) estaban señalados como pendientes en `TASKS.md` desde
la sesión anterior. De paso se encontró una referencia cruzada obsoleta: el
diagrama de componentes citaba el caso de uso complejo como "CU-016" cuando
en realidad es CU-006 (Gestión del Mercado Secundario de Entradas) — un
resto de antes de la renumeración de casos de uso.

**Decisión / resultado:** Se agregaron los 3 diagramas auxiliares a
`Work/C4Diagrams.tex`: (1) **Panorama de Sistemas**, ubicando el Sistema
Integral de Gestión de Eventos junto a otros sistemas plausibles de la
organización (Contabilidad, CRM, BI); (2) **Dinámico**, con la secuencia
numerada de 8 pasos de la reventa de una entrada (CU-006) a nivel de
contenedores; (3) **Despliegue**, aterrizando los contenedores del Nivel 2
en nodos de infraestructura reales (CDN, balanceador/API Gateway, clúster
Kubernetes con un pod por microservicio, clústeres de BD/Redis/mensajería).
Se corrigió la referencia CU-016→CU-006, se reescribió la sección de
verificación contra el checklist oficial para cubrir explícitamente cada
ítem de c4model.com/diagrams/checklist (incluida la aclaración de íconos,
bordes, tamaños y estilos de línea) sobre los 6 diagramas, y se actualizó la
conclusión y la portada. El documento se recompiló sin errores (pdflatex,
3 pasadas, 16 páginas) y reemplazó al PDF anterior en
`Submission/C4Diagrams.pdf`; se conserva una copia del PDF previo en el
scratchpad de la sesión. También se revisó `Work/ArchitecturalProposal.tex`
contra el ejercicio de las Clases 2 y 3 (priorizar atributos de calidad,
definir componentes/conexiones, explicar cómo la arquitectura satisface
cada atributo): ya cumplía los tres puntos explícitamente, no requirió
cambios.

**Alternativas consideradas:** Omitir también el diagrama de Código (Nivel
4) sin justificación — se mantuvo la justificación ya existente (la guía
oficial de C4 solo lo recomienda para componentes críticos y normalmente se
genera desde el código fuente, que este proyecto aún no tiene). Anidar los
5 pods del clúster de Kubernetes con un `tikzpicture` interno en el
diagrama de despliegue — se descartó porque los estilos de nodo definidos
en el `tikzpicture` externo no son visibles dentro de uno anidado (hubiera
fallado la compilación); se optó por dibujar los 5 nodos como hermanos y
agruparlos visualmente con `\node[fit=...]` de la librería `fit` de TikZ.

**Riesgos técnicos:** El panorama de sistemas (Contabilidad, CRM, BI) es
una propuesta razonable del asistente, no un inventario real de sistemas de
la organización — el equipo debe confirmar o ajustar qué sistemas existen
realmente. El diagrama de despliegue asume un ambiente en la nube con
Kubernetes, que es coherente con la arquitectura de microservicios ya
decidida pero aún no ha sido validado por el equipo como la plataforma de
despliegue real.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Casos de uso ampliados a ≥8 pasos según la regla de Clase 1

**Tipo:** Análisis

**Contexto:** Revisando la diapositiva "Características generales del
sistema" de `Work/Slides/01. AS - Introducción al curso y reglas.pdf`, se
confirmó que el curso exige **al menos 8 pasos por caso de uso** (además de
≥5 CU por integrante y ≥1 CU complejo por integrante con atributos de
calidad + infraestructura no triviales). Al contar los pasos reales del
`FLUJO BÁSICO DE ÉXITO` en las 25 hojas de `Submission/CU_eventos_completo.xlsx`
(ver entrada anterior), 13 casos de uso quedaban por debajo del mínimo (entre
4 y 6 pasos): CU-002, CU-003, CU-004, CU-005 (bloque Boletería), CU-016,
CU-017, CU-019, CU-020 (bloque Logística) y CU-021 a CU-025 (bloque
Parqueadero). De paso se encontró un bug de datos: en CU-024 el paso 1
("El sistema calcula el valor a pagar…") estaba puesto en la columna del
ACTOR en vez de la del SISTEMA.

**Decisión / resultado:** Se amplió el flujo básico de los 13 CU a 8-10 pasos
cada uno, añadiendo pasos de validación, confirmación y notificación
coherentes con el objetivo/pre-condiciones/post-condiciones ya definidos de
cada caso (sin inventar comportamiento nuevo, solo detallando el que ya
estaba implícito). Donde el flujo alterno decía "No hay flujos alternativos
conocidos" (CU-003, CU-004, CU-005) se redactaron 1-2 alternos reales; donde
ya existían alternos/excepciones se les sumó 1-2 más para reforzar la lectura
de "caso complejo". Se corrigió el bug de columna en CU-024. Con esto, las 25
hojas del documento cumplen el mínimo de 8 pasos (verificado programáticamente
tras el cambio), y la mayoría queda con 9-13 pasos + varios alternos +
excepciones + atributos de calidad + infraestructura no trivial, cumpliendo
el criterio de "caso de uso complejo" para más de un CU por bloque. Se
conserva una copia del archivo previo a esta ampliación en el scratchpad de
la sesión.

**Riesgos técnicos:** Los pasos nuevos fueron redactados por el asistente a
partir del contexto de cada CU, no por el equipo — conviene que el dueño de
cada bloque (según lo indicado: CU-001 a CU-005 de un integrante, CU-006 a
CU-010 de Samuel, CU-011 a CU-025 de otro integrante) los revise antes de la
entrega. Sigue pendiente confirmar cuántos integrantes tiene el equipo
realmente: si son más de 5, 25 CU no alcanzan el mínimo de "5 CU por
integrante" y haría falta sumar más casos de uso.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Reorganización y corrección de `CU_eventos_completo.xlsx`

**Tipo:** Análisis

**Contexto:** El archivo `Submission/CU_eventos_completo.xlsx` reunía 25 casos
de uso escritos por distintos subequipos (Boletería/Entradas, Personal,
Pedidos/Comida "HEXACORE", Logística, Parqueadero) en momentos distintos, sin
una revisión de consistencia final. Al revisarlo hoja por hoja se encontraron
errores reales, no solo de formato: IDs internos que no coincidían con la
pestaña (CU7 tenía Id interno `CU-017`; CU8 tenía `CU-08`; el CU de logística
"Asignar personal operativo" tenía Id `CU-002`, que chocaba con el CU-002 real
de boletería; el CU de parqueadero "Control de ocupación" tenía Id `CU-005`,
que chocaba con el CU-005 real de boletería); referencias cruzadas rotas
copiadas de otra plantilla y nunca actualizadas (CU8 citaba "CU-018A..G" y
"CU-07" en vez de CU-008; CU12 citaba "CU-001"/"CU-002A..D" en vez de CU-011/
CU-012A..D; CU14 tenía el alterno "CU-04D" mal escrito); metadatos de
"Proyecto" con 3 redacciones distintas para el mismo sistema; hojas en un
orden no secuencial (CU6..CU15, CU1..CU5, LOG, PARK); y solo un caso de uso
(CU6, mercado secundario de entradas) tenía las secciones "Atributos de
Calidad Asociados" e "Infraestructura No Trivial Utilizada" que las otras 24
hojas no tenían.

**Decisión / resultado:** Con el usuario se confirmaron dos decisiones antes
de tocar el contenido: (1) renumerar los 25 CU de forma secuencial y sin
choques, `CU-001`–`CU-025` (001–006 Boletería/Entradas, 007–010 Personal,
011–015 Pedidos/Comida, 016–020 Logística, 021–025 Parqueadero), corrigiendo
todas las referencias cruzadas para que apunten al ID correcto; y (2) redactar
"Atributos de Calidad Asociados" e "Infraestructura No Trivial Utilizada" para
los 24 casos de uso que no los tenían, en vez de quitarlos de CU6, dado el
peso que tienen esos dos campos en un curso de Arquitectura de Software. Se
estandarizó también el campo "Proyecto" a un único texto y la versión de cada
ficha a `2.0`. El archivo corregido reemplazó al original en
`Submission/CU_eventos_completo.xlsx`; se conserva una copia del original sin
tocar en el scratchpad de la sesión por si se necesita comparar.

**Alternativas consideradas:** Mantener la numeración original por subequipo
(CU-001..CU-015 + prefijos `CU-LOG-XXX`/`CU-PARK-XXX`) y solo arreglar los IDs
que chocaban — se descartó porque perpetuaba dos convenciones de nombrado
distintas en el mismo documento. Quitar las secciones de calidad/infraestructura
de CU6 en vez de generalizarlas — se descartó porque esos campos son
justamente el eje de evaluación del curso.

**Riesgos técnicos:** El texto de "Atributos de Calidad" e "Infraestructura"
para los 24 CU nuevos fue redactado por el asistente a partir de la
descripción de cada caso de uso, no por el equipo; conviene que cada
responsable de módulo lo revise antes de entregar. También se detectó una
posible duplicación de alcance entre el módulo de Personal (CU-007 a CU-009)
y el de Logística (CU-017/CU-018), que cubren asignación y turnos del
personal desde dos ángulos — no se fusionaron ni se eliminaron, queda
pendiente que el equipo decida si son complementarios o redundantes.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-18 — Bitácora creada; decisiones iniciales ya documentadas

**Tipo:** Análisis

**Contexto:** Al estudiar las diapositivas de clase (`Work/Slides/`) se
identificó que el curso exige mantener esta bitácora de forma permanente, y
que aún no existía en el repositorio.

**Decisión / resultado:** Se crea este archivo. Las decisiones arquitectónicas
ya tomadas para "Sistema Integral de Gestión de Eventos" están descritas en
`Work/ArchitecturalProposal.tex` (sección "Resumen de decisiones
arquitectónicas") y en `Work/C4Diagrams.tex`, pero **no estaban registradas
aquí con su justificación cronológica** (por qué, alternativas, riesgos). Se
recomienda, en la próxima sesión de trabajo del equipo, migrar cada decisión
relevante de esos documentos a una entrada propia en esta bitácora,
incluyendo alternativas consideradas y riesgos — no solo el resultado final.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-18 — Decisiones arquitectónicas fundacionales (migradas desde ArchitecturalProposal.tex)

**Tipo:** Decisión de diseño

**Contexto:** Migración pendiente señalada en la entrada anterior y en el
ejercicio de la Clase 5 ("refinar el documento de diseño"): las decisiones
de `Work/ArchitecturalProposal.tex` (sección "Resumen de decisiones
arquitectónicas") solo estaban registradas como una tabla de
decisión/problema/atributos, sin alternativas ni riesgos explícitos. Se
migran aquí con esa justificación completa.

**Decisión / resultado:** Para satisfacer consistencia, disponibilidad,
seguridad y rendimiento (prioridad Alta) más tiempo real, escalabilidad y
trazabilidad (prioridad Media), se adoptó:

1. **Arquitectura de microservicios** (uno por dominio: Entradas, Mercado
   Secundario, Personal, Eventos, Parqueaderos, Emergencias), cada uno con
   base de datos propia.
2. **API Gateway** como único punto de entrada al backend, centralizando
   autenticación, autorización y enrutamiento.
3. **Balanceador de carga** frente a las instancias de cada microservicio.
4. **Redis** para bloqueo temporal de recursos en disputa (p. ej. una
   entrada en reventa) y para datos de acceso rápido (aforo, sesiones).
5. **Cola de mensajes (RabbitMQ/Kafka)** para desacoplar operaciones
   asíncronas: generación de QR, notificaciones, auditoría, liquidación de
   pagos, alertas de emergencia.
6. **Base de datos independiente por servicio**, para reducir acoplamiento.
7. **Servicios externos** de pasarela de pagos y notificaciones
   (push/correo/SMS), integrados vía API.
8. **Cuatro interfaces especializadas** (Portal Web Cliente, Portal Web
   Administrativo/Operativo, App Móvil Cliente, App Móvil Personal), todas
   consumiendo el mismo backend a través del API Gateway.

**Alternativas consideradas:**
- **Monolito modular** en vez de microservicios: se descartó porque
  dificulta escalar de forma independiente el servicio de Entradas durante
  una apertura de venta sin sobre-aprovisionar los demás dominios.
- **Una sola base de datos compartida**: se descartó por acoplamiento —
  un cambio de esquema en un dominio (p. ej. Parqueaderos) no debería
  arriesgar la disponibilidad de Entradas.
- **Comunicación síncrona pura (sin colas)** para notificaciones/QR: se
  descartó porque un fallo temporal del proveedor de notificaciones no debe
  bloquear ni fallar la operación principal (compra, transferencia).
- **Una sola interfaz web genérica para todos los roles**: se descartó por
  usabilidad — clientes, personal y administración tienen necesidades muy
  distintas y exponer todas las funciones a todos los roles es
  confuso e inseguro.

**Ventajas / desventajas:** La separación en microservicios y BD por
dominio favorece mantenibilidad y escalabilidad independiente, a costa de
mayor complejidad operativa (más piezas de infraestructura que desplegar y
monitorear) y de tener que gestionar consistencia eventual entre servicios
en vez de transacciones ACID únicas. Redis y las colas resuelven
consistencia/concurrencia y desacoplamiento, pero introducen puntos
adicionales de falla que deben tener su propia estrategia de disponibilidad
(replicación, clúster).

**Riesgos técnicos:** Concurrencia entre compradores en el mercado
secundario (mitigado con bloqueo en Redis); disponibilidad del API Gateway
como punto único de entrada (mitigado con balanceador + múltiples
instancias); dependencia de servicios externos de pago y notificaciones
para completar flujos críticos (compra, reventa); sobrecarga de picos de
tráfico en la apertura de venta o el ingreso masivo al evento.

**Participantes:** Samuel Contreras (vía asistente).
