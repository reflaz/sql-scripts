USE refrain;

SELECT 
    *
FROM
    tmp_package_level
WHERE
    order_date < '2017-01-01';

SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'DIGITAL'
    LIMIT 200000) cb 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'CROSS BORDER'
    LIMIT 200000) cb 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'DIRECT BILLING'
    LIMIT 200000) db 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'EXPRESS DIRECT BILLING'
    LIMIT 200000) edb 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'EXPRESS FBL'
    LIMIT 200000) ef 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'EXPRESS MASTER ACCOUNT'
    LIMIT 200000) ema 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'FBL'
    LIMIT 200000) fbl 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'MASTER ACCOUNT'
    LIMIT 200000) ma 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_package_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'RETAIL'
    LIMIT 200000) ret;