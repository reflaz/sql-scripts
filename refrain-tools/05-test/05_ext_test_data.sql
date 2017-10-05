USE refrain;

SELECT 
    *
FROM
    tmp_item_level
WHERE
    order_date < '2017-01-01';

SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'CROSS BORDER'
    LIMIT 100000) cb 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'DIRECT BILLING'
    LIMIT 100000) db 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'EXPRESS DIRECT BILLING'
    LIMIT 100000) edb 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'EXPRESS FBL'
    LIMIT 100000) ef 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'EXPRESS MASTER ACCOUNT'
    LIMIT 100000) ema 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'FBL'
    LIMIT 100000) fbl 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'MASTER ACCOUNT'
    LIMIT 100000) ma 
UNION ALL SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        tmp_item_level
    WHERE
        order_date >= '2017-01-01'
            AND shipment_scheme = 'RETAIL'
    LIMIT 100000) ret;