/*
SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'first_name":"', - 1), '","', 1) AS customer_name,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'address1":"', - 1), '","', 1) AS customer_shipping_address,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'city":"', - 1), '","', 1) AS customer_shipping_city,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'phone":"', - 1), '","', 1) AS customer_phone_number,
*/

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            so.created_at,
            so.payment_method,
            IFNULL(bso.payment_method_obs, '') 'payment_method_obs',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            so.coupon_code,
            sovt.name 'coupon_type',
            IFNULL(soi.cart_rule_display_names, '') 'cart_rule_display_names',
            CASE
                WHEN bcakpay.transactionNo IS NOT NULL THEN ''
                WHEN cybers.orderNr IS NOT NULL THEN ''
                WHEN bca_bt.orderNr IS NOT NULL THEN bca_bt.idCust
                WHEN klikbca.transno IS NOT NULL THEN klikbca.userid
                WHEN mandiri_vt.orderNr IS NOT NULL THEN SUBSTRING_INDEX(SUBSTRING_INDEX(mandiri_vt.raw_response, '<CUST_ID>', - 1), '</CUST_ID>', 1)
                ELSE ''
            END 'payment_cust_id',
            CASE
                WHEN bca_bt.orderNr IS NOT NULL THEN bca_bt.custName
                WHEN mandiri_vt.orderNr IS NOT NULL THEN SUBSTRING_INDEX(SUBSTRING_INDEX(mandiri_vt.raw_response, '<CUST_NAME>', - 1), '</CUST_NAME>', 1)
                ELSE ''
            END 'payment_cust_name',
            soi.bob_id_supplier,
            sel.short_code,
            sel.name AS seller_name,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'address1":"', - 2), '","', 1) AS seller_address,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'city":"', - 2), '","', 1) AS seller_city,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'phone":"', - 2), '","', 1) AS seller_phone_number,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'bank_account_bank":"', - 1), '","', 1) AS seller_bank,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'bank_account_nr":"', - 1), '","', 1) AS seller_bank_account_number,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'bank_account_name":"', - 1), '","', 1) AS seller_bank_account_name,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'first_name":"', - 1), '","', 1) AS customer_name,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'address1":"', - 1), '","', 1) AS customer_shipping_address,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'city":"', - 1), '","', 1) AS customer_shipping_city,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sot.address_shipping, 'phone":"', - 1), '","', 1) AS customer_phone_number
    FROM
        bob_live.payment_klikbca_response klikbca
    LEFT JOIN oms_live.ims_sales_order so ON klikbca.transno = so.order_nr
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN bob_live.sales_order bso ON so.order_nr = bso.order_nr
    LEFT JOIN bob_live.payment_cybersource_response cybers ON so.order_nr = cybers.orderNr
    LEFT JOIN bob_live.payment_bca_response bcakpay ON so.order_nr = bcakpay.transactionNo
    LEFT JOIN bob_live.payment_bca_bank_transfer_response bca_bt ON so.order_nr = bca_bt.orderNr
    LEFT JOIN bob_live.payment_mandiri_virtual_transfer_response mandiri_vt ON so.order_nr = mandiri_vt.orderNr
        AND request_type = 'INQUIRY'
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.sales_order_item ascsoi ON soi.id_sales_order_item = ascsoi.src_id
    LEFT JOIN asc_live.sales_order ascso ON ascsoi.fk_sales_order = ascso.id_sales_order
    LEFT JOIN asc_live.sales_order_temp sot ON ascso.id_sales_order = sot.id_sales_order
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        klikbca.userid IN ()) result