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