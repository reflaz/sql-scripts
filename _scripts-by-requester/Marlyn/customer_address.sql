SELECT 
    so.order_nr,
    bso.customer_first_name,
    CONCAT(soa.address1, ' ', soa.city) 'address'
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
        LEFT JOIN
    bob_live.sales_order bso ON so.order_nr = bso.order_nr
WHERE
    so.order_nr IN ('')