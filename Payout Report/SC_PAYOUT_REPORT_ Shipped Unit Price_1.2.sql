/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SC Payout Report
 
Prepared by		: R Maliangkay
Modified by		: Muhammad Adrian, RM
Version			: 1.2
Changes made	: 1.1 Added Columns - Count of Shipped Orders and Sum of Shipped Orders Value 
				  1.2 Include Commission and Payment Fee in calculating Sum of Shipped Orders Value
Instructions	: Change @curr_start and @curr_end for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @curr_start = '2016-05-16';
SET @curr_end = '2016-05-23';
SET @last_start = DATE_ADD(@curr_start, INTERVAL (-(DAYOFWEEK(@curr_start) - 2) - 7) DAY);
SET @last_end = DATE_ADD(@last_start, INTERVAL 7 DAY);

SELECT 
    sel.id_seller,
    sel.short_code 'seller_id',
    sel.name 'supplier',
    SUM(IFNULL(tr.value, 0)) 'payout_curr_timeframe',
    CONCAT(STR_TO_DATE(@curr_start, '%Y-%m-%d'),
            ' - ',
            STR_TO_DATE(DATE_ADD(@curr_end, INTERVAL - 1 DAY),
                    '%Y-%m-%d')) 'curr_timeframe',
    IF(IFNULL(ts.payout, 0) <= 0,
        SUM(IFNULL(tr.value, 0)) - (IFNULL(ts.guarantee_deposit, 0) - IFNULL(ts.closing_balance, 0)),
        SUM(IFNULL(tr.value, 0))) 'payment_providers',
    CONCAT(STR_TO_DATE(@last_start, '%Y-%m-%d'),
            ' - ',
            STR_TO_DATE(DATE_ADD(@last_end, INTERVAL - 1 DAY),
                    '%Y-%m-%d')) 'prev_timeframe',
    ts.payout 'payout_prev_timeframe',
    IFNULL(si.count_of_orders, 0) 'shipped_orders',
    IFNULL(si.sum_of_shipped, 0) 'shipped_value'
FROM
    screport.transaction tr
        LEFT JOIN
    (SELECT 
        *
    FROM
        screport.transaction_statement ts
    WHERE
        ts.start_date >= STR_TO_DATE(@last_start, '%Y-%m-%d')
            AND ts.end_date < STR_TO_DATE(@last_end, '%Y-%m-%d')
    GROUP BY ts.fk_seller) ts ON tr.fk_seller = ts.fk_seller
        LEFT JOIN
    screport.seller sel ON tr.fk_seller = sel.id_seller
        LEFT JOIN
    (SELECT 
        oms_live.ims_sales_order_item.bob_id_supplier,
            COUNT(DISTINCT oms_live.ims_sales_order.order_nr) 'count_of_orders',
            SUM(oms_live.ims_sales_order_item.unit_price) + SUM(IF(pay.fk_transaction_type = 3, pay.value, 0)) + SUM(IF(com.fk_transaction_type = 16, com.value, 0)) 'sum_of_shipped'
    FROM
        oms_live.ims_sales_order_item
    JOIN oms_live.ims_sales_order ON oms_live.ims_sales_order_item.fk_sales_order = oms_live.ims_sales_order.id_sales_order
    LEFT JOIN screport.sales_order_item ON oms_live.ims_sales_order_item.id_sales_order_item = screport.sales_order_item.src_id
    LEFT JOIN screport.transaction com ON screport.sales_order_item.id_sales_order_item = com.ref
		AND com.fk_transaction_type = 15
	LEFT JOIN screport.transaction pay ON screport.sales_order_item.id_sales_order_item = pay.ref
		AND pay.fk_transaction_type = 3
    WHERE
        oms_live.ims_sales_order_item.fk_sales_order_item_status = 5
    GROUP BY oms_live.ims_sales_order_item.bob_id_supplier) si ON sel.src_id = si.bob_id_supplier
WHERE
    tr.created_at >= STR_TO_DATE(@curr_start, '%Y-%m-%d')
        AND tr.created_at < STR_TO_DATE(@curr_end, '%Y-%m-%d')
GROUP BY sel.id_seller