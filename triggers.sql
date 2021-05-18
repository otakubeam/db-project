CREATE OR REPLACE FUNCTION no_rewrite_at_night()
    RETURNS event_trigger AS $$
DECLARE
    ct int := extract('hour' FROM current_time);
BEGIN
    IF (ct > 23 or ct < 7) THEN
        RAISE EXCEPTION 'No rewrites at nighttime';
    END IF;
END;
$$ LANGUAGE plpgsql;


-- The ddl_command_start event occurs just before the execution of a CREATE,
-- ALTER, DROP, SECURITY LABEL, COMMENT, GRANT or REVOKE command.

CREATE EVENT TRIGGER no_rewrite_allowed
ON DDL_COMMAND_START EXECUTE PROCEDURE no_rewrite_at_night();
