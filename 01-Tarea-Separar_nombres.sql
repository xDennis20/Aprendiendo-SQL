SELECT name,
       substring(name, 0, position(' ' in name))  as first_name,
       substring(name, position(' ' in name) + 1) as last_name
FROM users;

UPDATE users
SET first_name = substring(name, 0, position(' ' in name)),
    last_name  = substring(name, position(' ' in name) + 1);

SELECT * FROM users;