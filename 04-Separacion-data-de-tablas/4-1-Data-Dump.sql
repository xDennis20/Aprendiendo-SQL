INSERT INTO continent (name)
SELECT DISTINCT continent
FROM country
ORDER BY continent ASC; --Query para separar los datos de continente de la tabla country a una tabla propia de solo continentes.