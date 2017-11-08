/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Count of Items Check

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain_live;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2000-01-01';
SET @extractend = '2100-01-01';-- This MUST be D + 1

CREATE TEMPORARY TABLE period_data_check (
   `period` DATETIME NOT NULL,
   UNIQUE KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_data_check()
BEGIN
	SET @start_loop_data_check = @extractstart;
	WHILE @start_loop_data_check < @extractend DO
		INSERT INTO period_data_check VALUES (@start_loop_data_check);
        SET @start_loop_data_check = DATE_ADD(@start_loop_data_check, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_data_check;

SELECT 
    *
FROM
    (SELECT 
        pdc.period,
            SUM(IF(pdc.period = fsoi.ordered, fsoi.item, 0)) 'ordered_item',
            SUM(IF(pdc.period = fsoi.finver, fsoi.item, 0)) 'finver_item',
            SUM(IF(pdc.period = fsoi.shipped, fsoi.item, 0)) 'shipped_item',
            SUM(IF(pdc.period = fsoi.delivered, fsoi.item, 0)) 'delivered_item',
            SUM(IF(pdc.period = fsoi.failed, fsoi.item, 0)) 'failed_item'
    FROM
        (SELECT 
        COUNT(bob_id_sales_order_item) 'item',
            DATE(order_date) 'ordered',
            DATE(finance_verified_date) 'finver',
            DATE(first_shipped_date) 'shipped',
            DATE(delivered_date) 'delivered',
            DATE(failed_delivery_date) 'failed'
    FROM
        tmp_item_level pdc
    GROUP BY finver , ordered , shipped , delivered , failed) fsoi
    JOIN period_data_check pdc ON (pdc.period = fsoi.ordered
        OR pdc.period = fsoi.shipped
        OR pdc.period = fsoi.delivered
        OR pdc.period = fsoi.failed)
    GROUP BY pdc.period) result;

DROP PROCEDURE load_date_data_check;

DROP TEMPORARY TABLE period_data_check;