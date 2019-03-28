declare
    cli number(5);
    pro number(5);
begin
    select count(*) into cli
    from clientes;

    select count(*) into pro
    from proveedores;
    
    if cli > pro then
        dbms_output.put_line('tengo ' || to_char(cli - pro) || ' proveedores mas que clientes');
    elsif cli < pro then
        dbms_output.put_line('tengo ' || to_char(pro -cli) || ' clientes mas que proveedores');
    else
        dbms_output.put_line('tengo igual numero de clientes y proveedores');
    end if;
end;
/
