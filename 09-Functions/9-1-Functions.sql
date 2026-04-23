CREATE OR REPLACE FUNCTION greet_employe(employee_name VARCHAR)
    RETURNS VARCHAR
AS
$$
BEGIN
    RETURN 'Hola ' || employee_name;
end;
$$
    LANGUAGE plpgsql;

-- Ejercicio 2 max_raise
CREATE OR REPLACE FUNCTION max_raise(empl_id INT)
    RETURNS NUMERIC(8, 2)
AS
$$
DECLARE
    total_increase NUMERIC(8, 2);
BEGIN
    SELECT j.max_salary - salary
    into total_increase
    FROM employees
             INNER JOIN public.jobs j on j.job_id = employees.job_id
    WHERE employees.employee_id = empl_id;

    RETURN total_increase;
end;
$$
    LANGUAGE plpgsql;
