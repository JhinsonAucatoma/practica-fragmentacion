-- ---- SE EJECUTA EN pg-campus ----
-- Corte horizontal: Ciudad = Quevedo | Corte vertical: datos públicos
CREATE TABLE clientes_publicos_quevedo (
    cliente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    ciudad VARCHAR(40) NOT NULL
);

INSERT INTO clientes_publicos_quevedo VALUES
(1, 'Maria Alvarado', 'Quevedo'),
(3, 'Ana Vera', 'Quevedo');

-- ---- SE EJECUTA EN pg-ventanas ----
-- Corte horizontal: Ciudad = Babahoyo o Ventanas | Corte vertical: datos públicos
CREATE TABLE clientes_publicos_otras (
    cliente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    ciudad VARCHAR(40) NOT NULL
);

INSERT INTO clientes_publicos_otras VALUES
(2, 'Luis Cedeno', 'Babahoyo'),
(4, 'Jose Mendoza', 'Ventanas'),
(5, 'Carla Zambrano', 'Ventanas'),
(6, 'Pedro Suarez', 'Babahoyo');

-- ---- SE EJECUTA EN pg-babahoyo ----
-- Corte horizontal: Ciudad = Quevedo | Corte vertical: datos de contacto
CREATE TABLE clientes_contacto_quevedo (
    cliente_id INTEGER PRIMARY KEY,
    email VARCHAR(120) NOT NULL,
    telefono VARCHAR(20)
);

INSERT INTO clientes_contacto_quevedo VALUES
(1, 'maria@uteq.edu.ec', '0991111111'),
(3, 'ana@uteq.edu.ec', '0993333333');

-- Corte horizontal: Ciudad = Babahoyo o Ventanas | Corte vertical: datos de contacto
CREATE TABLE clientes_contacto_otras (
    cliente_id INTEGER PRIMARY KEY,
    email VARCHAR(120) NOT NULL,
    telefono VARCHAR(20)
);

INSERT INTO clientes_contacto_otras VALUES
(2, 'luis@uteq.edu.ec', '0992222222'),
(4, 'jose@uteq.edu.ec', '0994444444'),
(5, 'carla@uteq.edu.ec', '0995555555'),
(6, 'pedro@uteq.edu.ec', '0996666666');