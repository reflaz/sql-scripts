SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.payment_method,
    soi.unit_price,
    soi.paid_price,
    soi.shipping_amount,
    soi.shipping_surcharge,
    so.created_at 'order_date',
    soish.created_at 'finance_verified',
    CASE
        WHEN
            (SELECT 
                    MAX(id_payment_bca_va_generated_codes)
                FROM
                    bob_live.payment_bca_va_generated_codes
                WHERE
                    order_nr = so.order_nr)
        THEN
            'BCA_Virtual_Account'
        WHEN
            (SELECT 
                    MAX(id_payment_bca_bank_transfer_response)
                FROM
                    bob_live.payment_bca_bank_transfer_response
                WHERE
                    orderNr = so.order_nr)
        THEN
            'BCA_Bank_Transfer'
    END 'type'
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
WHERE
    so.created_at >= '2016-11-24'
        AND so.created_at < '2016-12-05'
        AND so.payment_method = 'BCA_Bank_Transfer'
GROUP BY soi.id_sales_order_item