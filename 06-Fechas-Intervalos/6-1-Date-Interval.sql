SELECT make_interval(YEARS := date_part('year', CURRENT_DATE)::INTEGER -
                              extract(YEARS FROM hire_date)::INTEGER) as Tiempo_contratados,
       hire_date
FROM employees
GROUP BY hire_date;

UPDATE employees
SET hire_date = hire_date + (make_interval(YEARS := date_part('year', now())::INTEGER % 100));