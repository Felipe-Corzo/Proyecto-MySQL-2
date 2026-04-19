-- ======================================================
-- PROYECTO: GASEOSAS DEL VALLE S.A.
-- DESCRIPCIÓN: Inserción de Datos Iniciales (DML)
-- ======================================================

USE GaseosasDelValle;

-- 1. INSERTAR SEDES
INSERT INTO Sede (nombre_sede, capacidad_almacenamiento, encargado, ubicacion) VALUES 
('Sede Principal Girón', 5000, 'Carlos Ruiz', 'Calle 12 #23-45, Girón'),
('Sede Norte Bucaramanga', 3000, 'Marta López', 'Cra 15 #10-20, Bucaramanga'),
('Sede Sur Piedecuesta', 2500, 'Jorge Plata', 'Anillo Vial Km 2, Piedecuesta');

-- 2. INSERTAR CATEGORÍAS (Según tu última actualización)
INSERT INTO Categoria (id_categoria, nombre_categoria) VALUES 
(1, 'Gaseosas Coca-Cola'),
(2, 'Gaseosas Postobon'),
(3, 'Aguas'),
(4, 'Jugos'),
(5, 'Bebidas Energizantes');

-- 3. INSERTAR CLIENTES (20 Registros)
INSERT INTO Cliente (nombre_cliente, identificacion, direccion, telefono, correo) VALUES 
('Tienda La Economía de Girón', 1098000101, 'Calle 12 #23-45, Girón', '3150000001', 'ventas@laeconomia.com'),
('Minimarket El Vecino Bucaramanga', 1098000102, 'Cra 15 #10-20, Bucaramanga', '3150000002', 'vecino_bga@gmail.com'),
('Restaurante El Sabor Costeño', 1098000103, 'Calle 45 #12-10, Piedecuesta', '3150000003', 'contacto@elsabor.co'),
('Supermercado MerkaYa', 1098000104, 'Av. Central 4-50, Girón', '3150000004', 'admin@merkaya.com'),
('Cafetería Central Parque', 1098000105, 'Parque Principal, Piedecuesta', '3150000005', 'cafe_central@outlook.com'),
('Distribuidora Los Lagos', 1098000106, 'Diagonal 15 #56-22, Bucaramanga', '3150000006', 'logistica@loslagos.com'),
('Tienda Don Juan', 1098000107, 'Manzana 4 Lote 12, Girón', '3150000007', 'juan.perez@yahoo.es'),
('Panadería Trigos de Oro', 1098000108, 'Cra 27 #34-11, Bucaramanga', '3150000008', 'pedidos@trigosdeoro.com'),
('Gaseosas y Más S.A.S', 1098000109, 'Zona Industrial, Girón', '3150000009', 'gerencia@gaseosasymas.com'),
('Estanco El Refresque', 1098000110, 'Calle 200 #15-30, Floridablanca', '3150000110', 'elrefresque@gmail.com'),
('Market 24 Horas', 1098000111, 'Calle 56 #33-10, Bucaramanga', '3150000111', 'market24_bga@gmail.com'),
('Restaurante El Gran Combo', 1098000112, 'Calle 8 #4-15, Girón', '3150000112', 'admin@grancombo.com'),
('Tienda La Bendición', 1098000113, 'Carrera 4 #10-50, Piedecuesta', '3150000113', 'labendicion@hotmail.com'),
('Frutería El Oasis', 1098000114, 'Avenida 60 #20-11, Bucaramanga', '3150000114', 'oasis_fruteria@gmail.com'),
('Licorera La 33', 1098000115, 'Carrera 33 #45-12, Bucaramanga', '3150000115', 'ventas@la33.com'),
('Autoservicio El Porvenir', 1098000116, 'Calle 5 #9-80, Girón', '3150000116', 'porvenir_giron@gmail.com'),
('Billares El Recreo', 1098000117, 'Carrera 10 #12-40, Piedecuesta', '3150000117', 'recreo_billares@outlook.com'),
('Comidas Rápidas El Garaje', 1098000118, 'Calle 36 #25-10, Bucaramanga', '3150000118', 'pedidos@elgaraje.co'),
('Tienda El Triunfo', 1098000119, 'Diagonal 4 #12-05, Girón', '3150000119', 'triunfo_giron@gmail.com'),
('Minimercado La Sexta', 1098000120, 'Carrera 6 #15-44, Piedecuesta', '3150000120', 'sexta_market@gmail.com');

-- 4. INSERTAR PRODUCTOS (50 Registros con Stock Inicial)
INSERT INTO Producto (nombre, precio, volumen_ml, id_categoria, stock_actual, stock_minimo) VALUES 
('Coca-Cola Original 400ml', 3500.00, 400, 1, 150, 40),
('Coca-Cola Original 1.5L', 550  -- 20 Postobón Manzana 1.5Ls0.00, 1500, 1, 200, 40),
('Coca-Cola Original 2.5L', 8500.00, 2500, 1, 100, 40),
('Coca-Cola Sin Azúcar 400ml', 3500.00, 400, 1, 80, 40),
('Coca-Cola Sin Azúcar 1.5L', 5500.00, 1500, 1, 60, 40),
('Fanta Naranja 400ml', 3000.00, 400, 1, 120, 40),
('Fanta Naranja 1.5L', 5000.00, 1500, 1, 90, 40),
('Sprite Lima-Limón 400ml', 3200.00, 400, 1, 110, 40),
('Sprite Lima-Limón 1.5L', 5200.00, 1500, 1, 75, 40),
('Cuatro Toronja 400ml', 3200.00, 400, 1, 45, 40),
('Colombiana 500ml', 3000.00, 500, 2, 300, 40),
('Colombiana 1.5L', 4800.00, 1500, 2, 150, 40),
('Colombiana 3L', 9000.00, 3000, 2, 80, 40),
('Postobón Manzana 500ml', 2800.00, 500, 2, 250, 40),
('Postobón Manzana 1.5L', 4500.00, 1500, 2, 120, 40),
('Postobón Naranja 500ml', 2800.00, 500, 2, 140, 40),
('Postobón Uva 500ml', 2800.00, 500, 2, 100, 40),
('Kola Hipinto 500ml', 2700.00, 500, 2, 400, 40),
('Kola Hipinto 1.5L', 4200.00, 1500, 2, 180, 40),
('Bretaña Soda 300ml', 2500.00, 300, 2, 220, 40),
('Agua Cristal sin gas 600ml', 2000.00, 600, 3, 500, 40),
('Agua Cristal sin gas 1L', 3000.00, 1000, 3, 300, 40),
('Agua Cristal con gas 600ml', 2200.00, 600, 3, 150, 40),
('Agua Brisa sin gas 600ml', 2000.00, 600, 3, 200, 40),
('Agua Brisa con gas 600ml', 2200.00, 600, 3, 180, 40),
('Agua Manantial 500ml', 3500.00, 500, 3, 90, 40),
('Bolsa de Agua Cristal 6L', 6500.00, 6000, 3, 40, 40),
('H2O Limoneto 600ml', 2800.00, 600, 3, 130, 40),
('Agua con Gas y Limón 500ml', 2500.00, 500, 3, 110, 40),
('Agua Purificada Genérica 500ml', 1500.00, 500, 3, 600, 40),
('Jugo Hit Mora 500ml', 2600.00, 500, 4, 200, 40),
('Jugo Hit Naranja 500ml', 2600.00, 500, 4, 180, 40),
('Jugo Hit Tropical 500ml', 2600.00, 500, 4, 150, 40),
('Jugo Hit Lulo 500ml', 2600.00, 500, 4, 140, 40),
('Jugo Hit Mango 500ml', 2600.00, 500, 4, 160, 40),
('Jugo Hit Caja 200ml', 1500.00, 200, 4, 400, 40),
('Del Valle Naranja 400ml', 2800.00, 400, 4, 120, 40),
('Del Valle Mango 400ml', 2800.00, 400, 4, 110, 40),
('Tampico Citrus 500ml', 2500.00, 500, 4, 300, 40),
('Tampico Citrus 1.5L', 5500.00, 1500, 4, 100, 40),
('Red Bull Original 250ml', 7500.00, 250, 5, 80, 40),
('Red Bull Sugar Free 250ml', 7500.00, 250, 5, 70, 40),
('Monster Energy 473ml', 8500.00, 473, 5, 60, 40),
('Monster Ultra White 473ml', 8500.00, 473, 5, 55, 40),
('Vive 100 Original 240ml', 2000.00, 240, 5, 500, 40),
('Vive 100 Mega 500ml', 3500.00, 500, 5, 300, 40),
('Peak Energizante 500ml', 3000.00, 500, 5, 120, 40),
('Gatorade Blue Bolt 500ml', 3800.00, 500, 5, 200, 40),
('Gatorade Frutas Tropicales 500ml', 3800.00, 500, 5, 180, 40),
('Speed Max Canasta 250ml', 1800.00, 250, 5, 450, 40);

-- 1. INSERTAR CABECERAS DE PEDIDOS (25 Pedidos en total)
INSERT INTO Pedido (id_pedido, id_sede, id_cliente, fecha_pedido, total_sin_iva, total_con_iva) VALUES 
(1, 1, 1, '2026-04-10 08:30:00', 72500.00, 86275.00),
(2, 2, 2, '2026-04-10 09:15:00', 29400.00, 34986.00),
(3, 3, 3, '2026-04-11 10:00:00', 95000.00, 113050.00),
(4, 1, 4, '2026-04-11 11:20:00', 76200.00, 90678.00),
(5, 2, 5, '2026-04-12 14:00:00', 43000.00, 51170.00),
(6, 3, 6, '2026-04-12 15:30:00', 167000.00, 198730.00),
(7, 1, 7, '2026-04-13 08:00:00', 86400.00, 102816.00),
(8, 2, 8, '2026-04-13 09:45:00', 47500.00, 56525.00),
(9, 3, 9, '2026-04-14 11:10:00', 188500.00, 224315.00),
(10, 1, 10, '2026-04-14 16:20:00', 61000.00, 72590.00),
(11, 2, 11, '2026-04-15 07:30:00', 103200.00, 122808.00),
(12, 3, 12, '2026-04-15 10:00:00', 43300.00, 51527.00),
(13, 1, 13, '2026-04-15 12:45:00', 130000.00, 154700.00),
(14, 2, 14, '2026-04-16 13:20:00', 62000.00, 73780.00),
(15, 3, 15, '2026-04-16 14:50:00', 163400.00, 194446.00),
(16, 1, 16, '2026-04-16 15:10:00', 31000.00, 36890.00),
(17, 2, 17, '2026-04-16 16:00:00', 62200.00, 74018.00),
(18, 3, 18, '2026-04-16 16:30:00', 180000.00, 214200.00),
(19, 1, 19, '2026-04-16 17:00:00', 61400.00, 73066.00),
(20, 2, 20, '2026-04-16 17:30:00', 95700.00, 113883.00),
(21, 1, 4, '2026-04-16 10:00:00', 255000.00, 303450.00),
(22, 2, 6, '2026-04-16 11:30:00', 185200.00, 220388.00),
(23, 3, 13, '2026-04-16 14:15:00', 312000.00, 371280.00),
(24, 1, 9, '2026-04-16 15:45:00', 145000.00, 172550.00),
(25, 2, 11, '2026-04-16 16:30:00', 210500.00, 250495.00);


-- CABECESRAS DE DETALLE_PEDIDO (20)

INSERT INTO Detalle_pedido (id_detalle, id_producto, id_pedido, cantidad, subtotal) VALUES 
(1, 1, 1, 10, 35000.00),
(2, 11, 2, 4, 12000.00),
(3, 41, 3, 6, 45000.00),
(4, 14, 4, 10, 28000.00),
(5, 21, 5, 7, 14000.00),
(6, 43, 6, 10, 85000.00),
(7, 8, 7, 12, 38400.00),
(8, 31, 8, 7, 18200.00),
(9, 3, 9, 14, 119000.00),
(10, 18, 10, 11, 29700.00),
(11, 48, 11, 14, 53200.00),
(12, 24, 12, 11, 22000.00),
(13, 2, 13, 12, 66000.00),
(14, 39, 14, 17, 42500.00),
(15, 44, 15, 11, 93500.00),
(16, 36, 16, 9, 13500.00),
(17, 19, 17, 6, 25200.00),
(18, 13, 18, 12, 108000.00),
(19, 28, 19, 13, 36400.00),
(20, 15, 20, 11, 49500.00);

-- PEDIDOS GRANDES (5)

INSERT INTO Detalle_pedido (id_producto, id_pedido, cantidad, subtotal) VALUES 

(3, 21, 20, 170000.00), 
(21, 21, 30, 60000.00), 
(31, 21, 10, 25000.00),  
(43, 22, 15, 127500.00),
(8, 22, 12, 38400.00), 
(25, 22, 10, 19300.00), 
(13, 23, 24, 216000.00), 
(1, 23, 12, 42000.00),   
(41, 23, 6, 45000.00),   
(35, 23, 4, 9000.00),    
(18, 24, 30, 81000.00),
(19, 24, 10, 42000.00), 
(22, 24, 10, 22000.00), 
(48, 25, 20, 76000.00), 
(15, 25, 20, 90000.00),
(5, 25, 10, 44500.00);  