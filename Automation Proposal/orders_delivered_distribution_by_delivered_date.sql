-- BCA_Bank_Transfer
-- BCA_KlikPay
-- BCA_Virtual_Account
-- BNI_Virtual_Account
-- CashOnDelivery
-- Cybersource
-- DOKUInstallment
-- Hellopay
-- KlikBCA_Payment
-- Mandiri_Virtual_Payment
-- MandiriClickpay
-- ManualBankTransferId
-- NoPayment

SELECT 
    *
FROM
    (SELECT 
        payment_method,
            COUNT(IF(MONTH(so.created_at) = 1, soi.id_sales_order_item, NULL)) 'soi_count_jan',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 1, so.id_sales_order, NULL)) 'so_count_jan',
            COUNT(IF(MONTH(so.created_at) = 2, soi.id_sales_order_item, NULL)) 'soi_count_feb',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 2, so.id_sales_order, NULL)) 'so_count_feb',
            COUNT(IF(MONTH(so.created_at) = 3, soi.id_sales_order_item, NULL)) 'soi_count_mar',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 3, so.id_sales_order, NULL)) 'so_count_mar',
            COUNT(IF(MONTH(so.created_at) = 4, soi.id_sales_order_item, NULL)) 'soi_count_apr',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 4, so.id_sales_order, NULL)) 'so_count_apr',
            COUNT(IF(MONTH(so.created_at) = 5, soi.id_sales_order_item, NULL)) 'soi_count_may',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 5, so.id_sales_order, NULL)) 'so_count_may',
            COUNT(IF(MONTH(so.created_at) = 6, soi.id_sales_order_item, NULL)) 'soi_count_jun',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 6, so.id_sales_order, NULL)) 'so_count_jun',
            COUNT(IF(MONTH(so.created_at) = 7, soi.id_sales_order_item, NULL)) 'soi_count_jul',
            COUNT(DISTINCT IF(MONTH(so.created_at) = 7, so.id_sales_order, NULL)) 'so_count_jul'
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= '2016-01-01'
            AND created_at < '2016-08-01'
            AND fk_package_status = 6) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    WHERE
        so.created_at >= '2016-01-01'
            AND so.created_at < '2016-08-01'
            AND soi.fk_sales_order_item_status = 27
    GROUP BY payment_method) result