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
