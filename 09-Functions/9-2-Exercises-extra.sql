/*
 Ejercicio 1:

Tablas: employees, dependents

Requerimiento del negocio:
Recursos Humanos quiere calcular el bono navideño de los empleados, el cual depende de cuántos dependientes (hijos/familiares) tengan registrados.

Crea una función llamada calcular_bono(empl_id INT) que retorne un valor numérico (NUMERIC).

Reglas:

1. Si el empleado tiene 0 dependientes, el bono es el 5% de su salario actual.

2. Si tiene entre 1 y 2 dependientes, el bono es el 10% de su salario.

3. Si tiene 3 o más dependientes, el bono es el 15% de su salario.
 */

CREATE OR REPLACE FUNCTION calcular_bono(empld_id INT)
    RETURNS NUMERIC
AS
$$
DECLARE
    empld_salario  NUMERIC(8, 2);
    count_depend   INT;
BEGIN
    -- Obtener salario del empleado
    SELECT salary into empld_salario
    FROM employees
    WHERE employee_id = empld_id;

    -- Obtener cantidad de dependientes
    SELECT count(*) as contador into count_depend
    FROM dependents
    WHERE employee_id = empld_id;

    -- Calcular bono
    IF (count_depend = 0) THEN
        RETURN empld_salario * 0.05;
    ELSIF (count_depend BETWEEN 1 AND 2) THEN
        RETURN empld_salario * 0.10;
    ELSIF (count_depend >= 3) THEN
        RETURN empld_salario *0.15;
    end if;
end;
$$
    LANGUAGE plpgsql;

SELECT first_name,
       salary,
       calcular_bono(employee_id)
FROM employees;


