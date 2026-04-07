CREATE UNIQUE INDEX "unique_name_countrycode_district" ON city (
                                                                name, countrycode, district
    ); -- Query de indice compuesto unico en la tabla city (name, countrycode, district)

CREATE INDEX "index_district" ON city(
                                     district
    ); -- Query de indice en la columna district de la tabla city