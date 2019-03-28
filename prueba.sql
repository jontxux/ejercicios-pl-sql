/* 7. Crear un procedimiento almacenado de nombre ACTU_TOTAL que dado un código de cliente actualice el campo Total_factura de la tabla Mis_clientes con el importe de las compras que ha realizado. */
CREATE OR REPLACE PROCEDURE ACTU_TOTAL(COD IN CLIENTES.CLIENTE%TYPE, TOT OUT MIS_CLIENTES.TOTAL_FACTURADO%TYPE)
IS
	
BEGIN
    
