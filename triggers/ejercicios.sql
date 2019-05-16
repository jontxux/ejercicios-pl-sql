
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
CREATE OR REPLACE TRIGGER AUDITAR2
AFTER UPDATE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
	FECHA VARCHAR2(30);
	MENSAJE VARCHAR2(200);
	MODIFICADO VARCHAR2(20) := 'MODIFICACION';
BEGIN
	IF UPDATING THEN
	    MENSAJE := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:SS:MIN CLIENTE '||:NEW.CLIENTE||' ==> '||:OLD.CLIENTE||' EMPRESA '||:NEW.EMPRESA||' ==> '||:OLD.EMPRESA);
	END IF;

	INSERT INTO AUDITAR_CLI
	VALUES(MENSAJE, MODIFICADO);

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);
END;
