SELECT count(*),
       b.name
FROM country as a
         INNER JOIN continent as b ON a.continent = b.code
GROUP BY b.name
ORDER BY count(*);

SELECT count(a.continent) as total,
       b.name
FROM country as a
         RIGHT JOIN continent as b ON a.continent = b.code
GROUP BY b.name
ORDER BY total;