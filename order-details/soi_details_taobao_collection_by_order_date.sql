/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Date
 
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
SET @extractstart = '2017-10-01';
SET @extractend = '2017-10-02';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            ascsoi.id_sales_order_item 'sc_id_sales_order_item',
            soi.id_sales_order_item 'oms_id_sales_order_item',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            sovt.name 'coupon_type',
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(sovt.name <> 'coupon', IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = ascsoi.id_sales_order_item
                        AND tr.fk_transaction_type IN (8 , 142)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = ascsoi.id_sales_order_item
                        AND tr.fk_transaction_type IN (8 , 142)), 0)) 'auto_shipping_fee',
            so.created_at 'order_date',
            verified.created_at 'verified_date',
            IF(psh.fk_package_status = 4, psh.created_at, NULL) 'shipped_date',
            IF(psh.fk_package_status = 6, psh.created_at, NULL) 'delivered_date',
            IF(psh.fk_package_status = 5, psh.created_at, NULL) 'failed_delivery_date',
            pck.package_number,
            soi.sku,
            cc.primary_category,
            cca.regional_key,
            cca.name_en 'primary_category_name',
            sup.id_supplier,
            ascsel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            ascsel.tax_class
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_status_history psh ON psh.fk_package = pck.id_package
        AND psh.fk_package_status IN (4 , 5, 6)
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_category cca ON cc.primary_category = cca.id_catalog_category
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cs.id_catalog_simple = cspu.fk_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    LEFT JOIN asc_live.sales_order_item ascsoi ON soi.id_sales_order_item = ascsoi.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soi.bob_id_supplier IN (18358 , 74322, 118514, 121939, 127131)
    GROUP BY soi.id_sales_order_item) result