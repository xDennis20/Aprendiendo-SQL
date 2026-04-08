-- Restringue que en el continente de Antarctica la poblacion se mantenga en 0 y cualquier continente diferente que sea mayor a 0
ALTER TABLE country
    ADD CONSTRAINT check_logic_population_continent CHECK (
        (continent = 'Antarctica' AND population = 0) OR (continent != 'Antarctica' AND population > 0)
        );

-- Restringue que la indenpendencia del pais no sea mayor al año actual
AlTER TABLE country
    ADD CONSTRAINT check_logic_indepyear CHECK (
        indepyear <= EXTRACT(YEAR FROM CURRENT_DATE)
        );