/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Alipay SOI Details by Order Date
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: -- Change @extractstart and @extractend into specific timeframe
				  -- Run The Script
				  -- Close script without saving any changes
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @extractstart = '2017-01-16';
SET @extractend = '2017-01-17'; -- This MUST be D + 1

SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.payment_method,
    soish.created_at AS ovip_date,
    soi.paid_price,
    soi.shipping_surcharge,
    soi.shipping_amount
FROM
    (SELECT 
        id_sales_order, order_nr, payment_method
    FROM
        oms_live.ims_sales_order
    WHERE
        created_at >= DATE_SUB(@extractstart, INTERVAL 1 DAY)
            AND created_at < @extractend
    HAVING payment_method NOT IN ('CashOnDelivery' , 'NoPayment')) so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 69
GROUP BY soi.id_sales_order_item
HAVING ovip_date >= @extractstart
    AND ovip_date < @extractend