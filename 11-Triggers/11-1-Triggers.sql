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
    BEFORE UPDATE ON employees
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
    IF ( NEW.email NOT LIKE '%@sqltutorial.org' ) THEN
        NEW.email := NEW.email || '@sqltutorial.org';
    end if;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER vigilar_email
    BEFORE INSERT OR UPDATE ON employees
    FOR EACH ROW
    EXECUTE PROCEDURE modificar_email_invalido();