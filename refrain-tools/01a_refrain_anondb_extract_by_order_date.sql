/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools Population Extract by Order Date

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

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-05-01';
SET @extractend = '2016-05-02';-- This MUST be D + 1

SELECT 
    result.*,
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (15 , 16)
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (15 , 16)),
            0)) * - 1 'commission',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (65 , 66, 123)
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (65 , 66, 123)),
            0)) * - 1 'commission_adjustment',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (3 , 4)
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (3 , 4)),
            0)) * - 1 'payment_fee',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (67 , 84)
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (67 , 84)),
            0)) * - 1 'payment_fee_adjustment',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (8 , 142)
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (8 , 142)),
            0)) * - 1 'auto_shipping_fee',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (7 , 143)
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (7 , 143)),
            0)) * - 1 'manual_shipping_fee_lzd',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type = 21
                        AND ta.id_transaction IS NULL),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type = 21),
            0)) * - 1 'manual_shipping_fee_3p',
    (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                        LEFT JOIN
                    asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (19 , 20,
                        36,
                        37,
                        64,
                        104,
                        138,
                        140,
                        141,
                        144,
                        145)
                        AND ta.id_transaction IS NULL
                        AND (tr.description LIKE '%shipping%'
                        OR tr.description LIKE '%flat fee%')),
            0) + IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction_archive tr
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (19 , 20,
                        36,
                        37,
                        64,
                        104,
                        138,
                        140,
                        141,
                        144,
                        145)
                        AND (tr.description LIKE '%shipping%'
                        OR tr.description LIKE '%flat fee%')),
            0)) * - 1 'shipping_fee_adjustment'
FROM
    (SELECT 
        soi.bob_id_sales_order_item,
            COALESCE((SELECT 
                    id_sales_order_item
                FROM
                    asc_live.sales_order_item
                WHERE
                    src_id = soi.id_sales_order_item), (SELECT 
                    id_sales_order_item
                FROM
                    asc_live.sales_order_item_archive
                WHERE
                    src_id = soi.id_sales_order_item)) 'sc_id_sales_order_item',
            soi.id_sales_order_item 'oms_id_sales_order_item',
            so.order_nr,
            so.payment_method,
            ins.tenor,
            'bank',
            soi.sku,
            cc.primary_category,
            soi.bob_id_supplier,
            ascsel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN
                    is_marketplace = 1
                        AND sa.fk_country = 101
                THEN
                    'local'
                WHEN ascsel.tax_class = 0 THEN 'local'
                WHEN ascsel.tax_class = 1 THEN 'international'
            END 'tax_class',
            soi.is_marketplace,
            (SELECT 
                    SUM(IFNULL(ssoi.unit_price, 0))
                FROM
                    oms_live.ims_sales_order_item ssoi
                WHERE
                    ssoi.fk_sales_order = soi.fk_sales_order) 'order_value',
            (SELECT 
                    SUM(IFNULL(ssoi.paid_price, 0) + IFNULL(ssoi.shipping_surcharge, 0) + IFNULL(ssoi.shipping_amount, 0))
                FROM
                    oms_live.ims_sales_order_item ssoi
                WHERE
                    ssoi.fk_sales_order = soi.fk_sales_order) 'payment_value',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            IFNULL(IFNULL(poi.cost, soi.cost), 0) 'retail_cogs',
            sovt.name 'coupon_type',
            sois.name 'last_status',
            so.created_at 'order_date',
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 67) 'finance_verified_date',
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 4) 'first_shipped_date',
            (SELECT 
                    MAX(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 4) 'last_shipped_date',
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 6) 'delivered_date',
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 5) 'failed_delivery_date',
            CASE
                WHEN
                    sup.type = 'supplier'
                        OR (ascsel.tax_class = 0
                        AND st.name = 'warehouse')
                        OR (ascsel.tax_class = 0
                        AND sfom.origin IS NULL)
                THEN
                    CASE
                        WHEN soi.fk_mwh_warehouse = 2 THEN 'East Java'
                        WHEN soi.fk_mwh_warehouse = 3 THEN 'North Sumatera'
                        ELSE 'DKI Jakarta'
                    END
                WHEN sfom.origin IS NOT NULL THEN sfom.origin
                ELSE 'Cross Border'
            END 'origin',
            dst.id_customer_address_region 'id_district',
            so.bob_id_customer,
            ppt.name 'pickup_provider_type',
            pd.id_package_dispatching,
            pck.package_number,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
            cc.package_length 'config_length',
            cc.package_width 'config_width',
            cc.package_height 'config_height',
            cc.package_weight 'config_weight',
            cspu.length 'simple_length',
            cspu.width 'simple_width',
            cspu.height 'simple_height',
            cspu.weight 'simple_weight',
            st.name 'shipping_type',
            soi.delivery_type
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    JOIN oms_live.ims_sales_order_item_status_history ovip ON soi.id_sales_order_item = ovip.fk_sales_order_item
        AND ovip.fk_sales_order_item_status = 69
    LEFT JOIN oms_live.ims_supplier osup ON soi.bob_id_supplier = osup.bob_id_supplier
    LEFT JOIN oms_live.oms_pickup_provider_type ppt ON osup.fk_pickup_provider_type = ppt.id_pickup_provider_type
    LEFT JOIN oms_live.oms_shipping_type st ON soi.fk_shipping_type = st.id_shipping_type
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package_dispatching = pd.id_package_dispatching
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.wms_inventory inv ON pi.fk_inventory = inv.id_inventory
    LEFT JOIN oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN bob_live.sales_order_instalment ins ON so.order_nr = ins.order_nr
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
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country = sfom.fk_country
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country = sa.fk_country
                AND IFNULL(fk_country_region, sa.fk_country_region) = sa.fk_country_region
                AND is_live = 1)
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
    GROUP BY soi.bob_id_sales_order_item) result