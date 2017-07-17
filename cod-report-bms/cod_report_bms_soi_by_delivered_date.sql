/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
COD Report BMS

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
SET @extractstart = '2016-11-01';
SET @extractend = '2016-11-02';-- This must be D+1

SELECT 
    *
FROM
    (SELECT 
        'ID' AS 'Country',
            'Billing' AS 'ExtractType',
            soi.created_at 'SOI_created_at',
            so.payment_method 'payment_method',
            soi.is_marketplace 'marketplace',
            soish.created_at 'posting_date',
            soish.created_at 'doc_date',
            so.order_nr 'order_nr',
            soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price',
            IFNULL(soi.shipping_amount, 0) 'shipping_amount',
            IFNULL(soi.shipping_surcharge, 0) 'shipping_surcharge',
            IF(so.fk_voucher_type IN (1 , 2), soi.coupon_money_value, 0) 'Store_Credit',
            IF(so.fk_voucher_type = 3, soi.coupon_money_value, 0) 'Marketing_Voucher',
            IFNULL(soi.cart_rule_discount, 0) 'cart_rule_discount',
            IFNULL(soib.discount_amount, 0) 'bundle_discount_amount',
            prod.erp_reference 'article',
            so.bob_id_customer 'bob_id_customer',
            pd.tracking_number 'tracking_number',
            pck.package_number 'package_number',
            sp.shipment_provider_name 'ShippingProvider',
            IFNULL(soi.tax_percent, 0) 'tax_percent',
            IFNULL(soi.tax_amount, 0) 'tax_amount',
            cc.bob_regional_key 'bob_regional_key',
            CONCAT('ID', sup.id_supplier) 'supplier_code',
            '' AS 'receiving_bank',
            soi.loyalty_point_discount_on_item 'loyalty_point_discount_on_item',
            IF(so.gst_free_shipping_address = 0, NULL, so.gst_free_shipping_address) 'is_gst_free',
            '' AS 'id_sales_order_item_status_history',
            so.coupon_code 'coupon_code',
            soish.created_at 'delivery_update_date',
            usr.username 'delivery_creator',
            sois.name 'last_status'
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_bundle soib ON soi.id_sales_order_item = soib.fk_sales_order_item
    LEFT JOIN oms_live.ims_product prod ON soi.fk_product = prod.id_product
    LEFT JOIN oms_live.ims_catalog_category cc ON prod.fk_catalog_category = cc.id_catalog_category
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
	LEFT JOIN oms_live.ims_user usr ON soish.fk_user = usr.id_user
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    GROUP BY id_sales_order_item
    HAVING payment_method = 'CashOnDelivery'
        AND posting_date IS NOT NULL) result