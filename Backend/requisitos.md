LABORATORIO #3

Sistema de inventario para una aduana: base de datos relacional y agente de IA con

n8n

Asignatura: Bases de Datos Docente: ____________________
Curso / Sección: ____________________ Fecha de entrega: ____________________
Modalidad: Individual o en parejas Entrega: Google Classroom
Antes de empezar: un mensaje para ustedes
El lunes inicia formalmente la materia de Bases de Datos. Este laboratorio es su punto de partida:
investiguen, lean, prueben y empápense lo más que puedan de cada tema. Es normal que muchos
conceptos (tablas, llaves foráneas, relaciones, SQL, agentes de IA) todavía les resulten nuevos. No se
preocupen: aunque no los dominen, pueden aplicarlos con ayuda de la inteligencia artificial, que hoy es una
herramienta de trabajo más. Úsenla para preguntar, para que les explique paso a paso y para revisar sus
errores, pero asegúrense de entender lo que entregan.
Lo que se evalúa es el esfuerzo, la investigación y el proceso. Hagan su mejor esfuerzo: todo lo que
aprendan aquí les dará ventaja desde la primera clase.
1. Contexto del caso
Una aduana controla la mercancía que entra y sale del país. Cada día recibe contenedores y cargamentos
de distintos importadores, que llegan desde varios países, se registran mediante declaraciones
aduaneras, se almacenan en depósitos o bodegas, pasan por inspecciones y pagan aranceles antes de
ser liberados.
Actualmente toda esa información se lleva en hojas de cálculo dispersas, lo que provoca errores,
mercancía "perdida" y lentitud para responder preguntas básicas. Ustedes deben diseñar la base de
datos del sistema de inventario aduanero, llenarla con datos de prueba y construir un agente de IA en
n8n que permita a los funcionarios consultar la información escribiendo preguntas en lenguaje natural, por
ejemplo: "¿Qué mercancías de China siguen retenidas en la bodega 2?"
2. Objetivos
• Investigar los fundamentos de las bases de datos relacionales y del lenguaje SQL.
• Modelar el sistema de inventario de una aduana mediante un Diagrama Entidad-Relación.
• Crear la base de datos con sintaxis SQL (CREATE TABLE, llaves y relaciones) y llenarla con INSERT
INTO.
• Construir un agente de IA en n8n conectado a la base de datos que responda preguntas sobre el
inventario.
• Aprender a usar la IA como asistente para investigar, escribir código y resolver errores.

Laboratorio #3 · Sistema de Inventario Aduanero Página 2
3. Parte I – Investigación
Investiguen los siguientes temas y redacten un documento (3 a 6 páginas) con explicaciones en sus
propias palabras, ejemplos y las fuentes consultadas. Mientras más profundicen, mejor preparados
llegarán al lunes.
A. Bases de datos y SQL
1. ¿Qué es una base de datos? ¿Qué es un Sistema Gestor de Bases de Datos (SGBD)?
2. Diferencias entre base de datos relacional y no relacional (NoSQL).
3. Tabla, registro (fila), campo (columna) y tipos de datos más comunes.
4. Llave primaria (PK), llave foránea (FK) y llave compuesta.
5. Tipos de relaciones: uno a uno (1:1), uno a muchos (1:N) y muchos a muchos (N:M); cómo se
implementa cada una.
6. Integridad referencial y restricciones: NOT NULL, UNIQUE, CHECK, DEFAULT.
7. Qué son DDL y DML. Sentencias CREATE, INSERT, SELECT, UPDATE, DELETE y JOIN.
8. Normalización: primera, segunda y tercera forma normal.
9. Qué es un Diagrama Entidad-Relación y sus notaciones (Chen y pata de gallo).
B. Gestores de bases de datos
Comparen los tres gestores permitidos y justifiquen cuál eligieron:
Gestor Características Para tener en cuenta
SQLite Base de datos en un solo archivo, sin
servidor; muy fácil de instalar y usar.

Ideal para aprender. Para conectarla a n8n deben
investigar cómo hacerlo, pues no es tan directo
como los otros dos.

MySQL Gestor muy popular en aplicaciones

web; usa un servidor.

n8n tiene un nodo nativo de MySQL. Se puede usar
con XAMPP, Docker o un servicio en la nube.

PostgreSQL Gestor robusto y avanzado, muy usado

en la industria.

n8n tiene un nodo nativo de Postgres. Existen
opciones gratuitas en la nube (por ejemplo,
Supabase o Neon).

C. n8n y agentes de IA
1. ¿Qué es n8n? ¿Qué es la automatización de flujos de trabajo (workflows)?
2. ¿Qué es un nodo, un trigger y una credencial en n8n?
3. ¿Qué es un agente de IA y en qué se diferencia de un chatbot normal?
4. ¿Qué es un modelo de lenguaje (LLM) y qué son las "herramientas" (tools) de un agente?
5. ¿Cómo puede un agente consultar una base de datos de forma segura (por ejemplo, con un usuario
de solo lectura)?
D. El dominio aduanero
• ¿Qué es una aduana y qué es una declaración aduanera?
• ¿Qué es una partida arancelaria (Sistema Armonizado) y un arancel?

Laboratorio #3 · Sistema de Inventario Aduanero Página 3
• Regímenes aduaneros básicos: importación, exportación, tránsito y depósito.
• ¿Qué es un agente aduanal y qué papel cumple?
4. Parte II – Diagrama Entidad-Relación
Diseñen el DER del sistema. Las siguientes entidades son una guía; pueden agregar, quitar o renombrar
según su análisis.
Entidad sugerida Ejemplos de atributos
Importador / Exportador id, nombre o razón social, NIT/RUC, dirección, teléfono, correo
Agente aduanal id, nombre, licencia, teléfono
País id, nombre, código ISO
Categoría / Partida arancelaria id, código, descripción, porcentaje de arancel
Producto / Mercancía id, descripción, unidad de medida, valor unitario, id_categoría
Declaración aduanera id, número, fecha, régimen, estado, id_importador, id_agente, id_país_origen
Detalle de declaración id_declaración, id_producto, cantidad, valor declarado (tabla intermedia N:M)
Contenedor id, número, tipo, peso, id_declaración
Bodega / Depósito id, nombre, ubicación, capacidad
Inventario / Stock en bodega id_bodega, id_producto, cantidad, fecha de ingreso, estado (retenido, liberado)
Movimiento de inventario id, tipo (entrada/salida/traslado), fecha, cantidad, id_producto, id_bodega
Inspección id, fecha, resultado, observaciones, id_declaración, id_funcionario
Funcionario id, nombre, cargo, id_supervisor (relación recursiva)
Requisitos del diagrama:
• Mínimo 8 entidades, cada una con su llave primaria.
• Al menos una relación 1:N, una N:M resuelta con tabla intermedia y, si es posible, una 1:1 o una
recursiva.
• Atributos con tipo de dato, PK y FK señaladas y cardinalidades indicadas.
• El diagrama debe coincidir con el script SQL. Herramientas: draw.io, dbdiagram.io, Lucidchart,
ERDPlus o MySQL Workbench.
5. Parte III – Creación y llenado de la base de datos
Elijan SQLite, MySQL o PostgreSQL y escriban un script .sql que se ejecute sin errores de principio a
fin. Debe incluir:
1. Encabezado con comentarios: integrantes, gestor utilizado y fecha.
2. Creación de todas las tablas con tipos de datos y restricciones (NOT NULL, UNIQUE, CHECK,
DEFAULT).

Laboratorio #3 · Sistema de Inventario Aduanero Página 4
3. Llaves primarias y foráneas que implementen todas las relaciones del diagrama.
4. Llenado con INSERT INTO: mínimo 15 registros por tabla, con datos realistas y coherentes (países
reales, productos creíbles, fechas lógicas). Mientras más datos, más interesante será el agente.
5. Al menos 8 consultas SELECT con JOIN, WHERE, GROUP BY y ORDER BY que respondan preguntas
reales del negocio.
Cada gestor escribe algunas cosas de forma diferente; investiguen la sintaxis del que elijan:
Concepto SQLite MySQL PostgreSQL
ID autoincremental INTEGER PRIMARY KEY
AUTOINCREMENT

INT AUTO_INCREMENT
PRIMARY KEY

SERIAL PRIMARY KEY

Activar llaves
foráneas

PRAGMA foreign_keys =
ON;

Activas por defecto
(InnoDB)

Activas por defecto

Crear la base Se crea al abrir el archivo .db CREATE DATABASE
aduana;

CREATE DATABASE
aduana;

Ejemplo orientativo (MySQL). No lo copien: es solo para que vean la estructura.
-- Laboratorio #3 | Sistema de inventario aduanero | Gestor: MySQL
CREATE TABLE pais (
id_pais INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(60) NOT NULL UNIQUE,
codigo_iso CHAR(2) NOT NULL UNIQUE
);
-- Relación 1:N -> un país es origen de muchas declaraciones
CREATE TABLE declaracion (
id_declaracion INT AUTO_INCREMENT PRIMARY KEY,
numero VARCHAR(20) NOT NULL UNIQUE,
fecha DATE NOT NULL,
regimen VARCHAR(15) NOT NULL
CHECK (regimen IN ('Importacion','Exportacion','Transito')),
estado VARCHAR(15) DEFAULT 'Retenida',
id_pais_origen INT NOT NULL,
FOREIGN KEY (id_pais_origen) REFERENCES pais(id_pais)
);
INSERT INTO pais (nombre, codigo_iso) VALUES ('China', 'CN'), ('Estados Unidos', 'US');
INSERT INTO declaracion (numero, fecha, regimen, id_pais_origen)
VALUES ('DUA-2026-0001', '2026-10-15', 'Importacion', 1);
6. Parte IV – Agente de IA en n8n
Construyan en n8n un agente que reciba preguntas en lenguaje natural, consulte la base de datos y
responda con la información almacenada. La estructura básica del flujo es la siguiente:
# Nodo / acción en n8n Qué hace
1 Chat Trigger Abre un chat donde el usuario escribe su pregunta.
2 AI Agent El "cerebro" que decide cómo responder y cuándo consultar la

base de datos.

Laboratorio #3 · Sistema de Inventario Aduanero Página 5
# Nodo / acción en n8n Qué hace
3 Chat Model (OpenAI, Gemini,
Anthropic, etc.)

El modelo de lenguaje que usa el agente para entender y
redactar.

4 Memoria (Simple Memory) Permite que el agente recuerde lo conversado en el mismo

chat.

5 Herramienta de base de datos
(Postgres o MySQL)

Ejecuta las consultas SQL sobre su base de datos usando
credenciales.

Requisitos del agente:
• Puede usar n8n en la nube (prueba gratuita) o instalado localmente (por ejemplo, con npx n8n o
Docker).
• Escribir un mensaje de sistema (system prompt) que explique al agente que es un asistente de la
aduana y le describa las tablas y columnas de la base de datos.
• Por seguridad, el agente solo debe consultar (SELECT); no debe poder borrar ni modificar datos.
Investiguen cómo crear un usuario de solo lectura en su gestor.
• Si eligieron SQLite, investiguen cómo conectarla a n8n o migren su script a MySQL/PostgreSQL para
esta parte.
• Probar el agente con al menos 8 preguntas y guardar evidencia (capturas o video) de sus respuestas.
Preguntas de ejemplo para probar el agente:
• ¿Cuántas declaraciones de importación se registraron en octubre?
• ¿Qué mercancías siguen retenidas y en qué bodega están?
• ¿Cuál es el país de origen con más contenedores recibidos?
• ¿Qué importador ha declarado el mayor valor total en mercancías?
• ¿Qué inspecciones tuvieron resultado "con observaciones" y quién las realizó?
• ¿Cuánto stock queda del producto X en todas las bodegas?
7. Uso de la inteligencia artificial
En este laboratorio el uso de IA está permitido y se recomienda (ChatGPT, Claude, Gemini, Copilot u
otras). Algunas formas útiles de usarla:
• Pedir que les explique un concepto "como si fueran principiantes" y luego con ejemplos del caso de la
aduana.
• Pedir ayuda para escribir o revisar sus CREATE TABLE y INSERT, y para entender los mensajes de
error.
• Pedir datos de prueba realistas para llenar las tablas.
• Pedir una guía paso a paso para instalar n8n y conectar el agente a su base de datos.
Condición importante: deben poder explicar todo lo que entregan. Incluyan en el documento de
investigación un apartado llamado "Uso de IA" con las herramientas utilizadas, ejemplos de los prompts que
escribieron y qué aprendieron en el proceso. Copiar sin entender no sirve; usar la IA para aprender, sí.

Laboratorio #3 · Sistema de Inventario Aduanero Página 6
8. Entregables en Google Classroom
# Entregable Formato Nombre del archivo
1 Documento de investigación (incluye
apartado "Uso de IA")

PDF Apellido_Nombre_Investigacion_Lab3.pdf

2 Diagrama Entidad-Relación PNG, JPG o
PDF

Apellido_Nombre_DER_Lab3.png
3 Script SQL (tablas, inserts y consultas) .sql Apellido_Nombre_Aduana_Lab3.sql
4 Flujo de n8n exportado .json Apellido_Nombre_Agente_Lab3.json
5 Evidencia del agente respondiendo
(capturas o video corto)

PNG, JPG o
MP4

Apellido_Nombre_Evidencia_Lab3
Para exportar el flujo en n8n: abran el workflow, menú de opciones (···) y elijan Download. No incluyan
contraseñas ni claves de API en los archivos que suban.
9. Rúbrica de evaluación
Criterio Lo que se espera Pts
Investigación Cubre los temas A, B, C y D con explicaciones propias, ejemplos y

fuentes.

15
Uso de IA documentado Describe herramientas, prompts y aprendizajes obtenidos. 5
Diagrama
Entidad-Relación

Mínimo 8 entidades, relaciones y cardinalidades correctas, coherente
con el SQL.

20

Creación de tablas y
relaciones

Tipos de datos, restricciones, PK y FK bien implementadas; el script
corre sin errores.

20
Llenado de datos Mínimo 15 registros por tabla, realistas y coherentes con las relaciones. 10
Consultas SQL 8 consultas con JOIN, filtros y agrupaciones que respondan preguntas

del negocio.

10

Agente en n8n Conectado a la base de datos, con system prompt, responde

correctamente al menos 8 preguntas.

20
Total 100
Puntos extra (hasta 5): agente conectado a un canal real (Telegram, WhatsApp o una página web) o un dashboard
con indicadores del inventario.
10. Recomendaciones finales
• Empiecen por entender el caso: ¿qué se guarda, quién lo usa y qué preguntas necesita responder la
aduana?
• Hagan primero el diagrama y después el SQL; el diagrama es el plano de la casa.

Laboratorio #3 · Sistema de Inventario Aduanero Página 7
• Creen primero las tablas sin llaves foráneas ("padres") y luego las que dependen de ellas ("hijas");
igual con los INSERT.
• Avancen por partes y prueben cada paso; un error a tiempo es más fácil de corregir.
• Las dudas se atienden por los comentarios privados de la tarea en Classroom. Los trabajos copiados
entre compañeros se califican con cero.