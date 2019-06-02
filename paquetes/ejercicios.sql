-- 19. Crear un paquete de nombre MIPAQ_FUN en el que se declaren y guarden los siguientes objetos:
-- o Constante PI.
-- o Cursor MIS_PROVINCIAS que recorra las provincias que tiene clientes y proveedores.
-- o Cursor MIS_ALBARANES que recorra los albaranes que no contienen líneas.
-- o Función TOTAL_ALBARANES que dada una descripción de provincia devuelva el total de albaranes que sus clientes tienen asignados.
-- o Función FACTURADO_CLIENTE que dado un código de cliente devuelva el total facturado de dicho cliente.
CREATE OR REPLACE PACKAGE MIPAQ_FUN IS

	PI CONSTANT NUMBER := 3.141592654;
	CURSOR MIS_PROVINCIAS IS
		SELECT *
		FROM PROVINCIAS
		WHERE EXISTS(SELECT *
						FROM CLIENTES, PROVEEDORES
						WHERE PROVINCIAS.PROVINCIA = CLIENTES.PROVINCIA
						AND PROVINCIAS.PROVINCIA = PROVEEDORES.PROVEEDOR);
    CURSOR MIS_ALBARANES IS
        SELECT *
        FROM ALBARANES
		WHERE NOT EXISTS(SELECT *
						FROM LINEAS
						WHERE ALBARANES.ALBARAN = LINEAS.ALBARAN);
    FUNCTION TOTAL_ALBARANES(DESCR IN PROVINCIAS.DESCRIPCION%TYPE)
    RETURN NUMBER;
    FUNCTION FACTURADO_CLIENTE(COD IN CLIENTES.CLIENTE%TYPE)
    RETURN NUMBER;
END MIPAQ_FUN;
/

CREATE OR REPLACE PACKAGE BODY MIPAQ_FUN IS
    FUNCTION TOTAL_ALBARANES(DESCR IN PROVINCIAS.DESCRIPCION%TYPE)
    RETURN NUMBER;
    IS
        TOTAL NUMBER(10);
    BEGIN
        SELECT COUNT(*) INTO TOTAL
        FROM PROVINCIAS, CLIENTES, ALBARANES
        WHERE PROVINCIAS.PROVINCIA = CLIENTES.PROVINCIA
        AND CLIENTES.CLIENTE = ALBARANES.CLIENTE
        AND PROVINCIAS.DESCRIPCION = DESCR;

        RETURN TOTAL;
    END TOTAL_ALBARANES;

    FUNCTION FACTURADO_CLIENTE(COD IN CLIENTES.CLIENTE%TYPE)
    RETURN NUMBER;
    IS
        TOTAL NUMBER(16,2);
    BEGIN
        SELECT NVL(SUM(CANTIDAD * PRECIO * (1 - DESCUENTO / 100)), 0) INTO TOTAL
        FROM CLIENTES, ALBARANES, LINEAS
        WHERE CLIENTES.CLIENTE = ALBARANES.CLIENTE
        AND ALBARANES.ALBARAN = LINEAS.ALBARAN
        AND CLIENTES.CLIENTE = COD;

        RETURN TOTAL;
    END FACTURADO_CLIENTE;
END;
/

-- 20. Crear una paquete de nombre MIPAQ_PROC que defina:
-- o Un tipo de dato de tipo registro de nombre INFCLIE con un campo código de tipo numérico y nombre de tipo alfanumérico de 30 de longitud.
-- o Un tipo de dato de tipo tabla PL-SQL de nombre CLIE que cada uno de sus elementos sean del tipo de registro definido.
-- o Un tipo de dato VARRAY de nombre VPROVI que sirva para guardar la información de las 50 provincias españolas, con su código, nombre y prefijo.
-- o Definir un procedimiento de nombre BORRA_CLI que dado un código de cliente lo borre siempre y cuando compruebe que no tiene albaranes.
-- o Devuelve en un parámetro de salida tipo booleano si lo ha borrado o no.
-- o Definir un procedimiento de nombre INSERTA_UNI que dada un código de unidad y una descripción inserte un registro de la tabla unidades.
-- Devuelve en un parámetro de salida tipo booleano si lo ha insertado o no.
CREATE OR REPLACE PACKAGE MIPAQ_PROC IS
    TYPE INFCLIE IS RECORD
    (
        CODIGO NUMBER(10);
        NOMBRE VARCHAR2(30);
    )

    TYPE CLIE IS TABLE OF INFCLIE;
    TYPE VPROVI IS VARRAY (50) OF PROVINCIAS%ROWTYPE;
	PROCEDURE BORRA_CLI(CLI CLIENTES.CLIENTE%TYPE, BOR OUT BOOLEAN);
    PROCEDURE INSERTA_UNI(COD UNIDADES.UNIDAD%TYPE, DESCR UNIDADES.DECRIPCION%TYPE, BOR OUT BOOLEAN);
END MIPAQ_PROC;

	