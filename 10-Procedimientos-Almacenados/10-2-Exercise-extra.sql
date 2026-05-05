/*
 El Aumento Masivo (Control Transaccional)
Objetivo: Modificar múltiples registros y abortar todo si se rompe una regla de negocio.
Tablas a usar: employees, jobs

El Requerimiento:
La junta directiva decidió dar un aumento general a un departamento específico.

Crea un procedimiento llamado sp_aumento_departamento(dpto_id INT, porcentaje NUMERIC).

La Regla: Debes aplicarle el aumento (ej: 0.10 para 10%) a todos los empleados de ese departamento. PERO, ninguna persona puede quedar ganando más que el max_salary de su puesto (job_id).

La Transacción: Si el aumento hace que incluso un solo empleado supere su salario máximo permitido, debes hacer un ROLLBACK de toda la operación y lanzar un mensaje de error diciendo: "Operación cancelada. El aumento supera el límite permitido para algunos puestos." Si todos están dentro del límite, haces el COMMIT.
 */

CREATE OR REPLACE PROCEDURE sp_aumento_departamento(dpto_id INT, porcentaje NUMERIC)
AS
$$
DECLARE
    real_porcentaje NUMERIC;
    contador_salario_sobrepasado INT;
BEGIN
    real_porcentaje := porcentaje / 100;

    -- Acceder a los empleados del departamento ingresado y sacar la info del max_salary del job que estan
    UPDATE employees
    SET salary = salary + (salary * real_porcentaje)
    WHERE department_id = dpto_id;

    --Obtener max_raise del job del empleado
    SELECT count(*)
    INTO contador_salario_sobrepasado
    FROM employees
             INNER JOIN public.jobs j on j.job_id = employees.job_id
    WHERE department_id = dpto_id AND salary > j.max_salary;

    IF (contador_salario_sobrepasado = 0) THEN
        COMMIT;
    ELSE
        RAISE EXCEPTION 'Operación cancelada. El aumento supera el límite permitido para algunos puestos.';
    END IF;
END;
$$
    LANGUAGE plpgsql;