Crear una función de nombre UNIARTI que dada una unidad de medida pasada como parámetro, cuente el total de artículos que tienen asignada dicha unidad.
En caso de que el código de unidad no exista devolver -1.

Probar la función llamándola desde un bloque anónimo y sacar los mensajes correpondientes.

 
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
	END IF;

	SELECT COUNT(*) INTO CANTIDAD
	FROM ARTICULOS
	WHERE UNIDAD = UNI;
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
	COD UNIDADES.UNIDAD%TYPE	
	
 

Realizar un procedimiento de nombre TOTALENTRE2 que dados dos códigos de albarán, calcular el total facturado entre dichos albaranes.
Validar lo parámetros de forma que el primer código sea obligatoriamente menor al segundo.



Probar la función llamándola desde un bloque anónimo y sacar los mensajes correpondientes.

 

 

Proceder a realizar una función de nombre CLIENARTI que dado un nombre de empresa devuelva el total de artículos comprados por ese cliente.
Controlar las excepciones que se consideren necesarias y sacar los mensajes correspondientes por pantalla.

 

 

Desde un bloque anónimo hacer una llamada a CLIENARTI y proceder de la siguiente manera:
· Si el cliente ha comprado más de 20 artículos añadir dicha información a una tabla de nombre HABITUALES.

· Si existe dicha empresa de cliente en la tabla actualizar la fecha y acumular el número de artículos.

· Si no existe añadir una fila a dicha tabla.

 

 

Descripción Tabla Habituales:

 Columna Tipo

 Empresa Alfanumérico(30) not null Clave Primaria

 Fecha_ult Fecha

 Cantidad_art  Numérico

 

 

Crear un procedimiento de nombre ACTUALBA que dado un número de albarán y una fecha modifique la fecha de pago de dicho albarán. Si la fecha es nula, se actualizará con la actual.
Validar la fecha para que no sea superior a la actual ni inferior al año 2000.

 

 

Modificar el procedimiento anterior para que inserte en una tabla de nombre ALBACTU los valores antiguos y nuevos de los albaranes actualizados.
 

 

Descripción Tabla Albactu:

 Columna Tipo

 Albaran Number(3) not null

 Fecha_antigua Fecha

 Fecha_nueva  Fecha
