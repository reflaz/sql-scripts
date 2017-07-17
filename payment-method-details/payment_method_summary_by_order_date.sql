/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Payment Method Details by Order Date
 
Prepared by		: Reffly Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: -- Change @extractstart and @extractend into specific timeframe
				  -- Run The Script
				  -- Close script without saving any changes
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @extractstart = '2017-01-01';
SET @extractend = '2017-02-01'; -- This MUST be D + 1

SELECT 
    payment_method,
    COUNT(DISTINCT (order_nr)) AS count_so,
    COUNT(id_sales_order_item) AS count_soi,
    SUM(IFNULL(paid_price, 0)) AS sum_of_paid_price,
    SUM(IFNULL(shipping_surcharge, 0)) AS sum_of_shipping_surcharge,
    SUM(IFNULL(shipping_amount, 0)) AS sum_of_shipping_amount,
    SUM(IFNULL(nmv, 0)) AS nmv
FROM
    (SELECT 
        so.order_nr,
            soi.id_sales_order_item,
            so.payment_method,
            soish.created_at AS ovip_date,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.shipping_amount,
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        (SELECT 
        id_sales_order, order_nr, payment_method, fk_voucher_type
    FROM
        oms_live.ims_sales_order
    WHERE
        created_at >= DATE_SUB(@extractstart, INTERVAL 1 DAY)
            AND created_at < @extractend) so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 69
    GROUP BY soi.id_sales_order_item
    HAVING ovip_date >= @extractstart
        AND ovip_date < @extractend) result
GROUP BY payment_method