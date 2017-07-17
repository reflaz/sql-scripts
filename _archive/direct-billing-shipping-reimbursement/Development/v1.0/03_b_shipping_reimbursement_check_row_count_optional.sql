SELECT 
    'free_zone' AS 'table', COUNT(*) 'row_count'
FROM
    ship_reimb.free_zone 
UNION ALL SELECT 
    'jne_rate' AS 'table', COUNT(*) 'row_count'
FROM
    ship_reimb.jne_rate 
UNION ALL SELECT 
    'oms_data' AS 'table', COUNT(*) 'row_count'
FROM
    ship_reimb.oms_data;