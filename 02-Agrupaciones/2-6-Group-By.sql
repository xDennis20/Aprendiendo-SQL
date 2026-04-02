SELECT count(*),
       substring(email, '@([a-z,.]+)') as dominio -- Substring sirve para cortar un string desde donde queramos mostrar
FROM users
GROUP BY dominio
HAVING count(*) > 1
ORDER BY dominio desc;