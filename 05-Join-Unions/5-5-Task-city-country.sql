-- Mostrar el pais con mas ciudades
-- Campos: Total de ciudades y el nombre del pais
-- Usar INNER JOIN

SELECT count(a.name) as total,
       c.name        as city
FROM city as a
         INNER JOIN country as c ON a.countrycode = c.code
GROUP BY c.name
ORDER BY total DESC
LIMIT 1;