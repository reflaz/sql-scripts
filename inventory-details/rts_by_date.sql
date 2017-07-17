-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-05-01';
SET @extractend = '2017-06-01'; -- This MUST be D + 1

SELECT 
    p.sku AS sku,
    hist1.uid AS uid,
    hist1.barcode AS manufacturer_barcode,
    REPLACE(REPLACE(REPLACE(REPLACE(p.name, '\\', ''), CHAR(10), ' '), CHAR(13), ' '), CHAR(44), ', ') 'item_description',
    IF(l.description IS NULL,
        '',
        l.description) AS location,
    IF(wis.name IS NULL, '', wis.name) AS status,
    hist1.created_at AS created_at,
    hist1.updated_at AS updated_at,
    hist1.expiry_date AS expiry_date,
    poi.cost AS cogp,
    hist1.cost AS write_down_cost,
    IF(po.po_number IS NULL,
        '',
        po.po_number) AS po_number,
    IF(po.po_type IS NULL, '', po.po_type) AS po_type,
    IF(so.order_nr IS NULL, '', so.order_nr) AS order_nr,
    sup.name AS supplier_name,
    hist1.changed_reason_status,
    poct.name AS po_contract_type,
    wh.name AS warehouse_name,
    CONCAT('IDR',
            RIGHT(CONCAT('0000', srpck.id_supplier_return_package),
                7)) AS sap_rts_po_number,
    CONCAT('ID', sup.id_supplier) AS supplier,
    p.erp_reference,
    --
    srpck.package_number,
            wis.name as item_status,
            sua.city, 
            sua.fk_country_region as ID_District,
            cr.name as seller_origin,
            CASE
				WHEN hist1.fk_origin_warehouse = 1 THEN 'Default ID Warehouse'
                WHEN hist1.fk_origin_warehouse = 2 THEN 'Surabaya'
                WHEN hist1.fk_origin_warehouse = 3 THEN 'Medan'
                WHEN hist1.fk_origin_warehouse = 4 THEN 'TImesXBWH'
            END as warehouse_origin,
            CASE
				WHEN hist1.fk_current_warehouse = 1 THEN 'Default ID Warehouse'
                WHEN hist1.fk_current_warehouse = 2 THEN 'Surabaya'
                WHEN hist1.fk_current_warehouse = 3 THEN 'Medan'
                WHEN hist1.fk_current_warehouse = 4 THEN 'TImesXBWH'
            END as current_warehouse,
            ship.shipment_provider_name,
            pa.package_number laz_pck_number,
            hist1.history_created_at as rts_date,
            ih2.history_created_at as shiped_date,
            ih3.history_created_at as delivered_date,
            IFNULL(CASE 
				WHEN cspu.weight > 0 OR (cspu.length * cspu.width * cspu.height) > 0
				THEN cspu.weight
				ELSE cc.package_weight
			END, 0) 'package_weight', 
            IFNULL(CASE 
				WHEN cspu.weight > 0 OR (cspu.length * cspu.width * cspu.height) > 0
				THEN (cspu.length * cspu.width * cspu.height) / 6000
				ELSE cc.package_length * cc.package_width * cc.package_height / 6000
			END, 0) 'volumetric_weight',
    --
    hist2.history_created_at 'sold_offline_date',
    hist1.id_inventory 'id_inventory',
    hist3.fk_inventory_status 'last_status_code',
    hist2.fk_inventory_status 'max_status_code'
FROM
    (SELECT 
        *
    FROM
        oms_live.wms_inventory_history ih
    WHERE
        ih.history_created_at >= @extractstart
            AND ih.history_created_at < @extractend
            AND ih.fk_inventory_status = 18) hist1
        LEFT JOIN
    oms_live.wms_inventory_history hist2 ON hist1.id_inventory = hist2.id_inventory
        AND hist2.id_inventory_history = (SELECT 
            MAX(invhis.id_inventory_history)
        FROM
            oms_live.wms_inventory_history invhis
        WHERE
            invhis.id_inventory = hist1.id_inventory
                -- AND invhis.fk_inventory_status = 18
                AND invhis.history_created_at >= @extractstart
                AND invhis.history_created_at < @extractend)
        LEFT JOIN
    oms_live.wms_inventory_history hist3 ON hist1.id_inventory = hist3.id_inventory
        AND hist3.id_inventory_history = (SELECT 
            MAX(inhis.id_inventory_history)
        FROM
            oms_live.wms_inventory_history inhis
        WHERE
            inhis.history_created_at < @extractstart
                -- AND inhis.fk_inventory_status <> 18
                AND inhis.id_inventory = hist1.id_inventory)
	LEFT JOIN oms_live.wms_inventory_history ih2 on hist1.uid = ih2.uid
		AND ih2.id_inventory_history = (SELECT MIN(id_inventory_history)
		FROM oms_live.wms_inventory_history 
		WHERE uid = hist1.uid
		AND fk_inventory_status = 5)
	LEFT JOIN oms_live.wms_inventory_history ih3 on hist1.uid = ih3.uid
		AND ih3.id_inventory_history = (SELECT MIN(id_inventory_history)
		FROM oms_live.wms_inventory_history 
		WHERE uid = hist1.uid
		AND fk_inventory_status = 6)
        LEFT JOIN
    oms_live.wms_inventory_status wis ON hist2.fk_inventory_status = wis.id_inventory_status
        LEFT JOIN
    oms_live.ims_product p ON hist1.fk_product = p.id_product
        LEFT JOIN
    oms_live.ims_location l ON l.id_location = hist1.fk_location
        LEFT JOIN
    oms_live.ims_purchase_order_item poi ON hist1.fk_purchase_order_item = poi.id_purchase_order_item
        LEFT JOIN
    oms_live.ims_purchase_order po ON po.id_purchase_order = poi.fk_purchase_order
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON poi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.oms_package pa ON pa.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_supplier_product sp ON poi.fk_supplier_product = sp.id_supplier_product
        left JOIN
    oms_live.ims_purchase_order_contract_type poct ON po.fk_purchase_order_contract_type = poct.id_purchase_order_contract_type
        LEFT JOIN
    oms_live.oms_supplier_return_picklist_item srpi ON hist1.id_inventory = srpi.fk_inventory
        LEFT JOIN
    oms_live.oms_supplier_return_package_item srpai ON srpi.id_supplier_return_picklist_item = srpai.fk_supplier_return_picklist_item
        LEFT JOIN
    oms_live.oms_supplier_return_package srpck ON srpai.fk_supplier_return_package = srpck.id_supplier_return_package
    LEFT JOIN oms_live.oms_supplier_return_package_dispatching srpd ON srpd.fk_oms_supplier_return_package = srpck.id_supplier_return_package
    LEFT JOIN oms_live.oms_shipment_provider ship ON ship.id_shipment_provider = srpd.fk_shipment_provider
        LEFT JOIN
    oms_live.oms_warehouse AS wh ON wh.id_warehouse = hist1.fk_current_warehouse
        LEFT JOIN
    oms_live.ims_supplier s ON sp.fk_supplier = s.id_supplier
        LEFT JOIN
    bob_live.supplier sup ON s.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sua ON sua.fk_supplier = sup.id_supplier    
    LEFT JOIN bob_live.country_region cr ON cr.id_country_region = sua.fk_country_region    
    LEFT JOIN bob_live.sales_order_item bob_soi
		ON bob_soi.id_sales_order_item = soi.bob_id_sales_order_item
	LEFT JOIN bob_live.catalog_simple cs 
		ON bob_soi.sku = cs.sku
	LEFT JOIN bob_live.catalog_config cc 
		ON cc.id_catalog_config = cs.fk_catalog_config
	LEFT JOIN bob_live.catalog_simple_package_unit cspu 
		ON cspu.fk_catalog_simple = cs.id_catalog_simple
	GROUP BY supplier , uid , erp_reference , po_type
    having po_contract_type in ('Outright','Consignment')
    AND (hist3.fk_inventory_status <> 18 or hist3.fk_inventory_status is null)
    AND hist2.fk_inventory_status = 18;