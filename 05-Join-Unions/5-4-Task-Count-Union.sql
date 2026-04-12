-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa

SELECT count(c.name) as total,
       c.name
FROM country as a
INNER JOIN continent c on c.code = a.continent AND NOT c.name LIKE '%America%'
GROUP BY c.name
UNION
SELECT count(c.name) as total,
       'America'
FROM country as a
         INNER JOIN continent c on c.code = a.continent AND c.name LIKE '%America%';