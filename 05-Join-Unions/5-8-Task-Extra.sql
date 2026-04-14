/* Ejercicio 1:
 "Necesito un listado de ciudades, pero no de todas.
 Quiero saber el nombre de la ciudad, el distrito en el que se encuentra, y el nombre de su país.
 Pero, solo me interesan las ciudades que pertenecen a países que lograron su independencia (indepyear) en el año 1900 o después."
 */

SELECT a.name as city,
       a.district,
       b.name as country
FROM city as a
INNER JOIN country as b ON a.countrycode = b.code
WHERE b.indepyear IS NOT NULL AND b.indepyear >= 1900
ORDER BY country;

/*
 Ejercicio 2:
 "Quiero un mapa de los idiomas dominantes en el mundo.
 Tráeme el nombre del continente, el nombre del país y el nombre del idioma.
 La regla de negocio es estricta:
 solo quiero ver aquellos idiomas que sean OFICIALES en ese país y que además sean hablados por MÁS del 80% de su población (percentage)."
 */

SELECT c.name as continent,
       b.name as country,
       d.name as language
FROM countrylanguage as a
INNER JOIN country as b ON a.countrycode = b.code
INNER JOIN continent as c ON b.continent = c.code
INNER JOIN language as d ON a.languagecode = d.code
WHERE a.isofficial is TRUE AND a.percentage > 80.0
ORDER BY c.name;

/*
 Ejercicio 3:
 "Quiero un reporte ejecutivo que muestre:

El nombre del País.

El nombre de su Continente.

El nombre de su Ciudad Capital (usando la relación que te acabo de mencionar).

La poblacion de esa CIUDAD CAPITAL (no la del país, sino la de la ciudad)."
 */

SELECT b.name as continent,
       a.name as country,
       c.name as capital,
       c.population as population
FROM country as a
INNER JOIN continent as b ON a.continent = b.code
INNER JOIN city as c ON a.capital = c.id
ORDER BY continent;