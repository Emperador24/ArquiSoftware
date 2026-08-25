# Bitácora Arquitectónica

Registro permanente y acumulativo de reuniones, decisiones de diseño,
cambios arquitectónicos, análisis realizados a las decisiones y pruebas de
concepto, tal como lo pide el profesor en la Clase 5 ("Proceso de diseño
arquitectónico 1"). **Se debe actualizar continuamente durante todo el
semestre** — no reescribir entradas pasadas, solo añadir nuevas.

> **Unión con la Bitácora Grupal.** Esta bitácora vive en el repositorio del
> proyecto (`ArquiSoftware`) y es donde empezó el seguimiento real del
> trabajo. El registro oficial de las **reuniones del equipo** (agenda,
> acuerdos, tareas asignadas) vive aparte, en
> [`BitacoraGrupal.md`](https://github.com/Emperador24/Bitacora-Hexacore/blob/main/BitacoraGrupal.md)
> (repositorio `Bitacora-Hexacore`), cuya sección "Registro consolidado de
> decisiones del equipo" resume y enlaza de vuelta a las entradas de aquí.

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

## 2026-08-25 — Primera versión del SAD (plantilla arc42) y primer Árbol de Utilidad

**Tipo:** Análisis / Cambio arquitectónico

**Contexto:** el curso exige un documento único de Descripción de la
Arquitectura del Software (SAD) siguiendo la plantilla arc42
(`Work/DescripcionArquitecturaSoftware.tex`, hasta ahora sin llenar). El
trabajo arquitectónico ya elaborado vivía repartido en varios archivos
(`ArchitecturalProposal.tex`, `C4Diagrams.tex`, `DistribucionCasosUso.tex` y
esta bitácora) sin consolidarse en el formato exigido para Entrega 1.

**Decisión / resultado:** se consolidó una versión 1.0 del SAD en
`Work/DescripcionArquitecturaSoftware.tex`, reutilizando el contenido ya
elaborado: introducción y atributos de calidad (de
`ArchitecturalProposal.tex`), los 32 CU agrupados por bloque temático (de
`DistribucionCasosUso.tex`), las seis vistas C4 con sus imágenes (de
`C4Diagrams.tex`), y los cuatro ADR fundacionales, redactados a partir de la
entrada del 2026-08-18 de esta misma bitácora. Se añadió contenido nuevo que
no existía antes en ningún archivo: un primer Árbol de Utilidad formal
(ASR-01 a ASR-10, derivado de los 10 atributos de calidad priorizados) y una
tabla de restricciones del proyecto. Quedan marcadas explícitamente como
pendientes (no se inventó contenido): el diagrama de clases UML del dominio,
el desglose de componentes de los contenedores distintos a
Entradas/Mercado Secundario, los ambientes de despliegue de desarrollo y
pruebas, y los modelos de datos por servicio. Compila sin errores (19
páginas). Todavía no se copia a `Submission/` por ser un borrador, no la
entrega terminada.

**Alternativas consideradas:** dejar el contenido arquitectónico repartido
en los archivos originales y no usar la plantilla arc42 — se descartó
porque el curso exige explícitamente ese formato para la Entrega 1.

**Ventajas / desventajas:** consolidar todo en un solo documento facilita la
entrega y la sustentación, pero implica mantener la información
sincronizada en dos lugares (el documento consolidado y los archivos
fuente originales) hasta que estos últimos se retiren o se dejen solo como
insumo interno.

**Riesgos técnicos:** ninguno nuevo; se heredan los ya documentados en la
entrada del 2026-08-18.

**Participantes:** Samuel Emperador (vía asistente).

---

## 2026-08-22 — Corrección de resolución: los 6 diagramas C4 no se leían bien

**Tipo:** Cambio arquitectónico (documentación, sin cambio de arquitectura)

**Contexto:** Tras la primera versión de los diagramas en draw.io (entrada anterior de hoy), el
usuario reportó que el texto dentro de cada caja no se alcanzaba a leer en el PDF. La causa real
no era el tamaño de fuente sino la resolución de captura: las imágenes se habían generado con
una captura de pantalla del lienzo ajustado a la ventana (~55–60% de zoom), lo que dejaba muy
pocos píxeles reales por letra una vez que LaTeX escalaba la imagen al ancho de la página.

**Decisión / resultado:** Se cambió el método de exportación por el nativo de draw.io: **File →
Export as → PNG** con zoom 250%, seguido de **Copy** (copia la imagen al portapapeles del
sistema) y extracción con `osascript` (`the clipboard as «class PNGf»`) directamente a
`Work/Diagrams/`. Esto genera PNG a resolución real (3500–5000 px de ancho según el diagrama, en
vez de ~1400 px) sin depender del tamaño de la ventana del navegador ni de la carpeta de
Descargas (inaccesible por permisos del sistema para este entorno). De paso se aprovechó para
agrandar cajas y fuentes, añadir fondo blanco a las etiquetas de las flechas
(`labelBackgroundColor`) y corregir varias flechas que atravesaban el texto de cajas vecinas
(añadiendo puntos de recodo explícitos). Verificado renderizando el PDF final a 300 DPI: el texto
se ve nítido incluso con zoom alto. Recompilado sin errores (16 páginas) y republicado en
`Submission/C4Diagrams.pdf`; los 6 `.drawio` en `Work/Diagrams/` también se actualizaron con el
nuevo tamaño de caja/fuente y quedan editables.

**Alternativas consideradas:**
- **Agrandar la ventana del navegador** para capturar a mayor resolución: se probó primero: el
  gestor de ventanas del entorno solo permitió ~1568 px de ancho efectivo (aumento marginal,
  insuficiente).
- **Exportar el PNG en base64 y leerlo por el canal de la herramienta de JavaScript**: bloqueado
  deliberadamente por un filtro de seguridad que impide devolver datos largos en base64 (para
  evitar exfiltración) — se respetó esa restricción en vez de rodearla.
- **Descargar el PNG al disco vía el diálogo de exportación**: la carpeta de Descargas de macOS
  no es accesible para este entorno (restricción de permisos del sistema operativo), y un puente
  vía servidor local HTTP falló por la política de "mixed content" del navegador (la página de
  draw.io es HTTPS y no permite conexiones salientes a `http://localhost`). El portapapeles del
  sistema no tiene esa restricción y sí funcionó.

**Ventajas / desventajas:** La calidad final es muy superior (imágenes nítidas incluso con zoom
alto en el PDF) sin tener que rediseñar el contenido de los diagramas. Como desventaja, el archivo
del PDF creció de ~1.1 MB a ~1.7 MB por el mayor tamaño de las imágenes; no es un problema para
la entrega.

**Riesgos técnicos:** Ninguno funcional. Si se vuelve a editar un `.drawio`, hay que repetir el
mismo flujo de exportación (zoom 250% + Copy + `osascript`) para mantener la resolución; una
captura de pantalla simple del lienzo vuelve a producir el mismo problema de baja resolución.

**Participantes:** Samuel Contreras (vía asistente), a partir de retroalimentación directa del
usuario ("no se puede leer bien lo que está dentro de cada rectángulo").

---

## 2026-08-22 — Diagramas C4 rehechos en draw.io con retroalimentación del profesor

**Tipo:** Cambio arquitectónico (documentación, sin cambio de arquitectura)

**Contexto:** El profesor revisó `Work/C4Diagrams.tex` (basado en tikz) y dio dos indicaciones
puntuales: (1) cada caja de cada diagrama debe mostrar una pequeña descripción y la tecnología,
no solo el nombre; y (2) el Diagrama Dinámico debe reemplazarse por un diagrama de secuencia.
También pidió que todos los diagramas se hicieran en draw.io (la aplicación web
`app.diagrams.net`), no como código tikz.

**Decisión / resultado:** Se rehicieron los 6 diagramas (Contexto, Contenedores, Componentes,
Panorama de Sistemas, Secuencia y Despliegue) directamente en app.diagrams.net: se construyó el
XML de mxGraph de cada uno, se cargó en el editor vía "Extras → Edit Diagram", se ajustó el
layout (`Ctrl+Shift+H`) y se exportó una captura limpia de cada lienzo. Cada caja de cada
diagrama ahora muestra tres líneas: nombre en negrita, `[Tipo: Tecnología]` en cursiva, y una
breve descripción de su responsabilidad. El antiguo Diagrama Dinámico se reemplazó por un
diagrama de secuencia UML con líneas de vida punteadas, mensajes numerados (1–8) y una barra de
activación sobre el Servicio de Entradas, para el mismo caso de uso (CU-006, reventa de una
entrada). Los 6 archivos fuente `.drawio` y sus PNG exportados quedan en `Work/Diagrams/` para
edición futura; `Work/C4Diagrams.tex` ahora usa `\includegraphics` en vez de `tikzpicture` para
estas seis figuras, y la sección del checklist y la conclusión se actualizaron para reflejar el
nuevo formato de caja y el cambio Dinámico→Secuencia. Recompilado sin errores (15 páginas) y
republicado en `Submission/C4Diagrams.pdf`.

**Alternativas consideradas:**
- **Mantener tikz y solo añadir descripción/tecnología como texto adicional dentro de los nodos**:
  se descartó porque el profesor pidió explícitamente que los diagramas se hicieran en draw.io,
  no que se ajustara el código tikz existente.
- **Generar los `.drawio` por script sin abrir la aplicación web**: más rápido, pero no cumple la
  instrucción literal de "hazlos en la página web de draw.io"; se optó por cargar el XML dentro
  del editor real (`app.diagrams.net`) vía "Edit Diagram" y exportar desde ahí, de forma que el
  trabajo quede hecho efectivamente en la herramienta pedida.
- **Diagrama Dinámico de C4 con numeración pero sin líneas de vida** (la variante que ya existía):
  se descartó a favor de un diagrama de secuencia UML completo, más preciso y estándar, tal como
  pidió el profesor.

**Ventajas / desventajas:** Los diagramas ahora comunican mucha más información por caja (tipo,
tecnología, responsabilidad) sin necesitar la tabla de relaciones para entender cada elemento
individual, y quedan editables visualmente en draw.io por cualquier integrante del equipo sin
tocar LaTeX/tikz. La desventaja es que ya no son texto versionable línea a línea en el `.tex`
(las figuras son imágenes PNG); se mitiga guardando también el `.drawio` fuente de cada diagrama
en el repositorio.

**Riesgos técnicos:** Ninguno funcional — es un cambio de documentación/notación, no de
arquitectura. Riesgo menor: si se vuelve a editar un diagrama, hay que reexportar el PNG y
recompilar el PDF para que `Submission/C4Diagrams.pdf` no quede desactualizado respecto al
`.drawio` fuente.

**Participantes:** Samuel Contreras (vía asistente), a partir de retroalimentación directa del
profesor sobre `Work/C4Diagrams.tex`.

---

## 2026-08-20 — Reparto de CU-021 a CU-032 confirmado con el equipo

**Tipo:** Reunión

**Contexto:** El reparto de los 12 casos de uso restantes (CU-021 a
CU-032, entre ellos el bloque de Parqueaderos y los 7 CRUD añadidos
previamente) había sido una **propuesta del asistente**, no una
instrucción explícita del usuario caso por caso: Daniel Cristancho +
CU-021–023, Samuel Emperador + CU-024–026, Sebastián Sánchez + CU-027–029,
Diego Coronado + CU-030–032 (ver `Work/DistribucionCasosUso.pdf`). Se
ofrecieron varias vías para validarlo con el resto del equipo (dejarlo
como punto pendiente en `BitacoraGrupal.md`, abrir un issue en el
repositorio `Bitacora-Hexacore`, o redactar un mensaje para que el usuario
lo enviara); el usuario indicó que **ya lo había confirmado directamente
con el equipo** por su cuenta.

**Decisión / resultado:** El reparto queda **confirmado y definitivo**, sin
cambios respecto a lo propuesto. Se actualiza `TASKS.md`: la fila del
spreadsheet de casos de uso vuelve a `submitted`, y se cierra el pendiente
de "confirmar con el equipo" en el backlog. No se modificó
`Submission/CU_eventos_completo.xlsx` ni `Work/DistribucionCasosUso.pdf`
en esta entrada, ya que el contenido de ambos ya reflejaba este reparto.

**Riesgos técnicos:** Esta confirmación quedó registrada solo de palabra
del usuario dentro de esta conversación — no hay un registro externo
(mensaje de equipo, acta de reunión) enlazado desde aquí. Si el curso pide
evidencia de la reunión/acuerdo del equipo, conviene complementar esta
entrada con un acta en `BitacoraGrupal.md` (repositorio `Bitacora-Hexacore`).

**Participantes:** Samuel Contreras (vía asistente); equipo completo
(Daniel Cristancho, Samuel Emperador, Sebastián Sánchez, Diego Coronado)
según lo reportado por el usuario.

---

## 2026-08-20 — Campo "Autor" actualizado con los nombres reales del equipo

**Tipo:** Cambio arquitectónico

**Contexto:** El usuario pidió actualizar el campo "Autor" (celda B5) de
`Submission/CU_eventos_completo.xlsx`, que en las 32 hojas decía
`Hexacore`/`HEXACORE` (nombre de equipo genérico), con los nombres reales
ya conocidos por la entrada anterior de distribución de casos de uso.

**Decisión / resultado:** Se actualizó B5 en las 32 hojas (`CU-001` a
`CU-032`) con el dueño real, según el mismo reparto documentado en la
entrada anterior y en `Work/DistribucionCasosUso.pdf`:
- CU-001..005, CU-021..023 → **Daniel Cristancho**.
- CU-006..010, CU-024..026 → **Samuel Emperador** (ya decía "Samuel
  Emperador" en CU-006..010, sin cambios ahí).
- CU-011..015, CU-027..029 → **Sebastián Sánchez**.
- CU-016..020, CU-030..032 → **Diego Coronado**.

No se tocó ningún otro campo (nombre, versión, fecha, contenido del flujo,
etc.), ni las hojas obsoletas `CU1`..`CU5` mencionadas en entradas
anteriores — de hecho, al releer el archivo para esta operación se
confirmó que esas pestañas duplicadas **ya no existen** en el libro (32
hojas en total, `CU-001` a `CU-032`); no fue un cambio de esta sesión, el
archivo cambió en disco por fuera de esta conversación en algún punto
anterior.

**Riesgos técnicos:** Esta asignación de "Autor" para CU-021..CU-032 sigue
heredando el mismo supuesto no confirmado de la entrada anterior: el
reparto de esos 12 casos de uso fue una propuesta del asistente, no una
instrucción explícita del usuario caso por caso. Si el equipo decide
repartirlos distinto, hay que volver a correr esta actualización.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Distribución de los 32 casos de uso entre los 4 integrantes

**Tipo:** Análisis

**Contexto:** El usuario dio, por primera vez, los nombres reales del
equipo y su dueño explícito para los primeros 20 casos de uso: **Daniel
Cristancho** (CU-001 a CU-005), **Samuel Emperador** (CU-006 a CU-010),
**Sebastián Sánchez** (CU-011 a CU-015) y **Diego Coronado** (CU-016 a
CU-020). Pidió repartir entre los cuatro los 12 casos de uso restantes
(CU-021 a CU-032, que incluyen el bloque de Parqueaderos y los 7 CRUD
añadidos en la entrada anterior) y generar un PDF con encargado, nombre y
descripción de cada caso de uso.

**Decisión / resultado:** Se repartieron los 12 CU restantes en bloques
contiguos de 3, para que cada integrante termine con 8 casos de uso
temáticamente agrupados (más fácil de defender en la sustentación que una
asignación dispersa):
- Daniel Cristancho: + CU-021, CU-022, CU-023 (Parqueadero: reserva,
  ingreso/salida de vehículos, asignación de espacios).
- Samuel Emperador: + CU-024, CU-025, CU-026 (Parqueadero: cobro, control
  de ocupación; y Gestión de Eventos CRUD).
- Sebastián Sánchez: + CU-027, CU-028, CU-029 (Cuentas de Usuario, Roles y
  Permisos, Recintos y Zonas).
- Diego Coronado: + CU-030, CU-031, CU-032 (Proveedores, Pagos y
  Conciliación Financiera, Reportes y Analítica).

Se generó `Work/DistribucionCasosUso.tex` → `Work/DistribucionCasosUso.pdf`
(7 páginas), con una tabla resumen de la distribución y, por integrante,
una tabla con Id, nombre y descripción (tomada del campo "Objetivo en
Contexto" de cada hoja de `CU_eventos_completo.xlsx`) de sus 8 casos de
uso. No es un entregable del curso — es un documento de organización
interna del equipo.

**Alternativas consideradas:**
- **Reparto round-robin** (CU-021→Daniel, CU-022→Samuel, CU-023→Sebastián,
  CU-024→Diego, CU-025→Daniel, …): se descartó porque dispersa los CU de
  un mismo bloque temático (p. ej. Parqueadero) entre varias personas,
  dificultando que cada integrante defienda su módulo como una unidad
  coherente en la sustentación.

**Riesgos técnicos:** El reparto de CU-021 a CU-032 fue una **propuesta del
asistente**, no una instrucción explícita del usuario por caso — el equipo
debería confirmarla. El campo "Autor" dentro de `CU_eventos_completo.xlsx`
sigue diciendo `Hexacore` para todas las hojas y no se actualizó con estos
nombres reales en esta entrada (queda como tarea en `TASKS.md`).

**Participantes:** Samuel Contreras (vía asistente); nombres del equipo
(Daniel Cristancho, Samuel Emperador, Sebastián Sánchez, Diego Coronado)
dados por el usuario.

---

## 2026-08-20 — 7 casos de uso nuevos (CU-026 a CU-032) para cerrar huecos de CRUD

**Tipo:** Cambio arquitectónico

**Contexto:** El usuario pidió revisar el proyecto en busca de casos de uso
faltantes, señalando específicamente que "hacen falta los CRUD de muchas
cosas". Revisando las 25 hojas de `Submission/CU_eventos_completo.xlsx`
contra `Work/ArchitecturalProposal.tex` y `Work/Summary.tex`, se confirmaron
huecos reales: no existía ningún caso de uso para **crear/editar/publicar
un evento** (CU-005 "Consultar evento" es de solo lectura), ni para
**registro/login/recuperación de cuenta**, **roles y permisos (RBAC)**,
**recintos y zonas/mapa de asientos** (referenciados por CU-001 y CU-026
pero nunca definidos como entidad administrable), **proveedores externos**
(mencionados como insumo de CU-016 pero sin CU propio), **conciliación
financiera/reembolsos administrativos** (distinto de la cancelación
disparada por el cliente en CU-003), ni **reportes/analítica** del evento
para organizador/administrador. `Work/Summary.tex` incluso menciona
"CRUDs del sistema" y "gestión general (usuarios, roles, configuración)"
como funciones del Portal Web Administrativo sin que existiera un CU que
las respaldara.

**Decisión / resultado:** Se añadieron 7 casos de uso nuevos al final del
libro (CU-026 a CU-032), cada uno con el mismo formato que los 25
existentes (objetivo, actores, requisitos asociados, entradas/salidas,
pre/post-condiciones, flujo básico de 8-10 pasos ACTOR/SISTEMA, flujos
alternos, camino de excepción, atributos de calidad e infraestructura no
trivial), generados programáticamente copiando el estilo/formato de
`CU-016` para no perder ninguna convención visual del archivo:

1. **CU-026 — Gestión de Eventos (CRUD):** crear/editar/publicar/cancelar
   eventos, con validación de aforo vs. capacidad del recinto y de
   traslape de fechas.
2. **CU-027 — Gestión de Cuentas de Usuario:** registro, login,
   recuperación de contraseña, edición de perfil, activar/desactivar
   cuenta.
3. **CU-028 — Gestión de Roles y Permisos:** CRUD de roles y su matriz de
   permisos por módulo (RBAC).
4. **CU-029 — Gestión de Recintos y Zonas:** CRUD de recintos, zonas y
   capacidad por zona, insumo de CU-026.
5. **CU-030 — Gestión de Proveedores:** CRUD de proveedores externos,
   insumo de CU-016 (planificación logística).
6. **CU-031 — Gestión de Pagos y Conciliación Financiera:** conciliación
   de transacciones contra la pasarela de pagos y reembolsos
   administrativos, distinto del flujo de cancelación iniciado por el
   cliente (CU-003).
7. **CU-032 — Gestión de Reportes y Analítica del Evento:** dashboards de
   ventas/ocupación/personal/incidentes para organizador y administrador.

El total del libro pasa de 25 a **32 casos de uso**. `Cronograma.md` y
`TASKS.md` no se modificaron con esta entrada (son planificación, no
casos de uso); si el reparto de atributos de calidad por integrante en
`Cronograma.md` cambia por esto, actualizarlo aparte.

**Alternativas consideradas:**
- **No separar "Gestión de Pagos y Conciliación" de CU-003 (Cancelaciones
  y devoluciones):** se descartó porque son operaciones con actores y
  disparadores distintos (cliente vs. administrador financiero, evento
  puntual vs. proceso periódico de conciliación) — fusionarlas habría
  ocultado el atributo de calidad de trazabilidad financiera.
- **Tratar Recintos/Zonas como un campo de texto libre dentro de CU-026 en
  vez de un CU propio:** se descartó porque el mapa de zonas se reutiliza
  entre eventos y tiene su propio ciclo de vida (crear, editar, dar de
  baja), cumpliendo el criterio de entidad administrable independiente.

**Riesgos técnicos:** El campo "Autor" de las 7 hojas nuevas quedó como
`Hexacore` (placeholder de equipo) igual que la mayoría de las hojas
existentes — falta asignar el dueño real por integrante, igual que ya
estaba pendiente para el resto del archivo. Los pasos y flujos fueron
redactados por el asistente a partir del contexto arquitectónico ya
documentado, no por el equipo — conviene que cada integrante revise el CU
que le corresponda antes de la entrega. No se validó aún si estos CU
requieren ajustes en `Work/ArchitecturalProposal.tex` (p. ej. un
microservicio de "Recintos" o de "Roles/Permisos" explícito) ni en los
diagramas C4 — queda como tarea de seguimiento.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Corrección de dirección: CU-013 y CU-015 sobrescritas con CU-003 y CU-005

**Tipo:** Cambio arquitectónico

**Contexto:** El usuario indicó que la reasignación de la entrada anterior fue en la dirección
equivocada: no se trataba de llevar `CU-013`/`CU-014` hacia las pestañas `CU3`/`CU5`, sino al
revés, y con un destino distinto para el segundo caso. Se confirmó explícitamente con el usuario el
resultado exacto antes de aplicarlo, incluyendo que esto **reemplaza y hace perder** el contenido
que tenían `CU-013` y `CU-015`.

**Decisión / resultado:** Se deshizo el cambio anterior (`CU3` y `CU5` vuelven a ser copia exacta
de `CU-003` y `CU-005`, como antes de esa entrada) y, adicionalmente, se sobrescribió el contenido
de la hoja **`CU-013`** con el de `CU-003` (Cancelaciones y devoluciones) y el de la hoja
**`CU-015`** con el de `CU-005` (Consultar evento) — verificado celda por celda (0 diferencias) y
sin solapes de celdas fusionadas. `CU-014` no se tocó en ningún momento y sigue siendo "Validar y
entregar pedido", sin cambios.

**Riesgos técnicos:** Esto reintroduce a propósito el mismo tipo de inconsistencia que se corrigió
al inicio de la sesión: la pestaña `CU-013` ahora contiene internamente el Id `CU-003` (no
`CU-013`), y la pestaña `CU-015` contiene el Id `CU-005`. Además, **se perdieron** de este archivo
los casos de uso originales "Gestionar preparación del pedido" (antes en `CU-013`) y "Gestionar
cancelaciones y reembolsos" (antes en `CU-015`) del módulo de Pedidos — no aparecen en ninguna otra
pestaña del libro. Se conservan copias del archivo en cada paso intermedio en el scratchpad de la
sesión por si hace falta recuperarlos. El equipo debería confirmar que esta pérdida es intencional
antes de la entrega final.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Contenido de las pestañas finales CU3 y CU5 reasignado a petición del usuario

**Tipo:** Cambio arquitectónico

**Contexto:** Tras sincronizar las 5 pestañas finales `CU1`..`CU5` (ver entrada anterior) para que
no contradijeran a `CU-001`..`CU-005`, el usuario pidió explícitamente reemplazar el contenido de
dos de esas pestañas: `CU3` (hasta entonces copia de `CU-003`) por `CU-013`, y `CU5` (hasta entonces
copia de `CU-005`) por `CU-014`.

**Decisión / resultado:** Se reemplazó el contenido de la pestaña `CU3` por una copia exacta de
`CU-013` (Gestionar preparación del pedido) y el de `CU5` por una copia exacta de `CU-014`
(Validar y entregar pedido) — mismos valores, estilos, fusiones y alturas de fila, verificado
celda por celda (0 diferencias). Las pestañas `CU1`, `CU2` y `CU4` quedaron sin cambios (siguen
siendo copias de `CU-001`, `CU-002` y `CU-004`). Se conserva una copia del archivo previo a este
cambio en el scratchpad de la sesión.

**Riesgos técnicos:** No se conoce la razón de negocio detrás de esta reasignación puntual (fue una
instrucción directa del usuario, no una corrección de un error detectado por el asistente) — el
archivo sigue teniendo 30 pestañas en total (`CU-001`..`CU-025` más 5 duplicados bajo nombres de
pestaña antiguos), de las cuales ahora `CU3` y `CU5` en realidad representan `CU-013` y `CU-014`.
Si el equipo no recuerda por qué se hizo, vale la pena revisarlo antes de la entrega final para que
no genere confusión.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Sincronización de hojas obsoletas reaparecidas en CU_eventos_completo.xlsx

**Tipo:** Análisis

**Contexto:** Antes de comitear el trabajo de la sesión se detectó que
`Submission/CU_eventos_completo.xlsx` había cambiado en disco sin
intervención del asistente: pasó de 25 a 30 hojas. Las 5 hojas nuevas
(`CU1`..`CU5`) resultaron ser copias **previas a todas las correcciones**
de esta sesión — mismo contenido que `CU-001`..`CU-005` pero con el
"Proyecto" sin estandarizar (`Organización de eventos - HEXACORE` en vez de
`Sistema Integral de Gestión de Eventos`) y la versión en `1.0` en vez de
`2.0`. La causa más probable es una sincronización de OneDrive que fusionó
una copia en caché anterior a la reorganización. No había ningún archivo de
conflicto de OneDrive junto al original que lo confirmara.

**Decisión / resultado:** Se consultó al usuario antes de tocar el archivo.
En vez de borrar las 5 hojas repetidas, se sincronizó su contenido para que
cada una sea una copia exacta (valores, estilos, fusiones de celdas y
alturas de fila) de su hoja corregida correspondiente
(`CU1`←`CU-001`, ..., `CU5`←`CU-005`), verificado celda por celda (0
diferencias) y sin solapes de celdas fusionadas. El archivo quedó con 30
hojas: las 25 `CU-001`..`CU-025` más 5 duplicados exactos bajo el nombre de
pestaña antiguo. Se conserva una copia del archivo de 30 hojas sin
sincronizar en el scratchpad de la sesión.

**Riesgos técnicos:** El archivo sigue teniendo pestañas duplicadas
(`CU1`..`CU5` junto a `CU-001`..`CU-005`) — ya no contradictorias entre sí,
pero sí redundantes. Si vuelve a ocurrir una sincronización similar, o si el
equipo decide que las pestañas duplicadas no deberían entregarse así,
convendría eliminarlas explícitamente en vez de mantenerlas sincronizadas.
También vale la pena que el usuario revise la configuración de sincronización
de OneDrive para esta carpeta, ya que el archivo cambió sin que nadie lo
editara conscientemente.

**Participantes:** Samuel Contreras (vía asistente).

---

## 2026-08-20 — Guía de estudio para la sustentación + referencias CU obsoletas en Summary.tex

**Tipo:** Análisis

**Contexto:** Al preparar material de estudio para la sustentación se encontró que
`Work/Summary.tex` (el resumen ejecutivo del proyecto, ya en `Submission/Summary.pdf`) todavía
citaba los 5 casos de uso del módulo de Personal con la numeración antigua (`CU-016` a `CU-020`),
previa a la renumeración de casos de uso a `CU-001..CU-025` hecha antes en esta misma sesión. Esto
dejaba dos documentos ya entregados (`Summary.pdf` y `CU_eventos_completo.xlsx`) contradiciéndose
sobre el ID de los mismos casos de uso.

**Decisión / resultado:** Se corrigieron las 8 referencias de `CU-016..CU-020` a `CU-006..CU-010`
en `Work/Summary.tex`, se recompiló sin errores y se reemplazó `Submission/Summary.pdf`. Además, se
creó `Defense/DefenseGuide.tex` → `Defense/DefenseGuide.pdf`: una guía de estudio personal (no es
un entregable del curso) que explica, archivo por archivo, todo lo que hay en `Submission/`
(Summary, ArchitecturalProposal, C4Diagrams, CU_eventos_completo.xlsx), con preguntas que el
profesor podría hacer y los puntos delicados que el estudiante debe poder explicar con honestidad
(Árbol de Utilidad pendiente, posible duplicación Personal/Logística en los casos de uso,
infraestructura de despliegue propuesta por el asistente aún sin confirmar por el equipo) — en
línea con la regla del curso de que cada estudiante debe poder explicar cada término y decisión
generada con ayuda de IA.

**Riesgos técnicos:** Ninguno nuevo — el fix de `Summary.tex` es puramente de consistencia de IDs.
La guía de defensa puede quedar desactualizada si `Submission/` cambia después sin regenerarla; se
documentó esa dependencia en `CLAUDE.md` y `TASKS.md`.

**Participantes:** Samuel Contreras (vía asistente).

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
