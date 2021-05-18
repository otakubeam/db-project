UPDATE "Maintainer"
SET location_nm = 'Japan'
WHERE maintainer_nm = 'Felix Yan';


DELETE
FROM "PGP key"
WHERE id =
    (SELECT id
     FROM "Maintainer"
     WHERE maintainer_nm = 'Antonio Rojas')
  AND fingerprint_txt = '0x3B94FA10' RETURNING *;
