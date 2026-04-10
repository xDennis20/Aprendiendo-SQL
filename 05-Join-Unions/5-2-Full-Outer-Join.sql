SELECT a.name as country, a.continent as code_continent,
       b.name as continent_name
FROM country a
     FULL OUTER JOIN continent as b ON a.continent = b.code
ORDER BY code_continent DESC; -- Query de FULL OUTER JOIN

SELECT a.name as country, a.continent as code_continent,
       b.name as continent_name
FROM country a
         RIGHT OUTER JOIN continent as b ON a.continent = b.code
WHERE a.continent IS NULL
ORDER BY code_continent DESC; -- Query de RIGHT OUTER JOIN