SELECT 
    result.*,
    CONCAT(IF(UPPER(coupon_code) LIKE 'IDCSDUMMY%' OR email LIKE '%lazada%', 'Dummy Order', ''),
    IF(delivered IS NOT NULL,
    IF(finance_verified >= mbt_report_date,' Possible Advance',''),''), commentary) 'Remarks'
FROM
    (SELECT 
        oms_so.order_nr,
            oms_soi.bob_id_sales_order_item,
            (SELECT COUNT(id_sales_order_item) FROM oms_live.ims_sales_order_item WHERE fk_sales_order = oms_so.id_sales_order) AS item_count,
            oms_so.payment_method,
            oms_so.coupon_code,
            oms_soi.unit_price,
            oms_soi.paid_price,
            oms_soi.shipping_surcharge,
            oms_sois.name AS current_status,
            MIN(CASE WHEN oms_soish.fk_sales_order_item_status = oms_soi.fk_sales_order_item_status THEN oms_soish.created_at ELSE NULL END) AS current_status_date,
			MIN(oms_so.created_at) AS so_created_date,
			MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 69 THEN oms_soish.created_at ELSE NULL END) AS order_verification,
			MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 67 THEN oms_soish.created_at ELSE NULL END) AS finance_verified,
			MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 27 THEN oms_soish.created_at ELSE NULL END) AS delivered,
            DATE_FORMAT(CONCAT(DATE_FORMAT(DATE_ADD(oms_so.created_at, INTERVAL 1 MONTH),'%Y-%m'),'-05'),'%Y-%m-%d %H:%i:%S') 'mbt_report_date',
            CASE
				WHEN UPPER(group_concat(oms_soc.content)) LIKE '%DUMMY%' THEN 'Dummy Order'
				WHEN UPPER(group_concat(oms_soc.content)) LIKE '%DIVERT%' THEN 'Divert Order'
                ELSE ''
            END 'commentary',
            bob_cus.first_name 'customer_name',
            bob_cus.email
    FROM
        oms_live.ims_sales_order oms_so
    LEFT JOIN oms_live.ims_sales_order_item oms_soi ON oms_so.id_sales_order = oms_soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history oms_soish ON oms_soi.id_sales_order_item = oms_soish.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status oms_sois ON oms_soi.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_sales_order_comment oms_soc ON oms_so.id_sales_order = oms_soc.fk_sales_order
    LEFT JOIN bob_live.customer bob_cus ON oms_so.bob_id_customer = bob_cus.id_customer
    WHERE
        oms_so.order_nr IN ('304424651')
    GROUP BY bob_id_sales_order_item) result