ALTER TABLE country
ALTER COLUMN continent TYPE int4
USING continent::integer;