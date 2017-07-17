USE ship_reimb;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM oms_data 
WHERE
    id_district NOT IN (SELECT 
        id_district
    FROM
        free_zone);

SET SQL_SAFE_UPDATES = 1;