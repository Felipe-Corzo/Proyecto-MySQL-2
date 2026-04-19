
CREATE DATABASE IF NOT EXISTS GaseosasDelValle;
USE GaseosasDelValle;


CREATE TABLE Categoria (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Sede (
    id_sede INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    capacidad_almacenamiento INT UNSIGNED,
    encargado VARCHAR(100),
    ubicacion VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE Cliente (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    identificacion BIGINT UNSIGNED NOT NULL UNIQUE,
    direccion VARCHAR(100),
    telefono VARCHAR(13),
    correo VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE Producto (
    id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) UNSIGNED NOT NULL,
    volumen_ml INT UNSIGNED,
    id_categoria INT UNSIGNED,
    stock_actual INT UNSIGNED DEFAULT 0,  
    stock_minimo INT UNSIGNED DEFAULT 40,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) 
        REFERENCES Categoria(id_categoria) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE Pedido (
    id_pedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_sede INT UNSIGNED NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_sin_iva DECIMAL(10,2) UNSIGNED DEFAULT 0,
    total_con_iva DECIMAL(10,2) UNSIGNED DEFAULT 0,
    CONSTRAINT fk_pedido_sede FOREIGN KEY (id_sede) 
        REFERENCES Sede(id_sede) ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) 
        REFERENCES Cliente(id_cliente) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Detalle_pedido (
    id_detalle INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED NOT NULL,
    id_pedido INT UNSIGNED NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    subtotal DECIMAL(10,2) UNSIGNED NOT NULL,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) 
        REFERENCES Producto(id_producto) ON DELETE RESTRICT,
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (id_pedido) 
        REFERENCES Pedido(id_pedido) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Auditoria_precios (
    id_auditoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) DEFAULT (CURRENT_USER())
) ENGINE=InnoDB;