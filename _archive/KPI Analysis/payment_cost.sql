SET @extractstart = '2016-09-01';
SET @extractend = '2016-10-01';

SELECT 
    payment_method,
    bank,
    tenor,
    shipment_provider,
    total_qty,
    total_so,
    total_from_customer,
    payment_cost_logic,
    payment_cost
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
            END 'payment_cost'
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
            soi.paid_price 'total_paid_price',
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
    WHERE
        soish.created_at >= @extractstart
            AND soish.created_at < @extractend
    GROUP BY bob_id_sales_order_item) result
    GROUP BY payment_method , tenor , bank , shipment_provider , payType) result