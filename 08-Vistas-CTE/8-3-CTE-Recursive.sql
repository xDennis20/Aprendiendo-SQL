-- Nombre de la tabla temporal
-- Campos que la tabla va contener
WITH RECURSIVE countdown(val) as (
    -- inicializacion -> Es decir que con que valores va empezar la recursividad
    -- Quiero que empieze con el valor de 10
    SELECT 10 as val
    UNION
    -- Query recursivo o la iteracion recursiva
    SELECT val - 1 from countdown WHERE val > 1
)
SELECT * FROM countdown;

-- 2 Ejercicio
WITH RECURSIVE increase(val) as (
    -- inicializacion -> Es decir que con que valores va empezar la recursividad
    -- Quiero que empieze con el valor de 1
    SELECT 1 as val
    UNION
    -- Query recursivo o la iteracion recursiva
    SELECT val + 1 from increase WHERE val < 10
)
SELECT * FROM increase;

-- 3 Ejercicio
WITH RECURSIVE multiplication(base, multiplicador, result) as (
    SELECT 5 as base , 1 as multiplicador, 5 as result
    UNION
    SELECT base, multiplicador + 1, base * (multiplicador + 1 )  FROM multiplication WHERE multiplicador < 10
)
SELECT * FROM multiplication;

-- Ejercicio de empleados y jefes
WITH RECURSIVE bosses as (
    -- inicializacion
    SELECT id, name, report_to FROM employees where id = 6
    UNION
    -- iteracion recursiva
    SELECT a.id, a.name, a.report_to FROM employees as a
                                              INNER JOIN bosses as b ON b.id = a.report_to
)
SELECT * FROM bosses;