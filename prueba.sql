declare
    palabra varchar2(10) := 'oracle';
    invertida varchar2(10);
begin
    for i in length(palabra)..i loop
        invertida := invertida || substr(palabra, i, 1);
    end loop;
    DBMS_OUTPUT.PUT_LINE(invertida);
end;
/
