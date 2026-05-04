CREATE OR REPLACE PROCEDURE controlled_raise(percentage NUMERIC)
AS
$$
DECLARE

    real_percentage NUMERIC(4, 2);
    total_employees INT;
BEGIN
    -- Sacar porcentaje real
    real_percentage := percentage / 100;

    -- Insertar datos
    INSERT INTO raise_history (date, employee_id, base_salary, amount, percentage)
    SELECT current_date as "date",
           employee_id,
           salary,
           max_raise(employee_id) * real_percentage,
           percentage
    FROM employees;

    -- Modificar la tabla employees
    UPDATE employees
    SET salary = (max_raise(employee_id) * real_percentage) + salary;

    SELECT count(*)
    INTO total_employees
    FROM employees;
    COMMIT;
end;
$$
    LANGUAGE plpgsql;

CALL controlled_raise(1);

SELECT * FROM employees;