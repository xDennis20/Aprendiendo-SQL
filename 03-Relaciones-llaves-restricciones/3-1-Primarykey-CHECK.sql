ALTER TABLE country
    ADD PRIMARY KEY (code); -- Este Query es para selecionar una columna y ponerlo como Primary key.

ALTER TABLE country
    ADD CHECK (
        surfacearea >= 0
        ); -- Este Query sirve para poner diferente restricciones a los valores para evitar datos invalidos.