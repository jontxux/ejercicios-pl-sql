-- 7. Definir un procedimiento de nombre PRECIO_ARTI que seleccione de la tabla Mis_artículos las filas que superen un número de existencias dado.

-- Para cada uno de ellos compruebe y haga lo siguiente:

-- ü Si el precio de venta del artículo que se trata es nulo y el precio de costo no lo es, asignar al precio de venta, su precio de costo aplicándole una subida del 5%.

-- ü Si el precio de costo es nulo, asignarle su precio de venta, si no es nulo.

-- ü Si los dos precios son nulos, borrar el artículo.


-- Obtener al final del procedimiento, el número de filas actualizadas y borradas.


-- Adecuar los datos de la tabla Mis_artículos, para que el programa pueda ser convenientemente probado.


-- Realizar tres versiones:

-- ü Cursor FOR UPDATE.

-- ü ROWID

-- ü Sin ninguno de las anteriores.
CREATE OR REPLACE PROCEDURE PRECIO_ARTI(EXIS IN MIS_ARTICULOS.EXISTENCIAS%TYPE)

CURSOR CONSULTA IS
	SELECT PR_COST, PR_VENT
	FROM MIS_ARTICULOS
	WHERE 


CREATE OR REPLACE PROCEDURE PRECIO_ARTI(EXIS IN MIS_ARTICULOS.EXISTENCIAS%TYPE)

CURSOR CONSULTA IS
	SELECT PR_COST, PR_VENT, ROWID
	FROM MIS_ARTICULOS
-- 8. Dada la tabla Mis_articulos, definir un procedimiento de nombre FECHAS_ARTI que declare un cursor que devuelva los artículos de los suministradores de la descripción de la provincia que se pase como parámetro de entrada.

-- Compruebe los valores de las columnas fecha de última salida y fecha de última entrada y proceda:

-- ü Si los dos son nulos, borrarlo.

-- ü Si alguno es nulo, asignarle la fecha actual.

-- ü Si la entrada es más reciente que la salida. Actualizar la salida con la fecha de entrada.


-- Sacar por pantalla el número de artículos actualizados y borrados.


-- Versiones:

-- ü FOR UPDATE.

-- ü ROWID.

-- ü Sin ninguno de las anteriores.


-- 9. Crear una función de nombre BORRA_CLIENTE que dado un código de cliente lo borre de la tabla Mis_clientes si y solo si existe y no ha realizado ninguna compra.

-- Realizar un bloque PL/SQL que llame a dicha función y devuelva alguno de éstos mensajes:

-- ü El cliente XX de nombre XXXXX ha sido borrado.

-- ü El cliente XX de nombre XXXXX tiene compras.

-- ü El cliente XX no existe.


-- 10. Crear la tabla Mis_Formpagos a imagen de la tabla Formpagos del usuario almacén.

-- 11. Crear un procedimiento de nombre ALTA_FORMA que dado un código y una descripción de una forma de pago:

-- ü Inserte la nueva forma de pago si no existe ni el código ni la nueva descripción de forma de pago en la tabla Mis_Formpagos.

-- ü Actualice la descripción de la forma de pago si su código existe.


-- Informar en cada caso.
