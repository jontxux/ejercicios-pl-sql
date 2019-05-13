-- 7. Definir un procedimiento de nombre PRECIO_ARTI que seleccione de la tabla Mis_artículos las filas que superen un número de existencias dado.

-- Para cada uno de ellos compruebe y haga lo siguiente:

-- ü Si el precio de venta del artículo que se trata es nulo y el precio de costo no lo es, asignar al precio de venta, su precio de costo aplicándole una subida del 5%.

-- ü Si el precio de costo es nulo, asignarle su precio de venta, si no es nulo.

-- ü Si los dos precios son nulos, borrar el artículo.


-- Obtener al final del procedimiento, el número de filas actualizadas y borradas.


-- Adecuar los datos de la tabla Mis_artículos, para que el programa pueda ser convenientemente probado.


-- Realizar tres versiones:
CREATE TABLE MIS_ARTICULOS
AS SELECT *
FROM ARTICULOS;
/

-- ü Cursor FOR UPDATE.
CREATE OR REPLACE PROCEDURE PRECIO_ARTI(EXIS IN MIS_ARTICULOS.EXISTENCIAS%TYPE)
IS
	CURSOR CONSULTA IS
		SELECT *
		FROM ARTICULOS
		WHERE EXISTENCIAS > EXIS
		FOR UPDATE;

	FILA CONSULTA%ROWTYPE;
	ACT NUMBER(5) := 0;
	BOR NUMBER(5) := 0;
BEGIN
	OPEN CONSULTA;
	FETCH CONSULTA INTO FILA;
	WHILE CONSULTA%SQLFOUND LOOP
		IF FILA.PR_VENT IS NULL AND FILA.PR_COST IS NULL THEN
		    DELETE FROM MIS_ARTICULOS
			WHERE CURRENT OF CONSULTA;
			BOR := BOR + 1;
		ELSIF FILA.PR_VENT IS NULL THEN
			UPDATE MIS_ARTICULOS
			SET FILA.PR_VENT = FILA.PR_COST * 1.05;
			WHERE CURRENT OF CONSULTA;
			ACT := ACT + 1;
		ELSIF FILA.PR_COST IS NULL THEN
			UPDATE MIS_ARTICULOS
			SET FILA.PR_COST = FILA.PR_VENT
			WHERE CURRENT OF CONSULTA;
			ACT := ACT + 1;
		END IF;

		FETCH CONSULTA INTO FILA;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE(BOR||' FILAS ACTUALIZADAS Y '||ACT||' FILAS BORRADAS');
END PRECIO_ARTI;
/
-- ü ROWID

-- ü Sin ninguno de las anteriores.
CREATE OR REPLACE PROCEDURE PRECIO_ARTI(EXIS IN MIS_ARTICULOS.EXISTENCIAS%TYPE)
IS
	CURSOR CONSULTA IS
		SELECT ARTICULO, PROVEEDOR, PR_COST, PR_VENT
		FROM ARTICULOS
		WHERE EXISTENCIAS > EXIS;

	FILA CONSULTA%ROWTYPE;
	ACT NUMBER(5) := 0;
	BOR NUMBER(5) := 0;
BEGIN
	OPEN CONSULTA;
	FETCH CONSULTA INTO FILA;
	WHILE CONSULTA%FOUND LOOP
		IF FILA.PR_VENT IS NULL AND FILA.PR_COST IS NULL THEN
		    DELETE FROM MIS_ARTICULOS
			WHERE FILA.ARTICULO = ARTICULO
			AND FILA.PROVEEDOR = PROVEEDOR;
			BOR := BOR + 1;
		ELSIF FILA.PR_VENT IS NULL THEN
			UPDATE MIS_ARTICULOS
			SET PR_VENT = PR_COST * 1.05
			WHERE FILA.ARTICULO = ARTICULO
			AND FILA.PROVEEDOR = PROVEEDOR;
			ACT := ACT + 1;
		ELSIF FILA.PR_COST IS NULL THEN
			UPDATE MIS_ARTICULOS
			SET PR_COST = PR_VENT
			WHERE FILA.ARTICULO = ARTICULO
			AND FILA.PROVEEDOR = PROVEEDOR;
			ACT := ACT + 1;
		END IF;

		FETCH CONSULTA INTO FILA;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE(BOR||' FILAS ACTUALIZADAS Y '||ACT||' FILAS BORRADAS');
END PRECIO_ARTI;
/


-- 8. Dada la tabla Mis_articulos, definir un procedimiento de nombre FECHAS_ARTI que declare un cursor que devuelva los artículos de los suministradores de la descripción de la provincia que se pase como parámetro de entrada.

-- Compruebe los valores de las columnas fecha de última salida y fecha de última entrada y proceda:

-- ü Si los dos son nulos, borrarlo.
CREATE OR REPLACE PROCEDURE FECHAS_ARTI(DES IN PROVINCIAS.DESCRIPCION%TYPE,
	   	  		  						NUMEROARTICULOSACTUALIZADOS OUT NUMBER,
										NUMEROARTICULOSBORRADOS OUT NUMBER)
IS
	CURSOR CONSULTA IS
		SELECT ARTICULO, 
		FROM ARTICULOS
		WHERE EXISTS(SELECT *
					 FROM PROVINCIAS, PROVEEDORES
					 WHERE PROVINCIAS.PROVINCIA = PROVEEDORES.PROVINCIA
					 AND ARTICULOS.PROVEEDOR = PROVEEDORES.PROVEEDOR
					 AND UPPER(PROVINCIAS.DESCRIPCION) = UPPER(DES))
		FOR UPDATE OF ARTICULO;
BEGIN

	FOR FILA IN CONSULTA LOOP
		IF FILA.FEC_ULT_ENT IS NULL AND FILA.FEC_ULT_SAL IS NULL THEN
		    DELETE FROM MIS_ARTICULOS
			WHERE ARTICULO = FILA.ARTICULO
			AND PROVEEDOR = FILA.PROVEEDOR
		ELSIF FI
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
