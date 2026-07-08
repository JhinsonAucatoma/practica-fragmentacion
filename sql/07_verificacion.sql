-- 1) COMPLETITUD: la vista global debe tener el mismo número
-- de filas que la tabla centralizada de referencia.
SELECT COUNT(*) AS filas_globales FROM pedidos_global;
SELECT COUNT(*) AS filas_centralizadas FROM pedidos;

-- 2) RECONSTRUCCION: una consulta general contra la vista global
-- debe dar el mismo resultado que la misma consulta contra la BD central.
SELECT sede, SUM(monto) AS total_global
FROM pedidos_global
GROUP BY sede
ORDER BY sede;

SELECT sede, SUM(monto) AS total_centralizado
FROM pedidos
GROUP BY sede
ORDER BY sede;

-- 3) DISJUNCION horizontal: ningún pedido debe aparecer en dos nodos.
SELECT pedido_id, COUNT(*) AS veces
FROM pedidos_global
GROUP BY pedido_id
HAVING COUNT(*) > 1;   -- debe devolver CERO filas