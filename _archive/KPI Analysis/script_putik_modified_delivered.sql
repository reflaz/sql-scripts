SET @extractstart = '2016-10-01';
SET @extractend = '2016-10-02';

SELECT 
    *,
    CASE
        WHEN payment_method = 'Cybersource' THEN '1.85% from customer'
        WHEN payment_method = 'Mandiri_Virtual_Payment' THEN 'IDR 3000 per order'
        WHEN payment_method = 'BCA_Virtual_Account' THEN 'IDR 1000 per order'
        WHEN payment_method = 'Hellopay' THEN '2.25% from customer'
        WHEN payment_method = 'MandiriClickpay' THEN 'IDR 3000 per order'
        WHEN
            payment_method = 'BCA_KlikPay'
                AND payType = 1
        THEN
            'IDR 3500 per order'
        WHEN
            payment_method = 'BCA_KlikPay'
                AND payType = 2
        THEN
            'IDR 1500 per order + 1.5% from customer'
        WHEN
            payment_method = 'CashOnDelivery'
                AND shipment_provider LIKE '%LEX%'
        THEN
            '1.5% from customer'
        WHEN payment_method = 'CashOnDelivery' THEN '1% from customer'
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%Mandiri%'
                AND tenor = 3
        THEN
            'IDR 1500 per order + 2.5% from customer'
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%Mandiri%'
                AND tenor = 6
        THEN
            'IDR 1500 per order + 4% from customer'
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%Mandiri%'
                AND tenor = 12
        THEN
            'IDR 1500 per order + 6% from customer'
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%BNI%'
                AND tenor = 3
        THEN
            'IDR 1500 per order + 3% from customer'
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%BNI%'
                AND tenor = 6
        THEN
            'IDR 1500 per order + 4% from customer'
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%BNI%'
                AND tenor = 12
        THEN
            'IDR 1500 per order + 6% from customer'
        WHEN payment_method = 'DOKUInstallment' THEN '1.9% from customer'
        WHEN payment_method = 'BCA_Bank_Transfer' THEN 'IDR 3050 per order'
        WHEN payment_method = 'KlikBCA_Payment' THEN 'IDR 3500 per order'
        WHEN payment_method = 'BNI_Virtual_Account' THEN 'IDR 2200 per order'
    END 'payment_cost_logic',
    CASE
        WHEN payment_method = 'Cybersource' THEN 0.0185 * from_customer
        WHEN payment_method = 'Mandiri_Virtual_Payment' THEN 3000
        WHEN payment_method = 'BCA_Virtual_Account' THEN 1000
        WHEN payment_method = 'Hellopay' THEN 0.0225 * from_customer
        WHEN payment_method = 'MandiriClickpay' THEN 3000
        WHEN
            payment_method = 'BCA_KlikPay'
                AND payType = 1
        THEN
            3500
        WHEN
            payment_method = 'BCA_KlikPay'
                AND payType = 2
        THEN
            1500 + (0.015 * from_customer)
        WHEN
            payment_method = 'CashOnDelivery'
                AND shipment_provider LIKE '%LEX%'
        THEN
            0.015 * from_customer
        WHEN payment_method = 'CashOnDelivery' THEN 0.01 * from_customer
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%Mandiri%'
                AND tenor = 3
        THEN
            1500 + (0.025 * from_customer)
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%Mandiri%'
                AND tenor = 6
        THEN
            1500 + (0.04 * from_customer)
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%Mandiri%'
                AND tenor = 12
        THEN
            1500 + (0.06 * from_customer)
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%BNI%'
                AND tenor = 3
        THEN
            1500 + (0.03 * from_customer)
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%BNI%'
                AND tenor = 6
        THEN
            1500 + (0.04 * from_customer)
        WHEN
            payment_method = 'DOKUInstallment'
                AND bank LIKE '%BNI%'
                AND tenor = 12
        THEN
            1500 + (0.06 * from_customer)
        WHEN payment_method = 'DOKUInstallment' THEN 0.019 * from_customer
        WHEN payment_method = 'BCA_Bank_Transfer' THEN 3050
        WHEN payment_method = 'KlikBCA_Payment' THEN 3500
        WHEN payment_method = 'BNI_Virtual_Account' THEN 2200
    END / total_order_soi 'payment_cost'
FROM
    (SELECT 
        isoi.bob_id_sales_order_item,
            isoi.sku,
            CASE
                WHEN isoi.fk_marketplace_merchant IS NULL THEN 'retail'
                ELSE 'mp'
            END AS bu,
            CASE
                WHEN spr.shipment_provider_name LIKE '%FBL%' THEN 'FBL'
                ELSE 'Non FBL'
            END AS fbl,
            IFNULL(scseller.tax_class, 'local') AS tax_class,
            CASE
                WHEN spr.shipment_provider_name LIKE '%FBL%' THEN 'MA'
                WHEN spr.shipment_provider_name LIKE '%MP%' THEN 'MA'
                WHEN spr.shipment_provider_name LIKE '%LGS%' THEN 'MA'
                WHEN spr.shipment_provider_name LIKE '%LWE%' THEN 'MA'
                ELSE 'DB'
            END AS account,
            IFNULL(scseller.src_id, 0) AS bobidseller,
            isoi.unit_price / 1.1 AS unit_price,
            isoi.paid_price / 1.1 AS paid_price,
            IFNULL(isoi.shipping_surcharge / 1.1, 0) AS shipping_fee,
            IFNULL(isoi.shipping_amount / 1.1, 0) AS shipping_amount,
            (isoi.paid_price + IFNULL(isoi.shipping_surcharge, 0) + IFNULL(isoi.shipping_amount, 0)) AS from_customer,
            (isoi.paid_price + IFNULL(isoi.shipping_surcharge, 0) + IFNULL(isoi.shipping_amount, 0) + IF(iso.fk_voucher_type <> 3, IFNULL(isoi.coupon_money_value, 0), 0)) / 1.1 AS NMV,
            isoi.marketplace_commission_fee AS mpcommission,
            CASE
                WHEN isoi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN scseller.tax_class = 'local' THEN (0.013 * isoi.unit_price / 1.1)
                    ELSE (0.020 * isoi.unit_price / 1.1)
                END)
            END AS payment_fee,
            iso.coupon_code,
            CASE
                WHEN iso.fk_voucher_type = 3 THEN 'coupon'
                ELSE 'credit'
            END AS coupon_type,
            isoi.coupon_money_value / 1.1 AS coupon,
            isoi.cart_rule_display_names,
            isoi.cart_rule_discount / 1.1 AS cart_rule,
            iso.order_nr,
            p.package_number,
            DATE(iso.created_at) AS order_date,
            CONCAT(YEAR(iso.created_at), '-', MONTH(iso.created_at)) AS order_month,
            iso.payment_method,
            isois.name AS item_status,
            spr.shipment_provider_name AS shipment_provider,
            poi.cost AS retail_cogs,
            DATE(isoish.created_at) AS delivered_date,
            catree.lvl1,
            (SELECT 
                    COUNT(id_sales_order_item)
                FROM
                    oms_live.ims_sales_order_item soi
                WHERE
                    fk_sales_order = iso.id_sales_order
                GROUP BY fk_sales_order) 'total_order_soi',
            CASE
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Mandiri%' THEN 'Mandiri'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BNI%' THEN 'BNI'
                ELSE 'Others'
            END 'bank',
            soin.tenor,
            pbr.payType
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
    LEFT JOIN oms_live.oms_package p ON p.id_package = psh.fk_package
    LEFT JOIN oms_live.oms_package_item pi ON pi.fk_package = p.id_package
    LEFT JOIN oms_live.ims_sales_order_item isoi ON isoi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order iso ON iso.id_sales_order = isoi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status isois ON isois.id_sales_order_item_status = isoi.fk_sales_order_item_status
    LEFT JOIN oms_live.wms_inventory i ON pi.fk_inventory = i.id_inventory
    LEFT JOIN oms_live.ims_purchase_order_item poi ON i.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.oms_package_dispatching pd ON p.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider spr ON pd.fk_shipment_provider = spr.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_item_status_history isoish ON isoish.fk_sales_order_item = isoi.id_sales_order_item
        AND isoish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = isoi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    -- LEFT JOIN screport.sales_order_item scsoi ON scsoi.src_id = isoi.id_sales_order_item
    -- LEFT JOIN screport.seller scseller ON scseller.id_seller = scsoi.fk_seller
    LEFT JOIN bob_live.supplier sup ON isoi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller scseller ON sup.id_supplier = scseller.src_id
    LEFT JOIN bob_live.sales_order_item bsoi ON isoi.bob_id_sales_order_item = bsoi.id_sales_order_item
    LEFT JOIN bob_live.sales_order bso ON bsoi.fk_sales_order = bso.id_sales_order
    LEFT JOIN bob_live.payment_bca_response pbr ON bso.order_nr = pbr.transactionNo
    LEFT JOIN bob_live.payment_dokuinstallment_response pdr ON bso.id_sales_order = pdr.fk_sales_order
    LEFT JOIN bob_live.sales_order_instalment soin ON bso.order_nr = soin.order_nr
    LEFT JOIN bob_live.catalog_simple cs ON bsoi.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN (SELECT 
        IFNULL(lvl0_id, '') 'lvl0_id',
            IFNULL(lvl0, '') 'lvl0',
            IFNULL(lvl1_id, '') 'lvl1_id',
            IFNULL(lvl1, '') 'lvl1',
            IFNULL(lvl2_id, '') 'lvl2_id',
            IFNULL(lvl2, '') 'lvl2',
            IFNULL(lvl3_id, '') 'lvl3_id',
            IFNULL(lvl3, '') 'lvl3',
            IFNULL(lvl4_id, '') 'lvl4_id',
            IFNULL(lvl4, '') 'lvl4',
            IFNULL(lvl5_id, '') 'lvl5_id',
            IFNULL(lvl5, '') 'lvl5',
            IFNULL(lvl6_id, '') 'lvl6_id',
            IFNULL(lvl6, '') 'lvl6',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'lvl0',
            MIN(IF(catree.lvl = 0, catree.cc1_id, NULL)) 'lvl0_id',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'lvl1',
            MIN(IF(catree.lvl = 1, catree.cc1_id, NULL)) 'lvl1_id',
            MIN(IF(catree.lvl = 2, catree.cc1_name, NULL)) 'lvl2',
            MIN(IF(catree.lvl = 2, catree.cc1_id, NULL)) 'lvl2_id',
            MIN(IF(catree.lvl = 3, catree.cc1_name, NULL)) 'lvl3',
            MIN(IF(catree.lvl = 3, catree.cc1_id, NULL)) 'lvl3_id',
            MIN(IF(catree.lvl = 4, catree.cc1_name, NULL)) 'lvl4',
            MIN(IF(catree.lvl = 4, catree.cc1_id, NULL)) 'lvl4_id',
            MIN(IF(catree.lvl = 5, catree.cc1_name, NULL)) 'lvl5',
            MIN(IF(catree.lvl = 5, catree.cc1_id, NULL)) 'lvl5_id',
            MIN(IF(catree.lvl = 6, catree.cc1_name, NULL)) 'lvl6',
            MIN(IF(catree.lvl = 6, catree.cc1_id, NULL)) 'lvl6_id',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        *, IF(cc1_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc0.id_catalog_category 'cc0_id',
            cc0.name_en 'cc0_name',
            cc1.id_catalog_category 'cc1_id',
            cc1.name_en 'cc1_name',
            cc1.lft,
            cc1.rgt
    FROM
        bob_live.catalog_category cc0
    LEFT JOIN bob_live.catalog_category cc1 ON cc0.lft >= cc1.lft
        AND cc0.rgt <= cc1.rgt
    WHERE
        cc0.status = 'active'
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000000) catree) catree
    GROUP BY catree.cc0_id) result) catree ON cc.primary_category = catree.cc0_id
    GROUP BY isoi.bob_id_sales_order_item
    HAVING delivered_date >= @extractstart
        AND delivered_date < @extractend) result