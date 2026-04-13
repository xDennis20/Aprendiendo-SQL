-- Saber los idiomas oficiales que se hablan en un continente

SELECT DISTINCT l.name,
                a.isofficial,
                c.name
FROM countrylanguage as a
         INNER JOIN country as b ON a.countrycode = b.code
         INNER JOIN continent as c ON b.continent = c.code
         INNER JOIN language as l on a.languagecode = l.code
WHERE isofficial is TRUE
ORDER BY c.name;

-- Cuantos idiomas oficiales se hablan en un continente

SELECT count(*) as total, totales.name as continent
FROM (SELECT DISTINCT a.language,
                      a.isofficial,
                      c.name
      FROM countrylanguage as a
               INNER JOIN country as b ON a.countrycode = b.code
               INNER JOIN continent as c ON b.continent = c.code
      WHERE isofficial is TRUE
      ORDER BY c.name) as totales
GROUP BY totales.name
ORDER BY total DESC;

