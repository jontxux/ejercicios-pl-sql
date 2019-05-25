-- 1.    Crear un procedimiento de nombre PROM_PRECIO que por cada proveedor muestre el promedio del precio al que nos vende sus artículos

--  Proveedor:  FAGOR

-- Promedio Venta:  360€ 

--             Proveedor:  EROSKI

--                         Promedio Venta:  52€

-- …

-- ·         While

-- ·         Loop

CREATE OR REPLACE PROCEDURE PROM_PRECIO
IS
    CURSOR CONSULTA IS
        SELECT EMPRESA, NVL(AVG(PR_VENT), 0)
        FROM PROVEEDORES, ARTICULOS
        WHERE ARTICULOS.PROVEEDOR = PROVEEDORES.PROVEEDOR
        GROUP BY EMPRESA;
    
    EMPRESA PROVEEDORES.EMPRESA%TYPE;
    PROMEDIO NUMBER(12,2);
BEGIN
    OPEN CONSULTA;
    FETCH CONSULTA INTO EMPRESA, PROMEDIO;
    WHILE CONSULTA%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('PROVEEDOR: '|| EMPRESA);
        DBMS_OUTPUT.PUT_LINE('PROMEDIO VENTA: '|| PROMEDIO || '€');

        FETCH CONSULTA INTO EMPRESA, PROMEDIO;
    END LOOP;
    CLOSE CONSULTA;
END PROM_PRECIO;
/

CREATE OR REPLACE PROCEDURE PROM_PRECIO
IS
    CURSOR CONSULTA IS
        SELECT EMPRESA
        FROM PROVEEDORES
        FOR UPDATE;
    
    EMP PROVEEDORES.EMPRESA%TYPE;
    PRO NUMBER(12,2);
BEGIN
    OPEN CONSULTA;
    FECTH CONSULTA INTO EMP;
    WHILE CONSULTA%FOUND THEN
        SELECT NVL(AVG(PR_VENT), 0) INTO PROMEDIO
        FROM ARTICULOS
        WHERE CURRENT OF;

        DBMS_OUTPUT.PUT_LINE('PROVEEDOR: '|| EMPRESA);
        DBMS_OUTPUT.PUT_LINE('PROMEDIO VENTA: '|| PRO || '€');
    END LOOP;
    CLOSE CONSULTA;
END PROM_PRECIO;

CREATE OR REPLACE PROCEDURE PROM_PRECIO
IS
    CURSOR CONSULTA IS
        SELECT EMPRESA, AVG(PR_VENT) PROMEDIO
        FROM PROVEEDORES, ARTICULOS
        WHERE PROVEEDORES.PROVEEDOR = ARTICULOS.PROVEEDOR
        GROUP BY EMPRESA;

    FILA CONSULTA%ROWTYPE;
BEGIN
    OPEN CONSULTA;
    LOOP
        FETCH CONSULTA INTO FILA;
        EXIT WHEN CONSULTA%NOTFOUND
            DBMS_OUTPUT.PUT_LINE('PROVEEDOR: ' || FILA.EMPRESA);
            DBMS_OUTPUT.PUT_LINE('PROMEDIO VENTA: ' || FILA.PROMEDIO || '€');
    END LOOP;
    CLOSE CONSULTA;
END PROM_PRECIO;



BEGIN
    PROM_PRECIO;
END;
/

-- 2.    Crear un procedimiento de nombre PROVCLI que devuelva las provincias (por pantalla) con más de un número de  clientes dado como parámetro.

-- Lista de las provincias con más de X clientes (Por ejemplo: 4)

-- Provincia: BARCELONA

-- Nº de Clientes: 43

--           Provincia: GIPUZKOA

-- Nº de Clientes: 5

--             …

-- a.    For …loop

-- b.    While

CREATE OR REPLACE PROCEDURE PROVCLI(CANTIDAD IN NUMBER)
IS
    CURSOR CONSULTA IS
        SELECT DESCRIPCION, COUNT(*) CUANTOS
        FROM PROVINCIAS, CLIENTES
        WHERE PROVINCIAS.PROVINCIA = CLIENTE.PROVINCIA
        GROUP BY DESCRIPCION
        HAVING COUNT(*) >= CANTIDAD;
BEGIN
    FOR FILA IN CONSULTA LOOP
        DBMS_OUTPUT.PUT_LINE('PROVINCIA: '|| FILA.DESCRIPCION);
        DBMS_OUTPUT.PUT_LINE('Nº DE CLIENTES: '|| FILA.CUANTOS);
    END LOOP;
END PROVCLI;
/


CREATE OR REPLACE PROCEDURE PROVCLI(CANTIDAD IN NUMBER)
IS 
    CURSOR CONSULTA IS
        SELECT PROVINCIA, DESCRIPCION
        FROM PROVINCIAS
    CUANTOS NUMBER(15);
BEGIN
    FOR FILA IN CONSULTA LOOP
        SELECT COUNT(*) INTO CUANTOS
        FROM CLIENTES
        WHERE PROVINCIA = FILA.PROVINCIA;

        DBMS_OUTPUT.PUT_LINE('PROVINCIA: ' || FILA.DESCRIPCION);
        DBMS_OUTPUT.PUT_LINE('Nº DE CLIENTES: ' || CUANTOS);
    END LOOP;
END PROVCLI;
/


CREATE OR REPLACE PROCEDURE PROVCLI(CANTIDAD IN NUMBER)
IS 
    CURSOR CONSULTA IS
        SELECT DESCRIPCION, COUNT(*) CUANTOS
        FROM PROVINCIAS, CLIENTES
        WHERE PROVINCIAS.PROVINCIA = CLIENTES.PROVINCIA
        GROUP BY DESCRIPCION
        HAVING COUNT(*) >= CANTIDAD;
    
    FILA CONSULTA%ROWTYPE;
BEGIN
    OPEN CONSULTA;
    FETCH CONSULTA INTO FILA;
    WHILE CONSULTA%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('PROVINCIA: ' || FILA.DESCRIPCION);
        DBMS_OUTPUT.PUT_LINE('Nº DE CLIENTES: ' || FILA.CUANTOS);
    END LOOP;
END PROVCLI;
/


BEGIN
    PROVCLI(&CANTIDAD);
END;
/


-- 3.    Crear una tabla MASCLI con la provincia y el número de clientes. Modificar el ejercicio anterior y crear un procedimiento PROVCL2,
-- que además de sacar por pantalla la información anterior, inserte en la tabla MASCLI cada provincia y su número de
-- clientes que cumplen la condición (parámetro de entrada).

CREATE TABLE MASCLI(
    PROVINCIA NUMBER(3);
    CLIENTE NUMBER(9);
    CONSTRAINT PROVINCIA_PK PRIMARY KEY(PROVINCIA)
);

CREATE OR REPLACE PROCEDURE PROVCL2(CANTIDAD IN NUMBER)
IS
    CURSOR CONSULTA IS
        SELECT PROVINCIA, COUNT(*)
        FROM PROVINCIAS, CLIENTES
        WHERE PROVINCIAS.PROVINCIA = CLIENTES.PROVINCIA
        GROUP BY PROVINCIA
        HAVING COUNT(*) >= CANTIDAD;

BEGIN
    FOR FILA IN CONSULTA LOOP
        DBMS_OUTPUT.PUT_LINE('PROVINCIA: ' || FILA.PROVINCIA);
        DBMS_OUTPUT.PUT_LINE('Nº DE CLIENTES: ' || FILA.CUANTOS);
        
        DECLARE
            EXISTE MASCLI.PROVINCIA%TYPE
        BEGIN
            SELECT PROVINCIA INTO EXISTE
            FROM MASCLI
            WHERE PROVINCIA = FILA.PROVINCIA;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                INSERT INTO MASCLI
                VALUES(FILA.PROVINCIA, FILA.CUANTOS);
        END;
    END LOOP;
END PROVCL2;


CREATE OR REPLACE PROCEDURE PROVCL2(CANTIDAD IN NUMBER)
IS
    CURSOR CONSULTA IS
        SELECT PROVINCIA, DESCRIPCION
        FROM PROVINCIAS
    CUANTOS NUMBER(15);
BEGIN
    FOR FILA IN CONSULTA LOOP
        SELECT COUNT(*) INTO CUANTOS
        FROM CLIENTES
        WHERE PROVINCIA = FILA.PROVINCIA;

        IF CUANTOS > CANTIDAD THEN
            DECLARE
                PRO MASCLI.PROVINCIA%TYPE;
            BEGIN
                SELECT PROVINCIA INTO PRO
                FROM MASCLI
                WHERE PROVINCIA = FILA.PROVINCIA
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    INSERT INTO MASCLI
                    VALUES(FILA.PROVINCIA, CUANTOS);
            END;

            DBMS_OUTPUT.PUT_LINE('PROVINCIA: ' || FILA.PROVINCIA);
            DBMS_OUTPUT.PUT_LINE('Nº DE CLIENTES: ' || CUANTOS);
        END IF;
    END LOOP;
END PROVCL2;
/


BEGIN
    PROVCL2(&CANTIDAD);
END;
/

-- 4.     

-- a.     Crear una tabla de nombre AUDITAR_CLIENTES, que contenga cuatro campos (Codigo, empresa, total_facturado, fecha_ultimo_albaran), con sus tipos de datos adecuados y la clave primaria que precise.
CREATE TABLE AUDITAR_CLIENTES(
    CODIGO NUMBER(10) NOT NULL,
    EMPRESA VARCHAR2(30),
    TOTAL_FACTURADO NUMBER(15,2),
    FECHA_ULTIMO_ALBARAN DATE,
    CONSTRAINT CODIGO_PK PRIMARY KEY(CODIGO)
);
   

-- b.    Dada de alta la tabla de auditación. Crear un procedimiento almacenado de nombre AUDITAR_CLIENTES_PROC,
-- tal que para cada uno de los clientes existentes en nuestra base de datos (tabla CLIENTES) realice lo siguiente:

 

 

-- ü Lo dé de alta en nuestra tabla AUDITAR_CLIENTES si no aparece en dicha tabla. Adjuntar todos los datos requeridos.

 

 

-- ü Si el cliente ya está dado de alta. Comprobar si su total facturado coincide con el almacenado. Si es así no hacer nada.
-- En otro caso actualizarlo con el valor correspondiente, así como con la fecha de su último albarán en el campo correspondiente.

 

 

-- ü Dar de baja de la tabla AUDITAR_CLIENTES aquellos clientes que ya no aparezcan en la tabla CLIENTES. ( Cuando los campos código y empresa no coincidan)

 

 

-- ü Este procedimiento debe devolver el número de clientes dados de alta, actualizados y borrados, en sendos parámetros de salida creados para tal efecto.

  

-- q Cursor FOR..LOOP 

CREATE OR REPLACE PROCEDURE AUDITAR_CLIENTES_PROC(ALTA OUT NUMBER, ACTUALIZADOS OUT NUMBER, BORRADOS OUT NUMBER)
IS
    CURSOR CONSULTA IS
        SELECT CLIENTE, EMPRESA, NVL(SUM(CANTIDAD * PRECIO * (1 - DESCUENTO / 100)), 0) TOTAL, MAX(FECHA_ALBARAN) FECHA
        FROM CLIENTES, ALBARANES, LINEAS
        WHERE CLIENTES.CLIENTE = ALBARANES.CLIENTE
        AND ALBARANES.ALBARAN = LINEAS.ALBARAN
        GROUP BY CLIENTE, EMPRESA;
BEGIN
    ALTA := 0
    ACTUALIZADOS := 0
    FOR FILA IN CONSULTA LOOP
        DECLARE
            CLI AUDITAR_CLIENTES.CLIENTE%TYPE;
            TOT AUDITAR_CLIENTES.TOTAL_FACTURA%TYPE
            FEC DATE;
        BEGIN
            SELECT CLIENTE, TOTAL_FACTURA, FECHA_ULTIMO_ALBARAN INTO CLI, TOT, FEC
            FROM AUDITAR_CLIENTES
            WHERE CODIGO = FILA.CLIENTE;

            IF TOT != FILA.TOTAL AND FEC != FILA.FECHA THEN
                UPDATE AUDITAR_CLIENTES
                SET TOTAL_FACTURADO = FILA.TOTAL, FECHA_ULTIMO_ALBARAN = FILA.FECHA
                WHERE FILA.CLIENTE = CODIGO;
                ACTUALIZADOS := ACTUALIZADOS + 1;
            ELSIF TOT != FILA.TOTAL THEN
                UPDATE AUDITAR_CLIENTES
                SET TOTAL_FACTURADO = FILA.TOTAL
                WHERE FILA.CLIENTE = CODIGO;
                ACTUALIZADOS := ACTUALIZADOS + 1;                
            ELSIF FEC != FILA.FECHA THEN
                UPDATE AUDITAR_CLIENTES
                SET FECHA_ULTIMO_ALBARAN = FILA.FECHA
                WHERE FILA.CLIENTE = CODIGO;
                ACTUALIZADOS := ACTUALIZADOS + 1;                
            END IF;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                INSERT INTO AUDITAR_CLIENTES
                VALUES(FILA.CLIENTE, FILA.EMPRESA, FILA.TOTAL, FILA.FECHA);
        END;
    END LOOP;
    
    DELETE FROM AUDITAR_CLIENTES
    WHERE NOT EXISTS(SELECT *
                    FROM CLIENTES
                    WHERE CLIENTE = CODIGO
                    AND AUDITAR_CLIENTES.EMPRESA = CLIENTES.EMPRESA);
    BORRADOS := SQL%ROWCOUNT;
    
END AUDITAR_CLIENTES_PROC;

-- 5.     

-- a.     Crear la tabla AUDITAR_PROVINCIAS, que guarde el código de provincia, número de clientes, número de proveedores, número de albaranes y total facturado por provincia. 
CREATE TABLE AUDITAR_PROVINCIAS(
    PROVINCIA NUMBER(3),
    CLIENTE NUMBER(6),
    PROVEEDOR NUMBER(6),
    ALBARAN NUMBER(6),
    TOTAL_FACTURADO,
    CONSTRAINT PROVINCIA_PK PRIMARY KEY(PROVINCIA)
);
  

-- b.    Crear un procedimiento almacenado de nombre AUDITAR_PROVINCIAS_PROC, que para cada una de la provincias existentes en la base de datos ( Tabla PROVINCIAS ) realice lo siguiente:

-- Ø Darla de alta sino existe en la tabla AUDITAR_PROVINCIAS.

-- Función EXISTE_PROVINCIA. (devuelva True o False en cada caso)                
-- Ø Actualizar los demás campos con el valor correspondiente si ya existe.

 

-- Ø Crear una función para cada cálculo:

-- o Función NUMERO_CLIENTES.

-- o Función NUMERO_PROVEEDORES.

-- o Función NÚMERO_ALBARANES.

-- o Función TOTAL_FACT_PROVINCIA.

 

--             q WHILE

CREATE OR REPLACE PROCEDURE AUDITAR_CLIENTES_PROC
IS
    CURSOR CONSULTA IS
        SELECT PROVINCIA
        FROM PROVINCIAS;

    PRO PROVINCIAS.PROVINCIA%TYPE;
BEGIN
    OPEN CONSULTA;
    FETCH CONSULTA INTO PRO
    WHILE CONSULTA%FOUND THEN
        IF NOT EXISTE_PROVINCIA(PRO) THEN
            INSERT INTO AUDITAR_PROVINCIAS
            VALUES(PRO, NUMERO_CLIENTES(PRO), NUMERO_PROVEEDORES(PRO), NUMERO_ALBARANES(PRO), TOTAL_FACT_PROVINCIA(PRO));
        ELSE
            UPDATE AUDITAR_PROVINCIAS
            SET CLIENTE = NUMERO_CLIENTES(PRO), PROVEEDOR = NUMERO_PROVEEDORES(PRO), ALBARAN = NUMERO_ALBARANES(PRO), TOTAL_FACTURADO = TOTAL_FACT_PROVINCIA(PRO)
            WHERE PROVINCIA = PRO;
        END IF;
        FETCH CONSULTA INTO PRO;
    END LOOP;
END AUDITAR_CLIENTES_PROC;        




CREATE OR REPLACE FUNCTION EXISTE_PROVINCIA(PRO IN AUDITAR_PROVINCIAS.PROVINCIA%TYPE)
RETURN BOOLEAN
IS
    PROV AUDITAR_PROVINCIAS.PROVINCIA%TYPE;
BEGIN
    SELECT PROVINCIA INTO PROV
    FROM AUDITAR_PROVINCIAS
    WHERE PROVINCIA = PRO;

    RETURN TRUE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END EXISTE_PROVINCIA;
/

CREATE OR REPLACE FUNCTION NUMERO_CLIENTES(PRO IN AUDITAR_PROVINCIAS.PROVINCIA%TYPE)
RETURN NUMBER
IS
    CANTIDAD NUMBER(10);
BEGIN
    SELECT COUNT(*) INTO CANTIDAD
    FROM CLIENTES
    WHERE CLIENTES.PROVINCIA = PRO;

    RETURN CANTIDAD;
END NUMERO_CLIENTES;
/

CREATE OR REPLACE FUNCTION NUMERO_PROVEEDORES(PRO IN AUDITAR_PROVINCIAS.PROVINCIA%TYPE)
RETURN NUMBER
IS
    CANTIDAD NUMBER(10);
BEGIN
    SELECT COUNT(*) INTO CANTIDAD
    FROM PROVEEDORES
    WHERE PROVEEDORES.PROVINCIA = PRO;

    RETURN CANTIDAD
END NUMERO_CLIENTES;
/

CREATE OR REPLACE FUNCTION NUMERO_ALBARANES(PRO IN AUDITAR_PROVINCIAS.PROVINCIA%TYPE
RETURN NUMBER
IS
    CANTIDAD NUMBER(10;
BEGIN
    SELECT COUNT(*) INTO CANTIDAD
    FROM CLIENTES, ALBARANES
    WHERE CLIENTES.CLIENTE = ALBARANES.CLIENTE
    AND PROVINCIA = PRO;

    RETURN CANTIDAD;
END NUMERO_ALBARANES;
/

CREATE OR REPLACE FUNCTION TOTAL_FACT_PROVINCIA(PRO IN AUDITAR_PROVINCIAS.PROVINCIA%TYPE)
RETURN NUMBER
IS
    TOTAL NUMBER(16,2);
BEGIN
    SELECT SUM(CANTIDAD * PRECIO * (1 - DESCUENTO / 100)) INTO TOTAL
    FROM CLIENTES, ALBARANES, LINEAS
    WHERE CLIENTES.CLIENTE = ALBARANES.CLIENTE
    AND ALBARANES.ALBARAN = LINEAS.ALBARAN
    AND CLIENTE.PROVINCIA = PRO;

    RETURN TOTAL;
END TOTAL_FACT_PROVINCIA;
/


-- 6. Definir un trigger de base de datos de nombre ALTA_PROV que controle las operaciones de inserción en la tabla Proveedores.

 

-- Este trigger debe dispararse para todo registro que quiera ser insertado en la tabla y cumpla que el código de provincia a insertar es no nulo.

 

-- En el caso en que dicho código de provincia no coincida con alguno de los existentes en la tabla provincias, insertar la nueva provincia en la tabla provincias, con descripcion 'SIN NOMBRE' y prefijo 0.

CREATE OR REPLACE TRIGGER ALTA_PROV
BEFORE INSERT
ON PROVEEDORES
WHEN(NEW.PROVINCIA IS NOT NULL)

BEGIN
    INSERT INTO PROVINCIAS
    VALUES(:NEW.PROVINCIA, 'SIN NOMBRE', 0);
END ALTA_PROV;
/


-- 7. Modificar el trigger anterior para que además audite dicha operación en una tabla de nombre AUDITAR que contiene una columna de nombre línea y que debe guardar la información siguiente:

-- ·         Fecha y hora.

-- ·         Número proveedor nuevo.

-- ·         Provincia nueva.

CREATE OR REPLACE TRIGGER ALTA_PROV2
BEFORE INSERT
ON PROVEEDORES
WHEN(NEW.PROVINCIA IS NOT NULL)

