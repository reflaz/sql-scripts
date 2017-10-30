SET @end_period = '2016-01-01';
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
        CONCAT('ID', sel.id_seller) 'seller_id',
            sel.name 'seller_name',
            sel.email 'email_address',
            sel.short_code 'seller_center_id',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_01',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_02',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_03',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_04',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_05',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_06',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_07',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_08',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_09',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_10',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_11',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 16, tr.value, 0), 0)) 'commission_12'
    FROM
        screport.seller sel
    LEFT JOIN screport.transaction tr ON sel.id_seller = tr.fk_seller
    WHERE
        sel.id_seller IN ('')
    GROUP BY sel.id_seller) result