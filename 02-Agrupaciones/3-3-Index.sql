SELECT *
FROM country;

CREATE UNIQUE INDEX "country_name" ON country (
                                               name); -- Query para crear un indice unico en la columna name de la tabla country

CREATE INDEX "country_continent" ON country (
                                             continent); -- Query para crear indices no unico en la columna continent de la tabla country