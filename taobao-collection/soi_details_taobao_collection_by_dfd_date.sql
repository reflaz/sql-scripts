/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details TBC by Delivered Date
 
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
SET @extractstart = '2017-09-25';
SET @extractend = '2017-09-25';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            asoi.id_sales_order_item 'sc_id_sales_order_item',
            soi.id_sales_order_item 'oms_id_sales_order_item',
            soi.sku,
            cc.primary_category,
            cca.regional_key,
            cca.name_en 'primary_category_name',
            cty.id_customer_address_region 'id_city',
            cty.name 'city',
            dst.id_customer_address_region 'id_district',
            pck.package_number,
            sup.id_supplier,
            sel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            sel.tax_class,
            so.created_at 'order_date',
            soish.created_at 'verified_date',
            pash.created_at 'shipped_date',
            IF(result.fk_package_status = 6, result.created_at, NULL) 'delivered_date',
            IF(result.fk_package_status = 5, result.created_at, NULL) 'failed_delivery_date',
            result.created_at 'dfd_date',
            WEEK(result.created_at) 'week_dfd_date',
            sovt.name 'coupon_type',
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price',
            IFNULL(soi.shipping_amount, 0) 'shipping_amount',
            IFNULL(soi.shipping_surcharge, 0) 'shipping_surcharge',
            IFNULL(soi.coupon_money_value, 0) 'coupon_money_value',
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(sovt.name <> 'coupon', IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        (SELECT 
        fk_package, fk_package_status, MIN(created_at) 'created_at'
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status IN (5 , 6)
    GROUP BY fk_package) result
    LEFT JOIN oms_live.oms_package pck ON result.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_status_history pash ON pash.fk_package = pck.id_package
        AND pash.id_package_status_history = (SELECT 
            MIN(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = pck.id_package
                AND fk_package_status = 4)
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN bob_live.customer_address_region cty ON cty.id_customer_address_region = dst.fk_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_category cca ON cc.primary_category = cca.id_catalog_category
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.sales_order_item asoi ON soi.id_sales_order_item = asoi.src_id
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        soi.bob_id_supplier IN (18358 , 74322, 118514, 121939, 127131)
    GROUP BY soi.bob_id_sales_order_item) result