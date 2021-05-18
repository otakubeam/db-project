CREATE OR REPLACE VIEW GermanMaintainers AS
SELECT id,
       maintainer_nm,
       email_addr_txt
FROM "Maintainer"
WHERE location_nm = 'Germany';


CREATE OR REPLACE VIEW BasePackages AS
SELECT id,
       group_nm
FROM "Package Group"
WHERE is_base_flag = TRUE;


CREATE OR REPLACE VIEW LargeCustomLicensedPackages AS
SELECT package_nm,
       architecture_nm,
       last_updated_dt,
       package_sz,
       repository_nm
FROM "Package"
WHERE lincense_nm = 'Custom'
  AND package_sz > 5;


CREATE OR REPLACE VIEW DevelopersSecretEmails AS
SELECT developer_nm,
       mask_email(email_addr_txt, 1, 2)
FROM "Developer";


CREATE OR REPLACE VIEW ActiveDevelopment AS
SELECT package_nm,
       last_updated_dt,
       vcs_nm,
       commits_cnt
FROM "Source Code"
JOIN "Package" ON "Source Code".package_id = "Package".id
WHERE commits_cnt > 10000;


CREATE OR REPLACE VIEW KeyNumber AS
SELECT maintainer_nm,
       count("PGP key".id)
FROM "Maintainer"
JOIN "PGP key" ON "Maintainer".id = "PGP key".maintainer_id
GROUP BY maintainer_nm;
