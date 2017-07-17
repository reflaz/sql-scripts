-- 24 Nov 16 to 4 Dec 16. 

SELECT 
    *
FROM
    (SELECT 
        payment_method,
            COUNT(IF(created_day = 24, id_sales_order, NULL)) '24',
            COUNT(IF(created_day = 25, id_sales_order, NULL)) '25',
            COUNT(IF(created_day = 26, id_sales_order, NULL)) '26',
            COUNT(IF(created_day = 27, id_sales_order, NULL)) '27',
            COUNT(IF(created_day = 28, id_sales_order, NULL)) '28',
            COUNT(IF(created_day = 29, id_sales_order, NULL)) '29',
            COUNT(IF(created_day = 30, id_sales_order, NULL)) '30',
            COUNT(IF(created_day = 01, id_sales_order, NULL)) '01',
            COUNT(IF(created_day = 02, id_sales_order, NULL)) '02',
            COUNT(IF(created_day = 03, id_sales_order, NULL)) '03',
            COUNT(IF(created_day = 04, id_sales_order, NULL)) '04'
    FROM
        (SELECT 
        id_sales_order,
            payment_method,
            created_at,
            DAY(created_at) 'created_day'
    FROM
        oms_live.ims_sales_order
    WHERE
        created_at >= '2016-11-24'
            AND created_at < '2016-12-05') result
    GROUP BY payment_method) result