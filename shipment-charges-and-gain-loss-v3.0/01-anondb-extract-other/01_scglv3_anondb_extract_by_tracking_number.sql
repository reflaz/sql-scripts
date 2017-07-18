/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss AnonDB Population Extract

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *,
    IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END,
            0) 'chargeable_weight',
    IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END,
            0) 'chargeable_volumetric_weight',
    CASE
        WHEN tax_class = 'international' THEN 'CB'
        WHEN delivery_type = 'digital' THEN 0
        WHEN
            first_shipment_provider = 'Digital Delivery'
                OR last_shipment_provider = 'Digital Delivery'
        THEN
            0
        WHEN
            delivery_type IN ('express' , 'nextday', 'sameday')
                AND last_shipment_provider LIKE '%Go-Jek%'
        THEN
            'GO-JEK'
        WHEN is_marketplace = 0 THEN 'RETAIL'
        WHEN shipping_type = 'warehouse' THEN 'FBL'
        WHEN
            first_shipment_provider = 'Acommerce'
                AND last_shipment_provider = 'Acommerce'
        THEN
            'DIRECT BILLING'
        WHEN
            payment_method <> 'CashOnDelivery'
                AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
        THEN
            'DIRECT BILLING'
        ELSE 'MASTER ACCOUNT'
    END 'business_unit'
FROM
    (SELECT 
        soi.bob_id_sales_order_item,
            ascsoi.id_sales_order_item 'sc_sales_order_item',
            so.order_nr,
            so.payment_method,
            soi.sku,
            cc.primary_category,
            sup.id_supplier 'bob_id_supplier',
            ascsel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN ascsel.tax_class = 0 THEN 'local'
                WHEN ascsel.tax_class = 1 THEN 'international'
            END 'tax_class',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            IFNULL(tr.value, trp.value) 'marketplace_commission_fee',
            soi.coupon_money_value,
            soi.cart_rule_discount,
            so.coupon_code,
            sovt.name 'coupon_type',
            soi.cart_rule_display_names,
            sois.name 'last_status',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'first_shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'last_shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 44, soish.created_at, NULL)) 'not_delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 6, soish.created_at, NULL)) 'closed_date',
            MIN(IF(soish.fk_sales_order_item_status = 56, soish.created_at, NULL)) 'refund_completed_date',
            ppt.name 'pickup_provider_type',
            result.package_number,
            result.id_package_dispatching,
            ins.tenor,
            SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) AS 'bank',
            result.first_tracking_number,
            result.first_shipment_provider,
            result.last_tracking_number,
            result.last_shipment_provider,
            CASE
                WHEN ascsel.tax_class = 1 THEN 'Cross Border'
                WHEN
                    sup.type = 'supplier'
                        OR st.name = 'warehouse'
                        OR soi.fk_mwh_warehouse <> 1
                        OR sfom.origin IS NULL
                THEN
                    CASE
                        WHEN soi.fk_mwh_warehouse = 1 THEN 'DKI Jakarta'
                        WHEN soi.fk_mwh_warehouse = 2 THEN 'East Java'
                        WHEN soi.fk_mwh_warehouse = 3 THEN 'North Sumatera'
                        WHEN soi.fk_mwh_warehouse = 4 THEN 'DKI Jakarta'
                    END
                ELSE sfom.origin
            END 'origin',
            soa.city,
            dst.id_customer_address_region 'id_district',
            cc.package_length 'config_length',
            cc.package_width 'config_width',
            cc.package_height 'config_height',
            cc.package_weight 'config_weight',
            cspu.length 'simple_length',
            cspu.width 'simple_width',
            cspu.height 'simple_height',
            cspu.weight 'simple_weight',
            st.name 'shipping_type',
            soi.delivery_type,
            soi.is_marketplace,
            so.bob_id_customer,
            soi.is_express_shipping,
            IFNULL(IFNULL(poi.cost, soi.cost), 0) 'retail_cogs',
            (SELECT 
                    SUM(IFNULL(ssoi.paid_price, 0) + IFNULL(ssoi.shipping_surcharge, 0) + IFNULL(ssoi.shipping_amount, 0))
                FROM
                    oms_live.ims_sales_order_item ssoi
                WHERE
                    ssoi.fk_sales_order = soi.fk_sales_order) 'order_value',
            CASE
                WHEN soi.is_marketplace = 0 THEN NULL
                ELSE (SELECT 
                        SUM(IFNULL(value, 0))
                    FROM
                        asc_live.transaction
                    WHERE
                        ref = ascsoi.id_sales_order_item
                            AND fk_transaction_type = 7)
            END 'shipping_fee',
            CASE
                WHEN soi.is_marketplace = 0 THEN NULL
                ELSE (SELECT 
                        SUM(IFNULL(value, 0))
                    FROM
                        asc_live.transaction
                    WHERE
                        ref = ascsoi.id_sales_order_item
                            AND fk_transaction_type = 8)
            END 'shipping_fee_credit',
            CASE
                WHEN soi.is_marketplace = 0 THEN NULL
                ELSE (SELECT 
                        SUM(IFNULL(value, 0))
                    FROM
                        asc_live.transaction
                    WHERE
                        ref = ascsoi.id_sales_order_item
                            AND fk_transaction_type IN (36 , 37)
                            AND (description LIKE '%reimburse%'
                            OR description LIKE '%flat fee%'))
            END 'seller_cr_db_item'
    FROM
        (SELECT 
        pck.id_package,
            pck.package_number,
            pd.id_package_dispatching,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider'
    FROM
        (SELECT 
        *
    FROM
        oms_live.oms_package_dispatching_history
    WHERE
        tracking_number IN ()) pdh
    LEFT JOIN oms_live.oms_package pck ON pdh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    HAVING first_shipment_provider IS NOT NULL) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.wms_inventory inv ON pi.fk_inventory = inv.id_inventory
    LEFT JOIN oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27, 44, 6, 56)
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_supplier osup ON soi.bob_id_supplier = osup.bob_id_supplier
    LEFT JOIN oms_live.oms_pickup_provider_type ppt ON osup.fk_pickup_provider_type = ppt.id_pickup_provider_type
    LEFT JOIN oms_live.oms_shipping_type st ON soi.fk_shipping_type = st.id_shipping_type
    LEFT JOIN bob_live.sales_order_item bsoi ON soi.bob_id_sales_order_item = bsoi.id_sales_order_item
    LEFT JOIN bob_live.sales_order_instalment ins ON so.order_nr = ins.order_nr
    LEFT JOIN bob_live.payment_dokuinstallment_response pdr ON bsoi.fk_sales_order = pdr.fk_sales_order
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cs.id_catalog_simple = cspu.fk_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL
                AND address_type = 'warehouse')
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country_region = sa.fk_country_region
                AND origin <> 'Cross Border'
                AND is_live = 1)
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    LEFT JOIN asc_live.sales_order_item ascsoi ON soi.id_sales_order_item = ascsoi.src_id
    LEFT JOIN asc_live.transaction tr ON ascsoi.id_sales_order_item = tr.ref
        AND tr.fk_transaction_type = 16
    LEFT JOIN asc_live.transaction_pending trp ON ascsoi.id_sales_order_item = trp.ref
        AND trp.fk_transaction_type = 16
    GROUP BY soi.id_sales_order_item) result