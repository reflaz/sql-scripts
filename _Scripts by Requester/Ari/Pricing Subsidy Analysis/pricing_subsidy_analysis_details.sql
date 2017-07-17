SET @extractstart = '2015-12-27';
SET @extractend = '2016-07-13';
SET @sku = 'XI619ELAA1VHRTANID-3464623,SA850ELATGGPANID-754490,XI619ELAA4EH9IANID-8629295,IN848ELBCH8QANID-1243298,IN848ELBERX1ANID-1359166,IN848ELCHKE0ANID-2982992,IN848ELCHKF3ANID-2983031,ME826ELAA3CO1FANID-6389457,XI619ELAA31H8LANID-5710568,XI619ELAA37G9JANID-6087022,XI619ELAA3AGYWANID-6255562,XI619ELAA3AP7AANID-6268442,XI619ELAA3EQ1AANID-6509263,XI619ELAA3F5SSANID-6531957,XI619ELAA3G7PPANID-6587495,XI619ELAA3GLFJANID-6608781,XI619ELAA3GLZ4ANID-6609552,XI619ELAA3GN34ANID-6611401,XI619ELAA3MQZ2ANID-6982935,XI619ELAA3RUZJANID-7261616,IO763OTAK517ANID-524254,KO406ELAWGLUANID-923097,HI451ELAE2T2ANID-224276,DE773HBACMRBANID-143257,CH273ELAA3AHDDANID-6256172';

SELECT 
    *
FROM
    (SELECT 
        result.*,
            kbca.userid 'klikbca_user',
            MIN(IF(SUBSTRING_INDEX(SUBSTRING_INDEX(rawresponse, '"trueIPAddress":"', - 1), '","', 1) NOT LIKE '{%', SUBSTRING_INDEX(SUBSTRING_INDEX(rawresponse, '"trueIPAddress":"', - 1), '","', 1), NULL)) 'cybersource_ip',
            SUBSTRING_INDEX(SUBSTRING_INDEX(manvir.raw_response, '<CUST_ID>', - 1), '</CUST_ID>', 1) 'mandirivp_id',
            SUBSTRING_INDEX(SUBSTRING_INDEX(manvir.raw_response, '<CUST_NAME>', - 1), '</CUST_NAME>', 1) 'mandirivp_name',
            bni.customer_name 'bni_va_customer',
            SUBSTRING_INDEX(SUBSTRING_INDEX(hp.raw_response, '","firstName', 1), '"name":"', - 1) 'hellopay_name'
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.sku,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            soi.marketplace_commission_fee,
            soi.created_at,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 69 THEN soish.created_at
                ELSE NULL
            END) AS order_verification,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 67 THEN soish.created_at
                ELSE NULL
            END) AS finance_verified,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 5 THEN soish.created_at
                ELSE NULL
            END) AS shipped,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 9 THEN soish.created_at
                ELSE NULL
            END) AS cancelled,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status IN (8 , 11) THEN soish.created_at
                ELSE NULL
            END) AS returned,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status IN (56 , 78) THEN soish.created_at
                ELSE NULL
            END) AS refunded_replaced,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 27 THEN soish.created_at
                ELSE NULL
            END) AS delivered,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 27 THEN soish.real_action_date
                ELSE NULL
            END) AS real_delivered,
            SUM(CASE
                WHEN soish.fk_sales_order_item_status IN (50 , 76) THEN 1
                ELSE 0
            END) AS times_shipped,
            sup.name AS seller_name,
            sup.type AS seller_type,
            sup.bank_account_name,
            sup.bank_account_nr,
            sup.bank_account_bank,
            cus.first_name,
            cus.default_payment,
            cus.default_payment_value,
            so.payment_method,
            bso.payment_method_obs
    FROM
        oms_live.ims_sales_order_item soi
    JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (69 , 67, 5, 9, 8, 11, 56, 78, 27, 50, 76)
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN bob_live.sales_order bso ON so.order_nr = bso.order_nr
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.customer cus ON so.bob_id_customer = cus.id_customer
    WHERE
        soi.created_at >= @extractstart
            AND soi.created_at < @extractend
            AND FIND_IN_SET(soi.sku, @sku)
    GROUP BY soi.id_sales_order_item) result
    LEFT JOIN bob_live.payment_klikbca_response kbca ON result.order_nr = kbca.transno
    LEFT JOIN bob_live.payment_cybersource_response cyber ON result.order_nr = cyber.ordernr
    LEFT JOIN bob_live.payment_mandiri_virtual_transfer_response manvir ON result.order_nr = manvir.ordernr
    LEFT JOIN bob_live.payment_bni_response bni ON result.order_nr = bni.trx_id
    LEFT JOIN bob_live.payment_hellopay_response hp ON result.order_nr = hp.order_nr
    GROUP BY bob_id_sales_order_item) result