SELECT first_name,
       last_name,
       hire_date,
       CASE
           when hire_date > now() - INTERVAL '1 year' THEN 'Nuevo (1 año y menos)'
           when hire_date > now() - INTERVAL '3 year' THEN 'Normal (1-3 años y menos)'
           else 'Antiguo'
       END as rango_antiguedad
FROM employees