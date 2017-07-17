SELECT 
	oms_pd.tracking_number, -- AWB
    oms_so.payment_method, -- Payment Method
    bob_sup.name 'seller_name', -- Merchant name
	bob_sup.type 'seller_type', -- Merchant Type
	oms_so.created_at, -- Created Date
	oms_sois.name 'item_status', -- Item Status
	oms_ship.created_at 'shipped_date', -- Shipped Date
    oms_delv.created_at 'delivered_update_date'
FROM
    oms_live.oms_package_dispatching oms_pd
        LEFT JOIN
    oms_live.oms_package oms_pck ON oms_pd.fk_package = oms_pck.id_package
		LEFT JOIN
	oms_live.oms_shipment_provider oms_sp ON oms_pd.fk_shipment_provider = oms_sp.id_shipment_provider
        LEFT JOIN
    oms_live.oms_package_item oms_pi ON oms_pck.id_package = oms_pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item oms_soi ON oms_pi.fk_sales_order_item = oms_soi.id_sales_order_item
		LEFT JOIN
	oms_live.ims_sales_order_item_status_history oms_ship ON oms_soi.id_sales_order_item = oms_ship.fk_sales_order_item
		AND oms_ship.id_sales_order_item_status_history = (SELECT
			MIN(id_sales_order_item_status_history)
		FROM
			oms_live.ims_sales_order_item_status_history
		WHERE
			fk_sales_order_item = oms_soi.id_sales_order_item
			AND fk_sales_order_item_status = 5) -- first time shipped
		LEFT JOIN
	oms_live.ims_sales_order_item_status_history oms_delv ON oms_soi.id_sales_order_item = oms_delv.fk_sales_order_item
		AND oms_delv.id_sales_order_item_status_history = (SELECT
			MIN(id_sales_order_item_status_history)
		FROM
			oms_live.ims_sales_order_item_status_history
		WHERE
			fk_sales_order_item = oms_soi.id_sales_order_item
			AND fk_sales_order_item_status = 27) -- first time delivered
		LEFT JOIN
	oms_live.ims_sales_order_item_status oms_sois ON oms_soi.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
		LEFT JOIN
	oms_live.ims_sales_order oms_so ON oms_soi.fk_sales_order = oms_so.id_sales_order
		LEFT JOIN
	bob_live.supplier bob_sup ON oms_soi.bob_id_supplier = bob_sup.id_supplier
WHERE
	oms_pd.tracking_number IN ('')
GROUP BY
	oms_pd.tracking_number;