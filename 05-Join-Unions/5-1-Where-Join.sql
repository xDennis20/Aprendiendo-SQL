SELECT a.name as country, b.name as continent
FROM country as a,
     continent as b
WHERE a.continent = b.code
ORDER BY b.name ASC; -- Query de union con WHERE

SELECT a.name as country, b.name as continent
FROM country as a
     INNER JOIN continent as b ON a.continent = b.code
ORDER BY b.name ASC; -- Lo mismo del Query de arriba pero con la sentencia INNER JOIN es mas facil.