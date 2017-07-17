/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Reimbursement Extract v2.0
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 2.0
Changes made	: - Automate date based on extract date

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'

SET @extractend = '2016-04-01';
SET @extractstart = '2016-03-01';

SELECT 
    *, length * width * height / 6000 'volumetric_weight'
FROM
    (SELECT 
        soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            scsoi.id_sales_order_item 'sc_id_sales_order_item',
            so.order_nr 'order_nr',
            so.created_at 'order_date',
            ship.created_at 'shipped_date',
            delv.created_at 'delivered_date',
            soi.shipping_surcharge 'shipping_surcharge',
            soi.unit_price 'unit_price',
            soi.paid_price 'paid_price',
            soi.coupon_money_value 'coupon_money_value',
            soi.cart_rule_discount 'cart_rule_discount',
            so.coupon_code 'coupon_code',
            sovt.name 'voucher_type',
            soi.cart_rule_display_names 'cart_rule_display_names',
            soi.sku 'sku',
            pck.id_package 'id_package',
            pd.id_package_dispatching 'id_package_dispatching',
            pd.tracking_number 'tracking_number',
            sp.id_shipment_provider 'id_shipment_provider',
            sp.shipment_provider_name 'shipment_provider',
            sfom.origin 'origin',
            IF(reg.id_customer_address_region IS NOT NULL, reg.id_customer_address_region, IF(cty.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region)) 'id_region',
            IF(reg.id_customer_address_region IS NOT NULL, reg.name, IF(cty.id_customer_address_region IS NOT NULL, cty.name, dst.name)) 'region',
            IF(reg.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region) 'id_city',
            IF(reg.id_customer_address_region IS NOT NULL, cty.name, dst.name) 'city',
            IF(reg.id_customer_address_region IS NOT NULL, dst.id_customer_address_region, NULL) 'id_district',
            IF(reg.id_customer_address_region IS NOT NULL, dst.name, NULL) 'district',
            sup.id_supplier,
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name',
            sup.type 'seller_type',
            sel.tax_class,
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) 'length',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) 'width',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) 'height',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.weight, 0), IFNULL(cc.package_weight, 0)) 'weight'
    FROM
        oms_live.ims_sales_order so
	LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.ims_sales_order_item soi ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history ship ON soi.id_sales_order_item = ship.fk_sales_order_item
        AND ship.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    LEFT JOIN oms_live.ims_sales_order_item_status_history delv ON soi.id_sales_order_item = delv.fk_sales_order_item
        AND delv.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.oms_package_item pi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL)
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country_region = sa.fk_country_region)
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND (sup.type = 'supplier' OR sel.tax_class = 'local')
            AND sfom.origin IS NOT NULL
    GROUP BY soi.id_sales_order_item) result
HAVING weight <= 7 AND volumetric_weight <= 7