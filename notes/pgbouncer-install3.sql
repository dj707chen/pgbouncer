
-- Need to be SUPERUSER, otherwise there will be "ERROR:  permission denied for view pg_shadow"
-- from FUNCTION public.lookup
DROP ROLE IF EXISTS pgbouncer;
CREATE ROLE pgbouncer LOGIN PASSWORD 'pgbouncer';
-- CREATE ROLE pgbouncer LOGIN PASSWORD 'pgbouncer';
-- set a password for the user
-- \password pgbouncer

SET ROLE pgbouncer;

-- Need to create this function in EACH database
CREATE OR REPLACE FUNCTION public.lookup (
    INOUT p_user     name,
    OUT   p_password text
) RETURNS record
    LANGUAGE sql SECURITY DEFINER SET search_path = pg_catalog AS
$$SELECT usename, passwd FROM pg_shadow WHERE usename = p_user$$;

-- make sure only "pgbouncer" can use the function
REVOKE EXECUTE ON FUNCTION public.lookup(name) FROM PUBLIC;
GRANT  EXECUTE ON FUNCTION public.lookup(name) TO pgbouncer;
