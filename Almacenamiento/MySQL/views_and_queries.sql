
-- ======================================================
-- 1. VISTA: RESUMEN DE PEDIDOS POR SEDE
-- Propósito: Reporte gerencial de rendimiento por punto de venta.
-- ======================================================
create view vista_resumen_pedidos_por_sede as 
SELECT s.nombre_sede as Sede ,COUNT(*) AS 'pedidos', format(SUM(p.total_sin_iva),2) as Subtotal, format(sum(p.total_con_iva),2) as Total
FROM Pedido p INNER JOIN Sede s ON s.id_sede = p.id_sede
GROUP BY s.nombre_sede;

-- ======================================================
-- 2. VISTA: PRODUCTOS BAJO STOCK
-- Propósito: Alerta para el departamento de compras/producción.
-- ======================================================
CREATE VIEW vista_productos_bajo_stock AS
select c.nombre_categoria as Categoria, p.id_producto as ID, p.nombre as Producto, p.stock_actual as Stock 
from Producto p INNER JOIN  Categoria c ON p.id_categoria = c.id_categoria 
where p.stock_actual <= p.stock_minimo;


-- ======================================================
-- 3. VISTA: CLIENTES ACTIVOS
-- Propósito: Filtrar solo clientes que realmente generan ingresos.
-- ======================================================
create view vista_clientes_activos as
select c.nombre_cliente as Nombre ,count(p.id_pedido) as Pedidos, c.direccion as Direccion , c.telefono as Telefono 
from Cliente c join Pedido p on c.id_cliente = p.id_cliente
GROUP BY c.nombre_cliente, c.direccion, c.telefono;



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
SELECT c.id_categoria, c.nombre_categoria, p.nombre, p.precio
FROM Producto p join Categoria c on p.id_categoria = c.id_categoria 
WHERE c.id_categoria IN (1, 2, 3);


-- 7. Cliente con mayor número de pedidos (Usando subconsulta)
SELECT c.id_cliente, c.nombre_cliente,
    (SELECT COUNT(*) FROM Pedido p WHERE p.id_cliente = c.id_cliente) AS total_pedidos
FROM Cliente c
HAVING total_pedidos = (
    SELECT MAX(total_pedidos) FROM (
        SELECT COUNT(*) AS total_pedidos FROM Pedido GROUP BY id_cliente
    ) AS conteo
)
ORDER BY total_pedidos DESC;

-- 8. Pedidos y totales agrupados por sede
SELECT s.nombre_sede, COUNT(p.id_pedido) AS num_pedidos, SUM(p.total_con_iva) AS gran_total
FROM Sede s
JOIN Pedido p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede;