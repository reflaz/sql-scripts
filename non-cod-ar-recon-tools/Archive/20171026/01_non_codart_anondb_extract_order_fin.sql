/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss AnonDB Population Extract

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

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-06-05';
SET @extractend = '2017-06-07';-- This MUST be D + 1

SELECT 
    bob_id_sales_order_item,
    order_nr,
    payment_method,
    item_name,
    sku,
    bob_id_supplier,
    short_code,
    seller_name,
    seller_type,
    tax_class,
    unit_price,
    paid_price,
    shipping_amount,
    shipping_surcharge,
    total_paid_by_customer,
    last_status,
    order_date,
    ovip_date,
    ovip_by,
    delivery_updater,
    package_number
FROM
    (SELECT 
        soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            so.order_nr 'order_nr',
            so.payment_method 'payment_method',
            REPLACE(REPLACE(REPLACE(soi.name, '\\', ''), CHAR(10), ' '), CHAR(13), ' ') 'item_name',
            soi.sku 'sku',
            sup.id_supplier 'bob_id_supplier',
            ascsel.short_code 'short_code',
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN ascsel.tax_class = 0 THEN 'local'
                WHEN ascsel.tax_class = 1 THEN 'international'
            END 'tax_class',
            soi.unit_price 'unit_price',
            soi.paid_price 'paid_price',
            soi.shipping_amount 'shipping_amount',
            soi.shipping_surcharge 'shipping_surcharge',
            (IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_amount, 0) + IFNULL(soi.shipping_surcharge, 0)) 'total_paid_by_customer',
            sois.name 'last_status',
            so.created_at 'order_date',
            soish2.created_at 'ovip_date',
            user_ovip.username 'ovip_by',
            user.username 'delivery_updater', 
            pck.package_number 'package_number'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item)
    LEFT JOIN oms_live.ims_user user ON soish.fk_user = user.id_user
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish2 ON soi.id_sales_order_item = soish2.fk_sales_order_item
        AND soish2.fk_sales_order_item_status IN (69)
	LEFT JOIN oms_live.ims_user user_ovip ON soish2.fk_user = user_ovip.id_user
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    WHERE
        so.created_at >= DATE_SUB(@extractstart, INTERVAL 1 DAY)
            AND so.created_at < @extractend
            and so.payment_method not like 'CashOnDelivery' 
            -- and so.payment_method in ()
    GROUP BY soi.id_sales_order_item) result
HAVING ovip_date >= @extractstart
    AND ovip_date < @extractend