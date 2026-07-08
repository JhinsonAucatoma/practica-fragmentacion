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