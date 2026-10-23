# Bases de datos relacionales y SQL

Laboratorio #3 - Sistema de inventario aduanero
Aiden Montero Perez | Trabajo individual | 2026

Una base de datos organiza datos relacionados para consultarlos y actualizarlos de forma controlada. El SGBD es el programa que define estructuras, valida reglas, administra concurrencia, permisos y recuperacion. En la aduana, separar importadores, productos y declaraciones evita copiar los mismos datos en cada registro y ayuda a rastrear un cargamento.

Relacional y NoSQL. En el modelo relacional los datos se guardan en tablas con columnas definidas y relaciones mediante llaves. SQL permite combinar y resumir esas tablas. Una base NoSQL puede guardar documentos, pares clave-valor, grafos u otros formatos flexibles; resulta util cuando los datos cambian de forma o la escala exige distribuirlos. Para inventario aduanero las relaciones y reglas de integridad son centrales, por eso conviene un modelo relacional.

Tabla, fila, columna y tipos. Una tabla representa un tipo de entidad; la fila es una ocurrencia y la columna una propiedad. En producto, una fila puede representar “Telefono inteligente X1”; id_producto es INTEGER, descripcion VARCHAR, cantidad NUMERIC y fecha DATE. Elegir el tipo correcto evita comparar fechas como texto o perder decimales de dinero.

Llaves. La PK identifica cada fila sin repetirse. La FK apunta a una PK de otra tabla y evita referencias inexistentes. Una llave compuesta usa varias columnas: inventario se identifica por (id_bodega, id_producto, id_declaracion), pues un mismo producto puede aparecer en diferentes bodegas y declaraciones.

Relaciones. 1:1 se implementa con FK UNIQUE (por ejemplo, una tarjeta por persona); 1:N guarda la FK en el lado “muchos” (un pais tiene muchas declaraciones); N:M requiere una tabla intermedia. detalle_declaracion enlaza declaraciones con productos y agrega cantidad y valor declarado.

Integridad. NOT NULL exige dato; UNIQUE evita duplicados; CHECK valida rangos o estados permitidos; DEFAULT asigna un valor si no se indica. FK conserva integridad referencial: no se puede asignar a una declaracion un importador inexistente. Estas reglas son aplicadas por PostgreSQL al escribir.

# SQL, normalizacion y diagramas

DDL describe estructuras y DML trabaja con los registros. CREATE TABLE crea una tabla (DDL); INSERT agrega una fila, SELECT consulta, UPDATE modifica, DELETE elimina y JOIN combina datos relacionados (DML). Por ejemplo, un JOIN de inventario, producto y bodega permite saber que articulo esta almacenado y donde. WHERE filtra; GROUP BY agrupa y COUNT o SUM resume; ORDER BY ordena. En un asistente conectado a produccion, restringir el rol a SELECT reduce el impacto de un error.

Normalizacion. Primera forma normal (1FN): cada celda guarda un valor atomico y no hay grupos repetidos. Segunda (2FN): cada campo no clave depende de toda la llave compuesta, no solo de una parte. Tercera (3FN): un atributo no clave depende de la llave, no de otro atributo no clave. Por ejemplo, guardar codigo y nombre de pais repetidos en cada declaracion causa inconsistencias; la tabla pais conserva ese dato una sola vez.

El diagrama entidad-relacion (DER) es el plano del esquema: entidades, atributos, llaves y relaciones. Chen representa entidades como rectangulos, atributos como ovalos y relaciones como rombos. Pata de gallo marca cardinalidades con lineas y “patas” para muchos. En este trabajo, pais 1:N declaracion; funcionario tiene relacion recursiva con su supervisor, y detalle_declaracion resuelve la relacion N:M declaracion-producto.

Gestores comparados. SQLite es una biblioteca embebida, sin servidor y suele guardar toda la base en un solo archivo; es muy sencilla para aprender o para una app local. MySQL usa arquitectura cliente-servidor y es popular para aplicaciones web; ofrece amplia disponibilidad de herramientas y hosting. PostgreSQL tambien es cliente-servidor, con tipos y restricciones robustas y un nodo Postgres en n8n. Elegi PostgreSQL porque este laboratorio requiere integridad relacional, rol de solo lectura y conexion directa desde n8n; Supabase y Neon son opciones hospedadas mencionadas en el enunciado.

Fuentes tecnicas: PostgreSQL, “Constraints” y “GRANT”; SQLite, “About SQLite”; MySQL 8.4 Reference Manual, “What is MySQL?”.

# n8n y agentes de IA

n8n es una plataforma para conectar servicios mediante workflows. Un workflow es una secuencia de nodos: cada nodo ejecuta una tarea. Un trigger inicia el flujo ante un evento; una credencial guarda datos de conexion de forma administrada. En el laboratorio, Chat Trigger recibe la pregunta y AI Agent determina si necesita consultar datos.

Un chatbot normal suele responder siguiendo dialogo o reglas. Un agente puede decidir llamar una herramienta, observar el resultado y redactar una respuesta. El LLM interpreta el lenguaje y genera texto; una herramienta le permite actuar, por ejemplo ejecutar SQL. Simple Memory conserva parte del contexto de una conversacion para responder seguimientos.

Flujo propuesto: Chat Trigger -> AI Agent, conectado ademas a un Chat Model, Simple Memory y Postgres como AI Tool. La herramienta se configura con usuario de solo lectura. PostgreSQL debe otorgar CONNECT, USAGE sobre el esquema y SELECT sobre tablas actuales y futuras; no se otorga escritura. Las instrucciones del prompt indican SELECT, pero la proteccion efectiva es el permiso del servidor: un prompt por si solo no es una barrera de seguridad. Las credenciales se ingresan en n8n y se omiten del JSON exportado.

Caso aduanero. La aduana controla la entrada y salida de mercancias. La declaracion registra regimen, origen, importador, valor y estado. Una partida arancelaria clasifica mercancias bajo el Sistema Armonizado; el arancel es un tributo que puede aplicarse a la importacion conforme a la normativa nacional. El codigo HS armoniza categorias internacionales, pero cada pais agrega aperturas y tasas nacionales, por lo que los porcentajes de prueba no sustituyen una liquidacion oficial.

Regimenes incluidos en el esquema: importacion, exportacion, transito y deposito. Un agente aduanal representa o asesora al importador en tramites y clasificacion, conforme a las reglas aplicables. Contenedores, bodega, inventario, movimientos e inspecciones ayudan a seguir el recorrido y la custodia de la carga.

# Uso de IA y fuentes

Uso de IA
Utilice ChatGPT como apoyo para traducir los requisitos del enunciado a un modelo de tablas, explicar llaves y relaciones, proponer consultas y revisar consistencia entre SQL y el prompt. La IA no reemplaza ejecutar el script ni verificar las respuestas contra PostgreSQL.

Ejemplos de prompts utilizados:
- “Explicame PK, FK y relacion N:M con un ejemplo de una declaracion aduanera”.
- “Revisa si este esquema PostgreSQL permite saber que mercancias retenidas estan en cada bodega; verifica las FK y la llave de inventario”.
- “Escribe una consulta SELECT con JOIN y GROUP BY para ordenar los paises por contenedores recibidos”.
- “Ayudame a crear un agente n8n que consulte PostgreSQL con privilegios de solo lectura; no incluyas credenciales”.

Aprendizajes: un modelo puede proponer codigo rapido, pero hay que comprobar que nombres de columnas coincidan, que las filas respeten las FK y que estados y fechas tengan sentido. Aprendi que limitar permisos en el propio SGBD protege mejor que confiar unicamente en instrucciones del agente. Tambien comprendi que las tablas intermedias permiten guardar atributos propios de una relacion, como cantidad declarada por producto.

Fuentes consultadas (consulta: 23 octubre 2026):
1. PostgreSQL, Constraints: https://www.postgresql.org/docs/current/ddl-constraints.html
2. PostgreSQL, GRANT: https://www.postgresql.org/docs/current/sql-grant.html
3. PostgreSQL, SELECT: https://www.postgresql.org/docs/current/sql-select.html
4. SQLite, About SQLite: https://www.sqlite.org/about.html
5. MySQL 8.4, What is MySQL?: https://dev.mysql.com/doc/refman/8.4/en/what-is-mysql.html
6. World Customs Organization, Harmonized System FAQ: https://www.wcoomd.org/en/faq/harmonized_system_faq.aspx
7. n8n Documentation, AI and integrations: https://docs.n8n.io/

El esquema y los registros son un ejemplo academico. En una implementacion real se definirian moneda, calendario aduanero, reglas nacionales de clasificacion, auditoria y trazabilidad con especialistas.