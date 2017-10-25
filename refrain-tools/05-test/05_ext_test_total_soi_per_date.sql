SET @extractstart = '2016-01-01';
SET @extractend = '2018-01-01';-- This MUST be D + 1

USE refrain;

CREATE TEMPORARY TABLE period_bu (
   `period` DATETIME NOT NULL,
   UNIQUE KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_bu()
BEGIN
	SET @start_loop_bu = @extractstart;
	WHILE @start_loop_bu < @extractend DO
		INSERT INTO period_bu VALUES (@start_loop_bu);
        SET @start_loop_bu = DATE_ADD(@start_loop_bu, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_bu;

SELECT 
    pd.period,
    SUM(IF(order_date = period, 1, 0)) 'order_date',
    SUM(IF(finance_verified_date = period, 1, 0)) 'finance_verified_date',
    SUM(IF(first_shipped_date = period, 1, 0)) 'first_shipped_date',
    SUM(IF(delivered_date = period, 1, 0)) 'delivered_date',
    SUM(IF(failed_delivery_date = period, 1, 0)) 'failed_delivery_date'
FROM
    (SELECT 
        bob_id_sales_order_item,
            DATE(order_date) 'order_date',
            DATE(finance_verified_date) 'finance_verified_date',
            DATE(first_shipped_date) 'first_shipped_date',
            DATE(delivered_date) 'delivered_date',
            DATE(failed_delivery_date) 'failed_delivery_date'
    FROM
        tmp_item_level) fsoi
        LEFT JOIN
    period_bu pd ON (pd.period = fsoi.order_date
        OR pd.period = fsoi.finance_verified_date
        OR pd.period = fsoi.first_shipped_date
        OR pd.period = fsoi.delivered_date
        OR pd.period = fsoi.failed_delivery_date)
GROUP BY pd.period;

SELECT 
    pd.period,
    SUM(IF(order_date = period, 1, 0)) 'order_date',
    SUM(IF(finance_verified_date = period, 1, 0)) 'finance_verified_date',
    SUM(IF(first_shipped_date = period, 1, 0)) 'first_shipped_date',
    SUM(IF(delivered_date = period, 1, 0)) 'delivered_date',
    SUM(IF(failed_delivery_date = period, 1, 0)) 'failed_delivery_date'
FROM
    (SELECT 
        bob_id_sales_order_item,
            DATE(order_date) 'order_date',
            DATE(finance_verified_date) 'finance_verified_date',
            DATE(first_shipped_date) 'first_shipped_date',
            DATE(delivered_date) 'delivered_date',
            DATE(failed_delivery_date) 'failed_delivery_date'
    FROM
        fms_sales_order_item) fsoi
        LEFT JOIN
    period_bu pd ON (pd.period = fsoi.order_date
        OR pd.period = fsoi.finance_verified_date
        OR pd.period = fsoi.first_shipped_date
        OR pd.period = fsoi.delivered_date
        OR pd.period = fsoi.failed_delivery_date)
GROUP BY pd.period;

DROP PROCEDURE load_date_bu;

DROP TEMPORARY TABLE period_bu;