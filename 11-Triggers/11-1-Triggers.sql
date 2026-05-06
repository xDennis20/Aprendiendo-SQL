CREATE OR REPLACE TRIGGER create_sesion_trigger
    AFTER UPDATE
    ON "user"
    FOR EACH ROW
    WHEN ( OLD.last_login IS DISTINCT FROM NEW.last_login )
EXECUTE PROCEDURE create_sesion_log();

CREATE OR REPLACE FUNCTION create_sesion_log()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO "session" (user_id, last_login)
    VALUES (NEW.id, now());

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;