-- 1) Habilitar la extensión que permite conectar con otros nodos
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2) Declarar los otros dos nodos como "servidores remotos"
CREATE SERVER srv_babahoyo
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'pg-babahoyo', dbname 'cafeteria', port '5432');

CREATE SERVER srv_ventanas
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'pg-ventanas', dbname 'cafeteria', port '5432');

-- 3) Indicar con qué usuario/contraseña conectarse a cada nodo remoto
CREATE USER MAPPING FOR admin SERVER srv_babahoyo
    OPTIONS (user 'admin', password 'admin123');
CREATE USER MAPPING FOR admin SERVER srv_ventanas
    OPTIONS (user 'admin', password 'admin123');

-- 4) Crear "tablas espejo" que apuntan a las tablas reales en cada nodo remoto
CREATE FOREIGN TABLE pedidos_babahoyo (
    pedido_id INTEGER, cliente_id INTEGER, producto_id INTEGER,
    fecha DATE, monto NUMERIC(8,2), sede VARCHAR(20)
) SERVER srv_babahoyo OPTIONS (table_name 'pedidos_fragmento');

CREATE FOREIGN TABLE pedidos_ventanas (
    pedido_id INTEGER, cliente_id INTEGER, producto_id INTEGER,
    fecha DATE, monto NUMERIC(8,2), sede VARCHAR(20)
) SERVER srv_ventanas OPTIONS (table_name 'pedidos_fragmento');

-- 5) Vista global horizontal: reconstruye "pedidos" completo con UNION ALL
CREATE VIEW pedidos_global AS
SELECT * FROM pedidos_fragmento          
UNION ALL
SELECT * FROM pedidos_babahoyo           
UNION ALL
SELECT * FROM pedidos_ventanas;          

-- 6) Tabla espejo del fragmento de contacto (vive en pg-babahoyo)
CREATE FOREIGN TABLE clientes_contacto_remota (
    cliente_id INTEGER, email VARCHAR(120), telefono VARCHAR(20)
) SERVER srv_babahoyo OPTIONS (table_name 'clientes_contacto');

-- 7) Vista global vertical: reconstruye "clientes" completo con JOIN
CREATE VIEW clientes_global AS
SELECT p.cliente_id, p.nombre, p.ciudad, c.email, c.telefono
FROM clientes_publicos p                      -- fragmento local (Campus)
JOIN clientes_contacto_remota c USING (cliente_id);  -- fragmento remoto