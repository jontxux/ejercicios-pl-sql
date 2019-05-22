
-- 12. Definir un disparador o trigger de base de datos de nombre AUDITAR1 que permita auditar las operaciones de inserción o borrado de datos que se realicen en la tabla Mis_clientes según las siguientes especificaciones:

-- ü En primer lugar, crear desde SQL*Plus la tabla Auditar_cli con la columna de nombre texto de tipo alfanumérico de 200 bytes de longitud, y una columna de nombre operacion de tipo alfanumérico de 20 de longitud que tome uno de éstos tres valores: inserción, borrado o modificación (constraint ck1_tipo).

-- ü Cuando se produzca cualquier manipulación, se insertará una fila en dicha tabla que contendrá:

-- § Fecha y hora.

-- § Número de cliente.

-- § Nombre de empresa.



-- § La operación realizada, INSERCIÓN ó BORRADO.
CREATE TABLE AUDITAR_CLI
(TEXTO VARCHAR2(200),
OPERACION VARCHAR2(20),
	CONSTRAINT CK1_TIPO
	CHECK(UPPER(OPERACION) IN ('INSERCION', 'BORRADO', 'MODIFICACION')))
/

CREATE OR REPLACE TRIGGER AUDITAR1
AFTER INSERT OR DELETE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
	MENSAJE VARCHAR2(200);
	INSERBORRA VARCHAR2(20);
BEGIN
	IF INSERTING THEN
	   	 MENSAJE := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'||:NEW.CLIENTE||:NEW.EMPRESA);
		 INSERBORRA := TO_CHAR('INSERCION');
	ELSIF DELETING THEN			--PODEMOS PONER ELSE TAMBIEN PORQUE ARRIBA LE PONEMOS LO DE AFTER INSERT OR DELETE
		MENSAJE := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'||:OLD.CLIENTE||:OLD.EMPRESA);
		INSERBORRA := TO_CHAR('BORRADO');
	END IF;

	INSERT INTO AUDITAR_CLI
	VALUES(MENSAJE, INSERBORRA);

	DBMS_OUTPUT.PUT_LINE(MENSAJE||' '||INSERBORRA);
EXCEPTION
	WHEN OTHERS THEN
		 DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
	
END;
/

-- 13. Definir un trigger de base de datos de nombre AUDITAR2 que permita auditar las operaciones de modificación en la tabla Mis_clientes e inserte en la tabla Auditar_cli las siguientes especificaciones:

-- § Fecha y hora.

-- § Número de cliente.

-- § Nombre de empresa.

-- § La operación realizada, MODIFICACIÓN.



-- § El valor anterior y el valor nuevo de cada columna modificada.
-- cliente empresa forma de pago provincia
CREATE OR REPLACE TRIGGER AUDITAR2
AFTER UPDATE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
	FECHA VARCHAR2(30) := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS');
	MENSAJE VARCHAR2(250);
	CLI VARCHAR2(50);
	EMPRESA VARCHAR2(50);
	FORMPAGO VARCHAR2(50);
	PROVINCIA VARCHAR2(50);
	MODIFICADO VARCHAR2(20) := 'MODIFICACION';
BEGIN
	IF UPDATING('CLIENTE') THEN
	    CLI := TO_CHAR('CLIENTE ':OLD.CLIENTE||' ==> '||:NEW.CLIENTE);	
	END IF;

	IF UPDATING('EMPRESA') THEN
		EMPRESA := TO_CHAR('EMPRESA ':OLD.EMPRESA||' ==> '||:NEW.EMPRESA);
	END IF;

	IF UPDATING('FORMPAGO') THEN
		FORMPAGO := TO_CHAR('FORMPAGO ':OLD.FORMPAGO||' ==> '||:NEW.FORMPAGO);
	END IF;

	IF UPDATING('PROVINCIA') THEN
		PROVINCIA := TO_CHAR('PROVINCIA ':OLD.PROVINCIA||' ==> '||:NEW.PROVINCIA);
	END IF;

	MENSAJE := FECHA||' '||CLI||' '||EMPRESA||' '||FORMPAGO||' '||PROVINCIA;

	INSERT INTO AUDITAR_CLI
	VALUES(MENSAJE, MODIFICADO);

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);
END;
/

UPDATE MIS_CLIENTES
SET CLIENTE = 500
WHERE CLIENTE = 1;
/


-- 14. Definir un disparador de base de datos que haga fallar cualquier operación de modificación de la descripción o del código de proveedor de los artículos de la tabla Mis_articulos, o que suponga una subida de más del 10% de precio de venta.
CREATE OR REPLACE TRIGGER FALLAR
BEFORE UPDATE
ON MIS_ARTICULOS
FOR EACH ROW

DECLARE
	MAYOR EXCEPTION;
	DESCRIPOPROVE EXCEPTION;
BEGIN
	IF UPDATIGN('DESCRIPCION') OR UPDATING('PROVEEDOR') THEN
	    RAISE DESCRIPOPROVE;
	END IF;

	IF UPDATING('PR_VENT') AND :NEW.PR_VENT > :NEW.OLD * 1.10 THEN
	    RAISE MAYOR;
	END;

EXCEPTION
	WHEN DESCRIPOPROVE THEN
		DBMS_OUTPUT.PUT_LINE('RECUERDA EL PROVEEDOR Y DESCRIPCION SON INTOCABLES');
	WHEN MAYOR THEN
		DBMS_OUTPUT.PUT_LINE('RECUERDA QUE NO LE PUEDES SUBIR MAS DEL 10% A PRECIO DE VENTA');
END;

-- 15. Crear un trigger de nombre CLI_BARSA que se dispare al intentar borra un cliente y que aborte el borrado si dicho cliente tiene albaranes, sacando en pantalla el mensaje correspondiente.
CREATE OR REPLACE TRIGGER CLI_BARSA
BEFORE DELETE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
	CANTIDAD NUMBER(10);
BEGIN
	SELECT COUNT(*) INTO CANTIDAD
	FROM ALBARANES
	WHERE CLIENTE = :OLD.CLIENTE;

	IF CANTIDAD > 0 THEN
	    RAISE_APPLICATION_ERROR(-20999, 'HAS INTENTADO BORRAR CLIENTE CON ALBARANES');
	END IF;

END;

-- 16. Crear un trigger de nombre CONTROL_ALBA que no permita que un albarán contenga una fecha de pago superior a su fecha de albarán. Sólo para aquellos cuya fecha de envío pertenezca al año en curso.
CREATE OR REPLACE TRIGGER CONTROL_ALBA
BEFORE INSERT OR UDPATE OF FECHA_ALBARAN , FECHA_PAGO
ON ALBARANES
FOR EACH ROW
WHEN (TO_CHAR(NEW.FECHA_ENVIO, 'YYYY')) = TO_CHAR(SYSDATE, 'YYYY')

BEGIN
	
	IF UPDATING('FECHA_PAGO') AND :NEW.FECHA_PAGO < :OLD.FECHA_ALBARAN AND TO_CHAR(:OLD.FECHA_ENVIO, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY') THEN

	END IF;
	IF INSERTING THEN
	    IF :NEW.FECHA_PAGO > :NEW.FECHA_ALBARAN THEN
			RAISE_APPLICATION_ERROR(-20855, 'HAS INTENTADO BORRAR CLIENTE CON ALBARANES');
		END IF;
	ELSE
		IF 
END;

-- 17. Definir un bloque PL/SQL que seleccione las descripciones de las provincias, con el número de clientes que les pertenecen.

-- Vaya guardando la información en una variable tipo tabla PL/SQL.

-- Y una vez guardados en dicha variable, los vaya leyendo y sacando por pantalla.

-- (Realizar el mismo ejercicio con VARRAY’s)
CREATE OR REPLACE TYPE DESCRIPCIONCLIENTES IS TABLE OF 

-- 18. Guardar en dos tablas PL/SQL los códigos de cliente y los códigos de proveedor.

-- Posteriormente comparar su información y sacar por pantalla aquellos códigos que coincidan en ambas tablas PL/SQL.
