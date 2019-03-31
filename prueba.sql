/* 12. Escribir un procedimiento de nombre DOS_PROVI que dados dos códigos de provincia devuelva lo facturado por cada una de ellas y
su diferencia. En el caso en que no hayan facturado o no existan las provincias obtengamos el mensaje correspondiente. */

CREATE OR REPLACE PROCEDURE DOS_PROVI(PRO1 IN NUMBER, PRO2 IN NUMBER, DIF OUT NUMBER, FAC1 OUT NUMBER, FAC2 OUT NUMBER)
IS
BEGIN
    -- un number puedo contener nulos?
    -- SELECT SUM(TOTAL_FACTURA) FROM CLIENTES WHERE PROVINCIA = 105;
    SELECT SUM(TOTAL_FACTURADO) INTO FAC1
    FROM CLIENTES
    WHERE PROVINCIA = PRO1;

    SELECT SUM(TOTAL_FACTURADO) INTO FAC2
    FROM CLIENTES
    WHERE PROVINCIA = PRO2;

    DIF := ABS(FAC1 - FAC2)
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE("LA PROVINCIA NO EXISTE");
END DOS_PROVI;