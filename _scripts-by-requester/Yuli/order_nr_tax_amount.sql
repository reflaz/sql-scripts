SELECT 
    order_nr, tax_amount
FROM
    oms_live.ims_sales_order
WHERE
    order_nr IN ('')