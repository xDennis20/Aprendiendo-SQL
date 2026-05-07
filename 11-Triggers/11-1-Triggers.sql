CREATE OR REPLACE TRIGGER create_sesion_trigger
    AFTER UPDATE
    ON "user"
    FOR EACH ROW
    WHEN ( OLD.last_login IS DISTINCT FROM NEW.last_login )
EXECUTE PROCEDURE create_sesion_log();

CREATE OR REPLACE FUNCTION create_sesion_log()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO "session" (user_id, last_login)
    VALUES (NEW.id, now());

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

/*
 Ejercicio 1:
 */

CREATE OR REPLACE FUNCTION registrar_cambio_salario()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (OLD.salary IS DISTINCT FROM NEW.salary) THEN
        INSERT INTO audit_salaries(employee_id, old_salary, new_salary, changed_on)
        VALUES (OLD.employee_id, OLD.salary, NEW.salary, current_date);
    END if;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER vigilar_salarios
    BEFORE UPDATE
    ON employees
    FOR EACH ROW
EXECUTE PROCEDURE registrar_cambio_salario();

/*
 Ejercicio 2:
Objetivo: Usar un Trigger para limpiar datos basura antes de que toquen la base de datos.
Tabla a vigilar: employees
Recursos Humanos es un desastre escribiendo correos. A veces los ponen en mayúsculas, a veces se olvidan del dominio. Queremos que la base de datos arregle esto por ellos mágicamente.

Crea una función y un trigger que se dispare justo antes de insertar o actualizar un empleado.
 */

CREATE OR REPLACE FUNCTION modificar_email_invalido()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.email := lower(NEW.email);
    IF (NEW.email NOT LIKE '%@sqltutorial.org') THEN
        NEW.email := NEW.email || '@sqltutorial.org';
    end if;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER vigilar_email
    BEFORE INSERT OR UPDATE
    ON employees
    FOR EACH ROW
EXECUTE PROCEDURE modificar_email_invalido();

/*
 Ejercicio 3:
 Objetivo: Usar un Trigger para hacer cruces de tablas y abortar una operación si viola una regla de negocio.
Tablas a usar: employees, jobs
 El Requerimiento:
Ningún empleado puede ganar menos que el salario mínimo (min_salary) ni más que el salario máximo (max_salary) dictado por su puesto de trabajo (job_id).
 */

CREATE OR REPLACE FUNCTION verificar_salario()
    RETURNS TRIGGER AS
$$
DECLARE
    max_salary_job NUMERIC(8,2);
    min_salary_job NUMERIC(8,2);
BEGIN
    RAISE NOTICE '¡EL TRIGGER DESPERTÓ! El salario que intentan meter es: %', NEW.salary;
    SELECT max_salary,
           min_salary
    INTO
    max_salary_job,
    min_salary_job
    FROM jobs
    WHERE job_id = NEW.job_id;

    RAISE NOTICE '--- DEBUGGING TRIGGER ---';
    RAISE NOTICE 'Salario intentado: %', NEW.salary;
    RAISE NOTICE 'Límite Mínimo: %', min_salary_job;
    RAISE NOTICE 'Límite Máximo: %', max_salary_job;
    RAISE NOTICE '-------------------------';

    IF (min_salary_job <= NEW.salary AND NEW.salary <= max_salary_job) THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Salario Invalido. Debe estar entre % y %', min_salary_job, max_salary_job;
    end if;

END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER vigilar_salarios
    BEFORE INSERT OR UPDATE
    ON employees
    FOR EACH ROW
EXECUTE PROCEDURE verificar_salario();