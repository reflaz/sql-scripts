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
SET @extractstart = '2017-10-20';
SET @extractend = '2017-10-31';-- This MUST be D + 1

SELECT 
    id_city,
    city,
    threshold_order,
    SUM(city.unit_price) 'total_unit_price',
    SUM(city.paid_price) 'total_paid_price',
    SUM(city.nmv) 'nmv',
    COUNT(DISTINCT city.order_nr) 'total_so',
    COUNT(DISTINCT city.package_number) 'total_pck',
    SUM(city.qty) 'total_soi',
    SUM(city.unit_price) / COUNT(DISTINCT city.order_nr) 'aov',
    SUM(city.shipping_surcharge) 'total_shipping_surcharge',
    SUM(city.shipping_amount) 'total_shipping_amount'
FROM
    (SELECT 
        fin.*,
            CASE
                WHEN unit_price < 150000 THEN CONCAT('< ', 150000)
                ELSE CONCAT('>= ', 150000)
            END 'threshold_order'
    FROM
        (SELECT 
        id_city,
            city,
            order_nr,
            package_number,
            bob_id_supplier,
            COUNT(DISTINCT bob_id_sales_order_item) 'qty',
            SUM(unit_price) 'unit_price',
            SUM(paid_price) 'paid_price',
            SUM(shipping_surcharge) 'shipping_surcharge',
            SUM(shipping_amount) 'shipping_amount',
            SUM(nmv) 'nmv'
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            ascsoi.id_sales_order_item 'sc_id_sales_order_item',
            soi.id_sales_order_item 'oms_id_sales_order_item',
            cty.id_customer_address_region 'id_city',
            cty.name 'city',
            pck.package_number,
            soi.bob_id_supplier,
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price',
            IFNULL(soi.shipping_amount, 0) 'shipping_amount',
            IFNULL(soi.shipping_surcharge, 0) 'shipping_surcharge',
            IFNULL(soi.coupon_money_value, 0) 'coupon_money_value',
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(sovt.name <> 'coupon', IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN bob_live.customer_address_region cty ON cty.id_customer_address_region = dst.fk_customer_address_region
    LEFT JOIN asc_live.sales_order_item ascsoi ON soi.id_sales_order_item = ascsoi.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soi.bob_id_supplier IN (18358 , 74322, 118514, 121939, 127131)
    GROUP BY soi.id_sales_order_item) result
    GROUP BY order_nr, bob_id_supplier) fin) city
GROUP BY id_city, threshold_order