USE scgl;

-- timeframe for before
SET @extractstart = '2016-12-01';
SET @extractend = '2017-01-01';

SELECT 
    'anondb_calculate' AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
UNION ALL SELECT 
    CONCAT('anondb_calculate order date before ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
WHERE
    order_date < @extractend 
UNION ALL SELECT 
    CONCAT('anondb_calculate order date after ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
WHERE
    order_date >= @extractend 
UNION ALL SELECT 
    CONCAT('anondb_calculate first shipped date before ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
WHERE
    first_shipped_date < @extractend 
UNION ALL SELECT 
    CONCAT('anondb_calculate first shipped date after ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
WHERE
    first_shipped_date >= @extractend 
UNION ALL SELECT 
    CONCAT('anondb_calculate delivered date before ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
WHERE
    delivered_date < @extractend 
UNION ALL SELECT 
    CONCAT('anondb_calculate delivered date after ',
            @extractend) AS 'table_name',
    MIN(order_date),
    MAX(order_date),
    MIN(first_shipped_date),
    MAX(first_shipped_date),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_calculate
WHERE
    delivered_date >= @extractend
;