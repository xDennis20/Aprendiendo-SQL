-- Funciones agrupadas (MIN(), MAX(), AVG(), SUM(), ROUND(), COUNT())
-- Estas funciones mayormente sirven para sacar estadisticas como por ejemplo saber cual es el maximo de usuario

SELECT
    COUNT(*) as total_usuarios, -- Hace un conteo de cuantos usuarios hay en la tabla
    MAX(followers) as max_followers, -- Saca el numero maximo que hay en la columna followers
    MIN(following) as min_following, -- Saca el numero minimo que hay en la columna following
    ROUND(AVG(followers)) as avg_followers -- ROUND redondea un dato decimal y AVG saca el promedio de una cantidad de datos
FROM users