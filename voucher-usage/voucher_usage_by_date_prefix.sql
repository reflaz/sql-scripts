/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Voucher Usage by Date Prefix

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Format the prefix parameter by adding '%' after the prefix in the parameter brackets
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-10-01';
SET @extractend = '2017-10-31';

SELECT 
    soi.bob_id_supplier,
    ascsel.short_code,
    sup.name 'supplier_name',
    sup.type,
    CASE
        WHEN ascsel.tax_class = 0 THEN 'local'
        WHEN ascsel.tax_class = 1 THEN 'international'
    END 'tax_class',
    CASE
        WHEN soi.is_marketplace = 0 THEN 'Retail'
        WHEN soi.is_marketplace = 1 THEN 'MP'
    END 'bu',
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.created_at 'order_date',
    ovip.created_at 'ovip_date',
    verified.created_at 'finance_verified_date',
    IFNULL((SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pa.id_package
                        AND fk_package_status = 6),
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 27)) 'delivered_date',
    sois.name 'last_status',
    soi.unit_price,
    soi.paid_price,
    soi.coupon_money_value,
    soi.cart_rule_discount,
    so.coupon_code,
    sovt.name 'coupon_type',
    soi.cart_rule_display_names
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history ovip ON soi.id_sales_order_item = ovip.fk_sales_order_item
        AND ovip.fk_sales_order_item_status = 69
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.oms_package_item pai ON soi.id_sales_order_item = pai.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package pa ON pai.fk_package = pa.id_package
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
        LEFT JOIN
    asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
WHERE
    so.created_at >= @extractstart
        AND so.created_at < @extractend
        AND so.coupon_code LIKE ();
		-- please add '%' after the prefix in the parameter brackets
        -- example: if prefix is 'LAZ' then you must input 'LAZ%' in the parameter