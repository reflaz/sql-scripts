/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Voucher Seller Usage by Order Date

Prepared by		: Ryan Disastra
Modified by		: RD
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
SET @extractstart = '2017-11-01';
SET @extractend = '2017-12-01';-- This MUST be D + 1

SELECT 
    ascsel.id_seller 'asc_id_seller',
    sup.id_supplier 'bob_id_supplier',
    ascsel.short_code,
    sup.name 'seller_name',
    sup.type 'seller_type',
    CASE
        WHEN
            soi.is_marketplace = 1
                AND sa.fk_country = 101
        THEN
            'local'
        WHEN ascsel.tax_class = 0 THEN 'local'
        WHEN ascsel.tax_class = 1 THEN 'international'
    END 'tax_class',
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.created_at 'order_date',
    IFNULL((SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 27),
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 6)) 'delivered_date',
    sois.name 'last_status',
    soi.unit_price,
    soi.paid_price,
    soi.coupon_money_value,
    so.coupon_code,
    sovt.name 'coupon_type',
    socr.cart_rule_name,
    socr.cart_rule_discount
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        JOIN
    oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
        LEFT JOIN
    oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
        LEFT JOIN
    oms_live.ims_sales_order_cart_rule socr ON so.id_sales_order = socr.fk_sales_order
        LEFT JOIN
    oms_live.oms_package_item pi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pi.fk_package = pck.id_package
        LEFT JOIN
    bob_live.supplier sup ON sup.id_supplier = soi.bob_id_supplier
        LEFT JOIN
    bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL
                AND address_type = 'warehouse')
        LEFT JOIN
    order_api.sales_order_item bsoi ON soi.bob_id_sales_order_item = bsoi.id_sales_order_item
        LEFT JOIN
    order_api.sales_order bso ON bso.id_sales_order = bsoi.fk_sales_order
        LEFT JOIN
    bob_live.sales_rule_apply sra ON bso.id_sales_order = sra.fk_sales_order
        LEFT JOIN
    bob_live.sales_rule sr ON sra.fk_sales_rule = sr.id_sales_rule
        LEFT JOIN
    bob_live.sales_rule_set srs ON sr.fk_sales_rule_set = srs.id_sales_rule_set
        LEFT JOIN
    asc_live.seller ascsel ON ascsel.src_id = sup.id_supplier
WHERE
    so.created_at > @extractstart
        AND so.created_at <= @extractend
        AND so.coupon_code IS NOT NULL
        AND srs.promotion_level = 'shop'
        AND ascsel.id_seller IN ()