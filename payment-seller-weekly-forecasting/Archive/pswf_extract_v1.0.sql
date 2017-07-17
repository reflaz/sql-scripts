SET @end_period = DATE_FORMAT(IF(DAY(NOW()) > 15, DATE_ADD(NOW(), INTERVAL 1 MONTH), NOW()), '%Y-%m-01');
SET @period_1 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_2 = DATE_FORMAT(DATE_SUB(@period_1, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_3 = DATE_FORMAT(DATE_SUB(@period_2, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_4 = DATE_FORMAT(DATE_SUB(@period_3, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_5 = DATE_FORMAT(DATE_SUB(@period_4, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_6 = DATE_FORMAT(DATE_SUB(@period_5, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_7 = DATE_FORMAT(DATE_SUB(@period_6, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_8 = DATE_FORMAT(DATE_SUB(@period_7, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_9 = DATE_FORMAT(DATE_SUB(@period_8, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_10 = DATE_FORMAT(DATE_SUB(@period_9, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_11 = DATE_FORMAT(DATE_SUB(@period_10, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_12 = DATE_FORMAT(DATE_SUB(@period_11, INTERVAL 1 MONTH), '%Y-%m-01');

SELECT '12' AS 'period', @period_12 AS 'beginning_date'
UNION ALL SELECT '11' AS 'period', @period_11
UNION ALL SELECT '10' AS 'period', @period_10
UNION ALL SELECT '09' AS 'period', @period_9
UNION ALL SELECT '08' AS 'period', @period_8
UNION ALL SELECT '07' AS 'period', @period_7
UNION ALL SELECT '06' AS 'period', @period_6
UNION ALL SELECT '05' AS 'period', @period_5
UNION ALL SELECT '04' AS 'period', @period_4
UNION ALL SELECT '03' AS 'period', @period_3
UNION ALL SELECT '02' AS 'period', @period_2
UNION ALL SELECT '01' AS 'period', @period_1
UNION ALL SELECT 'end_period' AS 'period', @end_period;

SELECT 
    *
FROM
    (SELECT 
        SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_01',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_01',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, tr.value, NULL), NULL)) 'item_count_12',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, tr.value, NULL), NULL)) 'item_count_11',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, tr.value, NULL), NULL)) 'item_count_10',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, tr.value, NULL), NULL)) 'item_count_09',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, tr.value, NULL), NULL)) 'item_count_08',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, tr.value, NULL), NULL)) 'item_count_07',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, tr.value, NULL), NULL)) 'item_count_06',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, tr.value, NULL), NULL)) 'item_count_05',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, tr.value, NULL), NULL)) 'item_count_04',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, tr.value, NULL), NULL)) 'item_count_03',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, tr.value, NULL), NULL)) 'item_count_02',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, tr.value, NULL), NULL)) 'item_count_01'
    FROM
        screport.transaction tr
    WHERE
        tr.fk_transaction_type IN (3 , 13, 16)) result;