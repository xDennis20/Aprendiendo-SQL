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
    empld_salario NUMERIC(8, 2);
    count_depend  INT;
BEGIN
    -- Obtener salario del empleado
    SELECT salary
    into empld_salario
    FROM employees
    WHERE employee_id = empld_id;

    -- Obtener cantidad de dependientes
    SELECT count(*) as contador
    into count_depend
    FROM dependents
    WHERE employee_id = empld_id;

    -- Calcular bono
    IF (count_depend = 0) THEN
        RETURN empld_salario * 0.05;
    ELSIF (count_depend BETWEEN 1 AND 2) THEN
        RETURN empld_salario * 0.10;
    ELSIF (count_depend >= 3) THEN
        RETURN empld_salario * 0.15;
    end if;
end;
$$
    LANGUAGE plpgsql;

SELECT first_name,
       salary,
       calcular_bono(employee_id)
FROM employees;

/*
 Reto 2: Manipulación de Texto y Joins (El Generador de Etiquetas)
Tablas: departments, locations, countries

Requerimiento del negocio:
El departamento de mensajería necesita generar rápidamente la dirección completa de un departamento para imprimirla en las cajas de envío.

Crea una función llamada generar_direccion_dpto(dpto_id INT) que retorne un texto (VARCHAR).

Reglas:

El formato exacto del texto debe ser: "Departamento: [Nombre Dpto] - Dirección: [street_address], [city], [country_name]"

Ejemplo: "Departamento: IT - Dirección: 123 Tech Ave, Seattle, United States of America"
 */

CREATE OR REPLACE FUNCTION generar_direccion_dpto(dpto_id INT)
    RETURNS VARCHAR
AS
$$
DECLARE
    department_name VARCHAR(30);
    street_address  VARCHAR(40);
    name_city       VARCHAR(30);
    name_country    VARCHAR(30);
BEGIN
    SELECT a.department_name,
           b.street_address,
           b.city,
           c.country_name
    INTO
        department_name,
        street_address,
        name_city,
        name_country
    FROM departments as a
             INNER JOIN locations b ON a.location_id = b.location_id
             INNER JOIN countries c ON b.country_id = c.country_id
    WHERE a.department_id = dpto_id;

    RETURN
        'Departamento: ' || department_name || ' - ' || 'Direccion: ' || street_address || ', ' || name_city || ', ' ||
        name_country;
end;
$$
    LANGUAGE plpgsql;

SELECT department_name,
       generar_direccion_dpto(department_id)
FROM departments;

/*
 Tablas: employees, jobs

Requerimiento del negocio:
Queremos un sistema automático que nos diga si un empleado es candidato válido para que lo suban de puesto a un nuevo cargo.

Crea una función llamada evaluar_ascenso(empl_id INT, nuevo_job_id INT) que retorne un Booleano (BOOLEAN).

Reglas para que retorne TRUE (Aprobado):

El empleado debe tener más de 5 años trabajando en la empresa (basado en su hire_date).

El salario actual del empleado debe ser menor que el max_salary del nuevo puesto al que aspira. (No podemos ascenderlo si ya gana más que el tope del nuevo puesto).

Si incumple cualquiera de las dos reglas, retorna FALSE.
 */
CREATE OR REPLACE FUNCTION evaluar_ascenso(empl_id INT, nuevo_job_id INT)
    RETURNS BOOLEAN
AS
$$
DECLARE
    row_employe record;
    new_max_salary_job NUMERIC(8,2);
BEGIN
    SELECT age(current_date, hire_date) as tiempo_contratado,
           salary
    INTO
        row_employe
    FROM employees
    WHERE employee_id = empl_id;

    SELECT max_salary
    INTO
    new_max_salary_job
    FROM jobs
    WHERE job_id = nuevo_job_id;

    IF (row_employe.tiempo_contratado > INTERVAL '5 Years') AND (row_employe.salary < new_max_salary_job) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    end if;
end;
$$
    LANGUAGE plpgsql;