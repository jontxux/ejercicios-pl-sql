declare
    mi_resul number(13,2);
    x1 number(8,2) := &num1;
    y1 number(8,2) := &num2;

    function suma2(x in number, y in number)
    return number
    is
        resultado number(13,2);
    begin
        resultado := x + y;
        return nvl(resultado, 0);
    exception
        when others then
            return -1;
    end suma2;
begin
    mi_resul := suma2(x1, x2);
    if resul is not null then
        dbms_output.put_line('La suma es ' || TO_CHAR(resul));
    else
        dbms_output.put_line('no podemos sumarlo');
    end if;
end;
/
