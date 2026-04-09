SELECT a.name,
       a.continent,
       (SELECT b."code" as id_continent FROM continent b WHERE b.name = a.continent)
FROM country as a; -- Query para verificar que obtenemos los datos deseados para poder hacer el cambio

UPDATE country a
SET continent = (SELECT b."code" as id_continent FROM continent b WHERE b.name = a.continent); -- Query para actualiar los datos de la columna continent