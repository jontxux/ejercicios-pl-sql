/* 1. Crear un bloque PL/SQL anónimo que muestre por pantalla los 10 primeros múltiplos de un número dado e indique si es par o impar, de la forma: */



/*                         EL MULTIPLO NUMERO 2 DE 75 ES 150 Y ES PAR */

/* EL MULTIPLO NUMERO 3 DE 75 ES 225 Y ES IMPAR */

/*  . . . . */

/* Hacerlo con las diferentes cláusulas iterativas existentes: */

/* v WHILE */
declare
    cont number(4) := 1;
    numero number(2) :=75;
begin
    while cont < 11 loop
        if mod(cont, 2)=0 then
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(cont)||' DE '||numero||' ES '||TO_CHAR(numero * cont)||' Y ES PAR');
        else
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(cont)||' DE '||numero||' ES '||TO_CHAR(numero * cont)||' Y ES IMPAR');
        end if;
        cont := cont + 1;
    end loop;
end;
/

/* v LOOP */
declare
    cont number(4) := 1;
    numero number(2) := 75;
begin
    loop
        if mod(cont, 2)=0 then
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(cont)||' DE '||numero||' ES '||TO_CHAR(numero * cont)||' Y ES PAR');
        else
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(cont)||' DE '||numero||' ES '||TO_CHAR(numero * cont)||' Y ES IMPAR');
        end if;
        cont := cont + 1;
    exit when cont > 10;
    /* DBMS_OUTPUT.PUT_LINE('PROGRAMA FINALIZADO'); -- preguntar porque esto se ejecuta */
    end loop;
    DBMS_OUTPUT.PUT_LINE('PROGRAMA FINALIZADO');
end;
/

declare
    cont number(4) := 1;
    numero number(2) := 75;
    par varchar2(5);
begin
    loop
        if mod(cont, 2)=0 then
            par := 'PAR'
        else
            par := 'IMPAR'
        end if;
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO ' || TO_CHAR(cont) || ' DE ' || numero || ' ES ' || TO_CHAR(numero * cont) || ' Y ES ' || par);
        cont := cont + 1;
    exit when cont > 10;
    end loop;
    DBMS_OUTPUT.PUT_LINE('PROGRAMA FINALIZADO');
end;
/

/* v FOR */
declare
    numero number(2) :=75;
begin
    for i in 1..10 loop
        if mod(i, 2)=0 then
            DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(i)||' DE '||numero||' ES '||TO_CHAR(numero * i)||' Y ES PAR');
        else
            DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(i)||' DE '||numero||' ES '||TO_CHAR(numero * i)||' Y ES IMPAR');
        end if;
    end loop;
end;
/

/* 2. Construir un bloque PL/SQL que escriba en pantalla la cadena ‘ORACLE’ al revés. */

/* Utilizando bucles: */

/* v WHILE */
declare
    palabra varchar2(10) := 'oracle';
    invertida varchar2(10);
    contador number(2) := length('oracle');
begin
    while contador > 0 loop
        invertida := invertida || substr(palabra, contador, 1);
        contador := contador - 1;
    end loop;
    DBMS_OUTPUT.PUT_LINE('oracle al reves es ' || invertida);
end;
/

/* v FOR */
declare
    palabra varchar2(10) := 'oracle';
    invertida varchar2(10);
begin
    for i in reverse 1..length(palabra) loop
        invertida := invertida || substr(palabra, i, 1);
    end loop;
    DBMS_OUTPUT.PUT_LINE(invertida);
end;
/

/* 3. Utilizando variables de sustitución: (solo para bloques anónimos) */

/* a) Crear un bloque PL/SQL que muestre el precio de venta de un articulo determinado. */

/* b) Otro que devuelva el precio de venta y el de compra de un artículo. */

/* c) Conéctate con tu usuario y crea un bloque PL/SQL que permita dar de alta una provincia con todos sus datos en la tabla provincias. */


/* 4. Escribe un bloque PL/SQL que cuente el número de líneas de las tablas de clientes y proveedores. */

/* Y según lo devuelto muestre por pantalla: */

/* TENGO X PROVEEDORES MÄS QUE CLIENTES */

/* TENGO X CLIENTES MÄS QUE PROVEEDORES */

/* TENGO IGUAL NÜMERO DE CLIENTES Y PROVEEDORES */


/* 5. Crear un procedimiento almacenado de nombre VER_CLIENTE para consultar los datos relevantes de un cliente (empresa, dirección, población). */

/* Una vez creado y almacenado: */

/* a) Realizar una llamada al procedimiento directamente desde SQL*Plus. */

/* b) Realizar la llamada desde un bloque PL/SQL anónimo. */

/* c) Insertar la excepción NO_DATA_FOUND para poder tratar el caso en que no exista tal código de cliente. */


/* 6. Crear desde vuestro usuario una tabla de nombre Mis_clientes a imagen de la tabla Clientes del usuario almacén. */


/* 7. Crear un procedimiento almacenado de nombre ACTU_TOTAL que dado un código de cliente actualice el campo Total_factura de la tabla Mis_clientes con el importe de las compras que ha realizado. */

/* a) Comprobando primero que el cliente existe, sino ésta en la tabla Mis_clientes saque un mensaje.(EXCEPTION NO_DATA_FOUND) */

/* EL CLIENTE X NO EXISTE */

/* b) En el caso en que exista, pero no tiene compras, sacar un mensaje. */

/* EL CLIENTE X NO TIENE COMPRAS */

/* c) En otro caso, actualizarlo y sacar un mensaje diciendo: */

/* EL CLIENTE X HA SIDO ACTUALIZADO CON XXXXX EUROS */





/* 8. Crear un procedimiento almacenado de nombre NUEVA_PROV que dados un código, descripción y prefijo, inserte con ellos una provincia nueva. */

/* (Tratar la excepción DUP_VAL_ON_INDEX) */



/* 9. Desarrollar una función de nombre DIF_FECHAS que devuelva el número de años completos que hay entre dos fechas que se pasan como parámetro. */ 

/*  10. Implementar un procedimiento de nombre CAMBIO_DIVISA que reciba un importe y visualice el desglose del cambio en unidades monetarias de 1,2,5,10,20,50 ctms de € y 1, 2, 5,10,20,50,100 € en orden inverso al que aquí aparecen enumeradas. */



/* 11. Crear un procedimiento de nombre BORRAR_CLIENTE que permita borrar de la tabla Mis_clientes un cliente, cuyo número se pasará en la llamada. */

/* (Tratar excepción NO_DATA_FOUND) */



/* 12. Escribir un procedimiento de nombre DOS_PROVI que dados dos códigos de provincia devuelva lo facturado por cada una de ellas y su diferencia. En el caso en que no hayan facturado o no existan las provincias obtengamos el mensaje correspondiente. */

/* Realizar la llamada a una función de nombre UN_PROVI que calcule lo facturado para una provincia. */



/* 13. Crear una función de nombre CALCULA_FACT que dada una fecha devuelva el total facturado hasta la misma entre los albaranes (según fecha de albarán). */



/* 14. Crear una función de nombre CUANTAS_EXIS que devuelva el total de existencias existentes en nuestro almacén. */



/* 15. Modificar la función anterior para que calcule el total de existencias pero para los artículos de un tipo de unidad de medida específico, que se pasará como parámetro. */
