-- Creación de la base de datos
CREATE DATABASE brosteria;
USE brosteria;

-- Tabla PERMISO
CREATE TABLE PERMISO (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    nombre_permiso VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

-- Tabla ROL
CREATE TABLE ROL (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

-- Tabla intermedia ROL_PERMISO
CREATE TABLE ROL_PERMISO (
    id_rol INT,
    id_permiso INT,
    PRIMARY KEY (id_rol, id_permiso),
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol),
    FOREIGN KEY (id_permiso) REFERENCES PERMISO(id_permiso)
);

-- Tabla USUARIO
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol)
);

-- Tabla CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(200),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

-- Tabla CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    imagen_url VARCHAR(255),
    estado ENUM('activa', 'inactiva') DEFAULT 'activa'
);

-- Tabla PRODUCTO
CREATE TABLE PRODUCTO (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    precio DECIMAL(10,2) NOT NULL,
    imagen_url VARCHAR(255),
    estado ENUM('disponible', 'no disponible') DEFAULT 'disponible',
    stock INT DEFAULT 0,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria)
);

-- Tabla CARRITO
CREATE TABLE CARRITO (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('activo', 'abandonado', 'finalizado') DEFAULT 'activo',
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

-- Tabla ITEM_CARRITO
CREATE TABLE ITEM_CARRITO (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_carrito INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    comentarios VARCHAR(200),
    FOREIGN KEY (id_carrito) REFERENCES CARRITO(id_carrito),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);

-- Tabla PEDIDO
CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_usuario INT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'en_preparacion', 'listo', 'entregado', 'cancelado') DEFAULT 'pendiente',
    tipo_pedido ENUM('mesa', 'domicilio', 'recoger') NOT NULL,
    direccion_entrega VARCHAR(200),
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

-- Tabla DETALLE_PEDIDO
CREATE TABLE DETALLE_PEDIDO (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    comentarios VARCHAR(200),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);

-- Tabla VENTA
CREATE TABLE VENTA (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('completada', 'cancelada', 'reembolsada') DEFAULT 'completada',
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'app') NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    impuestos DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
);

-- Tabla PAGO
CREATE TABLE PAGO (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'app') NOT NULL,
    estado ENUM('completado', 'fallido', 'reembolsado') DEFAULT 'completado',
    referencia VARCHAR(100),
    FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta)
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_cliente_email ON CLIENTE(email);
CREATE INDEX idx_producto_categoria ON PRODUCTO(id_categoria);
CREATE INDEX idx_pedido_cliente ON PEDIDO(id_cliente);
CREATE INDEX idx_pedido_fecha ON PEDIDO(fecha_pedido);
CREATE INDEX idx_venta_pedido ON VENTA(id_pedido);
