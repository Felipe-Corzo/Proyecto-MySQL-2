
-- ======================================================
-- 1. TRIGGER: ACTUALIZAR STOCK
-- Acción: Al insertar en Detalle_pedido, descuenta del Producto.
-- ======================================================
DELIMITER //
CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON Detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE Producto 
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //
DELIMITER ;
-- ======================================================
-- 2. TRIGGER: AUDITAR CAMBIO DE PRECIO
-- Acción: Guarda el historial si el precio de un producto cambia.
-- ======================================================
DELIMITER // 
CREATE  TRIGGER tr_auditar_cambio_precio
AFTER UPDATE 
ON Producto
FOR EACH ROW 
BEGIN
   IF OLD.precio <> NEW.precio THEN
   INSERT INTO Auditoria_precios (id_producto, precio_anterior, precio_nuevo, fecha_cambio, usuario) 
   VALUES (OLD.id_producto, OLD.precio, NEW.precio, NOW(),CURRENT_USER());
   END IF;
END //


