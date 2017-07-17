SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            so.created_at 'order_date',
            so.payment_method,
            kbr.userid,
            SUBSTRING_INDEX(SUBSTRING_INDEX(IFNULL(scso.address_shipping, scso.address_shipping), 'first_name":"', - 1), '","', 1) first_name,
            SUBSTRING_INDEX(SUBSTRING_INDEX(IFNULL(scso.address_shipping, scso.address_shipping), 'phone":"', - 1), '","', 1) phone,
            SUBSTRING_INDEX(SUBSTRING_INDEX(IFNULL(scso.address_shipping, scso.address_shipping), 'address1":"', - 1), '","', 1) address1,
            SUBSTRING_INDEX(SUBSTRING_INDEX(IFNULL(scso.address_shipping, scso.address_shipping), 'city":"', - 1), '","', 1) city
    FROM
        bob_live.payment_klikbca_response kbr
    LEFT JOIN oms_live.ims_sales_order so ON kbr.transno = so.order_nr
    LEFT JOIN screport.sales_order scso ON so.order_nr = scso.order_nr
    LEFT JOIN asc_live.sales_order lcso ON so.order_nr = lcso.order_nr
    WHERE
        userid = 'RICOBUNA9292') result