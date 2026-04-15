/*
 Ejercicio 1:
 Haz un SELECT del first_name, last_name, hire_date, y crea una nueva columna calculada llamada fase_corporativa con las siguientes reglas lógicas:

Si fue contratado entre 2010 y 2015 (incluyendo 2015) -> 'Fase de Fundadores'

Si fue contratado entre 2016 y 2021 (incluyendo 2021) -> 'Fase de Expansión'

Si fue contratado del 2022 en adelante -> 'Nueva Ola'
(Pista: Puedes usar EXTRACT o DATE_PART en el WHEN, o comparar directamente contra strings de fechas completas como '2015-12-31').
 */

SELECT first_name,
       last_name,
       hire_date,
       CASE
           when extract('Year' FROM hire_date) BETWEEN 2010 AND 2015 THEN 'Fase de Fundadores'
           when extract('Year' FROM hire_date) BETWEEN 2016 AND 2021 THEN 'Fase de expansion'
           else 'Nueva Ola'
           END as fase_coporativa
FROM employees;

/*
 Ejercicio 2:
 Contexto: RRHH va a dar un bono por cada año completo de servicio.
 Necesitan saber los años exactos y cumplidos de cada empleado hasta el día de hoy.
 Tu Misión: Haz un SELECT del nombre del empleado, su fecha de contratación y usa la función específica de PostgreSQL diseñada para calcular intervalos de tiempo reales.
 De ese resultado, extrae únicamente los años para obtener la cantidad de años cumplidos reales como un número entero.
 */

SELECT first_name,
       last_name,
       hire_date,
       extract('year' FROM age(current_date,hire_date)) as años_cumplidos
FROM employees;

/*
 Ejercicio 3:
 Contexto: RRHH instauró una nueva política de revisión de contratos para todos los empleados de esta generación (2010-2026).
 La fecha de la primera revisión se calcula sumando un bloque de tiempo dinámico a la fecha original de contratación (hire_date), dependiendo del salario actual del empleado (salary).
 Tu Misión: Haz un SELECT del first_name, salary, hire_date y una columna calculada llamada fecha_revision.
 Las reglas para sumar el tiempo son:
 Si el salario es mayor a 10000, súmale exactamente 2 años a su hire_date.

 Si el salario es menor o igual a 10000, súmale exactamente 6 meses a su hire_date.
 */

SELECT first_name,
       last_name,
       hire_date,
       CASE
           when salary > 10000 THEN (hire_date + INTERVAL '2 years')::DATE
           when salary <= 10000 THEN (hire_date + INTERVAL '6 months')::DATE
       END as fecha_revision
FROM employees;