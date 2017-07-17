SET @extractstart = '2017-02-01';
SET @extractend = '2017-03-01';

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.id_sales_order_item 'sap_item_id',
            scsoi.id_sales_order_item 'sc_sales_order_item',
            so.payment_method,
            sois.name 'item_status',
            so.created_at 'order_date',
            MAX(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'verified_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 27, soish.real_action_date, NULL)) 'delivered_date',
            MAX(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date_input',
            MAX(IF(soish.fk_sales_order_item_status IN (8 , 11), soish.created_at, NULL)) 'returned_date',
            MAX(IF(soish.fk_sales_order_item_status = 78, soish.created_at, NULL)) 'replaced_date',
            MAX(IF(soish.fk_sales_order_item_status = 56, soish.created_at, NULL)) 'refunded_date',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            MAX(IF(tr.fk_transaction_type = 13, tr.value, NULL)) 'item_price_credit',
            MAX(IF(tr.fk_transaction_type = 16, tr.value, NULL)) 'commission',
            MAX(IF(tr.fk_transaction_type = 3, tr.value, NULL)) 'payment_fee',
            MAX(IF(tr.fk_transaction_type = 8, tr.value, NULL)) 'shipping_fee_credit',
            MAX(IF(tr.fk_transaction_type = 14, tr.value, NULL)) 'item_price',
            MAX(IF(tr.fk_transaction_type = 15, tr.value, NULL)) 'commission_credit',
            MAX(IF(tr.fk_transaction_type = 7, tr.value, NULL)) 'shipping_fee',
            soi.sku,
            cc.primary_category,
            dst.id_customer_address_region 'id_district',
            sp.shipment_provider_name 'shipment_provider',
            scsel.src_id 'seller_id',
            scsel.short_code 'sc_seller_id',
            scsel.name 'seller_name',
            CASE
                WHEN scsel.tax_class = 0 THEN 'local'
                WHEN scsel.tax_class = 1 THEN 'international'
            END 'tax_class'
    FROM
        (SELECT 
        *
    FROM
        oms_live.ims_sales_order_item_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_sales_order_item_status IN (56 , 78)
    GROUP BY fk_sales_order_item) soish0
    LEFT JOIN oms_live.ims_sales_order_item soi ON soish0.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (67 , 5, 27, 8, 11, 78, 56)
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN asc_live.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN asc_live.seller scsel ON scsoi.fk_seller = scsel.id_seller
    LEFT JOIN asc_live.transaction tr ON scsoi.id_sales_order_item = tr.ref
        AND tr.fk_transaction_type IN (13 , 16, 3, 8, 14)
    GROUP BY soi.id_sales_order_item
    HAVING tax_class IS NOT NULL) result;