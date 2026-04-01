SELECT first_name, last_name, followers
FROM users
-- El operador BETWEEN sirve para buscar datos en un rango especifico (5-10)
-- Cabe aclarar que tambien se puede hacerlo sin BETWEEN (followers > 4500 ANDfollowers < 4600)
WHERE followers > 4300 and followers < 4500
-- ORDER BY Sirve para ordenar datos dependiendo si queremos de forma ascendente (ASC) o descendente (DESC)
ORDER BY
    followers DESC;