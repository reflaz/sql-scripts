SET @extractstart = '2016-09-01';
SET @extractend = '2016-09-02';
SET @lvl = 0;

SELECT 
    payment_method,
    bank,
    tenor,
    shipment_provider,
    total_qty,
    total_so,
    total_from_customer,
    payment_cost_logic,
    payment_cost,
    NA / total_paid_price * payment_cost 'NA',
    c2994 / total_paid_price * payment_cost 'Sports & Outdoors',
    c332 / total_paid_price * payment_cost 'Travel & Luggage',
    c3281 / total_paid_price * payment_cost 'Fashion',
    c7230 / total_paid_price * payment_cost 'Media, Music & Books',
    c6971 / total_paid_price * payment_cost 'Motors',
    c3297 / total_paid_price * payment_cost 'Home Appliances',
    c3509 / total_paid_price * payment_cost 'Health & Beauty',
    c3377 / total_paid_price * payment_cost 'Computers & Laptops',
    c3425 / total_paid_price * payment_cost 'TV, Audio / Video, Gaming & Wearables',
    c3441 / total_paid_price * payment_cost 'Mobiles & Tablets',
    c3476 / total_paid_price * payment_cost 'Cameras',
    c3913 / total_paid_price * payment_cost 'Home & Living',
    c5360 / total_paid_price * payment_cost 'Lazada Deals',
    c9654 / total_paid_price * payment_cost 'Groceries',
    c15077 / total_paid_price * payment_cost 'Special Promotion',
    c10685 / total_paid_price * payment_cost 'Vouchers and Services',
    c11960 / total_paid_price * payment_cost 'Watches Sunglasses Jewellery',
    c13378 / total_paid_price * payment_cost 'Baby & Toddler',
    c13403 / total_paid_price * payment_cost 'Toys & Games',
    c15838 / total_paid_price * payment_cost 'Pet Supplies'
FROM
    (SELECT 
        *,
            SUM(from_customer) 'total_from_customer',
            SUM(qty) 'total_qty',
            COUNT(DISTINCT id_sales_order) 'total_so',
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
                WHEN payment_method = 'Cybersource' THEN 0.0185 * SUM(from_customer)
                WHEN payment_method = 'Mandiri_Virtual_Payment' THEN 3000 * COUNT(DISTINCT id_sales_order)
                WHEN payment_method = 'BCA_Virtual_Account' THEN 1000 * COUNT(DISTINCT id_sales_order)
                WHEN payment_method = 'Hellopay' THEN 0.0225 * SUM(from_customer)
                WHEN payment_method = 'MandiriClickpay' THEN 3000 * COUNT(DISTINCT id_sales_order)
                WHEN
                    payment_method = 'BCA_KlikPay'
                        AND payType = 1
                THEN
                    3500 * COUNT(DISTINCT id_sales_order)
                WHEN
                    payment_method = 'BCA_KlikPay'
                        AND payType = 2
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.015 * SUM(from_customer))
                WHEN
                    payment_method = 'CashOnDelivery'
                        AND shipment_provider LIKE '%LEX%'
                THEN
                    0.015 * SUM(from_customer)
                WHEN payment_method = 'CashOnDelivery' THEN 0.01 * SUM(from_customer)
                WHEN
                    payment_method = 'DOKUInstallment'
                        AND bank LIKE '%Mandiri%'
                        AND tenor = 3
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.025 * SUM(from_customer))
                WHEN
                    payment_method = 'DOKUInstallment'
                        AND bank LIKE '%Mandiri%'
                        AND tenor = 6
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.04 * SUM(from_customer))
                WHEN
                    payment_method = 'DOKUInstallment'
                        AND bank LIKE '%Mandiri%'
                        AND tenor = 12
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.06 * SUM(from_customer))
                WHEN
                    payment_method = 'DOKUInstallment'
                        AND bank LIKE '%BNI%'
                        AND tenor = 3
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.03 * SUM(from_customer))
                WHEN
                    payment_method = 'DOKUInstallment'
                        AND bank LIKE '%BNI%'
                        AND tenor = 6
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.04 * SUM(from_customer))
                WHEN
                    payment_method = 'DOKUInstallment'
                        AND bank LIKE '%BNI%'
                        AND tenor = 12
                THEN
                    (1500 * COUNT(DISTINCT id_sales_order)) + (0.06 * SUM(from_customer))
                WHEN payment_method = 'DOKUInstallment' THEN (0.019 * SUM(from_customer))
                WHEN payment_method = 'BCA_Bank_Transfer' THEN 3050 * COUNT(DISTINCT id_sales_order)
                WHEN payment_method = 'KlikBCA_Payment' THEN 3500 * COUNT(DISTINCT id_sales_order)
                WHEN payment_method = 'BNI_Virtual_Account' THEN 2200 * COUNT(DISTINCT id_sales_order)
            END 'payment_cost',
            SUM(paid_price) 'total_paid_price',
            SUM(IF(lvl1 IS NULL, paid_price, 0)) 'NA',
            SUM(IF(lvl1 = '2994', paid_price, 0)) 'c2994',
            SUM(IF(lvl1 = '332', paid_price, 0)) 'c332',
            SUM(IF(lvl1 = '3281', paid_price, 0)) 'c3281',
            SUM(IF(lvl1 = '7230', paid_price, 0)) 'c7230',
            SUM(IF(lvl1 = '6971', paid_price, 0)) 'c6971',
            SUM(IF(lvl1 = '3297', paid_price, 0)) 'c3297',
            SUM(IF(lvl1 = '3509', paid_price, 0)) 'c3509',
            SUM(IF(lvl1 = '3377', paid_price, 0)) 'c3377',
            SUM(IF(lvl1 = '3425', paid_price, 0)) 'c3425',
            SUM(IF(lvl1 = '3441', paid_price, 0)) 'c3441',
            SUM(IF(lvl1 = '3476', paid_price, 0)) 'c3476',
            SUM(IF(lvl1 = '3913', paid_price, 0)) 'c3913',
            SUM(IF(lvl1 = '5360', paid_price, 0)) 'c5360',
            SUM(IF(lvl1 = '9654', paid_price, 0)) 'c9654',
            SUM(IF(lvl1 = '15077', paid_price, 0)) 'c15077',
            SUM(IF(lvl1 = '10685', paid_price, 0)) 'c10685',
            SUM(IF(lvl1 = '11960', paid_price, 0)) 'c11960',
            SUM(IF(lvl1 = '13378', paid_price, 0)) 'c13378',
            SUM(IF(lvl1 = '13403', paid_price, 0)) 'c13403',
            SUM(IF(lvl1 = '15838', paid_price, 0)) 'c15838'
    FROM
        (SELECT 
        bso.payment_method,
            soin.tenor,
            CASE
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Mandiri%' THEN 'Mandiri'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BNI%' THEN 'BNI'
                ELSE 'Others'
            END 'bank',
            soi.bob_id_sales_order_item,
            soi.paid_price,
            lvl1_id 'lvl1',
            soi.paid_price + soi.shipping_amount + soi.shipping_surcharge 'from_customer',
            bso.id_sales_order,
            1 'qty',
            IF(bso.payment_method = 'CashOnDelivery'
                AND sp.shipment_provider_name LIKE '%LEX%', 'LEX', 'Others') 'shipment_provider',
            pbr.payType
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN bob_live.sales_order_item bsoi ON soi.bob_id_sales_order_item = bsoi.id_sales_order_item
    LEFT JOIN bob_live.sales_order bso ON bsoi.fk_sales_order = bso.id_sales_order
    LEFT JOIN bob_live.payment_bca_response pbr ON bso.order_nr = pbr.transactionNo
    LEFT JOIN bob_live.payment_dokuinstallment_response pdr ON bso.id_sales_order = pdr.fk_sales_order
    LEFT JOIN bob_live.sales_order_instalment soin ON bso.order_nr = soin.order_nr
    LEFT JOIN bob_live.catalog_simple cs ON bsoi.sku = cs.sku
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
    WHERE
        soish.created_at >= @extractstart
            AND soish.created_at < @extractend
    GROUP BY bob_id_sales_order_item) result
    GROUP BY payment_method , tenor , bank , shipment_provider , payType) result