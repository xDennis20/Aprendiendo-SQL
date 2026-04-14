-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

SELECT c.name,
       count(*) as total,
       c.code as code
FROM country as a
         INNER JOIN countrylanguage as b ON a.code = b.countrycode
         INNER JOIN language as c ON b.languagecode = c.code
WHERE a.continent = 5 AND b.isofficial is TRUE
GROUP BY c.code, c.name
ORDER BY total DESC
LIMIT 1;

-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa
-- (no hacer subquery, tomar el código anterior)
SELECT b.name
FROM countrylanguage as a
INNER JOIN country as b ON a.countrycode = b.code
WHERE a.languagecode = 101 AND b.continent = 5 AND a.isofficial is TRUE;