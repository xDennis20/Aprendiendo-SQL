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

-- alternativa de la funcion max_raise con condicionales y excepcion

CREATE OR REPLACE FUNCTION max_raise_2(empl_id INT)
    RETURNS NUMERIC(8, 2)
AS
$$
DECLARE
    job_id_actual  INT;
    total_increase NUMERIC(8, 2);
    current_salary NUMERIC(8, 2);
    job_max_salary NUMERIC(8, 2);

BEGIN
    -- Tomar el job_id y el salario del empleado
    SELECT salary, job_id
    into current_salary, job_id_actual
    FROM employees
    WHERE employee_id = empl_id;

    -- Tomar el salario maximo del job
    SELECT max_salary
    into job_max_salary
    FROM jobs
    WHERE job_id = job_id_actual;

    -- Operacion
    total_increase = job_max_salary - current_salary;
    IF (total_increase < 0 ) THEN
        RAISE EXCEPTION 'Empleado con salario mas alto que el salario maximo: %', empl_id;
    end if;

    RETURN total_increase;
end;
$$
    LANGUAGE plpgsql;

-- Max_raise_2 con rowtype

CREATE OR REPLACE FUNCTION max_raise_2_row(empl_id INT)
    RETURNS NUMERIC(8, 2)
AS
$$
DECLARE
    row_employee employees%rowtype;
    row_job jobs%rowtype;
    total_increase NUMERIC(8,2);

BEGIN
    -- Tomar el job_id y el salario del empleado
    SELECT *
    INTO row_employee
    FROM employees
    WHERE employee_id = empl_id;

    -- Tomar el salario maximo del job
    SELECT *
    into row_job
    FROM jobs
    WHERE job_id = row_employee.job_id;

    -- Operacion
    total_increase = row_job.max_salary - row_employee.salary;

    IF (total_increase < 0 ) THEN
        RAISE EXCEPTION 'Empleado con salario mas alto que el salario maximo: %, %', row_employee.employee_id, row_employee.first_name;
    end if;

    RETURN total_increase;
end;
$$
    LANGUAGE plpgsql;
