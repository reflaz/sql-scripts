/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Taobao Collection Details

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @api_date = '20171204-20171217';
SET @cr_hkd_idr = 1722;

USE refrain_live;

SELECT 
    *
FROM
    (SELECT 
        til.order_nr,
            til.bob_id_sales_order_item,
            til.sc_id_sales_order_item,
            til.oms_id_sales_order_item,
            til.sku,
            til.primary_category,
            ct.regional_key,
            ct.category_name 'primary_category_name',
            cti.id_city,
            cti.city,
            til.id_district,
            til.package_number,
            til.bob_id_supplier,
            til.short_code,
            til.seller_name,
            til.seller_type,
            til.tax_class,
            til.order_date,
            til.finance_verified_date,
            til.first_shipped_date,
            til.delivered_date,
            til.failed_delivery_date,
            IFNULL(til.delivered_date, til.failed_delivery_date) 'dfd_date',
            WEEK(IFNULL(til.delivered_date, til.failed_delivery_date)) 'week_dfd_date',
            til.coupon_type,
            IFNULL(til.unit_price, 0) 'unit_price',
            IFNULL(til.paid_price, 0) 'paid_price',
            IFNULL(til.shipping_amount, 0) 'shipping_amount',
            IFNULL(til.shipping_surcharge, 0) 'shipping_surcharge',
            IFNULL(til.coupon_money_value, 0) 'coupon_money_value',
            IFNULL(til.paid_price / 1.1, 0) + IFNULL(til.shipping_surcharge / 1.1, 0) + IFNULL(til.shipping_amount / 1.1, 0) + IF(til.coupon_type <> 'coupon', IFNULL(til.coupon_money_value / 1.1, 0), 0) 'nmv',
            IFNULL(total_seller_charge, 0) 'seller_charge',
            COALESCE(total_delivery_cost, total_failed_delivery_cost, 0) 'delivery_cost_hkd',
            COALESCE(total_delivery_cost, total_failed_delivery_cost, 0) * @cr_hkd_idr 'delivery_cost_idr',
            IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0) + IFNULL(total_seller_charge, 0) + (COALESCE(total_delivery_cost, total_failed_delivery_cost, 0) * @cr_hkd_idr) 'subsidy'
    FROM
        (SELECT 
        package_number, short_code, fk_api_type
    FROM
        api_data
    WHERE
        api_date = @api_date
            AND fk_api_type = 30002
    GROUP BY package_number , short_code) ad
    LEFT JOIN tmp_item_level til ON ad.package_number = til.package_number
        AND ad.short_code = til.short_code
        AND ad.fk_api_type = til.fk_api_type
    LEFT JOIN map_category_tree ct ON til.primary_category = ct.id_catalog_category
    LEFT JOIN map_city_tier cti ON til.id_district = cti.id_district
    GROUP BY bob_id_sales_order_item) result;