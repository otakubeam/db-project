-- посчитать пакеты, над которыми работало больше одного разработчика
SELECT count(D.id),
       package_nm
FROM "Package"
JOIN "Source Code" "S C" ON "Package".id = "S C".package_id
JOIN "Source code X Developer" "S c X D" ON "S C".id = "S c X D".source_id
JOIN "Developer" D ON D.id = "S c X D".developer_id
GROUP BY package_nm
HAVING count(D.id) > 1;


-- вывести топ 1 меэнтейнера по каличеству поддеживаемых пакетов
SELECT count(P.id),
       maintainer_nm
FROM "Maintainer"
JOIN "Package" P ON "Maintainer".id = P.maintainer_id
GROUP BY maintainer_nm
ORDER BY count(P.id) DESC
LIMIT 1;


-- выбрать пакеты, которыe разрабатываются не в git
SELECT package_nm
FROM "Package"
JOIN "Source Code" "S C" ON "Package".id = "S C".package_id
EXCEPT
SELECT package_nm
FROM "Package"
JOIN "Source Code" "S C2" ON "Package".id = "S C2".package_id
WHERE vcs_nm = 'git';


-- вывести по каждой стране мэйнтейнеров, которые поддерживают более одного пакета
SELECT *
FROM
  (SELECT maintainer_nm,
          location_nm,
          row_number() OVER (PARTITION BY location_nm
                             ORDER BY count(P.id) DESC) AS top
   FROM "Maintainer"
   JOIN "Package" P ON "Maintainer".id = P.maintainer_id
   GROUP BY maintainer_nm,
            location_nm) AS TEMP
WHERE top > 1;


-- вывести максимальный размер пакета в группе
SELECT group_nm,
       max(package_sz)
FROM "Package Group"
JOIN "Package X  Package Group" "P X  P G" ON "Package Group".id = "P X  P G".group_id
JOIN "Package" P ON P.id = "P X  P G".package_id
GROUP BY group_nm;
