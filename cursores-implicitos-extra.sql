-- 1.Crear una función de nombre UNIARTI que dada una unidad de medida pasada como parámetro, cuente el total de artículos que tienen asignada dicha unidad.
-- En caso de que el código de unidad no exista devolver -1.

-- Probar la función llamándola desde un bloque anónimo y sacar los mensajes correpondientes.

 
CREATE OR REPLACE FUNCTION UNIARTI(UNI UNIDADES.UNIDAD%TYPE)
RETURN NUMBER
IS
	EXISTE NUMBER(5);
	CANTIDAD NUMBER(5);
BEGIN
	SELECT COUNT(*) INTO EXISTE
	FROM UNIDADES
	WHERE UNIDAD = UNI;

	IF EXISTE = 0 THEN
	   CANTIDAD := -1;
	   RETURN CANTIDAD;
	END IF;

	SELECT COUNT(*) INTO CANTIDAD
	FROM ARTICULOS
	WHERE UNIDAD = UNI;

	RETURN CANTIDAD;
END UNIARTI;
/

CREATE OR REPLACE FUNCTION UNIARTI2(UNI UNIDADES.UNIDAD%TYPE)
RETURN NUMBER
IS
	UNID UNIDADES.UNIDAD%TYPE;
	CANTIDAD NUMBER(5);
BEGIN

	SELECT UNIDAD INTO UNID
	FROM UNIDADES
	WHERE UNIDAD = UNI;

	SELECT COUNT(*) INTO CANTIDAD
	FROM ARTICULOS
	WHERE UNIDAD = UNI;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		 RETURN -1;
END UNIARTI2;
/

DECLARE
	UNI UNIDADES.UNIDAD%TYPE := '&UNIDAD';
	CANTIDAD NUMBER(10);
BEGIN
	CANTIDAD := UNIARTI(UNI);
	IF CANTIDAD = -1 THEN
	   DBMS_OUTPUT.PUT_LINE('NO EXISTE LA UNIDAD '|| UNI);
	ELSE
		DBMS_OUTPUT.PUT_LINE('HAY '|| CANTIDAD || ' ARTICULOS CON LA UNIDAD '|| UNI);
	END IF;
END;
/
	
 

-- 2.Realizar un procedimiento de nombre TOTALENTRE2 que dados dos códigos de albarán, calcular el total facturado entre dichos albaranes.
-- Validar lo parámetros de forma que el primer código sea obligatoriamente menor al segundo.

-- Probar la función llamándola desde un bloque anónimo y sacar los mensajes correpondientes.
CREATE OR REPLACE PROCEDURE TOTALENTRE2(COD1 IN ALBARANES.ALBARAN%TYPE,
	   	  		  						COD2 IN ALBARANES.ALBARAN%TYPE,
										TOT OUT NUMBER)
IS
	CODIGO1 ALBARANES.ALBARAN%TYPE := COD1;
	CODIGO2 ALBARANES.ALBARAN%TYPE := COD2;
	AUXILIAR ALBARANES.ALBARAN%TYPE;
BEGIN
	IF CODIGO1 > CODIGO2 THEN
	   AUXILIAR := CODIGO1;
	   CODIGO1 := CODIGO2;
	   CODIGO2 := AUXILIAR;
	END IF;

	SELECT SUM(CANTIDAD * PRECIO * (1 - DESCUENTO / 100)) INTO TOT
	FROM LINEAS
	WHERE ALBARAN BETWEEN COD1 AND COD2;
	
END TOTALENTRE2;
/
 
DECLARE
	CODIGO1 ALBARANES.ALBARAN%TYPE := &ALBARAN1;
	CODIGO2 ALBARANES.ALBARAN%TYPE := &ALBARAN2;
	TOTAL NUMBER(13);
BEGIN
	SELECT ALBARAN INTO CODIGO1
	FROM ALBARANES
	WHERE ALBARAN = CODIGO1;

	SELECT ALBARAN INTO CODIGO2
	FROM ALBARANES
	WHERE ALBARAN = CODIGO2;
	
	TOTALENTRE2(CODIGO1, CODIGO2, TOTAL);
	DBMS_OUTPUT.PUT_LINE('TOTAL FACTURADO DE LOS ALBARANES PEDIDOS ' || TOTAL || '€');

EXCEPTION
		WHEN NO_DATA_FOUND THEN
			 DBMS_OUTPUT.PUT_LINE('ALGUNO DE LOS ALBARANES NO EXISTE');

END;
/
-- 3.Proceder a realizar una función de nombre CLIENARTI que dado un nombre de empresa devuelva el total de artículos comprados por ese cliente.
-- Controlar las excepciones que se consideren necesarias y sacar los mensajes correspondientes por pantalla.
CREATE OR REPLACE FUNCTION CLIENARTI(EMP IN CLIENTES.EMPRESA%TYPE)
RETURN NUMBER
IS
TOTAL NUMBER(13);
EXISTE CLIENTES.EMPRESA%TYPE;
BEGIN
	SELECT EMPRESA INTO EXISTE
	FROM CLIENTES
	WHERE EMP = EMPRESA;

	SELECT SUM(NVL(CANTIDAD), 0) INTO TOTAL
	FROM LINEAS, ALBARANES, CLIENTES
	WHERE CLIENTES.CLIENTE = ALBARANES.CLIENTE
	AND ALBARANES.ALBARAN = LINEAS.ALBARAN;
	

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		 DBMS_OUTPUT.PUT_LINE('NO HAY NINGUN CLIENTE CON ESA EMPRESA');
		 TOTAL := -1;
		 RETURN TOTAL;

	WHEN TOO_MANY_ROWS THEN
		 DBMS_OUTPUT.PUT_LINE('HAY MAS DE UN CLIENTE CON ESA EMPRESA');
 		 TOTAL := -2;
		 RETURN TOTAL;

END CLIENARTI;
/ 


-- 4.Desde un bloque anónimo hacer una llamada a CLIENARTI y proceder de la siguiente manera:
-- · Si el cliente ha comprado más de 20 artículos añadir dicha información a una tabla de nombre HABITUALES.

-- · Si existe dicha empresa de cliente en la tabla actualizar la fecha y acumular el número de artículos.

-- · Si no existe añadir una fila a dicha tabla.

CREATE TABLE HABITUALES(
	   EMPRESA VARCHAR2(30) NOT NULL;
	   FECHA_ULT DATE;
	   CANTIDAD_ART LINEAS.CANTIDAD%TYPE;
);

DECLARE
	EMPR CLIENTES.EMPRESA%TYPE := '&EMPRESA';
	TOTAL NUMBER(13);
BEGIN
	TOTAL := CLIENARTI(EMPR);
	IF TOTAL > 20 THEN
	   DECLARE
			;
END;
/

 

 

-- Descripción Tabla Habituales:

--  Columna Tipo

--  Empresa Alfanumérico(30) not null Clave Primaria

--  Fecha_ult Fecha

--  Cantidad_art  Numérico

 

 

Crear un procedimiento de nombre ACTUALBA que dado un número de albarán y una fecha modifique la fecha de pago de dicho albarán. Si la fecha es nula, se actualizará con la actual.
Validar la fecha para que no sea superior a la actual ni inferior al año 2000.

 

 

Modificar el procedimiento anterior para que inserte en una tabla de nombre ALBACTU los valores antiguos y nuevos de los albaranes actualizados.
 

 

Descripción Tabla Albactu:

 Columna Tipo

 Albaran Number(3) not null

 Fecha_antigua Fecha

 Fecha_nueva  Fecha
