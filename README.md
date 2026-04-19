# 🥤 Sistema de Gestión: Gaseosas del Valle S.A.

## 📝 1. Descripción del Proyecto
Este proyecto consiste en el diseño e implementación de una base de datos relacional robusta para la distribuidora **Gaseosas del Valle**. El sistema está diseñado para gestionar el ciclo completo de ventas, desde la administración de productos y categorías hasta el seguimiento detallado de pedidos por sede y la auditoría de seguridad en los precios.

**Objetivos clave:**
* **Integridad de Datos:** Uso estricto de llaves foráneas y reglas `ON DELETE`.
* **Automatización:** Reducción de errores manuales mediante triggers.
* **Inteligencia de Negocio:** Vistas predefinidas para la toma de decisiones rápidas.

---

## 🗺️ 2. Modelo Entidad-Relación (E-R)
El modelo conceptual se basa en la interacción de 6 entidades principales, resolviendo la relación de "Muchos a Muchos" entre Pedidos y Productos mediante una tabla de ruptura técnica.

* **Entidades:** `Sede`, `Categoria`, `Producto`, `Cliente`, `Pedido`.
* **Relación Detallada:** `Detalle_pedido` conecta los productos con sus respectivas facturas.
* **Auditoría:** `Auditoria_precios` mantiene la trazabilidad de cambios sensibles.

---

## ⚙️ 3. Lógica Programada

### Triggers (Disparadores)
* **`tr_actualizar_stock`**: Al registrar un nuevo ítem en `Detalle_pedido`, descuenta automáticamente la cantidad del `stock_actual` en la tabla `Producto`.
* **`tr_auditar_cambio_precio`**: Si un administrador modifica el precio de un producto, el sistema guarda el valor anterior, el nuevo, el usuario y la fecha exacta del cambio.

### Funciones (UDF)
* **`fn_calcular_total_con_iva(id_pedido)`**: Recibe el ID de un pedido y retorna el monto total sumando el 19% de IVA de manera automática.
* **`fn_validar_stock(id_producto, cantidad)`**: Retorna un mensaje preventivo (Ej: "Stock insuficiente") antes de intentar procesar una venta.

---

## 📊 4. Reportes y Consultas (Vistas)
Se implementaron vistas para facilitar la lectura de datos complejos:
1.  **`vista_resumen_pedidos_por_sede`**: Total de ventas agrupadas por ubicación física.
2.  **`vista_productos_bajo_stock`**: Reporte crítico de productos que alcanzaron su stock mínimo.
3.  **`vista_clientes_activos`**: Listado de clientes que han generado al menos una transacción.

### Ejemplos de Consultas SQL:
```sql
-- Buscar productos de categorías específicas (Gaseosas y Aguas)
SELECT nombre, precio FROM Producto WHERE id_categoria IN (1, 2, 3);

-- Ranking de los 5 productos más vendidos
SELECT pr.nombre, SUM(dp.cantidad) AS unidades 
FROM Producto pr 
JOIN Detalle_pedido dp ON pr.id_producto = dp.id_producto 
GROUP BY pr.nombre ORDER BY unidades DESC LIMIT 5;