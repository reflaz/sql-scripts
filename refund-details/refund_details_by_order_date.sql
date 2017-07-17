/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refund Details by Order Date
 
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
SET @extractstart = '2016-10-01';
SET @extractend = '2016-10-02';-- This MUST be D + 1

SELECT 
    soi.bob_id_sales_order_item,
    so.order_nr,
    so.created_at 'order_date',
    pck.package_number,
    pd.tracking_number,
    soi.unit_price,
    soi.paid_price,
    soi.shipping_amount,
    soi.shipping_surcharge,
    soi.coupon_money_value,
    soi.refunded_money,
    soi.refunded_shipping,
    soi.refunded_voucher,
    soi.refunded_other
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pi.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
WHERE
    soi.created_at >= DATE_SUB(@extractstart, INTERVAL 1 DAY)
        AND soi.created_at < DATE_ADD(@extractend, INTERVAL 1 DAY)
        AND soi.fk_sales_order_item_status = 56
HAVING order_date >= @extractstart
    AND order_date < @extractend