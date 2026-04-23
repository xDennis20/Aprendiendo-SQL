
CREATE OR REPLACE FUNCTION greet_employe (employee_name VARCHAR)
    RETURNS VARCHAR
AS $$
BEGIN
    RETURN 'Hola ' || employee_name;
end;
$$
    LANGUAGE plpgsql;