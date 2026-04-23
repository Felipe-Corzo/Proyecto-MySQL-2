/* =============================================================================
PROYECTO: GASEOSAS DEL VALLE S.A.
DESCRIPCIÓN: Script de Automatización (Vistas, Triggers, Consultas y Funciones)
AUTOR: Felipe Corzo
=============================================================================
*/

USE gaseosas_del_valle;

-- =============================================================================
-- 1. FUNCIONES ADICIONALES (Cálculos de Negocio)
-- =============================================================================

DELIMITER $$

-- Función para calcular el IVA (19%)
CREATE FUNCTION calcular_iva_producto(precio_base DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN precio_base * 0.19;
END $$

-- Función para verificar stock (Versión final corregida)
CREATE FUNCTION verificar_stock_producto(id_p INT, cant_solicitada INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE stock_actual_val INT;
    DECLARE respuesta VARCHAR(100);
    
    SELECT stock_actual INTO stock_actual_val FROM Producto WHERE id_producto = id_p;
    
    IF stock_actual_val IS NULL THEN SET respuesta = 'Producto no encontrado';
    ELSEIF stock_actual_val >= cant_solicitada THEN SET respuesta = 'Suficiente';
    ELSE SET respuesta = 'Insuficiente';
    END IF;
    
    RETURN respuesta;
END $$

DELIMITER ;

-- =============================================================================
-- 2. VISTAS (Reportes Dinámicos)
-- =============================================================================

-- Vista de productos con stock crítico (Punto 2 del requerimiento)
CREATE OR REPLACE VIEW vista_productos_bajo_stock AS
SELECT 
    p.nombre AS Producto,
    c.nombre_categoria AS Categoria,
    p.stock_actual AS Stock,
    s.nombre_sede AS Sede
FROM Producto p
JOIN Categoria c ON p.id_categoria = c.id_categoria
JOIN Sede s ON p.id_sede = s.id_sede
WHERE p.stock_actual <= 10;

-- Vista de ingresos por Sede (Extra para gestión)
CREATE OR REPLACE VIEW vista_ventas_por_sede AS
SELECT 
    s.nombre_sede, 
    SUM(ped.total_con_iva) AS ingresos_totales
FROM Sede s
JOIN Pedido ped ON s.id_sede = ped.id_sede
GROUP BY s.nombre_sede;

-- =============================================================================
-- 3. TRIGGERS (Integridad y Automatización)
-- =============================================================================

DELIMITER $$

-- Trigger para evitar stock negativo (Punto 4 del requerimiento)
CREATE TRIGGER control_stock_negativo
BEFORE INSERT ON Detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE stock_disponible INT;
    
    SELECT stock_actual INTO stock_disponible 
    FROM Producto 
    WHERE id_producto = NEW.id_producto;
    
    IF NEW.cantidad > stock_disponible THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para procesar el pedido';
    END IF;
END $$

-- Trigger de Auditoría de Precios (Extra para seguridad)
CREATE TRIGGER tr_auditoria_precios
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO Auditoria_precios (id_producto, precio_anterior, precio_nuevo, fecha_cambio, usuario)
        VALUES (OLD.id_producto, OLD.precio, NEW.precio, NOW(), USER());
    END IF;
END $$

-- Trigger para actualizar stock después de un pedido (Extra)
CREATE TRIGGER tr_actualizar_stock_post_venta
AFTER INSERT ON Detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE Producto 
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END $$

DELIMITER ;

-- =============================================================================
-- 4. CONSULTAS AVANZADAS (Punto 3 del requerimiento)
-- =============================================================================

-- Listado de Clientes con gasto superior al promedio general
SELECT 
    c.nombre_cliente, 
    SUM(p.total_con_iva) AS total_gastado
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_cliente
HAVING SUM(p.total_con_iva) > (
    SELECT AVG(total_con_iva) FROM Pedido
)
ORDER BY total_gastado DESC;


/* =============================================================================
EXTENSIÓN DE LÓGICA EMPRESARIAL - GASEOSAS DEL VALLE S.A.
Incluye: Funciones de fidelización, Triggers de seguridad, Vistas de KPI y Reportes.
============================================================================= */

USE gaseosas_del_valle;

-- =============================================================================
-- 1. FUNCIONES (Lógica de Negocio Avanzada)
-- =============================================================================

DELIMITER $$

-- A. Función para clasificar clientes según su gasto (Fidelización)
CREATE FUNCTION clasificar_cliente(p_id_cliente INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE categoria VARCHAR(20);
    
    SELECT SUM(total_con_iva) INTO total FROM Pedido WHERE id_cliente = p_id_cliente;
    
    IF total > 1000000 THEN SET categoria = 'PLATINO';
    ELSEIF total BETWEEN 500000 AND 1000000 THEN SET categoria = 'ORO';
    ELSE SET categoria = 'ESTÁNDAR';
    END IF;
    
    RETURN COALESCE(categoria, 'NUEVO');
END $$

-- B. Función para calcular el peso total de un pedido (Logística)
-- Asumiendo que volumen_ml es proporcional al peso (1ml = 1g aprox)
CREATE FUNCTION calcular_peso_pedido_kg(p_id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE peso_total DECIMAL(10,2);
    SELECT SUM(p.volumen_ml * dp.cantidad) / 1000 INTO peso_total
    FROM Detalle_pedido dp
    JOIN Producto p ON dp.id_producto = p.id_producto
    WHERE dp.id_pedido = p_id_pedido;
    
    RETURN peso_total;
END $$

DELIMITER ;

-- =============================================================================
-- 2. VISTAS (KPIs y Tableros de Control)
-- =============================================================================

-- A. Vista de Surtido Crítico (Prioridad para compras)
CREATE OR REPLACE VIEW vista_necesidad_reabastecimiento AS
SELECT 
    p.nombre, 
    p.stock_actual, 
    p.stock_minimo,
    (p.stock_minimo - p.stock_actual) AS cantidad_a_comprar,
    s.nombre_sede,
    s.encargado
FROM Producto p
JOIN Sede s ON p.id_sede = s.id_sede
WHERE p.stock_actual < p.stock_minimo;

-- B. Ranking de Gaseosas más Vendidas (Top 5)
CREATE OR REPLACE VIEW vista_top_ventas_gaseosas AS
SELECT 
    p.nombre, 
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal) AS ingresos_generados
FROM Producto p
JOIN Detalle_pedido dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;

-- C. Vista de Pedidos con IVA y Totales (Para Contabilidad)
CREATE OR REPLACE VIEW vista_facturacion_detallada AS
SELECT 
    pe.id_pedido,
    pe.fecha_pedido,
    c.nombre_cliente,
    pe.total_sin_iva,
    (pe.total_con_iva - pe.total_sin_iva) AS valor_iva,
    pe.total_con_iva
FROM Pedido pe
JOIN Cliente c ON pe.id_cliente = c.id_cliente;

-- =============================================================================
-- 3. TRIGGERS (Seguridad y Automatización de Procesos)
-- =============================================================================

DELIMITER $$

-- A. Validar que un cliente no tenga el correo vacío al registrarse
CREATE TRIGGER tr_validar_correo_cliente
BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    IF NEW.correo NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El formato del correo electrónico es inválido';
    END IF;
END $$

-- B. Prevenir la eliminación de sedes que tienen stock de productos
CREATE TRIGGER tr_prevenir_borrado_sede
BEFORE DELETE ON Sede
FOR EACH ROW
BEGIN
    DECLARE total_productos INT;
    SELECT COUNT(*) INTO total_productos FROM Producto WHERE id_sede = OLD.id_sede;
    
    IF total_productos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar la sede: tiene productos asociados en inventario';
    END IF;
END $$

-- C. Actualizar automáticamente los totales de la tabla Pedido al insertar detalles
CREATE TRIGGER tr_actualizar_totales_pedido
AFTER INSERT ON Detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE Pedido 
    SET total_sin_iva = (SELECT SUM(subtotal) FROM Detalle_pedido WHERE id_pedido = NEW.id_pedido),
        total_con_iva = (SELECT SUM(subtotal) * 1.19 FROM Detalle_pedido WHERE id_pedido = NEW.id_pedido)
    WHERE id_pedido = NEW.id_pedido;
END $$

DELIMITER ;

-- =============================================================================
-- 4. CONSULTAS AVANZADAS (Reportes Estratégicos)
-- =============================================================================

-- A. Reporte de Sedes con mayor eficiencia (Promedio de venta por pedido)
SELECT 
    s.nombre_sede, 
    COUNT(p.id_pedido) AS total_pedidos,
    AVG(p.total_con_iva) AS promedio_venta_por_pedido
FROM Sede s
JOIN Pedido p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede
ORDER BY promedio_venta_por_pedido DESC;

-- B. Clientes inactivos (Que no han hecho pedidos en los últimos 6 meses)
SELECT nombre_cliente, identificacion, correo
FROM Cliente
WHERE id_cliente NOT IN (
    SELECT DISTINCT id_cliente 
    FROM Pedido 
    WHERE fecha_pedido >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
);

-- C. Análisis de ingresos mensuales
SELECT 
    DATE_FORMAT(fecha_pedido, '%Y-%m') AS mes,
    COUNT(id_pedido) AS numero_pedidos,
    SUM(total_con_iva) AS recaudacion_mensual
FROM Pedido
GROUP BY mes
ORDER BY mes DESC;

-- VER CADA PRODUCTO Y CUANTAS VECES HA SIDO VENDIDO

SELECT nombre , (SELECT SUM(cantidad) FROM Detalle_pedido WHERE id_producto = Producto.id_producto) as VENDIDO
FROM Producto ;

-- PRODUCTOS QUE SON MAS CAROS QUE EL PRECIOPROMEDIO DE TODO EL INVENTARIO

SELECT nombre, precio
FROM Producto 
WHERE precio > (select AVG(precio) FROM Producto);

-- producto mas caro de cada categoria 
SELECT nombre, precio 
FROM Producto P_EXTERNO
WHERE precio = (SELECT MAX(precio) FROM Producto P_INTERNO WHERE P_INTERNO.id_categoria = P_EXTERNO.id_categoria  );