ALTER TABLE country
    DROP CONSTRAINT country_continent_check; -- Este Query es para eliminar CHECKS que interfieran en nuestra nuevo CHECK

ALTER TABLE country
    ADD CHECK ( continent IN ('Asia',
                              'South America',
                              'North America',
                              'Oceania',
                              'Antarctica',
                              'Africa',
                              'Europe',
                              'Central America')); -- Este Query es para agregar restricciones a una columna para validar datos correctos que nosotros esperamos