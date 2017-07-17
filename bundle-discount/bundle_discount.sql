/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Bundle Discount

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
SET @extractstart = '2017-05-01';
SET @extractend = '2017-05-05';-- This MUST be D + 1

SELECT 
    so.created_at 'order_date',
    soish.created_at 'delivered_date',
    soi.sku,
    soi.bob_id_sales_order_item,
    so.order_nr,
    sup.type 'seller_type',
    CASE
        WHEN ascsel.tax_class = 0 THEN 'local'
        WHEN ascsel.tax_class = 1 THEN 'international'
    END 'tax_class',
    sup.id_supplier,
    ascsel.short_code,
    sup.name 'seller_name',
    soi.unit_price,
    - bsoi.bundle_discount_value,
    CASE
        WHEN soi.fk_marketplace_merchant IS NULL THEN 0
        ELSE (CASE
            WHEN asc_sel.tax_class = 0 THEN (0.013 * IFNULL(bsoi.bundle_discount_value, 0))
            ELSE (0.020 * IFNULL(bsoi.bundle_discount_value, 0))
        END)
    END 'payment_fee',
    CASE
        WHEN soi.fk_marketplace_merchant IS NULL THEN 0
        ELSE (CASE
            WHEN asc_sel.tax_class = 0 THEN (0.013 * IFNULL(bsoi.bundle_discount_value, 0))
            ELSE (0.020 * IFNULL(bsoi.bundle_discount_value, 0))
        END)
    END * 0.1 'vat',
    marketplace_commission_fee
FROM
    (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) result
        LEFT JOIN
    oms_live.oms_package pck ON result.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    bob_live.sales_order_item bsoi ON soi.bob_id_sales_order_item = bsoi.id_sales_order_item
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
        LEFT JOIN
    asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
HAVING bsoi.bundle_discount_value > 0