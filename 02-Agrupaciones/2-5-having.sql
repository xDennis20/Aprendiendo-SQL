-- HAVING sirve para filtrar los grupos que crea GROUP BY, es decir HAVING se usa cuando
-- en nuestra consulta usamos una funcion de agregacion (SUM,AVG,COUNT,etc.)

SELECT round(avg(followers)) as promedio_seguidores,
       country
FROM users
WHERE following >= 10
GROUP BY
    country
HAVING avg(followers)>= 3000
ORDER BY avg(followers) desc;
