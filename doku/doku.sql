SELECT 
    so.order_nr 'order_number',
    so.created_at 'order_date',
    so.payment_method,
    SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</AMOUNT>', 1),
            '<AMOUNT>',
            - 1) 'amount',
    SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</RESULTMSG>', 1),
            '<RESULTMSG>',
            - 1) 'result_msg',
    SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1),
            '<BANK>',
            - 1) 'bank',
    soin.tenor 'tenor'
FROM
    bob_live.sales_order so
        LEFT JOIN
    bob_live.payment_dokuinstallment_response pdr ON so.id_sales_order = pdr.fk_sales_order
        LEFT JOIN
    bob_live.sales_order_instalment soin ON so.order_nr = soin.order_nr
WHERE
    so.order_nr IN ('');