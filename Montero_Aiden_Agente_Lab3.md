# Agente de IA Aduana | Montero_Aiden_Agente_Lab3

## Preparación y conexión
1. Crear proyecto PostgreSQL en Supabase o Neon y ejecutar Montero_Aiden_Aduana_Lab3.sql en el SQL editor (no incluir claves en archivos). La carga crea 13 tablas y 15 filas por tabla.
2. Ejecutar como propietario los comandos de rol de solo lectura que están comentados al final del SQL; configurar una contraseña fuerte directamente en el gestor de secretos de n8n. En n8n crear credencial Postgres con host, puerto 5432, base, usuario agente_aduana, SSL según proveedor y credencial secreta. No colocar esos valores en el JSON.
3. En n8n Cloud crear workflow. En local: instalar Node.js y ejecutar npx n8n (o usar Docker); abrir la URL que indica la consola.
4. Agregar Chat Trigger y AI Agent, conectando la salida principal del trigger al agente. Añadir un Chat Model (OpenAI Chat Model u otro proveedor), configurar su credencial en n8n y conectarlo al puerto Chat Model del agente.
5. Agregar Simple Memory y conectarla al puerto Memory. Usar como session key la sesión del Chat Trigger o la opción por defecto compatible con la versión instalada.
6. Agregar Postgres como herramienta del agente (nodo Postgres conectado al puerto AI Tool). Seleccionar credencial agente_aduana, operación Execute Query. En la descripción de herramienta: “Consulta de solo lectura; genera una sola sentencia SELECT”. No compartir credenciales en exportaciones.
7. Pegar Montero_Aiden_Agente_Lab3_prompt.txt como System Message del AI Agent. Guardar, activar/probar el workflow y comprobar que preguntas generen SELECT. La capa de permisos Postgres es la protección efectiva; las instrucciones al modelo complementan, no reemplazan permisos.

## Pruebas y respuesta esperada según el conjunto de prueba
1. ¿Cuántas declaraciones de importación se registraron en octubre de 2026? **9**.
2. ¿Qué mercancía de China sigue retenida y en qué bodega? **Teléfono inteligente X1, 100 unidades, Bodega 2 (DUA-2026-0001)**.
3. ¿Qué país de origen tiene más contenedores? **China: 5**.
4. ¿Qué importador declaró el mayor valor? **TecnoTica S.A.: USD 35,000** (valor de prueba; la moneda no está modelada, así que indique “unidades monetarias” si se desea máxima precisión).
5. ¿Qué inspecciones tuvieron observaciones y quién las realizó? **DUA-2026-0001 (Inspector 1), DUA-2026-0004 (Inspector 4), DUA-2026-0007 (Inspector 7), DUA-2026-0010 (Inspector 10), DUA-2026-0013 (Inspector 13)**, en sus fechas de octubre.
6. ¿Cuánto stock de Teléfono inteligente X1 hay por bodega? **100 en Bodega 2 y 0 en las otras 14 bodegas** (consulta con producto por todas las bodegas y LEFT JOIN).
7. ¿Cuánto suma el valor declarado de DUA-2026-0002? **16,400**.
8. ¿Qué declaraciones permanecen retenidas o en revisión? **DUA-2026-0001, 0003, 0004, 0006, 0007, 0011, 0012 y 0014** (incluye los estados del dataset).

## Exportación y evidencia
En el editor del workflow, menú ··· (arriba a la derecha) -> Download para exportar JSON. La copia inicial está en Montero_Aiden_Agente_Lab3.json; tras configurar nodos y probar en su instancia, vuelva a descargar desde n8n para que refleje IDs/versión de nodos. Capture: (1) lienzo con conexiones Chat Trigger -> AI Agent y modelo/memoria/herramienta; (2) credencial Postgres configurada sin mostrar secretos; (3) System Message y descripción de herramienta; (4) ocho preguntas y respuestas en el chat; (5) salida/log con consultas SELECT. Guarde capturas PNG en una carpeta Montero_Aiden_Evidencia_Lab3. Evidencia de una ejecución real debe tomarse en la instancia conectada; no se puede fabricar desde este workspace.

## Punto extra
Para chat web, incorporar Chat Trigger configurado como hosted chat o embed y publicar el snippet en un sitio HTTPS. Para Telegram, usar Telegram Trigger, credencial de bot guardada en n8n y adaptar entrada/salida de mensaje al AI Agent; limitar usuarios autorizados, proteger el webhook y no exponer credenciales. Reprobar el permiso SQL de solo lectura antes de publicar.
