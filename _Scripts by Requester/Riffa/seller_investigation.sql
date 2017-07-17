SET @extractstart = '2015-12-28';
SET @extractend = '2016-02-01'; -- this must be the day after

SELECT 
    *,
    CASE payment_method
        WHEN 'ManualBankTransactionId' THEN finance_verified_date
        WHEN 'CashOnDelivery' THEN delivered_date
        ELSE order_verification_date
    END 'trigger_date_by_payment_method',
    CASE payment_method
        WHEN
            'ManualBankTransactionId'
        THEN
            DATEDIFF(statement_end_date,
                    finance_verified_date) + 5
        WHEN 'CashOnDelivery' THEN DATEDIFF(statement_end_date, delivered_date) + 5 - 8.5
        ELSE DATEDIFF(statement_end_date,
                DATE_ADD(order_date, INTERVAL 1 DAY)) + 5
    END 'lead_time'
FROM
    (SELECT 
        sc.short_code 'sc_seller_id',
            CONCAT('ID', sc.sel_id) 'sel_id',
            sc.name 'seller_name',
            so.order_nr,
            soi.bob_id_sales_order_item,
            so.payment_method,
            so.created_at 'order_date',
            sc.item_price_credit,
            sc.shipping_fee_credit,
            MIN(IF(soish.fk_sales_order_item_status = 69, soish.created_at, NULL)) 'order_verification_date',
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'finance_verified_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            sc.statement_created_date,
            sc.statement_start_date,
            sc.statement_end_date,
            IF(sel_id IN (''), '1st', '') '1st'
    FROM
        (SELECT 
        soi.src_id,
            SUM(IF(tr.fk_transaction_type = 13, tr.value, 0)) 'item_price_credit',
            SUM(IF(tr.fk_transaction_type = 8, tr.value, 0)) 'shipping_fee_credit',
            ts.created_at 'statement_created_date',
            ts.start_date 'statement_start_date',
            ts.end_date 'statement_end_date',
            sel.name,
            sel.src_id 'sel_id',
            sel.short_code
    FROM
        screport.transaction_statement ts
    LEFT JOIN screport.transaction tr ON ts.id_transaction_statement = tr.fk_transaction_statement
    LEFT JOIN screport.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN screport.seller sel ON soi.fk_seller = sel.id_seller
    WHERE
        ts.start_date >= @extractstart
            AND ts.end_date < @extractend
            AND ts.fk_seller IN ('')
            AND tr.fk_transaction_type IN (13 , 8)
    GROUP BY soi.id_sales_order_item
    HAVING soi.id_sales_order_item IS NOT NULL) sc
    LEFT JOIN oms_live.ims_sales_order_item soi ON sc.src_id = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    WHERE
        so.payment_method <> 'NoPayment'
    GROUP BY soi.id_sales_order_item) result