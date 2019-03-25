declare
    cont number(4) := 1;
    numero number(2) :=75;
    par boolean := True;
begin
    while cont < 11 loop
        if mod(cont, 2)=0 then
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(numero)||' DE '||numero||' ES '||TO_CHAR(numero * cont)||' Y ES PAR');
        else
        DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO '||TO_CHAR(numero)||' DE '||numero||' ES '||TO_CHAR(numero * cont)||' Y ES IMPAR');
        end if;
        cont := cont + 1;
    end loop;
end;
/
