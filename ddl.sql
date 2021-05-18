CREATE TABLE IF NOT EXISTS "Maintainer"
(
    id serial NOT NULL
        CONSTRAINT maintainer_pk
            PRIMARY KEY,
    maintainer_nm varchar(128) NOT NULL,
    email_addr_txt text,
    location_nm varchar(64) NOT NULL
);

ALTER TABLE "Maintainer" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "Package"
(
    id serial NOT NULL
        CONSTRAINT package_pk
            PRIMARY KEY,
    repository_nm varchar(16) NOT NULL,
    maintainer_id integer NOT NULL
        CONSTRAINT package_maintainer_id_fk
            REFERENCES "Maintainer",
    package_nm varchar(128) NOT NULL,
    architecture_nm varchar(16) NOT NULL,
    last_updated_dt date NOT NULL,
    package_sz real NOT NULL,
    lincense_nm varchar(16)
);

ALTER TABLE "Package" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "PGP key"
(
    id serial NOT NULL
        CONSTRAINT "pgp key_pk"
            PRIMARY KEY,
    maintainer_id integer NOT NULL
        CONSTRAINT "pgp key_maintainer_id_fk"
            REFERENCES "Maintainer",
    fingerprint_txt varchar(64) NOT NULL
);

ALTER TABLE "PGP key" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "Source Code"
(
    id serial NOT NULL
        CONSTRAINT "source code_pk"
            PRIMARY KEY,
    package_id integer NOT NULL
        CONSTRAINT "source code_package_id_fk"
            REFERENCES "Package",
    commits_cnt integer NOT NULL,
    vcs_nm varchar(16)
);

ALTER TABLE "Source Code" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "Developer"
(
    id serial NOT NULL
        CONSTRAINT developer_pk
            PRIMARY KEY,
    developer_nm varchar(128) NOT NULL,
    email_addr_txt text
);

ALTER TABLE "Developer" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "Source code X Developer"
(
    id serial NOT NULL
        CONSTRAINT "source code x developer_pk"
            PRIMARY KEY,
    developer_id integer NOT NULL
        CONSTRAINT "source code x developer_developer_id_fk"
            REFERENCES "Developer",
    source_id integer NOT NULL
        CONSTRAINT "source code x developer_source code_id_fk"
            REFERENCES "Source Code"
);

ALTER TABLE "Source code X Developer" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "Package Group"
(
    id serial NOT NULL
        CONSTRAINT "package group_pk"
            PRIMARY KEY,
    group_nm varchar(16) NOT NULL,
    is_base_flag boolean DEFAULT FALSE NOT NULL
);

ALTER TABLE "Package Group" OWNER TO postgres;

CREATE TABLE IF NOT EXISTS "Package X  Package Group"
(
    id serial NOT NULL
        CONSTRAINT "package x  package group_pk"
            PRIMARY KEY,
    group_id integer
        CONSTRAINT "package x  package group_package group_id_fk"
            REFERENCES "Package Group",
    package_id integer
        CONSTRAINT "package x  package group_package_id_fk"
            REFERENCES "Package"
);

ALTER TABLE "Package X  Package Group" OWNER TO postgres;

CREATE OR REPLACE VIEW basepackages(id, group_nm) AS
    SELECT "Package Group".id,
       "Package Group".group_nm
FROM "Package Group"
WHERE "Package Group".is_base_flag = TRUE;

ALTER TABLE basepackages OWNER TO postgres;

CREATE OR REPLACE VIEW germanmaintainers(id, maintainer_nm, email_addr_txt) AS
    SELECT "Maintainer".id,
       "Maintainer".maintainer_nm,
       "Maintainer".email_addr_txt
FROM "Maintainer"
WHERE "Maintainer".location_nm::text = 'Germany'::text;

ALTER TABLE germanmaintainers OWNER TO postgres;

CREATE OR REPLACE VIEW largecustomlicensedpackages(package_nm, architecture_nm, last_updated_dt, package_sz, repository_nm) AS
    SELECT "Package".package_nm,
       "Package".architecture_nm,
       "Package".last_updated_dt,
       "Package".package_sz,
       "Package".repository_nm
FROM "Package"
WHERE "Package".lincense_nm::text = 'Custom'::text
  AND "Package".package_sz > 5::double precision;

ALTER TABLE largecustomlicensedpackages OWNER TO postgres;

CREATE OR REPLACE VIEW developerssecretemails(developer_nm, mask_email) AS
    SELECT "Developer".developer_nm,
       mask_email("Developer".email_addr_txt, 1, 2) AS mask_email
FROM "Developer";

ALTER TABLE developerssecretemails OWNER TO postgres;

CREATE OR REPLACE VIEW activedevelopment(package_nm, last_updated_dt, vcs_nm, commits_cnt) AS
    SELECT "Package".package_nm,
       "Package".last_updated_dt,
       "Source Code".vcs_nm,
       "Source Code".commits_cnt
FROM "Source Code"
         JOIN "Package" ON "Source Code".package_id = "Package".id
WHERE "Source Code".commits_cnt > 10000;

ALTER TABLE activedevelopment OWNER TO postgres;

CREATE OR REPLACE VIEW keynumber(maintainer_nm, COUNT) AS
    SELECT "Maintainer".maintainer_nm,
       count("PGP key".id) AS COUNT
FROM "Maintainer"
         JOIN "PGP key" ON "Maintainer".id = "PGP key".maintainer_id
GROUP BY "Maintainer".maintainer_nm;

ALTER TABLE keynumber OWNER TO postgres;

CREATE OR REPLACE FUNCTION mask_email(email text, offset_left integer, offset_right integer) RETURNS text
    LANGUAGE PLPGSQL
AS $$
DECLARE
    answer text:= '';
BEGIN
        answer = concat(answer, left(email, offset_left));

    For i in offset_left .. length(split_part($1, '@', 1)) - offset_right
    LOOP
    answer = concat(answer, '*');
    end loop;
    answer = concat(answer, right(split_part($1, '@', 1), offset_right));
    answer = concat(answer, '@');
    answer = concat(answer, split_part($1, '@', 2));
    return answer;
END
$$;

ALTER FUNCTION mask_email(text, integer, integer) OWNER TO postgres;

CREATE OR REPLACE FUNCTION no_rewrite_at_night() RETURNS event_trigger
    LANGUAGE PLPGSQL
AS $$
DECLARE
        ct int := extract('hour' FROM current_time);
    BEGIN
        IF (ct > 23 or ct < 7) THEN
            RAISE EXCEPTION 'No rewrites at nighttime';
        END IF;
    END;
$$;

ALTER FUNCTION no_rewrite_at_night() OWNER TO postgres;

CREATE OR REPLACE FUNCTION number_of_developed_progs(package_name CHARACTER varying) RETURNS integer
    LANGUAGE PLPGSQL
AS $$
DECLARE
    result int := 0;
BEGIN
    EXECUTE format('SELECT count("Developer".id) FROM "Developer"
                 JOIN "Source code X Developer" "S c X D" ON "Developer".id = "S c X D".developer_id
                 JOIN "Source Code" "S C" ON "S C".id = "S c X D".source_id
                 WHERE developer_nm = ''%s''', package_name) INTO result;
    RETURN result;
end;
$$;

ALTER FUNCTION number_of_developed_progs(varchar) OWNER TO postgres;
