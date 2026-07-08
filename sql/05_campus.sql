CREATE TABLE clientes_publicos_quevedo (
    cliente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    ciudad VARCHAR(40) NOT NULL
);

INSERT INTO clientes_publicos_quevedo VALUES
(1, 'Maria Alvarado', 'Quevedo'),
(3, 'Ana Vera', 'Quevedo');