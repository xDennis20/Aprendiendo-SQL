DELETE
FROM country
WHERE code = 'AFG'; -- Query para eliminar un codigo, como esta con Cascade los foreignkey, se eliminara todo lo relacionado

SELECT *
FROM city
WHERE countrycode = 'AFG';

SELECT *
FROM countrylanguage
WHERE countrycode = 'AFG';