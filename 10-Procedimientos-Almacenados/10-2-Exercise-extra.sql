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
    real_porcentaje              NUMERIC;
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
    WHERE department_id = dpto_id
      AND salary > j.max_salary;

    IF (contador_salario_sobrepasado = 0) THEN
        COMMIT;
    ELSE
        RAISE EXCEPTION 'Operación cancelada. El aumento supera el límite permitido para algunos puestos.';
    END IF;
END;
$$
    LANGUAGE plpgsql;

/*
 Objetivo: Mantener la integridad de los datos (evitar empleados huérfanos de jefe).
Tabla a usar: employees

El Requerimiento:
Un gerente (Manager) acaba de ser despedido. No podemos simplemente borrarlo, porque los empleados que estaban a su cargo se quedarían sin jefe (manager_id quedaría apuntando a la nada o daría error de Foreign Key).

Crea un procedimiento llamado sp_despedir_manager(id_manager_despedido INT).
 */

CREATE OR REPLACE PROCEDURE sp_despedir_manager(id_manager_despedido INT)
AS
$$
DECLARE
    id_jefe_del_manager_despedido INTEGER;
BEGIN

    -- Obtener el id del jefe del manager despedido
    SELECT manager_id
    INTO id_jefe_del_manager_despedido
    FROM employees
    WHERE employee_id = id_manager_despedido;

    -- Actualizar a todos los que tenian de jefe al manager que fue despedido al nuevo jefe
    UPDATE employees
    SET manager_id = id_jefe_del_manager_despedido
    WHERE manager_id = id_manager_despedido;

    -- ELiminar manager despedido
    DELETE
    FROM employees
    WHERE employee_id = id_manager_despedido;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Se canceló el despido por un error inesperado. Detalle del error: %', SQLERRM;

end;
$$
    LANGUAGE plpgsql;

/*
 La Contratación en Cadena (Inserciones dependientes)
Objetivo: Usar IDs recién creados para insertarlos en otras tablas dentro de la misma transacción.
Tablas a usar: departments, employees

El Requerimiento:
La empresa está abriendo un nuevo departamento e inmediatamente está contratando al que será su primer empleado.

Crea un procedimiento sp_crear_departamento_y_empleado(...). Va a recibir muchos parámetros: el nombre del departamento, el ID de la locación, y todos los datos básicos del nuevo empleado (nombre, apellido, email, fecha, trabajo, salario).
 */

CREATE OR REPLACE PROCEDURE sp_crear_departamento_y_empleado(department_name VARCHAR(30),
                                                             locations_id INTEGER,
                                                             nfirst_name VARCHAR(20),
                                                             nlast_name VARCHAR(25),
                                                             nemail VARCHAR(100),
                                                             nphone_number VARCHAR(20),
                                                             njob_id INTEGER,
                                                             nmanager_id INTEGER,
                                                             nsalary NUMERIC(8, 2))
AS
$$
DECLARE
    id_new_department INTEGER;
BEGIN
    -- Obtener id del nuevo departamento
    INSERT INTO departments(department_name, location_id)
    VALUES (sp_crear_departamento_y_empleado.department_name, locations_id)
    RETURNING
        department_id
        INTO id_new_department;

    -- Colocar el nuevo empleado al departamento nuevo
    INSERT INTO employees(first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id,
                          department_id)
    VALUES (nfirst_name, nlast_name, nemail, nphone_number, current_date, njob_id, nsalary, nmanager_id,
            id_new_department);
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error: %', SQLERRM;
END;
$$
    LANGUAGE plpgsql;

/*
 Ejercicio de fernando
 */
CREATE OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR)
AS
$$
DECLARE
    was_found BOOLEAN;
BEGIN
    SELECT count(*)
    INTO was_found
    FROM "user"
    WHERE name = user_name
      AND password = crypt(user_password, password);

    IF (was_found = FALSE) THEN
        INSERT INTO session_failed(id, username, "when")
        VALUES (1, user_name, current_timestamp);
        COMMIT;
        RAISE EXCEPTION 'Usuario y contraseña no son correctos';
    end if;

    UPDATE "user"
    SET last_login = now()
    WHERE name = user_name;
    COMMIT;
    RAISE NOTICE 'Usuario Encontrado %', was_found;
END;
$$
    LANGUAGE plpgsql;
