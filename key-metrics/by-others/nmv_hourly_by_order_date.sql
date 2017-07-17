/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
NMV Hourly
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-01-01';
SET @extractend = '2017-01-11';-- This MUST be D + 1

SELECT 
    order_date,
    SUM(IF(order_hour = 0, IFNULL(nmv, 0), 0)) '00',
    SUM(IF(order_hour = 1, IFNULL(nmv, 0), 0)) '01',
    SUM(IF(order_hour = 2, IFNULL(nmv, 0), 0)) '02',
    SUM(IF(order_hour = 3, IFNULL(nmv, 0), 0)) '03',
    SUM(IF(order_hour = 4, IFNULL(nmv, 0), 0)) '04',
    SUM(IF(order_hour = 5, IFNULL(nmv, 0), 0)) '05',
    SUM(IF(order_hour = 6, IFNULL(nmv, 0), 0)) '06',
    SUM(IF(order_hour = 7, IFNULL(nmv, 0), 0)) '07',
    SUM(IF(order_hour = 8, IFNULL(nmv, 0), 0)) '08',
    SUM(IF(order_hour = 9, IFNULL(nmv, 0), 0)) '09',
    SUM(IF(order_hour = 10, IFNULL(nmv, 0), 0)) '10',
    SUM(IF(order_hour = 11, IFNULL(nmv, 0), 0)) '11',
    SUM(IF(order_hour = 12, IFNULL(nmv, 0), 0)) '12',
    SUM(IF(order_hour = 13, IFNULL(nmv, 0), 0)) '13',
    SUM(IF(order_hour = 14, IFNULL(nmv, 0), 0)) '14',
    SUM(IF(order_hour = 15, IFNULL(nmv, 0), 0)) '15',
    SUM(IF(order_hour = 16, IFNULL(nmv, 0), 0)) '16',
    SUM(IF(order_hour = 17, IFNULL(nmv, 0), 0)) '17',
    SUM(IF(order_hour = 18, IFNULL(nmv, 0), 0)) '18',
    SUM(IF(order_hour = 19, IFNULL(nmv, 0), 0)) '19',
    SUM(IF(order_hour = 20, IFNULL(nmv, 0), 0)) '20',
    SUM(IF(order_hour = 21, IFNULL(nmv, 0), 0)) '21',
    SUM(IF(order_hour = 22, IFNULL(nmv, 0), 0)) '22',
    SUM(IF(order_hour = 23, IFNULL(nmv, 0), 0)) '23',
    SUM(IFNULL(nmv, 0)) 'total'
FROM
    (SELECT 
        DATE(so.created_at) 'order_date',
            HOUR(so.created_at) 'order_hour',
            soi.bob_id_sales_order_item,
            soish.created_at 'finance_verified_date',
            IFNULL(soi.unit_price / 1.1, 0) 'unit_price',
            IFNULL(soi.paid_price / 1.1, 0) 'paid_price',
            IFNULL(soi.shipping_surcharge / 1.1, 0) 'shipping_fee',
            IFNULL(soi.shipping_amount / 1.1, 0) 'shipping_amount',
            IFNULL(soi.cart_rule_discount / 1.1, 0) 'cart_rule_discount',
            IFNULL(soi.coupon_money_value / 1.1, 0) 'coupon_money_value',
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
        AND soish.created_at < @extractend
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
    GROUP BY id_sales_order_item) result
GROUP BY order_date