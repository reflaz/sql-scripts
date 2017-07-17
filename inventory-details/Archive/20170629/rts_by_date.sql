/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Return To Seller by Date 
 
Prepared by		: Michael Julius
Modified by		: MJ
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-11-01';
SET @extractend = '2016-12-01'; -- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
			p.sku AS sku,
            pop.uid AS uid,
            pop.barcode AS manufacturer_barcode,
            p.name AS item_description,
            IF(l.description IS NULL, '', l.description) AS location,
            IF(wis.name IS NULL, '', wis.name) AS status,
            pop.created_at AS created_at,
            pop.updated_at AS updated_at,
            pop.expiry_date AS expiry_date,
            poi.cost AS cogp,
            pop.cost AS write_down_cost,
            IF(po.po_number IS NULL, '', po.po_number) AS po_number,
            IF(po.po_type IS NULL, '', po.po_type) AS po_type,
            IF(so.order_nr IS NULL, '', so.order_nr) AS order_nr,
            sup.name AS supplier_name,
            pop.changed_reason_status,
            poct.name AS po_contract_type,
            wh.name AS warehouse_name,
            CONCAT('IDR', RIGHT(CONCAT('0000', srpck.id_supplier_return_package), 7)) AS sap_rts_po_number,
            CONCAT('ID', sup.id_supplier) AS supplier,
            p.erp_reference,
            srpck.package_number,
            wis.name as item_status,
            sua.city, 
            sua.fk_country_region as ID_District,
            cr.name as seller_origin,
            CASE
				WHEN pop.fk_origin_warehouse = 1 THEN 'Default ID Warehouse'
                WHEN pop.fk_origin_warehouse = 2 THEN 'Surabaya'
                WHEN pop.fk_origin_warehouse = 3 THEN 'Medan'
                WHEN pop.fk_origin_warehouse = 4 THEN 'TImesXBWH'
            END as warehouse_origin,
            CASE
				WHEN pop.fk_current_warehouse = 1 THEN 'Default ID Warehouse'
                WHEN pop.fk_current_warehouse = 2 THEN 'Surabaya'
                WHEN pop.fk_current_warehouse = 3 THEN 'Medan'
                WHEN pop.fk_current_warehouse = 4 THEN 'TImesXBWH'
            END as current_warehouse,
            ship.shipment_provider_name,
            pa.package_number laz_pck_number,
            ih.history_created_at as rts_date,
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
			END, 0) 'volumetric_weight'
    FROM
		(
			select
				id_inventory,
				uid,
                sku,
                fk_inventory_status,
                fk_origin_warehouse,
                fk_current_warehouse,
                history_created_at,
                barcode,
                created_at ,
                updated_at,
				expiry_date,
                cost,
                changed_reason_status
			from
				oms_live.wms_inventory_history
			where
				history_created_at >= @extractstart
            AND history_created_at < @extractend
            AND fk_inventory_status = 18
        ) pop
    
    LEFT JOIN
        oms_live.wms_inventory_history i on pop.id_inventory = i.id_inventory
        AND i.id_inventory_history = (SELECT 
            MAX(id_inventory_history)
        FROM
            oms_live.wms_inventory_history
        WHERE
            history_created_at >= @extractstart
                AND history_created_at < @extractend
                AND id_inventory = i.id_inventory
                and i.fk_inventory_status = 18)
        
    LEFT JOIN oms_live.wms_inventory_history ih ON i.id_inventory = ih.id_inventory
        AND ih.id_inventory_history = (SELECT MIN(id_inventory_history)
		FROM oms_live.wms_inventory_history 
		WHERE uid = ih.uid
		AND fk_inventory_status = 18)
	LEFT JOIN oms_live.wms_inventory_history ih2 on ih.uid = ih2.uid
		AND ih2.id_inventory_history = (SELECT MIN(id_inventory_history)
		FROM oms_live.wms_inventory_history 
		WHERE uid = ih.uid
		AND fk_inventory_status = 5)
	LEFT JOIN oms_live.wms_inventory_history ih3 on ih.uid = ih3.uid
		AND ih3.id_inventory_history = (SELECT MIN(id_inventory_history)
		FROM oms_live.wms_inventory_history 
		WHERE uid = ih.uid
		AND fk_inventory_status = 6)

    LEFT JOIN oms_live.wms_inventory_status wis ON ih.fk_inventory_status = wis.id_inventory_status
    LEFT JOIN oms_live.ims_product p ON ih.fk_product = p.id_product
    LEFT JOIN oms_live.ims_location l ON l.id_location = ih.fk_location
    LEFT JOIN oms_live.ims_purchase_order_item poi ON ih.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.ims_purchase_order po ON po.id_purchase_order = poi.fk_purchase_order
			  AND po.fk_purchase_order_contract_type in ('1','3') 
    LEFT JOIN oms_live.ims_sales_order_item soi ON poi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.oms_package pa ON pa.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_supplier_product sp ON poi.fk_supplier_product = sp.id_supplier_product
    LEFT JOIN oms_live.ims_purchase_order_contract_type poct ON po.fk_purchase_order_contract_type = poct.id_purchase_order_contract_type
    LEFT JOIN oms_live.oms_supplier_return_picklist_item srpi ON ih.id_inventory = srpi.fk_inventory
    LEFT JOIN oms_live.oms_supplier_return_package_item srpai ON srpi.id_supplier_return_picklist_item = srpai.fk_supplier_return_picklist_item
    LEFT JOIN oms_live.oms_supplier_return_package srpck ON srpai.fk_supplier_return_package = srpck.id_supplier_return_package
    LEFT JOIN oms_live.oms_supplier_return_package_dispatching srpd ON srpd.fk_oms_supplier_return_package = srpck.id_supplier_return_package
    LEFT JOIN oms_live.oms_shipment_provider ship ON ship.id_shipment_provider = srpd.fk_shipment_provider
    LEFT JOIN oms_live.oms_warehouse AS wh ON wh.id_warehouse = ih.fk_current_warehouse
    LEFT JOIN oms_live.ims_supplier s ON sp.fk_supplier = s.id_supplier
    LEFT JOIN bob_live.supplier sup ON s.bob_id_supplier = sup.id_supplier
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

    WHERE
        ih.history_created_at >= @extractstart
            AND ih.history_created_at < @extractend
            AND i.fk_inventory_status = 18
            
    GROUP BY supplier , uid , erp_reference , po_type) result;	