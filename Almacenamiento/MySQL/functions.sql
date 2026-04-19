USE GaseosasDelValle;

DELIMITER //

-- ======================================================
-- 1. FUNCIÓN: CALCULAR TOTAL CON IVA
-- ======================================================
CREATE FUNCTION fn_calcular_total_con_iva(p_id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total_iva DECIMAL(10,2);
    
    -- Sumamos los subtotales y multiplicamos por 1.19
    SELECT SUM(subtotal) * 1.19 INTO v_total_iva
    FROM Detalle_pedido
    WHERE id_pedido = p_id_pedido;
    
    -- Si el pedido no tiene detalles aún, devolvemos 0 en lugar de NULL
    RETURN IFNULL(v_total_iva, 0);
END //

-- ======================================================
-- 2. FUNCIÓN: VALIDAR STOCK
-- ======================================================
CREATE FUNCTION fn_validar_stock(p_id_producto INT, p_cantidad INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_mensaje VARCHAR(100);
    
    -- Obtenemos el stock del producto
    SELECT stock_actual INTO v_stock_actual 
    FROM Producto 
    WHERE id_producto = p_id_producto;
    
    -- Lógica de validación
    IF v_stock_actual >= p_cantidad THEN
        SET v_mensaje = 'Stock suficiente';
    ELSE
        SET v_mensaje = CONCAT('Stock insuficiente. Disponible: ', v_stock_actual);
    END IF;
    
    RETURN v_mensaje;
END //

DELIMITER ;