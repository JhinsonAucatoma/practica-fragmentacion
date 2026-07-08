# Práctica de Fragmentación de Bases de Datos Distribuidas
## Requisitos previos

- Docker Desktop instalado y en ejecución
- 4 GB de RAM libres, 5 GB de espacio en disco
- Una terminal (PowerShell/CMD en Windows, terminal en macOS/Linux)

Verifica que Docker funciona:

```bash
docker --version
docker compose version
```

## Estructura del proyecto

```
practica-fragmentacion/
  docker-compose.yml
  sql/
    01_esquema_central.sql
    02_datos.sql
    03_fragmentacion_horizontal.sql
    03_campus.sql
    03_babahoyo.sql
    03_ventanas.sql
    04_fragmentacion_vertical.sql
    04_campus.sql
    04_babahoyo.sql
    05_fragmentacion_mixta.sql
    05_campus.sql
    05_ventanas.sql
    05_babahoyo.sql
    06_vistas_globales.sql
    07_verificacion.sql
```

## 1. Levantar los tres nodos

```bash
docker compose up -d
docker compose ps
```

Confirma que `pg-campus`, `pg-babahoyo` y `pg-ventanas` estén en estado
`running`.

## 2. Esquema centralizado (referencia)

Se aplica **solo en pg-campus**:

```bash
docker exec -i pg-campus psql -U admin -d cafeteria < sql/01_esquema_central.sql
docker exec -i pg-campus psql -U admin -d cafeteria < sql/02_datos.sql
```

Verificación:

```bash
docker exec -it pg-campus psql -U admin -d cafeteria -c "SELECT * FROM pedidos;"
```

## 3. Fragmentación horizontal (tabla `pedidos_fragmento`)

Se aplica el esquema en los **tres nodos**, y luego los datos correspondientes
a cada sede:

```bash
docker exec -i pg-campus   psql -U admin -d cafeteria < sql/03_fragmentacion_horizontal.sql
docker exec -i pg-babahoyo psql -U admin -d cafeteria < sql/03_fragmentacion_horizontal.sql
docker exec -i pg-ventanas psql -U admin -d cafeteria < sql/03_fragmentacion_horizontal.sql

docker exec -i pg-campus   psql -U admin -d cafeteria < sql/03_campus.sql
docker exec -i pg-babahoyo psql -U admin -d cafeteria < sql/03_babahoyo.sql
docker exec -i pg-ventanas psql -U admin -d cafeteria < sql/03_ventanas.sql
```

Verificación (deben salir 3, 3 y 2 filas respectivamente):

```bash
docker exec -it pg-campus   psql -U admin -d cafeteria -c "SELECT * FROM pedidos_fragmento;"
docker exec -it pg-babahoyo psql -U admin -d cafeteria -c "SELECT * FROM pedidos_fragmento;"
docker exec -it pg-ventanas psql -U admin -d cafeteria -c "SELECT * FROM pedidos_fragmento;"
```

> **Nota:** se usó `pedidos_fragmento` en lugar de `pedidos` porque en
> `pg-campus` ya existía una tabla `pedidos` del esquema centralizado.

## 4. Fragmentación vertical (`clientes_publicos` / `clientes_contacto`)

```bash
docker exec -i pg-campus   psql -U admin -d cafeteria < sql/04_campus.sql
docker exec -i pg-babahoyo psql -U admin -d cafeteria < sql/04_babahoyo.sql
```

Verificación:

```bash
docker exec -it pg-campus   psql -U admin -d cafeteria -c "SELECT * FROM clientes_publicos;"
docker exec -it pg-babahoyo psql -U admin -d cafeteria -c "SELECT * FROM clientes_contacto;"
```

## 5. Fragmentación mixta

```bash
docker exec -i pg-campus   psql -U admin -d cafeteria < sql/05_campus.sql
docker exec -i pg-ventanas psql -U admin -d cafeteria < sql/05_ventanas.sql
docker exec -i pg-babahoyo psql -U admin -d cafeteria < sql/05_babahoyo.sql
```

Verificación:

```bash
docker exec -it pg-campus   psql -U admin -d cafeteria -c "SELECT * FROM clientes_publicos_quevedo;"
docker exec -it pg-ventanas psql -U admin -d cafeteria -c "SELECT * FROM clientes_publicos_otras;"
docker exec -it pg-babahoyo psql -U admin -d cafeteria -c "SELECT * FROM clientes_contacto_quevedo;"
docker exec -it pg-babahoyo psql -U admin -d cafeteria -c "SELECT * FROM clientes_contacto_otras;"
```

## 6. Vistas globales

Se ejecuta **solo en pg-campus**, que actúa como nodo coordinador:

```bash
docker exec -i pg-campus psql -U admin -d cafeteria < sql/06_vistas_globales.sql
```

Pruebas:

```bash
docker exec -it pg-campus psql -U admin -d cafeteria -c "SELECT * FROM pedidos_global ORDER BY pedido_id;"
docker exec -it pg-campus psql -U admin -d cafeteria -c "SELECT * FROM clientes_global ORDER BY cliente_id;"
docker exec -it pg-campus psql -U admin -d cafeteria -c "SELECT sede, SUM(monto) AS total FROM pedidos_global GROUP BY sede;"
```

## 7. Verificación de las tres condiciones

```bash
docker exec -i pg-campus psql -U admin -d cafeteria < sql/07_verificacion.sql
```
Resultados esperados:

| Condición | Resultado esperado |
|---|---|
| Completitud | `pedidos_global` y `pedidos` devuelven ambas 8 filas |
| Reconstrucción | Totales por sede idénticos en ambas consultas (Campus: 4.25, Babahoyo: 4.25, Ventanas: 2.25) |
| Disjunción | La consulta de duplicados devuelve 0 filas |

## Apagar el entorno

```bash
docker compose down
```

Para eliminar también los volúmenes de datos:

```bash
docker compose down -v
```
