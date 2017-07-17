USE scgl;

-- timeframe for before
SET @extractstart = '2016-12-01';
SET @extractend = '2017-01-01';

SELECT 
    'anondb_extract' AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
UNION ALL SELECT 
    CONCAT('anondb_extract order date before ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
WHERE
    order_date < @extractend 
UNION ALL SELECT 
    CONCAT('anondb_extract order date after ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
WHERE
    order_date >= @extractend 
UNION ALL SELECT 
    CONCAT('anondb_extract first shipped date before ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
WHERE
    first_shipped_date < @extractend 
UNION ALL SELECT 
    CONCAT('anondb_extract first shipped date after ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
WHERE
    first_shipped_date >= @extractend 
UNION ALL SELECT 
    CONCAT('anondb_extract delivered date before ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
WHERE
    delivered_date < @extractend 
UNION ALL SELECT 
    CONCAT('anondb_extract delivered date after ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract
WHERE
    delivered_date >= @extractend
;