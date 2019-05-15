CREATE OR REPLACE PROCEDURE PROVCLI(NUM IN NUMBER)
IS
	CURSOR CONSULTA IS
		SELECT PROVINCIA, DESCRIPCION
		FROM PROVINCIAS;
CANTIDAD NUMBER(5);
FILA CONSULTA%ROWTYPE;
BEGIN
	OPEN CONSULTA;
	FETCH CONSULTA INTO FILA;
	WHILE SQL%FOUND THEN
		SELECT COUNT(*) INTO CANTIDAD
		FROM CLIENTES
		WHERE PROVINCIA = FILA.PROVINCIA;

		IF CANTIDAD >= FILA.PROVINCIA THEN
		    DBMS_OUTPUT.PUT_LINE('PROVINCIA: '|| FILA.DESCRIPCION);
			DBMS_OUTPUT.PUT_LINE('Nº DE CLIENTES: '|| CANTIDAD);
		END IF;
		FETCH CONSULTA INTO FILA;
	END LOOP;
	CLOSE CONSULTA;
END PROVCLI;
/
