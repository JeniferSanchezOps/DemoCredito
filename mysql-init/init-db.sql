-- Crear tabla producto_credito
CREATE TABLE IF NOT EXISTS producto_credito (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    nombre_producto VARCHAR(255) NOT NULL
);

-- Insertar datos de ejemplo
INSERT INTO producto_credito (cliente_id, nombre_producto) VALUES
(1, 'Crédito personal'),
(1, 'Línea de crédito'),
(2, 'Préstamo educativo');

-- Crear tabla solicitud_producto
CREATE TABLE IF NOT EXISTS solicitud_producto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    tipo_producto VARCHAR(255),
    fecha DATETIME
);
