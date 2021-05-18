CREATE TABLE IF NOT EXISTS "Maintainer"
(
    id serial NOT NULL
        CONSTRAINT maintainer_pk
            PRIMARY KEY,
    maintainer_nm varchar(128) NOT NULL,
    email_addr_txt text,
    location_nm varchar(64) NOT NULL
);

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


CREATE TABLE IF NOT EXISTS "Developer"
(
    id serial NOT NULL
        CONSTRAINT developer_pk
            PRIMARY KEY,
    developer_nm varchar(128) NOT NULL,
    email_addr_txt text
);


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


CREATE TABLE IF NOT EXISTS "Package Group"
(
    id serial NOT NULL
        CONSTRAINT "package group_pk"
            PRIMARY KEY,
    group_nm varchar(16) NOT NULL,
    is_base_flag boolean DEFAULT FALSE NOT NULL
);


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
