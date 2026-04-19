USE GaseosasDelValle;

-- ======================================================
-- 1. VISTA: RESUMEN DE PEDIDOS POR SEDE
-- Propósito: Reporte gerencial de rendimiento por punto de venta.
-- ======================================================
CREATE OR REPLACE VIEW vista_resumen_pedidos_por_sede AS
SELECT 
    s.nombre_sede,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total_sin_iva) AS total_ventas_netas,
    SUM(p.total_con_iva) AS total_ventas_brutas
FROM Sede s
LEFT JOIN Pedido p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede;

-- ======================================================
-- 2. VISTA: PRODUCTOS BAJO STOCK
-- Propósito: Alerta para el departamento de compras/producción.
-- ======================================================
CREATE OR REPLACE VIEW vista_productos_bajo_stock AS
SELECT 
    id_producto,
    nombre,
    stock_actual,
    stock_minimo,
    (stock_minimo - stock_actual) AS cantidad_a_pedir
FROM Producto
WHERE stock_actual <= stock_minimo;

-- ======================================================
-- 3. VISTA: CLIENTES ACTIVOS
-- Propósito: Filtrar solo clientes que realmente generan ingresos.
-- ======================================================
CREATE OR REPLACE VIEW vista_clientes_activos AS
SELECT DISTINCT
    c.id_cliente,
    c.nombre_cliente,
    c.identificacion,
    c.telefono,
    c.correo
FROM Cliente c
INNER JOIN Pedido p ON c.id_cliente = p.id_cliente;


-- CONSULTAS 

-- 1. Productos con stock por debajo del mínimo (Alerta de reabastecimiento)
SELECT nombre, stock_actual, stock_minimo 
FROM Producto 
WHERE stock_actual <= stock_minimo;

-- 2. Pedidos realizados entre dos fechas (Ej: Primera quincena de abril)
SELECT id_pedido, fecha_pedido, total_con_iva 
FROM Pedido 
WHERE fecha_pedido BETWEEN '2026-04-01' AND '2026-04-15';

-- 3. Productos más vendidos (Top 5 por cantidad total)
SELECT pr.nombre, SUM(dp.cantidad) AS unidades_vendidas
FROM Producto pr
JOIN Detalle_pedido dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre
ORDER BY unidades_vendidas DESC
LIMIT 5;

-- 4. Clientes y su cantidad de pedidos realizados
SELECT c.nombre_cliente, COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_cliente;

-- 5. Buscar clientes por nombre parcial (Ej: los que tengan 'Tienda')
SELECT * FROM Cliente 
WHERE nombre_cliente LIKE '%Tienda%';

-- 6. Productos de ciertas categorías usando IN (Ej: Gaseosas y Aguas)
-- Usamos los IDs 1 (Coca-Cola), 2 (Postobón) y 3 (Aguas)
SELECT nombre, precio, id_categoria 
FROM Producto 
WHERE id_categoria IN (1, 2, 3);

-- 7. Cliente con mayor número de pedidos (Usando subconsulta)
SELECT nombre_cliente 
FROM Cliente 
WHERE id_cliente = (
    SELECT id_cliente 
    FROM Pedido 
    GROUP BY id_cliente 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- 8. Pedidos y totales agrupados por sede
SELECT s.nombre_sede, COUNT(p.id_pedido) AS num_pedidos, SUM(p.total_con_iva) AS gran_total
FROM Sede s
JOIN Pedido p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede;