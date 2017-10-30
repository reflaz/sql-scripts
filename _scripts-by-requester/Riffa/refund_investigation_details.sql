SELECT 
	oms_so.order_nr,
	oms_soi.bob_id_sales_order_item,
	oms_soi.id_sales_order_item 'oms_id_sales_order_item',
	oms_so.payment_method,
	oms_soi.unit_price,
	oms_soi.paid_price,
	oms_soi.shipping_surcharge,
	oms_sois.name AS current_status,
	MIN(oms_soi.created_at) AS soi_created_date,
	MIN(oms_so.created_at) AS so_created_date,
	MIN(oms_pck.created_at) AS package_date,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 10 THEN oms_soish.created_at ELSE NULL END) AS invalid,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 69 THEN oms_soish.created_at ELSE NULL END) AS order_verification,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 66 THEN oms_soish.created_at ELSE NULL END) AS finance_failed,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 67 THEN oms_soish.created_at ELSE NULL END) AS finance_verified,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 5 THEN oms_soish.created_at ELSE NULL END) AS shipped,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 9 THEN oms_soish.created_at ELSE NULL END) AS cancelled,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status IN (8 , 11) THEN oms_soish.created_at ELSE NULL END) AS returned,
    MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 57 THEN oms_soish.created_at ELSE NULL END) AS refund_reject,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status IN (56 , 78) THEN oms_soish.created_at ELSE NULL END) AS refunded_replaced,
	MIN(CASE WHEN oms_soish.fk_sales_order_item_status = 27 THEN oms_soish.created_at ELSE NULL END) AS delivered,
	SUM(CASE WHEN oms_soish.fk_sales_order_item_status IN (50 , 76) THEN 1 ELSE 0 END) AS times_shipped,
	CASE WHEN is_marketplace = 0 AND oms_soi.fk_marketplace_merchant IS NOT NULL THEN 1 ELSE 0 END AS mp_to_retail_change,
	bob_sup.name,
	bob_sup.type AS supplier_type,
    (SELECT COUNT(id_sales_order_item) FROM oms_live.ims_sales_order_item WHERE fk_sales_order = oms_so.id_sales_order) AS item_count
FROM
	oms_live.ims_sales_order oms_so
		JOIN
	oms_live.ims_sales_order_item oms_soi ON oms_so.id_sales_order = oms_soi.fk_sales_order
		JOIN
	oms_live.ims_sales_order_item_status_history oms_soish ON oms_soi.id_sales_order_item = oms_soish.fk_sales_order_item
		JOIN
	oms_live.ims_sales_order_item_status oms_sois ON oms_soi.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
		LEFT JOIN
	oms_live.oms_package_item oms_pi ON oms_soi.id_sales_order_item = oms_pi.fk_sales_order_item
		LEFT JOIN
	oms_live.oms_package oms_pck ON oms_pi.fk_package = oms_pck.id_package
		LEFT JOIN
	bob_live.supplier bob_sup ON oms_soi.bob_id_supplier = bob_sup.id_supplier
WHERE
	oms_so.order_nr IN ('')
GROUP BY bob_id_sales_order_item