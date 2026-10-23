-- Laboratorio #3 | Sistema de inventario aduanero
-- Integrante: Aiden Montero Pérez (individual) | Gestor: PostgreSQL | Fecha: 2026
-- Datos de prueba sintéticos. Ejecutar en una base vacía.
BEGIN;
CREATE TABLE pais(id_pais SERIAL PRIMARY KEY,nombre VARCHAR(80) NOT NULL UNIQUE,codigo_iso CHAR(2) NOT NULL UNIQUE,continente VARCHAR(30) NOT NULL);
CREATE TABLE importador(id_importador SERIAL PRIMARY KEY,razon_social VARCHAR(120) NOT NULL,nit_ruc VARCHAR(25) NOT NULL UNIQUE,direccion VARCHAR(180) NOT NULL,telefono VARCHAR(25) NOT NULL,correo VARCHAR(120) NOT NULL UNIQUE);
CREATE TABLE agente_aduanal(id_agente SERIAL PRIMARY KEY,nombre VARCHAR(120) NOT NULL,licencia VARCHAR(30) NOT NULL UNIQUE,telefono VARCHAR(25) NOT NULL,correo VARCHAR(120) NOT NULL UNIQUE);
CREATE TABLE partida_arancelaria(id_partida SERIAL PRIMARY KEY,codigo VARCHAR(12) NOT NULL UNIQUE,descripcion VARCHAR(180) NOT NULL,porcentaje_arancel NUMERIC(5,2) NOT NULL CHECK(porcentaje_arancel BETWEEN 0 AND 100));
CREATE TABLE producto(id_producto SERIAL PRIMARY KEY,descripcion VARCHAR(150) NOT NULL UNIQUE,unidad_medida VARCHAR(20) NOT NULL,valor_unitario NUMERIC(12,2) NOT NULL CHECK(valor_unitario>=0),id_partida INTEGER NOT NULL REFERENCES partida_arancelaria);
CREATE TABLE bodega(id_bodega SERIAL PRIMARY KEY,nombre VARCHAR(80) NOT NULL UNIQUE,ubicacion VARCHAR(120) NOT NULL,capacidad INTEGER NOT NULL CHECK(capacidad>0));
CREATE TABLE funcionario(id_funcionario SERIAL PRIMARY KEY,nombre VARCHAR(120) NOT NULL,cargo VARCHAR(60) NOT NULL,id_supervisor INTEGER REFERENCES funcionario,correo VARCHAR(120) NOT NULL UNIQUE);
CREATE TABLE declaracion(id_declaracion SERIAL PRIMARY KEY,numero VARCHAR(25) NOT NULL UNIQUE,fecha DATE NOT NULL,regimen VARCHAR(15) NOT NULL CHECK(regimen IN('Importacion','Exportacion','Transito','Deposito')),estado VARCHAR(15) NOT NULL DEFAULT 'Retenida' CHECK(estado IN('Retenida','En revision','Liberada','Rechazada')),valor_total_declarado NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK(valor_total_declarado>=0),id_importador INTEGER NOT NULL REFERENCES importador,id_agente INTEGER NOT NULL REFERENCES agente_aduanal,id_pais_origen INTEGER NOT NULL REFERENCES pais);
CREATE TABLE detalle_declaracion(id_detalle SERIAL PRIMARY KEY,id_declaracion INTEGER NOT NULL REFERENCES declaracion,id_producto INTEGER NOT NULL REFERENCES producto,cantidad NUMERIC(12,2) NOT NULL CHECK(cantidad>0),valor_declarado NUMERIC(14,2) NOT NULL CHECK(valor_declarado>=0),UNIQUE(id_declaracion,id_producto));
CREATE TABLE contenedor(id_contenedor SERIAL PRIMARY KEY,numero VARCHAR(20) NOT NULL UNIQUE,tipo VARCHAR(20) NOT NULL CHECK(tipo IN('Seco','Refrigerado','Abierto')),peso_kg NUMERIC(12,2) NOT NULL CHECK(peso_kg>0),id_declaracion INTEGER NOT NULL REFERENCES declaracion);
CREATE TABLE inventario(id_bodega INTEGER NOT NULL REFERENCES bodega,id_producto INTEGER NOT NULL REFERENCES producto,cantidad NUMERIC(12,2) NOT NULL CHECK(cantidad>=0),fecha_ingreso DATE NOT NULL,estado VARCHAR(12) NOT NULL CHECK(estado IN('Retenido','Liberado')),id_declaracion INTEGER NOT NULL REFERENCES declaracion,PRIMARY KEY(id_bodega,id_producto,id_declaracion));
CREATE TABLE movimiento_inventario(id_movimiento SERIAL PRIMARY KEY,tipo VARCHAR(10) NOT NULL CHECK(tipo IN('Entrada','Salida','Traslado')),fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,cantidad NUMERIC(12,2) NOT NULL CHECK(cantidad>0),id_producto INTEGER NOT NULL REFERENCES producto,id_bodega INTEGER NOT NULL REFERENCES bodega,id_declaracion INTEGER NOT NULL REFERENCES declaracion);
CREATE TABLE inspeccion(id_inspeccion SERIAL PRIMARY KEY,fecha DATE NOT NULL,resultado VARCHAR(25) NOT NULL CHECK(resultado IN('Aprobada','Con observaciones','Rechazada')),observaciones TEXT NOT NULL,id_declaracion INTEGER NOT NULL REFERENCES declaracion,id_funcionario INTEGER NOT NULL REFERENCES funcionario);
INSERT INTO pais(nombre,codigo_iso,continente) VALUES
('China','CN','Asia'),
('Estados Unidos','US','América del Norte'),
('México','MX','América del Norte'),
('Costa Rica','CR','América Central'),
('Japón','JP','Asia'),
('Alemania','DE','Europa'),
('Brasil','BR','América del Sur'),
('Corea del Sur','KR','Asia'),
('España','ES','Europa'),
('Canadá','CA','América del Norte'),
('Italia','IT','Europa'),
('India','IN','Asia'),
('Colombia','CO','América del Sur'),
('Chile','CL','América del Sur'),
('Países Bajos','NL','Europa');
INSERT INTO importador(razon_social,nit_ruc,direccion,telefono,correo) VALUES
('TecnoTica S.A.','310100001','San José, Costa Rica','+506 2222-1000','compras1@ejemplo.cr'),
('ElectroCentro S.A.','310100002','San José, Costa Rica','+506 2222-1001','compras2@ejemplo.cr'),
('Hogar Global S.A.','310100003','San José, Costa Rica','+506 2222-1002','compras3@ejemplo.cr'),
('AutoPartes Valle S.A.','310100004','San José, Costa Rica','+506 2222-1003','compras4@ejemplo.cr'),
('MedSupply S.A.','310100005','San José, Costa Rica','+506 2222-1004','compras5@ejemplo.cr'),
('Café y Más S.A.','310100006','San José, Costa Rica','+506 2222-1005','compras6@ejemplo.cr'),
('Moda Urbana S.A.','310100007','San José, Costa Rica','+506 2222-1006','compras7@ejemplo.cr'),
('Frío Industrial S.A.','310100008','San José, Costa Rica','+506 2222-1007','compras8@ejemplo.cr'),
('ConstruRed S.A.','310100009','San José, Costa Rica','+506 2222-1008','compras9@ejemplo.cr'),
('AgroMercantil S.A.','310100010','San José, Costa Rica','+506 2222-1009','compras10@ejemplo.cr'),
('Luz y Energía S.A.','310100011','San José, Costa Rica','+506 2222-1010','compras11@ejemplo.cr'),
('Muebles Pacífico S.A.','310100012','San José, Costa Rica','+506 2222-1011','compras12@ejemplo.cr'),
('Química Segura S.A.','310100013','San José, Costa Rica','+506 2222-1012','compras13@ejemplo.cr'),
('Deportes Ticos S.A.','310100014','San José, Costa Rica','+506 2222-1013','compras14@ejemplo.cr'),
('Papelería Central S.A.','310100015','San José, Costa Rica','+506 2222-1014','compras15@ejemplo.cr');
INSERT INTO agente_aduanal(nombre,licencia,telefono,correo) VALUES
('Agente 1 Aduanal','LIC-CR-001','+506 2200-0001','agente1@aduana.example'),
('Agente 2 Aduanal','LIC-CR-002','+506 2200-0002','agente2@aduana.example'),
('Agente 3 Aduanal','LIC-CR-003','+506 2200-0003','agente3@aduana.example'),
('Agente 4 Aduanal','LIC-CR-004','+506 2200-0004','agente4@aduana.example'),
('Agente 5 Aduanal','LIC-CR-005','+506 2200-0005','agente5@aduana.example'),
('Agente 6 Aduanal','LIC-CR-006','+506 2200-0006','agente6@aduana.example'),
('Agente 7 Aduanal','LIC-CR-007','+506 2200-0007','agente7@aduana.example'),
('Agente 8 Aduanal','LIC-CR-008','+506 2200-0008','agente8@aduana.example'),
('Agente 9 Aduanal','LIC-CR-009','+506 2200-0009','agente9@aduana.example'),
('Agente 10 Aduanal','LIC-CR-010','+506 2200-0010','agente10@aduana.example'),
('Agente 11 Aduanal','LIC-CR-011','+506 2200-0011','agente11@aduana.example'),
('Agente 12 Aduanal','LIC-CR-012','+506 2200-0012','agente12@aduana.example'),
('Agente 13 Aduanal','LIC-CR-013','+506 2200-0013','agente13@aduana.example'),
('Agente 14 Aduanal','LIC-CR-014','+506 2200-0014','agente14@aduana.example'),
('Agente 15 Aduanal','LIC-CR-015','+506 2200-0015','agente15@aduana.example');
INSERT INTO partida_arancelaria(codigo,descripcion,porcentaje_arancel) VALUES
('851713','Teléfonos inteligentes',5),
('847130','Computadoras portátiles',1),
('851830','Auriculares',5),
('940360','Muebles madera',10),
('300490','Medicamentos',0),
('090111','Café sin tostar',0),
('610910','Camisetas algodón',14),
('841810','Refrigeradores',10),
('854442','Cables eléctricos',5),
('392690','Artículos plásticos',10),
('850440','Adaptadores eléctricos',5),
('950691','Artículos deportivos',14),
('482010','Cuadernos',5),
('870899','Partes vehículos',10),
('853669','Conectores',5);
INSERT INTO producto(descripcion,unidad_medida,valor_unitario,id_partida) VALUES
('Teléfono inteligente X1','unidad',350,1),
('Laptop empresarial 14','unidad',820,2),
('Auriculares inalámbricos','unidad',45,3),
('Mesa comedor roble','unidad',240,4),
('Kit primeros auxilios','caja',18,5),
('Café verde premium','kg',8.5,6),
('Camiseta algodón básica','unidad',12,7),
('Refrigerador comercial','unidad',1200,8),
('Cable USB-C 2m','unidad',4.5,9),
('Caja organizadora','unidad',6.25,10),
('Adaptador corriente 65W','unidad',22,11),
('Balón fútbol profesional','unidad',28,12),
('Cuaderno universitario','unidad',2.75,13),
('Freno automotriz','juego',76,14),
('Conector industrial 16A','unidad',9.8,15);
INSERT INTO bodega(nombre,ubicacion,capacidad) VALUES
('Bodega 1','Puerto Limón',10000),
('Bodega 2','Caldera',11000),
('Bodega 3','Peñas Blancas',12000),
('Bodega 4','Juan Santamaría',13000),
('Bodega 5','Paso Canoas',14000),
('Bodega 6','Puerto Limón',15000),
('Bodega 7','Caldera',16000),
('Bodega 8','Peñas Blancas',17000),
('Bodega 9','Juan Santamaría',18000),
('Bodega 10','Paso Canoas',19000),
('Bodega 11','Puerto Limón',20000),
('Bodega 12','Caldera',21000),
('Bodega 13','Peñas Blancas',22000),
('Bodega 14','Juan Santamaría',23000),
('Bodega 15','Paso Canoas',24000);
INSERT INTO funcionario(nombre,cargo,id_supervisor,correo) VALUES
('Roberto Cordero','Jefe de Aduana',NULL,'roberto@aduana.example'),
('Inspector 1','Inspector',1,'func1@aduana.example'),
('Inspector 2','Inspector',2,'func2@aduana.example'),
('Inspector 3','Inspector',3,'func3@aduana.example'),
('Inspector 4','Inspector',4,'func4@aduana.example'),
('Inspector 5','Inspector',5,'func5@aduana.example'),
('Inspector 6','Inspector',1,'func6@aduana.example'),
('Inspector 7','Inspector',2,'func7@aduana.example'),
('Inspector 8','Inspector',3,'func8@aduana.example'),
('Inspector 9','Inspector',4,'func9@aduana.example'),
('Inspector 10','Inspector',5,'func10@aduana.example'),
('Inspector 11','Inspector',1,'func11@aduana.example'),
('Inspector 12','Inspector',2,'func12@aduana.example'),
('Inspector 13','Inspector',3,'func13@aduana.example'),
('Inspector 14','Inspector',4,'func14@aduana.example');
INSERT INTO declaracion(numero,fecha,regimen,estado,valor_total_declarado,id_importador,id_agente,id_pais_origen) VALUES
('DUA-2026-0001','2026-10-03','Importacion','Retenida',35000,1,1,1),
('DUA-2026-0002','2026-10-04','Importacion','Liberada',16400,2,2,2),
('DUA-2026-0003','2026-10-05','Importacion','En revision',9000,3,3,3),
('DUA-2026-0004','2026-10-06','Importacion','Retenida',2400,4,4,5),
('DUA-2026-0005','2026-10-07','Exportacion','Liberada',9000,5,5,4),
('DUA-2026-0006','2026-10-08','Transito','En revision',10200,6,6,6),
('DUA-2026-0007','2026-10-09','Deposito','Retenida',3600,7,7,7),
('DUA-2026-0008','2026-10-10','Importacion','Liberada',48000,8,8,1),
('DUA-2026-0009','2026-10-11','Importacion','Liberada',3150,9,9,8),
('DUA-2026-0010','2026-10-12','Exportacion','Liberada',312.5,10,10,9),
('DUA-2026-0011','2026-10-13','Importacion','En revision',1760,11,11,10),
('DUA-2026-0012','2026-10-14','Transito','Retenida',840,12,12,11),
('DUA-2026-0013','2026-10-15','Importacion','Liberada',687.5,13,13,12),
('DUA-2026-0014','2026-10-16','Deposito','Retenida',5320,14,14,13),
('DUA-2026-0015','2026-10-17','Importacion','Liberada',9800,15,15,14);
INSERT INTO detalle_declaracion(id_declaracion,id_producto,cantidad,valor_declarado) VALUES
(1,1,100,35000),
(2,2,20,16400),
(3,3,200,9000),
(4,4,10,2400),
(5,5,500,9000),
(6,6,1200,10200),
(7,7,300,3600),
(8,8,40,48000),
(9,9,700,3150),
(10,10,50,312.5),
(11,11,80,1760),
(12,12,30,840),
(13,13,250,687.5),
(14,14,70,5320),
(15,15,1000,9800);
INSERT INTO contenedor(numero,tipo,peso_kg,id_declaracion) VALUES
('CRTU0000001','Seco',5000,1),
('CRTU0000002','Refrigerado',5250,1),
('CRTU0000003','Abierto',5500,1),
('CRTU0000004','Seco',5750,8),
('CRTU0000005','Refrigerado',6000,8),
('CRTU0000006','Abierto',6250,2),
('CRTU0000007','Seco',6500,3),
('CRTU0000008','Refrigerado',6750,4),
('CRTU0000009','Abierto',7000,5),
('CRTU0000010','Seco',7250,6),
('CRTU0000011','Refrigerado',7500,7),
('CRTU0000012','Abierto',7750,9),
('CRTU0000013','Seco',8000,10),
('CRTU0000014','Refrigerado',8250,11),
('CRTU0000015','Abierto',8500,12);
INSERT INTO inventario(id_bodega,id_producto,cantidad,fecha_ingreso,estado,id_declaracion) VALUES
(2,1,100,'2026-10-03','Retenido',1),
(2,2,20,'2026-10-04','Liberado',2),
(3,3,200,'2026-10-05','Retenido',3),
(4,4,10,'2026-10-06','Retenido',4),
(5,5,500,'2026-10-07','Liberado',5),
(6,6,1200,'2026-10-08','Retenido',6),
(7,7,300,'2026-10-09','Retenido',7),
(8,8,40,'2026-10-10','Liberado',8),
(9,9,700,'2026-10-11','Liberado',9),
(10,10,50,'2026-10-12','Liberado',10),
(11,11,80,'2026-10-13','Retenido',11),
(12,12,30,'2026-10-14','Retenido',12),
(13,13,250,'2026-10-15','Liberado',13),
(14,14,70,'2026-10-16','Retenido',14),
(15,15,1000,'2026-10-17','Liberado',15);
INSERT INTO movimiento_inventario(tipo,fecha,cantidad,id_producto,id_bodega,id_declaracion) VALUES
('Entrada','2026-10-03 09:00:00',50,1,2,1),
('Salida','2026-10-04 09:00:00',10,2,2,2),
('Traslado','2026-10-05 09:00:00',100,3,3,3),
('Entrada','2026-10-06 09:00:00',5,4,4,4),
('Salida','2026-10-07 09:00:00',250,5,5,5),
('Traslado','2026-10-08 09:00:00',600,6,6,6),
('Entrada','2026-10-09 09:00:00',150,7,7,7),
('Salida','2026-10-10 09:00:00',20,8,8,8),
('Traslado','2026-10-11 09:00:00',350,9,9,9),
('Entrada','2026-10-12 09:00:00',25,10,10,10),
('Salida','2026-10-13 09:00:00',40,11,11,11),
('Traslado','2026-10-14 09:00:00',15,12,12,12),
('Entrada','2026-10-15 09:00:00',125,13,13,13),
('Salida','2026-10-16 09:00:00',35,14,14,14),
('Traslado','2026-10-17 09:00:00',500,15,15,15);
INSERT INTO inspeccion(fecha,resultado,observaciones,id_declaracion,id_funcionario) VALUES
('2026-10-03','Con observaciones','Etiqueta incompleta; requiere subsanación.',1,1),
('2026-10-04','Aprobada','Documentación y precintos conformes.',2,2),
('2026-10-05','Rechazada','Diferencia entre peso declarado y verificado.',3,3),
('2026-10-06','Con observaciones','Etiqueta incompleta; requiere subsanación.',4,4),
('2026-10-07','Aprobada','Documentación y precintos conformes.',5,5),
('2026-10-08','Rechazada','Diferencia entre peso declarado y verificado.',6,6),
('2026-10-09','Con observaciones','Etiqueta incompleta; requiere subsanación.',7,7),
('2026-10-10','Aprobada','Documentación y precintos conformes.',8,8),
('2026-10-11','Rechazada','Diferencia entre peso declarado y verificado.',9,9),
('2026-10-12','Con observaciones','Etiqueta incompleta; requiere subsanación.',10,10),
('2026-10-13','Aprobada','Documentación y precintos conformes.',11,11),
('2026-10-14','Rechazada','Diferencia entre peso declarado y verificado.',12,12),
('2026-10-15','Con observaciones','Etiqueta incompleta; requiere subsanación.',13,13),
('2026-10-16','Aprobada','Documentación y precintos conformes.',14,14),
('2026-10-17','Rechazada','Diferencia entre peso declarado y verificado.',15,1);
-- 1. Conteo de importaciones de octubre 2026, agrupado por régimen (una fila).
SELECT d.regimen,COUNT(d.id_declaracion) total FROM declaracion d JOIN importador i USING(id_importador) WHERE d.regimen='Importacion' AND d.fecha>=DATE '2026-10-01' AND d.fecha<DATE '2026-11-01' GROUP BY d.regimen ORDER BY total DESC;
-- 2. Mercancía retenida y bodega donde está almacenada.
SELECT p.descripcion,b.nombre bodega,d.numero,pa.nombre origen,SUM(inv.cantidad) cantidad FROM inventario inv JOIN producto p USING(id_producto) JOIN bodega b USING(id_bodega) JOIN declaracion d USING(id_declaracion) JOIN pais pa ON pa.id_pais=d.id_pais_origen WHERE inv.estado='Retenido' GROUP BY p.descripcion,b.nombre,d.numero,pa.nombre,b.id_bodega ORDER BY b.id_bodega,p.descripcion;
-- 3. Países de origen con más contenedores recibidos.
SELECT pa.nombre,COUNT(c.id_contenedor) contenedores FROM pais pa JOIN declaracion d ON d.id_pais_origen=pa.id_pais JOIN contenedor c USING(id_declaracion) WHERE c.id_contenedor IS NOT NULL GROUP BY pa.id_pais,pa.nombre ORDER BY contenedores DESC,pa.nombre;
-- 4. Importador con mayor valor declarado.
SELECT im.razon_social,SUM(d.valor_total_declarado) valor_total FROM importador im JOIN declaracion d USING(id_importador) WHERE d.valor_total_declarado>=0 GROUP BY im.id_importador,im.razon_social ORDER BY valor_total DESC;
-- 5. Inspecciones con observaciones y funcionario responsable.
SELECT ins.fecha,ins.observaciones,d.numero,f.nombre FROM inspeccion ins JOIN declaracion d USING(id_declaracion) JOIN funcionario f USING(id_funcionario) WHERE ins.resultado='Con observaciones' GROUP BY ins.id_inspeccion,ins.fecha,ins.observaciones,d.numero,f.nombre ORDER BY ins.fecha;
-- 6. Stock de cada producto en todas las bodegas (incluye cero con LEFT JOIN).
SELECT p.descripcion,b.nombre,SUM(COALESCE(inv.cantidad,0)) stock FROM bodega b CROSS JOIN producto p LEFT JOIN inventario inv ON inv.id_bodega=b.id_bodega AND inv.id_producto=p.id_producto WHERE p.id_producto>0 GROUP BY p.id_producto,p.descripcion,b.id_bodega,b.nombre ORDER BY p.descripcion,b.id_bodega;
-- 7. Estimación didáctica del arancel por partida en importaciones.
SELECT pa.codigo,pa.descripcion,SUM(dd.valor_declarado*pa.porcentaje_arancel/100) arancel_estimado FROM partida_arancelaria pa JOIN producto p USING(id_partida) JOIN detalle_declaracion dd USING(id_producto) JOIN declaracion d USING(id_declaracion) WHERE d.regimen='Importacion' GROUP BY pa.id_partida,pa.codigo,pa.descripcion ORDER BY arancel_estimado DESC;
-- 8. Declaraciones pendientes, días transcurridos, importador y origen (corte 31-oct-2026).
SELECT d.numero,d.fecha,d.estado,DATE '2026-10-31'-d.fecha dias,im.razon_social,pa.nombre origen FROM declaracion d JOIN importador im USING(id_importador) JOIN pais pa ON pa.id_pais=d.id_pais_origen WHERE d.estado IN('Retenida','En revision') GROUP BY d.id_declaracion,d.numero,d.fecha,d.estado,im.razon_social,pa.nombre ORDER BY dias DESC;
COMMIT;

-- Usuario de solo lectura: ejecutar como administrador, con password configurado por canal seguro (no guardar en este archivo).
-- CREATE ROLE agente_aduana LOGIN PASSWORD 'CONFIGURE_EN_SECRET_MANAGER';
-- GRANT CONNECT ON DATABASE aduana TO agente_aduana;
-- GRANT USAGE ON SCHEMA public TO agente_aduana;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO agente_aduana;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO agente_aduana;
-- REVOKE CREATE ON SCHEMA public FROM agente_aduana;
-- ALTER ROLE agente_aduana SET default_transaction_read_only = on;
-- Asegurar que el rol no sea miembro de roles con permisos de escritura.
