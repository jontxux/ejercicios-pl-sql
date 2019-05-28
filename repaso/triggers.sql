-- 12. Definir un disparador o trigger de base de datos de nombre AUDITAR1 que permita auditar las operaciones de inserción o borrado de datos que se realicen en la tabla Mis_clientes según las siguientes especificaciones:

-- ü En primer lugar, crear desde SQL*Plus la tabla Auditar_cli con la columna de nombre texto de tipo alfanumérico de 200 bytes de longitud, y una columna de nombre operacion de tipo alfanumérico de 20 de longitud que tome uno de éstos tres valores: inserción, borrado o modificación (constraint ck1_tipo).

-- ü Cuando se produzca cualquier manipulación, se insertará una fila en dicha tabla que contendrá:

-- § Fecha y hora.

-- § Número de cliente.

-- § Nombre de empresa.



-- § La operación realizada, INSERCIÓN ó BORRADO.
CREATE TABLE AUDITAR_CLI(
    TEXTO VARCHAR2(200),
    OPERACION VARCHAR2(20),
    CONSTRAINT CK1_TIPO CHECK (OPERACION IN ('INSERCION', 'BORRADO', 'MODIFICACION'))
);

CREATE OR REPLACE TRIGGER AUDITAR1
AFTER INSERT OR DELETE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
    TEXTO VARCHAR2(200);
    OPCION VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        TEXTO := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')||' HA SIDO INSERTADO EL CLIENTE '||:NEW.CLIENTE||' CON NOMBRE DE EMPRESA '|| :NEW.EMPRESA;
        OPCION := 'INSERCION';    
    ELSE
        TEXTO := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')||' HA SIDO ELIMINADO EL CLIENTE '||:OLD.CLIENTE||' CON NOMBRE DE EMPRESA '|| :OLD.EMPRESA;
        OPCION := 'BORRADO'
    
    INSERT INTO AUDITAR_CLI
    VALUES(TEXTO, OPCION);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
END;

-- 13. Definir un trigger de base de datos de nombre AUDITAR2 que permita auditar las operaciones de modificación en la tabla Mis_clientes e inserte en la tabla Auditar_cli las siguientes especificaciones:

-- § Fecha y hora.

-- § Número de cliente.N

-- § Nombre de empresa.

-- § La operación realizada, MODIFICACIÓN.



-- § El valor anterior y el valor nuevo de cada columna modificada.
CREATE OR REPLACE TRIGGER AUDITAR2
AFTER UPDATE
ON MIS_CLIENTES
FOR EACH ROW


DECLARE
    FECHA VARCHAR2(20);
    CLI VARCHAR2(100);
    EMP VARCHAR2(100);
    OPER VARCHAR2(20);
    TEXTO VARCHAR2(200);
BEGIN
    FECHA := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS');
    OPER := 'MODIFICACION';
    IF UPDATING('CLIENTE') THEN
        CLI := TO_CHAR(:OLD.CLIENTE)||' --> '||TO_CHAR(:NEW.CLIENTE);
    END IF;

    IF UPDATING('EMPRESA') THEN
        EMP := TO_CHAR(:OLD.CLIENTE||' --> '||TO_CHAR(:NEW.CLIENTE);
    END IF;

    TEXTO := FECHA||' '||CLI||' '||EMP||;

    INSERT INTO AUDITAR_CLI
    VALUES(TEXTO, OPER);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE, SQLERRM);
END;
/

-- 14. Definir un disparador de base de datos que haga fallar cualquier operación de modificación de la descripción o del código de proveedor de los artículos de la tabla Mis_articulos, o que suponga una subida de más del 10% de precio de venta.
CREATE OR REPLACE TRIGGER AUDITAR3
BEFORE UPDATE
ON MIS_ARTICULOS
FOR EACH ROW

BEGIN
    IF UPDATING('DESCRIPCION') THEN
        RAISE_APPLICATION_ERROR(-20100,'NO SE PUEDE ACTUALIZAR');
    END IF;

    IF UPDATING('PR_VENT') AND :OLD.PR_VENT * 1.1 < :NEW.PR_VENT  THEN
        RAISE_APPLICATION_ERROR(-20101,'ESTAS AUMENTANDO DEMASIADO EL PRECIO DE VENTA');
    END IF;

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);
END;

-- 15. Crear un trigger de nombre CLI_BARSA que se dispare al intentar borrar un cliente y que aborte el borrado si dicho cliente tiene albaranes, sacando en pantalla el mensaje correspondiente.
CREATE OR REPLACE TRIGGER CLI_BARCA
BEFORE UPDATE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
	ALB ALBARANES.ALBARAN%TYPE;
BEGIN
	SELECT ALBARAN INTO ALB
	FROM ALBARANES
	WHERE CLIENTE = :OLD.CLIENTE;

	RAISE_APPLICATION_ERROR(-20105, 'EL CLIENTE TIENE ALBARANES');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('EL CLIENTE NO TIENE ALBARANES');
END;
/

CREATE OR REPLACE TRIGGER CLI_BARCA
BEFORE UPDATE
ON MIS_CLIENTES
FOR EACH ROW

DECLARE
	ALB NUMBER(1);
BEGIN
	SELECT COUNT(*) INTO ALB
	FROM ALBARANES
	WHERE CLIENTE = :OLD.CLIENTE;

	IF ALB > 0 THEN
		RAISE_APPLICATION_ERROR(-20105, 'EL CLIENTE TIENE ALBARANES');
	END IF;
END;
/

-- 16. Crear un trigger de nombre CONTROL_ALBA que no permita que un albarán contenga una fecha de pago superior a su fecha de albarán. Sólo para aquellos cuya fecha de envío pertenezca al año en curso.
CREATE OR REPLACE TRIGGER CONTROL_ALBA
BEFORE INSERT OR UPDATE OF FECHA_ALBARAN, FECHA_PAGO
ON MIS_ALBARANES
FOR EACH ROW
WHEN(TO_CHAR(:NEW.FECHA_PAGO, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY'))

BEGIN
	IF INSERTING THEN
		IF :NEW.FECHA_PAGO > :NEW.FECHA_ALBARAN THEN
			RAISE_APPLICATION_ERROR(-20155, 'LA FECHA DE PAGO ES MAYOR QUE LA FECHA DE ALBARAN');
		END IF;
	ELSE
		IF :NEW.FECHA_ALBARAN < :NEW.FECHA_PAGO THEN
			RAISE_APPLICATION_ERROR(-20197, 'LA FECHA DE PAGO ES MAYOR QUE LA FECHA DE ALBARAN');
		END IF;
	END IF;
END;
		
